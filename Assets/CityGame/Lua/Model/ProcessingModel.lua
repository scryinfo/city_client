
ProcessingModel = class("ProcessingModel",ModelBase)
local pbl = pbl

function ProcessingModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function ProcessingModel:OnCreate()
    Event.AddListener("mReqCloseProcessing",self.mReqCloseProcessing,self)
    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnOpenProcessing)
end

function ProcessingModel:Close()
    --清空本地UI事件
end

--客户端请求--
--打开加工厂
function ProcessingModel:m_ReqOpenProcessing(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailProduceDepartment","gs.Id",{id = buildingId})
end
--改变建筑名字
function ProcessingModel:m_ReqChangeProcessingName(buildingId,name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = buildingId, name = name})
end
--关闭加工厂详情推送消息
function ProcessingModel:mReqCloseProcessing(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
end
--服务器回调--
--打开加工厂
function ProcessingModel:n_OnOpenProcessing(stream)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessingCtrl", 'refreshProcessingDataInfo',stream)
end

--[[
local pbl = pbl

ProcessingModel = {}
local this = ProcessingModel;

--构建函数
function ProcessingModel.New()
    return this;
end

function ProcessingModel.Awake()
    this:OnCreate();
end

function ProcessingModel.OnCreate()
    --注册本地事件
    Event.AddListener("m_ReqOpenProcessing",this.m_ReqOpenProcessing)


    ProcessingModel.registerAsNetMsg()
end

function ProcessingModel.registerAsNetMsg()
    --注册网络回调
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailProduceDepartment"),ProcessingModel.n_OnOpenProcessing);

end

function ProcessingModel.Close()
    --清空本地UI事件
end

--客户端请求
--打开加工厂
function ProcessingModel.m_ReqOpenProcessing(id)
    local msgId = pbl.enum("gscode.OpCode","detailProduceDepartment")
    local lMsg = {id = id}
    local pMsg = assert(pbl.encode("gs.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

--服务器回调
function ProcessingModel.n_OnOpenProcessing(stream)
    if stream == nil or stream == "" then
        return;
    end
    local msgProcessing = assert(pbl.decode("gs.ProduceDepartment",stream),"ProcessingModel.n_OnOpenProcessing")
    if msgProcessing then
        ProcessingModel.dataDetailsInfo = msgProcessing;
        ProcessingModel.buildingId = msgProcessing.info.id;
        ProcessingModel.processingWarehouse = msgProcessing.store.inHand;
        ProcessingModel.processingShelf = msgProcessing.shelf.good;
        ProcessingModel.buildingCode = msgProcessing.info.mId;
    end
    Event.Brocast("refreshProcessingDataInfo",msgProcessing)
end]]
