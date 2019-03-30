---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:25
---
-----
local transform
HousePanel = {}
local this = HousePanel

function HousePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function HousePanel.InitPanel()
    this.groupTrans = transform:Find("bottomRoot")
    this.topRootTran = transform:Find("topRoot")
    this.topItem = BuildingTopItem:new(transform:Find("topRoot/BuildingTopItem"))
    this.stopIconBtn = transform:Find("topRoot/openBtn")

    --this.centerBtn = transform:Find("centerBtn")
    --this.stopRootTran = transform:Find("stopRoot")
    --
    --this.stopText01 = transform:Find("stopRoot/Text"):GetComponent("Text")
end