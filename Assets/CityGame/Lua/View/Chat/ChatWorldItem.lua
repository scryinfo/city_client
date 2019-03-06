---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/18 16:57
---

ChatWorldItem = class('ChatWorldItem')
--ChatWorldItem.static.NAME_COLOR = "#8EADFF"  -- 名字的颜色
--ChatWorldItem.static.MSG_COLOR = "#F0F0F0"  -- 聊天内容的颜色

-- 初始化
function ChatWorldItem:initialize(prefab)
    self.prefab = prefab

    local transform = prefab.transform
    -- 聊天的内容
    self.chatText = transform:Find("ChatText"):GetComponent("Text")
    self.headImage = transform:Find("HeadImage")

    --self.chatText.text = string.format("<color=%s><b>[%s]:</b></color><color=%s>%s</color>",ChatWorldItem.static.NAME_COLOR, data.name, ChatWorldItem.static.MSG_COLOR, data.msg)
    self:_ShowPrefab(false)
end

function ChatWorldItem:_ShowPrefab(isShow)
    self.prefab:SetActive(isShow)
end

function ChatWorldItem:_ShowChatContent(data)
    self.chatText.text = data.msg
    local chatTextPreferredWidth = self.chatText.preferredWidth
    if chatTextPreferredWidth > 470 then
        local chatTextPreferredHeight = self.chatText.preferredHeight
        --if chatTextPreferredHeight > 60 then
            self.chatText.transform.sizeDelta = Vector2.New(470, chatTextPreferredHeight)
        --else
        --    self.chatText.transform.sizeDelta = Vector2.New(470, 60)
        --end
    else
        self.chatText.transform.sizeDelta = Vector2.New(chatTextPreferredWidth, 60)
    end
    for i = 1, self.headImage.childCount do
        UnityEngine.GameObject.Destroy(self.headImage:GetChild(i-1).gameObject)
    end
    AvatarManger.GetSmallAvatar(data.image,self.headImage,0.1)
end