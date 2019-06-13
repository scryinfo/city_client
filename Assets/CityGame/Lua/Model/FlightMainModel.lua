---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/8/31 10:45
---
-----
FlightMainModel= {}
local this = FlightMainModel

function FlightMainModel.New()
    return this
end

function FlightMainModel.Awake()
    this:OnCreate()
end
--启动事件--
function FlightMainModel.OnCreate()
    --本地的回调注册
    --Event.AddListener("m_PlayerBidGround", this.m_BidGround)
end
--网络回调注册
function FlightMainModel.registerNetMsg()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getAllFlight","gs.Flights",FlightMainModel.n_OnGetAllFlight)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","betFlight","gs.BetFlight",FlightMainModel.n_OnBetFlight)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getFlightBetHistory","gs.FlightBetHistory",FlightMainModel.n_OnGetBetHistory)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","flightBetInform","gs.FlightBetInform",FlightMainModel.n_OnGetBetResult)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","scoreChangeInform","gs.Num",FlightMainModel.n_OnFlightScoreChange)

end
--关闭事件--
function FlightMainModel.Close()
    --Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
end

--客户端请求---------------------------------------------------------------------------------
--
function FlightMainModel.m_ReqAllFlight()
    local msgId = pbl.enum("gscode.OpCode","getAllFlight")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--
function FlightMainModel.m_ReqBetFlight(id, delay, score)
    local msgId = pbl.enum("gscode.OpCode","betFlight")
    local lMsg = { id = id, delay = delay, score = score}
    local pMsg = assert(pbl.encode("gs.BetFlight", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--
function FlightMainModel.m_ReqFlightBetHistory()
    local msgId = pbl.enum("gscode.OpCode","getFlightBetHistory")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--服务器回调---------------------------------------------------------------------------------
--
function FlightMainModel.n_OnGetAllFlight(data, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnGetAllFlight："..data.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    Event.Brocast("c_getAllFlight", data)
end
--
function FlightMainModel.n_OnBetFlight(data, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnBetFlight："..data.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    Event.Brocast("c_betFlightEvent", data)
end
--
function FlightMainModel.n_OnGetBetHistory(data, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnGetBetHistory："..data.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    Event.Brocast("c_getFlightBetHistory", data)
end
--
function FlightMainModel.n_OnGetBetResult(data, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnGetBetResult："..data.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    Event.Brocast("c_getBetResult", data)
end
--
function FlightMainModel.n_OnFlightScoreChange(data, msgId)
    if msgId == 0 then
        local info = {}
        info.titleInfo = "Error"
        info.contentInfo = "GAucModel.n_OnFlightScoreChange："..data.reason
        ct.OpenCtrl("BtnDialogPageCtrl", info)
        return
    end
    DataManager.SetMyFlightScore(data.num)
    Event.Brocast("c_flightScoreChange", data)
end
