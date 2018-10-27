---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/26 17:14
---
ExchangeModel = {}
local this = ExchangeModel
local pbl = pbl

--构建函数--
function ExchangeModel.New()
    return this
end

function ExchangeModel.Awake()
    --UpdateBeat:Add(this.Update, this)
    this:OnCreate()
end

--启动事件--
function ExchangeModel.OnCreate()
    --网络回调注册 网络回调用n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeItemList"), ExchangeModel.n_OnReceiveExchangeItemList)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeMyOrder"), ExchangeModel.n_OnReceiveOrder)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeMyDealLog"), ExchangeModel.n_OnReceiveMyDealLog)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeAllDealLog"), ExchangeModel.n_OnReceiveAllDealLog)

    --本地的回调注册
    Event.AddListener("m_ReqExchangeItemList", this.m_ReqExchangeItemList)
    Event.AddListener("m_ReqExchangeMyOrder", this.m_ReqExchangeMyOrder)
    Event.AddListener("m_ReqExchangeMyDealLog", this.m_ReqExchangeMyDealLog)
    Event.AddListener("m_ReqExchangeAllDealLog", this.m_ReqExchangeAllDealLog)
    Event.AddListener("m_ReqExchangeCollect", this.m_ReqExchangeCollect)
    Event.AddListener("m_ReqExchangeUnCollect", this.m_ReqExchangeUnCollect)
    Event.AddListener("m_ReqExchangeBuy", this.m_ReqExchangeBuy)
    Event.AddListener("m_ReqExchangeSell", this.m_ReqExchangeSell)
    Event.AddListener("m_ReqExchangeCancel", this.m_ReqExchangeCancel)
    Event.AddListener("m_ReqExchangeWatchItemDetail", this.m_ReqExchangeWatchItemDetail)
    Event.AddListener("m_ReqExchangeStopWatchItemDetail", this.m_ReqExchangeStopWatchItemDetail)
    Event.AddListener("m_ReqExchangeGetItemDealHistory", this.m_ReqExchangeGetItemDealHistory)
end

--关闭事件--
function ExchangeModel.Close()
    --Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
end

--- 客户端请求 ---
--请求行情信息
function ExchangeModel.m_ReqExchangeItemList()
    local msgId = pbl.enum("gscode.OpCode", "exchangeItemList")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--挂单信息
function ExchangeModel.m_ReqExchangeMyOrder()
    local msgId = pbl.enum("gscode.OpCode", "exchangeMyOrder")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--成交历史
function ExchangeModel.m_ReqExchangeMyDealLog()
    local msgId = pbl.enum("gscode.OpCode", "exchangeMyDealLog")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--全城成交记录
function ExchangeModel.m_ReqExchangeAllDealLog()
    local msgId = pbl.enum("gscode.OpCode", "exchangeAllDealLog")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--收藏
function ExchangeModel.m_ReqExchangeCollect(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeCollect")
    CityEngineLua.Bundle:newAndSendMsg(msgId, itemId)
end
--取消收藏
function ExchangeModel.m_ReqExchangeUnCollect(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeUnCollect")
    CityEngineLua.Bundle:newAndSendMsg(msgId, itemId)
end
--挂买单
function ExchangeModel.m_ReqExchangeBuy(itemId, num, price, buildingId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeBuy")
    local lMsg = { itemId = itemId, num = num, price = price, buildingId = buildingId}
    local  pMsg = assert(pbl.encode("gs.ExchangeBuy", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--挂卖单
function ExchangeModel.m_ReqExchangeSell(itemId, num, price, buildingId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeSell")
    local lMsg = { itemId = itemId, num = num, price = price, buildingId = buildingId}
    local  pMsg = assert(pbl.encode("gs.ExchangeSell", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--撤单
function ExchangeModel.m_ReqExchangeCancel(id)
    local msgId = pbl.enum("gscode.OpCode", "exchangeCancel")
    CityEngineLua.Bundle:newAndSendMsg(msgId, id)
end
--打开买卖交易界面，开始接受更新信息
function ExchangeModel.m_ReqExchangeWatchItemDetail(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeWatchItemDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, itemId)
end
--关闭交易界面
function ExchangeModel.m_ReqExchangeStopWatchItemDetail(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeStopWatchItemDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, itemId)
end
--详情折线数据
function ExchangeModel.m_ReqExchangeGetItemDealHistory(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeGetItemDealHistory")
    CityEngineLua.Bundle:newAndSendMsg(msgId, itemId)
end

---网络回调
--收到行情信息
function ExchangeModel.n_OnReceiveExchangeItemList(stream)
    local quotesData = assert(pbl.decode("gs.ExchangeItemSummary", stream), "ExchangeModel.n_OnReceiveExchangeItemList: stream == nil")
    Event.Brocast("c_onReceiveExchangeItemList", quotesData)
end
--所有挂单信息
function ExchangeModel.n_OnReceiveOrder(stream)
    local orderData = assert(pbl.decode("gs.exchangeMyOrder", stream), "ExchangeModel.n_OnReceiveOrder: stream == nil")
    Event.Brocast("c_onReceiveExchangeMyOrder", orderData)
end
--自己的成交记录
function ExchangeModel.n_OnReceiveMyDealLog(stream)
    local dealLogData = assert(pbl.decode("gs.exchangeMyDealLog", stream), "ExchangeModel.n_OnReceiveMyDealLog: stream == nil")
    Event.Brocast("c_onReceiveExchangeMyDealLog", dealLogData)
end
--全城成交
function ExchangeModel.n_OnReceiveAllDealLog(stream)
    local allOrderData = assert(pbl.decode("gs.exchangeAllDealLog", stream), "ExchangeModel.n_OnReceiveAllDealLog: stream == nil")
    Event.Brocast("c_onReceiveExchangeAllDealLog", allOrderData)
end