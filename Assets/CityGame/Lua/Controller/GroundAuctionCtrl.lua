---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:55
---

require('Framework/UI/UIPage')
local class = require 'Framework/class'

GroundAuctionCtrl = class('GroundAuctionCtrl',UIPage)

function GroundAuctionCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundAuctionCtrl:bundleName()
    return "GroundAuction"
end

function GroundAuctionCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)

    local groundAuctionBehaviour = obj:GetComponent('LuaBehaviour');
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.bidBtn.gameObject, self.BidGround, self);
    groundAuctionBehaviour:AddClick(GroundAuctionPanel.backBtn.gameObject, self.UnRegistGroundBid, self);

    self:_initPanelData()

    --如果已经开始拍卖，则向服务器发送打开了UI界面，开始接收拍卖信息
    if self.m_data.isStartBid then
        Event.Brocast("m_RegistGroundBidInfor");
    end

    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate);  --拍卖信息更新
    Event.AddListener("c_NewGroundStartBid", self._changeToStartBidState);  --土地开始拍卖
end

function GroundAuctionCtrl:Awake(go)
    self.gameObject = go
    UpdateBeat:Add(self._update, self);
end

function GroundAuctionCtrl:Refresh()
    self:_initPanelData()
end

function GroundAuctionCtrl:Close()
    Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate);
    Event.RemoveListener("c_NewGroundStartBid", self._changeToStartBidState);
end

---初始化界面
function GroundAuctionCtrl:_initPanelData()
    if not self.m_data then
        return
    end

    --如果是已经开始了的，则显示拍卖倒计时界面
    local timeTemp = os.time()
    if ((self.m_data.beginTime + self.m_data.durationSec) > timeTemp and (self.m_data.isStartBid)) then
        GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one
        GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero

        if self.m_data.biderId ~= nil and self.m_data.price ~= nil then
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
        local timeStr = remainTime.hour..":"..remainTime.minute..":"..remainTime.second
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
        local timeStr = remainTime.hour..":"..remainTime.minute..":"..remainTime.second
        GroundAuctionPanel.startBidTimeDownText.text = timeStr

        if self.currentTime >= finishTime then
            self.startTimeDownForFinish = false
            return
        end

    end
end

---由即将拍卖变成拍卖状态
function GroundAuctionCtrl:_changeToStartBidState(startBidInfo)
    if not self.gameObject then  --如果还没打开过界面，则不进行任何操作
        return
    end

    if startBidInfo.id ~= self.m_data.id then
        log("cycle_w6_GroundAuc","[cycle_w6_GroundAuc] ")
        return
    end

    GroundAuctionPanel.waitBidRoot.transform.localScale = Vector3.zero
    GroundAuctionPanel.startBidRoot.transform.localScale = Vector3.one

    GroundAuctionPanel.currentPriceText.text = startBidInfo.num
    --开始拍卖结束倒计时
    self.startTimeDownForFinish = true
end

---出价
function GroundAuctionCtrl:BidGround(table)
    local bidPrice = GroundAuctionPanel.bidInput.text;

    Event.Brocast("m_PlayerBidGround", table.m_data.id, bidPrice);
end

---正在拍卖中的地块关闭了界面 --停止接收拍卖价格的更新
function GroundAuctionCtrl:UnRegistGroundBid(table)
    if table.m_data.isStartBid then
        Event.Brocast("m_UnRegistGroundBidInfor");
    end
end

---拍卖信息更新
function GroundAuctionCtrl:_bidInfoUpdate(data)
    GroundAuctionPanel.ChangeBidInfo(data)

    if data.id == self.m_data.id then
        local info = {}
        info.titleInfo = "CONGRATULATION";
        info.contentInfo = "Success!!!!";
        info.tipInfo = "lalalalalalalalla";
        info.btnCallBack = function ()
            log("cycle_w6_houseAndGround","[cycle_w6_houseAndGround] 回调啊回调")
        end;
        UIPage:ShowPage(BtnDialogPageCtrl, info)
    end
end

---出价失败
function GroundAuctionCtrl:_bidFailFunc(data)

end