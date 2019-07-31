---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/7/29 15:19
---
itemGoodsBtn = class('itemGoodsBtn')

function itemGoodsBtn:initialize(data,prefab,luaBehaviour,keyId)
    self.data = data
    self.keyId = keyId
    self.prefab = prefab

    self.bgBtn = prefab.transform:Find("bgBtn")
    self.iconImg = prefab.transform:Find("info/icon/iconImg"):GetComponent("Image")
    self.nameText = prefab.transform:Find("info/nameText"):GetComponent("Text")
    self.brandNameText = prefab.transform:Find("brandName/brandNameText"):GetComponent("Text")
    self.todaySalesText = prefab.transform:Find("todaySales/todaySalesText"):GetComponent("Text")
    self.proportionText = prefab.transform:Find("proportion/proportionText"):GetComponent("Text")

    luaBehaviour:AddClick(self.bgBtn.gameObject,self._clickBgBtn,self)
    self:InitializeData()
end

function itemGoodsBtn:InitializeData()
    self.iconImg.sprite = SpriteManager.GetSpriteByPool(self.data.itemId)
    self.nameText.text = GetLanguage(self.data.itemId)
    self.brandNameText.text = self.data.brandName
    self.todaySalesText.text = "+E"..GetClientPriceString(self.data.saleAccount)
    self.proportionText.text = self.data.increasePercent * 100 .."%"
end

function itemGoodsBtn:_clickBgBtn(ins)
    Event.Brocast("calculateLinePanel",ins.keyId)
end