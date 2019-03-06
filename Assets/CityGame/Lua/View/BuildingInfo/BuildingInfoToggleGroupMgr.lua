---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/19 10:17
---管理建筑首页的信息toggle mgr
require 'View/BuildingInfo/OccupancyRateItem'
require 'View/BuildingInfo/RentalItem'

require 'View/BuildingInfo/LineChartRateItem'
require 'View/BuildingInfo/AdLineChartItem'
require 'View/BuildingInfo/StaffRateItem'
require 'View/BuildingInfo/WarehouseRateItem'
require 'View/BuildingInfo/ShelfRateItem'
require 'View/BuildingInfo/HomeProductionLineItem'
require 'View/BuildingInfo/AdvertisementShowItem'
require'View/BuildingInfo/ParkInfoItem'
require 'View/BuildingInfo/TicketItem'



BuildingInfoToggleGroupMgr = class('BuildingInfoToggleGroupMgr')

BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME = 0.5  --item动画时间

BuildingInfoToggleGroupMgr.static.LEFT_POS = Vector2.New(0, 50)
BuildingInfoToggleGroupMgr.static.RIGHT_POS = Vector2.New(0, 50)
BuildingInfoToggleGroupMgr.static.MIDDLE_POS=Vector2.New(0,50)

BuildingInfoToggleGroupMgr.static.HOUSE_OCC_PATH = "View/BuildingMainPageInfoItem/HouseOccupancyRateItem"  --住宅入住率预制路径
BuildingInfoToggleGroupMgr.static.HOUSE_RENTAL_PATH = "View/BuildingMainPageInfoItem/HouseRentalItem"  --住宅租金

BuildingInfoToggleGroupMgr.static.HOUSE_STAFF_PATH = "View/BuildingMainPageInfoItem/StaffRateItem"  --员工管理预制
BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH = "View/BuildingMainPageInfoItem/LineChartRateItem" --折线图预制
BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH = "View/BuildingMainPageInfoItem/WarehouseRateItem" --仓库
BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH = "View/BuildingMainPageInfoItem/ShelfRateItem"  --货架
BuildingInfoToggleGroupMgr.static.Material_PRODUCTION_OTHER = "View/BuildingMainPageInfoItem/HomeOtherPlayerLineItem"  --其他玩家 生产线
BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE = "View/BuildingMainPageInfoItem/ProductionLineItem" --生产线
BuildingInfoToggleGroupMgr.static.Material_SHELF_OTHER = "View/BuildingMainPageInfoItem/HomeOtherPlayerShelfItem"  --其他玩家 货架

BuildingInfoToggleGroupMgr.static.Staff_PATH = "View/BuildingMainPageInfoItem/StaffRateItem"  --建筑员工

BuildingInfoToggleGroupMgr.static.Municipal_Advertisement_Path="View/BuildingMainPageInfoItem/AdvertisementShowItem"--广告展示
BuildingInfoToggleGroupMgr.static.Municipal_LineChart_Path = "View/BuildingMainPageInfoItem/AdLineChartItem"  --广告折线图
BuildingInfoToggleGroupMgr.static.Municipal_ParkInfo_Path="View/BuildingMainPageInfoItem/ParkInfoItem"--公园信息
BuildingInfoToggleGroupMgr.static.Municipal_Ticket_Path="View/BuildingMainPageInfoItem/TicketItem"--门票信息
BuildingInfoToggleGroupMgr.static.Laboratory_Path = "View/BuildingMainPageInfoItem/LabBuildingInfoResearchItem"  --研究线
BuildingInfoToggleGroupMgr.static.BuildingBrand_Path = "View/BuildingMainPageInfoItem/BuildingBrandItem"  --品牌品质

BuildingInfoToggleGroupMgr.static.TalentManagementItem_Path = "View/TalentCenterItem/TalentManagementItem"  --人才管理
BuildingInfoToggleGroupMgr.static.ExcavateTalentsItem_Path = "View/TalentCenterItem/ExcavateTalentsItem"  --挖掘人才


--初始化
--最后一个参数是品牌品质的父物体，可有可无
function BuildingInfoToggleGroupMgr:initialize(leftRect, rightRect, mainPanelLuaBehaviour, buildingData, topBrandRect)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    self.leftRect = leftRect
    self.rightRect = rightRect
    self.topBrandRect = topBrandRect
    self.toggleData = buildingData
    self.leftData = {}
    self.rightData = {}
    self.middleData={}

    if buildingData.buildingType == BuildingType.House then
        self:_creatHouseInfo()
    elseif buildingData.buildingType == BuildingType.MaterialFactory then
        self:_creatMaterialInfo()
    elseif buildingData.buildingType == BuildingType.Municipal then
        self:_creatMunicipalInfo()
    elseif buildingData.buildingType == BuildingType.ProcessingFactory then
        self:_creatProcessingInfo()
    elseif buildingData.buildingType == BuildingType.Laboratory then
        self:_creatResearchLineInfo()
    elseif buildingData.buildingType == BuildingType.RetailShop then
        self:_creatRetailShop()
    elseif buildingData.buildingType == BuildingType.TalentCenter then
        self:_creatTalentInfo()
    end

    --创建完之后调整item位置
    self:_sortItems(1, 1)
    --self:_sortRightItems()
end
--刷新数据
function BuildingInfoToggleGroupMgr:updateInfo(buildingData)
    self.toggleData = buildingData
    if buildingData.buildingType == BuildingType.House then
        self:_creatHouseInfo()
    elseif buildingData.buildingType == BuildingType.MaterialFactory then
        self:_creatMaterialInfo()
    elseif buildingData.buildingType == BuildingType.Municipal then
        self:_creatMunicipalInfo()
    elseif buildingData.buildingType == BuildingType.ProcessingFactory then
        self:_creatProcessingInfo()
    elseif buildingData.buildingType == BuildingType.Laboratory then
        self:_creatResearchLineInfo()
    elseif buildingData.buildingType == BuildingType.TalentCenter then
        self:_creatTalentInfo()
    elseif buildingData.buildingType == BuildingType.RetailShop then
        self:_creatRetailShop()
    end
    self:_sortItems(1, 1)
end

--清除lua实例
function BuildingInfoToggleGroupMgr:cleanItems()
    for i, item in ipairs(self.leftData) do
        item = nil
    end
    for i, item in ipairs(self.rightData) do
        item = nil
    end
    for i, item in ipairs(self.middleData) do
        item = nil
    end
    self.brandItem = nil
end

--每次打开一个Item，都要刷新位置
function BuildingInfoToggleGroupMgr:_clickItemFunc(toggleData)
    local leftIndex, rightIndex = nil
    if toggleData.pos == BuildingInfoTogglePos.Left then
        leftIndex = toggleData.index
    elseif toggleData.pos == BuildingInfoTogglePos.Right then
        rightIndex = toggleData.index
    end
    self:_sortItems(leftIndex,rightIndex)
end

--通过预制创建view
function BuildingInfoToggleGroupMgr:_creatItemObj(path, parent)
    local prefab = UnityEngine.Resources.Load(path)
    local go = UnityEngine.GameObject.Instantiate(prefab)
    local rect = go.transform:GetComponent("RectTransform")
    go.transform:SetParent(parent.transform)
    go.transform.localScale = Vector3.one
    rect.anchoredPosition = Vector3.zero

    return rect
end

--刷新item位置信息
function BuildingInfoToggleGroupMgr:_sortItems(leftOpenIndex, rightOpenIndex)

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

    if rightOpenIndex ~= nil and rightOpenIndex > 0 then
        local rightPos = BuildingInfoToggleGroupMgr.static.RIGHT_POS
        for key, toggleItem in pairs(self.rightData) do
            if toggleItem:getToggleIndex() == rightOpenIndex then
                rightPos = toggleItem:openToggleItem(rightPos)
            else
                rightPos = toggleItem:closeToggleItem(rightPos)
            end
        end
    end
end

--排列右侧信息，只需要排一次，一直都处于打开状态
function BuildingInfoToggleGroupMgr:_sortRightItems()
    local rightPos = BuildingInfoToggleGroupMgr.static.RIGHT_POS
    for key, toggleItem in pairs(self.rightData) do
        rightPos = toggleItem:openToggleItem(rightPos)
    end
end

local num=1  local temp=nil
function BuildingInfoToggleGroupMgr:_middleItem(toggleData)

    --for i, item in pairs(self.middleData) do
    --    if(item:getToggleIndex()==toggleData.index)then
    --
    --        if item==temp then
    --            if num%2==1 then
    --                item:openToggleItem()
    --                num=num+1
    --            else
    --                item:closeToggleItem()
    --                num=num+1
    --            end
    --        else
    --            num=1
    --            item:openToggleItem()
    --            num=num+1
    --            temp=item
    --        end
    --    end
    --end
end


---创建住宅主页左右信息，左侧加载turnover，staff，occupancy，右侧加载rental
--请按照顺序添加
function BuildingInfoToggleGroupMgr:_creatHouseInfo()
    ---折线图  左1
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)

    ---员工  左2
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}
    self.leftData[2] = self:_createStaff(staffToggleData)

    ---入住率  右1
    local occToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
    self.rightData[1] = self:_creatOccupancy(occToggleData)

    ---品牌品质
    self.brandItem = self:_createBrand(self.toggleData)
end

--创建原料厂主页左右信息
function BuildingInfoToggleGroupMgr:_creatMaterialInfo()
    --营业额折线图Item  左1
    --折线图  左1
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)

    if self.toggleData.isOther then
        --其他玩家进入
        if self.otherShelfRateItem then
            self.otherShelfView.gameObject:SetActive(true)
        end
        --购买货架
        local otherShelfToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        self.rightData[1] = self:creatOtherPlayerShelf(otherShelfToggleData)

        --如果这几个信息在，就隐藏  生产线
        if self.productionRateItem then
            self.productionView.gameObject:SetActive(false)
        end
        --员工
        if self.staffViewRect then
            self.staffViewRect.gameObject:SetActive(false)
        end
        --仓库
        if self.warehouseRateItem then
            self.warehouseView.gameObject:SetActive(false)
        end
        --货架
        if self.shelfRateItem then
            self.shelfView.gameObject:SetActive(false)
        end
        --生产线
        if self.productionRateItem then
            self.productionView.gameObject:SetActive(false)
        end
    else
        --如果这几个信息在，就显示  生产线
        if self.otherShelfRateItem then
            self.otherShelfView.gameObject:SetActive(false)
        else
        end
        --员工
        if self.staffViewRect then
            self.staffViewRect.gameObject:SetActive(true)
        end
        --仓库
        if self.warehouseRateItem then
            self.warehouseView.gameObject:SetActive(true)
        end
        --货架
        if self.shelfRateItem then
            self.shelfView.gameObject:SetActive(true)
        end
        --生产线
        if self.productionRateItem then
            self.productionView.gameObject:SetActive(true)
        end
        --员工  左2
        local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        self.leftData[2] = self:_createStaff(staffToggleData)

        --仓库Item 左3
        local warehouseToggleData = {pos = BuildingInfoTogglePos.Left, index = 3}   --处于toggleMgr的位置
        self.leftData[3] = self:creatRefreshWarehouse(warehouseToggleData)

        --货架 右1
        local shelfToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}  --处于toggleMgr的位置
        self.rightData[1] = self:creatRefreshShelf(shelfToggleData)

        --生产线 --左4
        local productionToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}
        self.leftData[4] = self:creatRefreshProductionLine(productionToggleData)
    end
end
--创建加工厂主页左右信息
function BuildingInfoToggleGroupMgr:_creatProcessingInfo()
    --营业额折线图Item  --左1
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)

    if self.toggleData.isOther then
        --其他玩家进入
        if self.otherShelfRateItem then
            self.otherShelfView.gameObject:SetActive(true)
        end
        --购买货架
        local otherShelfToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        self.rightData[1] = self:creatOtherPlayerShelf(otherShelfToggleData)
        --如果这几个信息在，就隐藏  生产线
        if self.productionRateItem then
            self.productionView.gameObject:SetActive(false)
        end
        --员工
        if self.staffViewRect then
            self.staffViewRect.gameObject:SetActive(false)
        end
        --仓库
        if self.warehouseRateItem then
            self.warehouseView.gameObject:SetActive(false)
        end
        --货架
        if self.shelfRateItem then
            self.shelfView.gameObject:SetActive(false)
        end
        --生产线
        if self.productionRateItem then
            self.productionView.gameObject:SetActive(false)
        end

    else
        --如果这几个信息在，就显示  生产线
        if self.otherShelfRateItem then
            self.otherShelfView.gameObject:SetActive(false)
        else
        end
        --员工
        if self.staffViewRect then
            self.staffViewRect.gameObject:SetActive(true)
        end
        --仓库
        if self.warehouseRateItem then
            self.warehouseView.gameObject:SetActive(true)
        end
        --货架
        if self.shelfRateItem then
            self.shelfView.gameObject:SetActive(true)
        end
        --生产线
        if self.productionRateItem then
            self.productionView.gameObject:SetActive(true)
        end

        --员工  左2
        local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        self.leftData[2] = self:_createStaff(staffToggleData)

        --仓库Item 左3
        local warehouseToggleData = {pos = BuildingInfoTogglePos.Left, index = 3}   --处于toggleMgr的位置
        self.leftData[3] = self:creatRefreshWarehouse(warehouseToggleData)

        --货架 右1
        local shelfToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}  --处于toggleMgr的位置
        self.rightData[1] = self:creatRefreshShelf(shelfToggleData)

        --生产线 --左4
        local productionToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}
        self.leftData[4] = self:creatRefreshProductionLine(productionToggleData)
    end
end
--创建零售店左右信息
function BuildingInfoToggleGroupMgr:_creatRetailShop()
    --营业额折线图Item  左1
    local lineLeftData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineLeftData)

    ----营业额折线图Item 右1
    --local adLineChartData = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Municipal_LineChart_Path, self.rightRect)
    --adLineChartData.gameObject.name = "AdLineChartItem"
    --local LineChartToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}  --处于toggleMgr的位置
    --local AdLineChartItem = AdLineChartItem:new(nil, self._clickItemFunc, adLineChartData, self.mainPanelLuaBehaviour, LineChartToggleData, self)
    --self.rightData[1] = AdLineChartItem

    if self.toggleData.isOther then
        --其他人进入
        --
        ----货架 左2
        --local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        --self.leftData[2] = self:creatRefreshShelf(shelfToggleData)
        --购买货架
        local otherShelfToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        self.rightData[1] = self:creatOtherPlayerShelf(otherShelfToggleData)
    else
        --员工  左2
        local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        self.leftData[2] = self:_createStaff(staffToggleData)

        --仓库 左3
        local warehouseToggleData = {pos = BuildingInfoTogglePos.Left, index = 3}   --处于toggleMgr的位置
        self.leftData[3] = self:creatRefreshWarehouse(warehouseToggleData)

        --货架 左4
        --local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
        --self.leftData[4] = self:creatRefreshShelf(shelfToggleData)

        --货架 左4
        local shelfToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        self.rightData[1] = self:creatOtherPlayerShelf(shelfToggleData)
        ---广告展示--右1
        --local advertisementViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.Municipal_Advertisement_Path, self.rightRect)
        --advertisementViewRect.gameObject.name = "Advertisement"
        --local ToggleData = { pos = BuildingInfoTogglePos.Right, index = 2}
        --local AdvertisementShowItem = AdvertisementShowItem:new(nil, self._clickItemFunc, advertisementViewRect, self.mainPanelLuaBehaviour, ToggleData, self)
        --self.rightData[2] = AdvertisementShowItem
    end
end
--创建市镇设施左右信息
function BuildingInfoToggleGroupMgr:_creatMunicipalInfo()
    --分为左侧和右侧的item，如果是左边，creatItemObj返回的第二个参数是currentLeftPos，否则为currentRightPos
    --如果是第一个，则必须为打开状态，creatItemObj方法传的最后一个参数为TOTAL_H，否则为TOP_H

    ---折线图  左1
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)


    if not self.staffViewRect then
        ---门票 --左3
        local ticketView
        ticketView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Municipal_Ticket_Path, self.leftRect)
        ticketView.gameObject.name = "TicketItem"
        local ticketToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
        local TicketItem = TicketItem:new(nil, self._clickItemFunc, ticketView, self.mainPanelLuaBehaviour, ticketToggleData, self)
        self.leftData[3] = TicketItem

        ---广告展示--右1
        local advertisementViewRect
        advertisementViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.Municipal_Advertisement_Path, self.rightRect)
        advertisementViewRect.gameObject.name="Advertisement"
        local ToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        local AdvertisementShowItem =AdvertisementShowItem:new(nil, self._clickItemFunc, advertisementViewRect, self.mainPanelLuaBehaviour, ToggleData, self)
        self.rightData[1] = AdvertisementShowItem

        ---个人公园信息--中1
        local ParkInfoRect
        ParkInfoRect=self:_creatItemObj(BuildingInfoToggleGroupMgr.Municipal_ParkInfo_Path,self.toggleData.middleRootTran )
        ParkInfoRect.gameObject.name="ParkInfo"
        local newData={func=self._middleItem}
        local ParkInfoData={pos=BuildingInfoTogglePos.Middle,index=1}
        local ParkInfoItem=ParkInfoItem:new(newData,self._clickItemFunc,ParkInfoRect,self.mainPanelLuaBehaviour,ParkInfoData,self)
        self.middleData[1]=ParkInfoItem
        ParkInfoItem:closeToggleItem(BuildingInfoToggleGroupMgr.static.MIDDLE_POS)

    end
    ---员工  左2
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    self.leftData[2] = self:_createStaff(staffToggleData)
end
---研究所
function BuildingInfoToggleGroupMgr:_creatResearchLineInfo()
    ---员工  左1
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}
    self.leftData[1] = self:_createStaff(staffToggleData)
    -----仓库  左2
    --if self.warehouseLuaItem == nil then
    --    local warehouseView
    --    warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
    --    warehouseView.gameObject.name = "WarehouseRateItem"
    --    local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    --    self.warehouseLuaItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
    --    self.leftData[2] = self.warehouseLuaItem
    --end

    local warehouseToggleData = {pos = BuildingInfoTogglePos.Left, index = 2}   --处于toggleMgr的位置
    self.leftData[2] = self:creatRefreshWarehouse(warehouseToggleData)

    ---研究线 --右1
    local researchLineToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
    self.rightData[1] = self:_creatResearchLine(researchLineToggleData)
end
--人才中心
function BuildingInfoToggleGroupMgr:_creatTalentInfo()
   -- 员工  左1
   -- local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}
   -- self.leftData[1] = self:_createStaff(staffToggleData)

    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)
    --人才管理  左2
    local management = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.TalentManagementItem_Path, self.leftRect)
    management.gameObject.name = "TalentManagement"
    local managementToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    local managementLuaItem = ManagementItem:new(nil, self._clickItemFunc, management, self.mainPanelLuaBehaviour, managementToggleData, self)
    self.leftData[2] = managementLuaItem

    --挖掘人才
    local excavate
    excavate = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.ExcavateTalentsItem_Path, self.rightRect)
    excavate.gameObject.name = "ExcavateTalents"
    local excavateToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}  --处于toggleMgr的位置
    local excavateLuaItem = ExcavateItem:new(nil, self._clickItemFunc, excavate, self.mainPanelLuaBehaviour, excavateToggleData, self)
    self.rightData[1] = excavateLuaItem
end

---通用部分
--折线图
function BuildingInfoToggleGroupMgr:_createLineChart(lineToggleData)
    if not self.lineViewRect then
        if lineToggleData.pos == BuildingInfoTogglePos.Left then
            self.lineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH, self.leftRect)
        else
            self.lineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_lINECHART_PATH, self.rightRect)
        end
        self.lineViewRect.gameObject.name = "LineChart"
    end

    local lineLuaItem = LineChartRateItem:new(nil, self._clickItemFunc, self.lineViewRect, self.mainPanelLuaBehaviour, lineToggleData, self)
    return lineLuaItem
end
--员工
function BuildingInfoToggleGroupMgr:_createStaff(staffToggleData)
    if not self.staffViewRect then
        if staffToggleData.pos == BuildingInfoTogglePos.Left then
            self.staffViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Staff_PATH, self.leftRect)
        --else
            --self.staffViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Staff_PATH, self.rightRect)  --如果出现在右侧，则需要加载其他预制
        end
        self.staffViewRect.gameObject.name = "Staff"
    end

    local staffData = {}
    if not self.toggleData.info then  --匹配未和服务器联调的建筑
        staffData.buildingId = 1
        staffData.buildingTypeId = 1
        staffData.satisfaction = 30
        staffData.dayWage = 10
        staffData.totalStaffCount = 20
        staffData.noDomicileCount = 0
        staffData.isOther = self.toggleData.isOther  --判断是自己还是别人打开了界面
        local staffLuaItem = StaffRateItem:new(staffData, self._clickItemFunc, self.staffViewRect, self.mainPanelLuaBehaviour, staffToggleData, self)
        return staffLuaItem
    else
        if self.toggleData.isOther then
            staffData.isOther = true
        else
            staffData.isOther = false
        end
        staffData.buildingId = self.toggleData.info.id
        staffData.buildingTypeId = self.toggleData.info.mId
        staffData.satisfaction = self.toggleData.info.happy
        staffData.dayWage = self.toggleData.info.salary / 100 * PlayerBuildingBaseData[staffData.buildingTypeId].salary
        staffData.totalStaffCount = PlayerBuildingBaseData[staffData.buildingTypeId].maxWorkerNum
        staffData.noDomicileCount = 0
        staffData.isOther = self.toggleData.isOther  --判断是自己还是别人打开了界面
        staffData.buildingState = self.toggleData.info.state  --判断是否是开业状态
        local staffLuaItem = StaffRateItem:new(staffData, self._clickItemFunc, self.staffViewRect, self.mainPanelLuaBehaviour, staffToggleData, self)
        return staffLuaItem
    end
end
--品牌品质
function BuildingInfoToggleGroupMgr:_createBrand(detailData)
    if self.brandItem ~= nil then
        local data = {}
        data.brand = detailData.brand or 100
        data.qty = detailData.qty or 100
        self.brandItem:updateInfo(data)
    else
        if self.brandItemViewRect == nil then
            if self.topBrandRect == nil then
                return
            end
            self.brandItemViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.BuildingBrand_Path, self.topBrandRect)
            self.brandItemViewRect.gameObject.name = "BuildingBrand"
        end

        local data = {}
        data.brand = detailData.brand or 100
        data.qty = detailData.qty or 100
        self.brandItem = BuildingBrandItem:new(data, self.brandItemViewRect)
    end
    return self.brandItem
end

---住宅部分
--入住率
function BuildingInfoToggleGroupMgr:_creatOccupancy(occToggleData)
    if self.occupancyLuaItem ~= nil then
        local occData = {}
        occData.qty = self.toggleData.qty
        occData.buildingId = self.toggleData.info.id
        occData.buildingTypeId = self.toggleData.info.mId
        occData.totalCount = PlayerBuildingBaseData[occData.buildingTypeId].npc
        occData.renter = self.toggleData.renter
        occData.isOther = self.toggleData.isOther
        occData.rent = self.toggleData.rent
        self.occupancyLuaItem:updateInfo(occData)
    else

    end

    if not self.occupancyViewRect then
        if occToggleData.pos == BuildingInfoTogglePos.Left then
            --self.occupancyViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_OCC_PATH, self.leftRect)
        else
            self.occupancyViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_OCC_PATH, self.rightRect)
        end
        self.occupancyViewRect.gameObject.name = "Occ"
    end

    local occData = {}
    occData.qty = self.toggleData.qty
    occData.buildingId = self.toggleData.info.id
    occData.buildingTypeId = self.toggleData.info.mId
    occData.totalCount = PlayerBuildingBaseData[occData.buildingTypeId].npc
    occData.renter = self.toggleData.renter
    occData.isOther = self.toggleData.isOther

    occData.rent = self.toggleData.rent
    --occData.effectiveDate = os.date("%Y/%m/%d %H:%M", os.time() + 86400)

    self.occupancyLuaItem = OccupancyRateItem:new(occData, self._clickItemFunc, self.occupancyViewRect, self.mainPanelLuaBehaviour, occToggleData, self)
    return self.occupancyLuaItem
end
--租金
function BuildingInfoToggleGroupMgr:_creatRental(rentalToggleData)
    if not self.rentalViewRect then
        if rentalToggleData.pos == BuildingInfoTogglePos.Left then
            self.rentalViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_RENTAL_PATH, self.leftRect)
        else
            self.rentalViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.HOUSE_RENTAL_PATH, self.rightRect)
        end
        self.rentalViewRect.gameObject.name = "Rental"
    end

    local rentalData = {}
    rentalData.buildingId = self.toggleData.info.id
    rentalData.buildingTypeId = self.toggleData.info.mId
    rentalData.rent = self.toggleData.rent
    rentalData.suggestRent = self.toggleData.rent
    --rentalData.effectiveDate = "2018/09/21/08:00:00"  --有效时间有待修改，为第二天的8点，需要读配置
    local endStr = os.date("%Y/%m/%d %H:%M", os.time() + 86400)
    rentalData.effectiveDate = endStr

    rentalData.isOther = self.toggleData.isOther  --
    local rentalLuaItem = RentalItem:new(rentalData, self._clickItemFunc, self.rentalViewRect, self.mainPanelLuaBehaviour, rentalToggleData, self)
    return rentalLuaItem
end
---研究所部分
--研究线
function BuildingInfoToggleGroupMgr:_creatResearchLine(researchLineToggleData)
    --如果已经存在则直接刷新数据，否则重新生成
    if self.labLineItem then
        local data = {}
        --data.insId = self.toggleData.insId
        --data.buildingTypeId = self.toggleData.mId
        data.lines = self.toggleData.orderLineData
        data.isOther = self.toggleData.isOther
        self.labLineItem:updateInfo(data)
    else
        if not self.researchLineViewRect then
            self.researchLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Laboratory_Path, self.rightRect)
            self.researchLineViewRect.gameObject.name = "ResearchLine"
        end

        local data = {}
        data.isOther = self.toggleData.isOther
        data.insId = self.toggleData.insId
        data.buildingTypeId = self.toggleData.mId
        data.lines = self.toggleData.orderLineData
        self.labLineItem = LabBuildingLineItem:new(data, self.researchLineViewRect, self.mainPanelLuaBehaviour, researchLineToggleData, self)
    end
    return self.labLineItem
end
--建筑自带仓库
function BuildingInfoToggleGroupMgr:creatRefreshWarehouse(warehouseToggleData)
    --如果已经存在则直接刷新数据，否则重新生成
    if self.warehouseRateItem then
        self.warehouseRateItem:updateInfo(self.toggleData)
    else
        if not self.warehouseView then
            self.warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
            self.warehouseView.gameObject.name = "WarehouseRateItem"
        end
        self.warehouseRateItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, self.warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
    end
    return self.warehouseRateItem
end
--建筑自带货架
function BuildingInfoToggleGroupMgr:creatRefreshShelf(shelfToggleData)
    --如果已经存在则直接刷新数据，否则重新生成
    if self.shelfRateItem then
        self.shelfRateItem:updateInfo(self.toggleData)
    else
        if not self.shelfView then
            self.shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH, self.rightRect)
            self.shelfView.gameObject.name = "ShelfRateItem"
        end
        self.shelfRateItem = ShelfRateItem:new(self.toggleData, self._clickItemFunc, self.shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
    end
    return self.shelfRateItem
end
--生产线
function BuildingInfoToggleGroupMgr:creatRefreshProductionLine(productionToggleData)
    --如果已经存在则直接刷新数据，否则重新生成
    if self.productionRateItem then
        self.productionRateItem:updateInfo(self.toggleData)
    else
        if not self.productionView then
            self.productionView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE, self.leftRect)
            self.productionView.gameObject.name = "ProductionLineItem";
        end
        self.productionRateItem = HomeProductionLineItem:new(self.toggleData, self._clickItemFunc, self.productionView, self.mainPanelLuaBehaviour, productionToggleData, self)
    end
    return self.productionRateItem
end
--其他玩家购买货架
function BuildingInfoToggleGroupMgr:creatOtherPlayerShelf(otherShelfToggleData)
    if self.otherShelfRateItem then
        self.otherShelfRateItem:updateInfo(self.toggleData)
    else
        if not self.otherShelfView then
            self.otherShelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_OTHER, self.rightRect)
            self.otherShelfView.gameObject.name = "HomeOtherPlayerShelfItem"
        end
        self.otherShelfRateItem = HomeOtherPlayerShelfItem:new(self.toggleData, self._clickItemFunc, self.otherShelfView, self.mainPanelLuaBehaviour, otherShelfToggleData, self)
    end
    return self.otherShelfRateItem
end