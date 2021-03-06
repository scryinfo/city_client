---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/5/24 15:59
---

EvaModel = class("EvaModel",ModelBase)

function EvaModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function EvaModel:OnCreate()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryMyEva","gs.BuildingEva",self.n_OnQueryMyEva,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","updateMyEvas","gs.BuildingEvas",self.n_OnUpdateMyEvas,self)
end

-- 查询玩家的Eva信息
function EvaModel:m_QueryMyEva(buildingType)
    FlightMainModel.OpenFlightLoading()
    DataManager.ModelSendNetMes("gscode.OpCode", "queryMyEva","gs.QueryMyEva",{playerId = DataManager.GetMyOwnerID(), buildingType = buildingType})
end

-- 服务器返回的Eva信息
function EvaModel:n_OnQueryMyEva(buildingEva)
    Event.Brocast("c_OnQueryMyEva", buildingEva)
    FlightMainModel.CloseFlightLoading()
end

-- Eva加点
function EvaModel:m_UpdateMyEvas(evas)
    FlightMainModel.OpenFlightLoading()
    DataManager.ModelSendNetMes("gscode.OpCode", "updateMyEvas","gs.UpdateMyEvas",evas)
end

-- 服务器返回的Eva加点
function EvaModel:n_OnUpdateMyEvas(buildingEvas)
    Event.Brocast("c_OnUpdateMyEvas", buildingEvas)
    FlightMainModel.CloseFlightLoading()
end