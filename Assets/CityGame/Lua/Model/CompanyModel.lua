---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/1/17 17:34
---

CompanyModel = class("CompanyModel",ModelBase)

function CompanyModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function CompanyModel:OnCreate()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getGroundInfo","gs.GroundChange",self.n_OnGetGroundInfo,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryMyBuildings","gs.MyBuildingInfos",self.n_OnQueryMyBuildings,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryMyEva","gs.Evas",self.n_OnQueryMyEva,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","updateMyEva","gs.Eva",self.n_OnUpdateMyEva,self)
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryPlayerIncomePayCurve","ss.PlayerIncomePayCurve",self.n_OnQueryPlayerIncomePayCurve,self)
end

-- 查询玩家的土地消息
function CompanyModel:m_GetGroundInfo()
    local msgId = pbl.enum("gscode.OpCode","getGroundInfo")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

-- 服务器返回的土地消息
function CompanyModel:n_OnGetGroundInfo(groundInfos)
    Event.Brocast("c_OnGetGroundInfo", groundInfos)
end

-- 查询玩家的建筑信息
function CompanyModel.m_QueryMyBuildings()
    DataManager.ModelSendNetMes("gscode.OpCode", "queryMyBuildings","gs.QueryMyBuildings",{id = DataManager.GetMyOwnerID()})
end

-- 服务器返回的建筑信息
function CompanyModel:n_OnQueryMyBuildings(buildingInfos)
    Event.Brocast("c_OnQueryMyBuildings", buildingInfos)
end

-- 查询玩家的Eva信息
function CompanyModel.m_QueryMyEva()
    DataManager.ModelSendNetMes("gscode.OpCode", "queryMyEva","gs.Id",{id = DataManager.GetMyOwnerID()})
end

-- 服务器返回的Eva信息
function CompanyModel:n_OnQueryMyEva(evas)
    Event.Brocast("c_OnQueryMyEva", evas)
end

-- Eva加点
function CompanyModel:m_UpdateMyEva(eva)
    DataManager.ModelSendNetMes("gscode.OpCode", "updateMyEva","gs.Eva",eva)
end

-- 服务器返回的Eva加点
function CompanyModel:n_OnUpdateMyEva(eva)
    Event.Brocast("c_OnUpdateMyEva", eva)
end

-- 查询玩家的收支信息
function CompanyModel.m_QueryPlayerIncomePayCurve()
    local msgId = pbl.enum("sscode.OpCode","queryPlayerIncomePayCurve")
    local lMsg = { id = DataManager.GetMyOwnerID() }
    local pMsg = assert(pbl.encode("ss.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end

-- 服务器返回的曲线图信息
function CompanyModel:n_OnQueryPlayerIncomePayCurve(curveInfo)
    Event.Brocast("c_OnQueryPlayerIncomePayCurve", curveInfo.playerIncome)
end