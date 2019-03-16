---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/26 18:34
---



GuildApplyItem = class("GuildApplyItem")

function GuildApplyItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform
    self.headImage = transform:Find("HeadBtn")
    self.nameText = transform:Find("NameText"):GetComponent("Text")
    self.companyText = transform:Find("CompanyText"):GetComponent("Text")
    self.validationMsgText = transform:Find("ValidationImage/ValidationMsgText"):GetComponent("Text")
    self.agreeBtn = transform:Find("AgreeBtn"):GetComponent("Button")
    self.refuseBtn = transform:Find("RefuseBtn"):GetComponent("Button")


    self.validationMsgText.text = self.data.description

    PlayerInfoManger.GetInfos({data.playerId}, self._showNameHead, self)

    self.agreeBtn.onClick:RemoveAllListeners()
    self.agreeBtn.onClick:AddListener(function ()
        self:_agreeGuildApplay()
    end)

    self.refuseBtn.onClick:RemoveAllListeners()
    self.refuseBtn.onClick:AddListener(function ()
        self:_refuseGuildApplay()
    end)
end

function GuildApplyItem:_agreeGuildApplay()
    PlayMusEff(1002)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildApplyCtrl, 'm_JoinHandle', { societyId = self.data.societyId, playerId = self.data.playerId, isAgree = true })
end

function GuildApplyItem:_refuseGuildApplay()
    PlayMusEff(1002)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildApplyCtrl, 'm_JoinHandle', { societyId = self.data.societyId, playerId = self.data.playerId, isAgree = false })
end

function GuildApplyItem:_showNameHead(playerData)
    self.nameText.text = playerData.name
    self.companyText.text = playerData.companyName
    self.avatarData = AvatarManger.GetSmallAvatar(playerData.faceId, self.headImage,0.2)
end

function GuildApplyItem:CloseAvatar()
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
end