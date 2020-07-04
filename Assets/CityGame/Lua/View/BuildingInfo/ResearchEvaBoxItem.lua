---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 14:55
---

ResearchEvaBoxItem = class("ResearchEvaBoxItem")

-- initialization
function ResearchEvaBoxItem:initialize(prefab, data, fuc)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform

    self.Bg = transform:Find("Bg")
    transform:Find("NameText"):GetComponent("Text").text = GetLanguage(ResearchConfig[data.key.id].packageName)
    self.numText = transform:Find("NumText"):GetComponent("Text")

    self.btn = transform:GetComponent("Button")
    self.btn.onClick:AddListener(function ()
        fuc(self)
    end)

    self:SetBg(false)
    self:SetNumText()
end

function ResearchEvaBoxItem:SetBg(isShow)
    self.Bg.localScale = isShow and Vector3.one or Vector3.zero
end

function ResearchEvaBoxItem:SetBtn(isSelect)
    self.btn.interactable = isSelect
    self:SetBg(not isSelect)
end

function ResearchEvaBoxItem:SetNumText()
    self.numText.text = "X" .. self.data.n
    ct.log("system","刷新研究所宝箱个数 " .. self.data.n )
end

function ResearchEvaBoxItem:ChangeNumber(num)
    ct.log("system","研究所宝箱个数  old：" .. self.data.n .. "  changeNum  " .. num )
    self.data.n = self.data.n + num
end

function ResearchEvaBoxItem:GetNumber()
    if  self.data.n ~= nil then
        return self.data.n
    end
end