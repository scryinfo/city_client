---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/11 16:51
---Raw material factory Model
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
    Event.AddListener("m_GetWarehouseData",self.m_GetWarehouseData,self)
    Event.AddListener("m_GetShelfData",self.m_GetShelfData,self)
    Event.AddListener("m_GetLineData",self.m_GetLineData,self)
    Event.AddListener("m_GetMaterialGuidePrice",self.m_GetMaterialGuidePrice,self)
    Event.AddListener("m_ReqBuildingMaterialInfo",self.m_ReqBuildingMaterialInfo,self)

    --Online registration
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnOpenMaterial)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    --仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfSet","gs.ShelfSet",self.n_OnModifyShelfInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","delItem","gs.DelItem",self.n_OnDelItemInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","salesNotice","gs.salesNotice",self.n_OnSalesNotice)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getStorageData","gs.StorageData",self.n_OnGetWarehouseData)
    --货架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getShelfData","gs.ShelfData",self.n_OnGetShelfData)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","queryMaterialRecommendPrice","gs.MaterialRecommendPrices",self.n_OnMaterialGuidePrice)

    --TODO:购物车协议
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    --生产线
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnAddLineInfo)
    --DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyChangeLine","gs.ChangeLine",self.n_OnModifyKLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyDelLine","gs.DelLine",self.n_OnDeleteLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineChangeInform","gs.LineInfo",self.n_OnLineChangeInform)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftySetLineOrder","gs.SetLineOrder",self.n_OnSetLineOrderInform)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","queryBuildingMaterialInfo","gs.BuildingMaterialInfo",self.n_OnBuildingMaterialInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getLineData","gs.LineData",self.n_OnBuildingLineInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","storeIsFullNotice","gs.ByteBool",self.n_OnBuildingWarehouse)
end

function MaterialFactoryModel:Close()
    --Clear local UI events
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
    Event.RemoveListener("m_GetWarehouseData",self.m_GetWarehouseData,self)
    Event.RemoveListener("m_GetShelfData",self.m_GetShelfData,self)
    Event.RemoveListener("m_GetLineData",self.m_GetLineData,self)
    Event.RemoveListener("m_ReqBuildingMaterialInfo",self.m_ReqBuildingMaterialInfo,self)
    Event.RemoveListener("m_GetMaterialGuidePrice",self.m_GetMaterialGuidePrice,self)

    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnOpenMaterial)
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
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","salesNotice","gs.salesNotice",self.n_OnSalesNotice)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getShelfData","gs.ShelfData",self.n_OnGetShelfData)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","queryMaterialRecommendPrice","gs.MaterialRecommendPrices",self.n_OnMaterialGuidePrice)

    --购物车
    --DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","addShopCart","gs.GoodInfo",self.n_OnAddShoppingCart)
    --生产线
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnAddLineInfo)
    --DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyChangeLine","gs.ChangeLine",self.n_OnModifyKLineInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyDelLine","gs.DelLine",self.n_OnDeleteLineInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyLineChangeInform","gs.LineInfo",self.n_OnLineChangeInform)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftySetLineOrder","gs.SetLineOrder",self.n_OnSetLineOrderInform)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","queryBuildingMaterialInfo","gs.BuildingMaterialInfo",self.n_OnBuildingMaterialInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getLineData","gs.LineData",self.n_OnBuildingLineInfo)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","storeIsFullNotice","gs.ByteBool",self.n_OnBuildingWarehouse)
end
---Client request---
--open Raw material factory
function MaterialFactoryModel:m_ReqOpenMaterial(buildingId)
    FlightMainModel.OpenFlightLoading()
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
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--上架
function MaterialFactoryModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--修改货架属性
function MaterialFactoryModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--下架
function MaterialFactoryModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--添加生产线
function MaterialFactoryModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
end
--删除生产线
function MaterialFactoryModel:m_ReqDeleteLine(buildingId,lineId)
    FlightMainModel.OpenFlightLoading()
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
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_ReqSetLineOrder(buildingId,lineId,pos)
end
--查询原料信息
function MaterialFactoryModel:m_ReqBuildingMaterialInfo(buildingId)
    self.funModel:m_ReqBuildingMaterialInfo(buildingId)
end
--获取仓库数据
function MaterialFactoryModel:m_GetWarehouseData(buildingId)
    FlightMainModel.OpenFlightLoading()
    self.funModel:m_GetWarehouseData(buildingId)
end
--获取货架数据
function MaterialFactoryModel:m_GetShelfData(buildingId)
    self.funModel:m_GetShelfData(buildingId)
end
--获取生产线
function MaterialFactoryModel:m_GetLineData(buildingId)
    self.funModel:m_GetLineData(buildingId)
end
--获取原料参考价格
function MaterialFactoryModel:m_GetMaterialGuidePrice(buildingId,playerId)
    self.funModel:m_GetMaterialGuidePrice(buildingId,playerId)
end
----自动补货
--function MaterialFactoryModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
--    self.funModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
--end
----添加购物车
--function MaterialFactoryModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--    self.funModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
--end
-------------------------------------------------------------Server callback------------------------------------------------------------------
--开业成功，再次请求建筑详情
function MaterialFactoryModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqOpenMaterial(self.insId)
        Event.Brocast("SmallPop", GetLanguage(24020018), ReminderType.Succeed)  --开业成功提示
    end
end
--员工工资改变
function MaterialFactoryModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"MaterialFactoryCtrl", '_refreshSalary', data)
end
--open Raw material factory
function MaterialFactoryModel:n_OnOpenMaterial(stream)
    FlightMainModel.CloseFlightLoading()
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
    DataManager.ControllerRpcNoRet(self.insId,"MaterialFactoryCtrl", 'refreshMaterialDataInfo',stream)
    UnitTest.Exec_now("abel_0511_ModyfyMyBrandName", "e_ModyfyMyBrandName",stream)
end
--运输
function MaterialFactoryModel:n_OnBuildingTransportInfo(data,msgId)
    FlightMainModel.CloseFlightLoading()
    if msgId == 0 then
        Event.Brocast("transportSucceed",data,msgId)
        return
    end
    Event.Brocast("transportSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--上架
function MaterialFactoryModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseDetailBoxCtrl",'RefreshWarehouseData',data)
    Event.Brocast("refreshShelfPartCount",data)
end
--修改货架属性
function MaterialFactoryModel:n_OnModifyShelfInfo(data,msgId)
    FlightMainModel.OpenFlightLoading()
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Succeed,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060013),func = function()
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        end
    end
    Event.Brocast("replenishmentSucceed",data)
    if data ~= nil and data.buildingId == self.insId then
        self:m_ReqOpenMaterial(self.insId)
        Event.Brocast("SmallPop", GetLanguage(29010010), ReminderType.Succeed)
    end
end
--下架
function MaterialFactoryModel:n_OnShelfDelInfo(data,msgId)
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Succeed,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060013),func = function()
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        end
    end
    Event.Brocast("downShelfSucceed",data)
    if data ~= nil and data.buildingId == self.insId then
        self:m_ReqOpenMaterial(self.insId)
        Event.Brocast("SmallPop", GetLanguage(25060007), ReminderType.Succeed)
    end
end
--添加生产线
function MaterialFactoryModel:n_OnAddLineInfo(data)
    Event.Brocast("partUpdateAddLine",data)
    DataManager.ControllerRpcNoRet(self.insId,"AddProductionLineBoxCtrl",'SucceedUpdatePanel',data)
end
--删除生产线
function MaterialFactoryModel:n_OnDeleteLineInfo(data)
    FlightMainModel.CloseFlightLoading()
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
function MaterialFactoryModel:n_OnBuyShelfGoodsInfo(data, msgId)
    if msgId == 0 then
        if data.reason == "numberNotEnough" then
            local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060013),func = function()
                    Event.Brocast("closeBuyList")
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        elseif data.reason == "shelfSetFail" then
            local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060013),func = function()
                    Event.Brocast("closeBuyList")
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        elseif data.reason == "spaceNotEnough" then
            local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060014),func = function()
                    Event.Brocast("closeBuyList")
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
            return
        elseif data.reason == "moneyNotEnough" then
            local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                        content = GetLanguage(25060015),func = function()
                    Event.Brocast("closeBuyList")
                    UIPanel.ClosePage()
                end}
            ct.OpenCtrl("NewReminderCtrl",data)
        end
    else
        Event.Brocast("buySucceed",data)
        --Event.Brocast("refreshShelfPartCount")
    end
end
--销毁仓库原料或商品
function MaterialFactoryModel:n_OnDelItemInfo(data,msgId)
    if msgId == 0 then
        Event.Brocast("deleteSucceed",data,msgId)
        return
    end
    Event.Brocast("deleteSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--生产线置顶
function MaterialFactoryModel:n_OnSetLineOrderInform(data)
    FlightMainModel.CloseFlightLoading()
    Event.Brocast("SettopSuccess",data)
end
--自动补货
function MaterialFactoryModel:n_OnSetAutoReplenish(data)
    Event.Brocast("replenishmentSucceed",data)
end
--查询原料信息
function MaterialFactoryModel:n_OnBuildingMaterialInfo(data)
    Event.Brocast("saveMaterialOrGoodsInfoPart",data)
    Event.Brocast("saveMaterialOrGoodsInfo",data)
end
--获取仓库数据
function MaterialFactoryModel:n_OnGetWarehouseData(data)
    FlightMainModel.CloseFlightLoading()
    Event.Brocast("getWarehouseInfoData",data)
    Event.Brocast("getWarehouseBoxData",data)
end
--获取货架数据
function MaterialFactoryModel:n_OnGetShelfData(data)
    Event.Brocast("getShelfInfoData",data)
end
--获取生产线
function MaterialFactoryModel:n_OnBuildingLineInfo(data)
    FlightMainModel.CloseFlightLoading()
    Event.Brocast("lineAddSucceed",data)
end
--货架购买数量推送
function MaterialFactoryModel:n_OnSalesNotice(data)
    Event.Brocast("salesNotice",data)
end
--仓库容量满通知
function MaterialFactoryModel:n_OnBuildingWarehouse(data)
    Event.Brocast("WarehousCapacityWhetherFull",data)
end
--获取原料参考价格
function MaterialFactoryModel:n_OnMaterialGuidePrice(data)
    Event.Brocast("getMultiGuidePrice",data)
end
----添加购物车
--function MaterialFactoryModel:n_OnAddShoppingCart(data)
--
--end