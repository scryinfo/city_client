
HomeOtherPlayerShelfItem = class('HomeOtherPlayerShelfItem')
HomeOtherPlayerShelfItem.static.TOTAL_H = 775  --The height of the entire Item
HomeOtherPlayerShelfItem.static.CONTENT_H = 732  --Display height
HomeOtherPlayerShelfItem.static.TOP_H = 100  --the height of the top bar
HomeOtherPlayerShelfItem.SmallShelfRateItemTab = {}
--Initialization method The data needs to accept the data sent by the server
function HomeOtherPlayerShelfItem:initialize(OtherPlayerShelfData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = OtherPlayerShelfData;
    self.toggleData = toggleData;    --On the first right of toggle

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --Content Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --Open state
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");    --Disabled
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");   --Open button
    self.content = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content")
    self.openName = self.viewRect.transform:Find("topRoot/open/nameText"):GetComponent("Text");
    self.closeName = self.viewRect.transform:Find("topRoot/close/nameText"):GetComponent("Text");
    --Prefab
    self.ShelfRateItemPrefab = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content/SmallShelfRateItem").gameObject

    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        PlayMusEff(1002)
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        if self.productionData.info.state == "OPERATE" then
            if self.productionData.buildingType == BuildingType.RetailShop then
                ct.OpenCtrl("RetailShelfCtrl",self.productionData)
            elseif self.productionData.buildingType == BuildingType.ProcessingFactory then
                ct.OpenCtrl("ProcessShelfCtrl",self.productionData)
            elseif self.productionData.buildingType == BuildingType.MaterialFactory then
                ct.OpenCtrl("ShelfCtrl",self.productionData)
            end
        else
            Event.Brocast("SmallPop",GetLanguage(35040013),300)
            return
        end
    end);
    self.openName.text = GetLanguage(25020004)
    self.closeName.text = GetLanguage(25020004)
    self:initializeInfo(self.productionData.shelf.good)
end

--Initialization data
function HomeOtherPlayerShelfItem:initializeInfo(data)
    if not data then
        return;
    end
    for key,value in pairs(data) do
        local homePageType = ct.homePage.shelf
        local prefab = self:loadingItemPrefab(self.ShelfRateItemPrefab,self.content)
        local SmallShelfRateItem = HomePageDisplay:new(homePageType,value,prefab)
        --HomeOtherPlayerShelfItem.SmallShelfRateItemTab[key] = SmallShelfRateItem
        table.insert(HomeOtherPlayerShelfItem.SmallShelfRateItemTab,SmallShelfRateItem)
    end
end

--Get is the first click
function HomeOtherPlayerShelfItem:getToggleIndex()
    return self.toggleData.index;
end

--open
function HomeOtherPlayerShelfItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, HomeOtherPlayerShelfItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --Open display
    --self.viewRect.anchoredPosition = targetMovePos  --Move to target location
    return Vector2.New(targetMovePos.x, targetMovePos.y - HomeOtherPlayerShelfItem.static.TOTAL_H);
end

--shut down
function HomeOtherPlayerShelfItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - HomeOtherPlayerShelfItem.static.TOP_H);
end
--Refresh data
function HomeOtherPlayerShelfItem:updateInfo(data)
    self.productionData = data
    self.productionData.shelf.good = data.shelf.good
    self:initializeInfo(self.productionData.shelf.good)
end
--Load instantiated Prefab
function HomeOtherPlayerShelfItem:loadingItemPrefab(itemPrefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
    local objRect = obj.transform:GetComponent("RectTransform");
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one;
    obj:SetActive(true)
    return obj
end