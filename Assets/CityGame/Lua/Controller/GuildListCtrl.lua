---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/16 16:31
---

GuildListCtrl = class("GuildListCtrl", UIPanel)
UIPanel:ResgisterOpen(GuildListCtrl)

function GuildListCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GuildListCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GuildListPanel.prefab"
end

function GuildListCtrl:OnCreate(go)
    ct.log("tina_w30_guild", "GuildListCtrl:OnCreate")
    UIPanel.OnCreate(self, go)

    GuildListCtrl.luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    GuildListCtrl.luaBehaviour:AddClick(GuildListPanel.backBtn, function ()
        PlayMusEff(1002)
        UIPanel.ClosePage()
    end)

    GuildListCtrl.luaBehaviour:AddClick(GuildListPanel.memberNumberBtn, self.OnMemberNumber, self)
    GuildListCtrl.luaBehaviour:AddClick(GuildListPanel.createBtn, self.OnClickCreate, self)
    GuildListCtrl.luaBehaviour:AddClick(GuildListPanel.createBackBtn, self.OnClickCreateBack, self)
    GuildListCtrl.luaBehaviour:AddClick(GuildListPanel.sureBtn, self.OnSure, self)
    GuildListCtrl.luaBehaviour:AddClick(GuildListPanel.timeBtn, self.OnTime, self)

    --GuildListPanel.listToggle.onValueChanged:AddListener(function (isOn)
    --    ct.log("tina_w30_guild", "值改变了" .. tostring(isOn))
    --end)

end

function GuildListCtrl:Awake(go)
    GuildListCtrl.static.guildTab = {}
    ct.log("tina_w30_guild", "GuildListCtrl:Awake")
    self.guildSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.guildSource.mProvideData = GuildListCtrl.static.GuildProvideData
    self.guildSource.mClearData = GuildListCtrl.static.GuildClearData
end

function GuildListCtrl:Active()
    ct.log("tina_w30_guild", "GuildListCtrl:Active")
    UIPanel.Active(self)
    self:_addListener()
    GuildListPanel.createRoot.localScale =Vector3.zero
end

-- 监听Model层网络回调
function GuildListCtrl:_addListener()
    Event.AddListener("c_OnSocietyList", self.c_OnSocietyList, self)
    Event.AddListener("c_OnSocietyInfo", self.c_OnSocietyInfo, self)
    Event.AddListener("c_JoinHandle", self.c_JoinHandle, self)
    Event.AddListener("c_OnJoinSociety", self.c_OnJoinSociety, self)
end

--注销model层网络回调h
function GuildListCtrl:_removeListener()
    Event.RemoveListener("c_OnSocietyList", self.c_OnSocietyList, self)
    Event.RemoveListener("c_OnSocietyInfo", self.c_OnSocietyInfo, self)
    Event.RemoveListener("c_JoinHandle", self.c_JoinHandle, self)
    Event.RemoveListener("c_OnJoinSociety", self.c_OnJoinSociety, self)
end

function GuildListCtrl:Refresh()
    ct.log("tina_w30_guild", "GuildListCtrl:Refresh")
    self:initInsData()
    self:_showView()
end

function GuildListCtrl:initInsData()
    DataManager.OpenDetailModel(GuildListModel, OpenModelInsID.GuildListCtrl)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildListCtrl, 'm_GetSocietyList')
end

function GuildListCtrl:Hide()
    GuildListPanel.guildListScroll:RefillCells()
    GuildListCtrl.societyList = nil
    GuildListCtrl.rankId = nil
    self:_removeListener()
    UIPanel.Hide(self)
end

function GuildListCtrl:_showView()
    local societyId = DataManager.GetGuildID()
    if societyId then
        GuildListPanel.createBtn:SetActive(false)
        GuildListPanel.guildListView.offsetMin = Vector2.New(0,0)
    else
        GuildListPanel.createBtn:SetActive(true)
        GuildListPanel.guildListView.offsetMin = Vector2.New(0,100)
    end
end

function GuildListCtrl:OnMemberNumber(go)
    PlayMusEff(1002)
    if GuildListCtrl.rankId == 1 then
        GuildListCtrl.rankId = 2
        GuildListPanel.memberNumberBtnOpen.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnClose.localScale =Vector3.one
        GuildListPanel.memberNumberBtnDefault1.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnDefault2.localScale =Vector3.zero

        GuildListPanel.timeBtnOpen.localScale =Vector3.zero
        GuildListPanel.timeBtnClose.localScale =Vector3.zero
        GuildListPanel.timeBtnDefault1.localScale =Vector3.one
        GuildListPanel.timeBtnDefault2.localScale =Vector3.one
    else
        GuildListCtrl.rankId = 1
        GuildListPanel.memberNumberBtnOpen.localScale =Vector3.one
        GuildListPanel.memberNumberBtnClose.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnDefault1.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnDefault2.localScale =Vector3.zero

        GuildListPanel.timeBtnOpen.localScale =Vector3.zero
        GuildListPanel.timeBtnClose.localScale =Vector3.zero
        GuildListPanel.timeBtnDefault1.localScale =Vector3.one
        GuildListPanel.timeBtnDefault2.localScale =Vector3.one
    end
    go:_sort(GuildListCtrl.rankId)
end

function GuildListCtrl:OnTime(go)
    PlayMusEff(1002)
    if GuildListCtrl.rankId == 3 then
        GuildListCtrl.rankId = 4
        GuildListPanel.memberNumberBtnOpen.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnClose.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnDefault1.localScale =Vector3.one
        GuildListPanel.memberNumberBtnDefault2.localScale =Vector3.one

        GuildListPanel.timeBtnOpen.localScale =Vector3.zero
        GuildListPanel.timeBtnClose.localScale =Vector3.one
        GuildListPanel.timeBtnDefault1.localScale =Vector3.zero
        GuildListPanel.timeBtnDefault2.localScale =Vector3.zero
    else
        GuildListCtrl.rankId = 3
        GuildListPanel.memberNumberBtnOpen.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnClose.localScale =Vector3.zero
        GuildListPanel.memberNumberBtnDefault1.localScale =Vector3.one
        GuildListPanel.memberNumberBtnDefault2.localScale =Vector3.one

        GuildListPanel.timeBtnOpen.localScale =Vector3.one
        GuildListPanel.timeBtnClose.localScale =Vector3.zero
        GuildListPanel.timeBtnDefault1.localScale =Vector3.zero
        GuildListPanel.timeBtnDefault2.localScale =Vector3.zero
    end
    go:_sort(GuildListCtrl.rankId)
end

function GuildListCtrl:_sort(rankId)
    if GuildListCtrl.societyList == nil then
        return
    end

    if rankId == 1 then
        table.sort(GuildListCtrl.societyList, function (m, n) return m.allCount < n.allCount end)
    elseif rankId == 2 then
        table.sort(GuildListCtrl.societyList, function (m, n) return m.allCount > n.allCount end)
    elseif rankId == 3 then
        table.sort(GuildListCtrl.societyList, function (m, n) return m.createTs < n.createTs end)
    elseif rankId == 4 then
        table.sort(GuildListCtrl.societyList, function (m, n) return m.createTs > n.createTs end)
    end
    GuildListPanel.guildListScroll:ActiveLoopScroll(self.guildSource, #GuildListCtrl.societyList, "View/Guild/GuildItem")
    GuildListPanel.guildListScroll:RefillCells()
end

function GuildListCtrl:OnClickCreate(go)
    GuildListPanel.createRoot.localScale =Vector3.one
end

function GuildListCtrl:OnClickCreateBack(go)
    GuildListPanel.createRoot.localScale =Vector3.zero
end

function GuildListCtrl:OnSure(go)
    local guildNameInputText = GuildListPanel.guildNameInput.text
    local describeInputText = GuildListPanel.describeInput.text
    if string.len(guildNameInputText) == 0 or guildNameInputText == "" or string.len(describeInputText) == 0 or describeInputText == "" then
        Event.Brocast("SmallPop", GetLanguage(15010017),80)
        return
    elseif string.len(guildNameInputText) > 13 then
        Event.Brocast("SmallPop",GetLanguage(15010018),80)
        return
    elseif string.len(describeInputText) > 100 then
        Event.Brocast("SmallPop",GetLanguage(15010018),80)
        return
    end

    GuildListPanel.createRoot.localScale =Vector3.zero

    --打开弹框
    local showData = {}
    showData.titleInfo = "提示"
    showData.contentInfo = "确定创建公会?"
    showData.tipInfo = ""
    showData.btnCallBack = function()
        DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildListCtrl, 'm_CreateSociety', {name = guildNameInputText, declaration = describeInputText})
    end
    ct.OpenCtrl("BtnDialogPageCtrl", showData)
end

-- 滑动复用
GuildListCtrl.static.GuildProvideData = function(transform, idx)
    idx = idx + 1
    local transformId = transform:GetInstanceID()
    if GuildListCtrl.static.guildTab[transformId] then
        GuildListCtrl.static.guildTab[transformId]:CloseAvatar()
    end
    GuildListCtrl.static.guildTab[transformId] = GuildItem:new(transform, GuildListCtrl.societyList[idx])
end

GuildListCtrl.static.GuildClearData = function(transform)

end

-- 网络回调
function GuildListCtrl:c_OnSocietyList(societyList)
    if societyList.listInfo then
        GuildListCtrl.societyList = societyList.listInfo
        GuildListPanel.guildListScroll:ActiveLoopScroll(self.guildSource, #GuildListCtrl.societyList, "View/Guild/GuildItem")

        if GuildListCtrl.rankId then
            self:_sort(GuildListCtrl.rankId)
        else
            GuildListPanel.memberNumberBtnOpen.localScale =Vector3.zero
            GuildListPanel.memberNumberBtnClose.localScale =Vector3.zero
            GuildListPanel.memberNumberBtnDefault1.localScale =Vector3.one
            GuildListPanel.memberNumberBtnDefault2.localScale =Vector3.one

            GuildListPanel.timeBtnOpen.localScale =Vector3.zero
            GuildListPanel.timeBtnClose.localScale =Vector3.zero
            GuildListPanel.timeBtnDefault1.localScale =Vector3.one
            GuildListPanel.timeBtnDefault2.localScale =Vector3.one
        end
    else

    end
end

function GuildListCtrl:c_OnSocietyInfo(societyInfo)
    Event.Brocast("SmallPop","创建公会成功！",80)
    DataManager.SetGuildID(societyInfo.id)
    DataManager.SetGuildInfo(societyInfo)
    UIPanel.ClosePage()
    ct.OpenCtrl("GuildOwnCtrl")
end

-- 申请加入公会通过
function GuildListCtrl:c_JoinHandle(societyInfo)
    UIPanel.ClosePage()
    ct.OpenCtrl("GuildOwnCtrl")

    --打开弹框
    local showData = {}
    showData.titleInfo = "提示"
    showData.contentInfo = "申请商业联盟通过"
    showData.tipInfo = ""
    ct.OpenCtrl("BtnDialogPageCtrl", showData)
end

-- 申请加入公会失败
function GuildListCtrl:c_OnJoinSociety()
    Event.Brocast("SmallPop", "申请失败，该联盟已解散！",80)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildListCtrl, 'm_GetSocietyList')
end