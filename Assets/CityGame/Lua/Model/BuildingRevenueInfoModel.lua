---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/7/31 9:41
---建筑经营详情Model

BuildingRevenueInfoModel = class('BuildingRevenueInfoModel',ModelBase)

function BuildingRevenueInfoModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function BuildingRevenueInfoModel:OnCreate()
    --本地事件
    Event.AddListener("m_ReqBuildingRevenueInfo",self.m_ReqBuildingRevenueInfo,self)

    --查询建筑今日经营详情
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryTodayBuildingSaleDetail","ss.BuildingTodaySaleDetail",self.n_BuildingRevenueInfo,self)
    --查询建筑历史经营详情
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryHistoryBuildingSaleDetail","ss.BuildingHistorySaleDetail",self.n_BuildingHistoryRevenueInfo,self)
end

function BuildingRevenueInfoModel:Close()
    --本地事件
    Event.RemoveListener("m_ReqBuildingRevenueInfo",self.m_ReqBuildingRevenueInfo,self)

    --查询建筑今日经营详情
    DataManager.ModelRemoveNetMsg(nil,"sscode.OpCode","queryTodayBuildingSaleDetail","ss.BuildingTodaySaleDetail",self.n_BuildingRevenueInfo,self)
    --查询建筑历史经营详情
    DataManager.ModelRemoveNetMsg(nil,"sscode.OpCode","queryHistoryBuildingSaleDetail","ss.BuildingHistorySaleDetail",self.n_BuildingHistoryRevenueInfo,self)
end

---客户端请求---
--查询建筑今日经营详情
function BuildingRevenueInfoModel:m_ReqBuildingRevenueInfo(buildingId,typeId)
    FlightMainModel.OpenFlightLoading()
    local msgId = pbl.enum("sscode.OpCode","queryTodayBuildingSaleDetail")
    local lMsg = {buildingId = buildingId,type = typeId}
    local pMsg = assert(pbl.encode("ss.QueryBuildingSaleDetail", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end
--查询建筑历史经营详情
function BuildingRevenueInfoModel:m_ReqBuildingHistoryRevenueInfo(buildingId,typeId,itemId,producerId)
    FlightMainModel.OpenFlightLoading()
    local msgId = pbl.enum("sscode.OpCode","queryHistoryBuildingSaleDetail")
    local lMsg = {buildingId = buildingId,type = typeId,itemId = itemId,producerId = producerId}
    local pMsg = assert(pbl.encode("ss.QueryHistoryBuildingSaleDetail", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end
---服务器回调---
--查询建筑今日经营详情
function BuildingRevenueInfoModel:n_BuildingRevenueInfo(data)
    FlightMainModel.CloseFlightLoading()
    DataManager.ControllerRpcNoRet(self.insId,"BuildingRevenueInfoCtrl", 'revenueInfoData',data)
end
--查询建筑历史经营详情
function BuildingRevenueInfoModel:n_BuildingHistoryRevenueInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingRevenueInfoCtrl", 'historyRevenueInfoData',data)
end
