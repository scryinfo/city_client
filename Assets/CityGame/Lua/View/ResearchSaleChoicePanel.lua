---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 16:26
---

local transform
ResearchSaleChoicePanel = {}

local this = ResearchSaleChoicePanel

function ResearchSaleChoicePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function ResearchSaleChoicePanel.InitPanel()
    this.backBtn = transform:Find("BottomRoot/BackBtn").gameObject

    this.materialsScrollContent = transform:Find("BottomRoot/MaterialsScroll/Viewport/Content")
    this.researchMaterialItem = transform:Find("BottomRoot/MaterialsScroll/Viewport/Content/ResearchMaterialItem").gameObject
end