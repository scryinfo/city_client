tempTransportModel = {}
local this = tempTransportModel
local pbl = pbl

function tempTransportModel.New()
    return this
end

function tempTransportModel.Awake()
    this:OnCreate()
end

--Start event
function tempTransportModel.OnCreate()
    --Register local events 
    --Event.AddListener("m_ReqTransport",this.m_ReqTransport);
    --
    --
    --tempTransportModel.registerAsNetMsg()
end

function tempTransportModel.registerAsNetMsg()
    --The network calls back to the beginning of n
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","transferItem"),tempTransportModel.n_OnTransportInfo);
    --DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","transferItem","gs.TransferItem",tempTransportModel.n_OnTransportInfo,tempTransportModel)

end
--Close event
function tempTransportModel.Close()
    --Clear local UI events
    Event.RemoveListener("m_OnShelfAdd",this.m_OnShelfAdd);
end

--Client request--
--Transport items
function tempTransportModel.m_ReqTransport(src,dst, itemId, n,producerId,qty)
    --local msgId = pbl.enum("gscode.OpCode","transferItem")
    --local lMsg = {src = src,dst = dst,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(n)}}
    --local pMsg = assert(pbl.encode("gs.TransferItem", lMsg))
    --CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    DataManager.ModelSendNetMes("gscode.OpCode", "transferItem","gs.TransferItem",
            { src = src,dst = dst,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(n)}} )
end

--Online registration--
--Transport items
function tempTransportModel:n_OnTransportInfo(msgTransportInfo)
    --local msgTransportInfo = assert(pbl.decode("gs.TransferItem",stream),"tempTransportModel.n_OnTransportInfo")
    local bagId = DataManager.GetBagId()

    local itemId = msgTransportInfo.item.key.id
    local producerId = msgTransportInfo.item.key.producerId
    local qty = msgTransportInfo.item.key.qty
    local n = msgTransportInfo.item.n
    if bagId == msgTransportInfo.src then
        Event.Brocast("c_transport",msgTransportInfo)

        Event.Brocast("c_DelBagInfo",itemId,n)
    else
        Event.Brocast("n_transports",msgTransportInfo)
        if msgTransportInfo.dst == bagId then
            Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
        end
    end
end