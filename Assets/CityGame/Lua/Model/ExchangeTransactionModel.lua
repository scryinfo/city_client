---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/29 16:52
---
ExchangeTransactionModel = {}
local this = ExchangeTransactionModel
local pbl = pbl

--构建函数--
function ExchangeTransactionModel.New()
    return this
end

function ExchangeTransactionModel.Awake()
    this:OnCreate()
end

--启动事件--
function ExchangeTransactionModel.OnCreate()
    --网络回调注册 网络回调用n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeBuy"), ExchangeTransactionModel.n_OnReceiveExchangeBuy)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeSell"), ExchangeTransactionModel.n_OnReceiveExchangeSell)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","exchangeItemDetailInform"), ExchangeTransactionModel.n_OnReceiveBuySellItemsInfo)

    --本地的回调注册
    Event.AddListener("m_ReqExchangeBuy", this.m_ReqExchangeBuy)
    Event.AddListener("m_ReqExchangeSell", this.m_ReqExchangeSell)
    Event.AddListener("m_ReqExchangeWatchItemDetail", this.m_ReqExchangeWatchItemDetail)
    Event.AddListener("m_ReqExchangeStopWatchItemDetail", this.m_ReqExchangeStopWatchItemDetail)
end

--关闭事件--
function ExchangeTransactionModel.Close()
    --Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
end

--- 客户端请求 ---
--挂买单
function ExchangeTransactionModel.m_ReqExchangeBuy(itemId, num, price, buildingId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeBuy")
    local lMsg = { itemId = itemId, num = num, price = price, buildingId = buildingId}
    local pMsg = assert(pbl.encode("gs.ExchangeBuy", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--挂卖单
function ExchangeTransactionModel.m_ReqExchangeSell(itemId, num, price, buildingId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeSell")
    --local lMsg = { itemId = itemId, num = num, price = price, buildingId = buildingId}
    local lMsg = { itemId = itemId, num = num, price = price, buildingId = "a33eab42-cb75-4c77-bd27-710d299f5591"}  --测试
    local pMsg = assert(pbl.encode("gs.ExchangeSell", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--打开买卖交易界面，开始接受更新信息
function ExchangeTransactionModel.m_ReqExchangeWatchItemDetail(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeWatchItemDetail")
    local lMsg = {num = itemId}
    local pMsg = assert(pbl.encode("gs.Num", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--关闭交易界面
function ExchangeTransactionModel.m_ReqExchangeStopWatchItemDetail(itemId)
    local msgId = pbl.enum("gscode.OpCode", "exchangeStopWatchItemDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

---网络回调
--买单
function ExchangeTransactionModel.n_OnReceiveExchangeBuy(stream)
    local orderId = assert(pbl.decode("gs.Id", stream), "ExchangeTransactionModel.n_OnReceiveExchangeBuy: stream == nil")
    Event.Brocast("c_onReceiveExchangeBuy", orderId)
end
--卖单
function ExchangeTransactionModel.n_OnReceiveExchangeSell(stream)
    local orderId = assert(pbl.decode("gs.Id", stream), "ExchangeTransactionModel.n_OnReceiveExchangeSell: stream == nil")
    Event.Brocast("c_onReceiveExchangeSell", orderId)
end
--买卖界面上下成交
function ExchangeTransactionModel.n_OnReceiveBuySellItemsInfo(stream)
    local itemsInfo = assert(pbl.decode("gs.ExchangeItemDetail", stream), "ExchangeTransactionModel.n_OnReceiveBuySellItemsInfo: stream == nil")
    Event.Brocast("c_onReceiveBuySellItemsInfo", itemsInfo)
end

------测试
function ExchangeTransactionModel._testUUIDToByte(id)
    for i = 1, 16 do

    end
end