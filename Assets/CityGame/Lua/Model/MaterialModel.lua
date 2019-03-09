MaterialModel = class("MaterialModel",ModelBase)
--local pbl = pbl

function MaterialModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function MaterialModel:OnCreate()
    --本地事件
    Event.AddListener("m_ReqCloseMaterial",self.m_ReqCloseMaterial,self)
    Event.AddListener("m_MaterialTransport",self.m_ReqBuildingTransport,self)
    Event.AddListener("m_ReqMaterialShelfAdd",self.m_ReqShelfAdd,self)
    Event.AddListener("m_ReqMaterialModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqMaterialShelfDel",self.m_ReqShelfDel,self)
    Event.AddListener("m_ReqMaterialAddLine",self.m_ReqAddLine,self)
    Event.AddListener("m_ReqMaterialDeleteLine",self.m_ReqDeleteLine,self)
    Event.AddListener("m_ReqMaterialBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.AddListener("m_ReqMaterialDelItem",self.m_ReqDelItem,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnOpenMaterial)
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

function MaterialModel:Close()
    --清空本地UI事件
end
---客户端请求---
--打开原料厂
function MaterialModel:m_ReqOpenMaterial(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailMaterialFactory","gs.Id",{id = buildingId})
end
--改变建筑名字
function MaterialModel:m_ReqChangeMaterialName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = id, name = name})
end
--关闭原料厂详情推送消息
function MaterialModel:m_ReqCloseMaterial(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
end
--运输
function MaterialModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function MaterialModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
end
--修改货架价格
function MaterialModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
end
--下架
function MaterialModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--添加生产线
function MaterialModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    self.funModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
end
--删除生产线
function MaterialModel:m_ReqDeleteLine(buildingId,lineId)
    self.funModel:m_ReqDeleteLine(buildingId,lineId)
end
--货架购买
function MaterialModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--销毁仓库原料或商品
function MaterialModel:m_ReqDelItem(buildingId,id,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,id,producerId,qty)
end
---服务器回调---
--打开原料厂
function MaterialModel:n_OnOpenMaterial(stream)
    DataManager.ControllerRpcNoRet(self.insId,"MaterialCtrl", 'refreshMaterialDataInfo',stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
end
--运输
function MaterialModel:n_OnBuildingTransportInfo(data)
    local bagId = DataManager.GetBagId()
    local n = data.item.n
    local itemId = data.item.key.id
    local qty = data.item.key.qty
    local producerId = data.item.key.producerId
    if data.dst == bagId then
        Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
    end
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseCtrl",'RefreshWarehouseData',data,true)
end
--上架
function MaterialModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseCtrl",'RefreshWarehouseData',data,false)
end
--修改货架数量或价格
function MaterialModel:n_OnModifyShelfInfo(data)
    local aaa = data
    -----------------------------------------
end
--下架
function MaterialModel:n_OnShelfDelInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ShelfCtrl",'RefreshShelfData',data)
end
--添加生产线
function MaterialModel:n_OnAddLineInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"AddLineBoxCtrl",'SucceedUpdatePanel',data)
end
--删除生产线
function MaterialModel:n_OnDeleteLineInfo(data)
    Event.Brocast("DeleteLineRefresh",data)
end
--生产线变化推送
function MaterialModel:n_OnLineChangeInform(data)
    Event.Brocast("c_refreshNowConte",data)
end
--货架购买
function MaterialModel:n_OnBuyShelfGoodsInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ShelfCtrl",'RefreshShelfData',data)
end
--销毁仓库原料或商品
function MaterialModel:n_OnDelItemInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseCtrl",'DestroyAfterRefresh',data)
end