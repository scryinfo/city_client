AdjustProductionLineModel = class("AdjustProductionLineModel",ModelBase)

function AdjustProductionLineModel:initialize(insId)
    self.insId = insId
    self:_addListener()
end
--启动事件
function AdjustProductionLineModel:_addListener()
    --本地事件
    Event.AddListener("m_ReqAddLine",self.m_ReqAddLine,self)
    Event.AddListener("m_ResModifyKLine",self.m_ResModifyKLine,self)
    Event.AddListener("m_ReqDeleteLine",self.m_ReqDeleteLine,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyAddLine","gs.FtyLineAddInform",self.n_OnAddLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyChangeLine","gs.ChangeLine",self.n_OnModifyKLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyDelLine","gs.DelLine",self.n_OnDeleteLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineChangeInform","gs.LineInfo",self.n_OnLineChangeInform)
end

---客户端请求---
--添加生产线
function AdjustProductionLineModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    local lMsg = {id = buildingId, itemId = itemId, targetNum = number, workerNum = tonumber(steffNumber)}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyAddLine","gs.AddLine",lMsg)
end
--修改生产线
function AdjustProductionLineModel:m_ResModifyKLine(buildingId,targetNum,steffNumber,lineId)
    local lMsg = {buildingId = buildingId,targetNum = targetNum,workerNum = tonumber(steffNumber),lineId = lineId}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyChangeLine","gs.ChangeLine",lMsg)
end
--删除生产线
function AdjustProductionLineModel:m_ReqDeleteLine(buildingId,lineId)
    local lMsg = {buildingId = buildingId, lineId = lineId}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyDelLine","gs.DelLine",lMsg)
end
---回调---
--添加生产线
function AdjustProductionLineModel:n_OnAddLineInfo(data)
    Event.Brocast("calculateTime",data)
    Event.Brocast("refreshSubtractWorkerNum",data)
    Event.Brocast("SmallPop",GetLanguage(28010007),300)
end
--修改生产线
function AdjustProductionLineModel:n_OnModifyKLineInfo(data)
    Event.Brocast("callbackDataInfo",data)
    Event.Brocast("SmallPop",GetLanguage(27010005),300)
end
--删除生产线
function AdjustProductionLineModel:n_OnDeleteLineInfo(data)
    Event.Brocast("SmallPop",GetLanguage(28010006),300)
    Event.Brocast("_deleteProductionLine",data)
end
--生产线变化推送
function AdjustProductionLineModel:n_OnLineChangeInform(data)
    Event.Brocast("refreshNowConte",data)
    Event.Brocast("c_refreshNowConte",data)
end




--local pbl = pbl

--AdjustProductionLineModel = {}
--local this = AdjustProductionLineModel;

----构建函数
--function AdjustProductionLineModel.New()
--    return this;
--end
--
--function AdjustProductionLineModel.Awake()
--    this:OnCreate();
--end
--
----启动事件
--function AdjustProductionLineModel.OnCreate()
--    --注册本地事件
--    Event.AddListener("m_ReqAddLine",this.m_ReqAddLine);
--    Event.AddListener("m_ResModifyKLine",this.m_ResModifyKLine);
--    Event.AddListener("m_ReqDeleteLine",this.m_ReqDeleteLine);
--
--    ----注册 AccountServer 消息
--    AdjustProductionLineModel.registerAsNetMsg()
--end
--
--function AdjustProductionLineModel.registerAsNetMsg()
--    --网络回调注册
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","ftyLineAddInform"),AdjustProductionLineModel.n_GsDetermineBtn);
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","ftyChangeLine"),AdjustProductionLineModel.n_GsModifyKLine);
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","ftyDelLine"),AdjustProductionLineModel.nGsDeleteLine);
--    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","ftyLineChangeInform"),AdjustProductionLineModel.n_GsLineChangeInform);
--
--end
----客户端请求--
----添加生产线
--function AdjustProductionLineModel.m_ReqAddLine(buildingId,number,steffNumber,itemId)
--    local msgId = pbl.enum("gscode.OpCode", "ftyAddLine")
--    local lMsg = {id = buildingId, itemId = itemId, targetNum = number, workerNum = tonumber(steffNumber)}
--    local pMsg = assert(pbl.encode("gs.AddLine", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
--end
----修改生产线
--function AdjustProductionLineModel.m_ResModifyKLine(buildingId,targetNum,steffNumber,lineId)
--    local msgId = pbl.enum("gscode.OpCode", "ftyChangeLine")
--    local lMsg = {buildingId = buildingId,targetNum = targetNum,workerNum = tonumber(steffNumber),lineId = lineId}
--    local pMsg = assert(pbl.encode("gs.ChangeLine", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
--end
----删除生产线
--function AdjustProductionLineModel.m_ReqDeleteLine(buildingId,lineId)
--    local msgId = pbl.enum("gscode.OpCode", "ftyDelLine")
--    local lMsg = {buildingId = buildingId, lineId = lineId}
--    local pMsg = assert(pbl.encode("gs.DelLine", lMsg))
--    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
--end
----服务器回调--
----添加生产线
--function AdjustProductionLineModel.n_GsDetermineBtn(stream)
--    if stream == nil then
--        return;
--    end
--    local msgAllGameServerInfo = assert(pbl.decode("gs.FtyLineAddInform", stream), "AdjustProductionLineModel.n_GsDetermineBtn: stream == nil")
--    Event.Brocast("calculateTime",msgAllGameServerInfo)
--    Event.Brocast("refreshSubtractWorkerNum",msgAllGameServerInfo)
--    Event.Brocast("SmallPop",GetLanguage(28010007),300)
--    --Event.Brocast("productionRefreshInfo",msgAllGameServerInfo)
--end
----修改生产线
--function AdjustProductionLineModel.n_GsModifyKLine(stream)
--    local msgModifyKLineInfo = assert(pbl.decode("gs.ChangeLine", stream), "AdjustProductionLineModel.n_GsModifyKLine: stream == nil")
--    if not msgModifyKLineInfo then
--        return
--    end
--    Event.Brocast("callbackDataInfo",msgModifyKLineInfo)
--    Event.Brocast("SmallPop",GetLanguage(27010005),300)
--end
----删除生产线
--function AdjustProductionLineModel.nGsDeleteLine(stream)
--    if stream == nil then
--        return;
--    end
--    local msgProductionLine = assert(pbl.decode("gs.DelLine",stream),"AdjustProductionLineModel.nGsDeleteLine: stream == nil")
--    Event.Brocast("SmallPop",GetLanguage(28010006),300)
--    Event.Brocast("_deleteProductionLine",msgProductionLine)
--    --Event.Brocast("delLineRefreshInfo",msgProductionLine)
--end
----生产线变化推送
--function AdjustProductionLineModel.n_GsLineChangeInform(stream)
--    local msgLineChangeInfo = assert(pbl.decode("gs.LineInfo",stream),"AdjustProductionLineModel.n_GsLineChangeInform: stream == nil")
--    Event.Brocast("refreshNowConte",msgLineChangeInfo)
--    Event.Brocast("c_refreshNowConte",msgLineChangeInfo)
--end