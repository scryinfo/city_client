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
    transportbox:AddClick(TransportBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self);
end

function TransportBoxCtrl:Awake(go)
    self.gameObject = go;
end

function TransportBoxCtrl:OnClick_closeBtn(obj)
    obj:Hide();
end
function TransportBoxCtrl:OnClick_confirmBtn(obj)
    obj:Hide();
end

function TransportBoxCtrl:Refresh()

end