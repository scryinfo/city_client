---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 15:34
---

local transform
ResearchPanel = {}

local this = ResearchPanel

function ResearchPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function ResearchPanel.InitPanel()
    this.backBtn = transform:Find("BackBtn").gameObject
    this.sureBtn = transform:Find("MiddleRoot/SureBtn").gameObject

    this.iconImage = transform:Find("MiddleRoot/IconImage"):GetComponent("Image")
    this.nameText = transform:Find("MiddleRoot/NameText"):GetComponent("Text")
    this.contentText = transform:Find("MiddleRoot/ContentText"):GetComponent("Text")
    this.speedTitleText = transform:Find("MiddleRoot/SpeedTitleText"):GetComponent("Text")
    this.speedText = transform:Find("MiddleRoot/SpeedTitleText/SpeedText"):GetComponent("Text")
    this.timeText = transform:Find("MiddleRoot/TimeText"):GetComponent("Text")
    this.timeTitleText = transform:Find("MiddleRoot/TimeTitleText"):GetComponent("Text")
    this.inputField = transform:Find("MiddleRoot/InputField"):GetComponent("InputField")
    this.TitleText = transform:Find("MiddleRoot/TitleText"):GetComponent("Text")
    this.quantityText = transform:Find("MiddleRoot/QuantityText"):GetComponent("Text")
end