---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/18 16:57
---

ChatWorldItem = class('ChatWorldItem')

-- 初始化
function ChatWorldItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data
    self.data.itemId = itemId

    local transform = prefab.transform
    -- 说话人的名字
    self.nameText = transform:Find("NameImage/NameText"):GetComponent("Text")
    -- 聊天的内容
    self.chatText = transform:Find("ChatText"):GetComponent("Text")
    self.nameText.text = self.data.name
    self.chatText.text = self.data.msg

    local chatTextPreferredWidth = self.chatText.preferredWidth
    if chatTextPreferredWidth > 345 then
        local chatTextPreferredHeight = self.chatText.preferredHeight
        self.chatText.transform.sizeDelta = Vector2.New(345, chatTextPreferredHeight)
    else
        self.chatText.transform.sizeDelta = Vector2.New(345, 18)
    end
end