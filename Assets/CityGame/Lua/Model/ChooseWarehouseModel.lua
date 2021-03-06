---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/28 16:14
---Select warehouse model
ChooseWarehouseModel = class("ChooseWarehouseModel",ModelBase)
local pbl = pbl

function ChooseWarehouseModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function ChooseWarehouseModel:OnCreate()

    --Network callback
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getAllBuildingDetail","gs.BuildingSet",self.n_OnReceiveAllBuildingDetailInfo,self)
    --DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getPlayerBuildingDetail","gs.BuildingSet",self.n_OnReceiveAllRentBuildingDetailInfo,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerBuildings","gs.BuildingInfos",self.n_OnQueryPlayerBuildings,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnDetailMaterialFactory,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnDetailProduceDepartment,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnDetailRetailShop,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailLaboratory","gs.Laboratory",self.n_OnDetailLaboratory,self)
end

function ChooseWarehouseModel:Close()
    --Clear local UI events

end
--Client request--

--Get details on renting your own building
function ChooseWarehouseModel:m_ReqAllBuildingDetail()
    local msgId = pbl.enum("gscode.OpCode", "getAllBuildingDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

--Get details on renting your own building
function ChooseWarehouseModel:m_ReqRentBuildingDetail()
    local msgId = pbl.enum("gscode.OpCode", "getPlayerBuildingDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

--Get friend information
function ChooseWarehouseModel:m_GetMyFriendsInfo(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds})
end

--Get player building packages
function ChooseWarehouseModel:m_QueryPlayerBuildings(id)
     DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerBuildings","gs.Id",{ id = id})
end

--Get building details
function ChooseWarehouseModel:m_DetailBuilding(info)
    if info ==nil then
        return
    end
    for i, v in pairs(info) do
        if PlayerBuildingBaseData[v.mId].storeCapacity ~= -1 then
            local a =  Details[v.mId][1]
            DataManager.ModelSendNetMes("gscode.OpCode", Details[v.mId][1],"gs.Id",{id = v.id})
        end
    end
end

--Server callback--

--Get player building callback
function ChooseWarehouseModel:n_OnQueryPlayerBuildings(lMsg)
    ChooseWarehouseModel:m_DetailBuilding(lMsg.info)
end

function ChooseWarehouseModel:n_OnDetailMaterialFactory(lMsg)
    --local lMsg = assert(pbl.decode("gs.MaterialFactory", stream))
    local detailInfo = {} --Friends building details
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end
function ChooseWarehouseModel:n_OnDetailProduceDepartment(lMsg)
    local detailInfo = {} --Friends building details
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end
function ChooseWarehouseModel:n_OnDetailRetailShop(lMsg)
    local detailInfo = {} --Friends building details
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end
function ChooseWarehouseModel:n_OnDetailLaboratory(lMsg)
    local detailInfo = {} --Friends building details
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end

--Receive all your building details
function ChooseWarehouseModel:n_OnReceiveAllBuildingDetailInfo(data)
    if data then
        DataManager.SetMyAllBuildingDetail(data)
    end
    Event.Brocast("CreateLinePanel")
end
--Receive all your own rental building details
function ChooseWarehouseModel:n_OnReceiveAllRentBuildingDetailInfo(data)
    if data then
        DataManager.SetMyAllBuildingDetail(data)
    end
    Event.Brocast("CreateLinePanel")
end

