require('Controller/AdjustProductionLineCtrl')

HomeProductionLineItem = class('HomeProductionLineItem')
HomeProductionLineItem.static.TOTAL_H = 308  --整个Item的高度
HomeProductionLineItem.static.CONTENT_H = 223  --显示内容的高度
HomeProductionLineItem.static.TOP_H = 100  --top条的高度
HomeProductionLineItem.static.Line_PATH = "View/GoodsItem/LineItem"
HomeProductionLineItem.storeData = {}

--初始化方法  数据需要接受服务器发送的数据
function HomeProductionLineItem:initialize(productionData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = productionData;
    HomeProductionLineItem.storeData = productionData.store.inHand
    self.toggleData = toggleData;    --位于toggle的第4个   左边

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
        ct.OpenCtrl("AddProductionLineCtrl",self.productionData)
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
    self.openName.text = GetLanguage(25020005)
    self.closeName.text = GetLanguage(25020005)
    if not productionLineData then
        self.add:SetActive(true)
        return;
    end
    local homePageType = ct.homePage.productionLine
    for key,value in pairs(productionLineData) do
        local prefab = self.loadingItemPrefab(self.LineItem,self.content)
        local lineItem = HomePageDisplay:new(homePageType,value,prefab)
        if not self.lineItemTable then
            self.lineItemTable = {}
        end
        table.insert(self.lineItemTable,lineItem)
    end
end
--刷新数据
function HomeProductionLineItem:updateInfo(data)
    self.productionData = data
    self.productionData.line = data.line
    self:initializeInfo(self.productionData.line)
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
