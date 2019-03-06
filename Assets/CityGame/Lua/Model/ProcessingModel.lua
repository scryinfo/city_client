
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
