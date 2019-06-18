---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/26 15:30
---

GuildMessageCtrl = class("GuildMessageCtrl", UIPanel)
UIPanel:ResgisterOpen(GuildMessageCtrl)

function GuildMessageCtrl:initialize(go)
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GuildMessageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GuildMessagePanel.prefab"
end

function GuildMessageCtrl:OnCreate(go)
    UIPanel.OnCreate(self, go)

    GuildMessageCtrl.luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")
    GuildMessageCtrl.luaBehaviour:AddClick(GuildMessagePanel.backBtn, function ()
        PlayMusEff(1002)
        UIPanel.ClosePage()
    end)

    GuildMessageCtrl.luaBehaviour:AddClick(GuildMessagePanel.guildListBtn, self.OnGuildList, self)
    GuildMessageCtrl.luaBehaviour:AddClick(GuildMessagePanel.applyListBtn.gameObject, self.OnApplyList, self)
    GuildMessageCtrl.luaBehaviour:AddClick(GuildMessagePanel.quitBtn, self.OnQuit, self)
end

function GuildMessageCtrl:Awake()
    self.guildNoticeSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.guildNoticeSource.mProvideData = GuildMessageCtrl.static.GuildNoticeProvideData
    self.guildNoticeSource.mClearData = GuildMessageCtrl.static.GuildNoticeClearData

    self.m_data = {}
    self.m_data.insId = OpenModelInsID.GuildMessageCtrl
end

function GuildMessageCtrl:Active()
    UIPanel.Active(self)
    self:_addListener()

    -- 多语言
    GuildMessagePanel.memberTitleText.text = GetLanguage(12010006)
    GuildMessagePanel.timeTitleText.text = GetLanguage(12040002)
    GuildMessagePanel.messageTitleText.text = GetLanguage(12040003)
end

-- 监听Model层网络回调
function GuildMessageCtrl:_addListener()
    Event.AddListener("c_MessageAdd", self.c_MessageAdd, self)
    Event.AddListener("c_ExitSociety", self.c_ExitSociety, self)
    Event.AddListener("c_MessageDelJoinReq", self.c_MessageDelJoinReq, self)
    Event.AddListener("c_MessageNewJoinReq", self.c_MessageNewJoinReq, self)
end

--注销model层网络回调h
function GuildMessageCtrl:_removeListener()
    Event.RemoveListener("c_MessageAdd", self.c_MessageAdd, self)
    Event.RemoveListener("c_ExitSociety", self.c_ExitSociety, self)
    Event.RemoveListener("c_MessageDelJoinReq", self.c_MessageDelJoinReq, self)
    Event.RemoveListener("c_MessageNewJoinReq", self.c_MessageNewJoinReq, self)
end

function GuildMessageCtrl:Refresh()
    self:initInsData()
    self:_showView()
end

-- 打开model
function GuildMessageCtrl:initInsData()
    DataManager.OpenDetailModel(GuildMessageModel, OpenModelInsID.GuildMessageCtrl)
end

function GuildMessageCtrl:Hide()
    self:_removeListener()
    UIPanel.Hide(self)
end

-- 显示界面各项信息
function GuildMessageCtrl:_showView()
    local societyInfo = DataManager.GetGuildInfo()
    if societyInfo then
        -- 显示公会的名字
        GuildMessagePanel.guildNameText.text = societyInfo.name
        -- 显示公会的人数
        GuildMessagePanel.memberNumberText.text = societyInfo.allCount
        -- 显示公会的时间
        local timeTab = getFormatUnixTime(societyInfo.createTs/1000)
        GuildMessagePanel.timeText.text = string.format("%s/%s/%s", timeTab.day, timeTab.month, timeTab.year)
        -- 显示公会的消息提示
        GuildMessageCtrl.societyNotice = societyInfo.notice
        GuildMessagePanel.guildInfoScroll:ActiveLoopScroll(self.guildNoticeSource, #GuildMessageCtrl.societyNotice, "View/Guild/GuildMessageItem")
        -- 显示公会的红点提示
        self:_showNotice()
    end
    local ownIdentity = GuildOwnCtrl.static.guildMgr:GetOwnGuildIdentity()
    if ownIdentity == "MEMBER" then
        GuildMessagePanel.applyListBtn.localScale = Vector3.zero
    else
        GuildMessagePanel.applyListBtn.localScale = Vector3.one
    end
end

-- 是否显示申请红点
function GuildMessageCtrl:_showNotice()
    local societyInfo = DataManager.GetGuildInfo()
    if societyInfo then
        if societyInfo.reqs and societyInfo.reqs[1] then
            GuildMessagePanel.applyListNotice.localScale = Vector3.one
        else
            GuildMessagePanel.applyListNotice.localScale = Vector3.zero
        end
    end
end

-- 显示消息提示
function GuildMessageCtrl:_showScroll(playerData)
    GuildMessagePanel.guildInfoScroll:ActiveLoopScroll(self.guildNoticeSource, #GuildMessageCtrl.societyNotice, "View/Guild/GuildMessageItem")
end

-- 打开公会列表界面
function GuildMessageCtrl:OnGuildList(go)
    ct.OpenCtrl("GuildListCtrl")
end

-- 打开公会申请界面
function GuildMessageCtrl:OnApplyList(go)
    ct.OpenCtrl("GuildApplyCtrl")
end

-- 点击退出按钮
function GuildMessageCtrl:OnQuit(go)
    local ownIdentity = GuildOwnCtrl.static.guildMgr:GetOwnGuildIdentity()
    local societyInfoMembers = DataManager.GetGuildMembers()
    if ownIdentity == "CHAIRMAN" and #societyInfoMembers ~= 1 then
        --打开弹框
        local showData = {}
        showData.titleInfo = "提示"
        showData.contentInfo = "转让主席后才可退出联盟！"
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
    else
        --打开弹框
        local showData = {}
        showData.titleInfo = "提示"
        showData.contentInfo = "确定退出联盟?"
        showData.tipInfo = ""
        showData.btnCallBack = function()
            DataManager.DetailModelRpcNoRet(OpenModelInsID.GuildMessageCtrl, "m_ExitSocietye", {id = DataManager.GetGuildID()})
        end
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
    end
end

-- 滑动复用
GuildMessageCtrl.static.GuildNoticeProvideData = function(transform, idx)
    idx = idx + 1
    GuildMessageItem:new(transform, GuildMessageCtrl.societyNotice[idx])
end

GuildMessageCtrl.static.GuildNoticeClearData = function(transform)

end

-- 网络回调
-- 新增提示
function GuildMessageCtrl:c_MessageAdd(societyNotice)
    --local idTemp = {}
    --if societyNotice.createId then
    --    table.insert(idTemp, societyNotice.createId)
    --end
    --if societyNotice.affectedId then
    --    table.insert(idTemp, societyNotice.affectedId)
    --end
    --if idTemp[1] then
    --    PlayerInfoManger.GetInfos(idTemp, self._showScroll, self)
    --end
    GuildMessagePanel.guildInfoScroll:ActiveLoopScroll(self.guildNoticeSource, #GuildMessageCtrl.societyNotice, "View/Guild/GuildMessageItem")
end

-- 退出公会返回
function GuildMessageCtrl:c_ExitSociety(byteBool)
    UIPanel.CloseAllPageExceptMain()
    if byteBool.b then -- 自己主动退出
        Event.Brocast("SmallPop","退出联盟成功！",80)
    else -- 被踢
        --打开弹框
        local showData = {}
        showData.titleInfo = "提示"
        showData.contentInfo = "申请商业联盟通过"
        showData.tipInfo = ""
        ct.OpenCtrl("BtnDialogPageCtrl", showData)
    end
end

-- 删除已处理的入会请求
function GuildMessageCtrl:c_MessageDelJoinReq(joinReq)
    self:_showNotice()
end

-- 新增入会请求
function GuildMessageCtrl:c_MessageNewJoinReq(joinReq)
    self:_showNotice()
end

-- 成员变更
function GuildMessageCtrl:c_MemberChanges(memberChanges)
    for _, v in ipairs(memberChanges.changeLists) do
        if v.type == "IDENTITY" and v.playerId == DataManager.GetMyOwnerID() then
            if v.identity == "MEMBER" then
                GuildMessagePanel.applyListBtn.localScale = Vector3.zero
            else
                GuildMessagePanel.applyListBtn.localScale = Vector3.one
            end
        end
    end
end