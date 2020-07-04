---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 17:42
---Player information prompt box
require "Common/define"
require('Framework/UI/UIPage')

local class = require 'Framework/class'
MessageTooltipCtrl = class('MessageTooltipCtrl',UIPage)
UIPage:ResgisterOpen(MessageTooltipCtrl) --How to open the registration

function  MessageTooltipCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MessageTooltipPanel.prefab"
end

function MessageTooltipCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function MessageTooltipCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    self:_initData();
    local messageTooltipBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    messageTooltipBehaviour:AddClick(MessageTooltipPanel.okBtn,self.c_OkBtn,self);
    messageTooltipBehaviour:AddClick(MessageTooltipPanel.xBtn,self.c_XBtn,self);
end

function MessageTooltipCtrl:c_OkBtn(obj)
    obj:Hide();
end

function MessageTooltipCtrl:c_XBtn(obj)
    obj:Hide();
end
---Initialize
function MessageTooltipCtrl:_initData()
    MessageTooltipPanel.madeBy.text = self.m_data.madeBy;
    MessageTooltipPanel.playerName.text = self.m_data.playerName
end