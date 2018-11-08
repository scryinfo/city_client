-----


DETAILSBoxCtrl = class('DETAILSBoxCtrl',UIPage);

function DETAILSBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function DETAILSBoxCtrl:bundleName()
    return "DETAILSBoxPanel";
end

function DETAILSBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local details = self.gameObject:GetComponent('LuaBehaviour');
    details:AddClick(DETAILSBoxPanel.XBtn.gameObject,self.OnClick_XBtn,self);
    details:AddClick(DETAILSBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self);
end

function DETAILSBoxCtrl:Awake(go)
    self.gameObject = go;
end

function DETAILSBoxCtrl:OnClick_XBtn(obj)
    obj:Hide();
end

function DETAILSBoxCtrl:OnClick_confirmBtn(obj)
    obj:Hide();
end

function DETAILSBoxCtrl:Refresh()

end