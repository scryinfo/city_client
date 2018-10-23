--管理货架物品信息
require 'View/BuildingInfo/ShelfGoodsItem'  --货架Item
require 'View/BuildingInfo/WarehouseItem'  --仓库Item

ShelfGoodsMgr = class('ShelfGoodsMgr')

ShelfGoodsMgr.static.Staff_PATH = "View/GoodsItem/ShelfGoodsItem"  --货架预制
ShelfGoodsMgr.static.Warehouse_PATH = "View/GoodsItem/WarehouseItem"   --仓库预制

function ShelfGoodsMgr:initialize(insluabehaviour,buildingData)
    self.behaviour = insluabehaviour
    if buildingData.buildingType == BuildingInType.Shelf then
        self:_creatStaffItemGoods();
    elseif buildingData.buildingType ==BuildingInType.Warehouse then
        log("这是仓库的!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
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

--删除物品
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
--生成预制
function ShelfGoodsMgr:_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return go
end