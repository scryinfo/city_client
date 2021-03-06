---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 15:54
---

ResearchLineItem = class("ResearchLineItem")

-- initialization
function ResearchLineItem:initialize(prefab, data, buildingId)
    self.prefab = prefab
    self.data = data
    self.buildingId = buildingId

    local transform = prefab.transform
    LoadSprite( ResearchConfig[data.itemId].iconPath, transform:Find("IconImage"):GetComponent("Image"), true)
    transform:Find("NameText"):GetComponent("Text").text = ResearchConfig[data.itemId].name
    transform:Find("NumText"):GetComponent("Text").text = string.format("0/%d", data.targetCount)

    transform:Find("DeleteBtn"):GetComponent("Button").onClick:AddListener(function ()
        self:_clickRemove()
    end)

    self.topBtn = transform:Find("TopBtn")
    self.topBtn:GetComponent("Button").onClick:AddListener(function ()
        self:_clickTop()
    end)
end

-- Set whether sticky is displayed
function ResearchLineItem:SetTopBtnShow(isSelect)
    self.topBtn.localScale = isSelect and Vector3.one or Vector3.zero
end

-- Click Delete to send a message to the server
function ResearchLineItem:_clickRemove()
    DataManager.DetailModelRpcNoRet(self.buildingId, 'm_ReqDelScienceLine', self.data.id)
end

-- Click Sticky to send a message to the server
function ResearchLineItem:_clickTop()
    DataManager.DetailModelRpcNoRet(self.buildingId, 'm_ReqSetScienceLineOrder', self.data.id)
end