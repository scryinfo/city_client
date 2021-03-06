---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/6/20 17:24
---

TutorialChoiceItem = class("TutorialChoiceItem")
TutorialChoiceItem.static.NomalNameColor = Vector3.New(78, 106, 178) -- Default name color
TutorialChoiceItem.static.SelectNameColor = Vector3.New(255, 255, 255) -- Selected name color

-- initialization
function TutorialChoiceItem:initialize(prefab, index, ctrl)
    self.prefab = prefab
    self.index = index
    self.ctrl = ctrl
    self.transform = prefab.transform

    self.choiceNameText = self.transform:Find("Text"):GetComponent("Text")

    self.btn = self.transform:GetComponent("Button")

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function()
        self:_onClickBtn()
    end)

    self:SetNameText()
    self:SetSelect(true)
end

-- Set whether the button is clickable
function TutorialChoiceItem:SetSelect(isSelect)
    self.btn.interactable = isSelect
    self.transform.sizeDelta = isSelect and Vector2.New(314, 110) or Vector2.New(318, 110)
    self.choiceNameText.color = getColorByVector3(isSelect and TutorialChoiceItem.static.NomalNameColor or TutorialChoiceItem.static.SelectNameColor)
end

-- Set the name of the selection
function TutorialChoiceItem:SetNameText()
    self.choiceNameText.text = GetLanguage(NoviceTutorialConfig[self.index].name)
end

-- Button click event
function TutorialChoiceItem:_onClickBtn()
    self:SetSelect(false)
    self.ctrl:_setBtnState(self)
    self.ctrl:ShowVideo(self.index)
end