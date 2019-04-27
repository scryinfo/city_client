---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---自己的建筑
MapRightSelfBuildingPage = class('MapRightSelfBuildingPage', MapRightPageBase)
MapRightSelfBuildingPage.moneyColor = "#F4AD07FF"

--初始化方法
function MapRightSelfBuildingPage:initialize(viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")
    local tran = self.viewRect.transform

    self.closeBtn = tran:Find("closeBtn"):GetComponent("Button")
    self.goHereBtn = tran:Find("goHereBtn"):GetComponent("Button")
    self.buildingNameText = tran:Find("buildingNameText"):GetComponent("Text")
    self.showRoot = tran:Find("opened/showRoot")
    self.openedTran = tran:Find("opened")
    self.notOpenTran = tran:Find("notOpenTran")
    self.notOpenText01 = tran:Find("notOpenTran/Text"):GetComponent("Text")

    self.closeBtn.onClick:AddListener(function ()
        self:close()
    end)
    self.goHereBtn.onClick:AddListener(function ()
        self:_goHereBtn()
    end)
    --
    self.goHereText01 = self.viewRect.transform:Find("goHereBtn/Text"):GetComponent("Text")
    Event.AddListener("c_Revenue", self._updateRevenue, self)
end
--
function MapRightSelfBuildingPage:_updateRevenue(income)
    if self.revenueItem == nil then
        return
    end
    local inconme = string.format("<color=%s>E%s</color>/D", MapRightSelfBuildingPage.moneyColor, GetClientPriceString(income))
    self.revenueItem:refreshData(inconme)
end
--
function MapRightSelfBuildingPage:refreshData(data)
    self.viewRect.anchoredPosition = Vector2.zero
    self:_cleanItems()

    local buildingDetail = DataManager.GetSelfBuildingDetailByBlockId(data.buildingId)
    self.data = buildingDetail
    local info = buildingDetail.info
    self.buildingNameText.text = string.format("%s %s%s", info.name, GetLanguage(PlayerBuildingBaseData[info.mId].sizeName), GetLanguage(PlayerBuildingBaseData[info.mId].typeName))
    if info.state == "OPERATE" then
        self.notOpenTran.localScale = Vector3.zero
        self.openedTran.localScale = Vector3.one
        local buildingType = GetBuildingTypeById(info.mId)
        --请求今日营收
        DataManager.ModelSendNetMes("gscode.OpCode", "getPrivateBuildingCommonInfo","gs.Bytes",{ids = {buildingDetail.info.id}})
        self:_createInfoByType(buildingType)
        self:_sortInfoItems()
    else
        self.notOpenTran.localScale = Vector3.one
        self.openedTran.localScale = Vector3.zero
    end
    self:openShow()
end
--
function MapRightSelfBuildingPage:_sortInfoItems()
    if self.items == nil or #self.items == 0 then
        return
    end
    local pos = Vector3.zero
    for i, item in ipairs(self.items) do
        item:setPos(pos)
        pos.y = pos.y - 66  --66是item的高度+间隔得来的
    end
end
--
function MapRightSelfBuildingPage:_createInfoByType(buildingType)
    local inconme = string.format("<color=%s>E%s</color>/D", MapRightSelfBuildingPage.moneyColor, GetClientPriceString(0))
    local revenueData = {infoTypeStr = "Revenue", value = inconme}  --今日营收
    local revenueItem = self:_createShowItem(revenueData)
    self.items[#self.items + 1] = revenueItem
    self.revenueItem = revenueItem

    local salaryData = {infoTypeStr = "Salary", value = self.data.info.salary.."%"}  --工资
    self.items[#self.items + 1] = self:_createShowItem(salaryData)

    if buildingType == BuildingType.House then
        self:_createHouse()
    elseif buildingType == BuildingType.MaterialFactory or buildingType == BuildingType.ProcessingFactory then
        self:_createMaterial()
    elseif buildingType == BuildingType.RetailShop then
        self:_createRetailShop()
    elseif buildingType == BuildingType.Warehouse then
        self:_createWarehouse()
    elseif buildingType == BuildingType.Laboratory then
        self:_createLab()
    elseif buildingType == BuildingType.Municipal then
        self:_createPromotion()
    end
end
--住宅
function MapRightSelfBuildingPage:_createHouse()
    local occStr = string.format("%d/%d", self.data.renter, PlayerBuildingBaseData[self.data.info.mId].npc)
    local occData = {infoTypeStr = "HouseOccupancy", value = occStr}  --入住率
    self.items[#self.items + 1] = self:_createShowItem(occData)

    local rentStr = string.format("<color=%s>E%s</color>/D", MapRightSelfBuildingPage.moneyColor, GetClientPriceString(self.data.rent))
    local rentData = {infoTypeStr = "HouseRent", value = rentStr}  --租金
    self.items[#self.items + 1] = self:_createShowItem(rentData)

    local data3 = {infoTypeStr = "Sign", value = self:getSignState(self.data.contractInfo)}  --签约
    self.items[#self.items + 1] = self:_createShowItem(data3)
end
--原料厂
function MapRightSelfBuildingPage:_createMaterial()
    local used = self:_getWarehouseCapacity(self.data.store)
    local str1 = string.format("%d/%d", used, PlayerBuildingBaseData[self.data.info.mId].storeCapacity)
    local data1 = {infoTypeStr = "Warehouse", value = str1}  --仓库容量
    self.items[#self.items + 1] = self:_createShowItem(data1)

    local data3 = {infoTypeStr = "OrderCenter", value = self:getShelfCount(self.data.shelf)}  --订单中心
    self.items[#self.items + 1] = self:_createShowItem(data3)

    if self.data.line == nil then  --生产线
        local str2 = GetLanguage(12345678)
        local data2 = {infoTypeStr = "Production", value = str2}
        self.items[#self.items + 1] = self:_createShowItem(data2)
    else
        local detailImgPath = Material[self.data.line[1].itemId].img
        local data2 = {infoTypeStr = "Production", value = GetLanguage(12345678), detailImgPath = detailImgPath}
        self.items[#self.items + 1] = self:_createShowItem(data2, true)
    end
end
--零售店
function MapRightSelfBuildingPage:_createRetailShop()
    local used = self:_getWarehouseCapacity(self.data.store)
    local str1 = string.format("%d/%d", used, PlayerBuildingBaseData[self.data.info.mId].storeCapacity)
    local data1 = {infoTypeStr = "Warehouse", value = str1}  --仓库容量
    self.items[#self.items + 1] = self:_createShowItem(data1)

    local data2 = {infoTypeStr = "OrderCenter", value = self:getShelfCount(self.data.shelf)}  --订单中心
    self.items[#self.items + 1] = self:_createShowItem(data2)

    local data3 = {infoTypeStr = "Sign", value = self:getSignState(self.data.contractInfo)}  --签约
    self.items[#self.items + 1] = self:_createShowItem(data3)
end
--研究所
function MapRightSelfBuildingPage:_createLab()
    local data3 = {infoTypeStr = "Queued", value = self:getLabQueued(self.data.inProcess)}  --研究所队列
    self.items[#self.items + 1] = self:_createShowItem(data3)
end
--仓库
function MapRightSelfBuildingPage:_createWarehouse()
    --local used = self:_getWarehouseCapacity(self.data.store)
    --local str1 = string.format("%d/%d", used, PlayerBuildingBaseData[self.data.info.mId].storeCapacity)
    --local data1 = {infoTypeStr = "Warehouse", value = str1}  --仓库容量
    --self.items[#self.items + 1] = self:_createShowItem(data1)
    --
    --local data2 = {infoTypeStr = "OrderCenter", value = self:getShelfCount(self.data.shelf)}  --订单中心
    --self.items[#self.items + 1] = self:_createShowItem(data2)

    --local data3 = {infoTypeStr = "WarehouseRent", value = self:getSignState(self.data.contractInfo)}  --仓库租赁
    --self.items[#self.items + 1] = self:_createShowItem(data3)
end
--推广公司
function MapRightSelfBuildingPage:_createPromotion()
    --local data1 = {infoTypeStr = "Queued", value = self.data.inProcess}  --队列
    --self.items[#self.items + 1] = self:_createShowItem(data1)
    --
    --local data3 = {infoTypeStr = "ADSign", value = self.data.queued.."%"}  --流量签约
    --self.items[#self.items + 1] = self:_createShowItem(data3)
end
--研究所队列
function MapRightSelfBuildingPage:getLabQueued(line)
    local reminderTime = 0
    for i, lineData in ipairs(line) do
        reminderTime = reminderTime + (lineData.times- (lineData.availableRoll + lineData.usedRoll))
    end
    return reminderTime
end
--判断签约状态
function MapRightSelfBuildingPage:getSignState(contractInfo)
    local str
    if contractInfo.isOpen == false then
        str = "尚未开启签约"
        return str
    end
    if contractInfo.isOpen == true and contractInfo.contract == nil then
        str = "尚未签约"
        return str
    end
    if contractInfo.isOpen == true and contractInfo.contract ~= nil then
        str = "已签约"
        return str
    end
end
--计算货架总数
function MapRightSelfBuildingPage:getShelfCount(data)
    local count = 0
    if not data.good then
        count = 0
    else
        for key,value in pairs(data.good) do
            count = count + value.n
        end
    end
    return count
end
--计算仓库容量
function MapRightSelfBuildingPage:_getWarehouseCapacity(store)
    local warehouseNowCount = 0
    local lockedNowCount = 0
    if store.inHand == nil then
        warehouseNowCount = 0
    else
        for key,value in pairs(store.inHand) do
            warehouseNowCount = warehouseNowCount + value.n
        end
    end
    if store.locked == nil then
        lockedNowCount = 0
    else
        for key,value in pairs(store.locked) do
            lockedNowCount = lockedNowCount + value.n
        end
    end
    return warehouseNowCount + lockedNowCount
end
--
function MapRightSelfBuildingPage:_createShowItem(data, hasDetail)
    local obj
    if hasDetail == true then
        obj = MapPanel.prefabPools[MapPanel.MapShowInfoHasImgPoolName]:GetAvailableGameObject()
    else
        obj = MapPanel.prefabPools[MapPanel.MapShowInfoPoolName]:GetAvailableGameObject()
    end
    obj.transform:SetParent(self.showRoot)
    obj.transform.localScale = Vector3.one
    local item = MapRightShowInfoItem:new(obj)
    item:initData(data)
    return item
end
--
function MapRightSelfBuildingPage:_cleanItems()
    if self.items == nil then
        self.items = {}
        return
    end
    for i, item in pairs(self.items) do
        if item:getIsDetail() == true then
            MapPanel.prefabPools[MapPanel.MapShowInfoHasImgPoolName]:RecyclingGameObjectToPool(item.viewRect.gameObject)
        else
            MapPanel.prefabPools[MapPanel.MapShowInfoPoolName]:RecyclingGameObjectToPool(item.viewRect.gameObject)
        end
        item = nil
    end
    self.items = {}
end


--重置状态
function MapRightSelfBuildingPage:openShow()
    self:_language()
    self.viewRect.anchoredPosition = Vector2.zero
end
--多语言
function MapRightSelfBuildingPage:_language()
    --正式代码
    --self.goHereText01.text = GetLanguage()
    self.goHereText01.text = "Go here"
    self.notOpenText01.text = "Not open"
end
--关闭
function MapRightSelfBuildingPage:close()
    --Event.RemoveListener("c_Revenue", self._updateRevenue, self)
    self.viewRect.anchoredPosition = Vector2.New(506, 0)
    self:_cleanItems()
    self.revenueItem = nil
    self.data = nil
    self = nil
end
--去地图上的一个建筑
function MapRightSelfBuildingPage:_goHereBtn()
    MapBubbleManager.GoHereFunc(self.data.info)
    local blockId = TerrainManager.GridIndexTurnBlockID(self.data.info.pos)
    local tempValue = DataManager.GetBaseBuildDataByID(blockId)
    if tempValue ~= nil then
        tempValue:OpenPanel()
        CameraMove.MoveIntoUILayer(blockId)
    end
end