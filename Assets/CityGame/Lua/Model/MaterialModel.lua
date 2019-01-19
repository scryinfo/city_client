
MaterialModel = class("MaterialModel",ModelBase)
local pbl = pbl

function MaterialModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function MaterialModel:OnCreate()
    Event.AddListener("mReqCloseMaterial",self.mReqCloseMaterial,self)
    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnOpenMaterial)
end

function MaterialModel:Close()
    --清空本地UI事件
end
--客户端请求--
--打开原料厂
function MaterialModel:m_ReqOpenMaterial(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailMaterialFactory","gs.Id",{id = buildingId})
end

--改变建筑名字
function MaterialModel:m_ReqChangeMaterialName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = id, name = name})
end
--关闭原料厂详情推送消息
function MaterialModel:mReqCloseMaterial(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
end
--服务器回调--
--打开原料厂
function MaterialModel:n_OnOpenMaterial(stream)
    DataManager.ControllerRpcNoRet(self.insId,"MaterialCtrl", 'refreshMaterialDataInfo',stream)
end


--[[
local pbl = pbl

MaterialModel = {};
local this = MaterialModel;

--构建函数
function MaterialModel.New()
    return this;
end

function MaterialModel.Awake()
    this:OnCreate();
end

function MaterialModel.OnCreate()

    --注册本地UI事件
    Event.AddListener("m_ReqOpenMaterial",this.m_ReqOpenMaterial)

    MaterialModel.registerAsNetMsg()
end

function MaterialModel.registerAsNetMsg()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailMaterialFactory"),MaterialModel.n_OnOpenMaterial);
end

function MaterialModel.Close()
    --清空本地UI事件
end
--客户端请求--
--打开原料厂
function MaterialModel.m_ReqOpenMaterial(id)
    local msgId = pbl.enum("gscode.OpCode","detailMaterialFactory")
    local lMsg = {id = id}
    local pMsg = assert(pbl.encode("gs.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

--网络回调--
--打开原料厂
function MaterialModel.n_OnOpenMaterial(stream)
    if stream == nil or stream == "" then
        return;
    end
    local msgMaterial = assert(pbl.decode("gs.MaterialFactory",stream),"MaterialModel.n_OnOpenMaterial")
    if msgMaterial then
        MaterialModel.dataDetailsInfo = msgMaterial;
        MaterialModel.buildingId = msgMaterial.info.id;
        MaterialModel.materialWarehouse = msgMaterial.store.inHand;
        MaterialModel.materialShelf = msgMaterial.shelf.good;
        MaterialModel.materialProductionLine = msgMaterial.line;
        MaterialModel.buildingCode = msgMaterial.info.mId;
    end
    Event.Brocast("refreshMaterialDataInfo",MaterialModel.dataDetailsInfo)
end
]]
