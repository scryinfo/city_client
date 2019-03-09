---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/26 18:21
---

GuildApplyModel = class("GuildApplyModel", ModelBase)

function GuildApplyModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function GuildApplyModel:OnCreate()
    -- 网络回调注册
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","delJoinReq","gs.JoinReq", self.n_DelJoinReq, self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","newJoinReq","gs.JoinReq", self.n_NewJoinReq, self)
end

function GuildApplyModel.Close()

end

-- 申请操作请求
function GuildApplyModel:m_JoinHandle(joinHandle)
    DataManager.ModelSendNetMes("gscode.OpCode", "joinHandle","gs.JoinHandle",joinHandle)
end

-- 申请操作返回
function GuildApplyModel:n_DelJoinReq(joinReq)
    Event.Brocast("c_DelJoinReq", joinReq)
end

-- 新增入会请求
function GuildApplyModel:n_NewJoinReq(joinReq)
    Event.Brocast("c_NewJoinReq", joinReq)
end