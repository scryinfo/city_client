---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/25/025 17:47
---


require "Common/define"
--require "View/BuildingInfo/BuildingInfoToggleGroupMgr";
require('Framework/UI/UIPage')

local class = require 'Framework/class'
AdvertisementPopCtrl = class('AdvertisementPopCtrl',UIPage)
UIPage:ResgisterOpen(AdvertisementPopCtrl) --注册打开的方法

---构建函数
function AdvertisementPopCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.None);
end

function AdvertisementPopCtrl:bundleName()
    return "AdvertisementPopPanel";
end

function AdvertisementPopCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function AdvertisementPopCtrl:Awake(go)
    self.gameObject = go;
    local materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviour:AddClick(AdvertisementPopPanel.confirmBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(AdvertisementPopPanel.closeBtn.gameObject,self.OnClick_backBtn,self);
end



---关闭弹窗
function AdvertisementPopCtrl:OnClick_backBtn(obj)
    obj:Hide();
end



function AdvertisementPopCtrl:Refresh()
    AdvertisementPopPanel.testTxt.text=self.m_data.id;
end


