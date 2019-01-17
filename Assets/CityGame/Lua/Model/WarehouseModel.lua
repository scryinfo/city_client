WarehouseModel = {};
local this = WarehouseModel;
local pbl = pbl

--构建函数
function WarehouseModel.New()
    return this;
end

function WarehouseModel.Awake()
    this:OnCreate();
end
--启动事件
function WarehouseModel.OnCreate()
    --注册本地事件 m开头
    Event.AddListener("m_ReqShelfAdd",this.m_ReqShelfAdd);
    Event.AddListener("m_ReqModifyShelf",this.m_ReqModifyShelf)
    Event.AddListener("mReqDelItem",this.mReqDelItem)
    WarehouseModel.registerAsNetMsg()

end

function WarehouseModel.registerAsNetMsg()
    --网络回调注册 n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfAdd"),WarehouseModel.n_OnShelfAddInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfSet"),WarehouseModel.n_OnModifyShelfInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","delItem"),WarehouseModel.n_GsDelItem);

end
--关闭事件
function WarehouseModel.Close()
    --清空本地UI事件
end

--客户端请求--
--上架物品
function WarehouseModel.m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
    if producerId == nil and qty == nil then
        ct.log("system",buildingId,Id,num,price)
        local msgId = pbl.enum("gscode.OpCode","shelfAdd")
        local lMsg = {buildingId = buildingId, item = {key = {id = Id},n = tonumber(num)}, price = tonumber(price)}
        local pMsg = assert(pbl.encode("gs.ShelfAdd", lMsg))
        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    else
        ct.log("system",buildingId,Id,num,price,producerId,qty)
        local msgId = pbl.enum("gscode.OpCode","shelfAdd")
        local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = tonumber(price)}
        local pMsg = assert(pbl.encode("gs.ShelfAdd", lMsg))
        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    end
end
--修改货架数量或价格
function WarehouseModel.m_ReqModifyShelf(buildingId,Id,num,price)
    local msgId = pbl.enum("gscode.OpCode","shelfSet")
    local lMsg = {buildingId = buildingId, item = {key = {id = Id},n = num}, price = price}
    local pMsg = assert(pbl.encode("gs.ShelfSet", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end
--删除仓库物品
function WarehouseModel.mReqDelItem(buildingId,id,producerId,qty)
    if producerId == nil and qty == nil then
        local msgId = pbl.enum("gscode.OpCode","delItem")
        local lMsg = {buildingId = buildingId, item = {id = id}}
        local pMsg = assert(pbl.encode("gs.DelItem", lMsg))
        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    else
        local msgId = pbl.enum("gscode.OpCode","delItem")
        local lMsg = {buildingId = buildingId, item = {key = {id = id,producerId = producerId,qty = qty}}}
        local pMsg = assert(pbl.encode("gs.DelItem", lMsg))
        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    end
end
--网络回调--
--上架物品
function WarehouseModel.n_OnShelfAddInfo(stream)
    if stream == nil then
        return;
    end
    local msgShelfAddInfo = assert(pbl.decode("gs.Shelf.Content",stream),"WarehouseModel.n_OnShelfAddInfo")
    Event.Brocast("n_shelfAdd",msgShelfAddInfo)
    Event.Brocast("SmallPop","上架成功",300)
    Event.Brocast("shelfRefreshInfo",msgShelfAddInfo)
    Event.Brocast("refreshShelfInfo",msgShelfAddInfo)
end
--修改货架数量或价格
function WarehouseModel.n_OnModifyShelfInfo(stream)
    local msgModifyShelfInfo = assert(pbl.decode("gs.ShelfSet",stream),"WarehouseModel.n_OnModifyShelfInfo")
    Event.Brocast("refreshUiInfo",msgModifyShelfInfo)
end
--删除仓库物品
function WarehouseModel.n_GsDelItem(stream)
    local pMsg = assert(pbl.decode("gs.DelItem",stream),"WarehouseModel.n_GsDelItem")
    --Event.Brocast("warehousedeleteGoods",msgGoodItemInfo)
end