-----


TransportBoxCtrl = class('TransportBoxCtrl',UIPage);
UIPage:ResgisterOpen(TransportBoxCtrl) --注册打开的方法


function TransportBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal);
end

function TransportBoxCtrl:bundleName()
    return "TransportBoxPanel";
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

function TransportBoxCtrl:Refresh()
    if self.m_data == nil then
        return;
    end
    TransportBoxPanel.fromName.text = self.m_data.currentLocationName;
    TransportBoxPanel.targetName.text = self.m_data.targetLocationName;
    TransportBoxPanel.distanceText.text = self.m_data.distance;
    TransportBoxPanel.timeText.text = self.m_data.time;
    TransportBoxPanel.goodsMoney.text = "E"..self.m_data.goodsPrice;
    TransportBoxPanel.transportMoney.text = "E"..self.m_data.freight;
    TransportBoxPanel.totalMoney.text = "E"..self.m_data.total;
end

function TransportBoxCtrl:OnClick_closeBtn(obj)
    obj.m_data = nil;
    obj:Hide();
end
function TransportBoxCtrl:OnClick_confirmBtn(obj)
    local data = {}
    data.titleInfo = "提示"
    data.contentInfo = "商品开始运输"
    data.tipInfo = "可在运输线查看详情"
    ct.OpenCtrl('BtnDialogPageCtrl',data)
    CenterWareHousePanel.transportConfirm:SetActive(true);
    CenterWareHousePanel.nameText.text = nil;
    obj:Hide();
end
