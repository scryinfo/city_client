---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/24 17:57
---
ExchangeDetailCtrl = class('ExchangeDetailCtrl',UIPage)
UIPage:ResgisterOpen(ExchangeDetailCtrl)
ExchangeDetailCtrl.static.level1TotalTime = 3600  --第一档的时间间隔

function ExchangeDetailCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ExchangeDetailCtrl:bundleName()
    return "ExchangeDetailPanel"
end

function ExchangeDetailCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function ExchangeDetailCtrl:Awake(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour');
    --UpdateBeat:Add(self._update, self);

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
    self.infoItem = ExchangeQuoteItem:new(self.m_data, ExchangeDetailPanel.itemInfoTran)
end

function ExchangeDetailCtrl:Refresh()
    self:_initPanelData()
end

function ExchangeDetailCtrl:Hide()
    self.startTimeDown = true
    self.luaBehaviour:RemoveClick(ExchangeDetailPanel.backBtn.gameObject, self.OnClickBack, self)
    UIPage.Hide(self)
end

---添加移除监听
function ExchangeDetailCtrl:_addListeners()
    Event.AddListener("c_onReceiveLineInfo", self._updateLineData, self)
end
function ExchangeDetailCtrl:_removeListeners()
    --self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.backBtn.gameObject, self._backBtn, self);
    ExchangeDetailPanel.toggle01.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle02.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle03.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle04.onValueChanged:RemoveAllListeners()
    ExchangeDetailPanel.toggle05.onValueChanged:RemoveAllListeners()

    Event.RemoveListener("c_onReceiveLineInfo", self._updateLineData, self)
end

function ExchangeDetailCtrl:Close()

end

function ExchangeDetailCtrl:_initPanelData()
    self.luaBehaviour:AddClick(ExchangeDetailPanel.backBtn.gameObject, self.OnClickBack,self)

    Event.AddListener("c_onUpdateSellBuyInfo", self._updateItemTransactionData, self)
    ExchangeDetailPanel.toggle01.isOn = true
    self.startTimeDown = true
end
--temp
function ExchangeDetailCtrl:_update()
    if self.startTimeDown then
        --第一档
        if self.level1Time > 0 then
            self.level1Time = self.level1Time - UnityEngine.Time.unscaledDeltaTime
        else
            Event.Brocast("m_ReqExchangeLineInfo", self.m_data.itemId)
            self.level1Time = ExchangeDetailCtrl.static.level1TotalTime
        end

        --第二档
        if self.level2Time > 0 then
            self.level2Time = self.level2Time - UnityEngine.Time.unscaledDeltaTime
        else
            Event.Brocast("m_ReqExchangeLineInfo", self.m_data.itemId)
            self.level2Time = ExchangeDetailCtrl.static.level2TotalTime
        end
    end
end

function ExchangeDetailCtrl:OnClickBack()
    UIPage.ClosePage()
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
function ExchangeDetailCtrl:_updateLineData(datas)

end