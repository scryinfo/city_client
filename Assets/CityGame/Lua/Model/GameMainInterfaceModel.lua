---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/15 14:29
---主界面model
GameMainInterfaceModel = class("GameMainInterfaceModel",ModelBase)
local pbl = pbl

function GameMainInterfaceModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function GameMainInterfaceModel:OnCreate()
    Event.AddListener("m_ReqHouseSetSalary1",self.m_ReqHouseSetSalary,self)
    Event.AddListener("m_stopListenBuildingDetailInform", self.m_stopListenBuildingDetailInform,self)--停止接收建筑详情推送消息
    Event.AddListener("m_GetFriendInfo", self.m_GetFriendInfo,self)--获取好友信息

    DataManager.RegisterErrorNetMsg()
    --网络回调
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getAllMails","gs.Mails",self.n_OnGetAllMails,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","moneyChange","gs.MoneyChange",self.n_GsExtendBag,self)--新版model网络注册
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","newMailInform","gs.Mail",self.n_GsGetMails,self)--新版model网络注册
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","incomeNotify","gs.IncomeNotify",self.n_GsIncomeNotify,self)--自己的收益情况
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","cityBroadcast","gs.CityBroadcast",self.n_GsCityBroadcast,self)--城市广播
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryExchangeAmount","ss.ExchangeAmount",self.n_OnAllExchangeAmount,self) --所有交易量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryCityBroadcast","ss.CityBroadcasts",self.n_OnCityBroadcasts,self) --查询城市广播
    --开启心跳模拟
    UnitTest.Exec_now("abel_wk27_hartbeat", "e_HartBeatStart")
end

function GameMainInterfaceModel:Close()
    --清空本地UI事件
    --Event.RemoveListener("m_QueryPlayerInfoChat", self.m_QueryPlayerInfoChat,self)
    Event.RemoveListener("m_ReqHouseSetSalary1",self.m_ReqHouseSetSalary,self)
    Event.RemoveListener("m_stopListenBuildingDetailInform", self.m_stopListenBuildingDetailInform,self)--停止接收建筑详情推送消息
    Event.RemoveListener("m_GetFriendInfo", self.m_GetFriendInfo,self)--获取好友信息
end
--客户端请求--
--获取所有邮件
function GameMainInterfaceModel:m_GetAllMails()
    --DataManager.ModelSendNetMes("gscode.OpCode", "getAllMails")
    local msgId = pbl.enum("gscode.OpCode","getAllMails")
    ----2、 填充 protobuf 内部协议数据
    --local msglogion = pb.as.Login()
    --msglogion.account = this.username
    --local pb_login = msglogion:SerializeToString()  -- Parse Example
    ----3、 获取 protobuf 数据大小
    --local pb_size = #pb_login
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

function GameMainInterfaceModel:m_GetFriendInfo(friendsId)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = {friendsId}})
end

--所有交易量
function GameMainInterfaceModel:m_AllExchangeAmount()
    local msgId = pbl.enum("sscode.OpCode","queryExchangeAmount")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, nil, CityEngineLua._tradeNetworkInterface1)
end

--查询城市广播
function GameMainInterfaceModel:m_queryCityBroadcast()
    local msgId = pbl.enum("sscode.OpCode","queryCityBroadcast")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, nil, CityEngineLua._tradeNetworkInterface1)
end

--服务器回调--
--获取所有邮件
function GameMainInterfaceModel:n_OnGetAllMails(lMsg)
    --DataManager.ControllerRpcNoRet(self.insId,"GameMainInterfaceCtrl", '_receiveAllM2ails',stream)
    Event.Brocast("c_AllMails",lMsg.mail)
end

--邮件更新回调
function GameMainInterfaceModel:n_GsGetMails(lMsg)
    --DataManager.ControllerRpcNoRet(self.insId,"GameMainInterfaceCtrl", '_receiveAllM2ails',stream)
    Event.Brocast("c_RefreshMails",lMsg)
end

--改变员工工资
function GameMainInterfaceModel.m_ReqHouseSetSalary(self,id, price)
    DataManager.ModelSendNetMes("gscode.OpCode", "setSalary","gs.ByteNum",{ id = id, num = price})
end



--停止推送消息
function GameMainInterfaceModel.m_stopListenBuildingDetailInform(ins,buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "stopListenBuildingDetailInform","gs.Id",{ id = buildingId })
end

--金币改变回调
function GameMainInterfaceModel:n_GsExtendBag(lMsg)
    DataManager.SetMoney(lMsg.money)
    Event.Brocast("c_ChangeMoney",lMsg.money)
end

--自己的收益情况回调
function GameMainInterfaceModel:n_GsIncomeNotify(lMsg)
    Event.Brocast("c_IncomeNotify",lMsg)
end

--城市广播回调
function GameMainInterfaceModel:n_GsCityBroadcast(lMsg)
    if lMsg.type == 1 then
        Event.Brocast("c_MajorTransaction",lMsg) --重大交易
    else
        Event.Brocast("c_RadioInfo",lMsg)
    end
end

--所有交易量回调
function GameMainInterfaceModel:n_OnAllExchangeAmount(lMsg)
    Event.Brocast("c_AllExchangeAmount",lMsg.exchangeAmount)
end

--查询城市广播
function GameMainInterfaceModel:n_OnCityBroadcasts(lMsg)
   Event.Brocast("c_CityBroadcasts",lMsg.cityBroadcast)
end
