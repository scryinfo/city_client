---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/11 16:51
---原料厂Model
-----

MaterialFactoryModel = class("MaterialFactoryModel",ModelBase)

function MaterialFactoryModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function MaterialFactoryModel:OnCreate()
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
    Event.AddListener("m_ReqMaterialSetLineOrder",self.m_ReqSetLineOrder,self)
    Event.AddListener("m_ReqMaterialSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.AddListener("m_ReqMaterialAddShoppingCart",self.m_ReqAddShoppingCart,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnOpenMaterial)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    --仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    --货架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    --TODO:购物车协议
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    --生产线
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnAddLineInfo)
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyChangeLine","gs.ChangeLine",self.n_OnModifyKLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyDelLine","gs.DelLine",self.n_OnDeleteLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineChangeInform","gs.LineInfo",self.n_OnLineChangeInform)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftySetLineOrder","gs.SetLineOrder",self.n_OnSetLineOrderInform)
end

function MaterialFactoryModel:Close()
    --清空本地UI事件
    Event.RemoveListener("m_ReqCloseMaterial",self.m_ReqCloseMaterial,self)
    Event.RemoveListener("m_MaterialTransport",self.m_ReqBuildingTransport,self)
    Event.RemoveListener("m_ReqMaterialShelfAdd",self.m_ReqShelfAdd,self)
    Event.RemoveListener("m_ReqMaterialModifyShelf",self.m_ReqModifyShelf,self)
    Event.RemoveListener("m_ReqMaterialShelfDel",self.m_ReqShelfDel,self)
    Event.RemoveListener("m_ReqMaterialAddLine",self.m_ReqAddLine,self)
    Event.RemoveListener("m_ReqMaterialDeleteLine",self.m_ReqDeleteLine,self)
    Event.RemoveListener("m_ReqMaterialBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.RemoveListener("m_ReqMaterialDelItem",self.m_ReqDelItem,self)
    Event.RemoveListener("m_ReqMaterialSetLineOrder",self.m_ReqSetLineOrder,self)
    Event.RemoveListener("m_ReqMaterialSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.RemoveListener("m_ReqMaterialAddShoppingCart",self.m_ReqAddShoppingCart,self)

    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnOpenMaterial)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    --仓库
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    --货架
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    --购物车
    --DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    --生产线
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnAddLineInfo)
    --DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyChangeLine","gs.ChangeLine",self.n_OnModifyKLineInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyDelLine","gs.DelLine",self.n_OnDeleteLineInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyLineChangeInform","gs.LineInfo",self.n_OnLineChangeInform)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftySetLineOrder","gs.SetLineOrder",self.n_OnSetLineOrderInform)
end
---客户端请求---
--打开原料厂
function MaterialFactoryModel:m_ReqOpenMaterial(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailMaterialFactory","gs.Id",{id = buildingId})
end
--改变建筑名字
function MaterialFactoryModel:m_ReqChangeMaterialName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = id, name = name})
end
--关闭原料厂详情推送消息
function MaterialFactoryModel:m_ReqCloseMaterial(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
end
--运输
function MaterialFactoryModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function MaterialFactoryModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--修改货架属性
function MaterialFactoryModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--下架
function MaterialFactoryModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--添加生产线
function MaterialFactoryModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    self.funModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
end
--删除生产线
function MaterialFactoryModel:m_ReqDeleteLine(buildingId,lineId)
    self.funModel:m_ReqDeleteLine(buildingId,lineId)
end
--货架购买
function MaterialFactoryModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--销毁仓库原料或商品
function MaterialFactoryModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
end
--生产线置顶
function MaterialFactoryModel:m_ReqSetLineOrder(buildingId,lineId,pos)
    self.funModel:m_ReqSetLineOrder(buildingId,lineId,pos)
end
----自动补货
function MaterialFactoryModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
    self.funModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
end
----添加购物车
--function MaterialFactoryModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--    self.funModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--end
---服务器回调---
--开业成功，再次请求建筑详情
function MaterialFactoryModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqOpenMaterial(self.insId)
        Event.Brocast("SmallPop", GetLanguage(24020018), 300)  --开业成功提示
    end
end
--员工工资改变
function MaterialFactoryModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"MaterialFactoryCtrl", '_refreshSalary', data)
end
--打开原料厂
function MaterialFactoryModel:n_OnOpenMaterial(stream)
    DataManager.ControllerRpcNoRet(self.insId,"MaterialFactoryCtrl", 'refreshMaterialDataInfo',stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
    --UnitTest.Exec_now("abel_0511_ModyfyMyBrandName", "e_ModyfyMyBrandName",DataManager.GetMyPersonalHomepageInfo().id)
    UnitTest.Exec_now("abel_0511_ModyfyMyBrandName", "e_ModyfyMyBrandName",stream)
end
--运输
function MaterialFactoryModel:n_OnBuildingTransportInfo(data)
    Event.Brocast("transportSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--上架
function MaterialFactoryModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseDetailBoxCtrl",'RefreshWarehouseData',data)
    Event.Brocast("refreshShelfPartCount")
end
--修改货架属性
function MaterialFactoryModel:n_OnModifyShelfInfo(data)
    Event.Brocast("replenishmentSucceed",data)
    if data ~= nil and data.buildingId == self.insId then
        self:m_ReqOpenMaterial(self.insId)
        Event.Brocast("SmallPop", GetLanguage(29010010), 300)
    end
end
--下架
function MaterialFactoryModel:n_OnShelfDelInfo(data)
    Event.Brocast("downShelfSucceed",data)
    if data ~= nil and data.buildingId == self.insId then
        self:m_ReqOpenMaterial(self.insId)
        Event.Brocast("SmallPop", GetLanguage(25060007), 300)
    end
end
--添加生产线
function MaterialFactoryModel:n_OnAddLineInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"AddProductionLineBoxCtrl",'SucceedUpdatePanel',data)
end
--删除生产线
function MaterialFactoryModel:n_OnDeleteLineInfo(data)
    Event.Brocast("detailPartUpdateNowLine",data)
    Event.Brocast("partUpdateNowLine",data)
end
--生产线变化推送
function MaterialFactoryModel:n_OnLineChangeInform(data)
    Event.Brocast("partUpdateNowCount",data)
    Event.Brocast("detailPartUpdateNowCount",data)
    Event.Brocast("partUpdateCapacity",data)
    Event.Brocast("detailPartUpdateCapacity",data)
end
--货架购买
function MaterialFactoryModel:n_OnBuyShelfGoodsInfo(data)
    Event.Brocast("buySucceed",data)
    Event.Brocast("refreshShelfPartCount")

end
--销毁仓库原料或商品
function MaterialFactoryModel:n_OnDelItemInfo(data)
    Event.Brocast("deleteSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--生产线置顶
function MaterialFactoryModel:n_OnSetLineOrderInform(data)
    Event.Brocast("SettopSuccess",data)
end
--自动补货
function MaterialFactoryModel:n_OnSetAutoReplenish(data)
    Event.Brocast("replenishmentSucceed",data)
end
----添加购物车
--function MaterialFactoryModel:n_OnAddShoppingCart(data)
--
--end