---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/30/030 11:59
---


local class = require 'Framework/class'

TicketItem = class('TicketItem');
TicketItem.static.TOTAL_H = 193 --整个Item的高度
TicketItem.static.CONTENT_H = 123  --显示内容的高度
TicketItem.static.TOP_H = 100  --top条的高度

--初始化方法   数据需要接受服务器发送的数据
function TicketItem:initialize(warehouseData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.warehouseData = warehouseData;
    self.toggleData = toggleData  --位于toggle的第三个  左边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
    self.openBtn = self.viewRect.transform:Find("topRoot/close/openBtn");  --打开按钮
    self.toDoBtn = self.viewRect.transform:Find("topRoot/open/toDoBtn");  --跳转页面

   self.wageText=self.viewRect.transform:Find("contentRoot/rentalValueText"):GetComponent("Text");
    mainPanelLuaBehaviour:AddClick(self.openBtn.gameObject, function()
        clickOpenFunc(mgrTable, self.toggleData)
    end);

    mainPanelLuaBehaviour:AddClick(self.toDoBtn.gameObject,self.OntoDoBtn,self);

    self.wageText.text=getPriceString(MunicipalModel.ticket..".0000",30,24)
    Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self);
end


--获取是第几个点击了
function TicketItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function TicketItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, TicketItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - TicketItem.static.TOTAL_H);
end

--关闭
function TicketItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - TicketItem.static.TOP_H);
end

--刷新数据
function TicketItem:updateInfo(data)
    --[[    self.occupancyData = data

    if not self.viewRect.gameObject.activeSelf then
        return
    end]]
end


function TicketItem:OntoDoBtn(ins)
    ct.OpenCtrl("TicketAdjustPopCtrl",ins)
end


function TicketItem:callback()
    if TicketAdjustPopPanel. ticketInp.text=="" then
        Event.Brocast("m_Setticket",PlayerTempModel.roleData.buys.publicFacility[1].info.id,0)
        self.wageText.text=0;
    else
        Event.Brocast("m_Setticket",PlayerTempModel.roleData.buys.publicFacility[1].info.id,tonumber(TicketAdjustPopPanel. ticketInp.text))
        self.wageText.text=getPriceString(TicketAdjustPopPanel.ticketInp.text..".0000",30,24)
    end
end