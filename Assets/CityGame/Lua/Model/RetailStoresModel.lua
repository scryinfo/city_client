---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/11 16:51
---零售店Model
-----

RetailStoresModel = class("RetailStoresModel",ModelBase)

function RetailStoresModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function RetailStoresModel:OnCreate()
    --本地事件
    --Event.AddListener("m_ReqCloseMaterial",self.m_ReqCloseMaterial,self)
    Event.AddListener("m_RetailStoresTransport",self.m_ReqBuildingTransport,self)
    Event.AddListener("m_ReqRetailStoresShelfAdd",self.m_ReqShelfAdd,self)
    Event.AddListener("m_ReqRetailStoresModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqRetailStoresShelfDel",self.m_ReqShelfDel,self)
    --Event.AddListener("m_ReqRetailStoresAddLine",self.m_ReqAddLine,self)
    --Event.AddListener("m_ReqRetailStoresDeleteLine",self.m_ReqDeleteLine,self)
    Event.AddListener("m_ReqRetailStoresBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.AddListener("m_ReqRetailStoresDelItem",self.m_ReqDelItem,self)
    --Event.AddListener("m_ReqRetailStoresSetLineOrder",self.m_ReqSetLineOrder,self)
    Event.AddListener("m_ReqRetailStoresSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.AddListener("m_ReqRetailStoresAddShoppingCart",self.m_ReqAddShoppingCart,self)
    Event.AddListener("m_GetWarehouseData",self.m_GetWarehouseData,self)
    Event.AddListener("m_GetShelfData",self.m_GetShelfData,self)
    Event.AddListener("m_GetRetailGiodePrice",self.m_GetRetailGiodePrice,self)

    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnOpenRetailStores)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    --仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getStorageData","gs.StorageData",self.n_OnGetWarehouseData)

    --货架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getShelfData","gs.ShelfData",self.n_OnGetShelfData)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","retailGuidePrice","gs.GoodSummary",self.n_OnRetailGuidePrice)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","salesNotice","gs.salesNotice",self.n_OnSalesNotice)

    --TODO:购物车协议
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    --签约
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","closeContract","gs.Id",self.n_OnReceiveCloseContract)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","settingContract","gs.ContractSetting",self.n_OnReceiveChangeContract)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","cancelContract","gs.Id",self.n_OnReceiveCancelContract)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","signContract","gs.Contract",self.n_OnReceiveSignContract)
end

function RetailStoresModel:Close()
    --清空本地UI事件
    --Event.RemoveListener("m_ReqCloseRetailStores",self.m_ReqCloseRetailStores,self)
    Event.RemoveListener("m_RetailStoresTransport",self.m_ReqBuildingTransport,self)
    Event.RemoveListener("m_ReqRetailStoresShelfAdd",self.m_ReqShelfAdd,self)
    Event.RemoveListener("m_ReqRetailStoresModifyShelf",self.m_ReqModifyShelf,self)
    Event.RemoveListener("m_ReqRetailStoresShelfDel",self.m_ReqShelfDel,self)
    Event.RemoveListener("m_ReqRetailStoresBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.RemoveListener("m_ReqRetailStoresDelItem",self.m_ReqDelItem,self)
    Event.RemoveListener("m_ReqRetailStoresSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.RemoveListener("m_ReqRetailStoresAddShoppingCart",self.m_ReqAddShoppingCart,self)
    Event.RemoveListener("m_GetWarehouseData",self.m_GetWarehouseData,self)
    Event.RemoveListener("m_GetShelfData",self.m_GetShelfData,self)
    Event.RemoveListener("m_GetRetailGiodePrice",self.m_GetRetailGiodePrice,self)

    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnOpenRetailStores)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    --仓库
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getStorageData","gs.StorageData",self.n_OnGetWarehouseData)

    --货架
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getShelfData","gs.ShelfData",self.n_OnGetShelfData)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","retailGuidePrice","gs.GoodSummary",self.n_OnRetailGuidePrice)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","salesNotice","gs.salesNotice",self.n_OnSalesNotice)


    --购物车
    --DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    --签约
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","closeContract","gs.Id",self.n_OnReceiveCloseContract)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","settingContract","gs.ContractSetting",self.n_OnReceiveChangeContract)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","cancelContract","gs.Id",self.n_OnReceiveCancelContract)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","signContract","gs.Contract",self.n_OnReceiveSignContract)
end
---客户端请求---
--打开零售店
function RetailStoresModel:m_ReqOpenRetailShop(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailRetailShop","gs.Id",{id = buildingId})
end
--改变建筑名字
function RetailStoresModel:m_ReqChangeMaterialName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = id, name = name})
end
----关闭零售店详情推送消息
--function RetailStoresModel:m_ReqCloseMaterial(buildingId)
--    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
--end
--运输
function RetailStoresModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function RetailStoresModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--修改货架属性
function RetailStoresModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--下架
function RetailStoresModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end

--货架购买
function RetailStoresModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--销毁仓库原料或商品
function RetailStoresModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
end
--获取仓库数据
function RetailStoresModel:m_GetWarehouseData(buildingId)
    self.funModel:m_GetWarehouseData(buildingId)
end
--获取货架数据
function RetailStoresModel:m_GetShelfData(buildingId)
    self.funModel:m_GetShelfData(buildingId)
end
--获取加工厂参考价格
function RetailStoresModel:m_GetRetailGiodePrice(buildingId,playerId)
    self.funModel:m_GetRetailGiodePrice(buildingId,playerId)
end
----自动补货
--function RetailStoresModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
--    self.funModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
--end
----添加购物车
--function RetailStoresModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--    self.funModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--end
-------------------------------------------------------------服务器回调------------------------------------------------------------------
--开业成功，再次请求建筑详情
function RetailStoresModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqOpenRetailShop(self.insId)
        Event.Brocast("SmallPop", GetLanguage(24020018), ReminderType.Succeed)  --开业成功提示
    end
end
--员工工资改变
function RetailStoresModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_refreshSalary', data)
end
--打开零售店
function RetailStoresModel:n_OnOpenRetailStores(stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", 'refreshmRetailShopDataInfo',stream)
end
--运输
function RetailStoresModel:n_OnBuildingTransportInfo(data,msgId)
    if msgId == 0 then
        Event.Brocast("transportSucceed",data,msgId)
        return
    end
    Event.Brocast("transportSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--上架
function RetailStoresModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseDetailBoxCtrl",'RefreshWarehouseData',data)
    Event.Brocast("refreshShelfPartCount")
end
--修改货架属性
function RetailStoresModel:n_OnModifyShelfInfo(data,msgId)
    FlightMainModel.CloseFlightLoading()
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Succeed,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = "货架数量发生变化请刷新后操作",func = function()
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        end
    end
    Event.Brocast("replenishmentSucceed",data)
    if data ~= nil and data.buildingId == self.insId then
        self:m_ReqOpenRetailShop(self.insId)
        Event.Brocast("SmallPop", GetLanguage(29010010), ReminderType.Succeed)
    end
end
--下架
function RetailStoresModel:n_OnShelfDelInfo(data,msgId)
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Succeed,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = "货架数量发生变化请刷新后操作",func = function()
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        end
    end
    Event.Brocast("downShelfSucceed",data)
    if data ~= nil and data.buildingId == self.insId then
        self:m_ReqOpenRetailShop(self.insId)
        Event.Brocast("SmallPop", GetLanguage(25060007), ReminderType.Succeed)
    end
end
--添加生产线
function RetailStoresModel:n_OnAddLineInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"AddProductionLineBoxCtrl",'SucceedUpdatePanel',data)
end
--货架购买
function RetailStoresModel:n_OnBuyShelfGoodsInfo(data)
    Event.Brocast("buySucceed",data)
    Event.Brocast("refreshShelfPartCount")
end
--销毁仓库原料或商品
function RetailStoresModel:n_OnDelItemInfo(data,msgId)
    if msgId == 0 then
        Event.Brocast("deleteSucceed",data,msgId)
    end
    Event.Brocast("deleteSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--货架购买数量推送
function RetailStoresModel:n_OnSalesNotice(data)
    Event.Brocast("salesNotice",data)
end
--获取仓库数据
function RetailStoresModel:n_OnGetWarehouseData(data)
    Event.Brocast("getWarehouseInfoData",data)
end
--获取货架数据
function RetailStoresModel:n_OnGetShelfData(data)
    Event.Brocast("getShelfInfoData",data)
end
--获取零售店参考价格
function RetailStoresModel:n_OnRetailGuidePrice(data)
    Event.Brocast("getRetailGuidePrice",data)
end
----自动补货
function RetailStoresModel:n_OnSetAutoReplenish(data)
    local aaa = data
end
--关闭签约
function RetailStoresModel:n_OnReceiveCloseContract(data)
    if data ~= nil and data.id == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_selfCloseSign', data)
    end
end
--开启/调整签约
function RetailStoresModel:n_OnReceiveChangeContract(data)
    if data ~= nil and data.buildingId == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_changeSignInfo', data)
    end
end
--自己取消自己的签约
function RetailStoresModel:n_OnReceiveCancelContract(data)
    if data ~= nil and data.id == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_selfCancelSign', data)
    end
end
--签约成功
function RetailStoresModel:n_OnReceiveSignContract(data)
    if data ~= nil and data.buildingId == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_signSuccess', data)
    end
end
----添加购物车
--function RetailStoresModel:n_OnAddShoppingCart(data)
--
--end