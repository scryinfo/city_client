RetailStoresModel = class("RetailStoresModel",ModelBase)
local pbl = pbl

function RetailStoresModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function RetailStoresModel:OnCreate()
    --本地事件
    Event.AddListener("mReqCloseRetailStores",self.mReqCloseRetailStores,self)
    Event.AddListener("m_RetailTransport",self.m_ReqBuildingTransport,self)
    Event.AddListener("m_ReqRetailShelfAdd",self.m_ReqShelfAdd,self)
    Event.AddListener("m_ReqRetailModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqRetailShelfDel",self.m_ReqShelfDel,self)
    Event.AddListener("m_ReqRetailDelItem",self.m_ReqDelItem,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnOpenRetailShop)
    --仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    --货架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
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
--运输
function RetailStoresModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function RetailStoresModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
end
--修改货架价格
function RetailStoresModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
end
--下架
function RetailStoresModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--销毁仓库原料或商品
function RetailStoresModel:m_ReqDelItem(buildingId,id,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,id,producerId,qty)
end
---服务器回调---
--打开零售店
function RetailStoresModel:n_OnOpenRetailShop(stream)
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", 'refreshRetailShopDataInfo',stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
end
--运输
function RetailStoresModel:n_OnBuildingTransportInfo(data)
    local bagId = DataManager.GetBagId()
    local n = data.item.n
    local itemId = data.item.key.id
    local qty = data.item.key.qty
    local producerId = data.item.key.producerId
    if data.dst == bagId then
        Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
    end
    DataManager.ControllerRpcNoRet(self.insId,"RetailWarehouseCtrl",'RefreshWarehouseData',data,true)
end
--上架
function RetailStoresModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"RetailWarehouseCtrl",'RefreshWarehouseData',data,false)
end
--修改货架价格
function RetailStoresModel:n_OnModifyShelfInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"RetailShelfCtrl",'RefreshShelfData',data)
end
--下架
function RetailStoresModel:n_OnShelfDelInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"RetailShelfCtrl",'RefreshShelfData',data)
end
--销毁仓库原料或商品
function RetailStoresModel:n_OnDelItemInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"RetailWarehouseCtrl",'DestroyAfterRefresh',data)
end