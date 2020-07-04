

LineChartRateItem = class('LineChartRateItem')
LineChartRateItem.static.TOTAL_H = 443  --The height of the entire Item
LineChartRateItem.static.CONTENT_H = 400  --The height of the entire Item
LineChartRateItem.static.TOP_H = 100  --the height of the top bar

--Initialization method --The data needs to accept the data sent by the server
function LineChartRateItem:initialize(materialData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect
    self.materialData = materialData
    self.toggleData = toggleData  --1st toggle, left

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --Content Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --Open state
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --Disabled
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --Open button

    --language
    self.titleText01 = self.viewRect.transform:Find("topRoot/open/nameText"):GetComponent("Text")
    self.titleText02 = self.viewRect.transform:Find("topRoot/close/nameText"):GetComponent("Text")
    self.stayTunedText03 = self.viewRect.transform:Find("contentRoot/bgLine/Image/Text"):GetComponent("Text")
    self:_language()

    self.goLineChart = self.viewRect.transform:Find("contentRoot/bgLine/LineChartPanel/Image/Scroll View/Viewport/Content/GameObject"):GetComponent("LineChart");
    local verts={
        Vector2.New(0.0, 0.4),
        Vector2.New(0.1, 0.3),
        Vector2.New(0.2, 0.2),
        Vector2.New(0.3, 0.1),
        Vector2.New(0.4, 0.2),
        Vector2.New(0.5, 0.3),
        Vector2.New(0.6, 0.4),
        Vector2.New(0.7, 0.5),
        Vector2.New(0.8, 0.6),
        Vector2.New(0.9, 0.7),
        Vector2.New(1.0, 0.8)
    }
    local verts1={
        Vector2.New(0.0, 0.1),
        Vector2.New(0.1, 0.6),
        Vector2.New(0.2, 0.1),
        Vector2.New(0.3, 0.3),
        Vector2.New(0.4, 0.2),
        Vector2.New(0.5, 0.4),
        Vector2.New(0.6, 0.6),
        Vector2.New(0.7, 0.8),
        Vector2.New(0.8, 0.4),
        Vector2.New(0.9, 0.2),
        Vector2.New(1.0, 0.3)
    }

    self.goLineChart :InjectDatas(verts,Color.New(1,1,1,1))
    self.goLineChart:InjectDatas(verts1,Color.New(0,1,0,1))

    --self.bgLine = self.viewRect.transform:Find("contentRoot/bgLine");  --Line chart location

    --UIPage:ShowPage(LineChartCtrl)

    ct.log("cycle_w5","------- Occ实例化"..self.openBtns.gameObject:GetInstanceID())

    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end);                                                              --This method comes from mgr, and it will be adjusted once every click

    --Event.AddListener("c_onOccupancyValueChange", function (data)  --Respond to data changes
    --    --    mgrTable:houseOccDataUpdate(data)
    --    --end);

    Event.AddListener("c_onOccupancyValueChange", self.updateInfo, self);
end

--Get the number of clicks
function LineChartRateItem:getToggleIndex()
    return self.toggleData.index;
end

--turn on
function LineChartRateItem:openToggleItem(targetMovePos)

    self.buildingInfoToggleState = BuildingInfoToggleState.Open

    self.openStateTran.localScale = Vector3.one
    self.closeStateTran.localScale = Vector3.zero

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, LineChartRateItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --Open display
    --self.viewRect.anchoredPosition = targetMovePos  --Move to target location

    return Vector2.New(targetMovePos.x, targetMovePos.y - LineChartRateItem.static.TOTAL_H-5)
end

--shut down
function LineChartRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.openStateTran.localScale = Vector3.zero
    self.closeStateTran.localScale = Vector3.one

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - LineChartRateItem.static.TOP_H-5)
end

--Refresh data
function LineChartRateItem:updateInfo(data)
--[[    self.occupancyData = data

    if not self.viewRect.gameObject.activeSelf then
        return
    end]]

end

function LineChartRateItem:destory()
    destroy(self.viewRect.gameObject)
end
--multi-language
function LineChartRateItem:_language()
    self.titleText01.text = GetLanguage(25010007)
    self.titleText02.text = GetLanguage(25010007)
    self.stayTunedText03.text = GetLanguage(25010008)
end