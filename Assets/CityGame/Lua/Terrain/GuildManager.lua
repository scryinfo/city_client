---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/25 19:27
---

GuildManager = class('GuildManager')

function GuildManager:initialize()
end

-- 向服务器发消息查询消息
function GuildManager:InitGuildInfo(societyId)
    DataManager.ModelSendNetMes("gscode.OpCode", "getSocietyInfo", "gs.Id", {id = societyId})
end

-- 把整个工会的消息保存下来
function GuildManager:SetGuildInfo(societyInfo)
    self.guildInfo = societyInfo
end

-- 获得整个工会的消息
function GuildManager:GetGuildInfo()
    return self.guildInfo
end

-- 删除已处理的入会请求
function GuildManager:DeleteGuildJoinReq(joinReq)
    for i, v in ipairs(self.guildInfo.reqs) do
        if v.playerId == joinReq.playerId then
            table.remove(self.guildInfo.reqs, i)
            break
        end
    end
end

-- 新增成员
function GuildManager:SetGuildMember(memberChanges)
    table.insert(self.guildInfo.members, memberChanges)
    self.guildInfo.allCount = #self.guildInfo.members
end

-- 设置公会通知
function GuildManager:SetGuildNotice(societyNotice)
    table.insert(self.guildInfo.notice, societyNotice)
end

-- 新增入会请求
function GuildManager:SetGuildJoinReq(joinReq)
    if not self.guildInfo.reqs then
        self.guildInfo.reqs = {}
    end
    -- 同一个人的申请只能存在一条
    for i, v in ipairs(self.guildInfo.reqs) do
        if v.playerId == joinReq.playerId then
            table.remove(self.guildInfo.reqs, i)
            break
        end
    end
    table.insert(self.guildInfo.reqs, joinReq)
end

-- 获得自己公会的职位
function GuildManager:GetOwnGuildIdentity(ownerId)
    for _, v in ipairs(self.guildInfo.members) do
        if v.id == ownerId then
            return v.identity
        end
    end
end

-- 删除成员
function GuildManager:DeleteGuildMember(playerId)
    if not self.guildInfo then
        return
    end
    for i, v in ipairs(self.guildInfo.members) do
        if v.id == playerId then
            table.remove(self.guildInfo.members, i)
            break
        end
    end
    self.guildInfo.allCount = #self.guildInfo.members
end

-- 刷新成员上下线状态
function GuildManager:SetGuildMemberOnline(playerId, online)
    if not self.guildInfo then
        return
    end
    for i, v in ipairs(self.guildInfo.members) do
        if v.id == playerId then
            v.online = online
            break
        end
    end
end

-- 刷新成员权限
function GuildManager:SetGuildMemberIdentity(playerId, identity)
    if not self.guildInfo then
        return
    end
    for i, v in ipairs(self.guildInfo.members) do
        if v.id == playerId then
            v.identity = identity
            if v.identity == "CHAIRMAN" then
                self.guildInfo.chairmanId = playerId
            end
            break
        end
    end
end

-- 设置名字
function GuildManager:SetGuildSocietyName(bytesStrings)
    self.guildInfo.name = bytesStrings.str
end

-- 设置介绍
function GuildManager:SetGuildIntroduction(bytesStrings)
    self.guildInfo.introduction = bytesStrings.str
end

-- 设置宣言
function GuildManager:SetGuildDeclaration(bytesStrings)
    self.guildInfo.declaration = bytesStrings.str
end

-- 获得公会成员
function GuildManager:GetGuildMembers()
    return self.guildInfo.members
end