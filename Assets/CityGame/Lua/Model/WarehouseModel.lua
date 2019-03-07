WarehouseModel = class("WarehouseModel",ModelBase)

function WarehouseModel:initialize(insId)
    self.insId = insId
    self:_addListener()
end
--启动事件
function WarehouseModel:_addListener()
    --本地事件
    Event.AddListener("m_ReqShelfAdd",self.m_ReqShelfAdd,self)
    Event.AddListener("m_ReqModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqDelItem",self.m_ReqDelItem,self)
    Event.AddListener("m_ReqBuildingTransport",self.m_ReqBuildingTransport,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItem)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
end

---客户端请求---
--上架
function WarehouseModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = tonumber(price)}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfAdd","gs.ShelfAdd",lMsg)
end
--运输
function WarehouseModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    local lMsg = {src = src,dst = dst,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(n)}}
    DataManager.ModelSendNetMes("gscode.OpCode","transferItem","gs.TransferItem",lMsg)
end
--修改数量或价格
function WarehouseModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = price}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfSet","gs.ShelfSet",lMsg)
end
--销毁原料或商品
function WarehouseModel:m_ReqDelItem(buildingId,id,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {id = id,producerId = producerId,qty = qty}}
    DataManager.ModelSendNetMes("gscode.OpCode","delItem","gs.DelItem",lMsg)
end

---回调---
--上架
function WarehouseModel:n_OnShelfAddInfo(data)
    Event.Brocast("n_shelfAdd",data)
    Event.Brocast("SmallPop",GetLanguage(27020002),300)
end
----运输
--function WarehouseModel:n_OnBuildingTransportInfo(data)
--    local bagId = DataManager.GetBagId()
--    local itemId = data.item.key.id
--    local producerId = data.item.key.producerId
--    local qty = data.item.key.qty
--    local n = data.item.n
--    if data.dst == bagId then
--        Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
--    end
--    Event.Brocast("n_transports",data)
--end
--修改数量或价格
function WarehouseModel:n_OnModifyShelfInfo(data)
    --Event.Brocast("shelfRefreshUiInfo",data)
end
--销毁原料或商品
function WarehouseModel:n_OnDelItem(data)
    Event.Brocast("deleteObjeCallback",data)
end


--WarehouseModel = {};
--local this = WarehouseModel;
--local pbl = pbl
--
----构建函数
--function WarehouseModel.New()
--    return this;
--end
--
--function WarehouseModel.Awake()
--    this:OnCreate();
--end
----启动事件
--function WarehouseModel.OnCreate()
--    --注册本地事件 m开头
--    Event.AddListener("m_ReqShelfAdd",this.m_ReqShelfAdd);
--    Event.AddListener("m_ReqModifyShelf",this.m_ReqModifyShelf)
--    Event.AddListener("mReqDelItem",this.mReqDelItem)
--    WarehouseModel.registerAsNetMsg()
--
--end
--
--function WarehouseModel.registerAsNetMsg()
--    --网络回调注册 n开头
--    --DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","shelfAdd","gs.ShelfAdd",WarehouseModel.n_OnShelfAddInfo)
--    --DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","shelfSet","gs.shelfSet",WarehouseModel.n_OnModifyShelfInfo)
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfAdd"),WarehouseModel.n_OnShelfAddInfo)
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfSet"),WarehouseModel.n_OnModifyShelfInfo)
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","delItem"),WarehouseModel.n_GsDelItem);
--    --DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","delItem","gs.DelItem",WarehouseModel.n_GsDelItem)
--end
----关闭事件
--function WarehouseModel.Close()
--    --清空本地UI事件
--end
--
----客户端请求--
----上架物品
--function WarehouseModel.m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
--    ct.log("system",buildingId,Id,num,price,producerId,qty)
--    local msgId = pbl.enum("gscode.OpCode","shelfAdd")
--    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = tonumber(price)}
--    local pMsg = assert(pbl.encode("gs.ShelfAdd", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--
--    --if producerId == nil and qty == nil then
--    --    ct.log("system",buildingId,Id,num,price)
--    --    local msgId = pbl.enum("gscode.OpCode","shelfAdd")
--    --    local lMsg = {buildingId = buildingId, item = {key = {id = Id},n = tonumber(num)}, price = tonumber(price)}
--    --    local pMsg = assert(pbl.encode("gs.ShelfAdd", lMsg))
--    --    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--    --else
--    --
--    --end
--end
----修改货架数量或价格
--function WarehouseModel.m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
--    local msgId = pbl.enum("gscode.OpCode","shelfSet")
--    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = price}
--    local pMsg = assert(pbl.encode("gs.ShelfSet", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--end
----删除仓库物品
--function WarehouseModel.mReqDelItem(buildingId,id,producerId,qty)
--    if producerId == nil and qty == nil then
--        local msgId = pbl.enum("gscode.OpCode","delItem")
--        local lMsg = {buildingId = buildingId, item = {id = id}}
--        local pMsg = assert(pbl.encode("gs.DelItem", lMsg))
--        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--    else
--        local msgId = pbl.enum("gscode.OpCode","delItem")
--        local lMsg = {buildingId = buildingId, item = {id = id,producerId = producerId,qty = qty}}
--        local pMsg = assert(pbl.encode("gs.DelItem", lMsg))
--        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--    end
--end
----网络回调--
----上架物品
--function WarehouseModel.n_OnShelfAddInfo(stream)
--    if stream == nil then
--        return;
--    end
--    local msgShelfAddInfo = assert(pbl.decode("gs.ShelfAdd",stream),"WarehouseModel.n_OnShelfAddInfo")
--    Event.Brocast("n_shelfAdd",msgShelfAddInfo)
--    Event.Brocast("SmallPop",GetLanguage(27020002),300)
--    --Event.Brocast("shelfRefreshInfo",msgShelfAddInfo)
--    --Event.Brocast("refreshShelfInfo",msgShelfAddInfo)
--end
----修改货架数量或价格
--function WarehouseModel.n_OnModifyShelfInfo(stream)
--    local msgModifyShelfInfo = assert(pbl.decode("gs.ShelfSet",stream),"WarehouseModel.n_OnModifyShelfInfo")
--    --Event.Brocast("shelfRefreshUiInfo",msgModifyShelfInfo)
--end
----删除仓库物品
--function WarehouseModel.n_GsDelItem(stream)
--    local pMsg = assert(pbl.decode("gs.DelItem",stream),"WarehouseModel.n_GsDelItem")
--    if pMsg ~= nil then
--        Event.Brocast("deleteObjeCallback",pMsg)
--    end
--end