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
    ct.log("tina_w22_friends", "CompanyPanel:InitPanel()")
    this.backBtn = transform:Find("TopRoot/BackBtn").gameObject

    -- 多语言EvaBtn
    this.titleText = transform:Find("TopRoot/TitleText"):GetComponent("Text")
    --this.incomeTitle = transform:Find("BottomRoot/BasicInfoRoot/IncomeImage/IncomeTitle"):GetComponent("Text")
    --this.expenditureTitle = transform:Find("BottomRoot/BasicInfoRoot/IncomeImage/ExpenditureTitle"):GetComponent("Text")
    --this.expenditureTitle = transform:Find("BottomRoot/BasicInfoRoot/IncomeImage/ExpenditureTitle"):GetComponent("Text")
    --this.tips = transform:Find("BottomRoot/BusinessRecordsRoot/Tips"):GetComponent("Text")
    --this.tipsTextCom = transform:Find("BottomRoot/BusinessRecordsRoot/TipsText"):GetComponent("Text")
    --
    -- 基础信息显示
    this.headImage = transform:Find("BottomRoot/InfoRoot/NameRoot/HeadBg")
    this.companyNameText = transform:Find("BottomRoot/InfoRoot/NameRoot/CompanyNameText"):GetComponent("Text")
    this.sexImage = transform:Find("BottomRoot/InfoRoot/NameRoot/NameText/SexImage"):GetComponent("Image")
    this.nameText = transform:Find("BottomRoot/InfoRoot/NameRoot/NameText"):GetComponent("Text")
    --this.coinBg = transform:Find("BottomRoot/InfoRoot/CoinBg").gameObject
    --this.coinText = transform:Find("BottomRoot/InfoRoot/CoinBg/CoinText"):GetComponent("Text")
    this.foundingTimeText = transform:Find("BottomRoot/InfoRoot/NameRoot/FoundingTimeText"):GetComponent("Text")
    this.companyRenameBtn = transform:Find("BottomRoot/InfoRoot/NameRoot/CompanyNameText/CompanyRenameBtn")
    this.yScaleRT = transform:Find("BottomRoot/InfoRoot/IEPic/yScale"):GetComponent("RectTransform")
    this.detaiks = transform:Find("BottomRoot/InfoRoot/IEPic/detaiks").gameObject    --营收详情
    this.detaiksText = transform:Find("BottomRoot/InfoRoot/IEPic/detaiks/Text"):GetComponent("Text")
    this.curve = transform:Find("BottomRoot/InfoRoot/IEPic/curveBg/curve")
    this.curveSlide = transform:Find("BottomRoot/InfoRoot/IEPic/curveBg/curve"):GetComponent("Slide")
    this.curveFunctionalGraph = transform:Find("BottomRoot/InfoRoot/IEPic/curveBg/curve"):GetComponent("FunctionalGraph")
    this.incomeText = transform:Find("BottomRoot/InfoRoot/IERoot/IncomeText"):GetComponent("Text")
    this.expenditureText = transform:Find("BottomRoot/InfoRoot/IERoot/ExpenditureText"):GetComponent("Text")

    -- 交易记录
    --this.businessRecordsScroll = transform:Find("BottomRoot/BusinessRecordsRoot/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect")
    --this.tipsText = transform:Find("BottomRoot/BusinessRecordsRoot/TipsText").gameObject

    -- 分页按钮
    this.infoBtn = transform:Find("BottomRoot/LeftRoot/InfoBtn"):GetComponent("Button")
    this.landBtn = transform:Find("BottomRoot/LeftRoot/LandBtn"):GetComponent("Button")
    this.buildingBtn = transform:Find("BottomRoot/LeftRoot/BuildingBtn"):GetComponent("Button")
    --this.evaBtn = transform:Find("BottomRoot/LeftRoot/EvaBtn"):GetComponent("Button")
    this.brandBtn = transform:Find("BottomRoot/LeftRoot/BrandBtn"):GetComponent("Button")

    -- 显示节点
    this.infoRoot = transform:Find("BottomRoot/InfoRoot")
    this.landRoot = transform:Find("BottomRoot/LandRoot")
    this.landTitleItem = transform:Find("BottomRoot/LandRoot/LandTitleItem").gameObject
    this.buildingRoot = transform:Find("BottomRoot/BuildingRoot")
    --this.evaRoot = transform:Find("BottomRoot/EvaRoot")
    this.brandRoot = transform:Find("BottomRoot/BrandRoot")

    -- 土地显示
    this.landTitleContent = transform:Find("BottomRoot/LandRoot/TitleScroll/Viewport/Content")
    this.landScroll = transform:Find("BottomRoot/LandRoot/ContentScroll/Viewport"):GetComponent("ActiveLoopScrollRect")

    -- 建筑显示
    this.buildingTitleContent = transform:Find("BottomRoot/BuildingRoot/TitleScroll/Viewport/Content")
    this.buildingTitleRt = transform:Find("BottomRoot/BuildingRoot/TitleScroll/Viewport/Content"):GetComponent("RectTransform")
    this.buildingScroll = transform:Find("BottomRoot/BuildingRoot/ContentScroll/Viewport"):GetComponent("ActiveLoopScrollRect")

    -- Eva显示
    --this.myEvaText = transform:Find("BottomRoot/EvaRoot/PropertyRoot/MyEvaText"):GetComponent("Text")
    --this.introductionBtn = transform:Find("BottomRoot/EvaRoot/PropertyRoot/IntroductionBtn").gameObject
    --this.optionOneObj = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionOneScroll").gameObject
    --this.optionOneScroll = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionOneScroll/Content")
    --this.optionTwoScroll = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionTwoScroll"):GetComponent("ActiveLoopScrollRect")
    --this.optionThereScroll = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionThereScroll"):GetComponent("ActiveLoopScrollRect")
    --this.propertyScroll = transform:Find("BottomRoot/EvaRoot/PropertyRoot/PropertyScroll/Content")
    --this.closeTipsBtn = transform:Find("BottomRoot/EvaRoot/PropertyRoot/CloseTipsBtn")

    -- Eva界面调整
    --this.optionRootRt = transform:Find("BottomRoot/EvaRoot/OptionRoot"):GetComponent("RectTransform")
    --this.bg2Rt = transform:Find("BottomRoot/EvaRoot/OptionRoot/Bg2")
    --this.optionOneRt = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionOneScroll/Content"):GetComponent("RectTransform")
    --this.optionTwoT = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionTwoScroll")
    --this.optionThereT = transform:Find("BottomRoot/EvaRoot/OptionRoot/OptionThereScroll")
    --this.propertyRootRt = transform:Find("BottomRoot/EvaRoot/PropertyRoot"):GetComponent("RectTransform")

    -- 品牌显示
    this.brandTitleContent = transform:Find("BottomRoot/BrandRoot/TitleScroll/Viewport/Content")
    this.sizeBtn = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBtn")
    this.sizeBtnImage = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBtn/Image")
    this.sizeBtnText = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBtn/Text"):GetComponent("Text")
    this.sizeBg = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBg")
    this.choiceOBtn = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBg/ChoiceOBtn")
    this.choiceOBtnText = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBg/ChoiceOBtn/Text"):GetComponent("Text")
    this.choiceTBtn = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBg/ChoiceTBtn")
    this.choiceTBtnText = transform:Find("BottomRoot/BrandRoot/ContentRoot/SizeBg/ChoiceTBtn/Text"):GetComponent("Text")
    this.brandScroll = transform:Find("BottomRoot/BrandRoot/ContentRoot/ContentScroll"):GetComponent("ActiveLoopScrollRect")
    this.brandScrollContent = transform:Find("BottomRoot/BrandRoot/ContentRoot/ContentScroll/Content"):GetComponent("GridLayoutGroup")

    -- 没内容提示
    this.noContentRoot = transform:Find("BottomRoot/NoContentRoot")
    this.tipsText = transform:Find("BottomRoot/NoContentRoot/TipsText"):GetComponent("Text")

    -- 多语言
    this.infoBtnText = transform:Find("BottomRoot/LeftRoot/InfoBtn/Text"):GetComponent("Text")
    this.landBtnText = transform:Find("BottomRoot/LeftRoot/LandBtn/Text"):GetComponent("Text")
    this.buildingBtnText = transform:Find("BottomRoot/LeftRoot/BuildingBtn/Text"):GetComponent("Text")
    this.brandBtnText = transform:Find("BottomRoot/LeftRoot/BrandBtn/Text"):GetComponent("Text")
    this.incomeTitleText = transform:Find("BottomRoot/InfoRoot/IERoot/IncomeTitleText"):GetComponent("Text")
    this.expenditureTitleText = transform:Find("BottomRoot/InfoRoot/IERoot/ExpenditureTitleText"):GetComponent("Text")
end
