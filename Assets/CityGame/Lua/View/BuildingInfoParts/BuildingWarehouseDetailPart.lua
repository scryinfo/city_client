---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 09:24
---建筑主界面仓库详情界面
BuildingWarehouseDetailPart = class('BuildingWarehouseDetailPart',BuildingBaseDetailPart)

local ToNumber = tonumber
local StringSun = string.sub
function BuildingWarehouseDetailPart:PrefabName()
    return "BuildingWarehouseDetailPart"
end
function BuildingWarehouseDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    --仓库数据
    self.warehouseDatas = {}
    --运输列表(运输成功后或退出建筑时清空)
    self.transportTab = {}
end
function BuildingWarehouseDetailPart:Show(data)
    BasePartDetail.Show(self,data)
    Event.AddListener("detailPartUpdateCapacity",self.updateCapacity,self)
end
function BuildingWarehouseDetailPart:Hide()
    BasePartDetail.Hide(self)
    Event.RemoveListener("detailPartUpdateCapacity",self.updateCapacity,self)
    if next(self.warehouseDatas) ~= nil then
        self:CloseDestroy(self.warehouseDatas)
    end
end
function BuildingWarehouseDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
    --合并两张表
    self.warehouseDataInfo = self:mergeTables(self.m_data.store.inHand,self.m_data.store.locked)
    self:initializeUiInfoData(self.warehouseDataInfo)
end

function BuildingWarehouseDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    --TopRoot
    self.closeBtn = transform:Find("topRoot/closeBtn")
    self.sortingBtn = transform:Find("topRoot/sortingBtn")
    self.nowStateText = transform:Find("topRoot/sortingBtn/nowStateText"):GetComponent("Text")
    self.transportBtn = transform:Find("topRoot/transportBtn")
    self.number = transform:Find("topRoot/number")
    self.numberText = transform:Find("topRoot/number/numberText"):GetComponent("Text")
    self.warehouseCapacitySlider = transform:Find("topRoot/warehouseCapacitySlider"):GetComponent("Slider")
    self.capacityNumberText = transform:Find("topRoot/warehouseCapacitySlider/numberText"):GetComponent("Text")
    self.capacityText = transform:Find("topRoot/capacityText"):GetComponent("Text")

    --ContentRoot
    self.noTip = transform:Find("contentRoot/noTip")
    self.tipText = transform:Find("contentRoot/noTip/tipText"):GetComponent("Text")
    self.Content = transform:Find("contentRoot/ScrollView/Viewport/Content")
    self.WarehouseItem = transform:Find("contentRoot/ScrollView/Viewport/Content/WarehouseItem").gameObject
end

function BuildingWarehouseDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject,function()
        self:clickCloseBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.transportBtn.gameObject,function()
        self:clickTransportBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.sortingBtn.gameObject,function()
        self:clickSortingBtn()
    end,self)
end

function BuildingWarehouseDetailPart:_ResetTransform()
    --关闭时清空Item数据
    if next(self.warehouseDatas) ~= nil then
        self:CloseDestroy(self.warehouseDatas)
    end
    --退出建筑是清空运输表
    if next(self.transportTab) ~= nil then
        self.transportTab = {}
    end
end

function BuildingWarehouseDetailPart:_RemoveClick()

end

function BuildingWarehouseDetailPart:_InitEvent()
    Event.AddListener("addTransportList",self.addTransportList,self)
    Event.AddListener("deleTransportList",self.deleTransportList,self)
    Event.AddListener("startTransport",self.startTransport,self)
    Event.AddListener("transportSucceed",self.transportSucceed,self)
    Event.AddListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
    Event.AddListener("deleteSucceed",self.deleteSucceed,self)
    Event.AddListener("getItemIdCount",self.getItemIdCount,self)
end

function BuildingWarehouseDetailPart:_RemoveEvent()
    Event.RemoveListener("addTransportList",self.addTransportList,self)
    Event.RemoveListener("deleTransportList",self.deleTransportList,self)
    Event.RemoveListener("startTransport",self.startTransport,self)
    Event.RemoveListener("transportSucceed",self.transportSucceed,self)
    Event.RemoveListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
    Event.RemoveListener("deleteSucceed",self.deleteSucceed,self)
    Event.RemoveListener("getItemIdCount",self.getItemIdCount,self)
end

function BuildingWarehouseDetailPart:_initFunc()
    self:_language()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingWarehouseDetailPart:_language()
    self.capacityText.text = "容量"
    self.tipText.text = "There is no product yet!".."\n".."just go to produce some.good luck."
end
--初始化UI数据
function BuildingWarehouseDetailPart:initializeUiInfoData(storeData)
    self.nowState = ItemScreening.all
    self.nowStateText.text = "All"
    if not storeData or next(storeData) == nil then
        self.Capacity = 0
        self.number.transform.localScale = Vector3.zero
        self.noTip.transform.localScale = Vector3.one
        self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
        self.warehouseCapacitySlider.value = 0
        self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue
    else
        self.noTip.transform.localScale = Vector3.zero
        self.Capacity = self:_getWarehouseCapacity(self.m_data.store)
        self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
        self.warehouseCapacitySlider.value = self.Capacity
        self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue
        if next(self.transportTab) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
        end
        if next(self.warehouseDatas) ~= nil then
            return
        else
            if next(self.warehouseDatas) ~= nil then
                self:CloseDestroy(self.warehouseDatas)
            end
            self.transportBool = GoodsItemStateType.transport
            self:CreateGoodsItems(storeData,self.WarehouseItem,self.Content,WarehouseItem,self.mainPanelLuaBehaviour,self.warehouseDatas,self.m_data.buildingType,self.transportBool)
        end
    end
end
-----------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------
--关闭详情
function BuildingWarehouseDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--打开运输弹窗
function BuildingWarehouseDetailPart:clickTransportBtn()
    local data = {}
    data.buildingId = self.m_data.insId
    data.buildingInfo = self.m_data.info
    data.buildingType = self.m_data.buildingType
    data.itemPrefabTab = self.transportTab
    data.stateType = GoodsItemStateType.transport
    ct.OpenCtrl("NewTransportBoxCtrl",data)
end
--切换分类
function BuildingWarehouseDetailPart:clickSortingBtn()
    if self.nowState == ItemScreening.all then
        --原料
        self.nowState = ItemScreening.material
        self.nowStateText.text = "Material"
        if next(self.warehouseDatas) ~= nil then
            self:CloseDestroy(self.warehouseDatas)
        end
        self.materialDataInfo = self:screeningTabInfo(self.warehouseDataInfo,self.nowState)
        self:CreateGoodsItems(self.materialDataInfo,self.WarehouseItem,self.Content,WarehouseItem,self.mainPanelLuaBehaviour,self.warehouseDatas,self.m_data.buildingType,self.transportBool)
    elseif self.nowState == ItemScreening.material then
        --商品
        self.nowState = ItemScreening.goods
        self.nowStateText.text = "Goods"
        if next(self.warehouseDatas) ~= nil then
            self:CloseDestroy(self.warehouseDatas)
        end
        self.goodsDataInfo = self:screeningTabInfo(self.warehouseDataInfo,self.nowState)
        self:CreateGoodsItems(self.goodsDataInfo,self.WarehouseItem,self.Content,WarehouseItem,self.mainPanelLuaBehaviour,self.warehouseDatas,self.m_data.buildingType,self.transportBool)
    elseif self.nowState == ItemScreening.goods then
        --全部
        self.nowState = ItemScreening.all
        self.nowStateText.text = "All"
        if next(self.warehouseDatas) ~= nil then
            self:CloseDestroy(self.warehouseDatas)
        end
        self:CreateGoodsItems(self.warehouseDataInfo,self.WarehouseItem,self.Content,WarehouseItem,self.mainPanelLuaBehaviour,self.warehouseDatas,self.m_data.buildingType,self.transportBool)
    end
end
-----------------------------------------------------------------------------事件函数---------------------------------------------------------------------------------------
--添加运输列表
function BuildingWarehouseDetailPart:addTransportList(data)
    --添加到运输列表
    if next(self.transportTab) == nil then
        table.insert(self.transportTab,data)
        self.number.transform.localScale = Vector3.one
        self.numberText.text = #self.transportTab
        Event.Brocast("SmallPop","添加成功", 300)
    else
        for key,value in pairs(self.transportTab) do
            if value.itemId == data.itemId then
                Event.Brocast("SmallPop","不能重复添加同一种商品", 300)
                return
            end
        end
        table.insert(self.transportTab,data)
        --self.number.transform.localScale = Vector3.one
        self.numberText.text = #self.transportTab
        Event.Brocast("SmallPop","添加成功", 300)
    end
end
--删除运输列表
function BuildingWarehouseDetailPart:deleTransportList(id)
    --删除指定的数据
    if not id then
        return
    else
        table.remove(self.transportTab,id)
        if next(self.transportTab) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
            self.numberText.text = #self.transportTab
        end
    end
    Event.Brocast("SmallPop","删除成功", 300)
end
--开始运输
function BuildingWarehouseDetailPart:startTransport(dataInfo,targetBuildingId)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --原料厂
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_MaterialTransport",self.m_data.insId,targetBuildingId,value.itemId,value.dataInfo.number,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --加工厂
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_processingTransport",self.m_data.insId,targetBuildingId,value.itemId,value.dataInfo.number,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.RetailShop then
        --零售店
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_RetailStoresTransport",self.m_data.insId,targetBuildingId,value.itemId,value.dataInfo.number,value.dataInfo.producerId,value.dataInfo.qty)
        end
    end
end
--销毁商品
function BuildingWarehouseDetailPart:deleteWarehouseItem(dataInfo)
    if dataInfo ~= nil then
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            --原料厂
            Event.Brocast("m_ReqMaterialDelItem",self.m_data.insId,dataInfo.itemId,dataInfo.num,dataInfo.producerId,dataInfo.qty)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            --加工厂
            Event.Brocast("m_ReqprocessingDelItem",self.m_data.insId,dataInfo.itemId,dataInfo.num,dataInfo.producerId,dataInfo.qty)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            --零售店
            Event.Brocast("m_ReqRetailStoresDelItem",self.m_data.insId,dataInfo.itemId,dataInfo.num,dataInfo.producerId,dataInfo.qty)
        end
    end
end
------------------------------------------------------------------------------------回调函数------------------------------------------------------------------------------------
--刷新生产线生产出来商品，当前的仓库容量
function BuildingWarehouseDetailPart:updateCapacity(data)
    if data ~= nil then
        self.Capacity = self.Capacity + 1
        self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
        self.warehouseCapacitySlider.value = self.Capacity
        self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue

        --刷新仓库界面
        for key,value in pairs(self.warehouseDatas) do
            if value.itemId == data.iKey.id then
                --value.dataInfo.n = value.dataInfo.n + 1
                value.numberText.text = "×"..value.dataInfo.n
            end
        end
    end
end
--运输成功回调
function BuildingWarehouseDetailPart:transportSucceed(data)
    if data ~= nil then
        --刷新仓库界面
        for key,value in pairs(self.warehouseDatas) do
            if value.itemId == data.item.key.id then
                if value.dataInfo.n == data.item.n then
                    self:deleteGoodsItem(self.warehouseDatas,key)
                else
                    value.dataInfo.n = value.dataInfo.n - data.item.n
                    value.numberText.text = "×"..value.dataInfo.n
                end
            end
        end
        --刷新建筑数据
        for key,value in pairs(self.m_data.store.inHand) do
            if value.key.id == data.item.key.id then
                if value.n == data.item.n then
                    table.remove(self.m_data.store.inHand,key)
                else
                    value.n = value.n - data.item.n
                end
            end
        end
    end
    --运输成功后，如果仓库是空的
    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
        self.noTip.transform.localScale = Vector3.one
    end
    self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
    self.warehouseCapacitySlider.value = self.warehouseCapacitySlider.value - data.item.n
    self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue
    self.number.transform.localScale = Vector3.zero
    self.transportTab = {}
    UIPanel.ClosePage()
    Event.Brocast("SmallPop", GetLanguage(21040003), 300)
end
--销毁成功后回调
function BuildingWarehouseDetailPart:deleteSucceed(data)
    if data ~= nil then
        --刷新仓库界面
        for key,value in pairs(self.warehouseDatas) do
            if value.itemId == data.item.key.id then
                if value.dataInfo.n == data.item.n then
                    self:deleteGoodsItem(self.warehouseDatas,key)
                else
                    value.dataInfo.n = value.dataInfo.n - data.item.n
                    value.numberText.text = "×"..value.dataInfo.n
                end
            end
        end
        --刷新建筑数据
        for key,value in pairs(self.m_data.store.inHand) do
            if value.key.id == data.item.key.id then
                if value.n == data.item.n then
                    table.remove(self.m_data.store.inHand,key)
                else
                    value.n = value.n - data.item.n
                end
            end
        end
    end
    --销毁成功后，如果仓库是空的
    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
        self.noTip.transform.localScale = Vector3.one
    end
    self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
    self.warehouseCapacitySlider.value = self.warehouseCapacitySlider.value - data.item.n
    self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue
    UIPanel.ClosePage()
    Event.Brocast("SmallPop", GetLanguage(26030003), 300)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--获取仓库里某个商品的数量
--(后边要修改)
function BuildingWarehouseDetailPart:getItemIdCount(itemId,callback)
    if itemId ~= nil then
        local nowCount = 0
        if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
            nowCount = 0
        else
            for key,value in pairs(self.m_data.store.inHand) do
                if value.key.id == itemId then
                    nowCount = value.n
                end
            end
        end
        callback(nowCount)
    end
end
--合并两张表
function BuildingWarehouseDetailPart:mergeTables(inHandTab,lockedTab)
    local targetTab = {}
    if inHandTab == nil and lockedTab == nil then
        targetTab = {}
    end
    if inHandTab ~= nil then
        for key,value in pairs(inHandTab) do
            targetTab[value.key.id] = ct.deepCopy(value)
        end
    end
    if lockedTab ~= nil then
        for key,value in pairs(lockedTab) do
            if targetTab[value.key.id] then
                targetTab[value.key.id].n = targetTab[value.key.id].n + value.n
            else
                targetTab[value.key.id] = ct.deepCopy(value)
            end
        end
    end
    return targetTab
end
--分类
function BuildingWarehouseDetailPart:screeningTabInfo(data,type)
    local materialKey,goodsKey = 21,22
    local targetTable = {}
    for key,value in pairs(data) do
        if type == ItemScreening.material then
            if ToNumber(StringSun(key,1,2)) == materialKey then
                targetTable[#targetTable + 1] = ct.deepCopy(value)
            end
        elseif type == ItemScreening.goods then
            if ToNumber(StringSun(key,1,2)) == goodsKey then
                targetTable[#targetTable + 1] = ct.deepCopy(value)
            end
        end
    end
    return targetTable
end