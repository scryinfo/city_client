---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 15:54
---

ResearchLineItem = class("ResearchLineItem")

-- 初始化
function ResearchLineItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data
end

-- 点击删除，向服务器发消息
function ResearchLineItem:_clickRemove()
end

-- 点击置顶，向服务器发消息
function ResearchLineItem:_clickTop()
end