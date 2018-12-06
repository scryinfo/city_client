ShelfModel = {}
local this = ShelfModel;
local pbl = pbl

--构建函数
function ShelfModel.New()
    return this;
end

function ShelfModel.Awake()
    this:OnCreate();
end

function ShelfModel.OnCreate()
    --注册本地事件 m开头
    Event.AddListener("m_ReqShelfDel",this.m_ReqShelfDel)
    Event.AddListener("n_OnShelfDelInfo",this.n_OnShelfDelInfo)
    ShelfModel.registerAsNetMsg()
end

function ShelfModel.registerAsNetMsg()
    --网络回调注册 n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfDel"),ShelfModel.n_OnShelfDelInfo);
end

--关闭事件
function ShelfModel.Close()
    --清空本地UI事件
end

--客户端请求--
--下架物品
function ShelfModel.m_ReqShelfDel(buildingId,itemId,num)
    local msgId = pbl.enum("gscode.OpCode","shelfDel")
    local lMsg = {buildingId = buildingId,item = {key = {id = itemId},n = num}}
    local pMsg = assert(pbl.encode("gs.ShelfDel", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

--网络回调--
--下架物品
function ShelfModel.n_OnShelfDelInfo(stream)
    local msgShelfDelInfo = assert(pbl.decode("gs.ShelfDel",stream),"ShelfModel.n_OnShelfDelInfo")
end