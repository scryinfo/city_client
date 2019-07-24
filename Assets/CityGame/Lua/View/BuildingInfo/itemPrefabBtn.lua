---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/7/24 16:04
---建筑经营详情Item
itemPrefabBtn = class('itemPrefabBtn')

function itemPrefabBtn:initialize(data,prefab,luaBehaviour,keyId)
    self.data = data
    self.keyId = keyId

    self.bgBtn = prefab.transform:Find("bgBtn")
    self.iconImg = prefab.transform:Find("info/icon/iconImg"):GetComponent("Image")
    self.nameText = prefab.transform:Find("info/nameText"):GetComponent("Text")
    self.brandName = prefab.transform:Find("info/brandName"):GetComponent("Text")
    self.todaySalesText = prefab.transform:Find("todaySales/todaySalesText"):GetComponent("Text")
    self.proportionText = prefab.transform:Find("proportion/proportionText"):GetComponent("Text")

    luaBehaviour:AddClick(self.bgBtn.gameObject,self._clickBgBtn,self)
    self:InitializeData()
end

function itemPrefabBtn:InitializeData()
    self.iconImg.sprite = SpriteManager.GetSpriteByPool(2101001)
    self.nameText.text = self.data.name
    self.brandName.text = ""
    self.todaySalesText.text = self.data.todaySales
    self.proportionText.text = self.data.proportion.."%"
end

function itemPrefabBtn:_clickBgBtn(ins)
    Event.Brocast("calculateLinePanel",ins.keyId)
end