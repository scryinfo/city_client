---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/23 10:20
---
---存在问题，什么时候清空界面，从选择仓库界面返回时不能清除已经填写好的界面信息，但是当从单个行情item点进的时候需要清除
---是在hide还是refresh中处理？
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

    self:_initPanelData()
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

    UpdateBeat:Add(self._update, self)
end

function ExchangeTransactionCtrl:Refresh()
    --self:_initPanelData()

    --Event.Brocast("m_ReqExchangeWatchItemDetail", self.itemId)
end

function ExchangeTransactionCtrl:Hide()
    --UIPage.Hide(self)
    self.gameObject:SetActive(false)
    self.isActived = false
    --ExchangeTransactionPanel._initPanel()

    Event.Brocast("m_ReqExchangeStopWatchItemDetail", self.itemId)
end

function ExchangeTransactionCtrl:Close()
end

function ExchangeTransactionCtrl:_update()
    if not self.gameObject.activeSelf then
        return
    end
    self:_updateConfim()
end
---检测是否能点击确认按钮
function ExchangeTransactionCtrl:_updateConfim()
    ExchangeTransactionPanel.confirmBtn.localScale = Vector3.zero
    if self.isSellState then
        if ExchangeTransactionPanel.sellCountInput.text ~= "" and tonumber(ExchangeTransactionPanel.sellCountInput.text) > 0 then
            if self.sellTotalCount ~= nil then
                if tonumber(ExchangeTransactionPanel.sellCountInput.text) > self.sellTotalCount then
                    ExchangeTransactionPanel.sellErorTipTran.localScale = Vector3.one
                    self.wareHouseChoosed = false
                else
                    ExchangeTransactionPanel.sellErorTipTran.localScale = Vector3.zero
                    self.wareHouseChoosed = true
                end
            end

            if ExchangeTransactionPanel.sellPriceInput.text ~= "" and tonumber(ExchangeTransactionPanel.sellPriceInput.text) > 0 then
                --显示算好的数值
                local count = ExchangeTransactionPanel.sellCountInput.text
                local unitPrice = ExchangeTransactionPanel.sellPriceInput.text
                ExchangeTransactionPanel.calculateText.text = "E"..getPriceString(count * unitPrice, 30, 24)
                ExchangeTransactionPanel.totalText.text = "E"..getPriceString(count * unitPrice, 48, 36)
                ExchangeTransactionPanel.serviceText.text = 0

                if not self.wareHouseChoosed then
                    return
                else
                    ExchangeTransactionPanel.confirmBtn.localScale = Vector3.one
                end
            end
        end
    else
        if ExchangeTransactionPanel.buyCountInput.text ~= "" and tonumber(ExchangeTransactionPanel.buyCountInput.text) > 0 then
            if self.buyCapacityCount ~= nil then
                if tonumber(ExchangeTransactionPanel.buyCountInput.text) > self.buyCapacityCount then
                    ExchangeTransactionPanel.buyErorTipTran.localScale = Vector3.one
                    self.wareHouseChoosed = false
                else
                    ExchangeTransactionPanel.buyErorTipTran.localScale = Vector3.zero
                    self.wareHouseChoosed = true
                end
            end

            if ExchangeTransactionPanel.buyPriceInput.text ~= "" and tonumber(ExchangeTransactionPanel.buyPriceInput.text) > 0 then
                --显示算好的数值
                local count = ExchangeTransactionPanel.buyCountInput.text
                local unitPrice = ExchangeTransactionPanel.buyPriceInput.text
                ExchangeTransactionPanel.calculateText.text = "E"..getPriceString(count * unitPrice, 30, 24)
                ExchangeTransactionPanel.totalText.text = "E"..getPriceString(count * unitPrice, 48, 36)
                ExchangeTransactionPanel.serviceText.text = "E"..getPriceString(count * unitPrice * 0.1, 30, 24)

                if not self.wareHouseChoosed then
                    return
                else
                    ExchangeTransactionPanel.confirmBtn.localScale = Vector3.one
                end
            end
        end

    end
end
---初始化
function ExchangeTransactionCtrl:_initPanelData()
    self:_addListeners()
    ExchangeTransactionCtrl.buyItems = {}
    ExchangeTransactionCtrl.sellItems = {}

    -----模拟数据
    --local buyTemp = {}
    --buyTemp[1] = {index = 1, isSell = false, id = 12345.987, num = 999}
    --buyTemp[2] = {index = 2, isSell = false, id = 12.87,     num = 89}
    --buyTemp[3] = {index = 3, isSell = false, id = 7.4544,    num = 78}
    --buyTemp[4] = {index = 4, isSell = false, id = 345.9,     num = 12}
    --buyTemp[5] = {index = 5, isSell = false, id = 245.17,    num = 68}
    --
    --local sellTemp = {}
    --sellTemp[1] = {index = 1, isSell = true, id = 12345.987, num = 999}
    --sellTemp[2] = {index = 2, isSell = true, id = 12.87,     num = 89}
    --sellTemp[3] = {index = 3, isSell = true, id = 7.4544,    num = 78}
    --sellTemp[4] = {index = 4, isSell = true, id = 345.9,     num = 12}
    --sellTemp[5] = {index = 5, isSell = true, id = 245.17,    num = 68}
    --ExchangeTransactionCtrl.static.sellDatas = sellTemp
    --ExchangeTransactionCtrl.static.buyDatas = buyTemp
    --ExchangeTransactionPanel.buyScroll:ActiveLoopScroll(self.buySource, #ExchangeTransactionCtrl.static.buyDatas)
    --ExchangeTransactionPanel.sellScroll:ActiveLoopScroll(self.sellSource, #ExchangeTransactionCtrl.static.sellDatas)

    ExchangeTransactionPanel.itemNameText.text = self.m_data.name
    ExchangeTransactionPanel.changeText.text = self.m_data.priceChange
    ExchangeTransactionPanel.newestPriceText.text = self.m_data.nowPrice
    --hide之后m_data会被清空，暂时这么存着
    self.name = self.m_data.name
    self.change = self.m_data.priceChange
    self.lastPrice = self.m_data.nowPrice
    self.itemId = self.m_data.itemId
    self.isSellState = false
    Event.Brocast("m_ReqExchangeWatchItemDetail", self.itemId)
end
---添加移除监听
function ExchangeTransactionCtrl:_addListeners()
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.backBtn.gameObject, self._backBtn, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.buyBtn.gameObject, self._openBuyPart, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.sellBtn.gameObject, self._openSellPart, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.sellChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.buyChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.confirmBtn.gameObject, self._clickConfirm, self);

    Event.AddListener("c_onExchangeChooseWareHouseBack", self._onExchangeChooseWareHouseBack, self)  --选择仓库完成

    Event.AddListener("c_onReceiveBuySellItemsInfo", self._updateItemTransactionData, self)
    Event.AddListener("c_onReceiveExchangeBuy", self._exchangeBuy, self)
    Event.AddListener("c_onReceiveExchangeSell", self._exchangeSell, self)

end
function ExchangeTransactionCtrl:_removeListeners()
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.backBtn.gameObject, self._backBtn, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.buyBtn.gameObject, self._openBuyPart, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.sellBtn.gameObject, self._openSellPart, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.sellChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.buyChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.confirmBtn.gameObject, self._clickConfirm, self);

    --Event.AddListener("c_onExchangeChooseWareHouseBack", self._onExchangeChooseWareHouseBack, self)  --选择仓库完成
end

---按钮监听
function ExchangeTransactionCtrl:_backBtn()
    UIPage.ClosePage();
end
function ExchangeTransactionCtrl:_openBuyPart(ins)
    ExchangeTransactionPanel._openBuy()
    ins.isSellState = false
end
function ExchangeTransactionCtrl:_openSellPart(ins)
    ExchangeTransactionPanel._openSell()
    ins.isSellState = true
end
function ExchangeTransactionCtrl:_chooseWareHouse(ins)
    local wareHouseData = {}
    if ins.isSellState then
        wareHouseData.isSell = true
    else
        wareHouseData.isSell = false
    end
    wareHouseData.itemId = ins.itemId
    ct.OpenCtrl("ExchangeChooseWareHouseCtrl", wareHouseData)
end
function ExchangeTransactionCtrl:_clickConfirm(ins)
    local showData = {}
    local str1
    local count
    if ins.isSellState then
        str1 = "sell"
        count = ExchangeTransactionPanel.sellCountInput.text
        showData.btnCallBack = function()
            log("cycle_w11_exchange03", "挂卖单")
            Event.Brocast("m_ReqExchangeSell", ins.itemId, count, ExchangeTransactionPanel.sellPriceInput.text, ins.buildingId)
        end
    else
        str1 = "buy"
        count = ExchangeTransactionPanel.buyCountInput.text
        showData.btnCallBack = function()
            Event.Brocast("m_ReqExchangeBuy", ins.itemId, count, ExchangeTransactionPanel.buyPriceInput.text, ins.buildingId)
            log("cycle_w11_exchange03", "挂买单")
        end
    end
    showData.titleInfo = "REMINDER"
    showData.contentInfo = string.format("Entrust to %s <color=%s>%s</color>x%d?", str1, "#CA8A00", ins.name, count)
    showData.tipInfo = ""
    ct.OpenCtrl("BtnDialogPageCtrl", showData)
end

---滑动复用
ExchangeTransactionCtrl.static.BuyProvideData = function(transform, idx)
    idx = idx + 1
    transform.localRotation = Quaternion.Euler(0, 0, 180);
    local buyItem = ExchangeTransactionItem:new(ExchangeTransactionCtrl.buyDatas[idx], transform)
    ExchangeTransactionCtrl.buyItems[idx] = buyItem
end
ExchangeTransactionCtrl.static.BuyClearData = function(transform)
end
--sellScroll
ExchangeTransactionCtrl.static.SellProvideData = function(transform, idx)
    idx = idx + 1
    local sellItem = ExchangeTransactionItem:new(ExchangeTransactionCtrl.sellDatas[idx], transform)
    ExchangeTransactionCtrl.sellItems[idx] = sellItem
end
ExchangeTransactionCtrl.static.SellClearData = function(transform)
end
---选择仓库事件回调
function ExchangeTransactionCtrl:_onExchangeChooseWareHouseBack(wareDats)
    if wareDats.isSell ~= self.isSellState then
    ct.log("cycle_w11_exchange03", "仓库数据的sell状态与交易界面状态不一致")
        return
    end

    self.buildingId = wareDats.buildingId
    if wareDats.isSell then
        ExchangeTransactionPanel.SellChooseSuccess(wareDats.buildingName)
        self.sellTotalCount = wareDats.totalCount
        local sellCountValue = ExchangeTransactionPanel.sellCountInput.text
        if sellCountValue == "" then  --如果数量还未填写，则显示当前库存量
            ExchangeTransactionPanel.sellCountInput.text = wareDats.totalCount
            ExchangeTransactionPanel.SellChooseSuccess(wareDats.buildingName)
            self.wareHouseChoosed = true
        else
            if tonumber(sellCountValue) > wareDats.totalCount then
                ExchangeTransactionPanel.sellErorTipTran.localScale = Vector3.one
                self.wareHouseChoosed = false
            else
                --ExchangeTransactionPanel.SellChooseSuccess(wareDats.buildingName)
                self.wareHouseChoosed = true
            end
        end
    else
        ExchangeTransactionPanel.BuyChooseSuccess(wareDats.buildingName)
        self.buyCapacityCount = wareDats.remainCapacity
        local buyCountValue = ExchangeTransactionPanel.buyCountInput.text
        if buyCountValue == "" then  --如果数量还未填写，则显示当前库存量
            ExchangeTransactionPanel.buyCountInput.text = wareDats.remainCapacity
            ExchangeTransactionPanel.BuyChooseSuccess(wareDats.buildingName)
            self.wareHouseChoosed = true
        else
            if tonumber(buyCountValue) > wareDats.remainCapacity then
                ExchangeTransactionPanel.buyErorTipTran.localScale = Vector3.one
                self.wareHouseChoosed = false
            else
                --ExchangeTransactionPanel.BuyChooseSuccess(wareDats.buildingName)
                self.wareHouseChoosed = true
            end
        end
    end
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
        ExchangeTransactionPanel.buyScroll:ActiveLoopScroll(self.buySource, #ExchangeTransactionCtrl.static.buyDatas)
    end

    if #datas.sell ~= 0 then
        ExchangeTransactionCtrl.static.sellDatas = datas.sell
        for i, itemData in ipairs(ExchangeTransactionCtrl.static.sellDatas) do
            itemData.index = i
            itemData.isSell = true
        end
        ExchangeTransactionPanel.sellScroll:ActiveLoopScroll(self.sellSource, #ExchangeTransactionCtrl.static.sellDatas)
    end

    ExchangeTransactionPanel.changeText.text = datas.priceChange
    ExchangeTransactionPanel.newestPriceText.text = datas.nowPrice
    self.change = datas.priceChange
    self.lastPrice = datas.nowPrice
end
--挂买单成功
function ExchangeTransactionCtrl:_exchangeBuy(id)
    --挂单成功之后会返回一个单号，但是目前来说不需要其他操作
end
--挂卖单成功
function ExchangeTransactionCtrl:_exchangeSell(id)
    --挂单成功之后会返回一个单号，但是目前来说不需要其他操作
end
