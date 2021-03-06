---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/19 15:27
---

GuildOwnCtrl = class("GuildOwnCtrl", UIPanel)
UIPanel:ResgisterOpen(GuildOwnCtrl)

function GuildOwnCtrl:initialize(go)
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GuildOwnCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GuildOwnPanel.prefab"
end

function GuildOwnCtrl:OnCreate(go)
    UIPanel.OnCreate(self, go)

    GuildOwnCtrl.luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.backBtn, function ()
        PlayMusEff(1002)
        UIPanel.ClosePage()
    end)

    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.modifyNameBtn.gameObject, self.OnModifyName, self)
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.modifyIntroductionBtn.gameObject, self.OnModifyIntroduction, self)
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.modifyDeclarationBtn.gameObject, self.OnModifyDeclaration, self)
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.moreActionBtn, self.OnMoreAction, self)
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.staffNumberBtn, self.OnStaffNumber, self)
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.joinTimeBtn, self.OnJoinTime, self)
    GuildOwnCtrl.luaBehaviour:AddClick(GuildOwnPanel.menuRoot.gameObject, self.OnClickMenu, self)
end

function GuildOwnCtrl:Awake()
    -- Initialization manager
    GuildOwnCtrl.static.guildMgr = GuildMgr:new()
    -- Initialize the item tab
    GuildOwnCtrl.static.guildMemberTab = {}

    self.guildMemberSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.guildMemberSource.mProvideData = GuildOwnCtrl.static.GuildProvideData
    self.guildMemberSource.mClearData = GuildOwnCtrl.static.GuildClearData
end

function GuildOwnCtrl:Active()
    UIPanel.Active(self)
    self:_addListener()

    -- multi-language
    GuildOwnPanel.memberTitleText.text = GetLanguage(12020001)
    GuildOwnPanel.jobTitleText.text = GetLanguage(12020002)
    GuildOwnPanel.staffNumberBtnText.text = GetLanguage(12020003)
    GuildOwnPanel.joinTimeBtnText.text = GetLanguage(12020005)

    GuildOwnCtrl.static.guildMgr:SetLanguage()
end

-- Listen to the model layer network callback
function GuildOwnCtrl:_addListener()
    Event.AddListener("c_GetSocietyInfo", self.c_GetSocietyInfo, self)
    Event.AddListener("c_ModifySocietyName", self.c_ModifySocietyName, self)
    Event.AddListener("c_ModifyIntroduction", self.c_ModifyIntroduction, self)
    Event.AddListener("c_ModifyDeclaration", self.c_ModifyDeclaration, self)
    Event.AddListener("c_KickMember", self.c_KickMember, self)
    Event.AddListener("c_AppointerPost", self.c_AppointerPost, self)
    Event.AddListener("c_OwnDelJoinReq", self.c_OwnDelJoinReq, self)
    Event.AddListener("c_OwnNewJoinReq", self.c_OwnNewJoinReq, self)
    Event.AddListener("c_OwnSociety", self.c_OwnSociety, self)
    Event.AddListener("c_MemberChanges", self.c_MemberChanges, self)
end

--Cancel the model layer network callback
function GuildOwnCtrl:_removeListener()
    Event.RemoveListener("c_GetSocietyInfo", self.c_GetSocietyInfo, self)
    Event.RemoveListener("c_ModifySocietyName", self.c_ModifySocietyName, self)
    Event.RemoveListener("c_ModifyIntroduction", self.c_ModifyIntroduction, self)
    Event.RemoveListener("c_ModifyDeclaration", self.c_ModifyDeclaration, self)
    Event.RemoveListener("c_KickMember", self.c_KickMember, self)
    Event.RemoveListener("c_AppointerPost", self.c_AppointerPost, self)
    Event.RemoveListener("c_OwnDelJoinReq", self.c_OwnDelJoinReq, self)
    Event.RemoveListener("c_OwnNewJoinReq", self.c_OwnNewJoinReq, self)
    Event.RemoveListener("c_OwnSociety", self.c_OwnSociety, self)
    Event.RemoveListener("c_MemberChanges", self.c_MemberChanges, self)
end

function GuildOwnCtrl:Refresh()
    self:initInsData()
    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
    local societyInfo = DataManager.GetGuildInfo()
    if societyInfo then
        self:c_GetSocietyInfo(societyInfo)
    end
    --self:_clickHomepage()
end

-- Open model
function GuildOwnCtrl:initInsData()
    DataManager.OpenDetailModel(GuildOwnModel, OpenModelInsID.GuildOwnCtrl)
end

function GuildOwnCtrl:Hide()
    self:_removeListener()
    UIPanel.Hide(self)
end

-- Whether to display the red dot prompt
function GuildOwnCtrl:_showNotice()
    local societyInfo = DataManager.GetGuildInfo()
    if societyInfo then
        if societyInfo.reqs and societyInfo.reqs[1] then
            GuildOwnPanel.moreActionNotice.localScale = Vector3.one
        else
            GuildOwnPanel.moreActionNotice.localScale = Vector3.zero
        end
    end
end

--Determine whether to display the modify button
function GuildOwnCtrl:_showModifyBtn(ownIdentity)
    if ownIdentity == "MEMBER" then
        GuildOwnPanel.modifyNameBtn.localScale = Vector3.zero
        GuildOwnPanel.modifyIntroductionBtn.localScale = Vector3.zero
        GuildOwnPanel.modifyDeclarationBtn.localScale = Vector3.zero
    else
        GuildOwnPanel.modifyNameBtn.localScale = Vector3.one
        GuildOwnPanel.modifyIntroductionBtn.localScale = Vector3.one
        GuildOwnPanel.modifyDeclarationBtn.localScale = Vector3.one
    end
end

--Change the name of the guild
function GuildOwnCtrl:OnModifyName(go)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(12050002)
    data.tipInfo = GetLanguage(18010012)
    data.inputDefaultStr = GetLanguage(12060019)
    data.characterLimit = 7
    data.btnCallBack = function(str)
        if str == "" or str == nil then
            str = GetLanguage(12060022)
            Event.Brocast("SmallPop",str,80)
        elseif string.len(str) > 21 then
            str = GetLanguage(12060023)
            Event.Brocast("SmallPop",str,80)
        else
            DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_ModifySocietyName", {societyId = DataManager.GetGuildID(), str = str})
        end
    end
    ct.OpenCtrl("CompanyInputCtrl",data)
    --ct.OpenCtrl("LongInputDialogPageCtrl", {placeholderContent = GetLanguage(12060019), btnCallBack = function (str)
    --    if str == "" or str == nil then
    --        str = GetLanguage(12060022)
    --        Event.Brocast("SmallPop",str,80)
    --    elseif string.len(str) > 21 then
    --        str = GetLanguage(12060023)
    --        Event.Brocast("SmallPop",str,80)
    --    else
    --        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_ModifySocietyName", {societyId = DataManager.GetGuildID(), str = str})
    --    end
    --
    --end})
end

-- Reform Guild Introduction
function GuildOwnCtrl:OnModifyIntroduction(go)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(12010008)
    --data.tipInfo = GetLanguage(18010012)
    data.inputDefaultStr = GetLanguage(12060020)
    data.characterLimit = 10
    data.btnCallBack = function(str)
        if str == "" or str == nil then
            str = GetLanguage(12060024)
            Event.Brocast("SmallPop",str,80)
        elseif string.len(str) > 30 then
            str = GetLanguage(12060025)
            Event.Brocast("SmallPop",str,80)
        else
            DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_ModifyIntroduction", {societyId = DataManager.GetGuildID(), str = str})
        end
    end
    ct.OpenCtrl("CompanyInputCtrl",data)
    --ct.OpenCtrl("LongInputDialogPageCtrl", {placeholderContent = GetLanguage(12060020), btnCallBack = function (str)
    --    if str == "" or str == nil then
    --        str = GetLanguage(12060024)
    --        Event.Brocast("SmallPop",str,80)
    --    elseif string.len(str) > 30 then
    --        str = GetLanguage(12060025)
    --        Event.Brocast("SmallPop",str,80)
    --    else
    --        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_ModifyIntroduction", {societyId = DataManager.GetGuildID(), str = str})
    --    end
    --end})
end

--Reform Association Declaration
function GuildOwnCtrl:OnModifyDeclaration(go)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(12060041)
    data.inputDefaultStr = GetLanguage(12060021)
    data.characterLimit = 60
    data.btnCallBack = function(str)
        if str == "" or str == nil then
            str = GetLanguage(12060026)
            Event.Brocast("SmallPop",str,80)
        elseif string.len(str) > 180 then
            str = GetLanguage(12060042)
            Event.Brocast("SmallPop",str,80)
        else
            DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_ModifyDeclaration", {societyId = DataManager.GetGuildID(), str = str})
        end
    end
    ct.OpenCtrl("BigInputCtrl",data)
    --ct.OpenCtrl("BigInputCtrl", {btnCallBack = function (str)
    --    if str == "" or str == nil then
    --        str = GetLanguage(12060026)
    --        Event.Brocast("SmallPop",str,80)
    --    elseif string.len(str) > 100 then
    --        str = GetLanguage(12060027)
    --        Event.Brocast("SmallPop",str,80)
    --    else
    --        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildOwnCtrl, "m_ModifyDeclaration", {societyId = DataManager.GetGuildID(), str = str})
    --    end
    --end})
end

-- Open the Guild Information Panel
function GuildOwnCtrl:OnMoreAction(go)
    PlayMusEff(1002)
    ct.OpenCtrl("GuildMessageCtrl")
end

-- Click the number of employees sort button
function GuildOwnCtrl:OnStaffNumber(go)
    PlayMusEff(1002)
    if GuildOwnCtrl.rankId == 1 then
        GuildOwnCtrl.rankId = 2
        GuildOwnPanel.staffNumberBtnOpen.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnClose.localScale =Vector3.one
        GuildOwnPanel.staffNumberBtnDefault1.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnDefault2.localScale =Vector3.zero

        GuildOwnPanel.joinTimeBtnOpen.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnClose.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnDefault1.localScale =Vector3.one
        GuildOwnPanel.joinTimeBtnDefault2.localScale =Vector3.one
    else
        GuildOwnCtrl.rankId = 1
        GuildOwnPanel.staffNumberBtnOpen.localScale =Vector3.one
        GuildOwnPanel.staffNumberBtnClose.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnDefault1.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnDefault2.localScale =Vector3.zero

        GuildOwnPanel.joinTimeBtnOpen.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnClose.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnDefault1.localScale =Vector3.one
        GuildOwnPanel.joinTimeBtnDefault2.localScale =Vector3.one
    end
    go:_sort(GuildOwnCtrl.rankId)
end

-- Click the Join Time Sort button
function GuildOwnCtrl:OnJoinTime(go)
    PlayMusEff(1002)
    if GuildOwnCtrl.rankId == 3 then
        GuildOwnCtrl.rankId = 4
        GuildOwnPanel.staffNumberBtnOpen.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnClose.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnDefault1.localScale =Vector3.one
        GuildOwnPanel.staffNumberBtnDefault2.localScale =Vector3.one

        GuildOwnPanel.joinTimeBtnOpen.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnClose.localScale =Vector3.one
        GuildOwnPanel.joinTimeBtnDefault1.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnDefault2.localScale =Vector3.zero
    else
        GuildOwnCtrl.rankId = 3
        GuildOwnPanel.staffNumberBtnOpen.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnClose.localScale =Vector3.zero
        GuildOwnPanel.staffNumberBtnDefault1.localScale =Vector3.one
        GuildOwnPanel.staffNumberBtnDefault2.localScale =Vector3.one

        GuildOwnPanel.joinTimeBtnOpen.localScale =Vector3.one
        GuildOwnPanel.joinTimeBtnClose.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnDefault1.localScale =Vector3.zero
        GuildOwnPanel.joinTimeBtnDefault2.localScale =Vector3.zero
    end
    go:_sort(GuildOwnCtrl.rankId)
end

-- Close menu
function GuildOwnCtrl:OnClickMenu(go)
    GuildOwnCtrl.static.guildMgr:SetClickInteractable()
    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)

end

--Data sorting and displaying guild members
function GuildOwnCtrl:_sort(rankId)
    if GuildOwnCtrl.societyMembers == nil then
        return
    end

    if rankId == 1 then
        table.sort(GuildOwnCtrl.societyMembers, function (m, n) return m.staffCount < n.staffCount end)
    elseif rankId == 2 then
        table.sort(GuildOwnCtrl.societyMembers, function (m, n) return m.staffCount > n.staffCount end)
    elseif rankId == 3 then
        table.sort(GuildOwnCtrl.societyMembers, function (m, n) return m.joinTs < n.joinTs end)
    elseif rankId == 4 then
        table.sort(GuildOwnCtrl.societyMembers, function (m, n) return m.joinTs > n.joinTs end)
    end
    GuildOwnPanel.guildMemberScroll:ActiveLoopScroll(self.guildMemberSource, #GuildOwnCtrl.societyMembers, "View/Guild/GuildMemberItem")
    GuildOwnPanel.guildMemberScroll:RefillCells()
end

-- Sliding multiplexing
GuildOwnCtrl.static.GuildProvideData = function(transform, idx)
    idx = idx + 1
    local transformId = transform:GetInstanceID()
    if GuildOwnCtrl.static.guildMemberTab[transformId] then
        GuildOwnCtrl.static.guildMemberTab[transformId]:CloseAvatar()
    end
    GuildOwnCtrl.static.guildMemberTab[transformId] = GuildMemberItem:new(transform, GuildOwnCtrl.societyMembers[idx])
end

GuildOwnCtrl.static.GuildClearData = function(transform)

end

-- Network callback
-- Display basic information
function GuildOwnCtrl:c_GetSocietyInfo(societyInfo)
    GuildOwnPanel.guildNameText.text = societyInfo.name
    if societyInfo.declaration == "" then
        GuildOwnPanel.declarationText.text = GetLanguage(12060044)
    else
        GuildOwnPanel.declarationText.text = societyInfo.declaration
    end
    GuildOwnPanel.introduceText.text = societyInfo.introduction

    GuildOwnCtrl.societyMembers = societyInfo.members
    GuildOwnPanel.guildMemberScroll:ActiveLoopScroll(self.guildMemberSource, #GuildOwnCtrl.societyMembers, "View/Guild/GuildMemberItem")

    if societyInfo.reqs and societyInfo.reqs[1] then
        GuildOwnPanel.moreActionNotice.localScale = Vector3.one
    else
        GuildOwnPanel.moreActionNotice.localScale = Vector3.zero
    end
    --societyInfo.members[1].staffCount = 1
    --societyInfo.members[2].staffCount = 2

    GuildOwnPanel.staffNumberBtnOpen.localScale =Vector3.zero
    GuildOwnPanel.staffNumberBtnClose.localScale =Vector3.zero
    GuildOwnPanel.staffNumberBtnDefault1.localScale =Vector3.one
    GuildOwnPanel.staffNumberBtnDefault2.localScale =Vector3.one

    GuildOwnPanel.joinTimeBtnOpen.localScale =Vector3.zero
    GuildOwnPanel.joinTimeBtnClose.localScale =Vector3.zero
    GuildOwnPanel.joinTimeBtnDefault1.localScale =Vector3.one
    GuildOwnPanel.joinTimeBtnDefault2.localScale =Vector3.one

    local ownIdentity = DataManager.GetOwnGuildIdentity()
    self:_showModifyBtn(ownIdentity)
    GuildOwnCtrl.static.guildMgr:SetOwnGuildIdentity(ownIdentity)
end

-- change name
function GuildOwnCtrl:c_ModifySocietyName(bytesStrings)
    GuildOwnPanel.guildNameText.text = bytesStrings.str
    if bytesStrings.createId and bytesStrings.createId == DataManager.GetMyOwnerID() then
        Event.Brocast("SmallPop",GetLanguage(12060028),80)
    end
end

-- Change introduction
function GuildOwnCtrl:c_ModifyIntroduction(bytesStrings)
    GuildOwnPanel.introduceText.text = bytesStrings.str
    if bytesStrings.createId and bytesStrings.createId == DataManager.GetMyOwnerID() then
        Event.Brocast("SmallPop",GetLanguage(12060029),80)
    end
end

-- Change declaration
function GuildOwnCtrl:c_ModifyDeclaration(bytesStrings)
    GuildOwnPanel.declarationText.text = bytesStrings.str
    if bytesStrings.createId and bytesStrings.createId == DataManager.GetMyOwnerID() then
        Event.Brocast("SmallPop",GetLanguage(12060004),80)
    end
end

-- Kick back
function GuildOwnCtrl:c_KickMember(ids)
    Event.Brocast("SmallPop",GetLanguage(12060010),80)
end

--Return of appointment
function GuildOwnCtrl:c_AppointerPost(appointerReq)
    if appointerReq.identity == "CHAIRMAN" then
        Event.Brocast("SmallPop",GetLanguage(12060030),80)
    else
        Event.Brocast("SmallPop",GetLanguage(12060012),80)
    end
end

-- Delete processed membership requests
function GuildOwnCtrl:c_OwnDelJoinReq(joinReq)
    self:_showNotice()
end

-- New membership request
function GuildOwnCtrl:c_OwnNewJoinReq(joinReq)
    self:_showNotice()
end

-- Return from the Guild
function GuildOwnCtrl:c_OwnSociety(byteBool)
    UIPanel.ClosePage()
    if byteBool.b then -- Quit yourself
        Event.Brocast("SmallPop",GetLanguage(12060031),80)
    else --Kicked
        --Open the bullet box
        local showData = {}
        showData.titleInfo = GetLanguage(12010014)
        showData.contentInfo = GetLanguage(12060032)
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
    end
end

-- Member change
function GuildOwnCtrl:c_MemberChanges(memberChanges)
    for i, v in ipairs(memberChanges.changeLists) do
        if v.type == "IDENTITY" then
            if v.playerId == DataManager.GetMyOwnerID() then
                GuildOwnCtrl.static.guildMgr:SetOwnGuildIdentity(v.identity)
                self:_showModifyBtn(v.identity)
                GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
                GuildOwnCtrl.static.guildMgr:SetClickInteractable()
            else
                if v.playerId == GuildOwnCtrl.static.guildMgr:GetPlayerId() then
                    GuildOwnCtrl.static.guildMgr:SetGuildMenuShow(false)
                    GuildOwnCtrl.static.guildMgr:SetClickInteractable()
                end
            end
        end
    end
    GuildOwnPanel.guildMemberScroll:ActiveLoopScroll(self.guildMemberSource, #GuildOwnCtrl.societyMembers, "View/Guild/GuildMemberItem")
end