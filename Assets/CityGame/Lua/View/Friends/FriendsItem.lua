---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/11/29 14:31
---

FriendsItem = class('FriendsItem')

-- 初始化
function FriendsItem:initialize(itemId, type, luaBehaviour, prefab, data)
    self.itemId = itemId
    self.prefab = prefab
    self.data = data
    --self.data.company = "Scry"
    self.data.sign = "Everything i do i wanna put a shine on it"

    local transform = prefab.transform
    self.bgBtn = transform:Find("Bg").gameObject
    self.headBtn = transform:Find("HeadBtn").gameObject
    -- 好友头像
    --self.headImage = transform:Find("HeadBtn/HeadImage"):GetComponent("Image")
    self.headImage = transform:Find("HeadBtn/HeadImage")
    -- 好友名
    self.nameText = transform:Find("NameText"):GetComponent("Text")
    -- 好友所在公司名字
    self.companyText = transform:Find("CompanyText"):GetComponent("Text")
    -- 好友签名
    self.signature = transform:Find("SignatureBg").gameObject
    self.signatureText = transform:Find("SignatureBg/SignatureText"):GetComponent("Text")
    -- 删除好友按钮
    self.deleteBtn = transform:Find("DeleteBtn").gameObject

    -- 解除屏蔽
    self.removeMaskBtn = transform:Find("RemoveMaskBtn").gameObject

    -- 加好友
    self.addFriendsBtn  = transform:Find("AddFriendsBtn").gameObject
    -- 发送私聊
    self.sendMsgBtn  = transform:Find("SendMsgBtn").gameObject

    -- 验证消息
    self.validation = transform:Find("ValidationImage").gameObject
    self.validationMsgText = transform:Find("ValidationImage/ValidationMsgText"):GetComponent("Text")
    -- 同意好友申请
    self.agreeBtn  = transform:Find("AgreeBtn").gameObject
    -- 拒绝好友申请
    self.refuseBtn  = transform:Find("RefuseBtn").gameObject

    --LoadSprite(PlayerHead[self.data.faceId].FriendsPath, self.headImage, true)
    --for i = 1, self.headImage.childCount do
    --    UnityEngine.GameObject.Destroy(self.headImage:GetChild(i-1).gameObject)
    --end
    self.avatarData = AvatarManger.GetSmallAvatar(self.data.faceId, self.headImage,0.2)
    self.nameText.text = self.data.name
    self.companyText.text = self.data.companyName
    if self.data.des == nil or self.data.des == "" then
        self.data.des = GetLanguage(13010003)  --默认值
    end
    self.signatureText.text = self.data.des
    if self.data.desc then
        self.validationMsgText.text = self.data.desc
    end

    -- 判断是否是自己的好友
    local friendsBasicData = DataManager.GetMyFriends()
    if friendsBasicData[data.id] == nil then
        self.isFriends = false
    else
        self.isFriends = true
    end

    if type == 1 then -- 好友主界面
        self.bgBtn:GetComponent("Button").interactable = true
        self.headBtn:GetComponent("Button").interactable = true
        self.signature:SetActive(true)
        self.deleteBtn:SetActive(false)
        self.removeMaskBtn:SetActive(false)
        self.validation:SetActive(false)
        self.addFriendsBtn:SetActive(false)
        self.sendMsgBtn:SetActive(false)
        self.agreeBtn:SetActive(false)
        self.refuseBtn:SetActive(false)

        self.bgBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.bgBtn, self.OnBg, self)
        self.headBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.headBtn, self.OnHead, self)
    elseif type == 2 then -- 好友管理
        self.bgBtn:GetComponent("Button").interactable = false
        self.headBtn:GetComponent("Button").interactable = false
        self.signature:SetActive(true)
        self.deleteBtn:SetActive(true)
        self.removeMaskBtn:SetActive(false)
        self.validation:SetActive(false)
        self.addFriendsBtn:SetActive(false)
        self.sendMsgBtn:SetActive(false)
        self.agreeBtn:SetActive(false)
        self.refuseBtn:SetActive(false)

        self.deleteBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.deleteBtn, self.OnDelete, self)

    elseif type == 3 then -- 黑名单
        self.bgBtn:GetComponent("Button").interactable = false
        self.headBtn:GetComponent("Button").interactable = false
        self.signature:SetActive(false)
        self.deleteBtn:SetActive(false)
        self.removeMaskBtn:SetActive(true)
        self.validation:SetActive(false)
        self.addFriendsBtn:SetActive(false)
        self.sendMsgBtn:SetActive(false)
        self.agreeBtn:SetActive(false)
        self.refuseBtn:SetActive(false)

        self.removeMaskBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.removeMaskBtn, self.OnRemoveMask, self)
    elseif type == 4 then -- 添加好友
        self.bgBtn:GetComponent("Button").interactable = false
        self.headBtn:GetComponent("Button").interactable = false
        self.signature:SetActive(false)
        self.deleteBtn:SetActive(false)
        self.removeMaskBtn:SetActive(false)
        self.validation:SetActive(false)
        self.addFriendsBtn:SetActive(true)
        self.sendMsgBtn:SetActive(true)
        self.agreeBtn:SetActive(false)
        self.refuseBtn:SetActive(false)

        self.sendMsgBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.sendMsgBtn, self.OnSendMsg, self)
        if self.isFriends then
            self.addFriendsBtn:GetComponent("Button").interactable = false
        else
            self.addFriendsBtn:GetComponent("Button").onClick:RemoveAllListeners()
            luaBehaviour:AddClick(self.addFriendsBtn, self.OnAddFriends, self)
        end
    elseif type == 5 then -- 申请列表
        self.bgBtn:GetComponent("Button").interactable = false
        self.headBtn:GetComponent("Button").interactable = false
        self.signature:SetActive(false)
        self.deleteBtn:SetActive(false)
        self.removeMaskBtn:SetActive(false)
        self.validation:SetActive(true)
        self.addFriendsBtn:SetActive(false)
        self.sendMsgBtn:SetActive(false)
        self.agreeBtn:SetActive(true)
        self.refuseBtn:SetActive(true)

        self.agreeBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.agreeBtn, self.OnAgree, self)
        self.refuseBtn:GetComponent("Button").onClick:RemoveAllListeners()
        luaBehaviour:AddClick(self.refuseBtn, self.OnRefuse, self)
    end
end

function FriendsItem:CloseAvatar()
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
end

function FriendsItem:OnBg(go)
    PlayMusEff(1002)
    ct.log("tina_w7_friends", "向好友发起聊天")
    ct.OpenCtrl("ChatCtrl", {toggleId = 2, id = go.data.id})
end

function FriendsItem:OnHead(go)
    PlayMusEff(1002)
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", go.data)
    ct.log("tina_w7_friends", "显示好友个人信息")
end

-- 删除好友
function FriendsItem:OnDelete(go)
    --打开弹框
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(13020002)
    data.contentInfo = GetLanguage(13020003, go.data.name)
    data.btnCallBack = function()
        ct.log("tina_w7_friends", "向服务器发送删除好友请求")
        Event.Brocast("m_DeleteFriend", go.data.id, false)
    end
    ct.OpenCtrl("BtnDialogPageCtrl", data)
end

-- 移除屏蔽
function FriendsItem:OnRemoveMask(go)
    --打开弹框
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(13030002)
    data.contentInfo = GetLanguage(13030003, go.data.name)
    data.btnCallBack = function()
        ct.log("tina_w7_friends", "向服务器发送移除屏蔽请求")
        Event.Brocast("m_DeleteBlacklist", go.data.id)
    end
    ct.OpenCtrl("BtnDialogPageCtrl", data)
end

-- 发送私聊
function FriendsItem:OnSendMsg(go)
    ct.log("tina_w8_friends", "向陌生人发起私聊")
    PlayMusEff(1002)
    FriendslistCtrl.static.isAddfriends = true
    if go.isFriends then
        ct.OpenCtrl("ChatCtrl", {toggleId = 2, id = go.data.id})
    else
        ct.OpenCtrl("ChatCtrl", {toggleId = 3, id = go.data.id})
    end
end

-- 加好友
function FriendsItem:OnAddFriends(go)
    PlayMusEff(1002)
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
            Event.Brocast("m_AddFriends", go.data.id, text)
            Event.Brocast("SmallPop", GetLanguage(13040004),80)
        end
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end

-- 同意好友申请
function FriendsItem:OnAgree(go)
    ct.log("tina_w8_friends", "向服务器发送同意好友申请请求")
    PlayMusEff(1002)
    Event.Brocast("m_AddFriendsReq", go.data.id, true)
    if FriendslistCtrl.friendInfo[go.itemId] then
        DataManager.SetMyFriendsApply({itemId = go.itemId})
        FriendslistCtrl:_refreshItem(#FriendslistCtrl.friendInfo)
        Event.Brocast("SmallPop", GetLanguage(13050002, go.data.name),80)
    end
end

-- 拒绝好友申请
function FriendsItem:OnRefuse(go)
    ct.log("tina_w8_friends", "向服务器发送拒绝好友申请请求")
    PlayMusEff(1002)
    Event.Brocast("m_AddFriendsReq", go.data.id, false)
    if FriendslistCtrl.friendInfo[go.itemId] then
        DataManager.SetMyFriendsApply({itemId = go.itemId})
        --table.remove(FriendslistCtrl.friendInfo, go.itemId)
        FriendslistCtrl:_refreshItem(#FriendslistCtrl.friendInfo)
        Event.Brocast("SmallPop", GetLanguage(13050003, go.data.name),80)
    end
end