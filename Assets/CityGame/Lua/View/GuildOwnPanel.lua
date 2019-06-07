---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/2/19 15:26
---

local transform

GuildOwnPanel = {}
local this = GuildOwnPanel

function GuildOwnPanel.Awake(obj)
    transform = obj.transform

    this.InitPanel()
end

function GuildOwnPanel.InitPanel()
    this.backBtn = transform:Find("TopRoot/BackBtn").gameObject

    -- 联盟首页
    this.guildNameText = transform:Find("TopRoot/Bg1/GuildNameText"):GetComponent("Text")
    this.introduceText = transform:Find("TopRoot/Bg1/IntroduceText"):GetComponent("Text")
    this.declarationText = transform:Find("TopRoot/Bg2/DeclarationText"):GetComponent("Text")
    this.guildMemberScroll = transform:Find("MiddleRoot/Scroll View"):GetComponent("ActiveLoopScrollRect")

    -- 改名字、改介绍、改宣言
    this.modifyNameBtn = transform:Find("TopRoot/Bg1/ModifyNameBtn")
    this.modifyIntroductionBtn = transform:Find("TopRoot/Bg1/ModifyIntroductionBtn")
    this.modifyDeclarationBtn = transform:Find("TopRoot/Bg2/ModifyDeclarationBtn")

    -- 打开联盟信息
    this.moreActionBtn = transform:Find("TopRoot/MoreActionBtn").gameObject
    this.moreActionNotice = transform:Find("TopRoot/MoreActionBtn/Notice")

    -- 菜单节点
    this.menuRoot = transform:Find("MenuRoot")

    -- 排序
    this.staffNumberBtn = transform:Find("MiddleRoot/SortRoot/StaffNumberBtn").gameObject
    this.staffNumberBtnOpen = transform:Find("MiddleRoot/SortRoot/StaffNumberBtn/Open")
    this.staffNumberBtnClose = transform:Find("MiddleRoot/SortRoot/StaffNumberBtn/Close")
    this.staffNumberBtnDefault1 = transform:Find("MiddleRoot/SortRoot/StaffNumberBtn/Default1")
    this.staffNumberBtnDefault2 = transform:Find("MiddleRoot/SortRoot/StaffNumberBtn/Default2")

    this.joinTimeBtn = transform:Find("MiddleRoot/SortRoot/JoinTimeBtn").gameObject
    this.joinTimeBtnOpen = transform:Find("MiddleRoot/SortRoot/JoinTimeBtn/Open")
    this.joinTimeBtnClose = transform:Find("MiddleRoot/SortRoot/JoinTimeBtn/Close")
    this.joinTimeBtnDefault1 = transform:Find("MiddleRoot/SortRoot/JoinTimeBtn/Default1")
    this.joinTimeBtnDefault2 = transform:Find("MiddleRoot/SortRoot/JoinTimeBtn/Default2")

    -- 多语言
    this.memberTitleText = transform:Find("MiddleRoot/SortRoot/MemberTitleText"):GetComponent("Text")
    this.jobTitleText = transform:Find("MiddleRoot/SortRoot/JobTitleText"):GetComponent("Text")
    this.staffNumberBtnText = transform:Find("MiddleRoot/SortRoot/StaffNumberBtn/Text"):GetComponent("Text")
    this.joinTimeBtnText = transform:Find("MiddleRoot/SortRoot/JoinTimeBtn/Text"):GetComponent("Text")
end