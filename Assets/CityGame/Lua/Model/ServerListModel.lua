-----
ServerListModel = class("ServerListModel",ModelBase)
local pbl = pbl
--local log = log

function ServerListModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end
--Start event--
function ServerListModel:OnCreate()
    --Register local events
    Event.AddListener("m_loginRole", self.loginRole,self);
    ----Register AccountServer Message
   -- ServerListModel.registerAsNetMsg()
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","chooseGameServer","as.ChoseCameServerACK",self.n_ChooseGameServer,self)
end
--Close event--
function ServerListModel:Close()
    --Clear local UI events1
   -- Event.RemoveListener("m_chooseGameServer", self.m_chooseGameServer);
    Event.RemoveListener("m_loginRole", self.loginRole,self);
end
function ServerListModel.registerAsNetMsg()
    --as Network callback registration
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","chooseGameServer"),ServerListModel.n_ChooseGameServer);
    --DataManager.ModelRegisterNetMsg(self.insId,"ascode.OpCode","chooseGameServer",self.n_ChooseGameServer)
   -- DataManager.ModelRegisterNetMsg(self.insId,"ascode.OpCode","chooseGameServer","as.ChoseCameServerACK",self.n_ChooseGameServer)
end

--Select game server
function ServerListModel:m_chooseGameServer( data )
    local serverIndex = data.Index 
    if data.serinofs[serverIndex].available == false then
        ct.MsgBox(GetLanguage(41010010), GetLanguage(41010002))
        return
    end
    local sid =  data.serinofs[serverIndex].serverId
    local ip =  data.serinofs[serverIndex].ip
    local port =  data.serinofs[serverIndex].port --The server returns 1000, which should be 9001, otherwise it can’t be reached
    --local port = "9001"

    --- cache selected server information
    CityEngineLua.baseappIP = ip;
    CityEngineLua.baseappPort = tostring(port);

    -- Save the information of the transaction server
    CityEngineLua.tradeappIP = data.serinofs[serverIndex].ssIp
    CityEngineLua.tradeappPort = tostring(data.serinofs[serverIndex].ssPort)

    --serverinfo.serverId
    --Update the server data to the UI, cache the server data in the UI implementation, such as serverId for later use
    DataManager.ModelSendNetMes("ascode.OpCode", "chooseGameServer","as.ChoseGameServer",{ serverId = sid})
end
---Callback after selecting the game server, sending a request to log in to the game server
function ServerListModel:n_ChooseGameServer( msg )
    ----Deserialization, take out the data
    --local msg = assert(pbl.decode("as.ChoseCameServerACK",stream), "LoginModel.n_ChooseGameServer: stream == nil")
    ----Processing data: cache server returns token
    CityEngineLua.token = msg.code
    --Event.Brocast("RobotTest_OnchooseServer",msg.code)
    ServerListModel.isClick = true
    if ServerListModel.isClick then
        ServerListModel:m_GsOK()
    end
    ServerListModel.isClick = false
end
function ServerListModel:m_GsOK()
    --Clear all registered network messages before
    DataManager.UnAllModelRegisterNetMsg()
    DataManager.InitialNetMessages()
    --Register gs network callback
    ServerListModel:registerGsNetMsg()
    -----------------------------------------------------------------------------
    ----Temporary separate processing agreement, and follow the datamanager
    StopAndBuildModel.Awake()
    -----------------------------------------------------------------------------
    GAucModel.registerNetMsg()  --Network callback of auction
    GroundTransModel.registerNetMsg()  --Callback of the land transaction network
    MapModel.registerNetMsg()  --Small map network callback
    FlightMainModel.registerNetMsg()  -- Flight forecast network callback
    --Connect gs
    CityEngineLua.login_baseapp(true)
    --CityEngineLua.login_tradeapp(true)
end
function ServerListModel:registerGsNetMsg()
    --gs Network callback registration
    CityEngineLua.Message:registerNetMsg(pbl.enum("common.OpCode","error"),CityEngineLua.Message.n_errorProcess);
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","login","gs.LoginACK",self.n_GsLoginSuccessfully,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","roleLogin","gs.Role",self.n_OnRoleLogin,self)
end
function ServerListModel:n_GsLoginSuccessfully( lMsg )
    --if stream == nil then
    --    return
    --end
    --
    ----CityEngineLua.login_tradeapp(true)
    --
    ----decode
    --local lMsg = assert(pbl.decode("gs.LoginACK", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    ----if no role yet, auto create a new role
    if lMsg.info == nil then
        Event.Brocast("c_GsCreateRole")
    else
        Event.Brocast("m_loginRole",lMsg.info[1])
    end
    --Event.Brocast("RobotTest_OnGsLoginSuccessfully")
    --cache data
    --Synchronize server time
    if lMsg.ts ~= nil then
        TimeSynchronized.SynchronizationServerTime(lMsg.ts)
    else
        ct.log("system","Error:登录服务器没有同步时间")
    end
end

--Log in gs to send a package
function ServerListModel:loginRole(info)
    DataManager.ModelSendNetMes("gscode.OpCode", "roleLogin","gs.Id",{ id = info.id })
end

function ServerListModel:n_OnRoleLogin(pMsg)
    --message RoleLoginAck{
    --    required Role role = 1;
    --}
    if(pMsg) then
        --local pMsg =assert(pbl.decode("gs.Role",stream),"LoginModel.n_OnRoleLogin : pbl.decode failed")
        if pMsg.bag ~= nil then
            ServerListModel.inHand = pMsg.bag.inHand
        end
        ServerListModel.bagId = pMsg.bagId

        ct.log("[LoginModel.n_OnRoleLogin] succeed!")
        Event.Brocast("c_RoleLoginDataInit",pMsg);
        Event.Brocast("m_bagCapacity",pMsg.bagCapacity);
        Event.Brocast("m_RoleLoginInExchangeModel", stream)  ---Test, get the information after login 11
        Event.Brocast("m_RoleLoginReqGroundAuction")  --Request auction information


        --On-chain testing, do not delete, to block, please log out the corresponding registration in test_group.lua
        UnitTest.Exec_now("abel_0531_ct_RechargeRequestReq", "e_abel_0531_ct_RechargeRequestReq",pMsg.id)

        --Activate the camera script
        --[[
        local camOjb = UnityEngine.Camera.main.gameObject:GetComponent("CameraScripts")
        if camOjb then
            camOjb.enabled = true;
        end
        --]]
        --logDebug(pMsg.role.id)
        --logDebug(pMsg.role.name)
        --logDebug(pMsg.role.name)
        --logDebug(pMsg.role.lockedMoney)
        --logDebug(pMsg.role.offlineTs)
        --logDebug(pMsg.role.position)

        Event.Brocast("c_GsLoginSuccess",pMsg.id);
        --Start the weather
        ClimateManager.Star()
        --Start jumping money
        MakeMoneyManager.Init()
        -- Query offline notification after login
        Event.Brocast("m_QueryOffLineInformation")
    end
end


