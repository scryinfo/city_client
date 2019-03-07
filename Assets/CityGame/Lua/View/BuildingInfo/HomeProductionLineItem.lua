require('Controller/AdjustProductionLineCtrl')

HomeProductionLineItem = class('HomeProductionLineItem')
HomeProductionLineItem.static.TOTAL_H = 308  --整个Item的高度
HomeProductionLineItem.static.CONTENT_H = 223  --显示内容的高度
HomeProductionLineItem.static.TOP_H = 100  --top条的高度
HomeProductionLineItem.static.Line_PATH = "View/GoodsItem/LineItem"
HomeProductionLineItem.storeData = {}
HomeProductionLineItem.lineItemTable = {}
--初始化方法  数据需要接受服务器发送的数据
function HomeProductionLineItem:initialize(productionData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = productionData;
    self.buildingId = productionData.insId
    HomeProductionLineItem.storeData = productionData.store.inHand
    self.toggleData = toggleData;    --位于toggle的第4个   左边
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");    --关闭状态
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --打开按钮
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");   --打开按钮
    self.content = self.viewRect.transform:Find("contentRoot/Scroll View/Viewport/Content")
    self.openName = self.viewRect.transform:Find("topRoot/open/nameText"):GetComponent("Text");
    self.closeName = self.viewRect.transform:Find("topRoot/close/nameText"):GetComponent("Text");
    self.addBtn = self.viewRect.transform:Find("contentRoot/Scroll View/Viewport/Content/Add/bgBtn")
    --预制
    self.LineItem = self.viewRect.transform:Find("contentRoot/Scroll View/Viewport/Content/LineItem").gameObject
    self.add = self.viewRect.transform:Find("contentRoot/Scroll View/Viewport/Content/Add").gameObject

    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject, function()
        PlayMusEff(1002)
        clickOpenFunc(mgrTable, self.toggleData)
    end);
    mainPanelLuaBehaviour:AddClick(self.addBtn.gameObject,function()
        PlayMusEff(1002)
        if self.productionData.info.state == "OPERATE" then
            ct.OpenCtrl("AddProductionLineCtrl",self.productionData)
        else
            Event.Brocast("SmallPop",GetLanguage(35040013),300)
            return
        end
    end);
    self:initializeInfo(self.productionData.line);

    Event.AddListener("productionRefreshInfo",self.productionRefreshInfo,self)
    Event.AddListener("delLineRefreshInfo",self.delLineRefreshInfo,self)
    Event.AddListener("DeleteLineRefresh",self.DeleteLineRefresh,self)
    Event.AddListener("DeleteLine",self.DeleteLine,self)
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
    self.openName.text = GetLanguage(25020005)
    self.closeName.text = GetLanguage(25020005)
    local aaa = getFormatUnixTime(TimeSynchronized.GetTheCurrentServerTime() / 1000)
    if not productionLineData then
        self.add:SetActive(true)
        return;
    end
    self.add:SetActive(false)
    --local homePageType = ct.homePage.productionLine
    for key,value in pairs(productionLineData) do
        local prefab = self.loadingItemPrefab(self.LineItem,self.content)
        local lineItem = LineItem:new(value,prefab,self.mainPanelLuaBehaviour,self.buildingId)
        table.insert(HomeProductionLineItem.lineItemTable,lineItem)
    end
end
--刷新数据
function HomeProductionLineItem:updateInfo(data)
    self.productionData = data
    self.buildingId = data.insId
    self.productionData.line = data.line
    self:initializeInfo(self.productionData.line)
    HomeProductionLineItem.storeData = data.store.inHand
end
--获取当前建筑某种商品的库存数量
function HomeProductionLineItem.GetInventoryNum(itemId)
    if not HomeProductionLineItem.storeData then
        local number = 0
        return number
    end
    for key,value in pairs(HomeProductionLineItem.storeData) do
        if value.key.id == itemId then
            return value.n
        end
    end
    local number = 0
    return number
end
--加载实例化Prefab
function HomeProductionLineItem.loadingItemPrefab(itemPrefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
    local objRect = obj.transform:GetComponent("RectTransform");
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one;
    --obj.transform:SetSiblingIndex(1)
    obj:SetActive(true)
    return obj
end
--删除主页面生产线
function HomeProductionLineItem:DeleteLine(ins)
    local data = {}
    data.titleInfo = GetLanguage(28010004)
    data.contentInfo = GetLanguage(28010005)
    --data.tipInfo = GetLanguage(28010006)
    data.btnCallBack = function()
        Event.Brocast("m_ReqMaterialDeleteLine",ins.buildingId,ins.lineId)
    end
    ct.OpenCtrl('ErrorBtnDialogPageCtrl',data)
end
--删除主页面生产线回调
function HomeProductionLineItem:DeleteLineRefresh(dataInfo)
    for key,value in pairs(HomeProductionLineItem.lineItemTable) do
        if dataInfo.lineId == value.lineId then
            value:closeEvent()
            destroy(value.prefab.gameObject)
            HomeProductionLineItem.lineItemTable[key] = nil
        end
    end
    self.add:SetActive(true)
    Event.Brocast("SmallPop",GetLanguage(28010006),300)
end
