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
    --UpdateBeat:Add(this._update, this)
end

--启动事件--
function GAucModel.OnCreate()
    --本地的回调注册
    Event.AddListener("m_PlayerBidGround", this.m_BidGround)
    Event.AddListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.AddListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.AddListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    Event.AddListener("c_UIBubbleLateUpdate", this.c_bubbleLateUpdate)  --temp
end

--网络回调注册
function GAucModel.registerNetMsg()
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundAuction"), GAucModel.n_OnReceiveQueryGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidGround"), GAucModel.n_OnReceiveBindGround)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryMetaGroundAuction"), GAucModel.n_OnReceivequeryMetaGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidChangeInform"), GAucModel.n_OnReceiveBidChangeInfor)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","auctionEnd"), GAucModel.n_OnReceiveAuctionEnd)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidWinInform"), GAucModel.n_OnReceiveWinBid)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidFailInform"), GAucModel.n_OnReceiveFailBid)
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

-----------------------------------------------------------------------------------

--角色登录成功之后请求拍卖的信息
function GAucModel.m_RoleLoginReqGroundAuction()
    GAucModel.m_ReqQueryGroundAuction()
end

--预先加载两个预制
function GAucModel._preLoadGroundAucObj()
    this.groundAucNowObj = UnityEngine.Resources.Load(GAucModel.StartAucPath)  --已经拍卖
    this.groundAucSoonObj = UnityEngine.Resources.Load(GAucModel.WillAucPath)  --即将拍卖
end

--拍卖信息更新 bidChangeInform
function GAucModel._updateAucBidInfo(aucData)
    local data = {id = aucData.targetId, price = aucData.nowPrice, biderId = aucData.biderId}
    if data.biderId ~= nil then
        Event.Brocast("c_BidInfoUpdate", data)
    end
end

--收到拍卖中的数据之后的操作
function GAucModel.getNowAucDataFunc(msgGroundAuc)
    if this.groundAucDatas == nil then
        this.groundAucDatas = {}
    end
    local lastId = 0
    for i, value in pairs(msgGroundAuc.auction) do
        lastId = value.id
        --拍卖
        UIBubbleManager._creatGroundAucBubbleItem(value)
    end
    --生成即将拍卖的item
    GAucModel.updateSoonItem(lastId + 1)
end
--更新即将拍卖
function GAucModel.updateSoonItem(groundId)
    if GroundAucConfig[groundId] == nil then
        return
    end
    UIBubbleManager._creatGroundAucBubbleItem({id = groundId})
    UIBubbleManager.startBubble()
end

--拍卖结束
function GAucModel.bindEndFunc(endId)
    Event.Brocast("c_BidEnd", endId)  --关闭界面
end

--移动到拍卖的位置
--function GAucModel._moveToAucPos()
--    if GAucModel.valuableStartAucObj ~= nil and GAucModel.valuableStartAucObj.transform.localScale ~= Vector3.zero then
--        CameraMove.MoveCameraToPos(GAucModel.valuableStartAucObj.transform.position)
--        return
--    end
--    if GAucModel.valuableWillAucObj ~= nil and GAucModel.valuableWillAucObj.transform.localScale ~= Vector3.zero then
--        CameraMove.MoveCameraToPos(GAucModel.valuableWillAucObj.transform.position)
--    end
--end

--获取有效的开始拍卖的土地预制
function GAucModel._getValuableStartAucObj()
    if GAucModel.valuableStartAucList ~= nil and #GAucModel.valuableStartAucList ~= 0 then
        for i, value in pairs(GAucModel.valuableStartAucList) do
            if value.transform.localScale == Vector3.zero then
                value.transform.localScale = Vector3.one
                return value
            end
        end
    end

    if GAucModel.valuableStartAucList == nil then
        GAucModel.valuableStartAucList = {}
    end
    local go = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)
    go.transform.localScale = Vector3.one
    go.gameObject.name = "拍卖中"
    table.insert(GAucModel.valuableStartAucList, 1, go)
    return go
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

--- 客户端请求 ---
--请求拍卖中的土地信息
function GAucModel.m_ReqQueryGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--请求已经拍卖的土地信息
function GAucModel.m_ReqRueryMetaGroundAuction()
    --local msgId = pbl.enum("gscode.OpCode","queryMetaGroundAuction")
    --CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
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

--请求玩家信息
function GAucModel.m_ReqPlayersInfo(ids)
    local msgId = pbl.enum("gscode.OpCode","queryPlayerInfo")
    local pMsg = assert(pbl.encode("gs.Bytes", { ids = ids}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

--- 回调 ---
--收到拍卖中的土地信息
function GAucModel.n_OnReceiveQueryGroundAuctionInfo(stream)
    --if stream == nil or stream == "" then
    --    local time = TimeSynchronized.GetTheCurrentTime()
    --    for i, value in ipairs(GroundAucConfig) do
    --        if value.beginTime > time then
    --            GAucModel.updateSoonItem(i)
    --            return
    --        end
    --    end
    --    return
    --end
    --local msgGroundAuc = assert(pbl.decode("gs.GroundAuction", stream), "GAucModel.n_OnReceiveQueryGroundAuctionInfo: stream == nil")
    --if msgGroundAuc == nil then
    --    return
    --end
    --
    --this.getNowAucDataFunc(msgGroundAuc)
end

--当收到所有拍卖的土地信息
function GAucModel.n_OnReceivequeryMetaGroundAuctionInfo(stream)
    --if stream == nil or stream == "" then
    --    return
    --end
    --local auctionInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GAucModel.n_OnReceivequeryMetaGroundAuctionInfo: stream == nil")
    --if auctionInfo == nil or #auctionInfo.auction == 0 then
    --    return
    --end

    --this.getMataGroundDataFunc(auctionInfo)
end

--拍卖出价回调 --出价成功之后会不会有提示信息？
function GAucModel.n_OnReceiveBindGround(stream)
    if stream == nil or stream == "" then
        return
    end

    local auctionInfo = assert(pbl.decode("gs.ByteNum", stream), "GAucModel.n_OnReceiveBindGround: stream == nil")
    if auctionInfo then
        --this._updateAucBidInfo(auctionInfo)

        local info = {}
        info.titleInfo = GetLanguage(22010005)
        info.contentInfo = GetLanguage(22010007)
        info.tipInfo = string.format("(%s)", GetLanguage(22010006))
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
        --this._updateAucBidInfo(bidInfo)
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
