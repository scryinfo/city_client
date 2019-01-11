---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:45
---
-----
GroundAuctionModel= {}
local this = GroundAuctionModel
local pbl = pbl

--构建函数--
function GroundAuctionModel.New()
    return this
end

function GroundAuctionModel.Awake()
    this:OnCreate()
    this._preLoadGroundAucObj()
    UpdateBeat:Add(this._update, this)
end

--启动事件--
function GroundAuctionModel.OnCreate()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundAuction"), GroundAuctionModel.n_OnReceiveQueryGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidGround"), GroundAuctionModel.n_OnReceiveBindGround)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryMetaGroundAuction"), GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidChangeInform"), GroundAuctionModel.n_OnReceiveBidChangeInfor)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","auctionEnd"), GroundAuctionModel.n_OnReceiveAuctionEnd)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","metaGroundAuctionAddInform"), GroundAuctionModel.n_OnReceiveAddInform)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidWinInform"), GroundAuctionModel.n_OnReceiveWinBid)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidFailInform"), GroundAuctionModel.n_OnReceiveFailBid)

    --本地的回调注册
    Event.AddListener("m_PlayerBidGround", this.m_BidGround)
    Event.AddListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.AddListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.AddListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    Event.AddListener("c_UIBubbleLateUpdate", GroundAuctionModel.c_bubbleLateUpdate)  --temp
end

function GroundAuctionModel.c_bubbleLateUpdate()
    UIBubbleCtrl._cameraLateUpdate()
end


--关闭事件--
function GroundAuctionModel.Close()
    Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
    Event.RemoveListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.RemoveListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.RemoveListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    --Event.RemoveListener("m_GroundAucStateChange", this.m_GroundAucStateChange)
end
---一直检测拍卖的状态信息
function GroundAuctionModel._update()
    if this.orderAucDatas and #this.orderAucDatas > 0 then
        this._nowTimeDown()
        this._soonTimeDown()
    end
end

--拍卖中，拍卖结束倒计时
function GroundAuctionModel._nowTimeDown()
    if not this.nowAucGroundData then
        return
    end
    local finishTime = this.nowAucGroundData.beginTime + this.nowAucGroundData.durationSec
    this.tempNowCurrentTime = this.tempNowCurrentTime + UnityEngine.Time.unscaledDeltaTime
    local remainTime = finishTime - this.tempNowCurrentTime

    if remainTime < 0 then
        --拍卖结束
        --重新确认下一个即将拍卖的数据
        if this.nowAucGroundData.beginTime < os.time() then
            Event.Brocast("c_BidEnd", this.nowAucGroundData.id)  --关闭界面

            table.remove(this.orderAucDatas, 1)
            if #this.orderAucDatas == 0 then
                return
            end
            this._checkNowAndSoonData()
            Event.Brocast("c_RefreshItems", {this.nowAucGroundData, this.soonAucGroundData})
        end
    end
end
--即将拍卖，拍卖倒计时
function GroundAuctionModel._soonTimeDown()
    if not this.soonAucGroundData then
        return
    end
    local beginTime = this.soonAucGroundData.beginTime
    local finishTime = this.soonAucGroundData.beginTime + this.soonAucGroundData.durationSec
    --判定，数据是否正确
    if finishTime <= os.time() or beginTime <= os.time() then
        Event.Brocast("c_BidStart", this.soonAucGroundData)
        this._checkNowAndSoonData()
        Event.Brocast("c_RefreshItems", {this.nowAucGroundData, this.soonAucGroundData})
        return
    end
    this.tempSoonCurrentTime = this.tempSoonCurrentTime + UnityEngine.Time.unscaledDeltaTime
    local remainTime = beginTime - this.tempSoonCurrentTime

    ---------------------------
    if remainTime < 0 then
        --即将拍卖
        --重新确认下一个拍卖的数据
        if this.soonAucGroundData.beginTime < os.time() then
            --table.remove(this.orderAucDatas, 1)
            Event.Brocast("c_BidStart", this.soonAucGroundData)
            this._checkNowAndSoonData()
            Event.Brocast("c_RefreshItems", {this.nowAucGroundData, this.soonAucGroundData})
        end
    end
end
-----------------------------------------------------------------------------------

--角色登录成功之后请求拍卖的信息
function GroundAuctionModel.m_RoleLoginReqGroundAuction()
    this.m_ReqRueryMetaGroundAuction()
    this.m_ReqQueryGroundAuction()
end

--预先加载两个预制
function GroundAuctionModel._preLoadGroundAucObj()
    --this.groundAucNowObj = UnityEngine.Resources.Load(PlayerBuildingBaseData[3000001].prefabRoute)  --已经拍卖
    --this.groundAucSoonObj = UnityEngine.Resources.Load(PlayerBuildingBaseData[3000002].prefabRoute)  --即将拍卖

    this.groundAucNowObj = GameObject.New()  --临时数据
    this.groundAucSoonObj = GameObject.New()
end

--拍卖信息更新
function GroundAuctionModel._updateAucBidInfo(data)
    if this.groundAucDatas[data.id] then
        this.groundAucDatas[data.id].price = data.num

        Event.Brocast("c_BidInfoUpdate", data)
    end
end

--获取当前soon And now AucGround，生成气泡
function GroundAuctionModel._getOrderGroundDatas(groundData)
    local auction = groundData
    this.orderAucDatas = {}
    for id, value in pairs(auction) do
        this.orderAucDatas[#this.orderAucDatas + 1] = value
    end
    table.sort(this.orderAucDatas, function (m, n) return m.beginTime < n.beginTime end)  --按照时间顺序排序

    this._checkNowAndSoonData()

    --创建气泡  --最多只有两个状态的气泡
    ct.OpenCtrl("UIBubbleCtrl", {this.nowAucGroundData, this.soonAucGroundData})
end

--确认数据
function GroundAuctionModel._checkNowAndSoonData()
    local showFirstWait = true
    this.soonAucGroundData = nil
    this.nowAucGroundData = nil
    this.tempNowCurrentTime = os.time()
    this.tempSoonCurrentTime = os.time()

    for i, groundAucItem in ipairs(this.orderAucDatas) do
        --如果已经开始拍卖
        if groundAucItem.beginTime <= os.time() then
            groundAucItem.isStartAuc = true

            local groundObj = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)  --已经拍卖
            groundObj.transform.localScale = Vector3.one
            groundObj.transform.position = Vector3.New(groundAucItem.area[1].x, 0, groundAucItem.area[1].y)  --temp 1x1
            groundObj.name = "拍卖中"
            groundAucItem.groundObj = groundObj

            this.nowAucGroundData = groundAucItem
        else
            if showFirstWait then
                if groundAucItem.beginTime <= os.time() then
                    ct.log("cycle_w6_GroundAuc", "-----------时间有问题")
                    return
                end

                groundAucItem.isStartAuc = false

                local groundObj = UnityEngine.GameObject.Instantiate(this.groundAucSoonObj)  --已经拍卖
                groundObj.transform.localScale = Vector3.one
                groundObj.transform.position = Vector3.New(groundAucItem.area[1].x, 0, groundAucItem.area[1].y)  --temp 1x1
                groundObj.name = "即将拍卖"
                groundAucItem.groundObj = groundObj

                this.soonAucGroundData = groundAucItem
                return
            end
        end
    end
end

--- 客户端请求 ---
--请求即将拍卖的土地信息
function GroundAuctionModel.m_ReqQueryGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--请求已经拍卖的土地信息
function GroundAuctionModel.m_ReqRueryMetaGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryMetaGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--出价
function GroundAuctionModel.m_BidGround(id, price)
    local msgId = pbl.enum("gscode.OpCode","bidGround")
    local lMsg = { id = id, num = price}
    local pMsg = assert(pbl.encode("gs.ByteNum", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

--打开UI 开始更新拍卖信息 --请判断打开界面的是否处于拍卖中
function GroundAuctionModel.m_RegistGroundBidInfor()
    local msgId = pbl.enum("gscode.OpCode","registGroundBidInform")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--关闭UI
function GroundAuctionModel.m_UnRegistGroundBidInfor()
    local msgId = pbl.enum("gscode.OpCode","unregistGroundBidInform")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--- 回调 ---
--收到拍卖中的土地信息
function GroundAuctionModel.n_OnReceiveQueryGroundAuctionInfo(stream)
    if stream == nil or stream == "" then
        return
    end
    local msgGroundAuc = assert(pbl.decode("gs.GroundAuction", stream), "GroundAuctionModel.n_OnReceiveQueryGroundAuctionInfo: stream == nil")
    if #msgGroundAuc.auction == 0 then
        return
    end

    --得到所有拍卖土地的出价信息
    for i, item in ipairs(msgGroundAuc.auction) do
        if this.groundAucDatas[item.id] then
            this.groundAucDatas[item.id].biderId = item.biderId
            this.groundAucDatas[item.id].price = item.price
        end
    end
    this._getOrderGroundDatas(this.groundAucDatas)
end

--当收到所有拍卖的土地信息
function GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo(stream)
    if stream == nil or stream == "" then
        return
    end
    local auctionInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo: stream == nil")
    if not auctionInfo or #auctionInfo.auction == 0 then
        return
    end

    --填充数据
    if not this.groundAucDatas then
        this.groundAucDatas = {}
    end
    for i, item in ipairs(auctionInfo.auction) do
        item.beginTime = item.beginTime / 1000
        item.durationSec = item.durationSec / 1000
        this.groundAucDatas[item.id] = item
    end
end

--拍卖出价回调 --出价成功之后会不会有提示信息？
function GroundAuctionModel.n_OnReceiveBindGround(stream)
    if stream == nil or stream == "" then
        return
    end

    local auctionInfo = assert(pbl.decode("gs.ByteNum", stream), "GroundAuctionModel.n_OnReceiveBindGround: stream == nil")
    if auctionInfo then
        this._updateAucBidInfo(auctionInfo)

        --ct.log("cycle_w6_GroundAuc", "啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"..auctionInfo.id)
        GroundAuctionPanel.ChangeBidInfo(auctionInfo)
        local info = {}
        info.titleInfo = "CONGRATULATION"
        info.contentInfo = "Successful participation in auction"
        info.tipInfo = "(if there is a higher bid price we will notify you by meil.)"
        info.btnCallBack = function ()
            ct.log("cycle_w6_houseAndGround","[cycle_w6_houseAndGround] 回调啊回调")
        end
        --UIPage:ShowPage(BtnDialogPageCtrl, info)
        ct.OpenCtrl("BtnDialogPageCtrl", info)
    end
end

--收到服务器拍卖信息更新
function GroundAuctionModel.n_OnReceiveBidChangeInfor(stream)
    if stream == nil or stream == "" then
        return
    end

    local bidInfo = assert(pbl.decode("gs.ByteNum", stream), "GroundAuctionModel.n_OnReceiveBidChangeInfor: stream == nil")
    if bidInfo then
        this._updateAucBidInfo(bidInfo)
    end
end

--拍卖结束
function GroundAuctionModel.n_OnReceiveAuctionEnd(stream)
    if stream == nil or stream == "" then
        return
    end

    local endId = assert(pbl.decode("gs.Id", stream), "GroundAuctionModel.n_OnReceiveAuctionEnd: stream == nil")
    Event.Brocast("c_BidEnd", endId.id)
end

--拍卖成功
function GroundAuctionModel.n_OnReceiveWinBid(stream)
    if stream == nil or stream == "" then
        return
    end

    if stream then
        --local bidInfo = assert(pbl.decode("gs.ByteNUm", stream), "GroundAuctionModel.n_OnReceiveBidChangeInfor: stream == nil")
    end
end
--拍卖失败
function GroundAuctionModel.n_OnReceiveFailBid(stream)
    if stream == nil or stream == "" then
        return
    end

    local bidInfo = assert(pbl.decode("gs.ByteNum", stream), "GroundAuctionModel.n_OnReceiveBidChangeInfor: stream == nil")
    if bidInfo then
        this._updateAucBidInfo(bidInfo)
    end
end

--接到新的meta拍卖信息
function GroundAuctionModel.n_OnReceiveAddInform(stream)
    --if stream == nil or stream == "" then
    --    return
    --end
    --
    --local addInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GroundAuctionModel.n_OnReceiveAddInform: stream == nil")
    --if #addInfo.auction == 0 then
    --    return
    --end
    --
    ----根据新的整个拍卖meta信息实例化气泡 --需要先清空之前存在的气泡
    ----参照GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo
    --for i, v in ipairs(addInfo.auction) do
    --    v.bubbleType = BubblleType.GroundAuction
    --    v.func = function(info)
    --        if info.bubbleType ~= BubblleType.GroundAuction then
    --            return
    --        end
    --        --GroundAuctionCtrl.OpenPanel(info)  --打开拍卖界面
    --        UIPage:ShowPage(GroundAuctionCtrl, info)
    --    end
    --    GameBubbleManager.CreatBubble(v)
    --end
    --
    ----实例化完之后，向服务器请求正在拍卖的土地
    --this.m_ReqRueryMetaGroundAuction()
end
