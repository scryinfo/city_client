--管理物品信息
require 'View/BuildingInfo/ShelfGoodsItem'  --货架Item
require 'View/BuildingInfo/WarehouseItem'  --仓库Item
require 'View/BuildingInfo/DetailsItem'  --仓库shelf Item
require 'View/BuildingInfo/ProductionItem'  --选择添加生产线Item
require 'View/BuildingInfo/SmallProductionLineItem'  --生产线 Item

GoodsUnifyMgr = class('GoodsUnifyMgr')

local itemsId
GoodsUnifyMgr.static.Staff_PATH = "View/GoodsItem/ShelfGoodsItem"  --货架预制
GoodsUnifyMgr.static.Warehouse_PATH = "View/GoodsItem/WarehouseItem"   --仓库预制
GoodsUnifyMgr.static.Warehouse_Shelf_PATH = "View/GoodsItem/DetailsItem"  --仓库shelf Item
GoodsUnifyMgr.static.Warehouse_Transport_PATH = "View/GoodsItem/TransportItem"  --仓库transport Item
GoodsUnifyMgr.static.Shelf_BuyGoods_PATH = "View/GoodsItem/BuyDetailsItem"  --货架购买物品 Item
GoodsUnifyMgr.static.AddProductionLine_PATH = "View/GoodsItem/ProductionItem"  --选择添加生产线 Item
GoodsUnifyMgr.static.SmallProductionLineItem_PATH = "View/GoodsItem/SmallProductionLineItem"  --生产线 Item

function GoodsUnifyMgr:initialize(insluabehaviour, buildingData)
    self.behaviour = insluabehaviour
    if buildingData.type == BuildingInType.Shelf and buildingData.buildingType == BuildingType.MaterialFactory then
        self:_creatStaffItemGoods(buildingData);
    elseif buildingData.type == BuildingInType.Shelf and buildingData.buildingType == BuildingType.ProcessingFactory then
        self:_creatStaffItemGoods(buildingData);
    elseif buildingData.type == BuildingInType.Warehouse and buildingData.buildingType == BuildingType.MaterialFactory then
        self:_creatWarehouseItemGoods(buildingData);
    elseif buildingData.type == BuildingInType.Warehouse and buildingData.buildingType == BuildingType.ProcessingFactory then
        self:_creatWarehouseItemGoods(buildingData);
    elseif buildingData.buildingType == BuildingInType.ProductionLine then
        self:_creatProductionItem();
    end
end
--仓库
function GoodsUnifyMgr:_creatWarehouseItemGoods(buildingData)
    if not buildingData.store.inHand then
        return;
    end
    self.WarehouseModelData = {}
    local configTable = {}
    for i,v in pairs(buildingData.store.inHand) do
        local uiTab = {}
        uiTab.name = Material[v.key.id].name
        uiTab.num = v.n
        uiTab.itemId = v.key.id
        configTable[i] = uiTab

        local prefabData = {}
        prefabData.uiData = configTable[i]
        prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.Warehouse_PATH,WarehousePanel.Content)
        self.WarehouseModelData[i] = prefabData

        local warehouseLuaItem = WarehouseItem:new(self.WarehouseModelData[i].uiData,prefabData._prefab,self.behaviour,self,i)
        if not self.WarehouseItems then
            self.WarehouseItems = {}
        end
        self.WarehouseItems[i] = warehouseLuaItem
    end
end
--货架
function GoodsUnifyMgr:_creatStaffItemGoods(buildingData)
    if not buildingData.shelf.good then
        return;
    end
    self.state = buildingData.isOther
    self.ModelDataList={}
    local configTable = {}
    for i,v in pairs(buildingData.shelf.good) do
        local shelfDataInfo = {}
        shelfDataInfo.name = Material[v.k.id].name
        shelfDataInfo.number = v.n
        shelfDataInfo.money = getPriceString("E"..v.price..".0000",35,25)
        shelfDataInfo.price = v.price
        shelfDataInfo.itemId = v.k.id
        configTable[i] = shelfDataInfo

        local prefabData={}
        prefabData.uiData = configTable[i]
        prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.Staff_PATH,ShelfPanel.Content)
        self.ModelDataList[i] = prefabData

        local shelfLuaItem = ShelfGoodsItem:new(self.ModelDataList[i].uiData, prefabData._prefab, self.behaviour, self, i,self.state,buildingData.info.id)
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
function GoodsUnifyMgr:_creatProductionItem()
    local configTable = {}
    for i,v in pairs(Material) do
        --原料类型分类
        local key = 2101
        if math.floor(i / 1000) == key then
            local productionItemInfo = {}
            productionItemInfo.itemId = Material[i].itemId
            productionItemInfo.name = Material[i].name
            configTable[i] = productionItemInfo

            local prefabData = {}
            prefabData.uiData = configTable[i]
            prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.AddProductionLine_PATH,AddProductionLinePanel.content)
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
function GoodsUnifyMgr:_creatProductionLine(name,itemId)
    local configTable = {};
    configTable.name = name
    configTable.itemId = itemId;
    itemsId = itemId;
    AdjustProductionLineCtrl.materialProductionUIInfo[itemId] = configTable

    local prefabData = {}
    prefabData.uiData = AdjustProductionLineCtrl.materialProductionUIInfo[itemId]
    prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
    AdjustProductionLineCtrl.materialProductionPrefab[itemId] = prefabData

    local productionLineItem = SmallProductionLineItem:new(AdjustProductionLineCtrl.materialProductionPrefab[itemId].uiData,prefabData._prefab,self.behaviour,self);
    AdjustProductionLineCtrl.materialProductionLine[itemId] = productionLineItem
end
--读取服务器发过来的信息，是否有生产线
function GoodsUnifyMgr:_getProductionLine(table,behaviour)
    if not table.line then
        return;
    end
    local configTable = {}
    for i,v in pairs(table.line) do
        local uiTab = {}
        if table.buildingType == BuildingType.MaterialFactory then
            uiTab.name = Material[v.itemId].name
        elseif table.buildingType == BuildingType.ProcessingFactory then
            uiTab.name = Material[v.itemId].name
        end
        uiTab.itemId = v.itemId
        uiTab.nowCount = v.nowCount
        uiTab.targetCount = v.targetCount
        uiTab.workerNum = v.workerNum
        uiTab.lineId = v.id
        configTable[i] = uiTab
        AdjustProductionLineCtrl.materialProductionUIInfo[i] = configTable

        local prefabData = {}
        prefabData.uiData = AdjustProductionLineCtrl.materialProductionUIInfo[i]
        prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
        AdjustProductionLineCtrl.materialProductionPrefab[i] = prefabData

        local productionLineItem = SmallProductionLineItem:new(AdjustProductionLineCtrl.materialProductionPrefab[i].uiData,prefabData._prefab,behaviour,self,i,table.info.id);
        AdjustProductionLineCtrl.materialProductionLine[i] = productionLineItem
    end
end
--获取发送的物品信息
function GoodsUnifyMgr:getSendInfo()
    if itemsId == nil then
        return;
    end
    GoodsUnifyMgr.sendInfoTempTab = {}
    GoodsUnifyMgr.sendInfoTempTab[itemsId] = AdjustProductionLineCtrl.materialProductionLine[itemsId]
    local number = GoodsUnifyMgr.sendInfoTempTab[itemsId].inputNumber.text;
    local steffNumber = GoodsUnifyMgr.sendInfoTempTab[itemsId].staffNumberText.text;
    if number == nil then
        return;
    end
    if steffNumber == nil then
        return;
    end
    return number,steffNumber,itemsId;
end
--仓库选中物品上架
function GoodsUnifyMgr:_creatShelfGoods(id,luabehaviour,itemId)
    --预制的信息
    local prefabData = {}
    prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.Warehouse_Shelf_PATH,WarehousePanel.shelfContent)
    local shelfLuaItem = DetailsItem:new(self.WarehouseModelData[id].uiData,prefabData._prefab,luabehaviour,self,id,itemId)

    if not self.shelfPanelItem then
        self.shelfPanelItem = {}
    end
    self.shelfPanelItem[id] = shelfLuaItem
end
--仓库右侧删除上架
function GoodsUnifyMgr:_deleteShelfItem(id)
    destroy(self.shelfPanelItem[id].prefab.gameObject);
    self.shelfPanelItem[id] = nil;
    WarehouseCtrl.temporaryItems[id] = nil;
end
--仓库选中物品运输
function GoodsUnifyMgr:_creatTransportGoods(id,luabehaviour,itemId)
    local prefabData = {}
    prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.Warehouse_Transport_PATH,WarehousePanel.transportContent);
    local transportLuaItem = TransportItem:new(self.WarehouseModelData[id].uiData,prefabData._prefab,luabehaviour,self,id,itemId);

    if not self.transportPanelItem then
        self.transportPanelItem = {}
    end
    self.transportPanelItem[id] = transportLuaItem
end
--仓库右侧删除运输
function GoodsUnifyMgr:_deleteTransportItem(id)
    destroy(self.transportPanelItem[id].prefab.gameObject);
    self.transportPanelItem[id] = nil;
    WarehouseCtrl.temporaryItems[id] = nil;
end
--货架购买暂用这个(后边修改物品上架，运输，购买)
function GoodsUnifyMgr:_buyShelfGoods(id,luabehaviour,itemId)
    local shelfGoodsData = {}
    shelfGoodsData._prefab = self:_creatGoods(GoodsUnifyMgr.static.Shelf_BuyGoods_PATH,ShelfPanel.buyContent);
    local buyGoodsItem = BuyDetailsItem:new(self.items[id].goodsDataInfo,shelfGoodsData._prefab,luabehaviour,self,id,itemId);

    if not self.shelfBuyGoodslItems then
        self.shelfBuyGoodslItems = {}
    end
    self.shelfBuyGoodslItems[id] = buyGoodsItem
end
--货架右侧删除购买
function GoodsUnifyMgr:_deleteBuyGoods(id)
    destroy(self.shelfBuyGoodslItems[id].prefab.gameObject);
    self.shelfBuyGoodslItems[id] = nil;
    ShelfCtrl.temporaryItems[id] = nil;
end
--货架删除
function GoodsUnifyMgr:_deleteGoods(ins)
    ct.log("fisher_week9_ShelfGoodsItem","[GoodsUnifyMgr:_deleteGoods]",ins.id);
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
function GoodsUnifyMgr:_deleteProductionLine(ins)
    destroy(AdjustProductionLineCtrl.materialProductionLine[ins.id].prefab.gameObject);
    table.remove(AdjustProductionLineCtrl.materialProductionPrefab,ins.id)
    table.remove(AdjustProductionLineCtrl.materialProductionLine,ins.id)
    local i = 1
    for k,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        AdjustProductionLineCtrl.materialProductionLine[i]:RefreshID(i)
        i = i +1
    end
end
--仓库删除
function GoodsUnifyMgr:_WarehousedeleteGoods(id)
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
function GoodsUnifyMgr:_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return go
end