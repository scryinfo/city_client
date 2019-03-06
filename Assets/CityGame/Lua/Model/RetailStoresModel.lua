RetailStoresModel = class("RetailStoresModel",ModelBase)
local pbl = pbl

function RetailStoresModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function RetailStoresModel:OnCreate()
    Event.AddListener("mReqCloseRetailStores",self.mReqCloseRetailStores,self)
    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnOpenRetailShop)
end

function RetailStoresModel:Close()
    --清空本地UI事件
end
---客户端请求---
--打开零售店
function RetailStoresModel:m_ReqOpenRetailShop(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailRetailShop","gs.Id",{id = buildingId})
end
--改变建筑名字
function RetailStoresModel:m_ReqChangeRetailName(buildingId, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = buildingId, name = name})
end
--关闭零售店详情推送
function RetailStoresModel:mReqCloseRetailStores(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
end
---服务器回调---
--打开零售店
function RetailStoresModel:n_OnOpenRetailShop(stream)
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", 'refreshRetailShopDataInfo',stream)
end