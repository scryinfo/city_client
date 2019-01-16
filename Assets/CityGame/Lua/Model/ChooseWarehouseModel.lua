---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/28 16:14
---选择仓库model
ChooseWarehouseModel = class("ChooseWarehouseModel",ModelBase)
local pbl = pbl

function ChooseWarehouseModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function ChooseWarehouseModel:OnCreate()

    --Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)
    --网络回调
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getAllBuildingDetail","gs.BuildingSet",self.n_OnReceiveAllBuildingDetailInfo,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerBuildings","gs.BuildingInfos",self.n_OnQueryPlayerBuildings,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnDetailMaterialFactory,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnDetailProduceDepartment,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnDetailRetailShop,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailLaboratory","gs.Laboratory",self.n_OnDetailLaboratory,self)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryPlayerBuildings"),ChooseWarehouseModel.n_OnQueryPlayerBuildings);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryPlayerBuildings"),ChooseWarehouseModel.n_OnQueryPlayerBuildings);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailMaterialFactory"),ChooseWarehouseModel.n_OnDetailMaterialFactory);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailProduceDepartment"),ChooseWarehouseModel.n_OnDetailProduceDepartment);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailRetailShop"),ChooseWarehouseModel.n_OnDetailRetailShop);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailLaboratory"),ChooseWarehouseModel.n_OnDetailLaboratory);

end

function ChooseWarehouseModel:Close()
    --清空本地UI事件

end
--客户端请求--

--获取自己的建筑详情
function ChooseWarehouseModel:m_ReqAllBuildingDetail()
    local msgId = pbl.enum("gscode.OpCode", "getAllBuildingDetail")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

--获取好友信息
function ChooseWarehouseModel:m_GetMyFriendsInfo(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds})
   -- local msgId = pbl.enum("gscode.OpCode","queryPlayerInfo")
   -- local lMsg = { ids = friendsIds }
   -- local  pMsg = assert(pbl.encode("gs.Bytes", lMsg))
   -- CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end

--获取玩家建筑发包
function ChooseWarehouseModel:m_QueryPlayerBuildings(id)
     DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerBuildings","gs.Id",{ id = id})
end

--获取建筑详情发包
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

--服务器回调--
--获取玩家建筑回调
function ChooseWarehouseModel:n_OnQueryPlayerBuildings(lMsg)
    --DataManager.ControllerRpcNoRet(self.insId,"GameMainInterfaceCtrl", '_receiveAllMails',stream)
   -- local lMsg = assert(pbl.decode("gs.BuildingInfos", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    ChooseWarehouseModel:m_DetailBuilding(lMsg.info)
    --Event.Brocast("c_OnQueryPlayerBuildings",lMsg.info)
end

function ChooseWarehouseModel:n_OnDetailMaterialFactory(lMsg)
    --local lMsg = assert(pbl.decode("gs.MaterialFactory", stream))
    local detailInfo = {} --好友建筑详情
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end
function ChooseWarehouseModel:n_OnDetailProduceDepartment(lMsg)
    --local lMsg = assert(pbl.decode("gs.ProduceDepartment", stream))
    local detailInfo = {} --好友建筑详情
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end
function ChooseWarehouseModel:n_OnDetailRetailShop(lMsg)
    --local lMsg = assert(pbl.decode("gs.RetailShop", stream))
    local detailInfo = {} --好友建筑详情
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end
function ChooseWarehouseModel:n_OnDetailLaboratory(lMsg)
    --local lMsg = assert(pbl.decode("gs.Laboratory", stream))
    local detailInfo = {} --好友建筑详情
    local i = 1
    detailInfo[i] = lMsg
    if lMsg ~= nil then
        Event.Brocast("c_OnCreatFriendsLinePanel",detailInfo)
    end
end

--收到自己所有建筑详情
function ChooseWarehouseModel:n_OnReceiveAllBuildingDetailInfo(data)
    if data then
        DataManager.SetMyAllBuildingDetail(data)
    end
    Event.Brocast("CreateLinePanel")
end

