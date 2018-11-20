---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/25/025 17:47
---


require "Common/define"

require('Framework/UI/UIPage')

local class = require 'Framework/class'
ScienceSellPopCtrl = class('ScienceSellPopCtrl',UIPage)
UIPage:ResgisterOpen(ScienceSellPopCtrl) --注册打开的方法

---构建函数
function ScienceSellPopCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.None);
end

function ScienceSellPopCtrl:bundleName()
    return "AdvertisementPopPanel";
end

function ScienceSellPopCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function ScienceSellPopCtrl:Awake(go)
    self.gameObject = go;
    local materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviour:AddClick(ScienceSellPopPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(ScienceSellPopPanel.cutBtn.gameObject,self.OnClick_cut,self);
    materialBehaviour:AddClick(ScienceSellPopPanel.plusBtn.gameObject,self.OnClick_plus,self);
    materialBehaviour:AddClick(ScienceSellPopPanel.okBtn.gameObject,self.OnClick_confirm,self);

end


local panel=ScienceSellPopPanel
---close
function ScienceSellPopCtrl:OnClick_backBtn(obj)
    obj:Hide();
end

---cut
function ScienceSellPopCtrl:OnClick_cut(obj)
    panel.levleInp.text=panel.levleInp.text-1
end

---plus
function ScienceSellPopCtrl:OnClick_plus(obj)
    panel.levleInp.text=panel.levleInp.text+1
end

---confirm
function ScienceSellPopCtrl:OnClick_confirm(obj)
    obj:Hide();

end

function AdvertisementPopCtrl:Refresh()

end





