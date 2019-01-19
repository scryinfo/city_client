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
    return "Assets/CityGame/Resources/View/GroundAuctionPanel.prefab"
end

function GroundAuctionCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)

    local groundAuctionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.bidBtn.gameObject, self.BidGround, self)
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.backBtn.gameObject, self.UnRegistGroundBid, self)
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.biderProtaitBtn.gameObject, self._clickProtait, self)
end

function GroundAuctionCtrl:Awake(go)
    self.gameObject = go
    UpdateBeat:Add(self._update, self)
end

function GroundAuctionCtrl:Refresh()
    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)  --拍卖信息更新
    Event.AddListener("c_BidEnd", self._bidEnd, self)  --拍卖结束
    Event.AddListener("c_BidStart", self._bidStart, self)  --拍卖开始
    Event.AddListener("c_GetBiderInfo", self._getBiderInfo, self)

    self:_initPanelData()
end

function GroundAuctionCtrl:Hide()
    Event.Brocast("c_ShowGroundBubble")

    self.startTimeDownForStart = false
    self.startTimeDownForFinish = false

    Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.RemoveListener("c_BidEnd", self._bidEnd, self)
    Event.RemoveListener("c_BidStart", self._bidStart, self)
    Event.RemoveListener("c_GetBiderInfo", self._getBiderInfo, self)
    UIPage.Hide(self)
end

function GroundAuctionCtrl:Close()

end

---初始化界面
function GroundAuctionCtrl:_initPanelData()
    Event.Brocast("c_HideGroundBubble")

    if self.m_data == nil then
        return
    end

    self.id = self.m_data.id
    GroundAuctionPanel.bidInput.text = ""
    GroundAuctionPanel.personAverageText.text = 0
    --如果是已经开始了的，则显示拍卖倒计时界面，向服务器发送打开了UI界面，开始接收拍卖信息
    if self.m_data.isStartAuc then
        GAucModel.m_ReqQueryGroundAuction()

        Event.Brocast("m_RegistGroundBidInfor")
        GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one
        GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero
        GroundAuctionPanel.nameText.text = "Floor price :"

        if self.m_data.price == nil then
            GroundAuctionPanel.topRootTran.transform.localScale = Vector3.zero
            GroundAuctionPanel.floorRootTran.transform.localScale = Vector3.one
            GroundAuctionPanel.floorPriceText.text = tostring(self.m_data.basePrice)
        else
            if tonumber(self.m_data.price) > self.m_data.basePrice then
                GroundAuctionPanel.topRootTran.transform.localScale = Vector3.one
                GroundAuctionPanel.floorRootTran.transform.localScale = Vector3.zero
                GroundAuctionPanel.currentPriceText.text = getPriceString(self.m_data.price, 30, 24)
            else
                GroundAuctionPanel.topRootTran.transform.localScale = Vector3.zero
                GroundAuctionPanel.floorRootTran.transform.localScale = Vector3.one
                GroundAuctionPanel.floorPriceText.text = tostring(self.m_data.basePrice)
            end
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

    self.intTime = 1
end

---Update
function GroundAuctionCtrl:_update()
    --如果还没打开过界面
    if self.gameObject == nil then
        return
    end

    --计时器，每秒调用
    self.intTime = self.intTime + UnityEngine.Time.unscaledDeltaTime
    if self.intTime >= 1 then
        self.intTime = 0
        self:SoonTimeDownFunc()
        self:NowTimeDownFunc()
    end
end

---倒计时---
--即将拍卖倒计时
function GroundAuctionCtrl:SoonTimeDownFunc()
    if self.startTimeDownForStart == true then
        local startAucTime = self.m_data.beginTime
        local remainTime = startAucTime - TimeSynchronized.GetTheCurrentTime()
        if remainTime <= 0 then
            self.startTimeDownForStart = false
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.minute..":"..timeTable.second
        GroundAuctionPanel.waitBidTimeDownText.text = timeStr
    end
end
--拍卖结束倒计时
function GroundAuctionCtrl:NowTimeDownFunc()
    if self.startTimeDownForFinish == true then
        local finishTime = self.m_data.beginTime + self.m_data.durationSec
        local remainTime = finishTime - TimeSynchronized.GetTheCurrentTime()
        if remainTime < 0 then
            self.startTimeDownForFinish = false
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.minute..":"..timeTable.second
        GroundAuctionPanel.startBidTimeDownText.text = timeStr
    end
end

--由即将拍卖变成拍卖状态
function GroundAuctionCtrl:_changeToStartBidState(startBidInfo)
    if not self.gameObject then  --如果还没打开过界面，则不进行任何操作
        return
    end

    if startBidInfo.id ~= self.m_data.id then
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
    if bidPrice == "" then
        --打开弹框
        local showData = {}
        showData.titleInfo = "REMINDER"
        showData.contentInfo = "Please enter right price "
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
        return
    end

    --if tonumber(bidPrice) < DataManager.GetMoney() then
    --    Event.Brocast("SmallPop", "您的资金不足", 300)
    --    return
    --end

    if ins.highestPrice == nil then
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

    self.highestPrice = data.price
    GroundAuctionPanel.currentPriceText.text = getPriceString(data.price, 30, 24)
    GroundAuctionPanel.topRootTran.transform.localScale = Vector3.one
    GroundAuctionPanel.floorRootTran.transform.localScale = Vector3.zero
    GroundAuctionPanel.currentPriceText.text = tostring(self.highestPrice)
    self.biderId = data.biderId

    if self.biderId == DataManager.GetMyOwnerID() then
        self.biderInfo = DataManager.GetMyPersonalHomepageInfo()
        self:_setUIInfo(self.biderInfo)
        return
    end
    if self.biderInfo == nil then
        --请求信息
        GAucModel.m_ReqPlayersInfo({[1] = data.id})
    else
        if self.biderInfo.id == data.id then
            --请求信息
            GAucModel.m_ReqPlayersInfo({[1] = data.id})
        end
    end
end
--得到消息
function GroundAuctionCtrl:_getBiderInfo(playerData)
    if playerData.info ~= nil and #playerData.info == 1 and playerData.info[1].id == self.biderId then
        self.biderInfo = playerData.info[1]
        self:_setUIInfo(self.biderInfo)
    end
end
--
function GroundAuctionCtrl:_setUIInfo(playerData)
    GroundAuctionPanel.nameText.text = self.biderInfo.name
    LoadSprite(PlayerHead[playerData.faceId].MainPath, GroundAuctionPanel.biderProtaitImg)
end

--拍卖结束
function GroundAuctionCtrl:_bidEnd(id)
    if id == self.id then
        self.biderInfo = nil
        UIPage.ClosePage()
    end
end
--开始拍卖
function GroundAuctionCtrl:_bidStart(groundData)
    Event.Brocast("m_RegistGroundBidInfor")

    GroundAuctionPanel.bidInput.text = ""
    GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one
    GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero
    self.m_data = groundData

    if self.m_data.biderId then
        GroundAuctionPanel.topRootTran.transform.localScale = Vector3.one
        GroundAuctionPanel.floorRootTran.transform.localScale = Vector3.zero
        GroundAuctionPanel.currentPriceText.text = getPriceString(self.m_data.price, 30, 24)
    else
        GroundAuctionPanel.topRootTran.transform.localScale = Vector3.zero
        GroundAuctionPanel.floorRootTran.transform.localScale = Vector3.one
        GroundAuctionPanel.floorPriceText.text = tostring(self.m_data.basePrice)
    end

    self.startTimeDownForFinish = true  --拍卖结束倒计时
end
--点击头像
function GroundAuctionCtrl:_clickProtait(ins)
    if ins.biderInfo == nil then
        return
    end
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", ins.biderInfo)
end
