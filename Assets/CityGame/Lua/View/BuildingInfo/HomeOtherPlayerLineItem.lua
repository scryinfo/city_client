HomeOtherPlayerLineItem = class('HomeOtherPlayerShelfItem')
HomeOtherPlayerLineItem.static.TOTAL_H = 455  --The height of the entire Item
HomeOtherPlayerLineItem.static.CONTENT_H = 412  --Display height
HomeOtherPlayerLineItem.static.TOP_H = 100  --the height of the top bar

--Initialization method The data needs to accept the data sent by the server
function HomeOtherPlayerLineItem:initialize(OtherPlayerShelfData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = OtherPlayerShelfData;
    self.toggleData = toggleData;    --On the first right of toggle

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --Content Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --Open state
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --Disabled
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --Open button
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");  --Jump to page
    self.content = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content");

    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject,function()
        clickOpenFunc(mgrTable,self.toggleData)
    end);

    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
    end);
end

--Get is the first click
function HomeOtherPlayerLineItem:getToggleIndex()
    return self.toggleData.index;
end

--turn on
function HomeOtherPlayerLineItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, HomeOtherPlayerLineItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --Open display
    --self.viewRect.anchoredPosition = targetMovePos  --Move to target location
    return Vector2.New(targetMovePos.x, targetMovePos.y - HomeOtherPlayerLineItem.static.TOTAL_H);
end

--shut down
function HomeOtherPlayerLineItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - HomeOtherPlayerLineItem.static.TOP_H);
end