-----
ServerListModel = class("ServerListModel",ModelBase)
local pbl = pbl
--local log = log

function ServerListModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end
--启动事件--
function ServerListModel:OnCreate()
    --注册本地事件
    Event.AddListener("m_loginRole", self.loginRole,self);
    ----注册 AccountServer 消息
   -- ServerListModel.registerAsNetMsg()
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","chooseGameServer","as.ChoseCameServerACK",self.n_ChooseGameServer,self)
end
--关闭事件--
function ServerListModel:Close()
    --清空本地UI事件1
   -- Event.RemoveListener("m_chooseGameServer", self.m_chooseGameServer);
    Event.RemoveListener("m_loginRole", self.loginRole,self);
end
function ServerListModel.registerAsNetMsg()
    --as网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","chooseGameServer"),ServerListModel.n_ChooseGameServer);
    --DataManager.ModelRegisterNetMsg(self.insId,"ascode.OpCode","chooseGameServer",self.n_ChooseGameServer)
   -- DataManager.ModelRegisterNetMsg(self.insId,"ascode.OpCode","chooseGameServer","as.ChoseCameServerACK",self.n_ChooseGameServer)
end

--选择游戏服务器
function ServerListModel:m_chooseGameServer( data )
    local serverIndex = data.Index --测试服务器列表索引 1 是公共服务器 2 是李宁的服务器
    if data.serinofs[serverIndex].available == false then
        ct.MsgBox(GetLanguage(4301012), GetLanguage(4301002))
        return
    end
    local sid =  data.serinofs[serverIndex].serverId
    local ip =  data.serinofs[serverIndex].ip
    local port =  data.serinofs[serverIndex].port --服务器返回1000，应该是 9001，不然连不上
    --local port = "9001"

    --缓存选择的服务器信息
    CityEngineLua.baseappIP = ip;
    CityEngineLua.baseappPort = tostring(port);

    -- 保存交易服务器的信息
    CityEngineLua.tradeappIP = data.serinofs[serverIndex].ssIp
    CityEngineLua.tradeappPort = tostring(data.serinofs[serverIndex].ssPort)

    --serverinfo.serverId
    --更新服务器数据到UI，UI实现中缓存服务器数据，比如 serverId ，以备后用
    DataManager.ModelSendNetMes("ascode.OpCode", "chooseGameServer","as.ChoseGameServer",{ serverId = sid})
end
--选择游戏服务器后回调, 发送登录游戏服务器的请求
function ServerListModel:n_ChooseGameServer( msg )
    ----反序列化，取出数据
    --local msg = assert(pbl.decode("as.ChoseCameServerACK",stream), "LoginModel.n_ChooseGameServer: stream == nil")
    ----处理数据：缓存服务器返回的 token
    CityEngineLua.token = msg.code
    --Event.Brocast("RobotTest_OnchooseServer",msg.code)
    ServerListModel.isClick = true
    if ServerListModel.isClick then
        ServerListModel:m_GsOK()
    end
    ServerListModel.isClick = false
end
function ServerListModel:m_GsOK()
    --清除之前的所有注册的网络消息
    DataManager.UnAllModelRegisterNetMsg()
    DataManager.InitialNetMessages()
    --注册gs的网络回调
    ServerListModel:registerGsNetMsg()
    -----------------------------------------------------------------------------
    --临时单独处理的协议，后边统走datamanager
    StopAndBuildModel.Awake()
    -----------------------------------------------------------------------------
    GAucModel.registerNetMsg()  --拍卖的网络回调
    --连接gs
    CityEngineLua.login_baseapp(true)
    --CityEngineLua.login_tradeapp(true)
end
function ServerListModel:registerGsNetMsg()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("common.OpCode","error"),CityEngineLua.Message.n_errorProcess);
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","login","gs.LoginACK",self.n_GsLoginSuccessfully,self)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","login"),ServerListModel.n_GsLoginSuccessfully);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),ServerListModel.n_OnRoleLogin);
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
    --同步服务器时间
    if lMsg.ts ~= nil then
        TimeSynchronized.SynchronizationServerTime(lMsg.ts)
    else
        ct.log("system","Error:登录服务器没有同步时间")
    end
end

--登录gs发包
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
        Event.Brocast("c_GsLoginSuccess",pMsg.id);
        Event.Brocast("c_RoleLoginDataInit",pMsg);
        Event.Brocast("m_bagCapacity",pMsg.bagCapacity);
        Event.Brocast("m_RoleLoginInExchangeModel", stream)  ---测试，获取登录之后的信息 cycle week 11
        Event.Brocast("m_RoleLoginReqGroundAuction")  --请求拍卖信息


        --激活相机脚本
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
    end
end


