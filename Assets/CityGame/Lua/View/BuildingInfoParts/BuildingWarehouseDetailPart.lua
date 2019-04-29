---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 09:24
---建筑主界面仓库详情界面
BuildingWarehouseDetailPart = class('BuildingWarehouseDetailPart',BuildingBaseDetailPart)

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
    self:initializeUiInfoData(self.m_data.store.inHand)
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
end

function BuildingWarehouseDetailPart:_RemoveEvent()
    Event.RemoveListener("addTransportList",self.addTransportList,self)
    Event.RemoveListener("deleTransportList",self.deleTransportList,self)
    Event.RemoveListener("startTransport",self.startTransport,self)
    Event.RemoveListener("transportSucceed",self.transportSucceed,self)
    Event.RemoveListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
    Event.RemoveListener("deleteSucceed",self.deleteSucceed,self)
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
    if not storeData then
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
        if #storeData == #self.warehouseDatas then
            return
        else
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
-----------------------------------------------------------------------------事件函数---------------------------------------------------------------------------------------
--添加运输列表
function BuildingWarehouseDetailPart:addTransportList(data)
    --添加到运输列表
    table.insert(self.transportTab,data)
    self.number.transform.localScale = Vector3.one
    self.numberText.text = #self.transportTab
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
    elseif self.m_data.buildingType == BuildingType.TalentCenter then
        --集散中心
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
        elseif self.m_data.buildingType == BuildingType.TalentCenter then
            --集散中心
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
end
