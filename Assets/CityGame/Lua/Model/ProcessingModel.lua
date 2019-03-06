
ProcessingModel = class("ProcessingModel",ModelBase)
local pbl = pbl

function ProcessingModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function ProcessingModel:OnCreate()
    --本地事件
    Event.AddListener("mReqCloseProcessing",self.mReqCloseProcessing,self)
    Event.AddListener("m_ProcessTransport",self.m_ReqBuildingTransport,self)
    Event.AddListener("m_ReqProcessShelfAdd",self.m_ReqShelfAdd,self)
    Event.AddListener("m_ReqProcessModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqProcessShelfDel",self.m_ReqShelfDel,self)
    Event.AddListener("m_ReqProcessAddLine",self.m_ReqAddLine,self)
    Event.AddListener("m_ReqProcessDeleteLine",self.m_ReqDeleteLine,self)
    Event.AddListener("m_ReqProcessBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.AddListener("m_ReqProcessDelItem",self.m_ReqDelItem,self)
    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnOpenProcessing)
    --仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    --货架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    --生产线
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnAddLineInfo)
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyChangeLine","gs.ChangeLine",self.n_OnModifyKLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyDelLine","gs.DelLine",self.n_OnDeleteLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineChangeInform","gs.LineInfo",self.n_OnLineChangeInform)
end

function ProcessingModel:Close()
    --清空本地UI事件
end

---客户端请求---
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
--运输
function ProcessingModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function ProcessingModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
end
--修改货架价格
function ProcessingModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
end
--下架
function ProcessingModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--添加生产线
function ProcessingModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    self.funModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
end
--删除生产线
function ProcessingModel:m_ReqDeleteLine(buildingId,lineId)
    self.funModel:m_ReqDeleteLine(buildingId,lineId)
end
--货架购买
function ProcessingModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--销毁仓库原料或商品
function ProcessingModel:m_ReqDelItem(buildingId,id,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,id,producerId,qty)
end
---服务器回调---
--打开加工厂
function ProcessingModel:n_OnOpenProcessing(stream)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessingCtrl", 'refreshProcessingDataInfo',stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
end
--运输
function ProcessingModel:n_OnBuildingTransportInfo(data)
    local bagId = DataManager.GetBagId()
    local n = data.item.n
    local itemId = data.item.key.id
    local qty = data.item.key.qty
    local producerId = data.item.key.producerId
    if data.dst == bagId then
        --Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
    end
    DataManager.ControllerRpcNoRet(self.insId,"ProcessWarehouseCtrl",'RefreshWarehouseData',data,true)
end
--上架
function ProcessingModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessWarehouseCtrl",'RefreshWarehouseData',data,false)
end
--修改货架数量或价格
function ProcessingModel:n_OnModifyShelfInfo(data)
    local aaa = data
    -----------------------------------------
end
--下架
function ProcessingModel:n_OnShelfDelInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessShelfCtrl",'RefreshShelfData',data)
end
--添加生产线
function ProcessingModel:n_OnAddLineInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"AddLineBoxCtrl",'SucceedUpdatePanel',data)
end
--删除生产线
function ProcessingModel:n_OnDeleteLineInfo(data)
    Event.Brocast("DeleteLineRefresh",data)
end
--生产线变化推送
function ProcessingModel:n_OnLineChangeInform(data)
    Event.Brocast("c_refreshNowConte",data)
end
--货架购买
function ProcessingModel:n_OnBuyShelfGoodsInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessShelfCtrl",'RefreshShelfData',data)
end
--销毁仓库原料或商品
function ProcessingModel:n_OnDelItemInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessWarehouseCtrl",'DestroyAfterRefresh',data)
end
