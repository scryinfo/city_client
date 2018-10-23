require('Controller/WarehouseCtrl')


WarehouseRateItem = class('WarehouseRateItem');
WarehouseRateItem.static.TOTAL_H = 475  --整个Item的高度
WarehouseRateItem.static.CONTENT_H = 410  --显示内容的高度
WarehouseRateItem.static.TOP_H = 100  --top条的高度

--初始化方法   数据需要接受服务器发送的数据
function WarehouseRateItem:initialize(warehouseData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.warehouseData = warehouseData;
    self.toggleData = toggleData  --位于toggle的第三个  左边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
    self.openBtn = self.viewRect.transform:Find("topRoot/close/openBtn");  --打开按钮
    self.toDoBtn = self.viewRect.transform:Find("topRoot/open/toDoBtn");  --跳转页面
    self.sizeSlider = self.viewRect.transform:Find("contentRoot/sizeSlider"):GetComponent("Slider");  -- slider

    mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end);

    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        UIPage:ShowPage(WarehouseCtrl)
    end);

    --Event.AddListener("c_onOccupancyValueChange", function (data)  --响应数据改变
    --    --    mgrTable:houseOccDataUpdate(data)
    --    --end);
    Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self);
end

--获取是第几个点击了
function WarehouseRateItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function WarehouseRateItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, WarehouseRateItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - WarehouseRateItem.static.TOTAL_H);
end

--关闭
function WarehouseRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - WarehouseRateItem.static.TOP_H);
end

--刷新数据
function WarehouseRateItem:updateInfo(data)
    --[[    self.occupancyData = data

    if not self.viewRect.gameObject.activeSelf then
        return
    end]]
end