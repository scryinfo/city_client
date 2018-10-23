---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/23 10:20
---
ExchangeTransactionCtrl = class('ExchangeTransactionCtrl',UIPage)
UIPage:ResgisterOpen(ExchangeTransactionCtrl)

function ExchangeTransactionCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ExchangeTransactionCtrl:bundleName()
    return "ExchangeTransaction"
end

function ExchangeTransactionCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function ExchangeTransactionCtrl:Awake(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour');

    --滑动复用部分
    self.buySource = UnityEngine.UI.LoopScrollDataSource.New()
    self.buySource.mProvideData = ExchangeTransactionCtrl.static.BuyProvideData
    self.buySource.mClearData = ExchangeTransactionCtrl.static.BuyClearData
    self.sellSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.sellSource.mProvideData = ExchangeTransactionCtrl.static.SellProvideData
    self.sellSource.mClearData = ExchangeTransactionCtrl.static.SellClearData
end

function ExchangeTransactionCtrl:Refresh()
    self:_initPanelData()
end

function ExchangeTransactionCtrl:Close()
    ExchangePanel.quotesToggle.onValueChanged:RemoveAllListeners();
end

function ExchangeTransactionCtrl:_initPanelData()
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.backBtn.gameObject, function()
        UIPage.ClosePage();
    end );

    Event.AddListener("m_onUpdateSellBuyInfo", self._updateItemTransactionData, self)

    ---模拟数据
    local buyTemp = {}
    buyTemp[1] = {index = 1, isSell = false, id = 12345.987, num = 999}
    buyTemp[2] = {index = 2, isSell = false, id = 12.87,     num = 89}
    buyTemp[3] = {index = 3, isSell = false, id = 7.4544,    num = 78}
    buyTemp[4] = {index = 4, isSell = false, id = 345.9,     num = 12}
    buyTemp[5] = {index = 5, isSell = false, id = 245.17,    num = 68}

    local sellTemp = {}
    sellTemp[1] = {index = 1, isSell = true, id = 12345.987, num = 999}
    sellTemp[2] = {index = 2, isSell = true, id = 12.87,     num = 89}
    sellTemp[3] = {index = 3, isSell = true, id = 7.4544,    num = 78}
    sellTemp[4] = {index = 4, isSell = true, id = 345.9,     num = 12}
    sellTemp[5] = {index = 5, isSell = true, id = 245.17,    num = 68}
    ExchangeTransactionCtrl.static.sellDatas = sellTemp
    ExchangeTransactionCtrl.static.buyDatas = buyTemp

    ExchangeTransactionPanel.buyScroll:ActiveLoopScroll(self.buyScroll, #ExchangeTransactionCtrl.static.buyDatas)
    ExchangeTransactionPanel.sellScroll:ActiveLoopScroll(self.sellScroll, #ExchangeTransactionCtrl.static.sellDatas)
end

--buyScroll
ExchangeTransactionCtrl.static.BuyProvideData = function(transform, idx)
    idx = idx + 1
    local buyItem = ExchangeTransactionItem:new(ExchangeTransactionCtrl.buyDatas[idx], transform)
end
ExchangeTransactionCtrl.static.BuyClearData = function(transform)
end
--sellScroll
ExchangeTransactionCtrl.static.SellProvideData = function(transform, idx)
    idx = idx + 1
    local sellItem = ExchangeTransactionItem:new(ExchangeTransactionCtrl.sellDatas[idx], transform)
end
ExchangeTransactionCtrl.static.SellClearData = function(transform)
end

---接收服务器消息
function ExchangeTransactionCtrl:_updateItemTransactionData(datas)
    if #datas.buy ~= 0 then
        ExchangeTransactionCtrl.static.buyDatas = datas.buy
        --填充数据
        for i, itemData in ipairs(ExchangeTransactionCtrl.static.buyDatas) do
            itemData.index = i
            itemData.isSell = false
        end
    end

    if #datas.sell ~= 0 then
        ExchangeTransactionCtrl.static.sellDatas = datas.sell
        for i, itemData in ipairs(ExchangeTransactionCtrl.static.sellDatas) do
            itemData.index = i
            itemData.isSell = true
        end
    end
end