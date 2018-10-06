---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/27 14:13
---
require "Common/define"
require "City"
local pbl = pbl
local log = log

LoginModel= {};
local this = LoginModel;

--构建函数--
function LoginModel.New()
    logDebug("LoginModel.New--->>");
    return this;
end

function LoginModel.Awake()
    logDebug("LoginModel.Awake--->>");
    this:OnCreate();
end

--启动事件--
function LoginModel.OnCreate()
    --注册本地UI事件
    Event.AddListener("m_OnAsLogin", this.m_OnAsLogin);
    Event.AddListener("m_Gslogin", this.m_Gslogin);
    Event.AddListener("m_chooseGameServer", this.m_chooseGameServer);
    Event.AddListener("m_onConnectionState", this.m_onConnectionState);
    Event.AddListener("m_onDisconnect", this.m_onDisconnect);
    --注册 AccountServer 消息
    LoginModel.registerAsNetMsg()
end
--关闭事件--
function LoginModel.Close()
    --清空本地UI事件
    Event.RemoveListener("m_OnAsLogin", this.OnLogin);
    Event.RemoveListener("m_Gslogin", this.m_Gslogin);
    Event.RemoveListener("m_chooseGameServer", this.m_chooseGameServer);
    Event.RemoveListener("m_onConnectionState", this.m_onConnectionState);
    Event.RemoveListener("m_onDisconnect", this.m_onDisconnect);
end
function LoginModel.registerAsNetMsg()
    --as网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","login"),LoginModel.n_AsLogin);
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","getServerList"),LoginModel.n_AllGameServerInfo);
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","chooseGameServer"),LoginModel.n_ChooseGameServer);
end

function LoginModel.m_OnAsLogin( username, password, data )
    CityEngineLua.username = username;
    CityEngineLua.password = password;
    CityEngineLua._clientdatas = data;
    CityEngineLua.login_loginapp(true);
end

function LoginModel.m_Gslogin( )
    --注册gs的网络回调
    LoginModel.registerGsNetMsg()
    --连接gs
    CityEngineLua.login_baseapp(true)
end

function LoginModel.m_onConnectionState( isSuccess )
    Event.Brocast("c_ConnectionStateChange", isSuccess );
end

function LoginModel.m_onDisconnect( isSuccess )
    Event.Brocast("c_Disconnect", isSuccess);
    CityEngineLua.reConnect()
end

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

--返回服务器列表
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
end

--选择游戏服务器
function LoginModel.m_chooseGameServer( obj, serverId )
    ----1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","chooseGameServer")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { serverId = serverId}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("as.ChoseGameServer", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

function LoginModel.registerGsNetMsg()
    --清理as的网络回调
    --CityEngineLua.Message:clear()
    --CityEngineLua.Message:bindFixedMessage()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","login"),LoginModel.n_GsLoginSuccessfully);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","createRole"),LoginModel.n_CreateNewRole);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),LoginModel.n_OnRoleLogin);
end

--选择游戏服务器后回调, 发送登录游戏服务器的请求
function LoginModel.n_ChooseGameServer( stream )
    ----反序列化，取出数据
    local msg = assert(pbl.decode("as.ChoseCameServerACK",stream), "LoginModel.n_ChooseGameServer: stream == nil")
    ----处理数据：缓存服务器返回的 token
    CityEngineLua.token = msg.code
end
function LoginModel.n_GsLoginSuccessfully(stream )
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
        local pMsg =assert(pbl.decode("gs.RoleLoginAck",stream),"LoginModel.n_CreateNewRole : stream == nil")
        log("[LoginModel.n_OnRoleLogin] succeed!")
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
        log("system", "[LoginModel.n_CreateNewRole] stream = nil")
        return
    end

    local pMsg =assert(pbl.decode("gs.RoleInfo",stream),"LoginModel.n_CreateNewRole : stream == nil")
    logDebug(pMsg.id)
    logDebug(pMsg.name)
    LoginModel.loginRole({{id = pMsg.id}})
end

