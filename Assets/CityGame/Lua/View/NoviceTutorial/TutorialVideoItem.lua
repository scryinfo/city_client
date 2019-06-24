---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/6/20 17:24
---

TutorialVideoItem = class("TutorialVideoItem")

-- 初始化
function TutorialVideoItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data
    local transform = prefab.transform

    transform:Find("VideoNameText"):GetComponent("Text").text = data.videoName
    LoadSprite(data.imgPath, transform:Find("VideoImage"):GetComponent("Image"), true)

    self.btn = transform:GetComponent("Button")

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function()
        self:_onClickBtn()
    end)
end

-- 按钮的点击事件
function TutorialVideoItem:_onClickBtn()
    UnityEngine.Application.OpenURL(self.data.url)
end