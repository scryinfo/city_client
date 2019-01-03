---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/27 16:11
---
local transform
GroundTransSelfCheckInfoPanel = {}
local this = GroundTransSelfCheckInfoPanel

function GroundTransSelfCheckInfoPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function GroundTransSelfCheckInfoPanel.InitPanel()
    this.bgBtn = transform:Find("bgBtn")
    this.backBtn = transform:Find("root/backBtn")

    this.rentalText = transform:Find("root/rentRoot/rentalText"):GetComponent("Text")
    this.tenancyText = transform:Find("root/rentRoot/tenancyText"):GetComponent("Text")
    this.remainDayText = transform:Find("root/rentRoot/remainDayText"):GetComponent("Text")
end