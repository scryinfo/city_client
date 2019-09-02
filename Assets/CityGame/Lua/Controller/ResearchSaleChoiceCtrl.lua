---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 16:24
---

ResearchSaleChoiceCtrl = class("ResearchSaleChoiceCtrl", UIPanel)
ResearchSaleChoiceCtrl:ResgisterOpen(ResearchSaleChoiceCtrl)

function ResearchSaleChoiceCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function ResearchSaleChoiceCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ResearchSaleChoicePanel.prefab"
end

function ResearchSaleChoiceCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function ResearchSaleChoiceCtrl:Awake(go)
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(ResearchSaleChoicePanel.backBtn, self.OnBack, self)
end

function ResearchSaleChoiceCtrl:Active()
    UIPanel.Active(self)

    -- 多语言
    ResearchSaleChoicePanel.nullText.text = GetLanguage(28060002)
    ResearchSaleChoicePanel.titleText.text = GetLanguage(28060023)
end

function ResearchSaleChoiceCtrl:Refresh()
    self:_updateData()
end

function ResearchSaleChoiceCtrl:Hide()
    UIPanel.Hide(self)
    if self.researchMaterialItems then
        for _, v in ipairs(self.researchMaterialItems) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.researchMaterialItems = nil
    end
end

-- 初始化基本数据
function ResearchSaleChoiceCtrl:_updateData()
    -- 根据数据生成ResearchMaterialItem
    if not self.researchMaterialItems then
        self.researchMaterialItems = {}
        if self.m_data.store and self.m_data.store[1] then
            ResearchSaleChoicePanel.nullImage.localScale = Vector3.zero
            for i, v in ipairs(self.m_data.store) do
                local go = ct.InstantiatePrefab(ResearchSaleChoicePanel.researchMaterialItem)
                local rect = go.transform:GetComponent("RectTransform")
                go.transform:SetParent(ResearchSaleChoicePanel.materialsScrollContent)
                rect.transform.localScale = Vector3.one
                rect.transform.localPosition = Vector3.zero
                go:SetActive(true)

                self.researchMaterialItems[i] = ResearchMaterialItem:new(go, v, 1, self.m_data.buildingId)
            end
        else
            ResearchSaleChoicePanel.nullImage.localScale = Vector3.one
        end
    end
end
-------------------------------------按钮点击事件-------------------------------------
function ResearchSaleChoiceCtrl:OnBack(go)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end