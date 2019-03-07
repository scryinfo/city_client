ShelfModel = class("ShelfModel",ModelBase)

function ShelfModel:initialize(insId)
    self.insId = insId
    self:_addListener()
end
--启动事件
function ShelfModel:_addListener()
    --本地事件
    Event.AddListener("m_ReqShelfDel",self.m_ReqShelfDel,self)
    Event.AddListener("m_ReqBuyShelfGoods",self.m_ReqBuyShelfGoods,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoods)
end

---客户端请求---
--下架
function ShelfModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = num}}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfDel","gs.ShelfDel",lMsg)
end
--购买
function ShelfModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(number)},price = tonumber(price),wareHouseId = wareHouseId}
    DataManager.ModelSendNetMes("gscode.OpCode","buyInShelf","gs.BuyInShelf",lMsg)
end
---回调---
--下架
function ShelfModel:n_OnShelfDelInfo(data)
    Event.Brocast("delGoodRefreshInfo",data)
end
--购买
function ShelfModel:n_OnBuyShelfGoods(data)
    Event.Brocast("receiveBuyRefreshInfo",data)
end


--ShelfModel = {}
--local this = ShelfModel;
--local pbl = pbl

----构建函数
--function ShelfModel.New()
--    return this;
--end
--
--function ShelfModel.Awake()
--    this:OnCreate();
--end
--
--function ShelfModel.OnCreate()
--    --注册本地事件 m开头
--    Event.AddListener("m_ReqShelfDel",this.m_ReqShelfDel)
--    Event.AddListener("m_ReqBuyShelfGoods",this.m_ReqBuyShelfGoods)
--    --Event.AddListener("n_OnShelfDelInfo",this.n_OnShelfDelInfo)
--    ShelfModel.registerAsNetMsg()
--end
--
--function ShelfModel.registerAsNetMsg()
--    --网络回调注册 n开头
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shelfDel"),ShelfModel.n_OnShelfDelInfo);
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","buyInShelf"),ShelfModel.n_OnBuyShelfGoods);
--end
--
----关闭事件
--function ShelfModel.Close()
--    --清空本地UI事件
--end
--
----客户端请求--
----下架物品
--function ShelfModel.m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
--    local msgId = pbl.enum("gscode.OpCode","shelfDel")
--    local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = num}}
--    local pMsg = assert(pbl.encode("gs.ShelfDel", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--end
----购买物品
--function ShelfModel.m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
--    if producerId == nil and qty == nil then
--        local msgId = pbl.enum("gscode.OpCode","buyInShelf")
--        local lMsg = {buildingId = buildingId,item = {key = {id = itemId},n = tonumber(number)},price = tonumber(price),wareHouseId = wareHouseId}
--        local pMsg = assert(pbl.encode("gs.BuyInShelf", lMsg))
--        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--    else
--        local msgId = pbl.enum("gscode.OpCode","buyInShelf")
--        local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(number)},price = tonumber(price),wareHouseId = wareHouseId}
--        local pMsg = assert(pbl.encode("gs.BuyInShelf", lMsg))
--        CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
--    end
--end
----网络回调--
----下架物品
--function ShelfModel.n_OnShelfDelInfo(stream)
--    local msgShelfDelInfo = assert(pbl.decode("gs.ShelfDel",stream),"ShelfModel.n_OnShelfDelInfo")
--    Event.Brocast("delGoodRefreshInfo",msgShelfDelInfo)
--end
----购买物品
--function ShelfModel.n_OnBuyShelfGoods(stream)
--    local msgBuyShelfGoods = assert(pbl.decode("gs.BuyInShelf",stream),"ShelfModel.n_OnBuyShelfGoods")
--    Event.Brocast("receiveBuyRefreshInfo",msgBuyShelfGoods);
--end