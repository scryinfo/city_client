---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/17 11:12
---

ChatRightItem = class('ChatRightItem')

-- 初始化
function ChatRightItem:initialize(itemId, prefab, data)
    self.prefab = prefab
    self.data = data
    self.data.itemId = itemId
    --self.data.company = "Scry"

    local transform = prefab.transform
    -- 说话人的背景
    self.playerNameImage = transform:Find("PlayerNameImage")
    -- 说话人的名字
    self.playerNameText = transform:Find("PlayerNameImage/PlayerNameText"):GetComponent("Text")
    -- 聊天的背景
    self.chatBg = transform:Find("ChatBg")
    -- 聊天的内容
    self.chatText = transform:Find("ChatBg/ChatText"):GetComponent("Text")
    self.playerNameText.text = self.data.name
    self.chatText.text = self.data.msg

    local chatTextPreferredWidth = self.chatText.preferredWidth
    local transformSizeDelta = transform.sizeDelta
    if chatTextPreferredWidth > 580 then
        self.chatText.transform.sizeDelta = Vector2.New(580, 60)
        self.chatText.verticalOverflow = UnityEngine.VerticalWrapMode.Overflow
        local chatTextPreferredHeight = self.chatText.preferredHeight
        self.chatText.transform.sizeDelta = Vector2.New(580, chatTextPreferredHeight)
        self.playerNameImage.anchoredPosition = Vector2.New(-170, chatTextPreferredHeight + 66)
        transformSizeDelta.y = chatTextPreferredHeight + 130
        transform.sizeDelta = Vector2.New(transformSizeDelta.x, chatTextPreferredHeight + 130)
    else
        self.chatText.transform.sizeDelta = Vector2.New(chatTextPreferredWidth, 30)
        self.playerNameImage.anchoredPosition = Vector2.New(-170, 97)
    end

    if self.data.channel == "WORLD" then
        transform.sizeDelta = Vector2.New(1120, transformSizeDelta.y)
    end
 end