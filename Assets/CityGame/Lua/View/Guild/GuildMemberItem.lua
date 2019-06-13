---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/21 15:40
---

GuildMemberItem = class("GuildMemberItem")
GuildMemberItem.static.NomalColor = Vector3.New(255, 255, 255) -- 默认的背景色
GuildMemberItem.static.OwnColor = Vector3.New(255, 247, 223) -- 自己的背景色
GuildMemberItem.static.SelectColor = Vector3.New(193, 201, 229) -- 被选中的背景色

function GuildMemberItem:initialize(prefab, data)
    self.prefab = prefab
    self.data = data

    local transform = prefab.transform
    self.memberHeadBg = transform:Find("MemberHeadBg")
    self.nameText = transform:Find("NameText"):GetComponent("Text")
    self.jobText = transform:Find("JobText"):GetComponent("Text")
    self.staffNumberText = transform:Find("StaffNumberText"):GetComponent("Text")
    self.joinTimeText = transform:Find("JoinTimeText"):GetComponent("Text")

    --self.nameText.text = self.data.id
    if self.data.identity == "CHAIRMAN" then
        self.jobText.text = GetLanguage( 12030001) -- "会长"
    elseif self.data.identity == "VICE_CHAIRMAN" then
        self.jobText.text = GetLanguage( 12030002) --"副会长"
    elseif self.data.identity == "ADMINISTRATOR" then
        self.jobText.text = GetLanguage( 12030003) -- "管理"
    elseif self.data.identity == "MEMBER" then
        self.jobText.text = GetLanguage( 12030004) -- "成员"
    end
    self.staffNumberText.text = self.data.staffCount
    local timeTab = getFormatUnixTime(self.data.joinTs/1000)
    self.joinTimeText.text = string.format("%s/%s/%s", timeTab.day, timeTab.month, timeTab.year)

    self.clickBtn = transform:Find("ClickBtn"):GetComponent("Button")
    self.clickImage = transform:Find("ClickBtn"):GetComponent("Image")

    PlayerInfoManger.GetInfos({data.id}, self._showNameHead, self)

    -- 自己的背景色为浅黄色且不能点击
    if data.id ==DataManager.GetMyOwnerID() then
        self:_setClickImageColor(false)
        self:_setButtonInteractable(false)
    else
        self:_setClickImageColor(true)
        self:_setButtonInteractable(true)
        self.clickBtn.onClick:RemoveAllListeners()
        self.clickBtn.onClick:AddListener(function ()
            self:_openMenu()
        end)
    end
end

-- 点击成员item打开操作菜单
function GuildMemberItem:_openMenu()
    local position = self.prefab.transform.position
    GuildOwnCtrl.static.guildMgr:ShowGuildMenu(position)
    GuildOwnCtrl.static.guildMgr:SetSelectMemberItem(self)
    --GuildOwnCtrl.static.guildMgr:SetIdentity()
    self:_setButtonInteractable(false)
end

-- 设置item的背景色
function GuildMemberItem:_setClickImageColor(isDefault)
    if isDefault then
        self.clickImage.color = getColorByVector3(GuildMemberItem.static.NomalColor)
    else
        self.clickImage.color = getColorByVector3(GuildMemberItem.static.OwnColor)
    end
end

-- 设置item是否能点击
function GuildMemberItem:_setButtonInteractable(isinteractable)
    self.clickBtn.interactable = isinteractable
end

-- 显示成员头像名字等基本信息
function GuildMemberItem:_showNameHead(playerData)
    self.nameText.text = playerData[1].name
    self.data.playerData = playerData[1]
    self.avatarData = AvatarManger.GetSmallAvatar(playerData[1].faceId, self.memberHeadBg,0.2)
end

-- 删除头像
function GuildMemberItem:CloseAvatar()
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
end