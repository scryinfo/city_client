require('Controller/AdjustProductionLineCtrl')
local class = require 'Framework/class'

HomeProductionLineItem = class('HomeProductionLineItem')
HomeProductionLineItem.static.TOTAL_H = 775  --整个Item的高度
HomeProductionLineItem.static.CONTENT_H = 732  --显示内容的高度
HomeProductionLineItem.static.TOP_H = 100  --top条的高度

--初始化方法  数据需要接受服务器发送的数据
function HomeProductionLineItem:initialize(productionData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = productionData;
    self.toggleData = toggleData;    --位于toggle的第一个   右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");    --关闭状态
    self.toDoBtn = self.viewRect.transform:Find("topRoot/open/toDoBtn");   --打开按钮

--[[    mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject,function()
        clickOpenFunc(mgrTable,self.toggleData)
    end);                                                       ]]

    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        UIPage:ShowPage(AdjustProductionLineCtrl)
    end);

    --Event.AddListener("c_onOccupancyValueChange", function (data)  --响应数据改变
    --    --    mgrTable:houseOccDataUpdate(data)
    --    --end);

    Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self);
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
-- 刷新数据
function HomeProductionLineItem:updateInfo(data)

--[[    self.occupancyData = data
    if not self.viewRect.gameObject.activeSelf then
        return
    end]]
end