---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 19:19
---
local transform;
local gameObject;

GroundAuctionPanel = {};
local this = GroundAuctionPanel;

function GroundAuctionPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    UpdateBeat:Add(this.Update, this);

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--Update
function GroundAuctionPanel:Update()
    --如果还没打开过界面
    if not gameObject then
        return
    end

    GroundAuctionPanel.WaitForBidTimeDown()
    GroundAuctionPanel.BidFinishTimeDown()
end

--初始化面板--
function GroundAuctionPanel.InitPanel()
    this.startBidRoot = transform:Find("startBidRoot").gameObject;
    this.startBidTimeDownText = transform:Find("startBidRoot/timeDownText").gameObject:GetComponent("Text");
    this.currentPriceText = transform:Find("startBidRoot/currentPriceText").gameObject:GetComponent("Text");
    this.bidInput = transform:Find("startBidRoot/inputRoot/bidInput").gameObject:GetComponent('InputField');
    this.bidErrorTipText = transform:Find("startBidRoot/inputRoot/errorTipText").gameObject:GetComponent("Text");
    this.bidBtn = transform:Find("startBidRoot/bidBtn").gameObject:GetComponent("Button");
    this.backBtn = transform:Find("backBtn").gameObject:GetComponent("Button");

    this.waitBidRoot = transform:Find("waitBidRoot").gameObject;
    this.waitBidTimeDownText = transform:Find("waitBidRoot/timeDownText").gameObject:GetComponent("Text");
    this.startBidTimeText = transform:Find("waitBidRoot/startBidText").gameObject:GetComponent("Text");
    this.bidBasePriceText = transform:Find("waitBidRoot/basePriceText").gameObject:GetComponent("Text");
end

--初始化页面信息
function GroundAuctionPanel.InitData(panelData)
    if not panelData then
        return
    end

    this.panelData = panelData
    --如果是已经开始了的，则显示拍卖倒计时界面
    --因为是先获取所有拍卖相关信息之后再点开的UI，所以该有的数据都应该有了
    local timeTemp = os.time()
    if ((panelData.beginTime + panelData.durationSec) > timeTemp and (panelData.isStartBid)) then
        this.startBidRoot.transform.localScale = Vector3.one
        this.waitBidRoot.transform.localScale = Vector3.zero

        if panelData.biderId ~= nil and panelData.price ~= nil then
            this.currentPriceText.text = "当前最高价："..panelData.price
        else
            this.currentPriceText.text = "当前最高价："..panelData.basePrice
        end

        this.StartTimeDownForFinish = true
    else
        this.startBidRoot.transform.localScale = Vector3.zero
        this.waitBidRoot.transform.localScale = Vector3.one

        local timeData = GroundAuctionPanel.FormatUnixTime(panelData.beginTime)
        this.startBidTimeText.text = "开始拍卖时间："..timeData.hour..":"..timeData.minute..":"..timeData.second
        this.StartTimeDownForStart = true
        end

end

--改变为拍卖开始状态--
function GroundAuctionPanel.ChangeToStartBidState(startBidInfo)
    if not gameObject then  --如果还没打开过界面，则不进行任何操作
        return
    end

    if startBidInfo.id ~= this.panelData.id then
        logDebug("当前拍卖土地不是已经打开的土地")
        return
    end

    this.waitBidRoot.transform.localScale = Vector3.zero
    this.startBidRoot.transform.localScale = Vector3.one

    this.currentPriceText.text = startBidInfo.num
    --开始拍卖结束倒计时
    this.StartTimeDownForFinish = true
    end

--界面更新拍卖信息--
function GroundAuctionPanel.ChangeBidInfo(newBidInfo)
    if newBidInfo.id ~= this.panelData.id then
        return
    end

    this.currentPriceText.text = newBidInfo.num
end

--拍卖结束--
function GroundAuctionPanel.BidEnd()

end



---倒计时---
--即将拍卖倒计时
function GroundAuctionPanel.WaitForBidTimeDown()
    if this.StartTimeDownForStart then
        local finishTime = this.panelData.beginTime
        this.currentTime = this.currentTime or os.time()
        this.currentTime = this.currentTime + UnityEngine.Time.unscaledDeltaTime

        local remainTime = finishTime - this.currentTime
        if remainTime < 0 then
            this.StartTimeDownForStart = false
            return
        end

        remainTime = GroundAuctionPanel.FormatUnixTime(remainTime)
        local timeStr = remainTime.minute..":"..remainTime.second
        this.waitBidTimeDownText.text = "开始拍卖倒计时："..timeStr

        if this.currentTime >= finishTime then
            logDebug("------ 拍卖panel，开始拍卖")
            this.StartTimeDownForStart = false
            return
        end

    end
end

--拍卖结束倒计时
function GroundAuctionPanel.BidFinishTimeDown()
    if this.StartTimeDownForFinish then
        local finishTime = this.panelData.beginTime + this.panelData.durationSec
        this.currentTime = this.currentTime or os.time()
        this.currentTime = this.currentTime + UnityEngine.Time.unscaledDeltaTime

        local remainTime = finishTime - this.currentTime
        if remainTime < 0 then
            this.StartTimeDownForFinish = false
            return
        end

        remainTime = GroundAuctionPanel.FormatUnixTime(remainTime)
        local timeStr = remainTime.minute..":"..remainTime.second
        this.startBidTimeDownText.text = "拍卖结束倒计时："..timeStr

        if this.currentTime >= finishTime then
            logDebug("------ 拍卖panel，拍卖结束")
            this.StartTimeDownForFinish = false
            return
        end

    end
end

--把时间 秒转换成xx时xx分xx秒格式
function GroundAuctionPanel.FormatUnixTime(time)
    local tb = {}
    tb.year = tonumber(os.date("%Y", time)) or 0
    tb.month = tonumber(os.date("%m", time)) or 0
    tb.day = tonumber(os.date("%d", time)) or 0
    tb.hour = tonumber(os.date("%H", time)) or 0
    tb.minute = tonumber(os.date("%M", time)) or 0
    tb.second = tonumber(os.date("%S", time)) or 0

    return tb
end