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
    Event.AddListener("m_createNewRole",self.m_createNewRole,self)
    --注册gs的网络回调
    CreateRoleModel:registerGsNetMsg()
end
--关闭事件--
function CreateRoleModel.Close()
    --清空本地UI事件
end

function CreateRoleModel:registerGsNetMsg()
    DataManager.RegisterErrorNetMsg()
    --gs网络回调注册
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","createRole","gs.RoleInfo",self.n_CreateNewRole,self)--新版model网络注册
end

--创角发包
function CreateRoleModel:m_createNewRole(data)
    DataManager.ModelSendNetMes("gscode.OpCode", "createRole","gs.CreateRole",
            { male = data.gender ,name =data.nickname ,companyName =data.companyname ,faceId = data.faceId })
end

--创角回调
function CreateRoleModel:n_CreateNewRole(pMsg, msgId)
    --异常处理
    if msgId == 0 then
        if pMsg.reason == 'notAllow' then
            Event.Brocast("c_SameName")
        end
        return
    end

    logDebug(pMsg.id)
    logDebug(pMsg.name)
    --登录
    Event.Brocast("m_loginRole",pMsg)
    --创建钱包

end


