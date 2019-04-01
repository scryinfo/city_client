---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 15:53
---小地图

MapCtrl = class('MapCtrl',UIPanel)
UIPanel:ResgisterOpen(MapCtrl)

MapCtrl.static.DetailSize = Vector2.New(500, 796)  --详细界面的大小
MapCtrl.static.CloseSearchBtnSize = Vector2.New(59, 277)  --关闭搜索的按钮的大小
MapCtrl.static.TypeMovePos = Vector2.New(0, -400)  --类型隐藏显示的X位置，x为显示位置，y为隐藏位置
MapCtrl.static.ShowTypeBtnMovePos = Vector2.New(17, -80)  --打开界面的按钮隐藏显示的X位置，x为显示位置，y为隐藏位置

EMapSearchType =
{
    Default = 0,
    Material = 1,
    Goods = 2,
    Deal = 3,
    Auction = 4,
    SelfBuilding = 5,
}

function MapCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function MapCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MapPanel.prefab"
end

function MapCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function MapCtrl:Awake(go)
    self.gameObject = go
    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(MapPanel.backBtn.gameObject, function ()
        PlayMusEff(1002)
        MapBubbleManager.setCameraToBackID()
        UIPanel.ClosePage()
    end)
    behaviour:AddClick(MapPanel.enlargeBtn.gameObject, function()
        PlayMusEff(1002)
        self:EnLargeMap()
    end)
    behaviour:AddClick(MapPanel.narrowBtn.gameObject, function()
        PlayMusEff(1002)
        self:NarrowMap()
    end)
    behaviour:AddClick(MapPanel.closeSearchBtn.gameObject, function()
        PlayMusEff(1002)
        self:closeSearch()
    end)
    behaviour:AddClick(MapPanel.openTypeBtnRect.gameObject, function()
        PlayMusEff(1002)
        self:openSearch()
    end)

    --读取配置表
    self.ScaleMin = TerrainConfig.MiniMap.ScaleMin
    self.ScaleMax = TerrainConfig.MiniMap.ScaleMax
    self.ScaleOffset = TerrainConfig.MiniMap.ScaleOffset
    self.my_Scale = TerrainConfig.MiniMap.ScaleStart
    self.ScaleDuringTime = TerrainConfig.MiniMap.ScaleDuringTime
    self.MapLeftPageDuringTime = TerrainConfig.MiniMap.MapLeftPageDuringTime  --打开关闭左侧搜索界面的时间

    self.criticalScaleValue = TerrainConfig.MiniMap.MapSize / 40  --AOI临界值
    self.itemWidth = MapPanel.mapRootRect.sizeDelta.x / TerrainConfig.MiniMap.MapSize   --一格Item的Rect大小
    MapBubbleManager.initMapSetting(self.itemWidth, self)  --传一个实例
    MapBubbleManager.createSystemItem()

    self:_initUIData()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getAllBuildingDetail","gs.BuildingSet",self.n_OnReceiveAllBuildingDetailInfo,self)
end

function MapCtrl:Active()
    UIPanel.Active(self)

    MapBubbleManager.setBackCollectionID()
end

function MapCtrl:Refresh()
    Event.AddListener("c_MapSearchCancelSelect", self.nonePageCancelSelect, self)
    Event.AddListener("c_MapSearchSelectType", self.refreshTypeItems, self)
    Event.AddListener("c_MapSearchSelectDetail", self.refreshDetailItem, self)
    Event.AddListener("c_MapCloseDetailPage", self.typeToggleSelectPage, self)
    Event.AddListener("c_MapReqMarketDetail", self._reqMarketDetail, self)
    Event.AddListener("c_MapOpenRightMatPage", self._openRightMatGoodPage, self)
    Event.AddListener("c_MapOpenRightGAucPage", self._openRightGAucPage, self)
    Event.AddListener("c_MapOpenRightGTransPage", self._openRightGTransPage, self)
    Event.AddListener("c_MapSelectSelfBuildingPage", self._openRightSelfBuildingPage, self)
    Event.AddListener("c_MapSelectSystemPage", self._openRightSystemPage, self)

    Event.AddListener("c_MapAllSearchToDetail", self._mapAllResearchToDetail, self)

    self:_reqAllBuildings()
end

function MapCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_MapSearchCancelSelect", self.nonePageCancelSelect, self)
    Event.RemoveListener("c_MapSearchSelectType", self.refreshTypeItems, self)
    Event.RemoveListener("c_MapSearchSelectDetail", self.refreshDetailItem, self)
    Event.RemoveListener("c_MapCloseDetailPage", self.typeToggleSelectPage, self)
    Event.RemoveListener("c_MapReqMarketDetail", self._reqMarketDetail, self)
    Event.RemoveListener("c_MapOpenRightMatPage", self._openRightMatGoodPage, self)
    Event.RemoveListener("c_MapOpenRightGAucPage", self._openRightGAucPage, self)
    Event.RemoveListener("c_MapOpenRightGTransPage", self._openRightGTransPage, self)
    Event.RemoveListener("c_MapSelectSelfBuildingPage", self._openRightSelfBuildingPage, self)
    Event.RemoveListener("c_MapSelectSystemPage", self._openRightSystemPage, self)

    Event.RemoveListener("c_MapAllSearchToDetail", self._mapAllResearchToDetail, self)

    self:_cleanDatas()
end
--
function MapCtrl:_cleanDatas()
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end

    self:_cancelDetailSelect()
    self:refreshTypeItems()
    self:closeSearch()
    self:_cleanChooseState()
    self:toggleDetailPage(false)

    --设置地图大小和Slider初始值
    MapPanel.scaleSlider.minValue = self.ScaleMin
    MapPanel.scaleSlider.maxValue = self.ScaleMax
    self.AOIState = 0  --设置为远镜头
    self.selectSearchType = EMapSearchType.Default

    self.my_Scale = TerrainConfig.MiniMap.ScaleStart  --重置镜头
    MapPanel.mapRootRect.transform.localScale = Vector3.one
    MapPanel.mapRootRect.anchoredPosition = Vector2.zero
    MapPanel.scaleSlider.value = self.my_Scale

    MapBubbleManager.closePanelFunc()

    --右侧的面板信息
    MapPanel.closeAllRightPage()
    if self.rightSearchItem ~= nil then
        self.rightSearchItem:close()
        self.rightSearchItem = nil
    end
end
--
function MapCtrl:n_OnReceiveAllBuildingDetailInfo(data)
    if data then
        DataManager.SetMyAllBuildingDetail(data)
    end
    MapBubbleManager.initItemData()
end
--
function MapCtrl:_reqAllBuildings()
    local msgId = pbl.enum("gscode.OpCode", "getAllBuildingDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--
function MapCtrl:_initUIData()
    --UI搜索界面
    self.typeTable = {}
    for i, value in ipairs(MapTypeConfig) do
        self:_createType(value)
    end

    --self:_cancelDetailSelect()
    --self:refreshTypeItems()
    --self:closeSearch()
    --self:toggleDetailPage(false)  --默认关闭搜索界面
    self:_cleanDatas()
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, 3, true)
end

function MapCtrl:_itemTimer()
    --Event.Brocast("c_SearchEndLoading")
    self:toggleLoadingState(true)
    self.m_Timer:Stop()
end

function MapCtrl:_createType(data)
    local go = UnityEngine.GameObject.Instantiate(MapPanel.mapSearchTypeItem)
    go.transform:SetParent(MapPanel.typeItemParent.transform)
    go.transform.localScale = Vector3.one

    local typeId = data.typeId
    if typeId == EMapSearchType.Material then
        self.typeTable[typeId] = MapSearchTypePageItem:new(data, function ()
            self:matSelect()
        end , go)
    elseif typeId == EMapSearchType.Goods then
        self.typeTable[typeId] = MapSearchTypePageItem:new(data, function ()
            self:goodsSelect()
        end , go)
    elseif typeId == EMapSearchType.Deal then
        self.typeTable[typeId] = MapSearchTypeNonePageItem:new(data, function ()
            self:dealSelect()
        end , go)
    elseif typeId == EMapSearchType.Auction then
        self.typeTable[typeId] = MapSearchTypeNonePageItem:new(data, function ()
            self:auctionSelect()
        end , go)
    end
end

--loading
function MapCtrl:toggleLoadingState(isShow)
    if self.typeTable ~= nil then
        for i, value in pairs(self.typeTable) do
            value:toggleLoadingState(isShow)
        end
    end
end
--打开原料详情界面
function MapCtrl:matSelect()
    self:toggleDetailPage(true)
    self:_openPageItems(EMapSearchType.Material)
end
--打开商品详情界面
function MapCtrl:goodsSelect()
    self:toggleDetailPage(true)
    self:_openPageItems(EMapSearchType.Goods)
end
--选中土地交易
function MapCtrl:dealSelect()
    self:toggleLoadingState(false)
    self.m_Timer:Reset(slot(self._itemTimer, self), 1, 3, true)
    self.m_Timer:Start()

    if self.selectDetailItem ~= nil then
        self.selectDetailItem:resetState()
        self.selectDetailItem = nil  --另一种选项清空
    end
    self.selectSearchType = EMapSearchType.Deal

    MapBubbleManager.cleanAllBubbleItems()
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapModel.m_ReqGroundTransSummary()
    end
end
--选中拍卖
function MapCtrl:auctionSelect()
    self:toggleLoadingState(false)
    self.m_Timer:Reset(slot(self._itemTimer, self), 1, 3, true)
    self.m_Timer:Start()

    if self.selectDetailItem ~= nil then
        self.selectDetailItem:resetState()
        self.selectDetailItem = nil  --另一种选项清空
    end
    self.selectSearchType = EMapSearchType.Auction

    MapBubbleManager.cleanAllBubbleItems()
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapBubbleManager.createSummaryItems(nil, self.selectSearchType)
    end
end

---
--nonePage类型，取消选中状态
function MapCtrl:nonePageCancelSelect(selectId)
    if self._cancelTypeSelect == selectId then
        self:refreshTypeItems()
        self.selectId = nil
        self.selectSearchType = EMapSearchType.Default
        MapBubbleManager.cleanAllBubbleItems()
    end
end
--
function MapCtrl:typeToggleSelectPage(selectId, open)
    if self.selectId == selectId then
        self:toggleDetailPage(open)
    end
end
--每次切换选择的类型的时候都应调用该方法
function MapCtrl:refreshTypeItems(selectId)
    if selectId == nil then
        for i, value in pairs(self.typeTable) do
            value:refreshShow(false)
        end
    else
        for i, value in pairs(self.typeTable) do
            if value:getTypeId() == selectId then
                value:refreshShow(true)
                self.selectId = selectId
                self:toggleDetailPage(false)
            else
                value:refreshShow(false)
            end
        end
    end
end
--清除所有选中状态
function MapCtrl:_cleanChooseState()
    for i, value in pairs(self.typeTable) do
        value:resetState()
    end
end
--
function MapCtrl:refreshDetailItem(item)
    if item == nil then
        if self.selectDetailItem ~= nil then
            self.selectDetailItem:resetState()
            self.selectDetailItem = nil
        end
        Event.Brocast("c_ChooseTypeDetail")
    else
        if self.selectDetailItem ~= nil then
            self.selectDetailItem:resetState()
        end

        self.selectSearchType = EMapSearchType.Default  --选中的搜索type
        self.selectDetailItem = item
        local typeId = item:getTypeId()
        local tempItem = self.typeTable[typeId]
        if tempItem ~= nil then
            Event.Brocast("c_ChooseTypeDetail", typeId, item:getNameStr())
            --向服务器发送请求  商品 原料
            if self:_getIsDetailFunc() == true then
                self:_judgeDetail()
            else
                MapModel.m_ReqQueryMarketSummary(item:getItemId())
            end

            --隐藏右边UI
            tempItem:_clickFunc()
            --cd
            self:toggleLoadingState(false)
            self.m_Timer:Reset(slot(self._itemTimer, self), 1, 3, true)
            self.m_Timer:Start()
        else
            ct.log("")
        end
    end
end

--取消选中
function MapCtrl:_cancelDetailSelect()
    if self.selectDetailItem ~= nil then
        self.selectDetailItem:resetState()
        self.selectDetailItem = nil
    end
    self.selectId = nil
end

---

--关闭左侧类型界面
function MapCtrl:closeSearch()
    if math.abs(math.abs(MapPanel.typeOpenRect.anchoredPosition.x) - math.abs(MapCtrl.static.TypeMovePos.x)) < 0.001 then  --如果为打开状态，则关闭
        MapPanel.typeOpenRect:DOAnchorPosX(MapCtrl.static.TypeMovePos.y, self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
        MapPanel.openTypeBtnRect:DOAnchorPosX(MapCtrl.static.ShowTypeBtnMovePos.x, self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
    end
end
--打开左侧类型界面
function MapCtrl:openSearch()
    if math.abs(math.abs(MapPanel.typeOpenRect.anchoredPosition.x) - math.abs(MapCtrl.static.TypeMovePos.y)) < 0.001 then  --如果为关闭状态，则打开
        MapPanel.typeOpenRect:DOAnchorPosX(MapCtrl.static.TypeMovePos.x, self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
        MapPanel.openTypeBtnRect:DOAnchorPosX(MapCtrl.static.ShowTypeBtnMovePos.y, self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
    end
end
--关闭详情界面
function MapCtrl:toggleDetailPage(open)
    if open == true then
        if MapPanel.detailPagesRect.sizeDelta.x == 0 then
            --MapPanel.detailPagesRect:DoSizeDelta(MapCtrl.static.DetailSize, self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
            --MapPanel.closeSearchBtn:DoSizeDelta(Vector2.New(0, MapCtrl.static.CloseSearchBtnSize.y), self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
            MapPanel.detailPagesRect.sizeDelta = MapCtrl.static.DetailSize
            MapPanel.closeSearchBtn.sizeDelta = Vector2.New(0, MapCtrl.static.CloseSearchBtnSize.y)
        end
        return
    end
    if MapPanel.detailPagesRect.sizeDelta.x ~= 0 then
        --MapPanel.detailPagesRect:DoSizeDelta(Vector2.New(0, MapCtrl.static.DetailSize.y), self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
        --MapPanel.closeSearchBtn:DoSizeDelta(MapCtrl.static.CloseSearchBtnSize, self.MapLeftPageDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
        MapPanel.detailPagesRect.sizeDelta = Vector2.New(0, MapCtrl.static.DetailSize.y)
        MapPanel.closeSearchBtn.sizeDelta = MapCtrl.static.CloseSearchBtnSize
    end
end
--生成右侧详情界面
function MapCtrl:_openPageItems(type)
    if self.detailPageItems == nil then
        self.detailPageItems = {}
    end
    if self.detailPageItems[type] == nil then
        local go
        if type == EMapSearchType.Material then
            go = MapPanel.matPageToggleGroup.gameObject
        elseif type == EMapSearchType.Goods then
            go = MapPanel.goodsPageToggleGroup.gameObject
        end

        go.transform.localScale = Vector3.one
        self.detailPageItems[type] = MapDetailPageItem:new(type, go)
    end
    for i, value in pairs(self.detailPageItems) do
        if value:getTypeId() == type then
            value:toggleState(true)
        else
            value:toggleState(false)
        end
    end
end

--搜索完成后，选择具体的item，打开右侧原料商品界面
function MapCtrl:_openRightMatGoodPage(item)
    if item ~= nil then
        if self.rightSearchItem ~= nil then
            self.rightSearchItem:toggleShowDetailImg(false)  --将之前的选中取消
        end
        self.rightSearchItem = item
        self.rightSearchItem:toggleShowDetailImg(true)
        MapPanel.rightMatGoodPageItem:refreshData(item.data)
    end
end
--打开拍卖
function MapCtrl:_openRightGAucPage(item)
    if item ~= nil then
        --if self.rightSearchItem ~= nil then
        --    self.rightSearchItem:toggleShowDetailImg(false)  --将之前的选中取消
        --end
        --self.rightSearchItem = item
        --self.rightSearchItem:toggleShowDetailImg(true)
        MapPanel.closeAllRightPage()
        MapPanel.rightGroundAucPageItem:refreshData(item.data)
    end
end
--打开土地交易
function MapCtrl:_openRightGTransPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapPanel.rightGroundTransPageItem:refreshData(item.data)
    end
end
--打开自己的建筑
function MapCtrl:_openRightSelfBuildingPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapPanel.selfBuildingPageItem:refreshData(item.data)
    end
end
--打开系统建筑
function MapCtrl:_openRightSystemPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapPanel.systemBuildingPageItem:refreshData(item.data)
    end
end
--
function MapCtrl:getNonePageSearchType()
    return self.selectSearchType
end

---服务器请求
function MapCtrl:_reqMarketDetail(blockId)
    --AOI范围外
    if self.my_Scale < self.criticalScaleValue then
        return
    end
    --目前只有原料商品需要走协议，其他信息暂时都能通过AOI拿到
    if self.selectDetailItem ~= nil and self.selectDetailItem:getItemId() ~= nil then
        local centerId = TerrainManager.BlockIDTurnCollectionGridIndex(blockId)
        MapModel.m_ReqMarketDetail(centerId, self.selectDetailItem:getItemId())
    end
end

---服务器回调

--原料商品搜索摘要
function MapCtrl:_receiveMarketSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Material)
end
--土地交易搜索摘要
function MapCtrl:_receiveGroundTransSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Deal)
end
--原料商品搜索详情
function MapCtrl:_receiveMarketDetail(data)
    if data ~= nil then
        MapBubbleManager.cleanAllBubbleItems()
        if self.selectDetailItem == nil or self.selectDetailItem:getItemId() ~= data.itemId then
            MapBubbleManager.createDetailItems(data, true)
            return
        end
        if self.selectDetailItem ~= nil and self.selectDetailItem:getItemId() == data.itemId then
            MapBubbleManager.createDetailItems(data, false)
        end
    end
end

---

---地图缩放部分
--放大地图[over]
function MapCtrl:EnLargeMap()
    if self.my_Scale ~= nil and self.ScaleOffset ~= nil and self.ScaleMax ~= nil then
        local scale_value = self.my_Scale + self.ScaleOffset
        if scale_value >= self.ScaleMax then
            scale_value = self.ScaleMax
        end
        if self.my_Scale ~= scale_value then
            if scale_value >= self.criticalScaleValue then
                --到达AOI范围
                if self.AOIState == 0 then
                    self.AOIState = 1
                    MapBubbleManager.toggleShowDetailBuilding(true)
                    MapBubbleManager.showSummaryOrDetail(true)
                    self:_judgeDetail()
                end
            end

            self:CenterOffset(self.my_Scale,scale_value)
            self.my_Scale = scale_value
            self:RefreshMiniMapScale()
        end
    end
end

--缩小地图[over]
function MapCtrl:NarrowMap()
    if self.my_Scale ~= nil and self.ScaleOffset ~= nil and self.ScaleMin ~= nil then
        local scale_value = self.my_Scale - self.ScaleOffset
        if scale_value <= self.ScaleMin then
            scale_value = self.ScaleMin
        end
        if self.my_Scale ~= scale_value then
            if scale_value < self.criticalScaleValue then
                --离开AOI范围
                if self.AOIState == 1 then
                    self.AOIState = 0
                    MapBubbleManager.toggleShowDetailBuilding(false)
                    MapBubbleManager.showSummaryOrDetail(false)
                    self:_judgeSummary()
                end
            end

            self:CenterOffset(self.my_Scale,scale_value)
            self.my_Scale = scale_value
            self:RefreshMiniMapScale()
        end
    end
end

--做中心偏移
function MapCtrl:CenterOffset(beginScale,EndScale)
    local TargetAnchoredPosition = MapPanel.mapRootRect.anchoredPosition * (EndScale/ beginScale)
    local NowRangeSize = (EndScale - 1) * MapPanel.mapRootRect.sizeDelta.x / 2
    if TargetAnchoredPosition.x > NowRangeSize then
        TargetAnchoredPosition.x = NowRangeSize
    elseif  TargetAnchoredPosition.x < -NowRangeSize then
        TargetAnchoredPosition.x = -NowRangeSize
    end
    if TargetAnchoredPosition.y > NowRangeSize then
        TargetAnchoredPosition.y = NowRangeSize
    elseif  TargetAnchoredPosition.y < -NowRangeSize then
        TargetAnchoredPosition.y = -NowRangeSize
    end
    MapPanel.mapRootRect:DOAnchorPos(TargetAnchoredPosition , self.ScaleDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
end

--刷新当前地图的大小
function MapCtrl:RefreshMiniMapScale()
    --刷新Slider
    MapPanel.scaleSlider.value = self.my_Scale
    --
    Event.Brocast("c_MapBubbleScale", self.my_Scale)
    --TODO:做中心偏移
    MapPanel.mapRootRect:DOScale(Vector3.New(self.my_Scale,self.my_Scale,self.my_Scale),self.ScaleDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
end

--获取屏幕中心基于小地图的世界坐标
function MapCtrl:getScreenCenterMapPos()
    local x = (MapPanel.mapRootRect.sizeDelta.x / 2 - MapPanel.mapRootRect.anchoredPosition.x / self.my_Scale) * (TerrainConfig.MiniMap.MapSize / MapPanel.mapRootRect.sizeDelta.x)
    local y = (MapPanel.mapRootRect.sizeDelta.y / 2 + MapPanel.mapRootRect.anchoredPosition.y / self.my_Scale) * (TerrainConfig.MiniMap.MapSize / MapPanel.mapRootRect.sizeDelta.y)
    return Vector3.New(y, 0, x)
end
--获取当前缩放值
function MapCtrl.getCurrentScaleValue()
    return MapPanel.scaleSlider.value
end
--
function MapCtrl:_mapAOIMove()
    if self.my_Scale < self.criticalScaleValue then
        return
    end
    local pos = self:getScreenCenterMapPos()
    --Event.Brocast("CameraMoveTo", pos)
    CameraMove.MoveCameraToPos(pos)
end
--放大过程中判断是否需要请求详情
function MapCtrl:_judgeDetail()
    if self.selectDetailItem ~= nil and self.selectDetailItem:getItemId() ~= nil then
        local collectionId = TerrainManager.GetCameraCollectionID()
        local blockId = TerrainManager.CollectionIDTurnBlockID(collectionId)
        local blockCollectionId = TerrainManager.BlockIDTurnCollectionGridIndex(blockId)
        MapModel.m_ReqMarketDetail(blockCollectionId, self.selectDetailItem:getItemId())
        return
    end
    if self.selectSearchType ~= nil and self.selectSearchType ~= EMapSearchType.Default then
        ct.log("")
        --显示拍卖/土地交易详情
        if self.selectSearchType == EMapSearchType.Auction then
            MapBubbleManager.createGAucDetailItems()
        elseif self.selectSearchType == EMapSearchType.Deal then
            MapBubbleManager.createGroundTransDetailItems()
        end
    end
end
--缩小过程中判断是否需要请求缩略
function MapCtrl:_judgeSummary()
    if self.selectDetailItem ~= nil and self.selectDetailItem:getItemId() ~= nil then
        MapModel.m_ReqQueryMarketSummary(self.selectDetailItem:getItemId())
        return
    end
    if self.selectSearchType ~= nil and self.selectSearchType ~= EMapSearchType.Default then
        ct.log("")
        --显示拍卖/土地交易缩略
        if self.selectSearchType == EMapSearchType.Auction then
            MapBubbleManager.createSummaryItems(nil, self.selectSearchType)
        elseif self.selectSearchType == EMapSearchType.Deal then
            MapModel.m_ReqGroundTransSummary()
        end
    end
end
--判断是否是
function MapCtrl:_getIsDetailFunc()
    if self.my_Scale ~= nil and self.my_Scale > self.criticalScaleValue then
        return true
    end
    return false
end
--点击缩略图缩放到详情大小
function MapCtrl:_mapAllResearchToDetail(summaryPos, scenePos)
    local targetScale = TerrainConfig.MiniMap.DetailScale
    if self.AOIState == 0 then
        self.AOIState = 1
        MapBubbleManager.toggleShowDetailBuilding(true)
        MapBubbleManager.showSummaryOrDetail(true)
        self:_judgeDetail()
    end

    self:_posOffset(self.my_Scale, targetScale, summaryPos)
    self.my_Scale = targetScale

    MapBubbleManager.toggleShowDetailBuilding(true)
    self:RefreshMiniMapScale()
    --移动相机
    --local pos = scenePos + Vector3.New(10, 0, 10)
    CameraMove.MoveCameraToPos(scenePos)
end
--左上角的item的偏移
function MapCtrl:_posOffset(beginScale, EndScale, summaryPos)
    --因为item的锚点在左上，所以做个偏移
    local itemPos = Vector2.New(summaryPos.x - MapPanel.mapRootRect.sizeDelta.x / 2, summaryPos.y + MapPanel.mapRootRect.sizeDelta.x / 2)
    local TargetAnchoredPosition = (MapPanel.mapRootRect.anchoredPosition - itemPos) * (EndScale/ beginScale)
    local NowRangeSize = (EndScale - 1) * MapPanel.mapRootRect.sizeDelta.x / 2
    if TargetAnchoredPosition.x > NowRangeSize then
        TargetAnchoredPosition.x = NowRangeSize
    elseif  TargetAnchoredPosition.x < -NowRangeSize then
        TargetAnchoredPosition.x = -NowRangeSize
    end
    if TargetAnchoredPosition.y > NowRangeSize then
        TargetAnchoredPosition.y = NowRangeSize
    elseif  TargetAnchoredPosition.y < -NowRangeSize then
        TargetAnchoredPosition.y = -NowRangeSize
    end
    MapPanel.mapRootRect:DOAnchorPos(TargetAnchoredPosition , self.ScaleDuringTime):SetEase(DG.Tweening.Ease.OutCubic)
end
---