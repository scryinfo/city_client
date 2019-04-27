---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/16 10:50
---
local transform
LaboratoryPanel = {}
local this = LaboratoryPanel

function LaboratoryPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function LaboratoryPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot")
    this.leftRootTran = transform:Find("leftRoot")
    this.topRootTran = transform:Find("topRoot")

    this.centerBtn = transform:Find("centerBtn")
    this.stopRootTran = transform:Find("stopRoot")
    this.stopIconBtn = transform:Find("stopRoot/stopIconBtn")

    this.mainGroup = transform:Find("MainGroup")
    this.groupTrans = transform:Find("MainGroup")
    this.topItem = BuildingUpperItem:new(transform:Find("topRoot/BuildingUpperItem"))
    this.openBusinessItem=OpenBusinessBtnItem:new(transform:Find("topRoot/OpenBusinessItem"))
end