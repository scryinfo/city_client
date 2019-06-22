---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/19 11:23
---

-- 联盟界面的Item
GuildItem = class("GuildItem")

function GuildItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform
    self.leaderHeadBg = transform:Find("LeaderHeadBg")
    self.nameText = transform:Find("NameText"):GetComponent("Text")
    self.leaderNameText = transform:Find("LeaderNameText"):GetComponent("Text")
    self.memberNumberText = transform:Find("MemberNumberText"):GetComponent("Text")
    self.timeText = transform:Find("TimeText"):GetComponent("Text")
    self.introductionText = transform:Find("IntroductionText"):GetComponent("Text")
    self.applyBtn = transform:Find("ApplyBtn"):GetComponent("Button")
    transform:Find("ApplyBtn/Text"):GetComponent("Text").text = GetLanguage(12010009)

    self.nameText.text = self.data.name

    self.memberNumberText.text = self.data.allCount
    local timeTab = getFormatUnixTime(self.data.createTs/1000)
    self.timeText.text = string.format("%s/%s/%s", timeTab.day, timeTab.month, timeTab.year)
    self.introductionText.text = self.data.introduction

    PlayerInfoManger.GetInfos({data.chairmanId}, self._showNameHead, self)

    local societyId = DataManager.GetGuildID()
    if societyId then
        self.applyBtn.gameObject:SetActive(false)
    else
        self.applyBtn.gameObject:SetActive(true)
        self.applyBtn.onClick:RemoveAllListeners()
        self.applyBtn.onClick:AddListener(function ()
            self:_applyGuild()
        end)
    end
end

-- 申请加入公会
function GuildItem:_applyGuild()
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(12010010)
    data.tipInfo = GetLanguage(12010011)
    data.inputInfo = GetLanguage(12060043)
    data.btnCallBack = function(text)
        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildListCtrl, 'm_JoinSociety', { id = self.data.id, desc = text })
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end

-- 显示头像
function GuildItem:_showNameHead(playerData)
    self.leaderNameText.text = playerData[1].name
    self.avatarData = AvatarManger.GetSmallAvatar(playerData[1].faceId, self.leaderHeadBg,0.2)
end

-- 删除头像
function GuildItem:CloseAvatar()
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
end