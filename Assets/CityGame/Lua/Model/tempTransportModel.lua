tempTransportModel = {}
local this = tempTransportModel
local pbl = pbl

function tempTransportModel.New()
    return this
end

function tempTransportModel.Awake()
    this:OnCreate()
end

--启动事件
function tempTransportModel.OnCreate()
    --注册本地事件 m开头
    Event.AddListener("m_ReqTransport",this.m_ReqTransport);


    tempTransportModel.registerAsNetMsg()
end

function tempTransportModel.registerAsNetMsg()
    --网络回调注册 n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","transferItem"),tempTransportModel.n_OnTransportInfo);

end
--关闭事件
function tempTransportModel.Close()
    --清空本地UI事件
    Event.RemoveListener("m_OnShelfAdd",this.m_OnShelfAdd);
end

--客户端请求--
--运输物品
function tempTransportModel.m_ReqTransport(src,dst, itemId, n)
    ct.log("system",src,dst,itemId,n)
    local msgId = pbl.enum("gscode.OpCode","transferItem")
    local lMsg = {src = src,dst = dst,item = {key = {id = itemId},n = n}}
    local pMsg = assert(pbl.encode("gs.TransferItem", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

--网络回调--
--运输物品
function tempTransportModel.n_OnTransportInfo(stream)
    local msgTransportInfo = assert(pbl.decode("gs.TransferItem",stream),"tempTransportModel.n_OnTransportInfo")
    Event.Brocast("c_transport",msgTransportInfo)
    Event.Brocast("n_transports",msgTransportInfo)
end