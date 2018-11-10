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
    --网络回调注册 n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfAdd"),WarehouseModel.n_OnShelfAddInfo);

end
--关闭事件
function WarehouseModel.Close()
    --清空本地UI事件
    Event.RemoveListener("m_OnShelfAdd",this.m_OnShelfAdd);
end

--客户端请求--
--上架物品
function WarehouseModel.m_ReqShelfAdd(itemId,num, price, buildingId)
    local msgId = pbl.enum("gscode.OpCode","shelfAdd")
    local lMsg = {itemId = itemId, num = num, price = price, buildingId = buildingId}
    local pMsg = assert(pbl.encode("gs.ShelfAdd", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

--网络回调--
--上架物品
function WarehouseModel.n_OnShelfAddInfo(stream)
    local msgShelfAddInfo = assert(pbl.decode("gs.ShelfAdd",stream),"WarehouseModel.n_OnShelfAddInfo")

end
