-----
CreateRoleModel = class("CreateRoleModel",ModelBase)
local pbl = pbl
--local log = log

function CreateRoleModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

--启动事件--
function CreateRoleModel:OnCreate()
    --注册本地事件

    --注册gs的网络回调
    CreateRoleModel:registerGsNetMsg()
end
--关闭事件--
function CreateRoleModel.Close()
    --清空本地UI事件
end

function CreateRoleModel:registerGsNetMsg()
    --gs网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","createRole"),CreateRoleModel.n_CreateNewRole);
end

--创角发包
function CreateRoleModel.m_createNewRole()
    DataManager.ModelSendNetMes("gscode.OpCode", "createRole","gs.Str",{ str = CityEngineLua.username.."_role1"})
end

--创角回调
function CreateRoleModel.n_CreateNewRole(stream)
    --message Role {
    --    required bytes id = 1;
    if stream == nil then
        ct.log("system", "[LoginModel.n_CreateNewRole] stream = nil")
        return
    end

    local pMsg =assert(pbl.decode("gs.RoleInfo",stream),"LoginModel.n_CreateNewRole : stream == nil")
    logDebug(pMsg.id)
    logDebug(pMsg.name)
    --角色登录
    Event.Brocast("m_loginRole",pMsg)
end

