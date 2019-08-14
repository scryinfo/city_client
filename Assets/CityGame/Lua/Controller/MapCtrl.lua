---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 15:53
--- 小地图
-- 搜索有几个标识：
-- self.uiSelectId：UI上选中的type 只做点击显示作用，不能用于判断当前确认的搜索类型
-- self.selectSearchType：选中的直接搜索的typeId
-- self.selectDetailItem：选中的二级菜单的详情Id，与 selectSearchType 不能同时存在，提供两个接口：getTypeId & getItemId
--

MapCtrl = class('MapCtrl',UIPanel)
UIPanel:ResgisterOpen(MapCtrl)

MapCtrl.static.reqServerTime = 10  --刷新时间
MapCtrl.static.DetailSize = Vector2.New(500, 876)  --详细界面的大小
MapCtrl.static.CloseSearchBtnSize = Vector2.New(59, 277)  --关闭搜索的按钮的大小
MapCtrl.static.TypeMovePos = Vector2.New(0, -400)  --类型隐藏显示的X位置，x为显示位置，y为隐藏位置
MapCtrl.static.ShowTypeBtnMovePos = Vector2.New(17, -80)  --打开界面的按钮隐藏显示的X位置，x为显示位置，y为隐藏位置
--小地图左侧搜索的类型
EMapSearchType =
{
    Default = 0,
    Material = 1,
    Goods = 2,
    Builds = 3,
    Technology = 4,
    Promotion = 5,
    Deal = 6,
    Auction = 7,
    Signing = 8,
    SelfBuilding = 9,
}
--科研推广查询的不同类型
EMapPromotionType =
{
    Food = 1,
    Clothes = 2,
    SuperMarket = 3,
    House = 4,
}
EMapTechnologyType =
{
    Default = 0,
    TechNewItem = 1,
    TechEva = 2,
}
EBuildingIconPath =
{
    House = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    MaterialFactory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-Material.png",
    Municipal = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    ProcessingFactory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-Fatory.png",
    Laboratory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    RetailShop = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-SuperMarket.png",
    TalentCenter = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
}
--需要与配置表的Id一一对应

function MapCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end
--
function MapCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MapPanel.prefab"
end
--
function MapCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end
--
function MapCtrl:Awake(go)
    --UpdateBeat:Add(self._update, self)

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
--
function MapCtrl:Active()
    UIPanel.Active(self)
    UpdateBeat:Add(self._update, self)

    MapBubbleManager.setBackCollectionID()
end
--
function MapCtrl:Refresh()
    Event.AddListener("c_MapSearchCancelSelect", self.nonePageCancelSelect, self)  --无二级菜单的类型，取消选中自己
    Event.AddListener("c_MapSearchSelectType", self.refreshTypeItems, self)  --选中左侧类型
    Event.AddListener("c_MapSearchSelectDetail", self.refreshDetailItem, self)  --二级菜单选中具体的item
    Event.AddListener("c_MapCloseDetailPage", self.typeToggleSelectPage, self)  --选中带二级菜单之后关闭右侧详情界面
    Event.AddListener("c_MapReqMarketDetail", self._reqMoveDetail, self)  --拖动小地图时，判断需要请求什么数据
    Event.AddListener("c_MapOpenRightOthersPage", self._openRightOthersPage, self)  --点击搜索出的结果，显示右侧界面
    Event.AddListener("c_MapOpenRightGAucPage", self._openRightGAucPage, self)
    Event.AddListener("c_MapOpenRightGTransPage", self._openRightGTransPage, self)
    Event.AddListener("c_MapSelectSelfBuildingPage", self._openRightSelfBuildingPage, self)
    Event.AddListener("c_MapSelectSystemPage", self._openRightSystemPage, self)

    Event.AddListener("c_MapAllSearchToDetail", self._mapAllResearchToDetail, self)  --点击缩略，放大到AOI范围

    self:_language()
    self:_reqAllBuildings()
end
--
function MapCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_MapSearchCancelSelect", self.nonePageCancelSelect, self)
    Event.RemoveListener("c_MapSearchSelectType", self.refreshTypeItems, self)
    Event.RemoveListener("c_MapSearchSelectDetail", self.refreshDetailItem, self)
    Event.RemoveListener("c_MapCloseDetailPage", self.typeToggleSelectPage, self)
    Event.RemoveListener("c_MapReqMarketDetail", self._reqMoveDetail, self)
    Event.RemoveListener("c_MapOpenRightOthersPage", self._openRightOthersPage, self)
    Event.RemoveListener("c_MapOpenRightGAucPage", self._openRightGAucPage, self)
    Event.RemoveListener("c_MapOpenRightGTransPage", self._openRightGTransPage, self)
    Event.RemoveListener("c_MapSelectSelfBuildingPage", self._openRightSelfBuildingPage, self)
    Event.RemoveListener("c_MapSelectSystemPage", self._openRightSystemPage, self)

    Event.RemoveListener("c_MapAllSearchToDetail", self._mapAllResearchToDetail, self)

    UpdateBeat:Remove(self._update, self)
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
    self.selectSearchType = EMapSearchType.Default  --选中的无二级菜单的搜索类型

    self.my_Scale = TerrainConfig.MiniMap.ScaleStart  --重置镜头
    MapPanel.mapRootRect.transform.localScale = Vector3.one
    MapPanel.mapRootRect.anchoredPosition = Vector2.zero
    MapPanel.scaleSlider.value = self.my_Scale

    MapBubbleManager.closePanelFunc()

    --右侧的面板信息
    MapPanel.closeAllRightPage()
    if MapCtrl.selectItem ~= nil then
        --MapCtrl.selectItem:close()
        MapCtrl.selectItem = nil
    end
    --if self.rightSearchItem ~= nil then
    --    self.rightSearchItem:close()
    --    self.rightSearchItem = nil
    --end
end
--
function MapCtrl:_update()
    if MapPanel.loadingImgTran.localScale == Vector3.one then
        MapPanel.loadingImgTran:Rotate(Vector3.back * 200 * UnityEngine.Time.deltaTime)
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

    self:_cleanDatas()
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, 3, true)
    MapPanel.loadingImgTran.transform.localScale = Vector3.zero
    MapPanel.loadingImgTran.transform.localEulerAngles = Vector3.zero
end
--
function MapCtrl:_language()
    --page 多语言
    if self.detailPageItems ~= nil then
        for i, item in pairs(self.detailPageItems) do
            item:resetState()
        end
    end
    --左侧搜索type 多语言
    if self.typeTable ~= nil then
        for i, item in pairs(self.typeTable) do
            item:_language()
        end
    end
    MapBubbleManager.systemInit()
end
--
function MapCtrl:_itemTimer()
    Event.Brocast("c_SearchEndLoading")
    MapPanel.loadingImgTran.transform.localScale = Vector3.zero
    MapPanel.loadingImgTran.transform.localEulerAngles = Vector3.zero  --初始化角度
    self:toggleLoadingState(true)
    self.m_Timer:Stop()
end
--
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
    elseif typeId == EMapSearchType.Builds then
        self.typeTable[typeId] = MapSearchTypePageItem:new(data, function ()
            self:buildsSelect()
        end , go)
    elseif typeId == EMapSearchType.Deal then
        self.typeTable[typeId] = MapSearchTypeNonePageItem:new(data, function ()
            self:dealSelect()
        end , go)
    elseif typeId == EMapSearchType.Auction then
        self.typeTable[typeId] = MapSearchTypeNonePageItem:new(data, function ()
            self:auctionSelect()
        end , go)
    elseif typeId == EMapSearchType.Warehouse then
        self.typeTable[typeId] = MapSearchTypeNonePageItem:new(data, function ()
            self:warehouseSelect()
        end , go)
    elseif typeId == EMapSearchType.Promotion then
        self.typeTable[typeId] = MapSearchTypePageItem:new(data, function ()
            self:promotionSelect()
        end , go)
    elseif typeId == EMapSearchType.Technology then
        self.typeTable[typeId] = MapSearchTypePageItem:new(data, function ()
            self:technologySelect()
        end , go)
    elseif typeId == EMapSearchType.Signing then
        self.typeTable[typeId] = MapSearchTypeNonePageItem:new(data, function ()
            self:signSelect()
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
--打开建筑搜索界面
function MapCtrl:buildsSelect()
    self:toggleDetailPage(true)
    self:_openPageItems(EMapSearchType.Builds)
end
--推广二级菜单
function MapCtrl:promotionSelect()
    self:toggleDetailPage(true)
    self:_openPageItems(EMapSearchType.Promotion)
end
--科研二级菜单
function MapCtrl:technologySelect()
    self:toggleDetailPage(true)
    self:_openPageItems(EMapSearchType.Technology)
end
--无二级菜单的类型搜索
function MapCtrl:_noPageTypeSelect()
    MapPanel.closeAllRightPage()
    self:toggleLoadingState(false)
    self.m_Timer:Reset(slot(self._itemTimer, self), 1, 3, true)
    self.m_Timer:Start()
    MapPanel.loadingImgTran.transform.localScale = Vector3.one  --开始转圈

    if self.selectDetailItem ~= nil then
        self.selectDetailItem:resetState()
        self.selectDetailItem = nil  --另一种选项清空
    end
end
--选中土地交易
function MapCtrl:dealSelect()
    self:_noPageTypeSelect()
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
    self:_noPageTypeSelect()
    self.selectSearchType = EMapSearchType.Auction

    MapBubbleManager.cleanAllBubbleItems()
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapBubbleManager.createSummaryItems(nil, self.selectSearchType)
    end
end
--仓库
function MapCtrl:warehouseSelect()
    self:_noPageTypeSelect()
    self.selectSearchType = EMapSearchType.Warehouse

    MapBubbleManager.cleanAllBubbleItems()
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapModel.m_ReqWarehouseSummary()
    end
end
--签约
function MapCtrl:signSelect()
    self:_noPageTypeSelect()
    self.selectSearchType = EMapSearchType.Signing

    MapBubbleManager.cleanAllBubbleItems()
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapModel.m_ReqSigningSummary()
    end
end

---
--nonePage类型，取消选中状态
function MapCtrl:nonePageCancelSelect(selectId)
    if self.selectSearchType == selectId then
        self:refreshTypeItems()
        self.uiSelectId = nil
        self.selectSearchType = EMapSearchType.Default
        self.selectDetailItem = nil

        MapPanel.closeAllRightPage()
        MapBubbleManager.cleanAllBubbleItems()
    end
end
--
function MapCtrl:typeToggleSelectPage(selectId, open)
    if self.uiSelectId == selectId then
        self:toggleDetailPage(open)
    end
end
--选中的左侧类型的UI显示
function MapCtrl:refreshTypeItems(selectId)
    if selectId == nil then
        for i, value in pairs(self.typeTable) do
            value:refreshShow(false)
            value:chooseTypeDetail()  --无二级菜单的type取消选中
        end
    else
        for i, value in pairs(self.typeTable) do
            if value:getTypeId() == selectId then
                value:refreshShow(true)
                self.uiSelectId = selectId
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
    MapPanel.closeAllRightPage()

    --点两次取消，检验是否已经选中
    if item == self.selectDetailItem then
        self.selectDetailItem:resetState()
        self.selectDetailItem = nil
        MapBubbleManager.cleanAllBubbleItems()
        Event.Brocast("c_ChooseTypeDetail")
    else
        --如果之前没有搜索过，记录搜索item
        if self.selectDetailItem ~= nil then
            self.selectDetailItem:resetState()
        end

        --self.selectSearchType = EMapSearchType.Default  --选中的搜索type
        --self.selectDetailItem = item
        local typeId = item:getTypeId()
        local tempItem = self.typeTable[typeId]
        if tempItem ~= nil then
            --设置一级菜单的显示
            Event.Brocast("c_ChooseTypeDetail", typeId, item:getNameStr())
            --判断是否是科研推广
            if typeId == EMapSearchType.Promotion or typeId == EMapSearchType.Technology then
                --向服务器请求数据
                self:checkPromotionTechReq(typeId, item)
            elseif typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
                self.selectSearchType = EMapSearchType.Default  --选中的搜索type
                self.selectDetailItem = item
                self:matGoodsReq(item:getItemId())
            elseif typeId == EMapSearchType.Builds then
                self.selectSearchType = EMapSearchType.Default  --选中的搜索type
                self.selectDetailItem = item
                self:buildsReq(item:getItemId())
            end

            tempItem:_clickFunc()  --隐藏右边UI
            --以下为转圈圈CD，固定转3秒
            self:toggleLoadingState(false)  --cd
            self.m_Timer:Reset(slot(self._itemTimer, self), 1, 3, true)
            self.m_Timer:Start()
            MapPanel.loadingImgTran.transform.localScale = Vector3.one  --开始转圈
        end
    end
end
--
function MapCtrl:buildsReq(typeId)
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapModel.m_ReqBuildsSummary(typeId)
    end
end
--
function MapCtrl:matGoodsReq(typeId)
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        MapModel.m_ReqQueryMarketSummary(typeId)
    end
end
--如果是推广和科研，则需要做特殊处理
--不是选中detail之后就向服务器发消息
--验证是否需要向服务器发送请求
function MapCtrl:checkPromotionTechReq(typeId, item)
    local typeData = self:_getSearchData()
    if typeId == typeData.typeId then
        if self.searchTime == nil then
            self.searchTime = {}
        end
        if self.searchTime[typeId] == nil then
            self:promotionTechReq(typeId, item)
            return
        end
        --10秒之内只能搜索同级菜单一次，计时器
        local time = self.searchTime[typeId]
        local remainTime = TimeSynchronized.GetTheCurrentTime() - time - MapCtrl.static.reqServerTime
        if remainTime >= 0 then
            self:promotionTechReq(typeId, item)
        end
    else
        self:promotionTechReq(typeId, item)
    end
end
--推广研究
function MapCtrl:promotionTechReq(typeId, item)
    if self.searchTime == nil then
        self.searchTime = {}
    end
    self.searchTime[typeId] = TimeSynchronized.GetTheCurrentTime()
    --一级菜单类型搜索
    self.selectSearchType = EMapSearchType.Default  --选中的搜索type
    --二级菜单类型搜索
    self.selectDetailItem = item
    if self:_getIsDetailFunc() == true then
        self:_judgeDetail()
    else
        self:switchNoDataReq(typeId)
    end
end
--
function MapCtrl:switchNoDataReq(typeId)
    if typeId == EMapSearchType.Technology then
        MapModel.m_ReqLabSummary()
    elseif typeId == EMapSearchType.Promotion then
        MapModel.m_ReqPromotionSummary()
    end
end

--取消选中
function MapCtrl:_cancelDetailSelect()
    if self.selectDetailItem ~= nil then
        self.selectDetailItem:resetState()
        self.selectDetailItem = nil
    end
    self.uiSelectId = nil
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
        local go = MapPanel.getPageByType(type)
        MapPanel.showDetailPageByType(type)

        self.detailPageItems[type] = self:getDetailPageByType(type, go)
    end
    for i, value in pairs(self.detailPageItems) do
        if value:getTypeId() == type then
            value:toggleState(true)
        else
            value:toggleState(false)
        end
    end
end
--
function MapCtrl:getDetailPageByType(typeId, go)
    local item
    if typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
        item = MapMatDetailPageItem:new(typeId, go)
    elseif typeId == EMapSearchType.Builds then
        item = MapBuildsPageItem:new(typeId, go)
    elseif typeId == EMapSearchType.Technology then
        item = MapTechnologyPageItem:new(typeId, go)
    elseif typeId == EMapSearchType.Promotion then
        item = MapPromotionPageItem:new(typeId, go)
    end
    return item
end
--所有有点击效果的选中item
function MapCtrl.selectCenterItem(item)
    if MapCtrl.selectItem == nil then
        MapCtrl.selectItem = item
        item:toggleShowSelect(true)
    else
        if MapCtrl.selectItem ~= item then
            MapCtrl.selectItem:toggleShowSelect(false)
            MapCtrl.selectItem = item
            item:toggleShowSelect(true)
        end
    end
end
--搜索完成后，选择具体的item，打开右侧原料商品界面
--item 是MapSearchResultItem
function MapCtrl:_openRightOthersPage(item)
    if item ~= nil then
        --if self.rightSearchItem ~= nil then
        --    self.rightSearchItem:toggleShowDetailImg(false)  --将之前的选中取消
        --end
        --self.rightSearchItem = item
        --self.rightSearchItem:toggleShowDetailImg(true)

        --判断是直接搜索还是展开二级界面的搜索
        local typeData = self:_getSearchData()
        MapPanel.closeAllRightPage()

        MapCtrl._toggleShowRightRoot(true)
        MapPanel.rightOtherBuildingPageItem:refreshData(item.data, typeData)
    end
end
--获取当前搜索的类型
function MapCtrl:_getSearchData()
    local typeData = {}
    --selectDetailItem是拥有二级菜单的类型详情item
    --typeId为一级菜单类型，detailId为二级菜单类型
    --eg：研究-->eva
    if self.selectDetailItem ~= nil then
        typeData.detailId = self.selectDetailItem:getItemId()
        typeData.typeId = self.selectDetailItem:getTypeId()
    else
        if self.selectSearchType ~= nil then
            typeData.typeId = self.selectSearchType
        end
    end
    return typeData
end
--打开拍卖
function MapCtrl:_openRightGAucPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapCtrl._toggleShowRightRoot(true)
        MapPanel.rightGroundAucPageItem:refreshData(item.data)
    end
end
--打开土地交易
function MapCtrl:_openRightGTransPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapCtrl._toggleShowRightRoot(true)
        MapPanel.rightGroundTransPageItem:refreshData(item.data)
    end
end
--打开自己的建筑
function MapCtrl:_openRightSelfBuildingPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapCtrl._toggleShowRightRoot(true)
        MapPanel.selfBuildingPageItem:refreshData(item.data)
    end
end
--打开系统建筑
function MapCtrl:_openRightSystemPage(item)
    if item ~= nil then
        MapPanel.closeAllRightPage()
        MapCtrl._toggleShowRightRoot(true)
        MapPanel.systemBuildingPageItem:refreshData(item.data)
    end
end
--
function MapCtrl:getNonePageSearchType()
    return self.selectSearchType
end

---服务器请求
function MapCtrl:_reqMoveDetail(blockId)
    --AOI范围外
    if self.my_Scale < self.criticalScaleValue then
        return
    end

    if self.selectDetailItem ~= nil then
        local blockCollectionId = TerrainManager.BlockIDTurnCollectionGridIndex(blockId)
        local typeId = self.selectDetailItem:getTypeId()

        if typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
            MapModel.m_ReqMarketDetail(blockCollectionId, self.selectDetailItem:getItemId())
        elseif typeId == EMapSearchType.Promotion then
            MapModel.m_ReqPromotionDetail(blockCollectionId)
        elseif typeId == EMapSearchType.Technology then
            MapModel.m_ReqTechnologyDetail(blockCollectionId)
        elseif typeId == EMapSearchType.Builds then
            MapModel.m_ReqBuildsDetail(blockCollectionId, self.selectDetailItem:getItemId())
        end
        return
    end
    --直接搜索 做对应处理
    if self.selectSearchType ~= nil and self.selectSearchType ~= EMapSearchType.Default then
        if self.selectSearchType == EMapSearchType.Warehouse then
            MapModel.m_ReqWarehouseDetail(MapCtrl.getNowCenterCollectionId())
        elseif self.selectSearchType == EMapSearchType.Signing then
            MapModel.m_ReqSigningDetail(MapCtrl.getNowCenterCollectionId())
        end
    end
end

---服务器回调
--建筑类型搜索摘要
function MapCtrl:_receiveBuildsSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Builds)
end
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
--科研
function MapCtrl:_receiveLabSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Technology)
end
--推广
function MapCtrl:_receivePromotionSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Promotion)
end
--签约
function MapCtrl:_receiveSigningSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Signing)
end
--仓库
function MapCtrl:_receiveWarehouseSummary(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createSummaryItems(data, EMapSearchType.Warehouse)
end
--建筑类型详情
function MapCtrl:_receiveBuildsDetail(data)
    if data ~= nil then
        MapBubbleManager.cleanAllBubbleItems()
        MapBubbleManager.createDetailItems(data, EMapSearchType.Builds,true)
    end
end
--原料商品搜索详情
function MapCtrl:_receiveMarketDetail(data)
    if data ~= nil then
        MapBubbleManager.cleanAllBubbleItems()
        MapBubbleManager.createDetailItems(data, EMapSearchType.Material,true)

        --local mapCtrlIns = MapBubbleManager.getMapCtrlIns()
        --if mapCtrlIns.selectDetailItem == nil or mapCtrlIns.selectDetailItem:getItemId() ~= data.itemId then
        --    MapBubbleManager.cleanAllBubbleItems()
        --    MapBubbleManager.createDetailItems(data, EMapSearchType.Material,true)
        --    return
        --end
        --if mapCtrlIns.selectDetailItem ~= nil and mapCtrlIns.selectDetailItem:getItemId() == data.itemId then
        --    MapBubbleManager.createDetailItems(data, EMapSearchType.Material,false)
        --end
    end
end

--签约详情
function MapCtrl:_receiveSignDetail(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createDetailItems(data, EMapSearchType.Signing, true)
end
--科研
function MapCtrl:_receiveTechDetail(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createDetailItems(data, EMapSearchType.Technology, true)
end
--仓库
function MapCtrl:_receiveWarehouseDetail(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createDetailItems(data, EMapSearchType.Warehouse, true)
end
--推广
function MapCtrl:_receivePromotionDetail(data)
    MapBubbleManager.cleanAllBubbleItems()
    MapBubbleManager.createDetailItems(data, EMapSearchType.Promotion, true)
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
function MapCtrl._toggleShowRightRoot(open)
    if open == true then
        MapPanel.rightOtherPageRoot.localScale = Vector3.one
    else
        MapPanel.rightOtherPageRoot.localScale = Vector3.zero
    end
end
--
function MapCtrl:_mapAOIMove()
    --一旦移动，则关闭右侧搜索结果
    MapCtrl._toggleShowRightRoot(false)
    if MapCtrl.selectItem ~= nil then
        MapCtrl.selectItem:toggleShowSelect(false)
        MapCtrl.selectItem = nil
    end

    if self.my_Scale < self.criticalScaleValue then
        return
    end
    local pos = self:getScreenCenterMapPos()
    --Event.Brocast("CameraMoveTo", pos)
    CameraMove.MoveCameraToPos(pos)
end
--放大过程中判断是否需要请求详情
function MapCtrl:_judgeDetail()
    --判断选中的是直接搜索还是二级搜索
    if self.selectDetailItem ~= nil then
        local blockCollectionId = MapCtrl.getNowCenterCollectionId()
        local typeId = self.selectDetailItem:getTypeId()

        if typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
            MapModel.m_ReqMarketDetail(blockCollectionId, self.selectDetailItem:getItemId())
        elseif typeId == EMapSearchType.Promotion then
            MapModel.m_ReqPromotionDetail(blockCollectionId)
        elseif typeId == EMapSearchType.Technology then
            MapModel.m_ReqTechnologyDetail(blockCollectionId)
        elseif typeId == EMapSearchType.Builds then
            MapModel.m_ReqBuildsDetail(blockCollectionId, self.selectDetailItem:getItemId())
        end
        return
    end

    --直接搜索 做对应处理
    if self.selectSearchType ~= nil and self.selectSearchType ~= EMapSearchType.Default then
        if self.selectSearchType == EMapSearchType.Auction then
            MapBubbleManager.createGAucDetailItems()
        elseif self.selectSearchType == EMapSearchType.Deal then
            MapBubbleManager.createGroundTransDetailItems()
        elseif self.selectSearchType == EMapSearchType.Warehouse then
            MapModel.m_ReqWarehouseDetail(MapCtrl.getNowCenterCollectionId())
        elseif self.selectSearchType == EMapSearchType.Signing then
            MapModel.m_ReqSigningDetail(MapCtrl.getNowCenterCollectionId())
        end
    end
end
--缩小过程中判断是否需要请求缩略
function MapCtrl:_judgeSummary()
    if self.selectDetailItem ~= nil then
        local typeId = self.selectDetailItem:getTypeId()

        if typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
            MapModel.m_ReqQueryMarketSummary(self.selectDetailItem:getItemId())
        elseif typeId == EMapSearchType.Promotion then
            MapModel.m_ReqPromotionSummary()
        elseif typeId == EMapSearchType.Technology then
            MapModel.m_ReqLabSummary()
        elseif typeId == EMapSearchType.Builds then
            MapModel.m_ReqBuildsSummary(self.selectDetailItem:getItemId())
        end
        return
    end

    if self.selectSearchType ~= nil and self.selectSearchType ~= EMapSearchType.Default then
        if self.selectSearchType == EMapSearchType.Auction then
            MapBubbleManager.createSummaryItems(nil, self.selectSearchType)
        elseif self.selectSearchType == EMapSearchType.Deal then
            MapModel.m_ReqGroundTransSummary()
        elseif self.selectSearchType == EMapSearchType.Warehouse then
            MapModel.m_ReqWarehouseSummary()
        elseif self.selectSearchType == EMapSearchType.Signing then
            MapModel.m_ReqSigningSummary()
        end
    end
end
--获取当前位置所在的地块Id
function MapCtrl.getNowCenterCollectionId()
    local collectionId = TerrainManager.GetCameraCollectionID()
    local blockId = TerrainManager.CollectionIDTurnBlockID(collectionId)
    local blockCollectionId = TerrainManager.BlockIDTurnCollectionGridIndex(blockId)
    return blockCollectionId
end
--判断小地图是否是详情搜索状态
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