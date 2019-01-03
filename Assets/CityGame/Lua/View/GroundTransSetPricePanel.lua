---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 14:47
---
local transform
GroundTransSetPricePanel = {}
local this = GroundTransSetPricePanel

function GroundTransSetPricePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function GroundTransSetPricePanel.InitPanel()
    this.bgBtn = transform:Find("bgBtn")
    this.titleText = transform:Find("root/titleText"):GetComponent("Text")
    this.backBtn = transform:Find("root/backBtn")
    this.sellRoot = transform:Find("root/sellRoot")
    this.sellInput = transform:Find("root/sellRoot/sellInput"):GetComponent("InputField")
    this.sellChangeStateTran = transform:Find("root/sellRoot/stateBtnRoot/changeState")
    this.sellIssueBtnTran = transform:Find("root/sellRoot/stateBtnRoot/issueBtn")
    this.sellCancelBtnTran = transform:Find("root/sellRoot/stateBtnRoot/changeState/cancelBtn")
    this.sellChangeBtnTran = transform:Find("root/sellRoot/stateBtnRoot/changeState/changeBtn")

    this.rentRoot = transform:Find("root/rentRoot")
    this.rentChangeStateTran = transform:Find("root/rentRoot/stateBtnRoot/changeState")
    this.rentIssueBtnTran = transform:Find("root/rentRoot/stateBtnRoot/issueBtn")
    this.rentCancelBtnTran = transform:Find("root/rentRoot/stateBtnRoot/changeState/cancelBtn")
    this.rentChangeBtnTran = transform:Find("root/rentRoot/stateBtnRoot/changeState/changeBtn")
    this.minRentDayInput = transform:Find("root/rentRoot/minRentDayInput"):GetComponent("InputField")
    this.maxRentDayInput = transform:Find("root/rentRoot/maxRentDayInput"):GetComponent("InputField")
    this.rentalInput = transform:Find("root/rentRoot/rentalInput"):GetComponent("InputField")
end

function GroundTransSetPricePanel.cleanData()
    this.minRentDayInput.text = ""
    this.maxRentDayInput.text = ""
    this.rentalInput.text = ""
end