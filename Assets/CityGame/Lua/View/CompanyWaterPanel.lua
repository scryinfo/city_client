---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/20 15:05
---公司流水
CompanyWaterPanel = {}
local this = CompanyWaterPanel

local transform
local gameObject

function CompanyWaterPanel.Awake(obj)
    gameObject = obj
    transform = obj.transform

    this.InitPanel()
end

function CompanyWaterPanel.InitPanel()
    this.backBtn = transform:Find("TopRoot/BackBtn").gameObject
    this.titleText = transform:Find("TopRoot/TitleText"):GetComponent("Text")
    this.incomeBg = transform:Find("TopRoot/incomeBg").gameObject
    this.income = transform:Find("TopRoot/incomeBg/income"):GetComponent("Text")
    this.open = transform:Find("TopRoot/incomeBg/line/open")
    this.close = transform:Find("TopRoot/incomeBg/line/close")
    this.expendBg = transform:Find("TopRoot/expendBg").gameObject
    this.expend = transform:Find("TopRoot/expendBg/expend"):GetComponent("Text")
    this.buildingContent = transform:Find("TopRoot/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.off = transform:Find("TopRoot/off")
    --滑动互用
    this.scroll = transform:Find("TopRoot/content/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect")
    this.empty = transform:Find("TopRoot/content/empty")
    this.emptyText = transform:Find("TopRoot/content/empty/Image/Text"):GetComponent("Text")
end