require "Common/define"
require "City"
local pbl = pbl
local log = log

ServerListModel= {};
local this = ServerListModel;

--构建函数--
function ServerListModel.New()
    logDebug("ServerListModel.New--->>");
    return this;
end

function ServerListModel.Awake()
    logDebug("ServerListModel.Awake--->>");
    this:OnCreate();
end

--启动事件--
function ServerListModel.OnCreate()
    --注册本地事件
    Event.AddListener("m_chooseGameServer", this.m_chooseGameServer);
    Event.AddListener("m_GsOK", this.m_GsOK);
    ----注册 AccountServer 消息
    ServerListModel.registerAsNetMsg()
end
--关闭事件--
function ServerListModel.Close()
    --清空本地UI事件
        Event.RemoveListener("m_chooseGameServer", this.m_chooseGameServer);
        Event.RemoveListener("m_GsOK", this.m_GsOK);
end
function ServerListModel.registerAsNetMsg()
    --as网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","getServerList"),ServerListModel.n_AllGameServerInfo);
    CityEngineLua.Message:registerNetMsg(pbl.enum("ascode.OpCode","chooseGameServer"),ServerListModel.n_ChooseGameServer);
end
--返回服务器列表
function ServerListModel.n_AllGameServerInfo( stream )

    local msgAllGameServerInfo = assert(pbl.decode("as.AllGameServerInfo", stream), "LoginModel.n_AllGameServerInfo: stream == nil")
    if #msgAllGameServerInfo.infos ~= 0 then
        this.serinofs = msgAllGameServerInfo.infos
        return
    end

    local xxx = 0 ;
end
--选择游戏服务器
function ServerListModel.m_chooseGameServer( Index )

    local serverIndex = Index --测试服务器列表索引 1 是公共服务器 2 是李宁的服务器
    local sid = this.serinofs[serverIndex].serverId
    log("rodger_w8_GameMainInterface","[test_n_GsLoginSuccessfully] ",serverIndex)
    local ip = this.serinofs[serverIndex].ip
    local port = this.serinofs[serverIndex].port --服务器返回1000，应该是 9001，不然连不上
    --local port = "9001"

    --缓存选择的服务器信息
    CityEngineLua.baseappIP = ip;
    CityEngineLua.baseappPort = tostring(port);
    --ServerListPanel.baseappID[1] = serverIndex;
    --local serverinfo = serinofs[1]
    --serverinfo.serverId
    --更新服务器数据到UI，UI实现中缓存服务器数据，比如 serverId ，以备后用
    ----1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","chooseGameServer")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { serverId = sid}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("as.ChoseGameServer", lMsg))
    log("rodger_w8_GameMainInterface","[test_n_GsLoginSuccessfully] ",lMsg)
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end
--选择游戏服务器后回调, 发送登录游戏服务器的请求
function ServerListModel.n_ChooseGameServer( stream )
    ----反序列化，取出数据
    local msg = assert(pbl.decode("as.ChoseCameServerACK",stream), "LoginModel.n_ChooseGameServer: stream == nil")
    ----处理数据：缓存服务器返回的 token
    CityEngineLua.token = msg.code
end
function ServerListModel.m_GsOK()
    --注册gs的网络回调
    ServerListModel.registerGsNetMsg()
    --连接gs
    CityEngineLua.login_baseapp(true)
end
function ServerListModel.registerGsNetMsg()
    --清理as的网络回调
    --CityEngineLua.Message:clear()
    --CityEngineLua.Message:bindFixedMessage()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","login"),ServerListModel.n_GsLoginSuccessfully);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),ServerListModel.n_OnRoleLogin);
end
function ServerListModel.n_GsLoginSuccessfully(stream )
    --decode
    local lMsg = assert(pbl.decode("gs.LoginACK", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    --if no role yet, auto create a new role
    log("rodger_w8_GameMainInterface","[test_n_GsLoginSuccessfully] ",lMsg.info)
    if lMsg.info == nil then
        Event.Brocast("c_GsCreateRole")
    else
        log("rodger_w8_GameMainInterface","[test_n_GsLoginSuccessfully] 我来了")
        ServerListModel.loginRole(lMsg.info)
    end

    --cache data
end
function ServerListModel.loginRole(info)
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

function ServerListModel.n_OnRoleLogin(stream)
    --message RoleLoginAck{
    --    required Role role = 1;
    --}
    if(stream) then
        local pMsg =assert(pbl.decode("gs.Role",stream),"LoginModel.n_OnRoleLogin : pbl.decode failed")
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

function ServerListModel.createNewRole()
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

function ServerListModel.n_CreateNewRole(stream)
    --message Role {
    --    required bytes id = 1;
    if stream == nil then
        log("system", "[LoginModel.n_CreateNewRole] stream = nil")
        return
    end

    local pMsg =assert(pbl.decode("gs.RoleInfo",stream),"LoginModel.n_CreateNewRole : stream == nil")
    logDebug(pMsg.id)
    logDebug(pMsg.name)
    ServerListModel.loginRole({{id = pMsg.id}})
end
UnitTest.Exec("rodger_w8_GameMainInterface", "test_ServerListCtrl_self",  function ()
    Event.AddListener("c_LoginSuccessfully_self", function ()
        UIPage:ShowPage(ServerListCtrl)
    end)
end)
