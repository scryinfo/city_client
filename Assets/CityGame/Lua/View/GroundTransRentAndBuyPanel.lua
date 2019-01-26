---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 15:49
---
local transform
GroundTransRentAndBuyPanel = {}
local this = GroundTransRentAndBuyPanel

function GroundTransRentAndBuyPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function GroundTransRentAndBuyPanel.InitPanel()
    this.bgBtn = transform:Find("bgBtn")
    this.backBtn = transform:Find("root/backBtn")
    this.nameText = transform:Find("root/nameBg/nameText"):GetComponent("Text")
    this.ownerBtn = transform:Find("root/ownerBtn")
    this.portraitImg = transform:Find("root/ownerBtn/portraitImg"):GetComponent("Image")

    this.sellRoot = transform:Find("root/sellRoot")
    this.buyBtn = transform:Find("root/sellRoot/buyBtn")
    this.sellPriceText = transform:Find("root/sellRoot/sellPriceText"):GetComponent("Text")

    this.rentRoot = transform:Find("root/rentRoot")
    --this.tenancyText = transform:Find("root/rentRoot/tenancyImg/tenancyText"):GetComponent("Text")
    this.tenancySlider = transform:Find("root/rentRoot/tenancySlider"):GetComponent("Slider")
    this.tenancyInput = transform:Find("root/rentRoot/rentDayInput"):GetComponent("InputField")
    this.rentBtn = transform:Find("root/rentRoot/rentBtn")
    this.dayRentalText = transform:Find("root/rentRoot/rentalText"):GetComponent("Text")
    this.totalRentalText = transform:Find("root/rentRoot/totalRentalText"):GetComponent("Text")
    --
    this.titleText01 = transform:Find("root/titleText"):GetComponent("Text")
    this.sellBtnText07 = transform:Find("root/sellRoot/buyBtn/Text"):GetComponent("Text")
    this.rentBtnText08 = transform:Find("root/rentRoot/rentBtn/Text"):GetComponent("Text")
    this.sellPriceText02 = transform:Find("root/sellRoot/Text"):GetComponent("Text")
    this.tenancyText03 = transform:Find("root/rentRoot/Text01"):GetComponent("Text")
    this.rentalText04 = transform:Find("root/rentRoot/Text02"):GetComponent("Text")
    this.totalPriceText05 = transform:Find("root/rentRoot/Text03"):GetComponent("Text")
    this.rentBtnText06 = transform:Find("root/rentRoot/Text03"):GetComponent("Text")
end