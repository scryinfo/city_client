---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:45
---
-----
GAucModel= {}
local this = GAucModel
local pbl = pbl
local prefabPools = {}

GAucModel.StartAucPath = "View/Building/AuctionPlanes"
GAucModel.WillAucPath = "View/Building/AuctionWillPlanes"
--GAucModel.BidTime = 180 * 1000
local GroundNowPoolName = "GroundNowObj"
local GroundSoonPoolName = "GroundSoonObj"

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
    --Event.AddListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    --Event.AddListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.AddListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    Event.AddListener("c_UIBubbleLateUpdate", this.c_bubbleLateUpdate)  --temp
end

--网络回调注册
function GAucModel.registerNetMsg()
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundAuction"), GAucModel.n_OnReceiveQueryGroundAuctionInfo)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidGround"), GAucModel.n_OnReceiveBindGround)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidChangeInform"), GAucModel.n_OnReceiveBidChangeInfor)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","auctionEnd"), GAucModel.n_OnReceiveAuctionEnd)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidWinInform"), GAucModel.n_OnReceiveWinBid)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidFailInform"), GAucModel.n_OnReceiveFailBid)

    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryGroundAuction","gs.GroundAuction",GAucModel.n_OnReceiveQueryGroundAuctionInfo)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","bidGround","gs.BidGround",GAucModel.n_OnReceiveBindGround)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","bidChangeInform","gs.BidChange",GAucModel.n_OnReceiveBidChangeInfor)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","auctionEnd","gs.Num",GAucModel.n_OnReceiveAuctionEnd)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","bidWinInform","gs.BidGround",GAucModel.n_OnReceiveWinBid)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","bidFailInform","gs.BidGround",GAucModel.n_OnReceiveFailBid)
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
    this.tempNow = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)
    this.tempSoon = UnityEngine.GameObject.Instantiate(this.groundAucSoonObj)

    prefabPools[GroundNowPoolName] = LuaGameObjectPool:new(GroundNowPoolName, this.tempNow, 25, Vector3.New(-999,-999,-999))
    prefabPools[GroundSoonPoolName] = LuaGameObjectPool:new(GroundSoonPoolName, this.tempSoon, 25, Vector3.New(-999,-999,-999))
end

--拍卖信息更新 bidChangeInform
function GAucModel._updateAucBidInfo(aucData)
    if aucData.ts == nil then
        aucData.ts = TimeSynchronized.GetTheCurrentServerTime()
    end
    local data = {id = aucData.targetId, price = aucData.nowPrice, biderId = aucData.biderId, ts = aucData.ts}
    if data.biderId ~= nil then
        Event.Brocast("c_BidInfoUpdate", data)
    end
end

--收到拍卖中的数据之后的操作
function GAucModel.getNowAucDataFunc(msgGroundAuc)
    if this.groundAucDatas == nil then
        this.groundAucDatas = {}
    end
    local maxId = 0
    for i, value in pairs(msgGroundAuc.auction) do
        if value.id >= maxId then
            maxId = value.id
        end
        --拍卖
        UIBubbleManager._creatGroundAucBubbleItem(value, true)
        UIBubbleManager.startBubble()
    end
    GAucModel.updateSoonItem(maxId)
end
--更新即将拍卖
function GAucModel.updateSoonItem(id)
    local time = TimeSynchronized.GetTheCurrentTime()
    for i = id, #GroundAucConfig do
        if GroundAucConfig[id] == nil then
            return
        end
        if GroundAucConfig[i].beginTime >= time then
            UIBubbleManager._creatGroundAucBubbleItem({id = i}, false)
            MapBubbleManager.groundAucChange(i)
            UIBubbleManager.startBubble()
            return
        end
    end
end

--拍卖结束
function GAucModel.bindEndFunc(endId)
    Event.Brocast("c_BidEnd", endId)  --关闭界面
end

--获取一个有效的item
--function GAucModel._getValuableStartAucObj()
--    if this.valuableStartAucList == nil or #this.valuableStartAucList == 0 then
--        local go = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)
--        go.transform.localScale = Vector3.one
--        go.gameObject.name = "拍卖中"
--        return go
--    else
--        local go = this.valuableStartAucList[1]
--        go.transform.localScale = Vector3.one
--        table.remove(this.valuableStartAucList, 1)
--        return go
--    end
--end
--回收obj
--function GAucModel._returnHistoryObj(go)
--    if this.valuableStartAucList == nil then
--        this.valuableStartAucList = {}
--    end
--    go.transform.localScale = Vector3.zero
--    table.insert(this.valuableStartAucList, 1, go)
--end
--获取有效的即将拍卖的土地预制
--function GAucModel._getValuableWillAucObj()
--    if GAucModel.valuableWillAucObj == nil then
--        GAucModel.valuableWillAucObj = UnityEngine.GameObject.Instantiate(this.groundAucSoonObj)
--    end
--    GAucModel.valuableWillAucObj.transform.localScale = Vector3.one
--    return GAucModel.valuableWillAucObj
--end

--获取拍卖中的预制
function GAucModel._getValuableStartAucObj(groundData)
    local table
    if groundData ~= nil then
        table = {}
        for i, value in ipairs(groundData) do
            local obj = prefabPools[GroundNowPoolName]:GetAvailableGameObject()
            local pos = Vector3.New(value.x, 0.01, value.y)
            obj.transform.position = pos
            table[i] = obj
        end
    end
    return table
end
--获取即将拍卖的预制
function GAucModel._getValuableWillAucObj(groundData)
    local table
    if groundData ~= nil then
        table = {}
        for i, value in ipairs(groundData) do
            local obj = prefabPools[GroundSoonPoolName]:GetAvailableGameObject()
            local pos = Vector3.New(value.x, 0.01, value.y)
            obj.transform.position = pos
            table[i] = obj
        end
    end
    return table
end
--Soon回收
function GAucModel._returnSoonToPool(table)
    if prefabPools[GroundSoonPoolName] == nil then
        return
    end
    if table ~= nil then
        for i, obj in pairs(table) do
            if obj ~= nil then
                prefabPools[GroundSoonPoolName]:RecyclingGameObjectToPool(obj.gameObject)
            end
        end
    end
end
--Now回收
function GAucModel._returnNowToPool(table)
    if prefabPools[GroundNowPoolName] == nil then
        return
    end
    if table ~= nil then
        for i, obj in pairs(table) do
            if obj ~= nil then
                prefabPools[GroundNowPoolName]:RecyclingGameObjectToPool(obj.gameObject)
            end
        end
    end
end

--- 客户端请求 ---
--请求拍卖中的土地信息
function GAucModel.m_ReqQueryGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--出价
function GAucModel.m_BidGround(id, price)
    local temp = tonumber(CityLuaUtil.scientificNotation2Normal(price))
    local msgId = pbl.enum("gscode.OpCode","bidGround")
    local lMsg = { id = id, num = temp}
    local pMsg = assert(pbl.encode("gs.BidGround", lMsg))
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
function GAucModel.n_OnReceiveQueryGroundAuctionInfo(stream, msgId)

    if stream == nil or stream == "" or stream.auction == nil then
        local time = TimeSynchronized.GetTheCurrentTime()
        for i, value in ipairs(GroundAucConfig) do
            if value.beginTime > time then
                GAucModel.updateSoonItem(i)
                return
            end
        end
        return
    end
    local msgGroundAuc = stream
    if msgGroundAuc == nil then
        return
    end

    this.getNowAucDataFunc(msgGroundAuc)

end

--拍卖出价回调 --出价成功之后会不会有提示信息？
function GAucModel.n_OnReceiveBindGround(stream, msgId)
    if msgId == 0 then
        local showData = {}
        showData.titleInfo = GetLanguage(24020009)
        showData.contentInfo = GetLanguage(21010010)
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
        return
    end
    if stream == nil or stream == "" then
        return
    end

    local info = {}
    info.titleInfo = GetLanguage(21010005)
    info.contentInfo = GetLanguage(21010007)
    info.tipInfo = string.format("(%s)", GetLanguage(21010006))
    ct.OpenCtrl("BtnDialogPageCtrl", info)
end

--收到服务器拍卖信息更新
function GAucModel.n_OnReceiveBidChangeInfor(stream, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnReceiveBidChangeInfor："..stream.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    if stream == nil or stream == "" then
        return
    end
    local bidInfo = stream
    if bidInfo then
        this._updateAucBidInfo(bidInfo)
    end
end

--拍卖结束
function GAucModel.n_OnReceiveAuctionEnd(stream, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnReceiveAuctionEnd："..stream.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    if stream == nil or stream == "" then
        return
    end

    local endId = stream
    GAucModel.bindEndFunc(endId.num)
end

--拍卖成功
function GAucModel.n_OnReceiveWinBid(stream, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnReceiveWinBid："..stream.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    if stream == nil or stream == "" then
        return
    end

    if stream then
        Event.Brocast("SmallPop", GetLanguage(21010014), 300)
    end
end
--拍卖失败
function GAucModel.n_OnReceiveFailBid(stream, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnReceiveFailBid："..stream.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    if stream == nil or stream == "" then
        return
    end

    local bidInfo = stream
    if bidInfo then
        Event.Brocast("SmallPop", GetLanguage(21010013), 300)
    end
end
