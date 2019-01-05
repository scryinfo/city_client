---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/1/3 17:34
---人才中心model
TalentCenterModel  = class('TalentCenterModel',ModelBase)
local pbl = pbl

function TalentCenterModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end


--启动事件--
function TalentCenterModel:OnCreate()
    --网络回调注册
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailTalentCenter","gs.TalentCenter",self.n_OnReceiveTalentDetailInfo)

    --本地的回调注册

end


--- 客户端请求 ---
--获取建筑详情
function TalentCenterModel:m_ReqTalentDetailInfo(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailTalentCenter","gs.Id",{ id = buildingId})
end

--- 回调 ---
--住宅详情
function TalentCenterModel:n_OnReceiveTalentDetailInfo(detailInfo)
    DataManager.ControllerRpcNoRet(self.insId,"HouseCtrl", '_receiveTanlentDetailInfo',detailInfo)
end