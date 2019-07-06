---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/13 11:26
---
local transform;
local gameObject;

AddProductionLineBoxPanel = {};
local this = AddProductionLineBoxPanel;

function AddProductionLineBoxPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function AddProductionLineBoxPanel:InitPanel()
    --Top
    this.closeBtn = transform:Find("contentRoot/top/closeBtn"):GetComponent("Button")
    this.topName = transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content
    this.iconImg = transform:Find("contentRoot/content/goodsInfo/iconBg/iconImg"):GetComponent("Image")
    this.nameText = transform:Find("contentRoot/content/goodsInfo/iconBg/nameBg/nameText"):GetComponent("Text")
    this.brandNameText = transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandNameText"):GetComponent("Text")
    --商品属性，原料没有
    this.iconBg = transform:Find("contentRoot/content/goodsInfo/iconBg")
    this.scoreBg = transform:Find("contentRoot/content/goodsInfo/scoreBg")
    this.popularity = transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity")
    this.quality = transform:Find("contentRoot/content/goodsInfo/scoreBg/quality")
    this.levelBg = transform:Find("contentRoot/content/goodsInfo/levelBg")

    this.popularityText = transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity"):GetComponent("Text")
    this.popularityValue = transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity/popularityValue"):GetComponent("Text")
    this.qualityText = transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality"):GetComponent("Text")
    this.qualityValue = transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality/qualityValue"):GetComponent("Text")
    this.levelImg = transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg"):GetComponent("Image")
    this.levelText = transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level"):GetComponent("Text")
    this.levelValue = transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level/levelText"):GetComponent("Text")

    this.productionText = transform:Find("contentRoot/content/goodsInfo/tipBg/productionSpeed/productionText"):GetComponent("Text")
    this.speedText = transform:Find("contentRoot/content/goodsInfo/tipBg/productionSpeed/productionText/SpeedText"):GetComponent("Text")
    this.eachText = transform:Find("contentRoot/content/goodsInfo/tipBg/productionSpeed/productionText/SpeedText/eachText"):GetComponent("Text")
    this.time = transform:Find("contentRoot/content/goodsInfo/tipBg/time"):GetComponent("Text")
    this.timeText = transform:Find("contentRoot/content/goodsInfo/tipBg/time/timebg/timeText"):GetComponent("Text")

    this.numberTip = transform:Find("contentRoot/content/numberTip"):GetComponent("Text")
    this.tipText = transform:Find("contentRoot/content/tip"):GetComponent("Text")
    this.numberSlider = transform:Find("contentRoot/content/numberSlider"):GetComponent("Slider")
    --this.sliderNumberText = transform:Find("contentRoot/content/numberSlider/HandleSlideArea/Handle/sliderNumberBg/sliderNumberText"):GetComponent("Text")
    this.numberText = transform:Find("contentRoot/content/number"):GetComponent("Text")
    this.numberInput = transform:Find("contentRoot/content/numberInput"):GetComponent("InputField")
    this.leftBtn = transform:Find("contentRoot/content/leftBtn"):GetComponent("Button")
    this.rightBtn = transform:Find("contentRoot/content/rightBtn"):GetComponent("Button")
    --bottom
    this.confirmBtn = transform:Find("contentRoot/bottom/confirmBtn"):GetComponent("Button")

end