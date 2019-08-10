---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/10 10:59
---城市信息Panel
local transform;
local gameObject;

CityInfoPanel = {};
local this = CityInfoPanel;
--启动事件--
function CityInfoPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CityInfoPanel.InitPanel()
    this.back = transform:Find("top/back").gameObject
    this.name = transform:Find("top/back/Text"):GetComponent("Text")
    --left
    this.notBasic = transform:Find("content/left/basic/notSelectBg").gameObject
    this.notBasicText = transform:Find("content/left/basic/notSelectBg/Image/Text"):GetComponent("Text")
    this.basic = transform:Find("content/left/basic/selectBg")
    this.basicText = transform:Find("content/left/basic/selectBg/Image/Text"):GetComponent("Text")
    this.notIndustry = transform:Find("content/left/industry/notSelectBg").gameObject
    this.notIndustryText = transform:Find("content/left/industry/notSelectBg/Image/Text"):GetComponent("Text")
    this.industry = transform:Find("content/left/industry/selectBg")
    this.industryText = transform:Find("content/left/industry/selectBg/Image/Text"):GetComponent("Text")
    this.content = transform:Find("content/left/content"):GetComponent("RectTransform")
    this.industryInfoItem = transform:Find("content/left/content/IndustryInfoItem").gameObject
    --right
    this.income = transform:Find("content/right/income"):GetComponent("Text")
    this.yScale = transform:Find("content/right/yScale"):GetComponent("RectTransform")
    this.sum = transform:Find("content/right/sum"):GetComponent("Text")
    this.curve = transform:Find("content/right/curveBg/curve"):GetComponent("RectTransform")
    this.slide = transform:Find("content/right/curveBg/curve"):GetComponent("Slide")  --滑动
    this.graph = transform:Find("content/right/curveBg/curve"):GetComponent("FunctionalGraph")  --绘制曲线
    this.homeHouse = transform:Find("content/right/homeHouse/bg").gameObject
    this.homeHouseText = transform:Find("content/right/homeHouse/Image/Text"):GetComponent("Text")
    this.homeHouseTag = transform:Find("content/right/homeHouse/tag")

    this.supermarket = transform:Find("content/right/supermarket/bg").gameObject
    this.supermarketText = transform:Find("content/right/supermarket/Image/Text"):GetComponent("Text")
    this.supermarketTag = transform:Find("content/right/supermarket/tag")

    this.materialPlant = transform:Find("content/right/materialPlant/bg").gameObject
    this.materialPlantText = transform:Find("content/right/materialPlant/Image/Text"):GetComponent("Text")
    this.materialPlantTag = transform:Find("content/right/materialPlant/tag")

    this.factory = transform:Find("content/right/factory/bg").gameObject
    this.factoryText = transform:Find("content/right/factory/Image/Text"):GetComponent("Text")
    this.factoryTag = transform:Find("content/right/factory/tag")

    this.advertising = transform:Find("content/right/advertising/bg").gameObject
    this.advertisingText = transform:Find("content/right/advertising/Image/Text"):GetComponent("Text")
    this.advertisingTag = transform:Find("content/right/advertising/tag")

    this.technology = transform:Find("content/right/technology/bg").gameObject
    this.technologyText = transform:Find("content/right/technology/Image/Text"):GetComponent("Text")
    this.technologyTag = transform:Find("content/right/technology/tag")

    this.land = transform:Find("content/right/land/bg").gameObject
    this.landText = transform:Find("content/right/land/Image/Text"):GetComponent("Text")
    this.landTag = transform:Find("content/right/land/tag")
end