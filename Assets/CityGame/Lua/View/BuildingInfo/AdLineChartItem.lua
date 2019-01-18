

AdLineChartItem = class('AdLineChartItem')
AdLineChartItem.static.TOTAL_H = 443  --整个Item的高度
AdLineChartItem.static.CONTENT_H = 400  --显示内容的高度
AdLineChartItem.static.TOP_H = 100  --top条的高度

--初始化方法 --数据需要接受服务器发送的数据
function AdLineChartItem:initialize(materialData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect
    self.materialData = materialData
    self.toggleData = toggleData  --位于toggle的第1个，左边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --打开按钮
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");  --跳转页面


    self.goLineChart = self.viewRect.transform:Find("contentRoot/bgLine/LineChartPanel/Image/Scroll View/Viewport/Content/GameObject"):GetComponent("LineChart");
    local verts={
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
    local verts1={
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

    self.goLineChart :InjectDatas(verts,Color.New(1,1,1,1))
    self.goLineChart:InjectDatas(verts1,Color.New(0,1,0,1))

    --self.bgLine = self.viewRect.transform:Find("contentRoot/bgLine");  --折线图位置

    --UIPage:ShowPage(LineChartCtrl)

    ct.log("cycle_w5","------- Occ实例化"..self.openBtns.gameObject:GetInstanceID())

    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end);                                                              --这个方法是mgr传来的，每次点击都会调一次

    --Event.AddListener("c_onOccupancyValueChange", function (data)  --响应数据改变
    --    --    mgrTable:houseOccDataUpdate(data)
    --    --end);

    Event.AddListener("c_onOccupancyValueChange", self.updateInfo, self);
end

--获取是第几个点击了
function AdLineChartItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function AdLineChartItem:openToggleItem(targetMovePos)

    self.buildingInfoToggleState = BuildingInfoToggleState.Open

    self.openStateTran.localScale = Vector3.one
    self.closeStateTran.localScale = Vector3.zero

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, AdLineChartItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --打开显示内容
    --self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置

    return Vector2.New(targetMovePos.x, targetMovePos.y - AdLineChartItem.static.TOTAL_H)
end

--关闭
function AdLineChartItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close

    self.openStateTran.localScale = Vector3.zero
    self.closeStateTran.localScale = Vector3.one

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, 0), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic)

    return Vector2.New(targetMovePos.x, targetMovePos.y - AdLineChartItem.static.TOP_H)
end

--刷新数据
function AdLineChartItem:updateInfo(data)
--[[    self.occupancyData = data

    if not self.viewRect.gameObject.activeSelf then
        return
    end]]

end

function AdLineChartItem:destory()
    destroy(self.viewRect.gameObject)
end