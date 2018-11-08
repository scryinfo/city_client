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

    self.infoBtn=prefab--信息按钮
    self.textnum = self.prefab.transform:Find("Text"):GetComponent("Text");  --文本
    self.deleteBtn=self.prefab.transform:Find("close");--删除按钮

    self.textnum.text=id

    self._luabehaviour:AddClick(self.deleteBtn.gameObject, self.OnClicl_XBtn, self);
    self._luabehaviour:AddClick(self.infoBtn,self.OnClick_detailsBtn,self);

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


