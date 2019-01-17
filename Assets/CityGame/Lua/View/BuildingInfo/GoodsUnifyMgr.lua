--管理物品信息
require 'View/BuildingInfo/ShelfGoodsItem'  --货架Item
require 'View/BuildingInfo/WarehouseItem'  --仓库Item
require 'View/BuildingInfo/DetailsItem'  --仓库shelf Item
require 'View/BuildingInfo/ProductionItem'  --选择添加生产线Item
require 'View/BuildingInfo/SmallProductionLineItem'  --生产线 Item

GoodsUnifyMgr = class('GoodsUnifyMgr')

local LinePrefab = nil
GoodsUnifyMgr.static.Shelf_PATH = "View/GoodsItem/ShelfGoodsItem"  --货架预制
GoodsUnifyMgr.static.RetailGoods_PATH = "View/GoodsItem/RetailGoodsItem"  --仓库商品预制
GoodsUnifyMgr.static.Warehouse_PATH = "View/GoodsItem/WarehouseItem"   --仓库预制
GoodsUnifyMgr.static.Warehouse_Shelf_PATH = "View/GoodsItem/DetailsItem"  --仓库shelf Item
GoodsUnifyMgr.static.Warehouse_Transport_PATH = "View/GoodsItem/TransportItem"  --仓库transport Item
GoodsUnifyMgr.static.Shelf_BuyGoods_PATH = "View/GoodsItem/BuyDetailsItem"  --货架购买物品 Item
GoodsUnifyMgr.static.AddProductionLine_PATH = "View/GoodsItem/ProductionItem"  --选择添加生产线 Item
GoodsUnifyMgr.static.SmallProductionLineItem_PATH = "View/GoodsItem/SmallProductionLineItem"  --生产线 Item


function GoodsUnifyMgr:initialize(insluabehaviour, buildingData)
    self.behaviour = insluabehaviour
    if buildingData.type == BuildingInType.Warehouse then
        self:_creatWarehouseItemGoods(buildingData.inHand,buildingData.buildingId)
    elseif buildingData.type == BuildingInType.Shelf then
        self:_creatStaffItemGoods(buildingData.good,buildingData.isOther,buildingData.buildingId)
    elseif buildingData.type == BuildingInType.ProductionLine then
        local buildingId = buildingData.buildingId
        buildingData.type = nil
        buildingData.buildingId = nil
        self:_getProductionLine(buildingData,buildingId)
    elseif buildingData.type == BuildingInType.RetailShelf then
        self:_creatretailShelfGoods(buildingData.good,buildingData.isOther,buildingData.buildingId)
    end
end
--仓库
function GoodsUnifyMgr:_creatWarehouseItemGoods(storeData,buildingId)
    if not storeData then
        return;
    end
    self.warehouseLuaTab = {}
    for i,v in pairs(storeData) do
        local prefab = self:_creatGoods(GoodsUnifyMgr.static.Warehouse_PATH,WarehousePanel.Content)
        local warehouseLuaItem = WarehouseItem:new(v,prefab,self.behaviour,self,i,buildingId)
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
function GoodsUnifyMgr:_creatretailShelfGoods(shelfData,goodState,buildingId)
    if not shelfData then
        return;
    end
    for i,v in pairs(shelfData) do
        local prefab = self:_creatGoods(GoodsUnifyMgr.static.RetailGoods_PATH,RetailShelfPanel.content)
        local retailGoodsItem = RetailGoodsItem:new(v,prefab,self.behaviour,self,i,goodState,buildingId)
        if not self.retailShelfs then
            self.retailShelfs = {}
        end
        self.retailShelfs[i] = retailGoodsItem
    end
    for k,v in pairs(self.retailShelfs) do
        if k % 5 == 0 then
            v.shelfImg:SetActive(true);
        else
            v.shelfImg:SetActive(false);
        end
    end
end
--添加生产线
function GoodsUnifyMgr:_creatProductionLine(luabehaviour,itemId,buildingId)
    local infoData = {}
    infoData.itemId = itemId
    infoData.buildingId = buildingId
    local prefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
    local productionLineItem = SmallProductionLineItem:new(infoData,prefab,luabehaviour,nil,self);
    if not self.tempLineItem then
        self.tempLineItem = {}
    end
    self.tempLineItem[itemId] = productionLineItem
    AdjustProductionLineCtrl.materialProductionLine[#AdjustProductionLineCtrl.materialProductionLine+1] = productionLineItem
end
--读取服务器发过来的信息，是否有生产线
function GoodsUnifyMgr:_getProductionLine(productionLineData,buildingId)
    if not productionLineData then
        return;
    end
    for i,v in pairs(productionLineData) do
        v.buildingId = buildingId
        local prefab = self:_creatGoods(GoodsUnifyMgr.static.SmallProductionLineItem_PATH,AdjustProductionLinePanel.content);
        local productionLineLuaItem = SmallProductionLineItem:new(v,prefab,self.behaviour,i,nil);
        AdjustProductionLineCtrl.materialProductionLine[i] = productionLineLuaItem
    end
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
    local transportLuaItem = TransportItem:new(id.goodsDataInfo,prefabData._prefab,luabehaviour,self,id.id,id.itemId);

    if not GoodsUnifyMgr.transportPanelItem then
        GoodsUnifyMgr.transportPanelItem = {}
    end
    GoodsUnifyMgr.transportPanelItem[id.id] = transportLuaItem
end
--仓库右侧删除运输
function GoodsUnifyMgr:_deleteTransportItem(id)
    destroy(GoodsUnifyMgr.transportPanelItem[id].prefab.gameObject);
    GoodsUnifyMgr.transportPanelItem[id] = nil;
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
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if v.itemId == ins.itemId then
            destroy(v.prefab.gameObject);
            AdjustProductionLineCtrl.materialProductionLine[i] = nil
        end
    end
end
--仓库删除
function GoodsUnifyMgr:_WarehousedeleteGoods(id)
    for i,v in pairs(self.warehouseLuaTab) do
        if i == id then
            v:closeEvent()
            destroy(v.prefab.gameObject);
            table.remove(self.warehouseLuaTab,id);
        end
    end
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