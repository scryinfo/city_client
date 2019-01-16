---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/1/001 17:03
---

require('Framework/UI/UIPage')
require "Common/define"

local class = require 'Framework/class'
SignOnCtrl = class('SignOnCtrl',UIPage)
UIPage:ResgisterOpen(SignOnCtrl) --注册打开的方法

local LuaBehaviour;
local gameObject;


function  SignOnCtrl:bundleName()
    return "Assets/CityGame/Resources/View/SignOnPanel.prefab"
end

function SignOnCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
end
local panel
--启动事件--
function SignOnCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    panel=SignOnPanel

    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);
    LuaBehaviour:AddClick(panel.confirmBtn.gameObject,self.OnClick_confirm,self);

end

local MunicipalModel
function SignOnCtrl:Refresh()
    Event.AddListener("OnClick_backBtn",self.OnClick_backBtn,self)
    local data=self.m_data
    MunicipalModel=DataManager.GetDetailModelByID(MunicipalPanel.buildingId)

    SignOnPanel.dayilyRentnumText.text=getPriceString("E"..MunicipalModel.SlotList[1].rentPreDay..".0000",30,30)
    SignOnPanel.dayilyRentnumText.text=getPriceString("E"..(3*MunicipalModel.SlotList[1].rentPreDay)..".0000",30,30)
    SignOnPanel.totalnumText.text=getPriceString("E"..data.totalPrice..".0000",48,36)


end

--返回
function SignOnCtrl:OnClick_backBtn()
    UIPage.ClosePage();
    Event.RemoveListener("OnClick_backBtn",self.OnClick_backBtn,self)
end

function SignOnCtrl:OnClick_confirm(ins)

    for i = 1, ins.m_data.acount do
        DataManager.DetailModelRpcNoRet(MunicipalPanel.buildingId, 'm_buySlot',
                MunicipalPanel.buildingId,MunicipalModel.SlotList[1].id,ins.m_data.dayAcount)
        table.remove(MunicipalModel.SlotList,1)
    end
    DataManager.DetailModelRpcNoRet(MunicipalPanel.buildingId, 'm_detailPublicFacility',MunicipalPanel.buildingId)

end