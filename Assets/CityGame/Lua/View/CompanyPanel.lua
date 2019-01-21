---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/1/15 16:40
---

CompanyPanel = {}
local this = CompanyPanel

local transform
local gameObject

function CompanyPanel.Awake(obj)
    gameObject = obj
    transform = obj.transform

    this.InitPanel()
end

function CompanyPanel.InitPanel()
    this.backBtn = transform:Find("TopRoot/BackBtn").gameObject
    this.titleText = transform:Find("TopRoot/TitleText"):GetComponent("Text")

    -- 基础信息显示
    this.headImage = transform:Find("BottomRoot/BasicInfoRoot/HeadBg/HeadImage"):GetComponent("Image")
    this.companyText = transform:Find("BottomRoot/BasicInfoRoot/CompanyImage/CompanyText"):GetComponent("Text")
    this.nameText = transform:Find("BottomRoot/BasicInfoRoot/NameImage/NameText"):GetComponent("Text")
    this.incomeText = transform:Find("BottomRoot/BasicInfoRoot/IncomeImage/IncomeText"):GetComponent("Text")
    this.expenditureText = transform:Find("BottomRoot/BasicInfoRoot/IncomeImage/ExpenditureText"):GetComponent("Text")
    this.coinBg = transform:Find("BottomRoot/BasicInfoRoot/CoinBg").gameObject
    this.coinText = transform:Find("BottomRoot/BasicInfoRoot/CoinBg/CoinText"):GetComponent("Text")
    this.foundingTimeText = transform:Find("BottomRoot/BasicInfoRoot/FoundingTimeText"):GetComponent("Text")

    -- 交易记录
    this.businessRecordsScroll = transform:Find("BottomRoot/BusinessRecordsRoot/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect")
    this.tipsText = transform:Find("BottomRoot/BusinessRecordsRoot/TipsText").gameObject
end