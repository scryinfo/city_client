---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:55
---
GroundAuctionCtrl = class('GroundAuctionCtrl',UIPanel)
UIPanel:ResgisterOpen(GroundAuctionCtrl)

GroundAuctionCtrl.static.GAucHistoryPath = "View/Items/GAucHistoryItem"  --历史记录

function GroundAuctionCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.DoNothing, UICollider.None)
end

function GroundAuctionCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GroundAuctionPanel.prefab"
end

function GroundAuctionCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)

    local groundAuctionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.bidBtn.gameObject, self.BidGround, self)
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.backBtn.gameObject, self.UnRegistGroundBid, self)
    GroundAuctionPanel.bidInput.onValueChanged:AddListener(function (str)
        local temp = ct.getCorrectPrice(str)
        GroundAuctionPanel.bidInput.text = temp
    end)
end

function GroundAuctionCtrl:Awake(go)
    self.gameObject = go
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, -1, true)
end

function GroundAuctionCtrl:Active()
    UIPanel.Active(self)
    GroundAuctionPanel.hourText01.text = GetLanguage(20160004)
    GroundAuctionPanel.minuteText02.text = GetLanguage(20160005)
    GroundAuctionPanel.secondText03.text = GetLanguage(20160006)
    GroundAuctionPanel.noneHistoryText04.text = GetLanguage(20160009)
    GroundAuctionPanel.tipText05.text = GetLanguage(21010004)
    GroundAuctionPanel.showText.text = GetLanguage(20160007)
    GroundAuctionPanel.bidBtnText.text = "拍卖"
    GroundAuctionPanel.groundSizeText.text = "土地拍卖的范围"
    GroundAuctionPanel.prosperityText.text = "土地繁荣度"
    --GroundAuctionPanel.titleText.text = GetLanguage(21010001)
end

function GroundAuctionCtrl:Refresh()
    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)  --拍卖信息更新
    Event.AddListener("c_BidEnd", self._bidEnd, self)  --拍卖结束
    Event.AddListener("c_BidStart", self._bidStart, self)  --拍卖开始
    Event.AddListener("c_ReturnGAucHistoryObj", self._returnHistoryObj, self)  --回收历史记录item
    Event.AddListener("_updateShowGroundPerityValue",self._updateShowGroundPerityValue,self)
    if self.m_data.id then
        GAucModel.m_ReqQueryGroundprosPerityValue(self.m_data.id)
    end
    self:_initPanelData()
end

function GroundAuctionCtrl:Hide()
    Event.Brocast("c_ShowGroundBubble")

    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end

    self.startTimeDownForStart = false
    self.startTimeDownForFinish = false
    self.highestPrice = nil
    self.bidHistory = nil
    self:_cleanHistoryObj()

    Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.RemoveListener("c_BidEnd", self._bidEnd, self)
    Event.RemoveListener("c_BidStart", self._bidStart, self)
    Event.RemoveListener("c_ReturnGAucHistoryObj", self._returnHistoryObj, self)
    Event.RemoveListener("_updateShowGroundPerityValue",self._updateShowGroundPerityValue,self)

    UIPanel.Hide(self)
end

function GroundAuctionCtrl:Close()
    UIPanel.Close(self)
end

function GroundAuctionCtrl:_itemTimer()
    self:SoonTimeDownFunc()
    self:NowTimeDownFunc()
end

---初始化界面
function GroundAuctionCtrl:_initPanelData()
    Event.Brocast("c_HideGroundBubble")
    if self.m_data == nil then
        return
    end
    self.m_Timer:Start()
    self.id = self.m_data.id
    --拍卖中土地规格
    GroundAuctionPanel.groundSizeValue.text = #GroundAucConfig[self.m_data.id].area
    GroundAuctionPanel.bidInput.text = ""
    local groundInfo = GroundAucConfig[self.m_data.id]
    --如果开始拍卖，还需判断是否有人出价
    if self.m_data.isStartAuc then
        GroundAuctionPanel.setSoonAndNow(true)
        GroundAuctionPanel.showValueText.text = string.format("<color=%s>E%s</color>", MapRightGroundTransPage.moneyColor, GetClientPriceString(groundInfo.basePrice))
        --self:refreshNow(groundInfo.basePrice)

        --判断是否有人出价
        if self.m_data.endTs == nil or self.m_data.endTs == 0 then
            GroundAuctionPanel.setBidState(false)
            self:setTimeValue(0)
        else
            GroundAuctionPanel.setBidState(true)
            self.bidHistory = ct.deepCopy(self.m_data.bidHistory)
            self:_createHistory()

            self.highestPrice = GetClientPriceString(self.bidHistory[1].price)
            GroundAuctionPanel.historyContent.localPosition = Vector2.zero
            self.startTimeDownForFinish = true  --拍卖结束倒计时
            self:NowTimeDownFunc()
        end
        Event.Brocast("m_RegistGroundBidInfor")
    else
        GroundAuctionPanel.setSoonAndNow(false)
        self:refreshSoon(groundInfo.beginTime, groundInfo.basePrice)
        self.startTimeDownForStart = true  --即将拍卖倒计时
        self:SoonTimeDownFunc()
    end
end
--------------------------------------------------------------------
--刷新开始拍卖的显示数据
function GroundAuctionCtrl:refreshNow(basePrice)
    --if self.nowPriceItem == nil then
    --    self.nowPriceItem = MapRightShowInfoItem:new(GroundAuctionPanel.nowPrice)
    --end
    --local str = string.format("<color=%s>E%s</color>", MapRightGroundTransPage.moneyColor, GetClientPriceString(basePrice))
    --local tempData = {infoTypeStr = "GAucPrice", value = str}
    --self.nowPriceItem:initData(tempData)
end
--刷新即将拍卖的显示数据
function GroundAuctionCtrl:refreshSoon(beginTime, basePrice)
    if self.soonStartTimeItem == nil then
        self.soonStartTimeItem = MapRightShowInfoItem:new(GroundAuctionPanel.soonStartTime)
    end
    if self.soonPriceItem == nil then
        self.soonPriceItem = MapRightShowInfoItem:new(GroundAuctionPanel.soonPrice)
    end
    local timeData = getFormatUnixTime(beginTime)
    local str1 = timeData.hour..":"..timeData.minute..":"..timeData.second
    local tempData1 = {infoTypeStr = "GAucTime", value = str1}
    self.soonStartTimeItem:initData(tempData1)
    local str2 = string.format("<color=%s>E%s</color>", MapRightGroundTransPage.moneyColor, GetClientPriceString(basePrice))
    local tempData2 = {infoTypeStr = "GAucPrice", value = str2}
    self.soonPriceItem:initData(tempData2)
end
--
function GroundAuctionCtrl:setTimeValue(remainTime)
    local timeTable = getTimeTable(remainTime)
    local hour = self:getValuableStr(timeTable.hour)
    local minute = self:getValuableStr(timeTable.minute)
    local second = self:getValuableStr(timeTable.second)
    GroundAuctionPanel.timeDownText.text = string.format("%s     %s     %s", hour, minute, second)
end
--
function GroundAuctionCtrl:getValuableStr(str)
    if string.len(str) ~= 2 then
        return
    end
    local firstChar = string.sub(str, 1, 1)
    local secondChar = string.sub(str, 2, 2)
    return firstChar.."   "..secondChar
end
--------------------------------------------------------------------
--历史记录简易池
function GroundAuctionCtrl:_createHistory()
    self:_cleanHistory()  --清除history item

    table.sort(self.bidHistory, function (m, n) return m.ts > n.ts end)
    for i, value in ipairs(self.bidHistory) do
        if i == 1 then
            value.isFirst = true
        else
            value.isFirst = false
        end
        local go = self:_getValuableHistoryObj()
        go.transform:SetParent(GroundAuctionPanel.historyContent.transform)
        go.transform.localScale = Vector3.one
        self.historyLuaItems[i] = MapGAucHistoryItem:new(value, go.transform)
    end
end
--获取一个有效的item
function GroundAuctionCtrl:_getValuableHistoryObj()
    if self.historyObjs == nil or #self.historyObjs == 0 then
        local go = UnityEngine.GameObject.Instantiate(GroundAuctionPanel.historyItemPrefab)
        --go.transform.localScale = Vector3.one
        return go
    else
        local go = self.historyObjs[1]
        --go.transform.localScale = Vector3.one
        table.remove(self.historyObjs, 1)
        return go
    end
end
--回收obj
function GroundAuctionCtrl:_returnHistoryObj(go)
    if self.historyObjs == nil then
        self.historyObjs = {}
    end
    go.transform:SetParent(GroundAuctionPanel.historyRoot.transform)
    go.transform.localScale = Vector3.zero
    table.insert(self.historyObjs, 1, go)
end
--更新显示拍卖中地块的繁荣度
function GroundAuctionCtrl:_updateShowGroundPerityValue(data)
    GroundAuctionPanel.prosperityValue.text = data.prosperity
end
--隐藏界面时，清掉记录
function GroundAuctionCtrl:_cleanHistoryObj()
    if self.historyObjs == nil then
        return
    end
    for i, go in pairs(self.historyObjs) do
        go.transform:SetParent(GroundAuctionPanel.historyRoot.transform)
        go.transform.localScale = Vector3.zero
    end
end

---倒计时---
--即将拍卖倒计时
function GroundAuctionCtrl:SoonTimeDownFunc()
    if self.startTimeDownForStart == true then
        local startAucTime = GroundAucConfig[self.m_data.id].beginTime * 1000
        local remainTime = startAucTime - TimeSynchronized.GetTheCurrentServerTime()
        if remainTime <= 0 then
            self.startTimeDownForStart = false
            return
        end
        self:setTimeValue(remainTime / 1000)
    end
end
--拍卖结束倒计时
function GroundAuctionCtrl:NowTimeDownFunc()
    if self.startTimeDownForFinish == true then
        if self.m_data.endTs == nil then
            return
        end
        local finishTime = self.m_data.endTs
        local remainTime = finishTime - TimeSynchronized.GetTheCurrentServerTime()
        if remainTime < 0 then
            self.startTimeDownForFinish = false
            return
        end
        self:setTimeValue(remainTime / 1000)
    end
end

--出价
function GroundAuctionCtrl:BidGround(ins)
    PlayMusEff(1005)
    local bidPrice = GroundAuctionPanel.bidInput.text
    if bidPrice == "" then
        --打开弹框
        local showData = {}
        showData.titleInfo = GetLanguage(24020009)
        showData.contentInfo = GetLanguage(22070001)
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
        return
    end

    local mMoney = tonumber(GetClientPriceString(DataManager.GetMoney()))
    if tonumber(bidPrice) > mMoney  then
        Event.Brocast("SmallPop", GetLanguage(41010006), 300)
        return
    end

    if ins.highestPrice == nil then
        ins.highestPrice = tonumber(GetClientPriceString(GroundAucConfig[ins.m_data.id].basePrice))
    end

    if GetServerPriceNumber(tonumber(bidPrice)) > GetServerPriceNumber(tonumber(ins.highestPrice)) then
        Event.Brocast("m_PlayerBidGround", ins.m_data.id, GetServerPriceNumber(bidPrice))
    else
        --打开弹框
        local showData = {}
        showData.titleInfo = GetLanguage(24020009)
        showData.contentInfo = GetLanguage(21010010)
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
    end
end

---正在拍卖中的地块关闭了界面 --停止接收拍卖价格的更新
function GroundAuctionCtrl:UnRegistGroundBid(ins)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

---拍卖信息更新
function GroundAuctionCtrl:_bidInfoUpdate(data)
    if data.id ~= self.m_data.id then
        return
    end

    GroundAuctionPanel.setBidState(true)
    self:_checkHighestPrice(data)

    self:_cleanHistory()  --清除history item
    self:_createHistory()
    self.startTimeDownForFinish = true
end
--判断是否是最高价
function GroundAuctionCtrl:_checkHighestPrice(data)
    if self.bidHistory == nil or #self.bidHistory == 0 then
        self.bidHistory = {}
        local temp = {biderId = data.biderId, price = data.price, ts = data.ts}
        self.highestPrice = GetClientPriceString(temp.price)
        table.insert(self.bidHistory, 1, temp)
        self.m_data.endTs = data.ts + GAucModel.BidTime
        return
    end

    local tempHigh = self.bidHistory[1]
    if tempHigh.price < data.price then
        local temp = {biderId = data.biderId, price = data.price, ts = data.ts}
        table.insert(self.bidHistory, 1, temp)
        self.highestPrice = GetClientPriceString(temp.price)
        self.m_data.endTs = data.ts + GAucModel.BidTime
    end
end
--清除历史item
function GroundAuctionCtrl:_cleanHistory()
    if self.historyLuaItems ~= nil and #self.historyLuaItems ~= 0 then
        for i, value in pairs(self.historyLuaItems) do
            value:close()
            value = nil
        end
    end
    self.historyLuaItems = {}
end

--拍卖结束
function GroundAuctionCtrl:_bidEnd(id)
    if id == self.id then
        self.biderInfo = nil
        self.highestPrice = nil
        UIPanel.CloseAllPageExceptMain()
    end
end
--开始拍卖
function GroundAuctionCtrl:_bidStart(groundData)
    if groundData.id ~= self.m_data.id then
        return
    end
    --Event.Brocast("m_RegistGroundBidInfor")

    GroundAuctionPanel.bidInput.text = ""
    GroundAuctionPanel.setSoonAndNow(true)
    GroundAuctionPanel.setBidState(false)
    self:refreshNow(GroundAucConfig[self.m_data.id].basePrice)
end
