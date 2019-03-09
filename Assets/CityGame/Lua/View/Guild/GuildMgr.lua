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
        self.guildMenu.prefab.transform.position = position
        self:SetClickInteractable()
        self.guildMenu:SetAppointRoot(false)
        self:SetGuildMenuShow(true)
        self.guildMenu:SetAppointImageColor(true)

    else
        self:LoadGuildMenu(position)
    end
end

function GuildMgr:LoadGuildMenu(position)
    panelMgr:LoadPrefab_A(GuildMgr.static.GuildMenuPATH, nil, nil, function(ins, obj )
        if obj ~= nil then
            local go = ct.InstantiatePrefab(obj)
            local rect = go.transform:GetComponent("RectTransform")
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
    return self.memberItem.data.id
end

function GuildMgr:SetClickInteractable()
    self.memberItem:_setButtonInteractable(true)
end

function GuildMgr:GetPlayerData()
    return self.memberItem.data
end

function GuildMgr:SetGuildMenuShow(isShow)
    if self.guildMenu then
        self.guildMenu:SetPrefabShow(isShow)
    end
end

function GuildMgr:SetOwnGuildIdentity(ownIdentity)
    if ownIdentity then
        self.ownIdentity = ownIdentity
    end
end

function GuildMgr:GetOwnGuildIdentity()
    return self.ownIdentity
end

function GuildMgr:SetIdentity()
    if self.guildMenu then
        self.guildMenu:_SetIdentity()
    end
end