-----
CreateRoleModel = class("CreateRoleModel",ModelBase)
local pbl = pbl
--local log = log

function CreateRoleModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

--Start event--
function CreateRoleModel:OnCreate()
    --Register local events
    Event.AddListener("m_createNewRole",self.m_createNewRole,self)
    --注册gs的网络回调
    CreateRoleModel:registerGsNetMsg()
end
--Close event--
function CreateRoleModel.Close()
    --Clear local UI events
end

function CreateRoleModel:registerGsNetMsg()
    DataManager.RegisterErrorNetMsg()
    --gs Network callback registration
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","createRole","gs.RoleInfo",self.n_CreateNewRole,self)--新版model网络注册
end

--Chuangjiao Hair Pack
function CreateRoleModel:m_createNewRole(data)
    DataManager.ModelSendNetMes("gscode.OpCode", "createRole","gs.CreateRole",
            { male = data.gender ,name =data.nickname ,companyName =data.companyname ,faceId = data.faceId })
end

--Angle callback
function CreateRoleModel:n_CreateNewRole(pMsg, msgId)
    --Exception handling
    if msgId == 0 then
        Event.Brocast("c_SameName",pMsg.reason)
        return
    end

    logDebug(pMsg.id)
    logDebug(pMsg.name)
    --log in
    Event.Brocast("m_loginRole",pMsg)
end


