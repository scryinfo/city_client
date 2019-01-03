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

    this.totalPriceText = transform:Find("centerRoot/total/totalPriceText")
    this.rentCenterTran = transform:Find("centerRoot/rent")
    this.rentAreaText = transform:Find("centerRoot/rent/areaText")
    this.rentTenancyText = transform:Find("centerRoot/rent/tenancyText"):GetComponent("Text")
    this.rentTenancyTimeText = transform:Find("centerRoot/rent/tenancyTimeText"):GetComponent("Text")
    this.rentDailyRentText = transform:Find("centerRoot/rent/dailyRentText"):GetComponent("Text")
    this.buyCenterTran = transform:Find("centerRoot/buy")
    this.buyAreaText = transform:Find("centerRoot/buy/areaText")

    --A
    this.APortraitImg = transform:Find("leftRoot/bg02/portraitImg"):GetComponent("Image")
    this.ANameText = transform:Find("leftRoot/nameText")
    --B
    this.BPortraitImg = transform:Find("rightRoot/bg02/portraitImg"):GetComponent("Image")
    this.BNameText = transform:Find("rightRoot/nameText")
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