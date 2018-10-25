--管理货架物品信息
require 'View/BuildingInfo/ShelfGoodsItem'  --货架Item
require 'View/BuildingInfo/WarehouseItem'  --仓库Item

ShelfGoodsMgr = class('ShelfGoodsMgr')

--存放选中的物品   临时表
--ShelfGoodsMgr.temporaryModeList = {}
ShelfGoodsMgr.temporaryItems = {}

ShelfGoodsMgr.static.Staff_PATH = "View/GoodsItem/ShelfGoodsItem"  --货架预制
ShelfGoodsMgr.static.Warehouse_PATH = "View/GoodsItem/WarehouseItem"   --仓库预制

function ShelfGoodsMgr:initialize(insluabehaviour,buildingData)
    self.behaviour = insluabehaviour
    if buildingData.buildingType == BuildingInType.Shelf then
        self:_creatStaffItemGoods();
    elseif buildingData.buildingType ==BuildingInType.Warehouse then
        self:_creatWarehouseItemGoods();
    end
end

--仓库创建物品
function ShelfGoodsMgr:_creatWarehouseItemGoods()
    --测试数据
    self.WarehouseModelData = {}
    --配置表数据模拟
    local configTable = {}
    for i = 1, 5 do
        local warehouseDataInfo = {}
        warehouseDataInfo.name = "Wood"--..tostring(i)
        warehouseDataInfo.number = math.random(i*5)
        configTable[i] = warehouseDataInfo

        --预制的信息
        local prefabData = {}
        prefabData.state = 'idel'
        prefabData.uiData = configTable[i]
        prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.Warehouse_PATH,WarehousePanel.Content)
        self.WarehouseModelData[i] = prefabData

        local warehouseLuaItem = WarehouseItem:new(self.WarehouseModelData[i].uiData,prefabData._prefab,self.behaviour,self,i)
        if not self.WarehouseItems then
            self.WarehouseItems = {}
        end
        self.WarehouseItems[i] = warehouseLuaItem
    end
end

--货架创建物品
function ShelfGoodsMgr:_creatStaffItemGoods()
    --测试数据
    self.ModelDataList={}
    --配置表数据模拟
    local configTable = {}
    for i = 1, 15 do
        local shelfDataInfo = {}
        shelfDataInfo.name = "Wood"..tostring(i)
        shelfDataInfo.number = math.random(i*5)
        shelfDataInfo.money = "E"..math.random(i*1000)..".0000"
        configTable[i] = shelfDataInfo

        --预制的信息
        local prefabData={}
        prefabData.state = 'idel'
        prefabData.uiData = configTable[i]
        prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.Staff_PATH,ShelfPanel.Content)
        self.ModelDataList[i] = prefabData

        local shelfLuaItem = ShelfGoodsItem:new(self.ModelDataList[i].uiData, prefabData._prefab, self.behaviour, self, i)
        if not self.items then
            self.items = {}
        end
        self.items[i] = shelfLuaItem
        --self.items  存的是Lua实例
        for k,v in pairs(self.items) do
            if k % 5 == 0 then
                shelfLuaItem.shelfImg:SetActive(true);
            else
                shelfLuaItem.shelfImg:SetActive(false);
            end
        end
    end
end
--货架删除物品
function ShelfGoodsMgr:_deleteGoods(ins)
    log("fisher_week9_ShelfGoodsItem","[ShelfGoodsMgr:_deleteGoods]",ins.id);
    --清空之前的旧数据
    destroy(self.items[ins.id].prefab.gameObject);
    table.remove(self.ModelDataList, ins.id)
    table.remove(self.items, ins.id)
    local i = 1
    for k,v in pairs(self.items)  do
        self.items[i]:RefreshID(i)
        i = i + 1
    end
end

--仓库物品选中
function ShelfGoodsMgr:_selectedGoods(ins)

    if self.temporaryItems[ins.id]  == nil then
        ins.circleTickImg:SetActive(true);
        --table.insert(self.temporaryItems,self.WarehouseItems[ins.id])
        self.temporaryItems[ins.id] = ins.id
        --table.insert(self.temporaryItems, ins.id)
        --table.remove(self.WarehouseItems[ins.id])
    else
        ins.circleTickImg:SetActive(false);
        --table.insert(self.WarehouseItems,self.temporaryItems[ins.id])
        self.temporaryItems[ins.id] = nil;
        --local i = 1
        --for k,v in pairs(self.WarehouseItems) do
        --    self.WarehouseItems[i]:RefreshID(i)
        --    i = i +1
        --end
    end
end

--仓库删除物品
function ShelfGoodsMgr:_WarehousedeleteGoods(ins)
    --清空之前的旧数据
    destroy(self.WarehouseItems[ins.id].prefab.gameObject);
    table.remove(self.WarehouseModelData,ins.id);
    table.remove(self.WarehouseItems,ins.id);
    local i = 1
    for k,v in pairs(self.WarehouseItems) do
        self.WarehouseItems[i]:RefreshID(i)
        i = i + 1
    end
end
--生成预制
function ShelfGoodsMgr:_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return go
end