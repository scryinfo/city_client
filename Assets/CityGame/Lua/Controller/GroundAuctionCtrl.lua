---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:55
---
GroundAuctionCtrl = class('GroundAuctionCtrl',UIPage)
UIPage:ResgisterOpen(GroundAuctionCtrl)

function GroundAuctionCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundAuctionCtrl:bundleName()
    return "GroundAuctionPanel"
end

function GroundAuctionCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)

    local groundAuctionBehaviour = obj:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.bidBtn.gameObject, self.BidGround, self)
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.backBtn.gameObject, self.UnRegistGroundBid, self)

    --self:_initPanelData()
end

function GroundAuctionCtrl:Awake(go)
    self.gameObject = go
    UpdateBeat:Add(self._update, self)
end

function GroundAuctionCtrl:Refresh()
    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)  --拍卖信息更新
    Event.AddListener("c_BidEnd", self._bidEnd, self)  --拍卖结束
    Event.AddListener("c_BidStart", self._bidStart, self)  --拍卖开始
    self:_initPanelData()
end

function GroundAuctionCtrl:Hide()
    Event.Brocast("c_ShowGroundBubble")

    self.startTimeDownForStart = false
    self.startTimeDownForFinish = false

    Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.RemoveListener("c_BidEnd", self._bidEnd, self)
    Event.RemoveListener("c_BidStart", self._bidStart, self)
    UIPage.Hide(self)
end

function GroundAuctionCtrl:Close()
    --Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    --Event.RemoveListener("c_NewGroundStartBid", self._changeToStartBidState, self)
end

---初始化界面
function GroundAuctionCtrl:_initPanelData()
    Event.Brocast("c_HideGroundBubble")

    if not self.m_data then
        return
    end

    self.beginTime = self.m_data.beginTime
    self.durationSec = self.m_data.durationSec
    self.currentTime = os.time()
    self.id = self.m_data.id

    GroundAuctionPanel.bidInput.text = ""
    GroundAuctionPanel.personAverageText.text = 0
    --如果是已经开始了的，则显示拍卖倒计时界面，向服务器发送打开了UI界面，开始接收拍卖信息
    if self.m_data.isStartAuc then
        Event.Brocast("m_RegistGroundBidInfor")
        GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one
        GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero

        if self.m_data.price > self.m_data.basePrice then
            GroundAuctionPanel.currentPriceText.text = getPriceString(self.m_data.price, 30, 24)
            GroundAuctionPanel.priceDesText.text = "Top price"
        else
            GroundAuctionPanel.currentPriceText.text = getPriceString(self.m_data.basePrice, 30, 24)
            GroundAuctionPanel.priceDesText.text = "Floor price"
        end

        self.startTimeDownForFinish = true  --拍卖结束倒计时
    else
        GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.zero
        GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.one

        GroundAuctionPanel.waitBidBasePriceText.text = getPriceString(self.m_data.basePrice, 30, 24)
        local timeData = getFormatUnixTime(self.m_data.beginTime)
        GroundAuctionPanel.startBidTimeText.text = timeData.hour..":"..timeData.minute..":"..timeData.second
        self.startTimeDownForStart = true  --即将拍卖倒计时
    end

end

---Update
function GroundAuctionCtrl:_update()
    --如果还没打开过界面
    if not self.gameObject then
        return
    end

    self:_waitForBidTimeDown()
    self:_bidFinishTimeDown()
end

---倒计时---
--即将拍卖倒计时
function GroundAuctionCtrl:_waitForBidTimeDown()
    if self.startTimeDownForStart then
        local finishTime = self.m_data.beginTime
        self.currentTime = self.currentTime or os.time()
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime

        local remainTime = finishTime - self.currentTime
        if remainTime < 0 then
            self.startTimeDownForStart = false
            return
        end

        remainTime = getFormatUnixTime(remainTime)
        --local timeStr = remainTime.hour..":"..remainTime.minute..":"..remainTime.second
        local timeStr = remainTime.minute..":"..remainTime.second
        GroundAuctionPanel.waitBidTimeDownText.text = timeStr

        if self.currentTime >= finishTime then
            self.startTimeDownForStart = false
            return
        end

    end
end

--拍卖结束倒计时
function GroundAuctionCtrl:_bidFinishTimeDown()
    if self.startTimeDownForFinish then
        local finishTime = self.m_data.beginTime + self.m_data.durationSec
        self.currentTime = self.currentTime or os.time()
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime

        local remainTime = finishTime - self.currentTime
        if remainTime < 0 then
            self.startTimeDownForFinish = false
            return
        end

        remainTime = getFormatUnixTime(remainTime)
        --local timeStr = remainTime.hour..":"..remainTime.minute..":"..remainTime.second
        local timeStr = remainTime.minute..":"..remainTime.second
        GroundAuctionPanel.startBidTimeDownText.text = timeStr

        if self.currentTime >= finishTime then
            self.startTimeDownForFinish = false
            return
        end

    end
end

--由即将拍卖变成拍卖状态
function GroundAuctionCtrl:_changeToStartBidState(startBidInfo)
    if not self.gameObject then  --如果还没打开过界面，则不进行任何操作
        return
    end

    if startBidInfo.id ~= self.m_data.id then
        ct.log("cycle_w6_GroundAuc","[cycle_w6_GroundAuc] ")
        return
    end

    GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero
    GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one

    GroundAuctionPanel.currentPriceText.text = startBidInfo.num
    --开始拍卖结束倒计时
    self.startTimeDownForFinish = true
end

--出价
function GroundAuctionCtrl:BidGround(ins)
    local bidPrice = GroundAuctionPanel.bidInput.text
    if not ins.highestPrice then
        ins.highestPrice = ins.m_data.basePrice
    end
    if tonumber(bidPrice) > ins.highestPrice then
        Event.Brocast("m_PlayerBidGround", ins.m_data.id, bidPrice)
    else
        --打开弹框
        local showData = {}
        showData.titleInfo = "REMINDER"
        showData.contentInfo = "Your price should be higher then "..ins.highestPrice
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
    end

end

---正在拍卖中的地块关闭了界面 --停止接收拍卖价格的更新
function GroundAuctionCtrl:UnRegistGroundBid(table)
    if table.m_data.isStartAuc then
        Event.Brocast("m_UnRegistGroundBidInfor")
    end
    UIPage.ClosePage()
end

---拍卖信息更新
function GroundAuctionCtrl:_bidInfoUpdate(data)
    if data.id ~= self.m_data.id then
        return
    end

    self.highestPrice = data.num
    GroundAuctionPanel.currentPriceText.text = getPriceString(data.num, 30, 24)
    GroundAuctionPanel.priceDesText.text = "Top price"
    GroundAuctionPanel.ChangeBidInfo(data)
end
--拍卖结束
function GroundAuctionCtrl:_bidEnd(id)
    if id == self.id then
        UIPage.ClosePage()
    end
end
--开始拍卖
function GroundAuctionCtrl:_bidStart(groundData)
    self.beginTime = self.m_data.beginTime
    self.durationSec = self.m_data.durationSec
    self.currentTime = os.time()

    GroundAuctionPanel.bidInput.text = ""
    GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one
    GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero
    self.m_data = groundData

    if self.m_data.biderId then
        GroundAuctionPanel.currentPriceText.text = getPriceString(self.m_data.price, 30, 24)
        GroundAuctionPanel.priceDesText.text = "Top price"
    else
        GroundAuctionPanel.currentPriceText.text = getPriceString(self.m_data.basePrice, 30, 24)
        GroundAuctionPanel.priceDesText.text = "Floor price"
    end

    self.startTimeDownForFinish = true  --拍卖结束倒计时
end