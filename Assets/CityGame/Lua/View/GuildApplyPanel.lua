---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/19 17:27
---

local transform

GuildApplyPanel = {}
local this = GuildApplyPanel

function GuildApplyPanel.Awake(obj)
    transform = obj.transform

    this.InitPanel()
end

function GuildApplyPanel.InitPanel()
    this.backBtn = transform:Find("MiddleRoot/BackBtn").gameObject

    -- 申请信息
    this.guildInfoScroll = transform:Find("MiddleRoot/Bg/Scroll View"):GetComponent("ActiveLoopScrollRect")
end