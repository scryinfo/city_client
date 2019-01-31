---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/27 11:25
---个人主页弹窗
PersonalHomeDialogPageCtrl = class('PersonalHomeDialogPageCtrl',UIPanel)
UIPanel:ResgisterOpen(PersonalHomeDialogPageCtrl) --注册打开的方法

function PersonalHomeDialogPageCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function PersonalHomeDialogPageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PersonalHomeDialogPagePanel.prefab"
end

function PersonalHomeDialogPageCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function PersonalHomeDialogPageCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_initData()

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.bgCloseBtn.gameObject, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.changeSayBtn.gameObject, self._changeDesFunc, self)
    self.luaBehaviour:AddClick(self.addFriendBtn.gameObject, self._reqAddFriend, self)
    self.luaBehaviour:AddClick(self.sendMessageBtn.gameObject, self._strangerChatBtnFunc, self)
    self.luaBehaviour:AddClick(self.friendSendMessageBtn.gameObject, self._friendChatBtnFunc, self)
    self.luaBehaviour:AddClick(self.companyBtn.gameObject, self._companyBtnFunc, self)
end

function PersonalHomeDialogPageCtrl:Active()
    UIPanel.Active(self)
    self.titleText.text = GetLanguage(16010001)
end

function PersonalHomeDialogPageCtrl:Refresh()
    self:_initData()
end

function PersonalHomeDialogPageCtrl:Close()
    UIPanel.Close(self)
end
---寻找组件
function PersonalHomeDialogPageCtrl:_getComponent(go)
    self.closeBtn = go.transform:Find("root/topBg/closeBtn")
    self.bgCloseBtn = go.transform:Find("bgCloseBtn")
    self.roleProtaitImg = go.transform:Find("root/Image"):GetComponent("Image")
    self.sayText = go.transform:Find("root/sayRoot/sayText"):GetComponent("Text")
    self.changeSayBtn = go.transform:Find("root/sayRoot/changeBtn")
    self.nameText = go.transform:Find("root/infoRoot/name/nameText"):GetComponent("Text")
    self.famaleTran = go.transform:Find("root/infoRoot/name/nameText/famale")
    self.maleTran = go.transform:Find("root/infoRoot/name/nameText/male")
    self.companyText = go.transform:Find("root/infoRoot/company/companyText"):GetComponent("Text")
    self.companyBtn = go.transform:Find("root/infoRoot/company")

    self.otherOpen = go.transform:Find("root/otherOpen")
    self.strangerOtherTran = go.transform:Find("root/otherOpen/stranger")
    self.addFriendBtn = go.transform:Find("root/otherOpen/stranger/addFriendBtn")
    self.sendMessageBtn = go.transform:Find("root/otherOpen/stranger/sendMessageBtn")

    self.friendOtherTran = go.transform:Find("root/otherOpen/friends")
    self.friendSendMessageBtn = go.transform:Find("root/otherOpen/friends/sendMessageBtn")  --如果是好友则只能聊天，不能再加好友

    --多语言
    self.titleText = go.transform:Find("root/topBg/Text"):GetComponent("Text")
end
---初始化
function PersonalHomeDialogPageCtrl:_initData()
    if self.m_data.id ~= DataManager.GetMyOwnerID() then
        self.otherOpen.localScale = Vector3.one
        self.changeSayBtn.localScale = Vector3.zero
        local friendsBasicData = DataManager.GetMyFriends()
        if friendsBasicData[self.m_data.id] == nil then
            self.friendOtherTran.localScale = Vector3.zero
            self.strangerOtherTran.localScale = Vector3.one
        else
            self.friendOtherTran.localScale = Vector3.one
            self.strangerOtherTran.localScale = Vector3.zero
        end

        if self.m_data.des == nil or self.m_data.des == "" then
            self.m_data.des = GetLanguage(12010003)  --默认值
        end
    else
        self.otherOpen.localScale = Vector3.zero
        self.changeSayBtn.localScale = Vector3.one

        if self.m_data.des == nil or self.m_data.des == "" then
            self.m_data.des = GetLanguage(4301013)  --默认值
        end
    end

    if self.m_data.male == false then
        self.famaleTran.localScale = Vector3.one
        self.maleTran.localScale = Vector3.zero
    else
        self.famaleTran.localScale = Vector3.zero
        self.maleTran.localScale = Vector3.one
    end

    self.sayText.text = self.m_data.des
    self.nameText.text = self.m_data.name
    self.nameText.rectTransform.sizeDelta = Vector2.New(self.nameText.preferredWidth + 45, self.nameText.rectTransform.sizeDelta.y)  --加一个性别图片的宽度
    self.companyText.text = self.m_data.companyName
    LoadSprite(PlayerHead[self.m_data.faceId].PersonHomepagePath, self.roleProtaitImg, true)
end
---点击关闭按钮
function PersonalHomeDialogPageCtrl:_onClickClose(ins)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--修改des
function PersonalHomeDialogPageCtrl:_changeDesFunc(ins)
    PlayMusEff(1002)
    ct.OpenCtrl("LongInputDialogPageCtrl", {btnCallBack = function (str)
        if str ~= "" and str ~= nil then
            ins:_reqChangeDesToServer(str)
            ins.sayText.text = str
            DataManager.SetMyPersonalHomepageDesInfo(str)
        end
    end})
end
--请求加好友
function PersonalHomeDialogPageCtrl:_reqAddFriend(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(12040002)
    data.tipInfo = GetLanguage(12040003)
    data.inputInfo = "I am a good boy"
    data.btnCallBack = function(text)
        Event.Brocast("m_ChatAddFriends", { id = ins.m_data.id, desc = text })
        Event.Brocast("SmallPop", GetLanguage(12040004), 80)
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end
--好友私聊
function PersonalHomeDialogPageCtrl:_friendChatBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.isOpenChat == nil or ins.m_data.isOpenChat == false then
        ct.OpenCtrl("ChatCtrl", {toggleId = 2, id = ins.m_data.id})
    end
    UIPanel.ClosePage()
end
--陌生人私聊
function PersonalHomeDialogPageCtrl:_strangerChatBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.isOpenChat == nil or ins.m_data.isOpenChat == false then
        ct.OpenCtrl("ChatCtrl", {toggleId = 3, id = ins.m_data.id})
    end
    UIPanel.ClosePage()
end
--公司
function PersonalHomeDialogPageCtrl:_companyBtnFunc(ins)
    PlayMusEff(1002)
    UIPanel.ClosePage()
    ct.OpenCtrl("CompanyCtrl", ins.m_data)
end
--
function PersonalHomeDialogPageCtrl:_reqChangeDesToServer(str)
    local msgId = pbl.enum("gscode.OpCode","setRoleDescription")
    local lMsg = {str = str}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end