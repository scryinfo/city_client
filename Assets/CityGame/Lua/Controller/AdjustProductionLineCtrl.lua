require('Framework/UI/UIPage')
local class = require 'Framework/class'

AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPage);

function AdjustProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AdjustProductionLineCtrl:bundleName()
    return "AdjustProductionLine"
end

function AdjustProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    adjustLine = self.gameObject:GetComponent('LuaBehaviour')
    adjustLine:AddClick(AdjustProductionLinePanel.returnBtn,self.OnClick_returnBtn);
end

function AdjustProductionLineCtrl:Awake(go)
    self.gameObject = go
end

function AdjustProductionLineCtrl:Refesh()

end

function AdjustProductionLineCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end