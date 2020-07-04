---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/18/018 12:02
---


local transform;

AvtarPanel = {};
local this = AvtarPanel;

function AvtarPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanel();
end

function AvtarPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn")
    this.cofirmBtn = transform:Find("topRoot/confirmBtn")
    this.randomBtn = transform:Find("randomBtn")

    this.showContent = transform:Find("showContent/bg/Image")
    this.fiveContent = transform:Find("fiveScroll/Viewport/Content")
    this.kindsContent = transform:Find("kindsScroll/Viewport/Content")
    this.maleBtn = transform:Find("kindsScroll/male")
    this.feMaleBtn = transform:Find("kindsScroll/faMale")

    this.maleSelect = transform:Find("kindsScroll/male/select")
    this.feMaleSelect = transform:Find("kindsScroll/faMale/select")

    this.topticText = transform:Find("topRoot/name"):GetComponent("Text")

    this.luckyText = transform:Find("topRoot/Lucky/luckText"):GetComponent("Text")

    this.luckyValue = transform:Find("topRoot/Lucky/luckycouponValue"):GetComponent("Text")

    this.luckyRoot = transform:Find("topRoot/Lucky")
    this.luckInfoBtn = transform:Find("topRoot/Lucky/ExplainBtn")
    this.luckText01 = transform:Find("infoRoot/Text"):GetComponent("Text")  --
    this.luckValueText = transform:Find("infoRoot/Text/valueText"):GetComponent("Text")  --Lucky coupons spent
    this.luckTipRoot = transform:Find("luckyTip")  --Lucky coupon tips
    this.luckTipBtn = transform:Find("luckyTip/btn")
    this.luckTipText02 = transform:Find("luckyTip/competitivenessRoot/tooltip/title"):GetComponent("Text")
    this.luckTipText03 = transform:Find("luckyTip/competitivenessRoot/tooltip/content"):GetComponent("Text")
end
--Lucky coupon tips
function AvtarPanel.InitLanguage()
    this.topticText.text = GetLanguage(10060011)
    this.luckyText.text = GetLanguage(17030001)
    --this.luckText01.text = GetLanguage(17030002)
    --this.luckTipText02.text = GetLanguage(17030003)
    --this.luckTipText03.text = GetLanguage(17030006)
end


