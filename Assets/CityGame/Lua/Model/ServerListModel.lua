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
function ServerListModel.Close()
    --清空本地UI事件1
   -- Event.RemoveListener("m_chooseGameServer", self.m_chooseGameServer);
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
    local sid =  data.serinofs[serverIndex].serverId
    local ip =  data.serinofs[serverIndex].ip
    local port =  data.serinofs[serverIndex].port --服务器返回1000，应该是 9001，不然连不上
    --local port = "9001"

    --缓存选择的服务器信息
    CityEngineLua.baseappIP = ip;
    CityEngineLua.baseappPort = tostring(port);
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
    ServerListModel.isClick = true
    if ServerListModel.isClick then
        ServerListModel:m_GsOK()
    end
    ServerListModel.isClick = false
end
function ServerListModel:m_GsOK()
    --注册gs的网络回调
    ServerListModel:registerGsNetMsg()
    --连接gs
    CityEngineLua.login_baseapp(true)
end
function ServerListModel:registerGsNetMsg()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","login"),ServerListModel.n_GsLoginSuccessfully);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),ServerListModel.n_OnRoleLogin);
   -- DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","roleLogin","gs.LoginACK",self.n_GsLoginSuccessfully)
end
function ServerListModel.n_GsLoginSuccessfully(stream )
    if stream == nil then
        return
    end
    --decode
    local lMsg = assert(pbl.decode("gs.LoginACK", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    --if no role yet, auto create a new role
    if lMsg.info == nil then
        Event.Brocast("c_GsCreateRole")
    else
        Event.Brocast("m_loginRole",lMsg.info[1])
    end
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

function ServerListModel.n_OnRoleLogin(stream)
    --message RoleLoginAck{
    --    required Role role = 1;
    --}
    if(stream) then
        local pMsg =assert(pbl.decode("gs.Role",stream),"LoginModel.n_OnRoleLogin : pbl.decode failed")
        if pMsg.bag ~= nil then
            ServerListModel.inHand = pMsg.bag.inHand
        end
        ServerListModel.bagId = pMsg.bagId

        ct.log("[LoginModel.n_OnRoleLogin] succeed!")
        Event.Brocast("c_GsLoginSuccess",pMsg.id);
        Event.Brocast("c_RoleLoginDataInit",pMsg);
        Event.Brocast("m_bagCapacity",pMsg.bagCapacity);
        Event.Brocast("m_RoleLoginInExchangeModel", stream)  ---测试，获取登录之后的信息 cycle week 11

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


