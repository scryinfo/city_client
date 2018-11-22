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
end

--启动事件--
function GroundAuctionModel.OnCreate()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundAuction"), GroundAuctionModel.n_OnReceiveQueryGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidGround"), GroundAuctionModel.n_OnReceiveBindGround)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryMetaGroundAuction"), GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidChangeInform"), GroundAuctionModel.n_OnReceiveBidChangeInfor)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","auctionEnd"), GroundAuctionModel.n_OnReceiveAuctionEnd)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","metaGroundAuctionAddInform"), GroundAuctionModel.n_OnReceiveAddInform)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidWinInform"), GroundAuctionModel.n_OnReceiveWinBid)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","bidFailInform"), GroundAuctionModel.n_OnReceiveFailBid)

    --本地的回调注册
    Event.AddListener("m_PlayerBidGround", this.m_BidGround)
    Event.AddListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.AddListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.AddListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    Event.AddListener("m_GroundAucStateChange", this.m_GroundAucStateChange)
end


--关闭事件--
function GroundAuctionModel.Close()
    Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
    Event.RemoveListener("m_RegistGroundBidInfor", this.m_RegistGroundBidInfor)
    Event.RemoveListener("m_UnRegistGroundBidInfor", this.m_UnRegistGroundBidInfor)
    Event.RemoveListener("m_RoleLoginReqGroundAuction", this.m_RoleLoginReqGroundAuction)
    Event.RemoveListener("m_GroundAucStateChange", this.m_GroundAucStateChange)
end

--角色登录成功之后请求拍卖的信息
function GroundAuctionModel.m_RoleLoginReqGroundAuction()
    this.m_ReqRueryMetaGroundAuction()
    this.m_ReqQueryGroundAuction()
end
--客户端即将拍卖倒计时结束，改变状态
function GroundAuctionModel.m_GroundAucStateChange(groundId)
    if this.groundAucDatas[groundId] then
        local item = this.groundAucDatas[groundId]
        destroy(item.groundObj.gameObject)

        item.isStartAuc = true
        local go = UnityEngine.GameObject.Instantiate(this.groundAucNowObj)  --已经拍卖
        go.transform.localScale = Vector3.one
        go.transform.position = Vector3.New(item.area[1].x, 0, item.area[1].y)
        item.groundObj = go
        Event.Brocast("c_BubbleUpdateItemState", this.groundAucDatas[groundId])  --检查是否数据有变化 --气泡界面的显示
    else
        ct.log("cycle_w6_GroundAuc", "不存在该土地信息错误错误错误")
    end
end
--预先加载两个预制
function GroundAuctionModel._preLoadGroundAucObj()
    this.groundAucNowObj = UnityEngine.Resources.Load(PlayerBuildingBaseData[3000001].prefabRoute)  --已经拍卖
    this.groundAucSoonObj = UnityEngine.Resources.Load(PlayerBuildingBaseData[3000002].prefabRoute)  --即将拍卖
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
    --创建气泡
    ct.OpenCtrl("UIBubbleCtrl", this.groundAucDatas)
end

--当收到所有拍卖的土地信息
function GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo(stream)
    local auctionInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo: stream == nil")
    if #auctionInfo.auction == 0 then
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
    local auctionInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GroundAuctionModel.n_OnReceiveBindGround: stream == nil")
    local count = #auctionInfo.auction
    local staticCount = #this.groundAucDatas
    if #auctionInfo.auction == 0 then
        return
    end

    --if
end

--收到服务器拍卖信息更新
function GroundAuctionModel.n_OnReceiveBidChangeInfor(stream)
    local bidInfo = assert(pbl.decode("gs.IdNum", stream), "GroundAuctionModel.n_OnReceiveBidChangeInfor: stream == nil")
    Event.Brocast("c_BidInfoUpdate", bidInfo)
end

--拍卖结束
function GroundAuctionModel.n_OnReceiveAuctionEnd(stream)
    local endId = assert(pbl.decode("gs.Id", stream), "GroundAuctionModel.n_OnReceiveAuctionEnd: stream == nil")
    --如果拍卖结束，则需要销毁obj
    if this.groundAucDatas[endId] then
        destroy(this.groundAucDatas[endId].groundObj.gameObject)
        this.groundAucDatas[endId] = nil
    end
end

--拍卖成功
function GroundAuctionModel.n_OnReceiveWinBid(stream)
    if stream then

    end
    --需要显示什么数据，是否是直接存储在playerInfo中
end
--拍卖失败
function GroundAuctionModel.n_OnReceiveFailBid(stream)
    if stream then

    end
    --需要显示什么数据，是否是直接存储在playerInfo中
end

--接到新的meta拍卖信息
function GroundAuctionModel.n_OnReceiveAddInform(stream)
    local addInfo = assert(pbl.decode("gs.MetaGroundAuction", stream), "GroundAuctionModel.n_OnReceiveAddInform: stream == nil")
    if #addInfo.auction == 0 then
        return
    end

    --根据新的整个拍卖meta信息实例化气泡 --需要先清空之前存在的气泡
    --参照GroundAuctionModel.n_OnReceivequeryMetaGroundAuctionInfo
    for i, v in ipairs(addInfo.auction) do
        v.bubbleType = BubblleType.GroundAuction
        v.func = function(info)
            if info.bubbleType ~= BubblleType.GroundAuction then
                return
            end
            --GroundAuctionCtrl.OpenPanel(info)  --打开拍卖界面
            UIPage:ShowPage(GroundAuctionCtrl, info)
        end
        GameBubbleManager.CreatBubble(v)
    end

    --实例化完之后，向服务器请求正在拍卖的土地
    this.m_ReqRueryMetaGroundAuction()
end
