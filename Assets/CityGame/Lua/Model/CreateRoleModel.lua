-----
local pbl = pbl
local log = log

CreateRoleModel= {};
local this = CreateRoleModel;

--构建函数--
function CreateRoleModel.New()
    logDebug("CreateRoleModel.New--->>");
    return this;
end

function CreateRoleModel.Awake()
    logDebug("CreateRoleModel.Awake--->>");
    this:OnCreate();
end

--启动事件--
function CreateRoleModel.OnCreate()
    --注册本地事件
    Event.AddListener("m_createNewRole", this.m_createNewRole);
end
--关闭事件--
function CreateRoleModel.Close()
    --清空本地UI事件
    Event.RemoveListener("m_createNewRole", this.m_createNewRole);
end
function CreateRoleModel.registerGsNetMsg()
    --清理as的网络回调
    --CityEngineLua.Message:clear()
    --CityEngineLua.Message:bindFixedMessage()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","createRole"),CreateRoleModel.n_CreateNewRole);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),CreateRoleModel.n_OnRoleLogin);
end
function CreateRoleModel.m_createNewRole()
    --注册gs的网络回调
    CreateRoleModel.registerGsNetMsg()

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
function CreateRoleModel.loginRole(info)
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
function CreateRoleModel.n_CreateNewRole(stream)
    --message Role {
    --    required bytes id = 1;
    if stream == nil then
        log("system", "[LoginModel.n_CreateNewRole] stream = nil")
        return
    end

    local pMsg =assert(pbl.decode("gs.RoleInfo",stream),"LoginModel.n_CreateNewRole : stream == nil")
    logDebug(pMsg.id)
    logDebug(pMsg.name)
    CreateRoleModel.loginRole({{id = pMsg.id}})
end
function CreateRoleModel.n_OnRoleLogin(stream)
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

