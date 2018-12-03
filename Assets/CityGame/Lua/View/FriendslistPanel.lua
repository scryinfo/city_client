---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/11/30 15:15
---

local transform

FriendslistPanel = {}
local this = FriendslistPanel

function FriendslistPanel.Awake(obj)
    ct.log("tina_w15_friends", "FriendsPanel.Awake")
    transform = obj.transform

    this.InitPanel()
end

function FriendslistPanel.InitPanel()
    -- 面板名字
    this.panelNameText = transform:Find("MiddleRoot/TitleBg/PanelNameText"):GetComponent("Text")

    this.backBtn = transform:Find("MiddleRoot/BackBtn").gameObject

    --好友图标及数量
    this.friendsNumberImage = transform:Find("MiddleRoot/Bg/FriendsNumberImage").gameObject
    this.friendsNumberText = transform:Find("MiddleRoot/Bg/FriendsNumberText"):GetComponent("Text")

    --好友搜索
    this.searchInputField = transform:Find("MiddleRoot/Bg/SearchInputField").gameObject

    --好友群组滑动框显示
    this.listScrollView = transform:Find("MiddleRoot/Bg/Scroll View"):GetComponent("RectTransform");
    this.listContent = transform:Find("MiddleRoot/Bg/Scroll View/Viewport/Content")
end
