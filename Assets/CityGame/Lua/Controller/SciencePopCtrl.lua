---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/22/022 15:42
---
require "Common/define"
require('Framework/UI/UIPage')

local class = require 'Framework/class'

SciencePopCtrl = class('SciencePopCtrl',UIPage)
UIPage:ResgisterOpen(SciencePopCtrl) --注册打开的方法

function SciencePopCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function SciencePopCtrl:bundleName()
    return "SciencePopPanel";
end

function SciencePopCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    gameObject = obj;
end

function SciencePopCtrl:Awake(go)
    self.gameObject = go;
    local WagesAdjustBox = self.gameObject:GetComponent('LuaBehaviour');
    WagesAdjustBox:AddClick(SciencePopPanel.confirmBtn.gameObject,self.OnClick_confirm,self);
    WagesAdjustBox:AddClick(SciencePopPanel.closeBtn.gameObject,self.OnClick_close,self);

end
--确定
function SciencePopCtrl:OnClick_confirm(obj)
    if(obj.m_data.func) then
        obj.m_data:func()
    end
    obj:Hide();
    SciencePopPanel.tips.localScale=Vector3.zero
  --  SciencePopPanel.grey.localScale=Vector3.zero
end
--关闭
function SciencePopCtrl:OnClick_close(obj)
    obj:Hide();
    SciencePopPanel.tips.localScale=Vector3.zero
    --SciencePopPanel.grey.localScale=Vector3.zero
end
--刷新
function SciencePopCtrl:Refresh()
    if self.m_data.price then
        SciencePopPanel.moneyText.gameObject:SetActive(true)
        SciencePopPanel.moneyText.text=getPriceString("E"..self.m_data.price..".0000",48,36)
        SciencePopPanel.mainText.text="Buy the technology?"
        if ScienceSellHallModel.money<tonumber(self.m_data.price) then
            SciencePopPanel.tips.localScale=Vector3.one
        end
    else
        SciencePopPanel.moneyText.gameObject:SetActive(false)
        SciencePopPanel.tips.localScale=Vector3.zero
        SciencePopPanel.mainText.text="Cancel the order?"
    end
end