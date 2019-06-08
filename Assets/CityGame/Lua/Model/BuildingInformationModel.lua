---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/5/17 9:38
---建筑信息Model

BuildingInformationModel = class('BuildingInformationModel',ModelBase)

function BuildingInformationModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function BuildingInformationModel:OnCreate()
    --本地事件
    Event.AddListener("m_ReqClosedBuilding",self.m_ReqClosedBuilding,self)
    Event.AddListener("m_ReqDemolitionBuilding",self.m_ReqDemolitionBuilding,self)
    Event.AddListener("m_ReqSetBuildingName",self.m_ReqSetBuildingName,self)
    --建筑停业
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","shutdownBusiness","gs.Id",self.n_ClosedBuilding,self)
    --建筑改名
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","updateBuildingName","gs.BuildingInfo",self.n_SetBuildingInfo,self)
    --原料厂
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryMaterialInfo","gs.MaterialInfo",self.n_MaterialFactoryInfo,self)
    --加工厂
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryProduceDepInfo","gs.ProduceDepInfo",self.n_ProcessingFactoryInfo,self)
    --零售店
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryRetailShopOrApartmentInfo","gs.RetailShopOrApartmentInfo",self.n_RetailShopInfo,self)
    --推广
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPromotionCompanyInfo","gs.PromotionCompanyInfo",self.n_PromoteInfo,self)
    --研究所
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryLaboratoryInfo","gs.LaboratoryInfo",self.n_LaboratoryInfo,self)
end

function BuildingInformationModel:Close()
    --本地事件
    Event.RemoveListener("m_ReqClosedBuilding",self.m_ReqClosedBuilding,self)
    Event.RemoveListener("m_ReqDemolitionBuilding",self.m_ReqDemolitionBuilding,self)
    Event.RemoveListener("m_ReqSetBuildingName",self.m_ReqSetBuildingName,self)
    --建筑停业
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","shutdownBusiness","gs.Id",self.n_ClosedBuilding,self)
    --建筑改名
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","updateBuildingName","gs.BuildingInfo",self.n_SetBuildingInfo,self)
    --原料厂
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","queryMaterialInfo","gs.MaterialInfo",self.n_MaterialFactoryInfo,self)
    --加工厂
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","queryProduceDepInfo","gs.ProduceDepInfo",self.n_ProcessingFactoryInfo,self)
    --零售店
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","queryRetailShopOrApartmentInfo","gs.RetailShopOrApartmentInfo",self.n_RetailShopInfo,self)
   --研究所
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","queryLaboratoryInfo","gs.LaboratoryInfo",self.n_LaboratoryInfo,self)
    --推广
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","queryPromotionCompanyInfo","gs.PromotionCompanyInfo",self.n_PromoteInfo,self)
    --研究所
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","queryLaboratoryInfo","gs.LaboratoryInfo",self.n_LaboratoryInfo,self)
<<<<<<< HEAD

=======
>>>>>>> 1d5cf22761e6761aa4ca9d29e06c2b8f704cd939
end

---客户端请求----
--建筑停业
function BuildingInformationModel:m_ReqClosedBuilding(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "shutdownBusiness","gs.Id",{id = buildingId})
end
--建筑拆除
function BuildingInformationModel:m_ReqDemolitionBuilding(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "delBuilding","gs.Id",{id = buildingId})
end
--建筑改名
function BuildingInformationModel:m_ReqSetBuildingName(buildingId,name)
    DataManager.ModelSendNetMes("gscode.OpCode", "updateBuildingName","gs.UpdateBuildingName",{buildingId = buildingId,name = name})
end

--请求建筑信息
--原料厂建筑信息
function BuildingInformationModel:m_ReqMaterialFactoryInfo(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode", "queryMaterialInfo","gs.QueryBuildingInfo",lMsg)
end
--加工厂建筑信息
function BuildingInformationModel:m_ReqProcessingFactoryInfo(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode", "queryProduceDepInfo","gs.QueryBuildingInfo",lMsg)
end
--零售店建筑信息
function BuildingInformationModel:m_ReqRetailShopInfo(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode", "queryRetailShopOrApartmentInfo","gs.QueryBuildingInfo",lMsg)
end
--研究所建筑信息
function BuildingInformationModel:m_LaboratoryInfo(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode", "queryLaboratoryInfo","gs.QueryBuildingInfo",lMsg)
end
--推广建筑信息
function BuildingInformationModel:m_ReqPromoteInfo(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPromotionCompanyInfo","gs.QueryBuildingInfo",lMsg)
end

---服务器回调---
--建筑停业
function BuildingInformationModel:n_ClosedBuilding(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'closedBuildingSucceed',data)
end
--建筑改名
function BuildingInformationModel:n_SetBuildingInfo(data,msgId)
    if msgId == 0 then
        Event.Brocast("setBuildingNameFailure",msgId)
    else
        DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'setBuildingNameSucceed',data)
    end
end

--请求建筑信息
--原料厂建筑信息
function BuildingInformationModel:n_MaterialFactoryInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'builidngInfo',data)
end
--加工厂建筑信息
function BuildingInformationModel:n_ProcessingFactoryInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'builidngInfo',data)
end
--零售店建筑信息
function BuildingInformationModel:n_RetailShopInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'builidngInfo',data)
end
--研究所建筑信息
function BuildingInformationModel:n_LaboratoryInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'builidngInfo',data)
end
--推广建筑信息
function BuildingInformationModel:n_PromoteInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"BuildingInformationCtrl", 'builidngInfo',data)
end

