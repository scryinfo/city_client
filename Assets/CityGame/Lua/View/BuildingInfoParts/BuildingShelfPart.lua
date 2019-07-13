---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/12 11:34
---建筑主界面货架
BuildingShelfPart = class("BuildingShelfPart",BasePart)

function BuildingShelfPart:PrefabName()
    return "BuildingShelfPart"
end

function BuildingShelfPart:GetDetailClass()
    return BuildingShelfDetailPart
end
function BuildingShelfPart:ShowDetail(data)
    BasePart.ShowDetail(self,data)
    Event.AddListener("refreshShelfPartCount",self.refreshShelfPartCount,self)
end
function BuildingShelfPart:_InitTransform()
    self:_getComponent(self.transform)
end

function BuildingShelfPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
function BuildingShelfPart:HideDetail()
    BasePart.HideDetail(self)
    Event.RemoveListener("refreshShelfPartCount",self.refreshShelfPartCount,self)
end
function BuildingShelfPart:_ResetTransform()
    self:_language()
end

function BuildingShelfPart:_getComponent(transform)
    if transform == nil then
        return
    end
    self.topText = transform:Find("Top/topText"):GetComponent("Text")
    self.salaryPercentText = transform:Find("Top/salaryPercentText"):GetComponent("Text")
    self.unselectTitleText = transform:Find("UnselectBtn/titleText"):GetComponent("Text")
    self.selectTitleText = transform:Find("SelectBtn/titleText"):GetComponent("Text")
end

function BuildingShelfPart:_InitChildClick(mainPanelLuaBehaviour)

end

function BuildingShelfPart:_initFunc()
    self:_language()
    self:_initializeShelfCount()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--重置组件
function BuildingShelfPart:_language()
    --暂时  需要修改多语言
    self.topText.text = GetLanguage(25010009)
    self.unselectTitleText.text = GetLanguage(25010008)
    self.selectTitleText.text = GetLanguage(25010008)
end
--初始化货架数量
function BuildingShelfPart:_initializeShelfCount()
    self.count = self:_getShelfCount(self.m_data.shelf)
    self.salaryPercentText.text = self.count
end
--计算货架数量
function BuildingShelfPart:_getShelfCount(dataTable)
    local shelfNowCount = 0
    if not dataTable.good then
        shelfNowCount = 0
    else
        for key,value in pairs(dataTable.good) do
            shelfNowCount = shelfNowCount + value.n
        end
    end
    return shelfNowCount
end
--上架成功或购买成功后刷新数量
function BuildingShelfPart:refreshShelfPartCount(data)
    self.count = self.count + data.item.n
    self.salaryPercentText.text = self.count
end



































--ShelfRateItem = class('ShelfRateItem')
--ShelfRateItem.static.TOTAL_H = 775  --整个Item的高度
--ShelfRateItem.static.CONTENT_H = 732  --显示内容的高度
--ShelfRateItem.static.TOP_H = 100  --top条的高度
--ShelfRateItem.SmallShelfRateItemTab = {}
----ShelfRateItem.static.Goods_PATH = "View/GoodsItem/SmallShelfRateItem"
----主页信息货架，生产线，只作显示
--ct.homePage =
--{
--    shelf  = 0,  --货架
--    productionLine = 1,  --生产线
--}
----初始化方法  数据需要接受服务器发送的数据
--function ShelfRateItem:initialize(shelfData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
--    self.viewRect = viewRect;
--    self.shelfData = shelfData;
--    self.toggleData = toggleData;   --位于toggle的第四个   左边
--
--    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
--    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
--    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
--    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --打开按钮
--    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");  --跳转页面
--    self.content = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content");
--    self.openName = self.viewRect.transform:Find("topRoot/open/nameText"):GetComponent("Text");
--    self.closeName = self.viewRect.transform:Find("topRoot/close/nameText"):GetComponent("Text");
--    --预制
--    self.ShelfRateItemPrefab = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content/SmallShelfRateItem").gameObject
--
--    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
--        PlayMusEff(1002)
--        if not self.viewRect.gameObject.activeSelf then
--            return
--        end
--        if self.shelfData.info.state == "OPERATE" then
--            if self.shelfData.buildingType == BuildingType.MaterialFactory then
--                ct.OpenCtrl("ShelfCtrl",self.shelfData)
--            elseif self.shelfData.buildingType == BuildingType.ProcessingFactory then
--                ct.OpenCtrl("ProcessShelfCtrl",self.shelfData)
--            elseif self.shelfData.buildingType == BuildingType.RetailShop then
--                ct.OpenCtrl("RetailShelfCtrl",self.shelfData)
--            end
--        else
--            Event.Brocast("SmallPop",GetLanguage(35040013),300)
--            return
--        end
--    end);
--    self.openName.text = GetLanguage(25020004)
--    self.closeName.text = GetLanguage(25020004)
--
--    self:initializeInfo(self.shelfData.shelf.good)
--end
--
----获取是第几个点击了
--function ShelfRateItem:getToggleIndex()
--    return self.toggleData.index;
--end
--
----打开
--function ShelfRateItem:openToggleItem(targetMovePos)
--    self.buildingInfoToggleState = BuildingInfoToggleState.Open;
--
--    self.openStateTran.localScale = Vector3.one;
--    self.closeStateTran.localScale = Vector3.zero;
--
--    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
--    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, ShelfRateItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
--
--    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --打开显示内容
--    --self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置
--    return Vector2.New(targetMovePos.x,targetMovePos.y - ShelfRateItem.static.TOTAL_H - 5);
--end
--
----关闭
--function ShelfRateItem:closeToggleItem(targetMovePos)
--    self.buildingInfoToggleState = BuildingInfoToggleState.Close;
--
--    self.openStateTran.localScale = Vector3.zero;
--    self.closeStateTran.localScale = Vector3.one;
--
--    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
--    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
--
--    return Vector2.New(targetMovePos.x,targetMovePos.y - ShelfRateItem.static.TOP_H - 5);
--end
----初始化数据
--function ShelfRateItem:initializeInfo(data)
--    if not data then
--        return;
--    end
--    for key,value in pairs(data) do
--        local homePageType = ct.homePage.shelf
--        local prefab = self:loadingItemPrefab(self.ShelfRateItemPrefab,self.content)
--        local SmallShelfRateItem = HomePageDisplay:new(homePageType,value,prefab)
--        --ShelfRateItem.SmallShelfRateItemTab[key] = SmallShelfRateItem
--        table.insert(ShelfRateItem.SmallShelfRateItemTab,SmallShelfRateItem)
--    end
--end
----刷新数据
--function ShelfRateItem:updateInfo(data)
--    self.shelfData = data
--    self.shelfData.shelf.good = data.shelf.good
--    self:initializeInfo(self.shelfData.shelf.good)
--end
----加载实例化Prefab
--function ShelfRateItem:loadingItemPrefab(itemPrefab,itemRoot)
--    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
--    local objRect = obj.transform:GetComponent("RectTransform");
--    obj.transform:SetParent(itemRoot.transform)
--    objRect.transform.localScale = Vector3.one;
--    obj:SetActive(true)
--    return obj
--end