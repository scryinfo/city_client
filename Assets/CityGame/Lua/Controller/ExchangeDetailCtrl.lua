---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/24 17:57
---
ExchangeDetailCtrl = class('ExchangeDetailCtrl',UIPage)
UIPage:ResgisterOpen(ExchangeDetailCtrl)

function ExchangeDetailCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ExchangeDetailCtrl:bundleName()
    return "ExchangeDetail"
end

function ExchangeDetailCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function ExchangeDetailCtrl:Awake(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour');

    ExchangeDetailPanel.toggle01.onValueChanged:AddListener(function (isOn)
        self:_chooseToggle01(isOn)
    end)
    ExchangeDetailPanel.toggle02.onValueChanged:AddListener(function (isOn)
        self:_chooseToggle02(isOn)
    end)
    ExchangeDetailPanel.toggle03.onValueChanged:AddListener(function (isOn)
        self:_chooseToggle03(isOn)
    end)
    ExchangeDetailPanel.toggle04.onValueChanged:AddListener(function (isOn)
        self:_chooseToggle04(isOn)
    end)
    ExchangeDetailPanel.toggle05.onValueChanged:AddListener(function (isOn)
        self:_chooseToggle05(isOn)
    end)
end

function ExchangeDetailCtrl:Refresh()
    self:_initPanelData()
end

function ExchangeDetailCtrl:Close()
    ExchangeDetailPanel.toggle01.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle02.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle03.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle04.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle05.onValueChanged:RemoveAllListeners()
end

function ExchangeDetailCtrl:_initPanelData()
    self.luaBehaviour:AddClick(ExchangeDetailPanel.backBtn.gameObject, function()
        UIPage.ClosePage();
    end );

    Event.AddListener("c_onUpdateSellBuyInfo", self._updateItemTransactionData, self)

    self.infoItem = ExchangeQuoteItem:new(self.m_data, ExchangeDetailPanel.itemInfoTran)
    ExchangeDetailPanel.toggle01.isOn = true
end

---toggle监听
function ExchangeDetailCtrl:_chooseToggle01(isOn)
    ExchangeDetailPanel._toggle01State(isOn)
    --请求01档位的数据

end
function ExchangeDetailCtrl:_chooseToggle02(isOn)
    ExchangeDetailPanel._toggle02State(isOn)
end
function ExchangeDetailCtrl:_chooseToggle03(isOn)
    ExchangeDetailPanel._toggle03State(isOn)
end
function ExchangeDetailCtrl:_chooseToggle04(isOn)
    ExchangeDetailPanel._toggle04State(isOn)
end
function ExchangeDetailCtrl:_chooseToggle05(isOn)
    ExchangeDetailPanel._toggle05State(isOn)
end

---接收服务器消息
function ExchangeDetailCtrl:_updateItemTransactionData(datas)

end