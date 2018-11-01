-----


TransportBoxCtrl = class('TransportBoxCtrl',UIPage);
UIPage:ResgisterOpen(TransportBoxCtrl) --注册打开的方法


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
    local data = {}
    data.titleInfo = "提示"
    data.contentInfo = "商品开始运输"
    data.tipInfo = "可在运输线查看详情"
    CityGlobal.OpenCtrl('BtnDialogPageCtrl',data)
    CenterWareHousePanel.transportConfirm:SetActive(true);
    CenterWareHousePanel.nameText.text = nil;
    obj:Hide();

end

function TransportBoxCtrl:Refresh()

end