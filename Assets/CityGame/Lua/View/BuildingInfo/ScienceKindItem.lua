---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/22/022 10:43
---

require('Framework/UI/UIPage')
local class = require 'Framework/class'

ScienceKindItem = class('ScienceKindItem')

---初始化方法   数据（读配置表）
function ScienceKindItem:initialize(prefabData,prefab,inluabehaviour,mgr, itemid)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.itemid = itemid
    self.ItemList=mgr.materialItemList

    self.iconImage=prefab.transform:Find("leftRoot/iconframe/icon"):GetComponent("Image");
    self.nameText=prefab.transform:Find("leftRoot/nameText"):GetComponent("Text");
    self.kindText=prefab.transform:Find("leftRoot/kindText"):GetComponent("Text");
    self.classText=prefab.transform:Find("middleRoot/classText"):GetComponent("Text");
    self.ownerText=prefab.transform:Find("middleRoot/ownerText"):GetComponent("Text");
    self.leveltext=prefab.transform:Find("middleRoot/leveltext"):GetComponent("Text");
    self.myleveltext=prefab.transform:Find("rightRoot/levelText"):GetComponent("Text");
    self.ScoreText=prefab.transform:Find("rightRoot/ScoreText"):GetComponent("Text");

    self.infoBtn=prefab.transform:Find("leftRoot/infoBtn")
    self.buyBtn=prefab.transform:Find("rightRoot/buyBg/Button")

    self:InitData()

    self:AddClick()
end

---detail
function ScienceKindItem:OnClick_detailsBtn(ins)

end

---buy
function ScienceKindItem:OnClick_buyBtn(ins)
    ct.OpenCtrl("ScienceTradeCtrl",ins)
end

function ScienceKindItem:InitData()
    self.nameText.text=self.prefabData.name
    self.ScoreText.text=self.itemid
end

function ScienceKindItem:AddClick()
    self._luabehaviour:AddClick(self.infoBtn.gameObject,self.OnClick_detailsBtn,self)
    self._luabehaviour:AddClick(self.buyBtn.gameObject,self.OnClick_buyBtn,self)
end




