---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/28 15:26
---

GuildMenu = class("GuildMenu")
GuildMenu.static.NomalColor = Vector3.New(19, 27, 56) -- 默认的背景色
GuildMenu.static.SelectColor = Vector3.New(46, 58, 100) -- 被选中的背景色
GuildMenu.static.IdentityTable = -- 不同职位的匹配
{
    ["MEMBER"] = {index = 1},
    ["ADMINISTRATOR"] = {index = 2},
    ["VICE_CHAIRMAN"] = {index = 3},
    ["CHAIRMAN"] = {index = 4},
}

function GuildMenu:initialize(prefab)
    self.prefab = prefab
    local transform = prefab.transform

    self.outBtn = transform:Find("OutBtn")
    self.outBtnText = transform:Find("OutBtn/Text"):GetComponent("Text")
    self.appointBtn = transform:Find("AppointBtn")
    self.appointImage = transform:Find("AppointBtn"):GetComponent("Image")
    self.appointBtnText = transform:Find("AppointBtn/Text"):GetComponent("Text")
    self.addFriendsBtn = transform:Find("AddFriendsBtn"):GetComponent("Button")
    self.addFriendsBtnRt = transform:Find("AddFriendsBtn"):GetComponent("RectTransform")
    self.addFriendsBtnText = transform:Find("AddFriendsBtn/Text"):GetComponent("Text")
    self.personalDataButton = transform:Find("PersonalDataButton"):GetComponent("Button")
    self.personalDataButtonRt = transform:Find("PersonalDataButton"):GetComponent("RectTransform")
    self.personalDataButtonText = transform:Find("PersonalDataButton/Text"):GetComponent("Text")
    self.appointRoot = transform:Find("AppointRoot")
    self.appointRootRt = transform:Find("AppointRoot"):GetComponent("RectTransform")
    self.identity4Btn = transform:Find("AppointRoot/Identity4Btn").gameObject
    self.identity4BtnText = transform:Find("AppointRoot/Identity4Btn/Text"):GetComponent("Text")
    self.identity3Btn = transform:Find("AppointRoot/Identity3Btn").gameObject
    self.identity3BtnText = transform:Find("AppointRoot/Identity3Btn/Text"):GetComponent("Text")
    self.identity2Btn = transform:Find("AppointRoot/Identity2Btn").gameObject
    self.identity2BtnText = transform:Find("AppointRoot/Identity2Btn/Text"):GetComponent("Text")
    self.identity1Btn = transform:Find("AppointRoot/Identity1Btn").gameObject
    self.identity1BtnText = transform:Find("AppointRoot/Identity1Btn/Text"):GetComponent("Text")

    self:SetAppointRoot(false)
    self:_SetLanguage()

    self.outBtn:GetComponent("Button").onClick:AddListener(function ()
        self:_onOut()
    end)
    self.appointBtn:GetComponent("Button").onClick:AddListener(function ()
        self:_onAppoint()
    end)
    self.addFriendsBtn.onClick:AddListener(function ()
        self:_onAddFriends()
    end)
    self.personalDataButton.onClick:AddListener(function ()
        self:_onPersonalData()
    end)
    self.identity4Btn:GetComponent("Button").onClick:AddListener(function ()
        self:_onAppointerPost(0)
    end)
    self.identity3Btn:GetComponent("Button").onClick:AddListener(function ()
        self:_onAppointerPost(2)
    end)
    self.identity2Btn:GetComponent("Button").onClick:AddListener(function ()
        self:_onAppointerPost(3)
    end)
    self.identity1Btn:GetComponent("Button").onClick:AddListener(function ()
        self:_onAppointerPost(1)
    end)
end

-- 设置任命面板是否显示
function GuildMenu:SetAppointRoot(isShow)
    if isShow then
        self.appointRoot.localScale = Vector3.one
    else
        self.appointRoot.localScale = Vector3.zero
    end
end

-- 设置操作菜单是否显示
function GuildMenu:SetPrefabShow(isShow)
    self.prefab:SetActive(isShow)
end

-- 设置任命的按钮的颜色
function GuildMenu:SetAppointImageColor(isShow)
    if isShow then
        self.appointImage.color = getColorByVector3(GuildMenu.static.NomalColor, 230)
    else
        self.appointImage.color = getColorByVector3(GuildMenu.static.SelectColor, 230)
    end
end

-- 点击踢出按钮
function GuildMenu:_onOut()
    PlayMusEff(1002)
    --self:SetPrefabShow(false)
    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
    GuildOwnCtrl.static.guildMgr:SetClickInteractable()
    --打开弹框
    local showData = {}
    showData.titleInfo = GetLanguage(12010014)
    showData.contentInfo = GetLanguage(12060034)
    showData.tipInfo = ""
    showData.btnCallBack = function()
        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_KickMember", {societyId = DataManager.GetGuildID(), playerId = GuildOwnCtrl.static.guildMgr:GetPlayerId()})
    end
    ct.OpenCtrl("BtnDialogPageCtrl", showData)
end

-- 点击任命按钮
function GuildMenu:_onAppoint()
    PlayMusEff(1002)
    self:SetAppointRoot(true)
    self:SetAppointImageColor(false)
end

-- 点击加好友按钮
function GuildMenu:_onAddFriends()
    PlayMusEff(1002)
    --self:SetPrefabShow(false)
    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
    GuildOwnCtrl.static.guildMgr:SetClickInteractable()
    local data = {}
    data.titleInfo = GetLanguage(13040002)
    data.tipInfo = GetLanguage(13040003)
    data.inputInfo = GetLanguage(15010023)
    data.btnCallBack = function(text)
        ct.log("tina_w8_friends", "向服务器发送加好友信息")
        if string.len(text) > 30 then
            text = GetLanguage(13040006)
            Event.Brocast("SmallPop",text,80)
        else
            DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_AddFriends", { id = GuildOwnCtrl.static.guildMgr:GetPlayerId(), desc = text })
            Event.Brocast("SmallPop", GetLanguage(13040004),80)
        end
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end

-- 显示个人信息
function GuildMenu:_onPersonalData()
    PlayMusEff(1002)
    --self:SetPrefabShow(false)
    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
    GuildOwnCtrl.static.guildMgr:SetClickInteractable()
    local playerInfo = GuildOwnCtrl.static.guildMgr:GetPlayerData().playerData
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", playerInfo)
end

-- 任命某职位
function GuildMenu:_onAppointerPost(index)
    PlayMusEff(1002)
    --self:SetPrefabShow(false)
    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
    GuildOwnCtrl.static.guildMgr:SetClickInteractable()
    --打开弹框
    local tips
    if index == 0 then
        tips = GetLanguage(12060033)
    elseif index == 1 then
        tips = GetLanguage(12060035)
    elseif index == 2 then
        tips = GetLanguage(12060036)
    elseif index == 3 then
        tips = GetLanguage(12060037)
    end
    local showData = {}
    showData.titleInfo = GetLanguage(12010014)
    showData.contentInfo = tips
    showData.tipInfo = ""
    showData.btnCallBack = function()
        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_AppointerPost", {societyId = DataManager.GetGuildID(), playerId = GuildOwnCtrl.static.guildMgr:GetPlayerId(), identity = index})
    end
    ct.OpenCtrl("BtnDialogPageCtrl", showData)
end

-- 设置可任命的具体职位
function GuildMenu:_SetIdentity()
    local playerDataIndex = GuildMenu.static.IdentityTable[GuildOwnCtrl.static.guildMgr:GetPlayerData().identity].index
    local ownIdentityIndex = GuildMenu.static.IdentityTable[GuildOwnCtrl.static.guildMgr:GetOwnGuildIdentity()].index
    if playerDataIndex < ownIdentityIndex then
        if ownIdentityIndex == GuildMenu.static.IdentityTable["ADMINISTRATOR"].index then
            self.outBtn.localScale  = Vector3.one
            self.appointBtn.localScale  = Vector3.zero

            -- 判断是否是自己的好友
            local friendsBasicData = DataManager.GetMyFriends()
            if friendsBasicData[GuildOwnCtrl.static.guildMgr:GetPlayerId()] == nil then
                self.addFriendsBtnRt.localScale = Vector3.one
                self.addFriendsBtnRt.anchoredPosition = Vector2.New(0, 152)
                self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 254)
            else  -- 是好友
                self.addFriendsBtnRt.localScale = Vector3.zero
                self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 152)
            end
        else
            self.outBtn.localScale  = Vector3.one
            self.appointBtn.localScale  = Vector3.one

            -- 判断是否是自己的好友
            local friendsBasicData = DataManager.GetMyFriends()
            if friendsBasicData[GuildOwnCtrl.static.guildMgr:GetPlayerId()] == nil then
                self.addFriendsBtnRt.localScale = Vector3.one
                self.addFriendsBtnRt.anchoredPosition = Vector2.New(0, 254)
                self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 356)
                self.appointRootRt.anchoredPosition = Vector2.New(212, 406)
            else
                self.addFriendsBtnRt.localScale = Vector3.zero
                self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 254)
                self.appointRootRt.anchoredPosition = Vector2.New(212, 304)
            end

            if ownIdentityIndex == 4 then  -- 自己是主席
                self.identity4Btn:SetActive(true)
                self.identity3Btn:SetActive(true)
                self.identity2Btn:SetActive(true)
                self.identity1Btn:SetActive(true)
                self["identity".. tostring(playerDataIndex) .. "Btn"]:SetActive(false)
            else
                for i = 1, 4 do
                    if i == playerDataIndex then
                        self["identity".. tostring(i) .. "Btn"]:SetActive(false)
                    elseif i >= ownIdentityIndex then
                        self["identity".. tostring(i) .. "Btn"]:SetActive(false)
                    else
                        self["identity".. tostring(i) .. "Btn"]:SetActive(true)
                    end
                end
            end
        end
    else
        self.outBtn.localScale  = Vector3.zero
        self.appointBtn.localScale  = Vector3.zero

        -- 判断是否是自己的好友
        local friendsBasicData = DataManager.GetMyFriends()
        if friendsBasicData[GuildOwnCtrl.static.guildMgr:GetPlayerId()] == nil then
            self.addFriendsBtnRt.localScale = Vector3.one
            self.addFriendsBtnRt.anchoredPosition = Vector2.New(0, 50)
            self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 152)
        else
            self.addFriendsBtnRt.localScale = Vector3.zero
            self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 50)
        end
        --self.personalDataButtonRt.anchoredPosition = Vector2.New(0, 152)
    end
end

-- 设置多语言
function GuildMenu:_SetLanguage()
    self.outBtnText.text = GetLanguage(12060008)
    self.appointBtnText.text = GetLanguage(12060007)
    self.addFriendsBtnText.text = GetLanguage(12060006)
    self.personalDataButtonText.text = GetLanguage(12060005)
    self.identity4BtnText.text = GetLanguage(12030001)
    self.identity3BtnText.text = GetLanguage(12030002)
    self.identity2BtnText.text = GetLanguage(12030003)
    self.identity1BtnText.text = GetLanguage(12030004)
end