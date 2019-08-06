---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/18 10:36
---
OfflineNotificationBuildingpageItem = class("OfflineNotificationBuildingpageItem")

function OfflineNotificationBuildingpageItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform

    LoadSprite(PlayerBuildingBaseData[data.mId].imgPath, transform:Find("BuildingIconImage"):GetComponent("Image"), false)
    transform:Find("NameText"):GetComponent("Text").text = data.buildingName
    transform:Find("CoordinateText"):GetComponent("Text").text = string.format("(%d,%d)", data.pos.x, data.pos.y)
    transform:Find("IncomeText"):GetComponent("Text").text = string.format("E%s", GetClientPriceString(data.income))
end