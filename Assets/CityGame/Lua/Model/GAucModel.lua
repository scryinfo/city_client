---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:45
---
-----
GAucModel= {}
local this = GAucModel
local pbl = pbl

GAucModel.StartAucPath = "View/Building/AuctionPlanes"
GAucModel.WillAucPath = "View/Building/AuctionWillPlanes"

--构建函数--
function GAucModel.New()
    return this
end

function GAucModel.Awake()
    this:OnCreate()
    this._preLoadGroundAucObj()
    UpdateBeat:Add(this._update, this)
end

--启动事件--
function GAucModel.OnCreate()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundAuction"), GAucModel.n_OnReceiveQueryGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidGround"), GAucModel.n_OnReceiveBindGround)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryMetaGroundAuction"), GAucModel.n_OnReceivequeryMetaGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidChangeInform"), GAucModel.n_OnReceiveBidChangeInfor)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","auctionEnd"), GAucModel.n_OnReceiveAuctionEnd)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","metaGroundAuctionAddInform"), GAucModel.n_OnReceiveAddInform)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidWinInform"), GAucModel.n_OnReceiveWinBid)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidFailInform"), GAucModel.n_OnReceiveFailBid)

    --本地的回调注册
    Event.AddListener("m_PlayerBidGround", this.m_BidGround)
    Event.AddListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.AddListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.AddListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    Event.AddListener("c_UIBubbleLateUpdate", this.c_bubbleLateUpdate)  --temp
end

function GAucModel.c_bubbleLateUpdate()
    UIBubbleManager._cameraLateUpdate()
end

--关闭事件--
function GAucModel.Close()
    Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
    Event.RemoveListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.RemoveListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.RemoveListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    --Event.RemoveListener("m_GroundAucStateChange", this.m_GroundAucStateChange)
end
---一直检测拍卖的状态信息
function GAucModel._update()
    if this.orderAucDatas ~= nil and #this.orderAucDatas > 0 then
        --this._nowTimeDown()
        this._soonTimeDown()
    end
end

--即将拍卖，拍卖倒计时
function GAucModel._soonTimeDown()
    if this.soonAucGroundData == nil then
        return
    end

    this.intTime = this.intTime + UnityEngine.Time.unscaledDeltaTime
    if this.intTime >= 1 then
        this.intTime = 0

        local beginTime = this.soonAucGroundData.beginTime
        if beginTime <= TimeSynchronized.GetTheCurrentTime() then
            this._checkSoonData()
            return
        end
    end
end
-----------------------------------------------------------------------------------

--角色登录成功之后请求拍卖的信息
function GAucModel.m_RoleLoginReqGroundAuction()
    this.m_ReqRueryMetaGroundAuction()
end

--预先加载两个预制
function GAucModel._preLoadGroundAucObj()
    this.groundAucNowObj = UnityEngine.Resources.Load(GAucModel.StartAucPath)  --已经拍卖
    this.groundAucSoonObj = UnityEngine.Resources.Load(GAucModel.WillAucPath)  --即将拍卖
end

--拍卖信息更新
function GAucModel._updateAucBidInfo(aucData)
    local data = {id = aucData.targetId, num = aucData.nowPrice, biderId = aucData.biderId}
    if data.biderId ~= nil then
        Event.Brocast("c_BidInfoUpdate", data)
    end
end
--收到meta数据之后的操作
function GAucModel.getMataGroundDataFunc(auctionInfo)
    UIBubbleManager.startBubble()

    --填充数据
    if this.groundAucDatas == nil then
        this.groundAucDatas = {}
    end
    for i, item in ipairs(auctionInfo.auction) do
        item.beginTime = item.beginTime / 1000
        item.durationSec = item.durationSec / 1000
        this.groundAucDatas[item.id] = item
    end

    this._getOrderGroundDatas(this.groundAucDatas)  --获取时间顺序表
    this.getFirstNowData()  --创建拍卖中的item
    this._checkSoonData()  --创建即将拍卖item
    this._moveToAucPos()

    --this.m_ReqQueryGroundAuction()  --请求拍卖中的气泡
end

--收到拍卖中的数据之后的操作
function GAucModel.getNowAucDataFunc(msgGroundAuc)
    --得到所有拍卖土地的出价信息
    for i, item in ipairs(msgGroundAuc.auction) do
        if this.groundAucDatas[item.id] then
            this.groundAucDatas[item.id].biderId = item.biderId
            this.groundAucDatas[item.id].price = item.price

            if item.biderId ~= nil then
                local data = {id = item.id, num = item.price, biderId = item.biderId}
                Event.Brocast("c_BidInfoUpdate", data)
            end
        end
    end
end
--拍卖结束
function GAucModel.bindEndFunc(endId)
    Event.Brocast("c_BidEnd", endId)  --关闭界面
end

--获取当前soon And now AucGround，生成气泡
function GAucModel._getOrderGroundDatas(groundData)
    local auction = groundData
    this.orderAucDatas = {}
    for id, value in pairs(auction) do
        this.orderAucDatas[#this.orderAucDatas + 1] = value
    end
    table.sort(this.orderAucDatas, function (m, n) return m.beginTime < n.beginTime end)  --按照时间顺序排序
end
--移动到即将拍卖的位置
function GAucModel._moveToAucPos()
    if GAucModel.valuableWillAucObj ~= nil then
        CameraMove.MoveCameraToPos(GAucModel.valuableWillAucObj.transform.position)
    end
end

--获取有效的开始拍卖的土地预制
function GAucModel._getValuableStartAucObj()
    if GAucModel.valuableStartAucObj == nil then
        GAucModel.valuableStartAucObj = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)
    end
    GAucModel.valuableStartAucObj.transform.localScale = Vector3.one
    GAucModel.valuableStartAucObj.gameObject.name = "拍卖中"
    return GAucModel.valuableStartAucObj
end
--获取有效的即将拍卖的土地预制
function GAucModel._getValuableWillAucObj()
    if GAucModel.valuableWillAucObj == nil then
        GAucModel.valuableWillAucObj = UnityEngine.GameObject.Instantiate(this.groundAucSoonObj)
    end
    GAucModel.valuableWillAucObj.transform.localScale = Vector3.one
    GAucModel.valuableWillAucObj.gameObject.name = "即将拍卖"
    return GAucModel.valuableWillAucObj
end

--确认数据
function GAucModel._checkSoonData()
    local showFirstWait = true
    local sTime = TimeSynchronized.GetTheCurrentTime()
    for i, groundAucItem in ipairs(this.orderAucDatas) do
        --如果已经开始拍卖
        if groundAucItem.beginTime <= sTime then
            table.remove(this.orderAucDatas, i)
        else
            if showFirstWait then
                local data = {}
                data.isStartAuc = false
                local groundObj = GAucModel._getValuableWillAucObj()
                groundObj.transform.position = Vector3.New(groundAucItem.area[1].x, 0, groundAucItem.area[1].y)
                groundObj.transform.localScale = Vector3.one
                data.targetPos = groundObj.transform.position
                data.aucInfo = groundAucItem
                UIBubbleManager._creatGroundAucBubbleItem(data)  --创建一个item
                this.soonAucGroundData = groundAucItem
                this.intTime = 0

                table.remove(this.orderAucDatas, i)
                return
            end
        end
    end
end
--确认拍卖的数据  --只有一开始的时候判断
function GAucModel.getFirstNowData()
    if this.orderAucDatas ~= nil and #this.orderAucDatas then
        local sTime = TimeSynchronized.GetTheCurrentTime()
        for i, value in ipairs(this.orderAucDatas) do
            if value.beginTime < sTime then
                local data = {}
                data.isStartAuc = true
                local groundObj = GAucModel._getValuableStartAucObj()
                groundObj.transform.position = Vector3.New(value.area[1].x, 0, value.area[1].y)  --第二个地块为左上角的位置
                groundObj.transform.localScale = Vector3.one
                data.targetPos = groundObj.transform.position
                data.aucInfo = value
                UIBubbleManager._creatGroundAucBubbleItem(data)  --创建一个item
                table.remove(this.orderAucDatas, i)
            end
        end
        --if this.orderAucDatas[1].beginTime < TimeSynchronized.GetTheCurrentTime() then
        --    local data = {}
        --    data.isStartAuc = true
        --    local groundObj = GAucModel._getValuableStartAucObj()
        --    groundObj.transform.position = Vector3.New(this.orderAucDatas[1].area[1].x, 0, this.orderAucDatas[1].area[1].y)  --第二个地块为左上角的位置
        --    groundObj.transform.localScale = Vector3.one
        --    data.targetPos = groundObj.transform.position
        --    data.aucInfo = this.orderAucDatas[1]
        --    UIBubbleManager._creatGroundAucBubbleItem(data)  --创建一个item
        --    table.remove(this.orderAucDatas, 1)
        --end
    end
end

--- 客户端请求 ---
--请求即将拍卖的土地信息
function GAucModel.m_ReqQueryGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--请求已经拍卖的土地信息
function GAucModel.m_ReqRueryMetaGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryMetaGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--出价
function GAucModel.m_BidGround(id, price)
    local msgId = pbl.enum("gscode.OpCode","bidGround")
    local lMsg = { id = id, num = price}
    local pMsg = assert(pbl.encode("gs.ByteNum", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

--打开UI 开始更新拍卖信息 --请判断打开界面的是否处于拍卖中
function GAucModel.m_RegistGroundBidInfor()
    local msgId = pbl.enum("gscode.OpCode","registGroundBidInform")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--关闭UI
function GAucModel.m_UnRegistGroundBidInfor()
    local msgId = pbl.enum("gscode.OpCode","unregistGroundBidInform")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--- 回调 ---
--收到拍卖中的土地信息
function GAucModel.n_OnReceiveQueryGroundAuctionInfo(stream)
    if stream == nil or stream == "" then
        return
    end
    local msgGroundAuc = assert(pbl.decode("gs.GroundAuction", stream), "GAucModel.n_OnReceiveQueryGroundAuctionInfo: stream == nil")
    if msgGroundAuc == nil or #msgGroundAuc.auction == 0 then
        return
    end

    this.getNowAucDataFunc(msgGroundAuc)
end

--当收到所有拍卖的土地信息
function GAucModel.n_OnReceivequeryMetaGroundAuctionInfo(stream)
    if stream == nil or stream == "" then
        return
    end
    local auctionInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GAucModel.n_OnReceivequeryMetaGroundAuctionInfo: stream == nil")
    if auctionInfo == nil or #auctionInfo.auction == 0 then
        return
    end

    this.getMataGroundDataFunc(auctionInfo)
end

--拍卖出价回调 --出价成功之后会不会有提示信息？
function GAucModel.n_OnReceiveBindGround(stream)
    if stream == nil or stream == "" then
        return
    end

    local auctionInfo = assert(pbl.decode("gs.ByteNum", stream), "GAucModel.n_OnReceiveBindGround: stream == nil")
    if auctionInfo then
        this._updateAucBidInfo(auctionInfo)

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
function GAucModel.n_OnReceiveBidChangeInfor(stream)
    if stream == nil or stream == "" then
        return
    end
    local bidInfo = assert(pbl.decode("gs.BidChange", stream), "GAucModel.n_OnReceiveBidChangeInfor: stream == nil")
    if bidInfo then
        this._updateAucBidInfo(bidInfo)
    end
end

--拍卖结束
function GAucModel.n_OnReceiveAuctionEnd(stream)
    if stream == nil or stream == "" then
        return
    end

    local endId = assert(pbl.decode("gs.Id", stream), "GAucModel.n_OnReceiveAuctionEnd: stream == nil")
    GAucModel.bindEndFunc(endId.id)
end

--拍卖成功
function GAucModel.n_OnReceiveWinBid(stream)
    if stream == nil or stream == "" then
        return
    end

    if stream then
        --local bidInfo = assert(pbl.decode("gs.ByteNUm", stream), "GAucModel.n_OnReceiveBidChangeInfor: stream == nil")
    end
end
--拍卖失败
function GAucModel.n_OnReceiveFailBid(stream)
    if stream == nil or stream == "" then
        return
    end

    local bidInfo = assert(pbl.decode("gs.ByteNum", stream), "GAucModel.n_OnReceiveBidChangeInfor: stream == nil")
    if bidInfo then
        this._updateAucBidInfo(bidInfo)
    end
end

--接到新的meta拍卖信息
function GAucModel.n_OnReceiveAddInform(stream)
    --if stream == nil or stream == "" then
    --    return
    --end
    --
    --local addInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GAucModel.n_OnReceiveAddInform: stream == nil")
    --if #addInfo.auction == 0 then
    --    return
    --end
    --
    ----根据新的整个拍卖meta信息实例化气泡 --需要先清空之前存在的气泡
    ----参照GAucModel.n_OnReceivequeryMetaGroundAuctionInfo
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
