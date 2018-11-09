--管理物品信息
require 'View/BuildingInfo/ShelfGoodsItem'  --货架Item
require 'View/BuildingInfo/WarehouseItem'  --仓库Item
require 'View/BuildingInfo/DetailsItem'  --仓库shelf Item
require 'View/BuildingInfo/ProductionItem'  --选择添加生产线Item
require 'View/BuildingInfo/SmallProductionLineItem'  --生产线 Item

ShelfGoodsMgr = class('ShelfGoodsMgr')

local itemsId
ShelfGoodsMgr.static.Staff_PATH = "View/GoodsItem/ShelfGoodsItem"  --货架预制
ShelfGoodsMgr.static.Warehouse_PATH = "View/GoodsItem/WarehouseItem"   --仓库预制
ShelfGoodsMgr.static.Warehouse_Shelf_PATH = "View/GoodsItem/DetailsItem"  --仓库shelf Item
ShelfGoodsMgr.static.Warehouse_Transport_PATH = "View/GoodsItem/TransportItem"  --仓库transport Item
ShelfGoodsMgr.static.AddProductionLine_PATH = "View/GoodsItem/ProductionItem"  --选择添加生产线 Item
ShelfGoodsMgr.static.SmallProductionLineItem_PATH = "View/GoodsItem/SmallProductionLineItem"  --生产线 Item

function ShelfGoodsMgr:initialize(insluabehaviour, buildingData)
    self.behaviour = insluabehaviour
    if buildingData.buildingType == BuildingInType.Shelf then
        self:_creatStaffItemGoods();
    elseif buildingData.buildingType == BuildingInType.Warehouse then
        self:_creatWarehouseItemGoods();
    elseif buildingData.buildingType == BuildingInType.ProductionLine then
        self:_creatProductionItem();
    end
end

--仓库创建物品
function ShelfGoodsMgr:_creatWarehouseItemGoods()
    --测试数据
    self.WarehouseModelData = {}
    --配置表数据模拟
    local configTable = {}
    for i,v in pairs(PlayerTempModel.storeList[1].inHand) do
        --local warehouseDataInfo = {}
        --warehouseDataInfo.name = Material[i].name
        --warehouseDataInfo.number = math.random(i*5)
        --configTable[i] = warehouseDataInfo

        --uiTab.name = Material[i].name
        --uiTab.num = PlayerTempModel.storeList[1].inHand[i].num
        --uiTab.itemId = PlayerTempModel.storeList[1].inHand[i].id

        local uiTab = {}
        uiTab.name = Material[i].name
        uiTab.num = v.num
        uiTab.itemId = v.id
        configTable[i] = uiTab

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
        ct.log("这是仓库的!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
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

--添加生产线可以生产的原料或商品
function ShelfGoodsMgr:_creatProductionItem()
    --配置表数据
    local configTable = {}
    for i = 1, 5 do
        local productionItemInfo = {}
        productionItemInfo.itemId = Material[i].itemId
        productionItemInfo.name = Material[i].name
        configTable[i] = productionItemInfo

        --预制的信息
        local prefabData = {}
        prefabData.state = 'idel'
        prefabData.uiData = configTable[i]
        prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.AddProductionLine_PATH,AddProductionLinePanel.content)
        AddProductionLineCtrl.productionItemTab[i] = prefabData

        local productionItem = ProductionItem:new(AddProductionLineCtrl.productionItemTab[i].uiData,prefabData._prefab,self.behaviour,self,i)
        if not self.productionItems then
            self.productionItems = {}
        end
        self.productionItems[i] = productionItem
    end
end

--添加生产线
function ShelfGoodsMgr:_creatProductionLine(name,itemId)
    local configTable = {};
    configTable.name = name
    configTable.itemId = itemId;
    itemsId = itemId;
    AdjustProductionLineCtrl.productionLineUIInfo[itemId] = configTable

    local prefabData = {}
    prefabData.state = 'idel'
    prefabData.uiData = AdjustProductionLineCtrl.productionLineUIInfo[itemId]
    prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
    AdjustProductionLineCtrl.productionLinePrefab[itemId] = prefabData

    local productionLineItem = SmallProductionLineItem:new(AdjustProductionLineCtrl.productionLinePrefab[itemId].uiData,prefabData._prefab,self.behaviour,self,itemId);
    AdjustProductionLineCtrl.productionLineTab[itemId] = productionLineItem
end

--Test
function ShelfGoodsMgr:testSend()
    local number = AdjustProductionLineCtrl.productionLineTab[itemsId].inputNumber.text;
    local steffNumber = AdjustProductionLineCtrl.productionLineTab[itemsId].staffNumberText.text;
    return number,steffNumber,itemsId;
end

--仓库选中物品（右侧shelf）
function ShelfGoodsMgr:_creatShelfGoods(id,luabehaviour)
    --预制的信息
    local prefabData = {}
    prefabData.state = 'idel'
    prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.Warehouse_Shelf_PATH,WarehousePanel.shelfContent)
    local shelfLuaItem = DetailsItem:new(self.WarehouseModelData[id].uiData,prefabData._prefab,luabehaviour,self,id)

    if not self.shelfPanelItem then
        self.shelfPanelItem = {}
    end
    self.shelfPanelItem[id] = shelfLuaItem
end

--仓库右侧shelfItem 删除
function ShelfGoodsMgr:_deleteShelfItem(id)
    destroy(self.shelfPanelItem[id].prefab.gameObject);
    self.shelfPanelItem[id] = nil;
    WarehouseCtrl.temporaryItems[id] = nil;
end

--仓库选中物品（右侧transport）
function ShelfGoodsMgr:_creatTransportGoods(id,luabehaviour,itemId)
    --预制的信息
    local prefabData = {}
    prefabData.state = 'idel'
    prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.Warehouse_Transport_PATH,WarehousePanel.transportContent)
    local transportLuaItem = TransportItem:new(self.WarehouseModelData[id].uiData,prefabData._prefab,luabehaviour,self,id,itemId);

    if not self.transportPanelItem then
        self.transportPanelItem = {}
    end
    self.transportPanelItem[id] = transportLuaItem
end

--仓库右侧transportItem 删除
function ShelfGoodsMgr:_deleteTransportItem(id)
    destroy(self.transportPanelItem[id].prefab.gameObject);
    self.transportPanelItem[id] = nil;
    WarehouseCtrl.temporaryItems[id] = nil;
end
--货架删除
function ShelfGoodsMgr:_deleteGoods(ins)
    ct.log("fisher_week9_ShelfGoodsItem","[ShelfGoodsMgr:_deleteGoods]",ins.id);
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
--仓库删除
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