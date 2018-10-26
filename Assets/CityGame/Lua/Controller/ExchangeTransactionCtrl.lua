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

    UpdateBeat:Add(self._update, self);
end

function ExchangeTransactionCtrl:Refresh()
    --self:_initPanelData()
end

function ExchangeTransactionCtrl:Hide()
    --UIPage.Hide(self)
    self.gameObject:SetActive(false)
    self.isActived = false
    --ExchangeTransactionPanel._initPanel()
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
            if self.sellRemainCount ~= nil then
                if tonumber(ExchangeTransactionPanel.sellCountInput.text) > self.sellRemainCount then
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
    ExchangeTransactionCtrl.buyItems = {}
    ExchangeTransactionCtrl.sellItems = {}
    ExchangeTransactionPanel.buyScroll:ActiveLoopScroll(self.buySource, #ExchangeTransactionCtrl.static.buyDatas)
    ExchangeTransactionPanel.sellScroll:ActiveLoopScroll(self.sellSource, #ExchangeTransactionCtrl.static.sellDatas)

    ExchangeTransactionPanel.itemNameText.text = self.m_data.name
    ExchangeTransactionPanel.changeText.text = self.m_data.change
    ExchangeTransactionPanel.newestPriceText.text = self.m_data.lastPrice
    --hide之后m_data会被清空，暂时这么存着
    self.name = self.m_data.name
    self.change = self.m_data.change
    self.lastPrice = self.m_data.lastPrice
    self.isSellState = false
end
---添加移除监听
function ExchangeTransactionCtrl:_addListeners()
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.backBtn.gameObject, self._backBtn, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.buyBtn.gameObject, self._openBuyPart, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.sellBtn.gameObject, self._openSellPart, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.sellChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.buyChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:AddClick(ExchangeTransactionPanel.confirmBtn.gameObject, self._clickConfirm, self);

    Event.AddListener("c_onUpdateSellBuyInfo", self._updateItemTransactionData, self)
    Event.AddListener("c_onExchangeChooseWareHouseBack", self._onExchangeChooseWareHouseBack, self)  --选择仓库完成
end
function ExchangeTransactionCtrl:_removeListeners()
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.backBtn.gameObject, self._backBtn, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.buyBtn.gameObject, self._openBuyPart, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.sellBtn.gameObject, self._openSellPart, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.sellChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.buyChooseBtn.gameObject, self._chooseWareHouse, self);
    self.luaBehaviour:RemoveClick(ExchangeTransactionPanel.confirmBtn.gameObject, self._clickConfirm, self);

    --Event.AddListener("c_onUpdateSellBuyInfo", self._updateItemTransactionData, self)
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
    CityGlobal.OpenCtrl("ExchangeChooseWareHouseCtrl")
end
function ExchangeTransactionCtrl:_clickConfirm(ins)
    local showData = {}
    local str1
    local count
    if ins.isSellState then
        str1 = "sell"
        count = ExchangeTransactionPanel.sellCountInput.text
    else
        str1 = "buy"
        count = ExchangeTransactionPanel.buyCountInput.text
    end
    showData.titleInfo = "REMINDER"
    showData.contentInfo = string.format("Entrust to %s <color=%s>%s</color>x%d?", str1, "#CA8A00", ins.name, count)
    showData.tipInfo = ""
    showData.btnCallBack = function()
        log("cycle_w10_exchange02", "向服务器发送请求")
    end
    CityGlobal.OpenCtrl("BtnDialogPageCtrl", showData)
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
        log("cycle_w10_exchange02", "仓库数据的sell状态与交易界面状态不一致")
        return
    end

    if wareDats.isSell then
        ExchangeTransactionPanel.SellChooseSuccess(wareDats.buildingName)
        self.sellRemainCount = wareDats.remainCount
        local sellCountValue = ExchangeTransactionPanel.sellCountInput.text
        if sellCountValue == "" then  --如果数量还未填写，则显示当前库存量
            ExchangeTransactionPanel.sellCountInput.text = wareDats.remainCount
            ExchangeTransactionPanel.SellChooseSuccess(wareDats.buildingName)
            self.wareHouseChoosed = true
        else
            if tonumber(sellCountValue) > wareDats.remainCount then
                ExchangeTransactionPanel.sellErorTipTran.localScale = Vector3.one
                self.wareHouseChoosed = false
            else
                --ExchangeTransactionPanel.SellChooseSuccess(wareDats.buildingName)
                self.wareHouseChoosed = true
            end
        end
    else
        ExchangeTransactionPanel.BuyChooseSuccess(wareDats.buildingName)
        self.buyCapacityCount = wareDats.capacityCount
        local buyCountValue = ExchangeTransactionPanel.buyCountInput.text
        if buyCountValue == "" then  --如果数量还未填写，则显示当前库存量
            ExchangeTransactionPanel.buyCountInput.text = wareDats.capacityCount
            ExchangeTransactionPanel.BuyChooseSuccess(wareDats.buildingName)
            self.wareHouseChoosed = true
        else
            if tonumber(buyCountValue) > wareDats.capacityCount then
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
end