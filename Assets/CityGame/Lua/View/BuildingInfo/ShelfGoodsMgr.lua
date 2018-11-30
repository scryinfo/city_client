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
    if not MaterialModel.MaterialWarehouse then
        return;
    end
    self.WarehouseModelData = {}
    local configTable = {}
    for i,v in pairs(MaterialModel.MaterialWarehouse) do
        local uiTab = {}
        uiTab.name = Material[v.key.id].name
        uiTab.num = v.n
        uiTab.itemId = v.key.id
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
    if not MaterialModel.MaterialShelf then
        return;
    end
    self.ModelDataList={}

    local configTable = {}
    for i,v in pairs(MaterialModel.MaterialShelf) do
        local shelfDataInfo = {}
        shelfDataInfo.name = Material[v.k.id].name
        shelfDataInfo.number = v.n
        --shelfDataInfo.money = "E"..v.price..".0000"
        shelfDataInfo.money = getPriceString("E"..v.price..".0000",35,25)
        shelfDataInfo.price = v.price
        shelfDataInfo.itemId = v.k.id
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
    local configTable = {}
    for i,v in pairs(Material) do
        local key = 2151
        if math.floor(i / 1000) == key then
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

        local productionLineItem = SmallProductionLineItem:new(AdjustProductionLineCtrl.productionLinePrefab[itemId].uiData,prefabData._prefab,self.behaviour,self);
        AdjustProductionLineCtrl.productionLineTab[itemId] = productionLineItem
end
--读取服务器发过来的信息，是否有生产线
function ShelfGoodsMgr:_getProductionLine(table,behaviour)
    if not table then
        return;
    end
    local configTable = {}
    for i,v in pairs(table) do
        local uiTab = {}
        uiTab.name = Material[v.itemId].name
        uiTab.itemId = v.itemId
        uiTab.nowCount = v.nowCount
        uiTab.targetCount = v.targetCount
        uiTab.workerNum = v.workerNum
        uiTab.lineId = v.id
        configTable[i] = uiTab

        AdjustProductionLineCtrl.productionLineUIInfo[i] = configTable

        local prefabData = {}
        prefabData.state = 'idel'
        prefabData.uiData = AdjustProductionLineCtrl.productionLineUIInfo[i]
        prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
        AdjustProductionLineCtrl.productionLinePrefab[i] = prefabData

        local productionLineItem = SmallProductionLineItem:new(AdjustProductionLineCtrl.productionLinePrefab[i].uiData,prefabData._prefab,behaviour,self,i);
        AdjustProductionLineCtrl.productionLineTab[i] = productionLineItem
    end
end
--获取要发送的物品信息
function ShelfGoodsMgr:getSendInfo()
    if itemsId == nil then
        return;
    end
    local number = AdjustProductionLineCtrl.productionLineTab[itemsId].inputNumber.text;
    local steffNumber = AdjustProductionLineCtrl.productionLineTab[itemsId].staffNumberText.text;
    ShelfGoodsMgr.sendInfoTempTab = {}
    ShelfGoodsMgr.sendInfoTempTab[itemsId] = AdjustProductionLineCtrl.productionLineTab[itemsId]
    if number == nil then
        return;
    end
    if steffNumber == nil then
        return;
    end
    return number,steffNumber,itemsId;
end

--仓库选中物品上架
function ShelfGoodsMgr:_creatShelfGoods(id,luabehaviour,itemId)
    --预制的信息
    local prefabData = {}
    prefabData.state = 'idel'
    prefabData._prefab = self:_creatGoods(ShelfGoodsMgr.static.Warehouse_Shelf_PATH,WarehousePanel.shelfContent)
    local shelfLuaItem = DetailsItem:new(self.WarehouseModelData[id].uiData,prefabData._prefab,luabehaviour,self,id,itemId)

    if not self.shelfPanelItem then
        self.shelfPanelItem = {}
    end
    self.shelfPanelItem[id] = shelfLuaItem
end

--仓库右侧删除上架
function ShelfGoodsMgr:_deleteShelfItem(id)
    destroy(self.shelfPanelItem[id].prefab.gameObject);
    self.shelfPanelItem[id] = nil;
    WarehouseCtrl.temporaryItems[id] = nil;
end

--仓库选中物品运输
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

--仓库右侧删除运输
function ShelfGoodsMgr:_deleteTransportItem(id)
    destroy(self.transportPanelItem[id].prefab.gameObject);
    self.transportPanelItem[id] = nil;
    WarehouseCtrl.temporaryItems[id] = nil;
end
--货架删除
function ShelfGoodsMgr:_deleteGoods(ins)
    ct.log("fisher_week9_ShelfGoodsItem","[ShelfGoodsMgr:_deleteGoods]",ins.id);
    destroy(self.items[ins.id].prefab.gameObject);
    table.remove(self.ModelDataList, ins.id)
    table.remove(self.items, ins.id)
    local i = 1
    for k,v in pairs(self.items) do
        self.items[i]:RefreshID(i)
        i = i + 1
    end
end
--删除生产线
function ShelfGoodsMgr:_deleteProductionLine(ins)
    destroy(AdjustProductionLineCtrl.productionLineTab[ins.id].prefab.gameObject);
    table.remove(AdjustProductionLineCtrl.productionLinePrefab,ins.id)
    table.remove(AdjustProductionLineCtrl.productionLineTab,ins.id)
    local i = 1
    for k,v in pairs(AdjustProductionLineCtrl.productionLineTab) do
        AdjustProductionLineCtrl.productionLineTab[i]:RefreshID(i)
        i = i +1
    end
end
--仓库删除
function ShelfGoodsMgr:_WarehousedeleteGoods(id)
    destroy(self.WarehouseItems[id].prefab.gameObject);
    table.remove(self.WarehouseModelData,id);
    table.remove(self.WarehouseItems,id);
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