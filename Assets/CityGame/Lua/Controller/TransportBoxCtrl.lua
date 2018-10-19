require('Framework/UI/UIPage')
local class = require 'Framework/class'

TransportBoxCtrl = class('TransportBoxCtrl',UIPage);

function TransportBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function TransportBoxCtrl:bundleName()
    return "TransportBox";
end

function TransportBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local transportbox = self.gameObject:GetComponent('LuaBehaviour');
    transportbox:AddClick(TransportBoxPanel.closeBtn.gameObject,self.OnClick_closeBtn,self);
end
function TransportBoxCtrl:OnClick_closeBtn()
    UIPage.ClosePage();
end