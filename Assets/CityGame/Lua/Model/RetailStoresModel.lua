RetailStoresModel = class("RetailStoresModel",ModelBase)
local pbl = pbl

function RetailStoresModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function RetailStoresModel:OnCreate()
    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnOpenRetailShop)

end

function RetailStoresModel:Close()
    --清空本地UI事件
end
--客户端请求--
--打开零售店
function RetailStoresModel:m_ReqOpenRetailShop(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailRetailShop","gs.Id",{id = buildingId})
end

--服务器回调--
--打开零售店
function RetailStoresModel:n_OnOpenRetailShop(stream)
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", 'refreshRetailShopDataInfo',stream)
end