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
BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE = "View/BuildingMainPageInfoItem/HomeProductionLineItem" --生产线
BuildingInfoToggleGroupMgr.static.Material_SHELF_OTHER = "View/BuildingMainPageInfoItem/HomeOtherPlayerShelfItem"  --其他玩家 货架

BuildingInfoToggleGroupMgr.static.Staff_PATH = "View/BuildingMainPageInfoItem/StaffRateItem"  --建筑员工

BuildingInfoToggleGroupMgr.static.Municipal_Advertisement_Path="View/BuildingMainPageInfoItem/AdvertisementShowItem"--广告展示
BuildingInfoToggleGroupMgr.static.Municipal_ParkInfo_Path="View/BuildingMainPageInfoItem/ParkInfoItem"--公园信息
BuildingInfoToggleGroupMgr.static.Municipal_Ticket_Path="View/BuildingMainPageInfoItem/TicketItem"--门票信息
BuildingInfoToggleGroupMgr.static.Laboratory_Path="View/BuildingMainPageInfoItem/LabBuildingInfoResearchItem"  --研究线

BuildingInfoToggleGroupMgr.static.TalentManagementItem_Path = "View/TalentCenterItem/TalentManagementItem"  --人才管理
BuildingInfoToggleGroupMgr.static.ExcavateTalentsItem_Path = "View/TalentCenterItem/TalentManagementItem"  --挖掘人才


--初始化
function BuildingInfoToggleGroupMgr:initialize(leftRect, rightRect, mainPanelLuaBehaviour, buildingData)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    self.leftRect = leftRect
    self.rightRect = rightRect
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
    elseif buildingData.buildingType == BuildingType.TalentCenter then
        self:_creatTalentInfo()
    end

    --创建完之后调整item位置
    self:_sortItems(1)
    self:_sortRightItems()
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
    end
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
end

--每次打开一个Item，都要刷新位置
function BuildingInfoToggleGroupMgr:_clickItemFunc(toggleData)
    local leftIndex, rightIndex = nil
    if toggleData.pos == BuildingInfoTogglePos.Left then
        leftIndex = toggleData.index
    elseif toggleData.pos == BuildingInfoTogglePos.Right then
        rightIndex = toggleData.index
    end

    self:_sortItems(leftIndex, rightIndex)
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
            if toggleItem:getToggleIndex() == leftOpenIndex then
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

    for i, item in pairs(self.middleData) do
        if(item:getToggleIndex()==toggleData.index)then

            if item==temp then
                if num%2==1 then
                    item:openToggleItem()
                    num=num+1
                else
                    item:closeToggleItem()
                    num=num+1
                end
            else
                num=1
                item:openToggleItem()
                num=num+1
                temp=item
            end
        end
    end
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

    ---租金 --右2
    local rentalToggleData = { pos = BuildingInfoTogglePos.Right, index = 2}
    self.rightData[2] = self:_creatRental(rentalToggleData)
end

--创建原料厂主页左右信息
function BuildingInfoToggleGroupMgr:_creatMaterialInfo()
    ---营业额折线图Item --左边第一个
    ---折线图  左1
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)

    if self.toggleData.isOther then
        --其他玩家进入
        -----员工  左2
        --local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        --self.leftData[2] = self:_createStaff(staffToggleData)

        -----仓库Item --左边第三个
        --local warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
        --warehouseView.gameObject.name = "WarehouseRateItem"
        --local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
        --local warehouseLuaItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
        --self.leftData[3] = warehouseLuaItem

        ----生产线 --左边第四个
        --local shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTION_OTHER, self.leftRect)
        --shelfView.gameObject.name = "HomeOtherPlayerLineItem"
        --local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
        --local shelfLuaItem = HomeOtherPlayerLineItem:new(self.toggleData, self._clickItemFunc, shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
        --self.leftData[4] = shelfLuaItem

        --货架 --右边第一个
        local prodictionLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_OTHER, self.rightRect)
        prodictionLineViewRect.gameObject.name = "HomeOtherPlayerShelfItem";
        local prodictionToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        local prodictionLuaItem = HomeOtherPlayerShelfItem:new(self.toggleData, self._clickItemFunc, prodictionLineViewRect, self.mainPanelLuaBehaviour, prodictionToggleData, self)
        self.rightData[1] = prodictionLuaItem


    else
        -----员工  左2
        local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        self.leftData[2] = self:_createStaff(staffToggleData)

        -----仓库Item --左边第三个
        local warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
        warehouseView.gameObject.name = "WarehouseRateItem"
        local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
        local warehouseLuaItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
        self.leftData[3] = warehouseLuaItem

        ---货架 --左边第四个
        local shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH, self.leftRect)
        shelfView.gameObject.name = "ShelfRateItem"
        local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
        local shelfLuaItem = ShelfRateItem:new(self.toggleData, self._clickItemFunc, shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
        self.leftData[4] = shelfLuaItem

        ---生长线 --右侧第一个
        local prodictionLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE, self.rightRect)
        prodictionLineViewRect.gameObject.name = "HomeProductionLineItem";
        local prodictionToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        local prodictionLuaItem = HomeProductionLineItem:new(self.toggleData, self._clickItemFunc, prodictionLineViewRect, self.mainPanelLuaBehaviour, prodictionToggleData, self)
        self.rightData[1] = prodictionLuaItem
    end

end
--创建加工厂主页左右信息
function BuildingInfoToggleGroupMgr:_creatProcessingInfo()
    --分为左侧和右侧的item，如果是左边，creatItemObj返回的第二个参数是currentLeftPos，否则为currentRightPos
    --如果是第一个，则必须为打开状态，creatItemObj方法传的最后一个参数为TOTAL_H，否则为TOP_H

    -----营业额折线图Item --左边第一个
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)

    if self.toggleData.isOther then
        --其他玩家进入
        -----员工  左2
        --local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        --self.leftData[2] = self:_createStaff(staffToggleData)
        --
        -----仓库Item --左边第三个
        --local warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
        --warehouseView.gameObject.name = "WarehouseRateItem"
        --local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
        --local warehouseLuaItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
        --self.leftData[3] = warehouseLuaItem
        --
        ----生产线 --左边第四个
        --local shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTION_OTHER, self.leftRect)
        --shelfView.gameObject.name = "HomeOtherPlayerLineItem"
        --local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
        --local shelfLuaItem = HomeOtherPlayerLineItem:new(self.toggleData, self._clickItemFunc, shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
        --self.leftData[4] = shelfLuaItem

        --货架 --右边第一个
        local prodictionLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_OTHER, self.rightRect)
        prodictionLineViewRect.gameObject.name = "HomeOtherPlayerShelfItem";
        local prodictionToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        local prodictionLuaItem = HomeOtherPlayerShelfItem:new(self.toggleData, self._clickItemFunc, prodictionLineViewRect, self.mainPanelLuaBehaviour, prodictionToggleData, self)
        self.rightData[1] = prodictionLuaItem
    else
        -----员工  左2
        local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        self.leftData[2] = self:_createStaff(staffToggleData)

        -----仓库Item --左边第三个
        local warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
        warehouseView.gameObject.name = "WarehouseRateItem"
        local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 3}  --处于toggleMgr的位置
        local warehouseLuaItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
        self.leftData[3] = warehouseLuaItem

        ---货架 --左边第四个
        local shelfView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_SHELF_PATH, self.leftRect)
        shelfView.gameObject.name = "ShelfRateItem"
        local shelfToggleData = { pos = BuildingInfoTogglePos.Left, index = 4}  --处于toggleMgr的位置
        local shelfLuaItem = ShelfRateItem:new(self.toggleData, self._clickItemFunc, shelfView, self.mainPanelLuaBehaviour, shelfToggleData, self)
        self.leftData[4] = shelfLuaItem

        ---生产线 --右侧第一个
        local prodictionLineViewRect = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_PRODUCTIONLINE, self.rightRect)
        prodictionLineViewRect.gameObject.name = "HomeProductionLineItem";
        local prodictionToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
        local prodictionLuaItem = HomeProductionLineItem:new(self.toggleData, self._clickItemFunc, prodictionLineViewRect, self.mainPanelLuaBehaviour, prodictionToggleData, self)
        self.rightData[1] = prodictionLuaItem
    end

end
--创建市镇设施左右信息
function BuildingInfoToggleGroupMgr:_creatMunicipalInfo()
    --分为左侧和右侧的item，如果是左边，creatItemObj返回的第二个参数是currentLeftPos，否则为currentRightPos
    --如果是第一个，则必须为打开状态，creatItemObj方法传的最后一个参数为TOTAL_H，否则为TOP_H

    ---折线图  左1
    local lineToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}  --处于toggleMgr的位置
    self.leftData[1] = self:_createLineChart(lineToggleData)



    if  not self.staffViewRect then
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
        --AdvertisementShowItem:openToggleItem(BuildingInfoToggleGroupMgr.static.RIGHT_POS)
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
    ---仓库  左2
    if self.warehouseLuaItem == nil then
        local warehouseView
        warehouseView = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.Material_WAREHOUSE_PATH, self.leftRect)
        warehouseView.gameObject.name = "WarehouseRateItem"
        local warehouseToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
        self.warehouseLuaItem = WarehouseRateItem:new(self.toggleData, self._clickItemFunc, warehouseView, self.mainPanelLuaBehaviour, warehouseToggleData, self)
        self.leftData[2] = self.warehouseLuaItem
    end
    ---研究线 --右1
    local researchLineToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}
    self.rightData[1] = self:_creatResearchLine(researchLineToggleData)
end
--人才中心
function BuildingInfoToggleGroupMgr:_creatTalentInfo()
    --员工  左1
    local staffToggleData = { pos = BuildingInfoTogglePos.Left, index = 1}
    self.leftData[1] = self:_createStaff(staffToggleData)
    --人才管理  左2
    local management
    management = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.TalentManagementItem_Path, self.leftRect)
    management.gameObject.name = "TalentManagement"
    local managementToggleData = { pos = BuildingInfoTogglePos.Left, index = 2}  --处于toggleMgr的位置
    local managementLuaItem = WarehouseRateItem:new(nil, self._clickItemFunc, management, self.mainPanelLuaBehaviour, managementToggleData, self)
    self.leftData[2] = managementLuaItem
    --挖掘人才
    local excavate
    excavate = self:_creatItemObj(BuildingInfoToggleGroupMgr.static.TalentManagementItem_Path, self.rightRect)
    excavate.gameObject.name = "ExcavateTalents"
    local excavateToggleData = { pos = BuildingInfoTogglePos.Right, index = 1}  --处于toggleMgr的位置
    local excavateLuaItem = WarehouseRateItem:new(nil, self._clickItemFunc, excavate, self.mainPanelLuaBehaviour, excavateToggleData, self)
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
        staffData.dayWage = self.toggleData.info.salary
        staffData.totalStaffCount = PlayerBuildingBaseData[staffData.buildingTypeId].maxWorkerNum
        staffData.noDomicileCount = 0
        staffData.isOther = self.toggleData.isOther  --判断是自己还是别人打开了界面
        local staffLuaItem = StaffRateItem:new(staffData, self._clickItemFunc, self.staffViewRect, self.mainPanelLuaBehaviour, staffToggleData, self)
        return staffLuaItem
    end
end

---住宅部分
--入住率
function BuildingInfoToggleGroupMgr:_creatOccupancy(occToggleData)
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
    occData.isOther = self.toggleData.isOther  --
    local occupancyLuaItem = OccupancyRateItem:new(occData, self._clickItemFunc, self.occupancyViewRect, self.mainPanelLuaBehaviour, occToggleData, self)
    return occupancyLuaItem
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
    rentalData.effectiveDate = "2018/09/21/08:00:00"  --有效时间有待修改，为第二天的8点，需要读配置
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
