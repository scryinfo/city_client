-----
TransportBoxCtrl = class('TransportBoxCtrl',UIPanel);
UIPanel:ResgisterOpen(TransportBoxCtrl) --How to open the registration
local transportbox

function TransportBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function TransportBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/TransportBoxPanel.prefab";
end

function TransportBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function TransportBoxCtrl:Awake(go)
    self.gameObject = go;
end
function TransportBoxCtrl:Active()
    UIPanel.Active(self)
    TransportBoxPanel.name.text = GetLanguage(26040008)
    TransportBoxPanel.total.text = GetLanguage(26040009)
    transportbox = self.gameObject:GetComponent('LuaBehaviour');
    transportbox:AddClick(TransportBoxPanel.closeBtn.gameObject,self.OnClick_closeBtn,self);
    transportbox:AddClick(TransportBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self);
end
function TransportBoxCtrl:Refresh()
    if self.m_data == nil then
        return;
    end
    self:refreshUiInfo()
end
----Refresh data
function TransportBoxCtrl:refreshUiInfo()
    if not self.m_data.goodsPrice then
        TransportBoxPanel.goodsObj.localScale = Vector3.zero
        TransportBoxPanel.transportObj.localScale = Vector3.zero
        TransportBoxPanel.transportsObj.localScale = Vector3.one
        TransportBoxPanel.transportsMoney.text =  "E"..self.m_data.freight;
    else
        TransportBoxPanel.goodsObj.localScale = Vector3.one
        TransportBoxPanel.transportObj.localScale = Vector3.one
        TransportBoxPanel.transportsObj.localScale = Vector3.zero
        TransportBoxPanel.transportMoney.text = "E"..self.m_data.freight;
        TransportBoxPanel.goodsMoney.text = "E"..self.m_data.goodsPrice;

    end
    --self.buildingId = self.m_data.buildingId;
    --self.buyGood = self.m_data.good;
    TransportBoxPanel.fromName.text = self.m_data.currentLocationName;
    TransportBoxPanel.targetName.text = self.m_data.targetLocationName;
    TransportBoxPanel.distanceText.text = math.floor(self.m_data.distance).."km";
    TransportBoxPanel.numberText.text = self.m_data.number;
    TransportBoxPanel.totalMoney.text = "E"..self.m_data.total;
end
function TransportBoxCtrl:OnClick_closeBtn(ins)
    PlayMusEff(1002)
    transportbox:RemoveClick(TransportBoxPanel.closeBtn.gameObject, ins.OnClick_closeBtn, ins)
    transportbox:RemoveClick(TransportBoxPanel.confirmBtn.gameObject, ins.OnClick_confirmBtn, ins)
    --ins.m_data = nil;
    --ins:clickClosrBtn();
    UIPanel.ClosePage()

end
function TransportBoxCtrl:OnClick_confirmBtn(ins)
    PlayMusEff(1002)
    if ins.m_data.btnClick then
        ins.m_data.btnClick()
        ins.m_data.btnClick = nil
    end
    --ins:OnClick_closeBtn(ins)
    UIPanel.ClosePage()
end
--function TransportBoxCtrl:clickClosrBtn()
--    UIPanel.ClosePage()
--    --UIPanel.Hide(self)
--end