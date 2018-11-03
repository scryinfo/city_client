---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/19 10:17
---管理建筑首页的信息toggle mgr
require 'View/BuildingInfo/OccupancyRateItem'
require 'View/BuildingInfo/RentalItem'

require 'View/BuildingInfo/LineChartRateItem'
require 'View/BuildingInfo/StaffRateItem'
require 'View/BuildingInfo/WarehouseRateItem'
require 'View/BuildingInfo/ShelfRateItem'
require 'View/BuildingInfo/HomeProductionLineItem'



BuildingInfoToggleGroupMgr = class('BuildingInfoToggleGroupMgr')

BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME = 0.5  --item动画时间

BuildingInfoToggleGroupMgr.static.LEFT_POS = Vector2.New(0, 50)
BuildingInfoToggleGroupMgr.static.RIGHT_POS = Vector2.New(0, 50)

BuildingInfoToggleGroupMgr.static.HOUSE_OCC_PATH = "View/BuildingMainPageInfoItem/HouseOccupancyRateItem"  --住宅入住率预制路径
BuildingInfoToggleGroupMgr.static.HOUSE_RENTAL_PATH = "View/BuildingMainPageInfoItem/HouseRentalItem"  --住宅租金

BuildingInfoToggleGroupMgr.static.HOUSE_STAFF_PATH = "View/BuildingMainPageInfoItem/StaffRateItem"  --员工管理预制
BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH = "View/BuildingMainPageInfoItem/LineChartRateItem" --折线图预制
BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH = "View/BuildingMainPageInfoItem/WarehouseRateItem" --仓库
BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH = "View/BuildingMainPageInfoItem/ShelfRateItem"  --货架
BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE = "View/BuildingMainPageInfoItem/HomeProductionLineItem" --生产线

BuildingInfoToggleGroupMgr.static.Staff_PATH = "View/BuildingMainPageInfoItem/StaffRateItem"  --建筑员工


--初始化
function BuildingInfoToggleGroupMgr:initialize(leftRect, rightRect, mainPanelLuaBehaviour, buildingData)

    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    self.leftRect = leftRect
    self.rightRect = rightRect
    self.toggleData = buildingData
    self.leftData = {}
    self.rightData = {}

    if buildingData.buildingType == BuildingType.House then
        self:_creatHouseInfo()
    elseif buildingData.buildingType == BuildingType.MaterialFactory then
        self:_creatMaterialInfo()
    elseif buildingData.buildingType == BuildingType.ProcessingFactory then
        self:_creatProcessingInfo()
    end

    --创建完之后调整item位置
    self:_sortItems(1)
    self:_sortRightItems()
end

--每次打开一个Item，都要刷新位置
function BuildingInfoToggleGroupMgr:_clickItemFunc(toggleData)
    local leftIndex, rightIndex = nil
    if toggleData.pos == BuildingInfoTogglePos.Left then
        leftIndex = toggleData.index
    --elseif toggleData.pos == BuildingInfoTogglePos.Right then
    --    rightIndex = toggleData.index
    end

    self:_sortItems(leftIndex)
end

--通过预制创建view
function BuildingInfoToggleGroupMgr:_creatItemObj(path, parent, pos, nextHeight)
    local prefab = UnityEngine.Resources.Load(path)
    local go = UnityEngine.GameObject.Instantiate(prefab)
    local rect = go.transform:GetComponent("RectTransform")
    go.transform:SetParent(parent.transform)
    go.transform.localScale = Vector3.one;
    rect.anchoredPosition = Vector3.zero;

    return rect
end

--刷新item位置信息
function BuildingInfoToggleGroupMgr:_sortItems(leftOpenIndex)

    if leftOpenIndex ~= nil and leftOpenIndex > 0 then
        local leftPos = BuildingInfoToggleGroupMgr.static.LEFT_POS
        for key, toggleItem in pairs(self.leftData) do
            if toggleItem:getToggleIndex() == leftOpenIndex then
                leftPos = toggleItem:openToggleItem(leftPos)
            else
                leftPos = toggleItem:closeToggleItem(leftPos)
            end
        end
    end

    --if rightOpenIndex ~= nil and rightOpenIndex > 0 then
    --    local rightPos = BuildingInfoToggleGroupMgr.static.RIGHT_POS
    --    for key, toggleItem in pairs(self.rightData) do
    --        if toggleItem:getToggleIndex() == leftOpenIndex then
    --            rightPos = toggleItem:openToggleItem(rightPos)
    --        else
    --            rightPos = toggleItem:closeToggleItem(rightPos)
    --        end
    --    end
    --end
end

--排列右侧信息，只需要排一次，一直都处于打开状态
function BuildingInfoToggleGroupMgr:_sortRightItems()
    local rightPos = BuildingInfoToggleGroupMgr.static.RIGHT_POS
    for key, toggleItem in pairs(self.rightData) do
        rightPos = toggleItem:openToggleItem(rightPos)
    end
end

---创建住宅主页左右信息，左侧加载turnover，staff，occupancy，右侧加载rental
--请按照顺序添加
function BuildingInfoToggleGroupMgr:_creatHouseInfo()
    --分为左侧和右侧的item，如果是左边，creatItemObj返回的第二个参数是currentLeftPos，否则为currentRightPos
    --如果是第一个，则必须为打开状态，creatItemObj方法传的最后一个参数为TOTAL_H，否则为TOP_H

    ---营业额折线图Item --左边第一个
    local turnoverLineChart
    turnoverLineChart = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH, self.leftRect)
    turnoverLineChart.gameObject.name = "LineChartRateItem"

    local LineChartToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    local LineChartLuaItem = LineChartRateItem:new(nil, self._clickItemFunc, turnoverLineChart, self.mainPanelLuaBehaviour, LineChartToggleData, self)
    self.leftData[1] = LineChartLuaItem

    ---员工  左2
    local staffViewRect
    staffViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Staff_PATH, self.leftRect)
    staffViewRect.gameObject.name = "Staff"
    --测试数据
    local staffData = {}
    staffData.EmployeeSatisfaction = 0.8
    staffData.EmployeeDaywages = 18
    staffData.noDomicileCount = 3
    staffData.totalStaffCount = 100
    --end
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位
    local staffLuaItem = StaffRateItem:new(staffData, self._clickItemFunc, staffViewRect, self.mainPanelLuaBehaviour, staffToggleData, self)
    self.leftData[2] = staffLuaItem

    ---入住率  右1
    local occupancyViewRect
    occupancyViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_OCC_PATH, self.rightRect)
    occupancyViewRect.gameObject.name = "Occ01"
    --测试数据
    local occData = {}
    occData.totalCount = 60
    occData.renter = 18
    --end
    local occToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}  --处于toggleMgr的位置
    local occupancyLuaItem = OccupancyRateItem:new(occData, self._clickItemFunc, occupancyViewRect, self.mainPanelLuaBehaviour, occToggleData, self)
    self.rightData[1] = occupancyLuaItem

    ---租金 --右2
    local rentalViewRect
    rentalViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_RENTAL_PATH, self.rightRect)
    local rentalData = {}
    rentalData.rent = 500.23
    rentalData.effectiveDate = "2018/09/21/08:00:00"  --有效时间有待修改，为第二天的8点，需要读配置
    local rentalToggleData = { pos = BuildingInfoTogglePos.Right, index = 2}
    local rentalLuaItem = RentalItem:new(rentalData, self._clickItemFunc, rentalViewRect, self.mainPanelLuaBehaviour, rentalToggleData, self)
    self.rightData[2] = rentalLuaItem


end
--创建原料厂主页左右信息
function BuildingInfoToggleGroupMgr:_creatMaterialInfo()
    --分为左侧和右侧的item，如果是左边，creatItemObj返回的第二个参数是currentLeftPos，否则为currentRightPos
    --如果是第一个，则必须为打开状态，creatItemObj方法传的最后一个参数为TOTAL_H，否则为TOP_H

    ---营业额折线图Item --左边第一个
    local turnoverLineChart
    turnoverLineChart = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH, self.leftRect)
    turnoverLineChart.gameObject.name = "LineChartRateItem"

    local LineChartToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    local LineChartLuaItem = LineChartRateItem:new(nil, self._clickItemFunc, turnoverLineChart, self.mainPanelLuaBehaviour, LineChartToggleData, self)
    self.leftData[1] = LineChartLuaItem

--[[    ---员工管理Item --左边第二个
    local staffRateItemView
    staffRateItemView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_STAFF_PATH, self.leftRect)
    staffRateItemView.gameObject.name = "StaffRateItem"
    local stafftToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    local staffLuaItem = StaffRateItem:new(nil, self._clickItemFunc, staffRateItemView, self.mainPanelLuaBehaviour, stafftToggleData, self)
    self.leftData[2] = staffLuaItem]]

    ---员工  左1
    local staffViewRect
    staffViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Staff_PATH, self.leftRect)
    staffViewRect.gameObject.name = "Staff"
    --测试数据
    local staffData = {}
    staffData.EmployeeSatisfaction = 0.8
    staffData.EmployeeDaywages = 18
    staffData.noDomicileCount = 3
    staffData.totalStaffCount = 100
    --end
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    local staffLuaItem = StaffRateItem:new(staffData, self._clickItemFunc, staffViewRect, self.mainPanelLuaBehaviour, staffToggleData, self)
    self.leftData[2] = staffLuaItem


    ---仓库Item --左边第三个
    local warehouseView
    warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
    warehouseView.gameObject.name = "WarehouseRateItem"
    local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
    local warehouseLuaItem = WarehouseRateItem:new(nil, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
    self.leftData[3] = warehouseLuaItem

    ---货架Item --左边第四个
    local shelfView
    shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH, self.leftRect)
    shelfView.gameObject.name = "ShelfRateItem"
    local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
    local shelfLuaItem = ShelfRateItem:new(nil, self._clickItemFunc, shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
    self.leftData[4] = shelfLuaItem

    ---生产线 --右侧第一个
    local prodictionLineViewRect
    prodictionLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE, self.rightRect)
    prodictionLineViewRect.gameObject.name = "HomeProductionLineItem";
--[[    local rentalData = {}
    rentalData.rent = 500.23
    rentalData.effectiveDate = "2018/09/21/08:00:00"  --有效时间有待修改，为第二天的8点，需要读配置]]
    local prodictionToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
    local prodictionLuaItem = HomeProductionLineItem:new(nil, self._clickItemFunc, prodictionLineViewRect, self.mainPanelLuaBehaviour, prodictionToggleData, self)
    self.rightData[1] = prodictionLuaItem
end
--创建加工厂主页左右信息
function BuildingInfoToggleGroupMgr:_creatProcessingInfo()
    --分为左侧和右侧的item，如果是左边，creatItemObj返回的第二个参数是currentLeftPos，否则为currentRightPos
    --如果是第一个，则必须为打开状态，creatItemObj方法传的最后一个参数为TOTAL_H，否则为TOP_H

    ---营业额折线图Item --左边第一个
    local turnoverLineChart
    turnoverLineChart = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH, self.leftRect)
    turnoverLineChart.gameObject.name = "LineChartRateItem"

    local LineChartToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    local LineChartLuaItem = LineChartRateItem:new(nil, self._clickItemFunc, turnoverLineChart, self.mainPanelLuaBehaviour, LineChartToggleData, self)
    self.leftData[1] = LineChartLuaItem

    ---员工  左1
    local staffViewRect
    staffViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Staff_PATH, self.leftRect)
    staffViewRect.gameObject.name = "Staff"
    --测试数据
    local staffData = {}
    staffData.EmployeeSatisfaction = 0.8
    staffData.EmployeeDaywages = 18
    staffData.noDomicileCount = 3
    staffData.totalStaffCount = 100
    --end
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    local staffLuaItem = StaffRateItem:new(staffData, self._clickItemFunc, staffViewRect, self.mainPanelLuaBehaviour, staffToggleData, self)
    self.leftData[2] = staffLuaItem


    ---仓库Item --左边第三个
    local warehouseView
    warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
    warehouseView.gameObject.name = "WarehouseRateItem"
    local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
    local warehouseLuaItem = WarehouseRateItem:new(nil, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
    self.leftData[3] = warehouseLuaItem

    ---货架Item --左边第四个
    local shelfView
    shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH, self.leftRect)
    shelfView.gameObject.name = "ShelfRateItem"
    local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
    local shelfLuaItem = ShelfRateItem:new(nil, self._clickItemFunc, shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
    self.leftData[4] = shelfLuaItem

    ---生产线 --右侧第一个
    local prodictionLineViewRect
    prodictionLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE, self.rightRect)
    prodictionLineViewRect.gameObject.name = "HomeProductionLineItem";
    --[[    local rentalData = {}
        rentalData.rent = 500.23
        rentalData.effectiveDate = "2018/09/21/08:00:00"  --有效时间有待修改，为第二天的8点，需要读配置]]
    local prodictionToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
    local prodictionLuaItem = HomeProductionLineItem:new(nil, self._clickItemFunc, prodictionLineViewRect, self.mainPanelLuaBehaviour, prodictionToggleData, self)
    self.rightData[1] = prodictionLuaItem

end