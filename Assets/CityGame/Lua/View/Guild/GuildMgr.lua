---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/28 15:19
---

GuildMgr = class('GuildMgr')
GuildMgr.static.GuildMenuPATH = "Assets/CityGame/Resources/View/Guild/GuildMenu.prefab"

function GuildMgr:initialize()
end

function GuildMgr:ShowGuildMenu(position)
    if self.guildMenu then
        self:SetGuildMenuShow(true)
        self.guildMenu.prefab.transform.position = position
        --self:SetClickInteractable()
        self.guildMenu:SetAppointRoot(false)
        self.guildMenu:SetAppointImageColor(true)
        self.guildMenu:_SetIdentity()
    else
        self:LoadGuildMenu(position)
    end
end

function GuildMgr:LoadGuildMenu(position)
    panelMgr:LoadPrefab_A(GuildMgr.static.GuildMenuPATH, nil, nil, function(ins, obj )
        if obj ~= nil then
            local go = ct.InstantiatePrefab(obj)
            local rect = go.transform:GetComponent("RectTransform")
            self:SetGuildMenuShow(true)
            go.transform:SetParent(GuildOwnPanel.menuRoot)
            rect.transform.localScale = Vector3.one
            rect.transform.position = position
            self.guildMenu = GuildMenu:new(go)
            self.guildMenu:_SetIdentity()
        end
    end)
end

function GuildMgr:SetSelectMemberItem(item)
    self.memberItem = item
end

function GuildMgr:GetPlayerId()
    local memberItemId
    if self.memberItem then
        memberItemId = self.memberItem.data.id
    end
    return memberItemId
end

function GuildMgr:SetClickInteractable()
    if self.memberItem then
        self.memberItem:_setButtonInteractable(true)
    end
end

function GuildMgr:GetPlayerData()
    return self.memberItem.data
end

function GuildMgr:SetGuildMenuShow(isShow)
    GuildOwnPanel.menuRoot.localScale = isShow and Vector3.one or Vector3.zero
end

function GuildMgr:SetOwnGuildIdentity(ownIdentity)
    if ownIdentity then
        self.ownIdentity = ownIdentity
    end
end

function GuildMgr:GetOwnGuildIdentity()
    return self.ownIdentity
end

--function GuildMgr:SetIdentity()
--    if self.guildMenu then
--        self.guildMenu:_SetIdentity()
--    end
--end

function GuildMgr:SetLanguage()
    if self.guildMenu then
        self.guildMenu:_SetLanguage()
    end
end
