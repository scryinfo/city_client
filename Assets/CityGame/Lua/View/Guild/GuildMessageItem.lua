---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/21 16:42
---

GuildMessageItem = class("GuildMessageItem")
GuildMessageItem.static.NORMAL_COLOR = "#393939"  -- 正常颜色
GuildMessageItem.static.NAME_COLOR = "#f4c563"  -- 名字的颜色

function GuildMessageItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform
    self.describeText = transform:Find("DescribeText"):GetComponent("Text")
    self.timeText = transform:Find("TimeText"):GetComponent("Text")


    local timeTab = getFormatUnixTime(self.data.createTs/1000)
    self.timeText.text = string.format("%s/%s/%s", timeTab.day, timeTab.month, timeTab.year)


    if data.type == "JOIN_SOCIETY" then
        --str = data.createId .. "同意" .. data.affectedId .. "加入了商业联盟"
        PlayerInfoManger.GetInfos({data.createId, data.affectedId}, self._showNameHead, self)
    elseif data.type == "EXIT_SOCIETY" then
        --str = data.createId .. "退出了商业联盟"
        PlayerInfoManger.GetInfos({data.createId}, self._showNameHead, self)
    elseif data.type == "CREATE_SOCIETY" then
        --str = data.createId .. "创建了商业联盟"
        PlayerInfoManger.GetInfos({data.createId}, self._showNameHead, self)
    elseif data.type == "KICK_OUT_SOCIETY" then
        --str = data.affectedId .. "被" .. data.createId .. "踢出了商业联盟"
        PlayerInfoManger.GetInfos({data.affectedId, data.createId}, self._showNameHead, self)
    elseif data.type == "APPOINT_TO_MEMBER" then
        --str = data.affectedId .. "被" .. data.createId .. "任命为成员"
        PlayerInfoManger.GetInfos({data.affectedId, data.createId}, self._showNameHead, self)
    elseif data.type == "APPOINT_TO_CHAIRMAN" then
        --str = data.affectedId .. "被" .. data.createId .. "任命为会长"
        PlayerInfoManger.GetInfos({data.affectedId, data.createId}, self._showNameHead, self)
    elseif data.type == "APPOINT_TO_VICE_CHAIRMAN" then
        --str = data.affectedId .. "被" .. data.createId .. "任命为副会长"
        PlayerInfoManger.GetInfos({data.affectedId, data.createId}, self._showNameHead, self)
    elseif data.type == "APPOINT_TO_ADMINISTRATOR" then
        --str = data.affectedId .. "被" .. data.createId .. "任命为管理"
        PlayerInfoManger.GetInfos({data.affectedId, data.createId}, self._showNameHead, self)
    elseif data.type == "MODIFY_NAME" then
        --str = data.createId .. "修改了联盟名字"
        PlayerInfoManger.GetInfos({data.createId}, self._showNameHead, self)
    elseif data.type == "MODIFY_DECLARATION" then
        --str = data.createId .. "修改了商业宣言"
        PlayerInfoManger.GetInfos({data.createId}, self._showNameHead, self)
    elseif data.type == "MODIFY_INTRODUCTION" then
        --str = data.createId .. "修改了商业介绍"
        PlayerInfoManger.GetInfos({data.createId}, self._showNameHead, self)
    end
end

function GuildMessageItem:_showNameHead(playerData)
    local str = "1111"
    local data = self.data

    if data.type == "JOIN_SOCIETY" then
        str = playerData[1].name .. "同意" .. playerData[2].name .. "加入了商业联盟"
        --str = string.format("<color=%s>%s</color><color=%s>同意</color><color=%s>%s</color><color=%s>加入了商业联盟</color>", GuildMessageItem.static.NAME_COLOR, playerData[1].name, GuildMessageItem.static.NORMAL_COLOR, GuildMessageItem.static.NAME_COLOR, playerData[2].name, GuildMessageItem.static.NORMAL_COLOR)
    elseif data.type == "EXIT_SOCIETY" then
        str = playerData[1].name .. "退出了商业联盟"
    elseif data.type == "CREATE_SOCIETY" then
        str = playerData[1].name .. "创建了商业联盟"
    elseif data.type == "KICK_OUT_SOCIETY" then
        str = playerData[1].name .. "被" .. playerData[2].name .. "踢出了商业联盟"
    elseif data.type == "APPOINT_TO_MEMBER" then
        str = playerData[1].name .. "被" .. playerData[2].name .. "任命为成员"
    elseif data.type == "APPOINT_TO_CHAIRMAN" then
        str = playerData[1].name .. "被" .. playerData[2].name .. "任命为会长"
    elseif data.type == "APPOINT_TO_VICE_CHAIRMAN" then
        str = playerData[1].name .. "被" .. playerData[2].name .. "任命为副会长"
    elseif data.type == "APPOINT_TO_ADMINISTRATOR" then
        str = playerData[1].name .. "被" .. playerData[2].name .. "任命为管理"
    elseif data.type == "MODIFY_NAME" then
        str = playerData[1].name .. "修改了联盟名字"
    elseif data.type == "MODIFY_DECLARATION" then
        str = playerData[1].name .. "修改了商业宣言"
    elseif data.type == "MODIFY_INTRODUCTION" then
        str = playerData[1].name .. "修改了商业介绍"
    end
    self.describeText.text = str
end