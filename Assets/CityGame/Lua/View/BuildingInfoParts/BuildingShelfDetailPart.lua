---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/12 11:37
---建筑主界面货架详情界面
BuildingShelfDetailPart = class('BuildingShelfDetailPart',BuildingBaseDetailPart)

function BuildingShelfDetailPart:PrefabName()
    return "BuildingShelfDetailPart"
end

function BuildingShelfDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    --货架数据
    self.shelfDatas = {}
    --购买列表(暂时购买成功后或退出建筑时清空)
    self.buyDatas = {}
end

function BuildingShelfDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end

function BuildingShelfDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    --TopRoot
    self.closeBtn = transform:Find("topRoot/closeBtn")
    self.sortingBtn = transform:Find("topRoot/sortingBtn")
    self.nowStateText = transform:Find("topRoot/sortingBtn/nowStateText"):GetComponent("Text")
    self.buyBtn = transform:Find("topRoot/buyBtn")
    self.number = transform:Find("topRoot/number")
    self.numberText = transform:Find("topRoot/number/numberText"):GetComponent("Text")

    --ContentRoot
    self.noTip = transform:Find("contentRoot/noTip")
    self.tipText = transform:Find("contentRoot/noTip/tipText"):GetComponent("Text")
    self.addbg = transform:Find("contentRoot/noTip/addbg")
    self.addBtn = transform:Find("contentRoot/noTip/addbg/addBtn")
    self.ScrollView = transform:Find("contentRoot/ScrollView")
    self.Content = transform:Find("contentRoot/ScrollView/Viewport/Content")
    self.contentAddBg = transform:Find("contentRoot/ScrollView/Viewport/Content/addbg")
    self.contentAddBtn = transform:Find("contentRoot/ScrollView/Viewport/Content/addbg/addBtn")
    self.ShelfItem = transform:Find("contentRoot/ScrollView/Viewport/Content/ShelfItem").gameObject
end

function BuildingShelfDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject,function()
        self:clickCloseBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.addBtn.gameObject,function()
        self:clickaddShelfBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.contentAddBtn.gameObject,function()
        self:clickaddShelfBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.buyBtn.gameObject,function()
        self:clickBuyBtn()
    end,self)
end

function BuildingShelfDetailPart:_ResetTransform()
    --关闭时清空Item数据
    if next(self.shelfDatas) ~= nil then
        self:CloseDestroy(self.shelfDatas)
    end
end

function BuildingShelfDetailPart:_RemoveClick()

end

function BuildingShelfDetailPart:_InitEvent()
    Event.AddListener("addBuyList",self.addBuyList,self)
    Event.AddListener("deleBuyList",self.deleBuyList,self)
    Event.AddListener("startBuy",self.startBuy,self)
    Event.AddListener("refreshShelfDetailPart",self.refreshShelfDetailPart,self)
    Event.AddListener("whetherSend",self.whetherSend,self)
    Event.AddListener("downShelf",self.downShelf,self)
    Event.AddListener("downShelfSucceed",self.downShelfSucceed,self)
    Event.AddListener("buySucceed",self.buySucceed,self)
    Event.AddListener("replenishmentSucceed",self.replenishmentSucceed,self)
    Event.AddListener("getShelfItemIdCount",self.getShelfItemIdCount,self)
end

function BuildingShelfDetailPart:_RemoveEvent()
    Event.RemoveListener("addBuyList",self.addBuyList,self)
    Event.RemoveListener("deleBuyList",self.deleBuyList,self)
    Event.RemoveListener("startBuy",self.startBuy,self)
    Event.RemoveListener("refreshShelfDetailPart",self.refreshShelfDetailPart,self)
    Event.RemoveListener("whetherSend",self.whetherSend,self)
    Event.RemoveListener("downShelf",self.downShelf,self)
    Event.RemoveListener("downShelfSucceed",self.downShelfSucceed,self)
    Event.RemoveListener("buySucceed",self.buySucceed,self)
    Event.RemoveListener("replenishmentSucceed",self.replenishmentSucceed,self)
    Event.RemoveListener("getShelfItemIdCount",self.getShelfItemIdCount,self)
end

function BuildingShelfDetailPart:_initFunc()
    self:_language()
    self:initializeUiInfoData(self.m_data.shelf.good)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingShelfDetailPart:_language()
    self.tipText.text = "There is no product yet!".."\n".."just go to produce some.good luck."
end
--初始化UI数据
function BuildingShelfDetailPart:initializeUiInfoData(shelfData)
    --是否是自己打开
    if self.m_data.isOther == true then
        self.contentAddBg.gameObject:SetActive(false)
        self.buyBtn.transform.localScale = Vector3.one
        self.number.transform.localScale = Vector3.zero
    else
        self.contentAddBg.gameObject:SetActive(true)
        self.buyBtn.transform.localScale = Vector3.zero
        self.number.transform.localScale = Vector3.zero
    end
    --货架是否是空的
    if not shelfData or next(shelfData) == nil then
        self.number.transform.localScale = Vector3.zero
        self.noTip.transform.localScale = Vector3.one
        self.ScrollView.transform.localScale = Vector3.zero
        if self.m_data.isOther == true then
            self.addbg.transform.localScale = Vector3.zero
        else
            self.addbg.transform.localScale = Vector3.one
        end
    else
        self.noTip.transform.localScale = Vector3.zero
        self.ScrollView.transform.localScale = Vector3.one

        if next(self.buyDatas) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
        end
        if #shelfData == #self.shelfDatas then
            return
        else
            self:CreateGoodsItems(shelfData,self.ShelfItem,self.Content,ShelfItem,self.mainPanelLuaBehaviour,self.shelfDatas,self.m_data.buildingType,self.m_data.insId,self.m_data.isOther)
        end
    end
end
-----------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------
--关闭详情
function BuildingShelfDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--点击上架
function BuildingShelfDetailPart:clickaddShelfBtn()
    local data = {}
    data.info = self.m_data
    ct.OpenCtrl("WarehouseDetailBoxCtrl",data)
end
--打开购买弹窗
function BuildingShelfDetailPart:clickBuyBtn()
    local data = {}
    data.buildingId = self.m_data.insId
    data.buildingInfo = self.m_data.info
    data.buildingType = self.m_data.buildingType
    data.itemPrefabTab = self.buyDatas
    data.stateType = GoodsItemStateType.buy
    ct.OpenCtrl("NewTransportBoxCtrl",data)
end
-----------------------------------------------------------------------------事件函数--------------------------------------------------------------------------------------
--添加到购买列表
function BuildingShelfDetailPart:addBuyList(data)
    --添加到购买列表
    if next(self.buyDatas) == nil then
        table.insert(self.buyDatas,data)
        self.number.transform.localScale = Vector3.one
        self.numberText.text = #self.buyDatas
        Event.Brocast("SmallPop","添加成功", 300)
    else
        for key,value in pairs(self.buyDatas) do
            if value.itemId == data.itemId then
                Event.Brocast("SmallPop","不能重复添加同一种商品", 300)
                return
            end
        end
        table.insert(self.buyDatas,data)
        --self.number.transform.localScale = Vector3.one
        self.numberText.text = #self.buyDatas
        Event.Brocast("SmallPop","添加成功", 300)
    end
end
--删除购买列表
function BuildingShelfDetailPart:deleBuyList(id)
    --删除指定的数据
    if not id then
        return
    else
        table.remove(self.buyDatas,id)
        if next(self.buyDatas) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
            self.numberText.text = #self.buyDatas
        end
    end
end
--在货架时，开关值改变时是否发送消息
function BuildingShelfDetailPart:whetherSend(data)
    if data ~= nil then
        if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
            return
        end
        for key,value in pairs(self.m_data.shelf.good) do
            if value.k.id == data.itemId then
                if self.m_data.buildingType == BuildingType.MaterialFactory then
                    --原料场
                    Event.Brocast("m_ReqMaterialSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
                    --加工厂
                    Event.Brocast("m_ReqprocessingSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                elseif self.m_data.buildingType == BuildingType.RetailShop then
                    --零售店
                    Event.Brocast("m_ReqRetailStoresSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                elseif self.m_data.buildingType == BuildingType.WareHouse then
                    --集散中心
                    Event.Brocast("m_ReqMaterialSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                end
            end
        end
    end
end
--下架
function BuildingShelfDetailPart:downShelf(data)
    if data ~= nil then
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            --原料厂
            Event.Brocast("m_ReqMaterialShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            --加工厂
            Event.Brocast("m_ReqprocessingShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            --零售店
            Event.Brocast("m_ReqRetailStoresShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        elseif self.m_data.buildingType == BuildingType.WareHouse then
            --集散中心
            Event.Brocast("m_ReqMaterialShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        end
    end
end
--购买
function BuildingShelfDetailPart:startBuy(dataInfo,targetBuildingId)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --原料厂
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqMaterialBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --加工厂
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqprocessingBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.RetailShop then
        --零售店
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqRetailStoresBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.WareHouse then
        --集散中心
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqMaterialBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    end
end
--刷新最新数据
function BuildingShelfDetailPart:refreshShelfDetailPart(dataInfo)
    self.m_data = dataInfo.info
    if next(self.shelfDatas) ~= nil then
        self:CloseDestroy(self.shelfDatas)
    end
    self:initializeUiInfoData(self.m_data.shelf.good)
end
-----------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------
--下架成功后
function BuildingShelfDetailPart:downShelfSucceed(data)
    if data ~= nil then
        --刷新货架
        for key,value in pairs(self.shelfDatas) do
            if value.itemId == data.item.key.id then
                if value.dataInfo.n == data.item.n then
                    self:deleteGoodsItem(self.shelfDatas,key)
                else
                    value.dataInfo.n = value.dataInfo.n - data.item.n
                    value.numberText.text = "×"..value.dataInfo.n
                end
            end
        end
        --刷新建筑货架信息
        for key,value in pairs(self.m_data.shelf.good) do
            if value.k.id == data.item.key.id then
                if value.n == data.item.n then
                    table.remove(self.m_data.shelf.good,key)
                else
                    value.n = value.n - data.item.n
                end
            end
        end
        --刷新建筑仓库信息
        if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
            local goods = {}
            local key = {}
            goods.key = key
            goods.key.id = data.item.key.id
            goods.key.producerId = data.item.key.producerId
            goods.key.qty = data.item.key.qty
            goods.n = data.item.n
            if not self.m_data.store.inHand then
                self.m_data.store.inHand = {}
            end
            self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goods
        else
            for key,value in pairs(self.m_data.store.inHand) do
                if value.key.id == data.item.key.id then
                    value.n = value.n + data.item.n
                    --下架成功后，如果货架是空的
                    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
                        self.noTip.transform.localScale = Vector3.one
                        self.ScrollView.transform.localScale = Vector3.zero
                    end
                    UIPanel.ClosePage()

                    return
                end
            end
            --如果没有在仓库找到这个商品
            self:wareHouseNoGoods(data)
        end
    end
    --下架成功后，如果货架是空的
    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
        self.noTip.transform.localScale = Vector3.one
        self.ScrollView.transform.localScale = Vector3.zero
    end
    UIPanel.ClosePage()
    Event.Brocast("SmallPop",GetLanguage(27010003), 300)
end
--购买成功
function BuildingShelfDetailPart:buySucceed(data)
    if data ~= nil then
        --刷新货架
        for key,value in pairs(self.shelfDatas) do
            if value.itemId == data.item.key.id then
                if value.dataInfo.n == data.item.n then
                    self:deleteGoodsItem(self.shelfDatas,key)
                else
                    value.dataInfo.n = value.dataInfo.n - data.item.n
                    value.numberText.text = "×"..value.dataInfo.n
                end
            end
        end
        --刷新建筑货架信息
        for key,value in pairs(self.m_data.shelf.good) do
            if value.k.id == data.item.key.id then
                if value.n == data.item.n then
                    table.remove(self.m_data.shelf.good,key)
                else
                    value.n = value.n - data.item.n
                end
            end
        end
    end
    --购买成功后，如果货架是空的
    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
        self.noTip.transform.localScale = Vector3.one
        self.addbg.transform.localScale = Vector3.zero
        self.ScrollView.transform.localScale = Vector3.zero
    end
    self.number.transform.localScale = Vector3.zero
    self.buyDatas = {}
    UIPanel.ClosePage()
    Event.Brocast("SmallPop",GetLanguage(27010006), 300)
end
--自动补货
function BuildingShelfDetailPart:replenishmentSucceed(data)
    if data ~= nil then
        --如果等于false，是关闭自动补货
        if data.autoRepOn == false then
            --改变实例表属性
            for key,value in pairs(self.shelfDatas) do
                if value.itemId == data.iKey.id then
                    value.dataInfo.autoReplenish = data.autoRepOn
                    value.numberBg.transform.localScale = Vector3.one
                    value.automaticBg.transform.localScale = Vector3.zero
                    value.noHaveBg.transform.localScale = Vector3.zero
                end
            end
            --改变建筑信息里的属性
            for key,value in pairs(self.m_data.shelf.good) do
                if value.k.id == data.iKey.id then
                    value.autoReplenish = data.autoRepOn
                end
            end
            Event.Brocast("SmallPop","自动补货关闭成功", 300)
            UIPanel.ClosePage()
        else
            --如果是打开自动补货
            --刷新仓库数据
            local warehouseNum = 0        --仓库里剩余的数量
            if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
                --打开自动补货，仓库是空的时候
                for key,value in pairs(self.shelfDatas) do
                    value.dataInfo.autoReplenish = data.autoRepOn
                    value.dataInfo.n = value.dataInfo.n + warehouseNum
                    value.numberBg.transform.localScale = Vector3.zero
                    value.automaticBg.transform.localScale = Vector3.one
                    value.noHaveBg.transform.localScale = Vector3.zero
                end
                for key,value in pairs(self.m_data.shelf.good) do
                    value.autoReplenish = data.autoRepOn
                    value.n = value.n + warehouseNum
                end
            else
                --打开自动补货，获取到仓库的数量
                for key,value in pairs(self.m_data.store.inHand) do
                    if value.key.id == data.iKey.id then
                        warehouseNum = value.n
                        table.remove(self.m_data.store.inHand,key)
                    end
                end
                for key,value in pairs(self.shelfDatas) do
                    value.dataInfo.autoReplenish = data.autoRepOn
                    value.dataInfo.n = value.dataInfo.n + warehouseNum
                    value.numberText.text = "×"..value.dataInfo.n
                    value.numberBg.transform.localScale = Vector3.zero
                    value.automaticBg.transform.localScale = Vector3.one
                    value.noHaveBg.transform.localScale = Vector3.zero
                end
                for key,value in pairs(self.m_data.shelf.good) do
                    value.autoReplenish = data.autoRepOn
                    value.n = value.n + warehouseNum
                end
            end
            Event.Brocast("SmallPop","自动补货打开成功", 300)
            UIPanel.ClosePage()
        end
    end
end
--如果没有在仓库找到这个商品
function BuildingShelfDetailPart:wareHouseNoGoods(data)
    local goods = {}
    local key = {}
    goods.key = key
    goods.key.id = data.item.key.id
    goods.key.producerId = data.item.key.producerId
    goods.key.qty = data.item.key.qty
    goods.n = data.item.n
    self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goods
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--获取仓库里某个商品的数量
--(后边要修改)
function BuildingShelfDetailPart:getShelfItemIdCount(itemId,callback)
    if itemId ~= nil then
        local nowCount = 0
        if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
            nowCount = 0
        else
            for key,value in pairs(self.m_data.shelf.good) do
                if value.k.id == itemId then
                    nowCount = value.n
                end
            end
        end
        callback(nowCount)
    end
end
