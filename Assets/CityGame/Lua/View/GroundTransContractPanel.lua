---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/27 20:16
---GroundTransContractPanel
local transform
GroundTransContractPanel = {}
local this = GroundTransContractPanel

function GroundTransContractPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function GroundTransContractPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn")
    this.rentBottomTran = transform:Find("bottomRoot/rent")
    this.rentBtn = transform:Find("bottomRoot/rent/rentBtn")
    this.rentTipText = transform:Find("bottomRoot/rent/tipText"):GetComponent("Text")
    this.buyBottomBtn = transform:Find("bottomRoot/buyBtn")

    this.totalPriceText = transform:Find("centerRoot/total/totalPriceText"):GetComponent("Text")
    this.rentCenterTran = transform:Find("centerRoot/rent")
    this.rentAreaText = transform:Find("centerRoot/rent/areaText"):GetComponent("Text")
    this.rentTenancyText = transform:Find("centerRoot/rent/tenancyText"):GetComponent("Text")
    this.rentTenancyTimeText = transform:Find("centerRoot/rent/tenancyTimeText"):GetComponent("Text")
    this.rentDailyRentText = transform:Find("centerRoot/rent/dailyRentText"):GetComponent("Text")
    this.buyCenterTran = transform:Find("centerRoot/buy")
    this.buyAreaText = transform:Find("centerRoot/buy/areaText"):GetComponent("Text")

    --A
    this.APortraitImg = transform:Find("leftRoot/bg02/portraitImg"):GetComponent("Image")
    this.ANameText = transform:Find("leftRoot/nameText"):GetComponent("Text")
    --B
    this.BPortraitImg = transform:Find("rightRoot/bg02/portraitImg"):GetComponent("Image")
    this.BNameText = transform:Find("rightRoot/nameText"):GetComponent("Text")

    --
    this.titleText01 = transform:Find("topRoot/Text"):GetComponent("Text")
    this.AText02 = transform:Find("leftRoot/Text"):GetComponent("Text")
    this.BText03 = transform:Find("rightRoot/Text"):GetComponent("Text")
    this.buyAreaText04 = transform:Find("centerRoot/buy/Text (1)"):GetComponent("Text")
    this.rentAreaText05 = transform:Find("centerRoot/rent/Text (1)"):GetComponent("Text")
    this.rentTenancyText06 = transform:Find("centerRoot/rent/Text (2)"):GetComponent("Text")
    this.rentDailyText07 = transform:Find("centerRoot/rent/Text (3)"):GetComponent("Text")
    this.totalText08 = transform:Find("centerRoot/total/Text"):GetComponent("Text")
end
--
function GroundTransContractPanel.chooseState(isRent)
    if isRent then
        this.rentBottomTran.localScale = Vector3.one
        this.rentCenterTran.localScale = Vector3.one
        this.buyBottomBtn.localScale = Vector3.zero
        this.buyCenterTran.localScale = Vector3.zero
    else
        this.rentBottomTran.localScale = Vector3.zero
        this.rentCenterTran.localScale = Vector3.zero
        this.buyBottomBtn.localScale = Vector3.one
        this.buyCenterTran.localScale = Vector3.one
    end
end