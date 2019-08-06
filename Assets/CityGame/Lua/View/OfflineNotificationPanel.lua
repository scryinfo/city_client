---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/17 16:51
---

OfflineNotificationPanel = {}
local this = OfflineNotificationPanel

local transform
local gameObject

function OfflineNotificationPanel.Awake(obj)
    gameObject = obj
    transform = obj.transform

    this.InitPanel()
end

function OfflineNotificationPanel.InitPanel()
    this.sureBtn = transform:Find("MiddleRoot/SureBtn").gameObject

    -- 离线界面
    this.offlineNotificationHomepageItem = transform:Find("MiddleRoot/AllListScroll/Viewport/Content/OfflineNotificationHomepageItem").gameObject
    this.allListScroll = transform:Find("MiddleRoot/AllListScroll/Viewport/Content")
    this.detailsScroll = transform:Find("MiddleRoot/DetailsScroll"):GetComponent("ActiveLoopScrollRect")
    this.allListTransform = transform:Find("MiddleRoot/AllListScroll")
    this.detailsTransform = transform:Find("MiddleRoot/DetailsScroll")
    this.scrollBg = transform:Find("MiddleRoot/ScrollBg")

    -- 建筑详情
    this.buildingInfoTitleBg = transform:Find("MiddleRoot/BuildingInfoTitleBg")
    this.incomeTitleTextTF = transform:Find("MiddleRoot/IncomeTitleText")
    this.incomeTitleText = transform:Find("MiddleRoot/IncomeTitleText"):GetComponent("Text")
    this.incomeText = transform:Find("MiddleRoot/IncomeTitleText/IncomeText"):GetComponent("Text")
    this.buildingReturnBtn = transform:Find("MiddleRoot/BuildingInfoTitleBg/ReturnBtn").gameObject

    -- 幸运值详情
    this.luckyValueTitleBg = transform:Find("MiddleRoot/LuckyValueTitleBg")
    this.luckyTitleTextTF = transform:Find("MiddleRoot/LuckyTitleText")
    this.luckyText = transform:Find("MiddleRoot/LuckyTitleText/LuckyText"):GetComponent("Text")
    this.luckyReturnBtn = transform:Find("MiddleRoot/LuckyValueTitleBg/ReturnBtn").gameObject
end