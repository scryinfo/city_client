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
function BuildingShelfDetailPart:Show(data)
    BasePartDetail.Show(self,data)
    --打开时清空Item数据
    if next(self.shelfDatas) ~= nil then
        self:CloseDestroy(self.shelfDatas)
    end
    Event.AddListener("salesNotice",self.salesNotice,self)
end
function BuildingShelfDetailPart:Hide()
    BasePartDetail.Hide(self)
    self.buyDatas = {}
    Event.RemoveListener("salesNotice",self.salesNotice,self)
end
function BuildingShelfDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
    self.shelfInfoData = {}
    if data.buildingType == BuildingType.MaterialFactory then
        Event.Brocast("m_GetMaterialGuidePrice",data.insId,data.info.ownerId)
    elseif data.buildingType == BuildingType.ProcessingFactory then
        Event.Brocast("m_GetProcessingGuidePrice",data.insId,data.info.ownerId)
    elseif data.buildingType == BuildingType.RetailShop then
        Event.Brocast("m_GetRetailGiodePrice",data.insId,data.info.ownerId)
    end

    --获取最新的货架数据
    Event.Brocast("m_GetShelfData",data.insId)
    --获取最新的仓库数据
    Event.Brocast("m_GetWarehouseData",data.insId)
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
    Event.AddListener("downShelf",self.downShelf,self)
    Event.AddListener("downShelfSucceed",self.downShelfSucceed,self)
    Event.AddListener("buySucceed",self.buySucceed,self)
    Event.AddListener("replenishmentSucceed",self.replenishmentSucceed,self)
    Event.AddListener("getShelfItemIdCount",self.getShelfItemIdCount,self)
    Event.AddListener("modifyShelfInfo",self.modifyShelfInfo,self)
    Event.AddListener("getShelfInfoData",self.getShelfInfoData,self)
    Event.AddListener("getWarehouseBoxData",self.getWarehouseData,self)
    --Event.AddListener("getShelfGuidePrice",self.getShelfGuidePrice,self)
    Event.AddListener("closeBuyList",self.closeBuyList,self)
    --Event.AddListener("getShelfProcessingGuidePrice",self.getShelfProcessingGuidePrice,self)
    --Event.AddListener("getRetailGuidePrice",self.getRetailGuidePrice,self)
    Event.AddListener("getMultiGuidePrice",self.getMultiGuidePrice,self)
    --Event.AddListener("getShelfItemGuidePrice",self.getShelfItemGuidePrice,self)
    --Event.AddListener("getShelfItemProcessing",self.getShelfItemProcessing,self)
    --Event.AddListener("getRetailItemGuidePrice",self.getRetailItemGuidePrice,self)
    Event.AddListener("getShelfGuidePrice",self.getShelfGuidePrice,self)
end

function BuildingShelfDetailPart:_RemoveEvent()
    Event.RemoveListener("addBuyList",self.addBuyList,self)
    Event.RemoveListener("deleBuyList",self.deleBuyList,self)
    Event.RemoveListener("startBuy",self.startBuy,self)
    Event.RemoveListener("refreshShelfDetailPart",self.refreshShelfDetailPart,self)
    Event.RemoveListener("downShelf",self.downShelf,self)
    Event.RemoveListener("downShelfSucceed",self.downShelfSucceed,self)
    Event.RemoveListener("buySucceed",self.buySucceed,self)
    Event.RemoveListener("replenishmentSucceed",self.replenishmentSucceed,self)
    Event.RemoveListener("getShelfItemIdCount",self.getShelfItemIdCount,self)
    Event.RemoveListener("modifyShelfInfo",self.modifyShelfInfo,self)
    Event.RemoveListener("getShelfInfoData",self.getShelfInfoData,self)
    Event.RemoveListener("getWarehouseBoxData",self.getWarehouseData,self)
    --Event.RemoveListener("getShelfGuidePrice",self.getShelfGuidePrice,self)
    Event.RemoveListener("closeBuyList",self.closeBuyList,self)
    --Event.RemoveListener("getShelfProcessingGuidePrice",self.getShelfProcessingGuidePrice,self)
    --Event.RemoveListener("getRetailGuidePrice",self.getRetailGuidePrice,self)
    Event.RemoveListener("getMultiGuidePrice",self.getMultiGuidePrice,self)
    --Event.RemoveListener("getShelfItemGuidePrice",self.getShelfItemGuidePrice,self)
    --Event.RemoveListener("getShelfItemProcessing",self.getShelfItemProcessing,self)
    --Event.RemoveListener("getRetailItemGuidePrice",self.getRetailItemGuidePrice,self)
    Event.RemoveListener("getShelfGuidePrice",self.getShelfGuidePrice,self)
end

function BuildingShelfDetailPart:_initFunc()
    self:_language()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingShelfDetailPart:_language()
    self.tipText.text = GetLanguage(25060001)
end
--初始化UI数据
function BuildingShelfDetailPart:initializeUiInfoData(shelfData)
    --TODO  暂时隐藏货架分类
    self.sortingBtn.transform.localScale = Vector3.zero
    --是否是自己打开
    if self.m_data.isOther == true then
        self.contentAddBg.gameObject:SetActive(false)
        --如果是零售店，也要隐藏购买列表
        if self.m_data.buildingType == BuildingType.RetailShop then
            self.buyBtn.transform.localScale = Vector3.zero
        else
            self.buyBtn.transform.localScale = Vector3.one
        end
        self.number.transform.localScale = Vector3.zero
        self.tipText.text = GetLanguage(25060012)
    else
        self.contentAddBg.gameObject:SetActive(true)
        self.buyBtn.transform.localScale = Vector3.zero
        self.number.transform.localScale = Vector3.zero
        self.tipText.text = GetLanguage(25060001)
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
    data.shelf = self.shelfInfoData
    data.warehouse = self.warehouseInfoData
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
        Event.Brocast("SmallPop",GetLanguage(25070010), 300)
    else
        for key,value in pairs(self.buyDatas) do
            if value.itemId == data.itemId and value.producerId == data.producerId then
                Event.Brocast("SmallPop",GetLanguage(25070011), 300)
                return
            end
        end
        table.insert(self.buyDatas,data)
        --self.number.transform.localScale = Vector3.one
        self.numberText.text = #self.buyDatas
        Event.Brocast("SmallPop",GetLanguage(25070010), 300)
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
--修改货架属性
function BuildingShelfDetailPart:modifyShelfInfo(data)
    if data ~= nil then
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            --原料厂
            Event.Brocast("m_ReqMaterialModifyShelf",self.m_data.insId,data.itemId,data.number,data.price,data.producerId,data.qty,data.switch)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            --加工厂
            Event.Brocast("m_ReqprocessingModifyShelf",self.m_data.insId,data.itemId,data.number,data.price,data.producerId,data.qty,data.switch)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            --零售店
            Event.Brocast("m_ReqRetailStoresModifyShelf",self.m_data.insId,data.itemId,data.number,data.price,data.producerId,data.qty,data.switch)
        elseif self.m_data.buildingType == BuildingType.TalentCenter then
            --集散中心
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
        elseif self.m_data.buildingType == BuildingType.TalentCenter then
            --集散中心
        end
    end
end
--购买
function BuildingShelfDetailPart:startBuy(dataInfo,targetBuildingId)
    self.numberTest = #dataInfo
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
    elseif self.m_data.buildingType == BuildingType.TalentCenter then
        --集散中心
    end
end
--刷新最新数据
function BuildingShelfDetailPart:refreshShelfDetailPart(dataInfo)
    self.m_data = dataInfo.info
    if next(self.shelfDatas) ~= nil then
        self:CloseDestroy(self.shelfDatas)
    end
    self:initializeUiInfoData(dataInfo.shelf.shelf.good)
end
-----------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------
--获取货架数据
function BuildingShelfDetailPart:getShelfInfoData(data)
    self.shelfInfoData = ct.deepCopy(data)
    self:initializeUiInfoData(self.shelfInfoData.shelf.good)
end
--获取仓库数据
function BuildingShelfDetailPart:getWarehouseData(data)
    self.warehouseInfoData = ct.deepCopy(data)
end
--下架成功后
function BuildingShelfDetailPart:downShelfSucceed(data)
    if data ~= nil then
        --下架成功后，如果货架是空的
        if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
            self.noTip.transform.localScale = Vector3.one
            self.ScrollView.transform.localScale = Vector3.zero
        end
        --更新界面
        if next(self.shelfDatas) ~= nil then
            self:CloseDestroy(self.shelfDatas)
        end
    end
    UIPanel.ClosePage()
    Event.Brocast("SmallPop",GetLanguage(25060007), ReminderType.Succeed)
end
--购买成功
function BuildingShelfDetailPart:buySucceed(data)
    if data ~= nil then
        self.numberTest = self.numberTest - 1
        if not data.item or next(data.item) == nil then
            data.item = {}
        end
        --刷新货架
        for key,value in pairs(self.shelfDatas) do
            if tonumber(string.sub(data.item.key.id,1,2)) == 21 then
                if value.itemId == data.item.key.id then
                    if value.dataInfo.n == data.item.n then
                        self:deleteGoodsItem(self.shelfDatas,key)
                    end
                end
            elseif tonumber(string.sub(data.item.key.id,1,2)) == 22 then
                if value.itemId == data.item.key.id and value.dataInfo.k.producerId == data.item.key.producerId then
                    if value.dataInfo.n == data.item.n then
                        self:deleteGoodsItem(self.shelfDatas,key)
                    end
                end
            end
        end
        --刷新建筑货架信息
        for key,value in pairs(self.m_data.shelf.good) do
            if tonumber(string.sub(data.item.key.id,1,2)) == 21 then
                if value.k.id == data.item.key.id then
                    if value.n == data.item.n then
                        table.remove(self.m_data.shelf.good,key)
                    else
                        value.n = value.n - data.item.n
                    end
                end
            elseif tonumber(string.sub(data.item.key.id,1,2)) == 22 then
                if value.k.id == data.item.key.id and value.k.producerId == data.item.key.producerId then
                    if value.n == data.item.n then
                        table.remove(self.m_data.shelf.good,key)
                    else
                        value.n = value.n - data.item.n
                    end
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
    if self.numberTest == 0 then
        UIPanel.ClosePage()
    end
    Event.Brocast("SmallPop",GetLanguage(25070005), ReminderType.Succeed)
end
--自动补货
function BuildingShelfDetailPart:replenishmentSucceed(data)
    --更新界面
    if data ~= nil then
        --关闭时清空Item数据
        if next(self.shelfDatas) ~= nil then
            self:CloseDestroy(self.shelfDatas)
        end
    end
    UIPanel.ClosePage()
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
--货架变化推送
function BuildingShelfDetailPart:salesNotice(data)
    if data ~= nil then
        for key,value in pairs(self.shelfDatas) do
            if tonumber(string.sub(data.itemId,1,2)) == 21 then
                if value.dataInfo.k.id == data.itemId then
                    value.dataInfo.n = data.selledCount
                    value.dataInfo.price = data.selledPrice
                    value.dataInfo.autoReplenish = data.autoRepOn
                    if data.autoRepOn == true then
                        value.automaticBg.transform.localScale = Vector3.one
                        value.numberBg.gameObject:SetActive(false)
                    else
                        value.automaticBg.transform.localScale = Vector3.zero
                        value.numberBg.gameObject:SetActive(true)
                    end
                    value.automaticNumberText.text = "×"..data.selledCount
                    value.numberText.text = "×"..data.selledCount
                    value.priceText.text = GetClientPriceString(data.selledPrice)
                end
            elseif tonumber(string.sub(data.itemId,1,2)) == 22 then
                if value.dataInfo.k.id == data.itemId and value.dataInfo.k.producerId == data.producerId then
                    value.dataInfo.n = data.selledCount
                    value.dataInfo.price = data.selledPrice
                    value.dataInfo.autoReplenish = data.autoRepOn
                    if data.autoRepOn == true then
                        value.automaticBg.transform.localScale = Vector3.one
                        value.numberBg.gameObject:SetActive(false)
                    else
                        value.automaticBg.transform.localScale = Vector3.zero
                        value.numberBg.gameObject:SetActive(true)
                    end
                    value.automaticNumberText.text = "×"..data.selledCount
                    value.numberText.text = "×"..data.selledCount
                    value.priceText.text = GetClientPriceString(data.selledPrice)
                end
            end
        end
    end
end
----货架购买失败后清空购买列表
--function BuildingShelfDetailPart:closeBuyList()
--    self.buyDatas = {}
--    self.number.transform.localScale = Vector3.zero
--    self.numberText.text = #self.buyDatas
--end
----原料参考价格
--function BuildingShelfDetailPart:getShelfGuidePrice(data)
--    self.guideMaterialPrice = data
--end
----加工厂参考价格
--function BuildingShelfDetailPart:getShelfProcessingGuidePrice(data)
--    self.guideProcessingPrice = data
--end
----零售店参考价格
--function BuildingShelfDetailPart:getRetailGuidePrice(data)
--    self.guideRetailPrice = data
--end
--获取推荐定价
function BuildingShelfDetailPart:getMultiGuidePrice(data)
    self.guidePriceTab = data
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--获取货架上某个商品的数量
--(后边要修改)
function BuildingShelfDetailPart:getShelfItemIdCount(itemId,producerId,callback)
    if itemId ~= nil then
        local nowCount = 0
        if not self.m_data.store.locked or next(self.m_data.store.locked) == nil then
            nowCount = 0
        else
            for key,value in pairs(self.m_data.store.locked) do
                if producerId == nil then
                    if value.key.id == itemId then
                        nowCount = value.n
                    end
                else
                    if value.key.id == itemId and value.key.producerId == producerId then
                        nowCount = value.n
                    end
                end
            end
        end
        callback(nowCount)
    end
end
--获取推荐定价
function BuildingShelfDetailPart:getShelfGuidePrice(itemId,callback)
    if itemId ~= nil then
        if not self.guidePriceTab or next(self.guidePriceTab) ~= nil then
            for key,value in pairs(self.guidePriceTab.msg) do
                if value.mid == itemId then
                    return callback(value.guidePrice)
                end
            end
        end
    end
end
----获取原料某个商品的推荐价格
--function BuildingShelfDetailPart:getShelfItemGuidePrice(itemId,callback)
--    if itemId ~= nil then
--        if not self.guideMaterialPrice or next(self.guideMaterialPrice) ~= nil then
--            for key,value in pairs(self.guideMaterialPrice.goodMap) do
--                if value.itemId[1] == itemId then
--                    return callback(value.gudePrice[1])
--                end
--            end
--        end
--    end
--end
----获取加工厂某个商品的推荐价格
--function BuildingShelfDetailPart:getShelfItemProcessing(itemId,callback)
--    if not self.guideProcessingPrice or next(self.guideProcessingPrice) ~= nil then
--        for key,value in pairs(self.guideProcessingPrice.goodMap) do
--            if value.itemId[1] == itemId then
--                return callback(value.gudePrice[1],value.gudePrice[2],value.gudePrice[3])
--            end
--        end
--    end
--end
----获取零售店某个商品的推荐价格
--function BuildingShelfDetailPart:getRetailItemGuidePrice(itemId,callback)
--    if itemId ~= nil then
--        if not self.guideRetailPrice or next(self.guideRetailPrice) ~= nil then
--            for key,value in pairs(self.guideRetailPrice.goodMap) do
--                if value.itemId[1] == itemId then
--                    return callback(value.gudePrice[1],value.gudePrice[2],value.gudePrice[3],value.gudePrice[4],value.gudePrice[5])
--                end
--            end
--        end
--    end
--end