require('Controller/AdjustProductionLineCtrl')

HomeProductionLineItem = class('HomeProductionLineItem')
HomeProductionLineItem.static.TOTAL_H = 775  --整个Item的高度
HomeProductionLineItem.static.CONTENT_H = 732  --显示内容的高度
HomeProductionLineItem.static.TOP_H = 100  --top条的高度
HomeProductionLineItem.static.Line_PATH = "View/GoodsItem/LineItem"

--初始化方法  数据需要接受服务器发送的数据
function HomeProductionLineItem:initialize(productionData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = productionData;
    self.toggleData = toggleData;    --位于toggle的第一个   右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");    --关闭状态
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");   --打开按钮
    self.content = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content")

    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        if self.productionData.buildingType == BuildingType.MaterialFactory then
            ct.OpenCtrl("AdjustProductionLineCtrl",self.productionData)
        elseif self.productionData.buildingType == BuildingType.ProcessingFactory then
            ct.OpenCtrl("AdjustProductionLineCtrl",self.productionData)
        end
    end);

    self:initializeInfo(self.productionData.line);

    --Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self);
    Event.AddListener("productionRefreshInfo",self.productionRefreshInfo,self)
    Event.AddListener("delLineRefreshInfo",self.delLineRefreshInfo,self)
end

--获取是第几次点击了
function HomeProductionLineItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function HomeProductionLineItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, HomeProductionLineItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --打开显示内容
    --self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置
    return Vector2.New(targetMovePos.x, targetMovePos.y - HomeProductionLineItem.static.TOTAL_H);
end

--关闭
function HomeProductionLineItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - HomeProductionLineItem.static.TOP_H);
end
--初始化数据
function HomeProductionLineItem:initializeInfo(productionLineData)
    if not productionLineData then
        return;
    end
    for i,v in pairs(productionLineData) do
        local homePageType = ct.homePage.productionLine
        local prefab = creatGoods(HomeProductionLineItem.static.Line_PATH,self.content)
        local SmallLineRateItem = HomePageDisplay:new(homePageType,v,prefab)
        if not self.SmallLineRateItemTab then
            self.SmallLineRateItemTab = {}
        end
        self.SmallLineRateItemTab[i] = SmallLineRateItem
    end
    HomeProductionLineItem.productionTab = self.SmallLineRateItemTab
end
--生产线添加时添加
function HomeProductionLineItem:productionRefreshInfo(data)
    if not data then
        return;
    end
    local homePageType = ct.homePage.productionLine
    local prefab = creatGoods(HomeProductionLineItem.static.Line_PATH,self.content)
    local SmallLineRateItem = HomePageDisplay:new(homePageType,data.line,prefab)
    if not self.SmallLineRateItemTab then
        self.SmallLineRateItemTab = {}
        self.SmallLineRateItemTab[1] = SmallLineRateItem
    else
        self.SmallLineRateItemTab[#self.SmallLineRateItemTab] = SmallLineRateItem
    end
    HomeProductionLineItem.productionTab = self.SmallLineRateItemTab
end
--删除生产线时添加
function HomeProductionLineItem:delLineRefreshInfo(data)
    if not data then
        return
    end
    for i,v in pairs(self.SmallLineRateItemTab) do
        if v.id == data.lineId then
            v:closeEvent()
            destroy(v.prefab.gameObject)
        end
    end
end
--刷新数据
function HomeProductionLineItem:updateInfo(data)
    self.productionData = data
    self.productionData.line = data.line
    self:initializeInfo()
end