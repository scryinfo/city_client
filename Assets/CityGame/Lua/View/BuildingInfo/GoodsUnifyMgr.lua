--管理物品信息
require 'View/BuildingInfo/ShelfGoodsItem'  --货架Item
require 'View/BuildingInfo/WarehouseItem'  --仓库Item
require 'View/BuildingInfo/DetailsItem'  --仓库shelf Item
require 'View/BuildingInfo/ProductionItem'  --选择添加生产线Item
require 'View/BuildingInfo/SmallProductionLineItem'  --生产线 Item

GoodsUnifyMgr = class('GoodsUnifyMgr')

local itemsId
local LinePrefab = nil
GoodsUnifyMgr.static.Shelf_PATH = "View/GoodsItem/ShelfGoodsItem"  --货架预制
GoodsUnifyMgr.static.RetailGoods_PATH = "View/GoodsItem/RetailGoodsItem"  --零售店货架预制
GoodsUnifyMgr.static.Warehouse_PATH = "View/GoodsItem/WarehouseItem"   --仓库预制
GoodsUnifyMgr.static.Warehouse_Shelf_PATH = "View/GoodsItem/DetailsItem"  --仓库shelf Item
GoodsUnifyMgr.static.Warehouse_Transport_PATH = "View/GoodsItem/TransportItem"  --仓库transport Item
GoodsUnifyMgr.static.Shelf_BuyGoods_PATH = "View/GoodsItem/BuyDetailsItem"  --货架购买物品 Item
GoodsUnifyMgr.static.AddProductionLine_PATH = "View/GoodsItem/ProductionItem"  --选择添加生产线 Item
GoodsUnifyMgr.static.SmallProductionLineItem_PATH = "View/GoodsItem/SmallProductionLineItem"  --生产线 Item


function GoodsUnifyMgr:initialize(insluabehaviour, buildingData)
    self.behaviour = insluabehaviour
    if buildingData.type == BuildingInType.Warehouse then
        self:_creatWarehouseItemGoods(buildingData.inHand)
    elseif buildingData.type == BuildingInType.Shelf then
        self:_creatStaffItemGoods(buildingData.good,buildingData.isOther,buildingData.buildingId)
    elseif buildingData.type == BuildingInType.ProductionLine then
        buildingData.type = nil
        self:_getProductionLine(buildingData)
    end
end
--仓库
function GoodsUnifyMgr:_creatWarehouseItemGoods(storeData)
    if not storeData then
        return;
    end
    for i,v in pairs(storeData) do
        local prefab = self:_creatGoods(GoodsUnifyMgr.static.Warehouse_PATH,WarehousePanel.Content)
        local warehouseLuaItem = WarehouseItem:new(v,prefab,self.behaviour,self,i)
        if not self.warehouseLuaTab then
            self.warehouseLuaTab = {}
        end
        self.warehouseLuaTab[i] = warehouseLuaItem
    end
end
--货架
function GoodsUnifyMgr:_creatStaffItemGoods(shelfData,goodState,buildingId)
    if not shelfData then
        return;
    end
    for i,v in pairs(shelfData) do
        local prefab = self:_creatGoods(GoodsUnifyMgr.static.Shelf_PATH,ShelfPanel.Content)
        local warehouseLuaItem = ShelfGoodsItem:new(v,prefab,self.behaviour,self,i,goodState,buildingId)
        if not self.shelfLuaTab then
            self.shelfLuaTab = {}
        end
        self.shelfLuaTab[i] = warehouseLuaItem
    end
    for k,v in pairs(self.shelfLuaTab) do
        if k % 5 == 0 then
            v.shelfImg:SetActive(true);
        else
            v.shelfImg:SetActive(false);
        end
    end
end
--零售店货架
function GoodsUnifyMgr:_creatretailShelfGoods()
    local configTable = {}
    for i = 1, 11 do
        local goodsDataInfo = {}
        goodsDataInfo.name = "wood"..i
        goodsDataInfo.brandName = "Addypolly"..i
        goodsDataInfo.brandValue = math.random(50,100)
        goodsDataInfo.qualityValue = math.random(50,100)
        goodsDataInfo.price = math.random(1000,10000)
        goodsDataInfo.number = math.random(50,99)
        configTable[i] = goodsDataInfo

        local prefab = {}
        prefab.uiData = configTable[i]
        prefab._prefab = self:_creatGoods(GoodsUnifyMgr.static.RetailGoods_PATH,RetailShelfPanel.content)
        RetailShelfCtrl.retailShelfUIData[i] = prefab

        local retailGoodsItem = RetailGoodsItem:new(RetailShelfCtrl.retailShelfUIData[i].uiData,prefab._prefab,self.behaviour,i)
        RetailShelfCtrl.retailShelfGoods[i] = retailGoodsItem;

        for k,v in pairs(RetailShelfCtrl.retailShelfGoods) do
            if k % 5 == 0 then
                v.shelfImg:SetActive(true);
            else
                v.shelfImg:SetActive(false);
            end
        end
    end
end
----添加生产线可以生产的原料或商品
--function GoodsUnifyMgr:_creatProductionItem()
--    local configTable = {}
--    for i,v in pairs(Material) do
--        --原料类型分类
--        local key = 2101
--        if math.floor(i / 1000) == key then
--            local productionItemInfo = {}
--            productionItemInfo.itemId = Material[i].itemId
--            productionItemInfo.name = Material[i].name
--            configTable[i] = productionItemInfo
--
--            local prefabData = {}
--            prefabData.uiData = configTable[i]
--            --prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.AddProductionLine_PATH,AddProductionLinePanel.content)
--            prefabData._prefab = creatGoods(GoodsUnifyMgr.static.AddProductionLine_PATH,AddProductionLinePanel.content)
--            AddProductionLineCtrl.productionItemTab[i] = prefabData
--
--            local productionItem = ProductionItem:new(AddProductionLineCtrl.productionItemTab[i].uiData,prefabData._prefab,self.behaviour,self,i)
--            if not self.productionItems then
--                self.productionItems = {}
--            end
--            self.productionItems[i] = productionItem
--        end
--    end
--end
--添加生产线
function GoodsUnifyMgr:_creatProductionLine(name,itemId)
    local configTable = {};
    configTable.name = name
    configTable.itemId = itemId;
    itemsId = itemId;
    self.materialProductionUIInfo = {};
    self.materialProductionUIInfo[itemId] = configTable

    local prefabData = {}
    prefabData.uiData = self.materialProductionUIInfo[itemId]
    --prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
    prefabData._prefab = creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
    self.materialProductionPrefab = {};
    self.materialProductionPrefab[itemId] = prefabData

    local productionLineItem = SmallProductionLineItem:new(self.materialProductionPrefab[itemId].uiData,prefabData._prefab,self.behaviour,self);
    self.materialProductionLine = {}
    self.materialProductionLine[itemId] = productionLineItem
end
--添加生产线
function GoodsUnifyMgr:_creatProductionLine(luabehaviour,itemId)
    itemsId = itemId;
    local configTable = {};
    local materialKey,goodsKey = 2101,2251
    if math.floor(itemId / 1000) == materialKey then
        configTable.name = Material[itemId].name
    elseif math.floor(itemId / 1000) == goodsKey then
        configTable.name = Good[itemId].name
    end
    configTable.itemId = itemId;
    GoodsUnifyMgr.tempLineUIInfo = {};
    GoodsUnifyMgr.tempLineUIInfo[itemId] = configTable

    local prefabData = {}
    prefabData.uiData = self.tempLineUIInfo[itemId]
    if LinePrefab == nil then
        LinePrefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
    end
    GoodsUnifyMgr.tempLinePrefab = {};
    GoodsUnifyMgr.tempLinePrefab[itemId] = prefabData

    local productionLineItem = SmallProductionLineItem:new(self.tempLinePrefab[itemId].uiData,LinePrefab,luabehaviour,self);
    GoodsUnifyMgr.tempLineItem = {}
    GoodsUnifyMgr.tempLineItem[itemId] = productionLineItem
end
--读取服务器发过来的信息，是否有生产线
function GoodsUnifyMgr:_getProductionLine(productionLineData)
    if not productionLineData then
        return;
    end
    for i,v in pairs(productionLineData) do
        if i == "type" then
            return;
        end
        local prefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
        local productionLineLuaItem = SmallProductionLineItem:new(v,prefab,self.behaviour,i);
        AdjustProductionLineCtrl.materialProductionLine[i] = productionLineLuaItem
    end
end
--获取发送的物品信息
function GoodsUnifyMgr:getSendInfo()
    if itemsId == nil then
        return;
    end
    GoodsUnifyMgr.sendInfoTempTab = {}
    GoodsUnifyMgr.sendInfoTempTab[itemsId] = GoodsUnifyMgr.tempLineItem[itemsId]
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
function GoodsUnifyMgr:_creatShelfGoods(ins,luabehaviour)
    --预制的信息
    local prefab = self:_creatGoods(GoodsUnifyMgr.static.Warehouse_Shelf_PATH,WarehousePanel.shelfContent)
    local shelfLuaItem = DetailsItem:new(ins.goodsDataInfo,prefab,luabehaviour,self,ins.id)
    if not self.shelfPanelItem then
        self.shelfPanelItem = {}
    end
    self.shelfPanelItem[ins.id] = shelfLuaItem
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
function GoodsUnifyMgr:_buyShelfGoods(ins,luabehaviour)
    local shelfGoodsData = self:_creatGoods(GoodsUnifyMgr.static.Shelf_BuyGoods_PATH,ShelfPanel.buyContent);
    local buyGoodsItem = BuyDetailsItem:new(ins.goodsDataInfo,shelfGoodsData,luabehaviour,ins.id);

    if not self.shelfBuyGoodslItems then
        self.shelfBuyGoodslItems = {}
    end
    self.shelfBuyGoodslItems[ins.id] = buyGoodsItem
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
    destroy(self.shelfLuaTab[ins.id].prefab.gameObject);
    table.remove(self.shelfLuaTab, ins.id)
    local i = 1
    for k,v in pairs(self.shelfLuaTab) do
        self.shelfLuaTab[i]:RefreshID(i)
        i = i + 1
    end
end
--删除刚添加的生产线
function GoodsUnifyMgr:_deleteLine(ins)
    destroy(GoodsUnifyMgr.tempLineItem[ins.itemId].prefab.gameObject);
    table.remove(GoodsUnifyMgr.tempLinePrefab,ins.itemId)
    table.remove(GoodsUnifyMgr.tempLineItem,ins.itemId)
    --local i = 1
    --for k,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
    --    AdjustProductionLineCtrl.materialProductionLine[i]:RefreshID(i)
    --    i = i +1
    --end
end
--仓库删除
function GoodsUnifyMgr:_WarehousedeleteGoods(id)
    destroy(self.warehouseLuaTab[id].prefab.gameObject);
    table.remove(self.warehouseLuaTab,id);
    local i = 1
    for k,v in pairs(self.warehouseLuaTab) do
        self.warehouseLuaTab[i]:RefreshID(i)
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