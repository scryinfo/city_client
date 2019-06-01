---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/6/1 17:16
---

EvaResultItem = class("EvaResultItem")

-- 初始化
function EvaResultItem:initialize(perfab, data)
    local transform = perfab.transform
    local datas = data.evasInfo

    local rootTab = { {root = transform:Find("LeftRoot")}, {root = transform:Find("RightRoot")}}
    for i, v in ipairs(rootTab) do
        v.root:Find("NameText"):GetComponent("Text").text = "name"
    end
end