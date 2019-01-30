---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/27 14:13
---
LoginModel = class("LoginModel",ModelBase)
local pbl = pbl
--local log = log

function LoginModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

--启动事件--
function LoginModel:OnCreate()
    --注册本地UI事件
    Event.AddListener("m_OnAsLogin", self.m_OnAsLogin);
    Event.AddListener("m_onConnectionState", self.m_onConnectionState);
    Event.AddListener("m_onDisconnect", self.m_onDisconnect);
    Event.AddListener("c_RemoveListener", self.c_RemoveListener,self);
    --注册 AccountServer 消息
    local a = DataManager
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","login","as.Login",self.n_AsLogin,self)--新版model网络注册
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","getServerList","as.AllGameServerInfo",self.n_AllGameServerInfo,self)
end
--关闭事件--
function LoginModel:Close()
    --清空本地UI事件
    Event.RemoveListener("m_OnAsLogin", self.m_OnAsLogin);
    Event.RemoveListener("m_onConnectionState", self.m_onConnectionState);
    Event.RemoveListener("m_onDisconnect", self.m_onDisconnect);
end

function LoginModel:c_RemoveListener()
    self:Close()
end

--点击登录
function LoginModel.m_OnAsLogin( username, password, data )
    CityEngineLua.username = username;
    CityEngineLua.password = password;
    CityEngineLua._clientdatas = data;
    CityEngineLua.login_loginapp(true);
end

--返回服务器列表回调
function LoginModel:n_AllGameServerInfo( msgAllGameServerInfo )
    --local msgAllGameServerInfo = assert(pbl.decode("as.AllGameServerInfo", stream), "LoginModel.n_AllGameServerInfo: stream == nil")
    if #msgAllGameServerInfo.infos ~= 0 then
        local serinofs = msgAllGameServerInfo.infos
       -- RobotIns:SaveData("serinofs",serinofs)
        ct.OpenCtrl("ServerListCtrl", serinofs)
        --服务器发过来的bytes测试
        UnitTest.Exec_now("abel_w11_UUID_FromeServer", "t_UUID_FromeServer",serinofs)
       -- UnitTest.Exec_now("byj_w27_robetTest", "byj_w27_robetTest",serinofs)
        --服务器发过来的bytes测试
        --Event.Brocast("RobotTest_OnAsLogin");
        return
    end

    local xxx = 0 ;
end

--注意，这里在运行时会调用不过来
function LoginModel.m_onConnectionState( state )
    ct.log("system","[m_onConnectionState]",state.error)
    Event.Brocast("c_ConnectionStateChange", state );
    if state.error == '' then
        --CityEngineLua.login_loginapp(false)
        --LoginPanel.textStatus:GetComponent('Text').text = "连接成功，正在登陆";
    elseif state.error == 'Connection TimeOut' then
        ct.log("system","[m_onConnectionState]",state.error)
    else
        ct.log("system","[m_onConnectionState]",state.error)
    end
end

function LoginModel.m_onDisconnect( isSuccess )
    Event.Brocast("c_Disconnect", isSuccess);
    CityEngineLua.reConnect()
end

--登录AS回调
function LoginModel.n_AsLogin(stream )


    local successfully = true
    --这里本来应该是反序列化pb字节流，但暂时因为服务器那边的login协议是特殊处理的，返回的包没有pb数据，所以暂时没有反序列化这一步
    --local msglogion = pb.as.Login()
    --msglogion:ParseFromString(stream)
    --successfully = msglogion.successed
    --end
    Event.Brocast("c_LoginSuccessfully", successfully );
    LoginModel:onUIGetServerList()

end
function LoginModel.onUIGetServerList( stream )
    --1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","getServerList")
    ----2、 填充 protobuf 内部协议数据
    --local msglogion = pb.as.Login()
    --msglogion.account = this.username
    --local pb_login = msglogion:SerializeToString()  -- Parse Example
    ----3、 获取 protobuf 数据大小
    --local pb_size = #pb_login
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end
UnitTest.TestBlockStart()-------------------------------------------------------------
UnitTest.Exec("abel_w17_ctrlRpcTest", "test_abel_w17_ctrlRpcTest",  function ()
    ct.log("abel_w17_ctrlRpcTest","[test_abel_w17_ctrlRpcTest]  测试开始")

    ct.ctrlRpcNoRet('LoginCtrl','rpcTest', 1,2)

    ct.ctrlRpc('LoginCtrl','rpcTest', 1,2,function (retvalue)
        ct.log("abel_w17_ctrlRpcTest","[test_abel_w17_ctrlRpcTest]  LoginCtrl:rpcTest return ="..retvalue)
    end)

end)
UnitTest.TestBlockEnd()---------------------------------------------------------------

--[[返回服务器列表
function LoginModel.n_AllGameServerInfo( stream )

    local msgAllGameServerInfo = assert(pbl.decode("as.AllGameServerInfo", stream), "LoginModel.n_AllGameServerInfo: stream == nil")
    local serinofs = msgAllGameServerInfo.infos
    if #msgAllGameServerInfo.infos ~= o then
        local serverIndex = 1  --测试服务器列表索引 1 是公共服务器 2 是李宁的服务器
        local sid = serinofs[serverIndex].serverId
        local ip = serinofs[serverIndex].ip
        local port = serinofs[serverIndex].port --服务器返回1000，应该是 9001，不然连不上
        --local port = "9001"

        --缓存选择的服务器信息
        CityEngineLua.baseappIP = ip;
        CityEngineLua.baseappPort = tostring(port);

        --local serverinfo = serinofs[1]
        --serverinfo.serverId
        --更新服务器数据到UI，UI实现中缓存服务器数据，比如 serverId ，以备后用
        --这里先直接模拟选服的操作，后边由UI触发
        LoginModel.m_chooseGameServer( this, sid)
        return
    end

    local xxx = 0 ;
end--]]

--选择游戏服务器
--[[function LoginModel.m_chooseGameServer( obj, serverId )
    ----1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","chooseGameServer")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { serverId = serverId}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("as.ChoseGameServer", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end--]]

--[[function LoginModel.registerGsNetMsg()
    --清理as的网络回调
    CityEngineLua.Message:clear()
    CityEngineLua.Message:bindFixedMessage()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","login"),LoginModel.n_GsLoginSuccessfully);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","createRole"),LoginModel.n_CreateNewRole);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),LoginModel.n_OnRoleLogin);
end--]]

--选择游戏服务器后回调, 发送登录游戏服务器的请求
--[[function LoginModel.n_ChooseGameServer( stream )
    ----反序列化，取出数据
    local msg = assert(pbl.decode("as.ChoseCameServerACK",stream), "LoginModel.n_ChooseGameServer: stream == nil")
    ----处理数据：缓存服务器返回的 token
    CityEngineLua.token = msg.code
end--]]
--[[function LoginModel.n_GsLoginSuccessfully(stream )
    --decode
    local lMsg = assert(pbl.decode("gs.LoginACK", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    --if no role yet, auto create a new role
    if lMsg.info == nil then
        LoginModel.createNewRole()
    else
        LoginModel.loginRole(lMsg.info)
    end

    --cache data
end

function LoginModel.loginRole(info)
    --roleLogin = 1002;						//c
    --message Id {
    --    required bytes id = 1;
    --}
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","roleLogin")
    ----2、 填充 protobuf 内部协议数据
    if #info > 0 then
        local lMsg = { id = info[1].id }
        local pMsg = assert(pbl.encode("gs.Id", lMsg))
        ----3、 创建包，填入数据并发包
        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    end
end

function LoginModel.n_OnRoleLogin(stream)
    --message RoleLoginAck{
    --    required Role role = 1;
    --}
    if(stream) then
        local pMsg =assert(pbl.decode("gs.Role",stream),"LoginModel.n_OnRoleLogin : pbl.decode failed")
        ct.log("[LoginModel.n_OnRoleLogin] succeed!")
        Event.Brocast("c_GsLoginSuccess");
        --logDebug(pMsg.role.id)
        --logDebug(pMsg.role.name)
        --logDebug(pMsg.role.name)
        --logDebug(pMsg.role.lockedMoney)
        --logDebug(pMsg.role.offlineTs)
        --logDebug(pMsg.role.position)
    end
end

function LoginModel.createNewRole()
    --    message Str{
    --    required string str = 1;
    --    required string name = 2;
    --    required int64 money = 3;
    --    required int32 lockedMoney = 4;
    --    required int64 offlineTs = 5;
    --    required GridIndex position = 6;
    --}
    --
    --message RoleLoginAck{
    --    required Role role = 1;
    --}
    --}
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","createRole")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { str = CityEngineLua.username.."_role1"}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    ----3、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

function LoginModel.n_CreateNewRole(stream)
    --message Role {
    --    required bytes id = 1;
    if stream == nil then
        ct.log("system", "[LoginModel.n_CreateNewRole] stream = nil")
        return
    end

    local pMsg =assert(pbl.decode("gs.RoleInfo",stream),"LoginModel.n_CreateNewRole : stream == nil")
    logDebug(pMsg.id)
    logDebug(pMsg.name)
    LoginModel.loginRole({{id = pMsg.id}})
end
--]]
