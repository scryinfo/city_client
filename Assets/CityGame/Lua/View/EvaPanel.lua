---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/5/24 15:28
---

EvaPanel = {}
local this = EvaPanel

local transform
local ganeObject

function EvaPanel.Awake(obj)
    ganeObject = obj
    transform = obj.transform

    this.InitPanel()
end

function EvaPanel.InitPanel()
    this.backBtn = transform:Find("TopRoot/BackBtn").gameObject
    this.closeIntroductionBtn = transform:Find("CloseIntroductionBtn")
    this.startAddBtn = transform:Find("TopRoot/StartAddBtn")
    this.addBtn = transform:Find("TopRoot/AddBtn").gameObject
    this.addButton = transform:Find("TopRoot/AddBtn"):GetComponent("Button")

    -- left
    this.evaTitleItem = transform:Find("BottomRoot/LeftRoot/EvaTitleItem").gameObject
    this.optionOneScroll = transform:Find("BottomRoot/LeftRoot/OptionOneScroll/Content")

    -- Technology points, market points
    this.technologyTitleText = transform:Find("BottomRoot/PointRoot/TechnologyTitleText"):GetComponent("Text")
    this.technologyText = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText"):GetComponent("Text")
    this.technologyBtn = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText/TechnologyBtn")
    this.lineImageTF = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText/TechnologyBtn/Image")
    this.marketTitleTextTF = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText/TechnologyBtn/MarketTitleText")
    this.marketTitleText = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText/TechnologyBtn/MarketTitleText"):GetComponent("Text")
    this.marketText = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText/TechnologyBtn/MarketTitleText/MarketText"):GetComponent("Text")
    this.marketBtn = transform:Find("BottomRoot/PointRoot/TechnologyTitleText/TechnologyText/TechnologyBtn/MarketTitleText/MarketText/MarketBtn")

    this.optionTwoScroll = transform:Find("BottomRoot/OptionRoot/OptionTwoScroll"):GetComponent("ActiveLoopScrollRect")
    this.optionThereScroll = transform:Find("BottomRoot/OptionRoot/OptionThereScroll"):GetComponent("ActiveLoopScrollRect")

    -- hint
    this.introductionImage = transform:Find("IntroductionImage")
    this.introductionText = transform:Find("IntroductionImage/IntroductionText"):GetComponent("Text")

    this.iconTF = transform:Find("BottomRoot/PropertyRoot/ResultImage/Icon")
    this.iconImageTF = transform:Find("BottomRoot/PropertyRoot/ResultImage/Icon/IconImage")
    this.iconImage = transform:Find("BottomRoot/PropertyRoot/ResultImage/Icon/IconImage"):GetComponent("Image")

    this.ResultRootO = ResultOneItem:new(transform:Find("BottomRoot/PropertyRoot/ResultImage/ResultRootO"))
    this.ResultRootTwo = ResultTwoItem:new(transform:Find("BottomRoot/PropertyRoot/ResultImage/ResultRootTwo"))
    this.ResultRootThere = ResultTwoItem:new(transform:Find("BottomRoot/PropertyRoot/ResultImage/ResultRootThere"))

    this.propertyScroll = transform:Find("BottomRoot/PropertyRoot/PropertyScroll"):GetComponent("ActiveLoopScrollRect")
    this.propertyRootRt = transform:Find("BottomRoot/PropertyRoot")

    -- multi-language
    this.titleText = transform:Find("TopRoot/TitleText"):GetComponent("Text")
    this.addBtnText = transform:Find("TopRoot/AddBtn/Text"):GetComponent("Text")
end
