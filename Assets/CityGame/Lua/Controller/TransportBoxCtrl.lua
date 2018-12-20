-----


TransportBoxCtrl = class('TransportBoxCtrl',UIPage);
UIPage:ResgisterOpen(TransportBoxCtrl) --注册打开的方法
local transportbox

function TransportBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function TransportBoxCtrl:bundleName()
    return "TransportBoxPanel";
end

function TransportBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);

end

function TransportBoxCtrl:Awake(go)
    self.gameObject = go;
end

function TransportBoxCtrl:Refresh()
    transportbox = self.gameObject:GetComponent('LuaBehaviour');
    transportbox:AddClick(TransportBoxPanel.closeBtn.gameObject,self.OnClick_closeBtn,self);
    transportbox:AddClick(TransportBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self);
    if self.m_data == nil then
        return;
    end
    self:refreshUiInfo()
end
--刷新数据
function TransportBoxCtrl:refreshUiInfo()
    if not self.m_data.goodsPrice then
        TransportBoxPanel.goodsObj.localScale = Vector3.zero
        TransportBoxPanel.transportObj.localScale = Vector3.zero
        TransportBoxPanel.transportsObj.localScale = Vector3.one
        TransportBoxPanel.transportMoney.text = self.m_data.freight
    else
        TransportBoxPanel.goodsObj.localScale = Vector3.one
        TransportBoxPanel.transportObj.localScale = Vector3.one
        TransportBoxPanel.transportsObj.localScale = Vector3.zero
        TransportBoxPanel.transportMoney.text = "E"..math.floor(self.m_data.freight)..".0000";
    end
    --self.buildingId = self.m_data.buildingId;
    --self.buyGood = self.m_data.good;
    TransportBoxPanel.fromName.text = self.m_data.currentLocationName;
    TransportBoxPanel.targetName.text = self.m_data.targetLocationName;
    TransportBoxPanel.distanceText.text = math.floor(self.m_data.distance).."km";
    TransportBoxPanel.numberText.text = self.m_data.number;
    TransportBoxPanel.goodsMoney.text = "E"..self.m_data.goodsPrice..".0000";
    TransportBoxPanel.totalMoney.text = "E"..math.floor(self.m_data.total)..".0000";
end
function TransportBoxCtrl:OnClick_closeBtn(ins)
    transportbox:RemoveClick(TransportBoxPanel.closeBtn.gameObject, ins.OnClick_closeBtn, ins)
    transportbox:RemoveClick(TransportBoxPanel.confirmBtn.gameObject, ins.OnClick_confirmBtn, ins)
    --ins.m_data = nil;
    ins:Hide();
end
function TransportBoxCtrl:OnClick_confirmBtn(ins)
    if ins.m_data.btnClick then
        ins.m_data.btnClick()
        ins.m_data.btnClick = nil
    end
    --ins:Hide();
    ins:OnClick_closeBtn(ins)
end
