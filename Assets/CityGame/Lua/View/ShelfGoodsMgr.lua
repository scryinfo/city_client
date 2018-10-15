--管理货架物品信息
require 'View/BuildingInfo/ShelfGoodsItem'

local class = require 'Framework/class'
ShelfGoodsMgr = class('ShelfGoodsMgr')
local goodsNum;

--创建物品
function ShelfGoodsMgr:_creatGoods(path,parent,goodsDataInfo)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    --ShelfGoodsMgr:goodsKey(table)
end
--[[function ShelfGoodsMgr:goodsKey(table)
    local goodsTable = {};
    goodsNum = 0;
    if table == nil then
        return;
    end
    for x,xx in pairs(table) do
        goodsNum = goodsNum + 1;
        goodsTable[x] = xx;
    end0
end]]
--删除物品
function ShelfGoodsMgr._deleteGoods()
    destroy(ShelfIcon);
end