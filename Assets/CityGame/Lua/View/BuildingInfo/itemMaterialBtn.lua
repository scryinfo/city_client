---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/7/24 16:04
---建筑经营详情Item（三个字段属性显示）
itemMaterialBtn = class('itemMaterialBtn')

local ToNumber = tonumber
local StringSub = string.sub
function itemMaterialBtn:initialize(data,prefab,luaBehaviour,keyId)
    self.data = data
    self.keyId = keyId
    self.prefab = prefab

    self.bgBtn = prefab.transform:Find("bgBtn")
    self.iconImg = prefab.transform:Find("info/icon/iconImg"):GetComponent("Image")
    self.nameText = prefab.transform:Find("info/nameText"):GetComponent("Text")
    self.todaySalesText = prefab.transform:Find("todaySales/todaySalesText"):GetComponent("Text")
    self.proportionText = prefab.transform:Find("proportion/proportionText"):GetComponent("Text")

    luaBehaviour:AddClick(self.bgBtn.gameObject,self._clickBgBtn,self)
    self:InitializeData()
end

function itemMaterialBtn:InitializeData()
    local path = nil
    if ToNumber(StringSub(self.data.itemId,5,7)) == 11 then
        path = BuildingInformationIcon[1100002].imgPath
        LoadSprite(path,self.iconImg,false)
        self.nameText.text = GetLanguage(PlayerBuildingBaseData[1100002].typeName)
    elseif ToNumber(StringSub(self.data.itemId,5,7)) == 12 then
        path = BuildingInformationIcon[1200002].imgPath
        LoadSprite(path,self.iconImg,false)
        self.nameText.text = GetLanguage(PlayerBuildingBaseData[1200002].typeName)
    elseif ToNumber(StringSub(self.data.itemId,5,7)) == 13 then
        path = BuildingInformationIcon[1300002].imgPath
        LoadSprite(path,self.iconImg,false)
        self.nameText.text = GetLanguage(PlayerBuildingBaseData[1300002].typeName)
    elseif ToNumber(StringSub(self.data.itemId,5,7)) == 14 then
        path = BuildingInformationIcon[1400002].imgPath
        LoadSprite(path,self.iconImg,false)
        self.nameText.text = GetLanguage(PlayerBuildingBaseData[1400002].typeName)
    elseif ToNumber(StringSub(self.data.itemId,5,7)) == 15 then
        path = BuildingInformationIcon[1500002].imgPath
        LoadSprite(path,self.iconImg,false)
        self.nameText.text = GetLanguage(PlayerBuildingBaseData[1500002].typeName)
    elseif ToNumber(StringSub(self.data.itemId,5,7)) == 16 then
        path = BuildingInformationIcon[1600002].imgPath
        LoadSprite(path,self.iconImg,false)
        self.nameText.text = GetLanguage(PlayerBuildingBaseData[1600002].typeName)
    else
        self.iconImg.sprite = SpriteManager.GetSpriteByPool(self.data.itemId)
        self.nameText.text = GetLanguage(self.data.itemId)
    end
    self.todaySalesText.text = "+E"..GetClientPriceString(self.data.saleAccount)
    self.proportionText.text = math.floor(self.data.increasePercent * 100).."%"
end

function itemMaterialBtn:_clickBgBtn(ins)
    Event.Brocast("calculateLinePanel",ins)
end