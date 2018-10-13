--管理货架物品信息
require 'View/BuildingInfo/ShelfIcon'

local class = require 'Framework/class'
ShelfGoodsMgr = class('ShelfGoodsMgr')
local GoodsInfo = {};

--创建物品
function ShelfGoodsMgr:_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
end
--删除物品
function ShelfGoodsMgr._deleteGoods()
    destroy(ShelfIcon);
end