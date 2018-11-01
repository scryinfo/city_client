---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/31/031 16:30
---

require "Common/define"
require('Framework/UI/UIPage')

local class = require 'Framework/class'

ConfirmPopCtrl = class('ConfirmPopCtrl',UIPage)
UIPage:ResgisterOpen(ConfirmPopCtrl) --注册打开的方法

function ConfirmPopCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function ConfirmPopCtrl:bundleName()
    return "ConfirmPop";
end

function ConfirmPopCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    gameObject = obj;
    local WagesAdjustBox = gameObject:GetComponent('LuaBehaviour');
end

function ConfirmPopCtrl:Awake(go)
    self.gameObject = go;
    local WagesAdjustBox = self.gameObject:GetComponent('LuaBehaviour');
    WagesAdjustBox:AddClick(ConfirmPopPanel.confirmBtn.gameObject,self.OnClick_confirm,self);
    WagesAdjustBox:AddClick(ConfirmPopPanel.closeBtn.gameObject,self.OnClick_close,self);
end
--确定
function ConfirmPopCtrl:OnClick_confirm(obj)
    if(obj.m_data) then
        obj.m_data:callback()
    end
    obj:Hide();
end
--关闭
function ConfirmPopCtrl:OnClick_close(obj)
    obj:Hide();
end
--刷新
function ConfirmPopCtrl:Refresh()

end


