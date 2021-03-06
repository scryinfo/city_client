---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:25
---
-----
local transform
FlightRecordPanel = {}
local this = FlightRecordPanel

function FlightRecordPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function FlightRecordPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn")
    this.leftBtn = transform:Find("leftBtn")
    this.rightBtn = transform:Find("rightBtn")
    this.noneTip = transform:Find("noneTip")

    this.pageItem = transform:Find("pageRoot/FlightRecordPageItem")
    this.scrollPage = transform:Find("pageRoot/scroll"):GetComponent("ScrollPageOptimize")

    this.titleText01 = transform:Find("topRoot/Text"):GetComponent("Text")
    this.noneTipText02 = transform:Find("noneTip/Text"):GetComponent("Text")
end