---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/11 16:51
---Retail store Model
-----

RetailStoresModel = class("RetailStoresModel",ModelBase)

function RetailStoresModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function RetailStoresModel:OnCreate()
    --Local events
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

    --Online registration
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnOpenRetailStores)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    --Warehouse
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getStorageData","gs.StorageData",self.n_OnGetWarehouseData)

    --Shelf
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getShelfData","gs.ShelfData",self.n_OnGetShelfData)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","queryRetailShopRecommendPrice","gs.RetailShopRecommendPrice",self.n_OnRetailGuidePrice)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","salesNotice","gs.salesNotice",self.n_OnSalesNotice)

    --TODO:shopping cart agreement
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    -- Signing a contract
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","closeContract","gs.Id",self.n_OnReceiveCloseContract)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","settingContract","gs.ContractSetting",self.n_OnReceiveChangeContract)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","cancelContract","gs.Id",self.n_OnReceiveCancelContract)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","signContract","gs.Contract",self.n_OnReceiveSignContract)
end

function RetailStoresModel:Close()
    --Clear local UI events
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
    --Warehouse
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getStorageData","gs.StorageData",self.n_OnGetWarehouseData)

    --Shelf
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getShelfData","gs.ShelfData",self.n_OnGetShelfData)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","queryRetailShopRecommendPrice","gs.RetailShopRecommendPrice",self.n_OnRetailGuidePrice)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","salesNotice","gs.salesNotice",self.n_OnSalesNotice)

    --shopping cart
    --DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    -- Signing a contract
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","closeContract","gs.Id",self.n_OnReceiveCloseContract)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","settingContract","gs.ContractSetting",self.n_OnReceiveChangeContract)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","cancelContract","gs.Id",self.n_OnReceiveCancelContract)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","signContract","gs.Contract",self.n_OnReceiveSignContract)
end
---Client request---
--Open retail store
function RetailStoresModel:m_ReqOpenRetailShop(buildingId)
    FlightMainModel.OpenFlightLoading()
    DataManager.ModelSendNetMes("gscode.OpCode", "detailRetailShop","gs.Id",{id = buildingId})
end
--Change the building name
function RetailStoresModel:m_ReqChangeMaterialName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingName","gs.SetBuildingName",{ id = id, name = name})
end
----Closed retail store details push message
--function RetailStoresModel:m_ReqCloseMaterial(buildingId)
--    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id = buildingId})
--end
--transport
function RetailStoresModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--Shelf
function RetailStoresModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--Modify shelf properties
function RetailStoresModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--Removal
function RetailStoresModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end

--Shelf purchase
function RetailStoresModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--Destroy warehouse raw materials or commodities
function RetailStoresModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
end
--Get warehouse data
function RetailStoresModel:m_GetWarehouseData(buildingId)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_GetWarehouseData(buildingId)
end
--Get shelf data
function RetailStoresModel:m_GetShelfData(buildingId)
    self.funModel:m_GetShelfData(buildingId)
end
--Get the reference price of the processing plant
function RetailStoresModel:m_GetRetailGiodePrice(buildingId,playerId)
    self.funModel:m_GetRetailGiodePrice(buildingId,playerId)
end
----Automatic replenishment
--function RetailStoresModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
--    self.funModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
--end
----Add shopping cart
--function RetailStoresModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--    self.funModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--end
-------------------------------------------------------------Server callback------------------------------------------------------------------
-- Successful opening, request building details again
function RetailStoresModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqOpenRetailShop(self.insId)
        Event.Brocast("SmallPop", GetLanguage(24020018), ReminderType.Succeed)  --Prompt for successful opening
    end
end
--Employee salary change
function RetailStoresModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_refreshSalary', data)
end
--Open retail store
function RetailStoresModel:n_OnOpenRetailStores(stream)
    FlightMainModel.CloseFlightLoading()
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
    DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", 'refreshmRetailShopDataInfo',stream)
end
--transport
function RetailStoresModel:n_OnBuildingTransportInfo(data,msgId)
    FlightMainModel.CloseFlightLoading()
    if msgId == 0 then
        Event.Brocast("transportSucceed",data,msgId)
        return
    end
    Event.Brocast("transportSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--Shelf
function RetailStoresModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseDetailBoxCtrl",'RefreshWarehouseData',data)
    Event.Brocast("refreshShelfPartCount",data)
end
--Modify shelf properties
function RetailStoresModel:n_OnModifyShelfInfo(data,msgId)
    FlightMainModel.CloseFlightLoading()
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060013),func = function()
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
--Removal
function RetailStoresModel:n_OnShelfDelInfo(data,msgId)
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060013),func = function()
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
--Add production line
function RetailStoresModel:n_OnAddLineInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"AddProductionLineBoxCtrl",'SucceedUpdatePanel',data)
end
--Shelf purchase
function RetailStoresModel:n_OnBuyShelfGoodsInfo(data)
    Event.Brocast("buySucceed",data)
    --Event.Brocast("refreshShelfPartCount")
end
--Destroy warehouse raw materials or commodities
function RetailStoresModel:n_OnDelItemInfo(data,msgId)
    if msgId == 0 then
        Event.Brocast("deleteSucceed",data,msgId)
    end
    Event.Brocast("deleteSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--Push the number of shelves purchased
function RetailStoresModel:n_OnSalesNotice(data)
    Event.Brocast("salesNotice",data)
end
---Get warehouse data
function RetailStoresModel:n_OnGetWarehouseData(data)
    FlightMainModel.CloseFlightLoading()
    Event.Brocast("getWarehouseInfoData",data)
    Event.Brocast("getWarehouseBoxData",data)
end
--Get shelf data
function RetailStoresModel:n_OnGetShelfData(data)
    Event.Brocast("getShelfInfoData",data)
end
--Get the retail store reference price
function RetailStoresModel:n_OnRetailGuidePrice(data)
    Event.Brocast("getMultiGuidePrice",data)
end
----Automatic replenishment
function RetailStoresModel:n_OnSetAutoReplenish(data)
    local aaa = data
end
--Close contract
function RetailStoresModel:n_OnReceiveCloseContract(data)
    if data ~= nil and data.id == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_selfCloseSign', data)
    end
end
--Open/adjust contract
function RetailStoresModel:n_OnReceiveChangeContract(data)
    if data ~= nil and data.buildingId == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_changeSignInfo', data)
    end
end
--Cancel your own contract
function RetailStoresModel:n_OnReceiveCancelContract(data)
    if data ~= nil and data.id == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_selfCancelSign', data)
    end
end
--Successful signing
function RetailStoresModel:n_OnReceiveSignContract(data)
    if data ~= nil and data.buildingId == self.insId then
        DataManager.ControllerRpcNoRet(self.insId,"RetailStoresCtrl", '_signSuccess', data)
    end
end
----Add shopping cart
--function RetailStoresModel:n_OnAddShoppingCart(data)
--
--end