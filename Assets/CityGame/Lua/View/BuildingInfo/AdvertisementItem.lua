---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/26/026 15:08
---


require('Framework/UI/UIPage')
local class = require 'Framework/class'

AdvertisementItem = class('AdvertisementItem')

---初始化方法   数据（读配置表）
function AdvertisementItem:initialize(prefabData,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.ItemList=mgr.AdvertisementItemList
    if prefabData.metaId then
        self.metaId=prefabData.metaId
    end


    self.countText=prefab.transform:Find("bg/numImage/Text"):GetComponent("Text");
    self.nameText=prefab.transform:Find("nameImage/Text"):GetComponent("Text");
    self.icon=prefab.transform:Find("icon"):GetComponent("Image");
    self.ownerIma=prefab.transform:Find("bg/head/owner")

    if prefabData.count then
        self.countText.text=prefabData.count;
    end


end
---删除
function AdvertisementItem:OnClicl_XBtn(go)
    go.manager:_deleteGoods(go)
end


function AdvertisementItem:OnClick_detailsBtn(go)
    local m_data={}
    m_data.id=go.id
    ct.OpenCtrl("AdvertisementPopCtrl",m_data)
end



