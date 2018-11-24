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
    Event.AddListener("m_ReqDetermineBtn",this.m_ReqDetermineBtn);
    Event.AddListener("m_ResModifyKLine",this.m_ResModifyKLine);

    ----注册 AccountServer 消息
    AdjustProductionLineModel.registerAsNetMsg()
end

function AdjustProductionLineModel.registerAsNetMsg()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addLine"),AdjustProductionLineModel.n_GsDetermineBtn);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","lineChangeInform"),AdjustProductionLineModel.n_GsDetermineBtn);

end
--客户端请求--

--添加生产线
function AdjustProductionLineModel.m_ReqDetermineBtn(buildingId,number,steffNumber,itemId)
    local msgId = pbl.enum("gscode.OpCode", "addLine")
    local lMsg = {id = buildingId, itemId = itemId, targetNum = number, workerNum = steffNumber}
    local pMsg = assert(pbl.encode("gs.AddLine", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end

--修改生产线
function AdjustProductionLineModel.m_ResModifyKLine(buildingId,targetNum,steffNumber,lineId)
    local msgId = pbl.enum("gscode.OpCode", "changeLine")
    local lMsg = {buildingId = buildingId,targetNum = targetNum,workerNum = steffNumber,lineId = lineId}
    local pMsg = assert(pbl.encode("gs.ChangeLine", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end

--服务器回调--

--添加生产线
function AdjustProductionLineModel.n_GsDetermineBtn(stream)
    local msgAllGameServerInfo = assert(pbl.decode("gs.Line", stream), "AdjustProductionLineModel.n_GsDetermineBtn: stream == nil")
    Event.Brocast("calculateTime",msgAllGameServerInfo)
end
--修改生产线
function AdjustProductionLineModel.n_GsModifyKLine(stream)
    local msgModifyKLineInfo = assert(pbl.decode("gs.ChangeLine", stream), "AdjustProductionLineModel.n_GsModifyKLine: stream == nil")
    Event.Brocast("calculateTime",msgModifyKLineInfo)
end
--生产线变化推送
function AdjustProductionLineModel.n_GsLineChangeInform(stream)
    local msgLineChangeInfo = assert(pbl.decode("gs.LineInfo",stream),"AdjustProductionLineModel.n_GsLineChangeInform: stream == nil")

end