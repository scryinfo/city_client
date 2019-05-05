---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/11 16:51
---加工厂Model
-----

ProcessingFactoryModel = class("ProcessingFactoryModel",ModelBase)

function ProcessingFactoryModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function ProcessingFactoryModel:OnCreate()
    --本地事件
    Event.AddListener("m_ReqCloseprocessing",self.m_ReqCloseprocessing,self)
    Event.AddListener("m_processingTransport",self.m_ReqBuildingTransport,self)
    Event.AddListener("m_ReqprocessingShelfAdd",self.m_ReqShelfAdd,self)
    Event.AddListener("m_ReqprocessingModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqprocessingShelfDel",self.m_ReqShelfDel,self)
    Event.AddListener("m_ReqprocessingAddLine",self.m_ReqAddLine,self)
    Event.AddListener("m_ReqprocessingDeleteLine",self.m_ReqDeleteLine,self)
    Event.AddListener("m_ReqprocessingBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.AddListener("m_ReqprocessingDelItem",self.m_ReqDelItem,self)
    Event.AddListener("m_ReqprocessingSetLineOrder",self.m_ReqSetLineOrder,self)
    Event.AddListener("m_ReqprocessingSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.AddListener("m_ReqprocessingAddShoppingCart",self.m_ReqAddShoppingCart,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnOpenprocessing)
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

function ProcessingFactoryModel:Close()
    --清空本地UI事件
    Event.RemoveListener("m_ReqCloseprocessing",self.m_ReqCloseprocessing,self)
    Event.RemoveListener("m_processingTransport",self.m_ReqBuildingTransport,self)
    Event.RemoveListener("m_ReqprocessingShelfAdd",self.m_ReqShelfAdd,self)
    Event.RemoveListener("m_ReqprocessingModifyShelf",self.m_ReqModifyShelf,self)
    Event.RemoveListener("m_ReqprocessingShelfDel",self.m_ReqShelfDel,self)
    Event.RemoveListener("m_ReqprocessingAddLine",self.m_ReqAddLine,self)
    Event.RemoveListener("m_ReqprocessingDeleteLine",self.m_ReqDeleteLine,self)
    Event.RemoveListener("m_ReqprocessingBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.RemoveListener("m_ReqprocessingDelItem",self.m_ReqDelItem,self)
    Event.RemoveListener("m_ReqprocessingSetLineOrder",self.m_ReqSetLineOrder,self)
    Event.RemoveListener("m_ReqprocessingSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.RemoveListener("m_ReqprocessingAddShoppingCart",self.m_ReqAddShoppingCart,self)

    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnOpenprocessing)
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
function ProcessingFactoryModel:m_ReqOpenprocessing(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailProduceDepartment","gs.Id",{id = buildingId})
end
--改变建筑名字
function ProcessingFactoryModel:m_ReqChangeprocessingName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = id, name = name})
end
--关闭原料厂详情推送消息
function ProcessingFactoryModel:m_ReqCloseprocessing(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
end
--运输
function ProcessingFactoryModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function ProcessingFactoryModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--修改货架价格
function ProcessingFactoryModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
end
--下架
function ProcessingFactoryModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--添加生产线
function ProcessingFactoryModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    self.funModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
end
--删除生产线
function ProcessingFactoryModel:m_ReqDeleteLine(buildingId,lineId)
    self.funModel:m_ReqDeleteLine(buildingId,lineId)
end
--货架购买
function ProcessingFactoryModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--销毁仓库原料或商品
function ProcessingFactoryModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
end
--生产线置顶
function ProcessingFactoryModel:m_ReqSetLineOrder(buildingId,lineId,pos)
    self.funModel:m_ReqSetLineOrder(buildingId,lineId,pos)
end
----自动补货
function ProcessingFactoryModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
    self.funModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
end
----添加购物车
--function ProcessingFactoryModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--    self.funModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--end
---服务器回调---
--开业成功，再次请求建筑详情
function ProcessingFactoryModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqOpenprocessing(self.insId)
        Event.Brocast("SmallPop", GetLanguage(40010020), 300)  --开业成功提示
    end
end
--员工工资改变
function ProcessingFactoryModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessingFactoryCtrl", '_refreshSalary', data)
end
--打开加工厂
function ProcessingFactoryModel:n_OnOpenprocessing(stream)
    DataManager.ControllerRpcNoRet(self.insId,"ProcessingFactoryCtrl", 'refreshprocessingDataInfo',stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
end
--运输
function ProcessingFactoryModel:n_OnBuildingTransportInfo(data)
    --local bagId = DataManager.GetBagId()
    --local n = data.item.n
    --local itemId = data.item.key.id
    --local qty = data.item.key.qty
    --local producerId = data.item.key.producerId
    --if data.dst == bagId then
    --    Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
    --end
    Event.Brocast("transportSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--上架
function ProcessingFactoryModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseDetailBoxCtrl",'RefreshWarehouseData',data)
    Event.Brocast("refreshShelfPartCount")
end
--修改货架价格
function ProcessingFactoryModel:n_OnModifyShelfInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"ShelfCtrl",'RefreshShelfData',data)
end
--下架
function ProcessingFactoryModel:n_OnShelfDelInfo(data)
    Event.Brocast("downShelfSucceed",data)
    Event.Brocast("refreshShelfPartCount")
end
--添加生产线
function ProcessingFactoryModel:n_OnAddLineInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"AddProductionLineBoxCtrl",'SucceedUpdatePanel',data)
end
--删除生产线
function ProcessingFactoryModel:n_OnDeleteLineInfo(data)
    Event.Brocast("detailPartUpdateNowLine",data)
    Event.Brocast("partUpdateNowLine",data)
end
--生产线变化推送
function ProcessingFactoryModel:n_OnLineChangeInform(data)
    Event.Brocast("partUpdateNowCount",data)
    Event.Brocast("detailPartUpdateNowCount",data)
    Event.Brocast("partUpdateCapacity",data)
    Event.Brocast("detailPartUpdateCapacity",data)
end
--货架购买
function ProcessingFactoryModel:n_OnBuyShelfGoodsInfo(data)
    Event.Brocast("buySucceed",data)
    Event.Brocast("refreshShelfPartCount")

    --DataManager.ControllerRpcNoRet(self.insId,"ShelfCtrl",'RefreshShelfData',data)
end
--销毁仓库原料或商品
function ProcessingFactoryModel:n_OnDelItemInfo(data)
    Event.Brocast("deleteSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--生产线置顶
function ProcessingFactoryModel:n_OnSetLineOrderInform(data)
    Event.Brocast("SettopSuccess",data)
end
--自动补货
function ProcessingFactoryModel:n_OnSetAutoReplenish(data)
    local aaa = data
    local bbb = ""
end
--添加购物车
function ProcessingFactoryModel:n_OnAddShoppingCart(data)

end