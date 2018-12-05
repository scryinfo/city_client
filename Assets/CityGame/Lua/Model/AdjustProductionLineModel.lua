local pbl = pbl

AdjustProductionLineModel = {}
local this = AdjustProductionLineModel;

--构建函数
function AdjustProductionLineModel.New()
    return this;
end

function AdjustProductionLineModel.Awake()
    this:OnCreate();
end

--启动事件
function AdjustProductionLineModel.OnCreate()
    --注册本地事件
    Event.AddListener("m_ReqAddLine",this.m_ReqAddLine);
    Event.AddListener("m_ResModifyKLine",this.m_ResModifyKLine);
    Event.AddListener("m_ReqDeleteLine",this.m_ReqDeleteLine);

    ----注册 AccountServer 消息
    AdjustProductionLineModel.registerAsNetMsg()
end

function AdjustProductionLineModel.registerAsNetMsg()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addLine"),AdjustProductionLineModel.n_GsDetermineBtn);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","changeLine"),AdjustProductionLineModel.n_GsModifyKLine);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","delLine"),AdjustProductionLineModel.nGsDeleteLine);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","lineChangeInform"),AdjustProductionLineModel.n_GsLineChangeInform);

end
--客户端请求--
--添加生产线
function AdjustProductionLineModel.m_ReqAddLine(buildingId,number,steffNumber,itemId)
    local msgId = pbl.enum("gscode.OpCode", "addLine")
    local lMsg = {id = buildingId, itemId = itemId, targetNum = tonumber(number), workerNum = tonumber(steffNumber)}
    local pMsg = assert(pbl.encode("gs.AddLine", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--修改生产线
function AdjustProductionLineModel.m_ResModifyKLine(buildingId,targetNum,steffNumber,lineId)
    local msgId = pbl.enum("gscode.OpCode", "changeLine")
    local lMsg = {buildingId = buildingId,targetNum = tonumber(targetNum),workerNum = tonumber(steffNumber),lineId = lineId}
    local pMsg = assert(pbl.encode("gs.ChangeLine", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--删除生产线
function AdjustProductionLineModel.m_ReqDeleteLine(buildingId,lineId)
    local msgId = pbl.enum("gscode.OpCode", "delLine")
    local lMsg = {buildingId = buildingId, lineId = lineId}
    local pMsg = assert(pbl.encode("gs.DelLine", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--服务器回调--
--添加生产线
function AdjustProductionLineModel.n_GsDetermineBtn(stream)
    if stream == nil then
        return;
    end
    local msgAllGameServerInfo = assert(pbl.decode("gs.Line", stream), "AdjustProductionLineModel.n_GsDetermineBtn: stream == nil")
    Event.Brocast("calculateTime",msgAllGameServerInfo)
    Event.Brocast("refreshIdleWorkerNum",msgAllGameServerInfo)
    Event.Brocast("SmallPop","添加成功",300)
end
--修改生产线
function AdjustProductionLineModel.n_GsModifyKLine(stream)
    local msgModifyKLineInfo = assert(pbl.decode("gs.ChangeLine", stream), "AdjustProductionLineModel.n_GsModifyKLine: stream == nil")
    Event.Brocast("calculateTime",msgModifyKLineInfo)
end
--删除生产线
function AdjustProductionLineModel.nGsDeleteLine(stream)
    if stream == nil then
        return;
    end
    Event.Brocast("SmallPop","删除成功",300)
    --local msgProductionLine = assert(pbl.decode("gs.DelLine"),"AdjustProductionLineModel.nGsDeleteLine: stream == nil")
end
--生产线变化推送
function AdjustProductionLineModel.n_GsLineChangeInform(stream)
    local msgLineChangeInfo = assert(pbl.decode("gs.LineInfo",stream),"AdjustProductionLineModel.n_GsLineChangeInform: stream == nil")
    --Event.Brocast("refreshTimeText",msgLineChangeInfo)
end