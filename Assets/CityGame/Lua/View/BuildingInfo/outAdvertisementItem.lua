---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/12/012 16:39
---


require('Framework/UI/UIPage')
local class = require 'Framework/class'

outAdvertisementItem = class('outAdvertisementItem')

---初始化方法   数据（读配置表）
function outAdvertisementItem:initialize(prefabData,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.ItemList=mgr.outAdvertisementItemList



end
---删除
function outAdvertisementItem:OnClicl_XBtn(go)
    go.manager:_deleteGoods(go)
end







































