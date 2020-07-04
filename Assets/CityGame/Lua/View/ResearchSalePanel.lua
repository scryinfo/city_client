---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 16:34
---

local transform
ResearchSalePanel = {}

local this = ResearchSalePanel

function ResearchSalePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function ResearchSalePanel.InitPanel()
    this.backBtn = transform:Find("BackBtn").gameObject

    this.nameText = transform:Find("MiddleRoot/LightImage/NameText"):GetComponent("Text")
    this.warehouseBtn = transform:Find("MiddleRoot/LightImage/WarehouseBtn").gameObject
    this.warehouseText = transform:Find("MiddleRoot/LightImage/WarehouseBtn/Text"):GetComponent("Text")
    this.shelfBtn = transform:Find("MiddleRoot/LightImage/ShelfBtn").gameObject
    this.shelfText = transform:Find("MiddleRoot/LightImage/ShelfBtn/Text"):GetComponent("Text")

    this.autoToggle = transform:Find("MiddleRoot/AutoToggle"):GetComponent("Toggle")
    this.autoBtnImage = transform:Find("MiddleRoot/AutoToggle/BtnImage")
    this.quantityInputField = transform:Find("MiddleRoot/QuantityRoot/InputField"):GetComponent("InputField")
    this.quantitySlider = transform:Find("MiddleRoot/QuantityRoot/Slider"):GetComponent("Slider")
    this.nullImage = transform:Find("MiddleRoot/QuantityRoot/NullImage")
    this.nullText = transform:Find("MiddleRoot/QuantityRoot/NullImage/NullText"):GetComponent("Text")
    this.priceInputField = transform:Find("MiddleRoot/PriceRoot/InputField"):GetComponent("InputField")
    this.priceSlider = transform:Find("MiddleRoot/PriceRoot/Slider"):GetComponent("Slider")
    this.recommendText = transform:Find("MiddleRoot/PriceRoot/Slider/RecommendImage/Text"):GetComponent("Text")

    this.competitivenessText = transform:Find("MiddleRoot/CompetitivenessImage/CompetitivenessText"):GetComponent("Text")


    this.autoBtn = transform:Find("MiddleRoot/AutoBtn")
    this.tipsImage = transform:Find("MiddleRoot/AutoBtn/TipsImage")
    this.tipsText = transform:Find("MiddleRoot/AutoBtn/TipsImage/TipsText"):GetComponent("Text")

    this.competitivenessBtn = transform:Find("MiddleRoot/CompetitivenessImage/CompetitivenessBtn")

    this.closeBtnTF = transform:Find("MiddleRoot/CloseTextBtn")
    this.closeBtn = transform:Find("MiddleRoot/CloseTextBtn").gameObject
    this.sureBtnTF = transform:Find("MiddleRoot/SureBtn")
    this.sureBtn = transform:Find("MiddleRoot/SureBtn").gameObject
    this.changeBtnTF = transform:Find("MiddleRoot/ChangeBtn")
    this.changeBtn = transform:Find("MiddleRoot/ChangeBtn").gameObject

    this.closeTipsBtn = transform:Find("CloseTipsBtn")

    -- multi-language
    this.titleText = transform:Find("MiddleRoot/TitleText"):GetComponent("Text")
    this.priceRootTitleText = transform:Find("MiddleRoot/PriceRoot/TitleText"):GetComponent("Text")
    this.quantityRootTitleText = transform:Find("MiddleRoot/QuantityRoot/TitleText"):GetComponent("Text")
    this.autoLabel = transform:Find("MiddleRoot/AutoToggle/Label"):GetComponent("Text")
    this.sureText = transform:Find("MiddleRoot/SureBtn/Text"):GetComponent("Text")
    this.closeTextBtnText = transform:Find("MiddleRoot/CloseTextBtn"):GetComponent("Text")
end