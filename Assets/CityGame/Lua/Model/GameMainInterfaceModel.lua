---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/15 14:29
---主界面model
GameMainInterfaceModel = class("GameMainInterfaceModel",ModelBase)
local pbl = pbl

function GameMainInterfaceModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function GameMainInterfaceModel:OnCreate()
    Event.AddListener("m_ReqHouseSetSalary1",self.m_ReqHouseSetSalary,self)
    --网络回调
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getAllMails","gs.Mails",self.n_OnGetAllMails)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","getAllMails"),GameMainInterfaceModel.n_OnGetAllMails);
end

function GameMainInterfaceModel:Close()
    --清空本地UI事件

end
--客户端请求--
--获取所有邮件
function GameMainInterfaceModel:m_GetAllMails()
    --DataManager.ModelSendNetMes("gscode.OpCode", "getAllMails")
    local msgId = pbl.enum("gscode.OpCode","getAllMails")
    ----2、 填充 protobuf 内部协议数据
    --local msglogion = pb.as.Login()
    --msglogion.account = this.username
    --local pb_login = msglogion:SerializeToString()  -- Parse Example
    ----3、 获取 protobuf 数据大小
    --local pb_size = #pb_login
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--服务器回调--
--获取所有邮件
function GameMainInterfaceModel.n_OnGetAllMails(stream)
    --DataManager.ControllerRpcNoRet(self.insId,"GameMainInterfaceCtrl", '_receiveAllM2ails',stream)
    local lMsg = assert(pbl.decode("gs.Mails", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    local a= lMsg
end

--改变员工工资
function GameMainInterfaceModel.m_ReqHouseSetSalary(self,id, price)
    DataManager.ModelSendNetMes("gscode.OpCode", "setSalary","gs.ByteNum",{ id = id, num = price})

end

