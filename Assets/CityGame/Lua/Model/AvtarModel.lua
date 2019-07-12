---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/18/018 12:01
---


AvtarModel = class("AvtarModel",ModelBase)
local pbl = pbl
local insID
function AvtarModel:initialize(insId)
    self.insId = insId
    insID=insId
    self:OnCreate()
end

function AvtarModel:OnCreate()
    Event.AddListener("m_setRoleFaceId", self.m_setRoleFaceId,self)--设置FaceId
    --网络回调
    --DataManager.ModelRegisterNetMsg(insID,"gscode.OpCode","setRoleFaceId","gs.Mail",self.n_GsGetMails,self)--新版model网络注册
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","setRoleFaceId","gs.Bool",self.m_registerRoleFaceId,self)
end
---================================================================================发包===========================================================================
function AvtarModel:m_setRoleFaceId(faceId)
    DataManager.ModelSendNetMes("gscode.OpCode", "setRoleFaceId","gs.Str",{ str =faceId })
end

---================================================================================收包===========================================================================

function AvtarModel:m_registerRoleFaceId(isSuccess)
    if isSuccess.b ~= nil and isSuccess.b == true then
        Event.Brocast("SmallPop", GetLanguage(17030005), ReminderType.Succeed)
        DataManager.SetMyFlightScore(DataManager.GetMyFlightScore() - 10 )
        Event.Brocast("m_AvatarChangeSuccess", DataManager.GetMyFlightScore())
    else
        Event.Brocast("SmallPop", GetLanguage(41010016), ReminderType.Warning)
    end
end












