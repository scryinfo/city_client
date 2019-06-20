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

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.bgCloseBtn.gameObject, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.changeSayBtn.gameObject, self._changeDesFunc, self)
    self.luaBehaviour:AddClick(self.addFriendBtn.gameObject, self._reqAddFriend, self)
    self.luaBehaviour:AddClick(self.sendMessageBtn.gameObject, self._strangerChatBtnFunc, self)
    self.luaBehaviour:AddClick(self.friendSendMessageBtn.gameObject, self._friendChatBtnFunc, self)
    self.luaBehaviour:AddClick(self.companyBtn.gameObject, self._companyBtnFunc, self)
    self.luaBehaviour:AddClick(self.avatarBtn.gameObject, self._avatarBtnFunc, self)
    self.luaBehaviour:AddClick(self.nameBtn.gameObject, self._nameBtnFunc, self)
    self.luaBehaviour:AddClick(self.moneyBtn.gameObject, self._moneyBtnFunc, self)
end

function PersonalHomeDialogPageCtrl:Active()
    UIPanel.Active(self)
    self.titleText.text = GetLanguage(17010001)

    Event.AddListener("updatePlayerName",self.updateNameFunc,self)
end

function PersonalHomeDialogPageCtrl:Refresh()
    self:_initData()
end

function PersonalHomeDialogPageCtrl:Close()
    UIPanel.Close(self)
end

function PersonalHomeDialogPageCtrl:Hide()
    UIPanel.Hide(self)
    if self.playerAvatar then
        AvatarManger.CollectAvatar(self.playerAvatar)
    end
    Event.RemoveListener("updatePlayerName",self.updateNameFunc,self)
end
---寻找组件
function PersonalHomeDialogPageCtrl:_getComponent(go)
    local trans = go.transform
    self.closeBtn = go.transform:Find("root/topBg/closeBtn")
    self.avatarBtn = go.transform:Find("root/avatarBtn"):GetComponent("Button")
    self.bgCloseBtn = trans:Find("bgCloseBtn")
    self.roleProtaitImg = trans:Find("root/avatarBtn")
    self.sayText = trans:Find("root/sayRoot/sayText"):GetComponent("Text")
    self.changeSayBtn = trans:Find("root/sayRoot/changeBtn")
    self.nameText = trans:Find("root/infoRoot/name/nameText"):GetComponent("Text")
    self.nameBtn = trans:Find("root/infoRoot/name"):GetComponent("Button")
    self.nameIconTran = trans:Find("root/infoRoot/name/iconImg")
    self.famaleTran = trans:Find("root/infoRoot/name/nameText/famale")
    self.maleTran = trans:Find("root/infoRoot/name/nameText/male")
    self.companyText = trans:Find("root/infoRoot/company/companyText"):GetComponent("Text")
    self.companyBtn = trans:Find("root/infoRoot/company")
    self.moneyRoot = trans:Find("root/moneyRoot")
    self.moneyBtn = trans:Find("root/moneyRoot/btn")
    self.moneyText = trans:Find("root/moneyRoot/Text"):GetComponent("Text")

    self.otherOpen = trans:Find("root/otherOpen")
    self.strangerOtherTran = trans:Find("root/otherOpen/stranger")
    self.addFriendBtn = trans:Find("root/otherOpen/stranger/addFriendBtn")
    self.sendMessageBtn = trans:Find("root/otherOpen/stranger/sendMessageBtn")

    self.friendOtherTran = trans:Find("root/otherOpen/friends")
    self.friendSendMessageBtn = trans:Find("root/otherOpen/friends/sendMessageBtn")  --如果是好友则只能聊天，不能再加好友

    --多语言
    self.titleText = trans:Find("root/topBg/Text"):GetComponent("Text")
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
            self.m_data.des = GetLanguage(17020007)  --默认值
        end

        --
        self.moneyRoot.localScale = Vector3.zero
        self.nameBtn.interactable = false
        self.avatarBtn.interactable = false
        self.nameIconTran.localScale = Vector3.zero
        self.playerAvatar = AvatarManger.GetBigAvatar(self.m_data.faceId,self.roleProtaitImg.transform,1.0)
    else
        self.otherOpen.localScale = Vector3.zero
        self.changeSayBtn.localScale = Vector3.one

        if self.m_data.des == nil or self.m_data.des == "" then
            self.m_data.des = GetLanguage(17010004)  --默认值
        end

        self.moneyRoot.localScale = Vector3.one
        self.nameBtn.interactable = true
        self.avatarBtn.interactable = true
        self.nameIconTran.localScale = Vector3.one
        self.playerAvatar = AvatarManger.GetBigAvatar(DataManager.GetFaceId(),self.roleProtaitImg.transform,1.0)
        self.moneyText.text = string.format("E%s", DataManager.GetMoneyByString())
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
    self.nameText.rectTransform.sizeDelta = Vector2.New(self.nameText.preferredWidth + 50, self.nameText.rectTransform.sizeDelta.y)  --加一个性别图片的宽度
    self.companyText.text = self.m_data.companyName
end
--刷新玩家名字
function PersonalHomeDialogPageCtrl:updateNameFunc(str)
    self.nameText.text = str
    self.nameText.rectTransform.sizeDelta = Vector2.New(self.nameText.preferredWidth + 50, self.nameText.rectTransform.sizeDelta.y)  --加一个性别图片的宽度
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
        if str == "" or str == nil then
            str = GetLanguage(17020007)
        end
        ins:_reqChangeDesToServer(str)
        DataManager.SetMyPersonalHomepageDesInfo(str)

        ins.sayText.text = ins.m_data.des
        --if ins.m_data.id == DataManager.GetMyOwnerID() then
        --    ins.m_data.des = GetLanguage(4301013)  --默认值
        --end
        ins.sayText.text = str
    end})
end
--请求加好友
function PersonalHomeDialogPageCtrl:_reqAddFriend(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(13040002)
    data.tipInfo = GetLanguage(13040003)
    data.inputInfo = GetLanguage(15010023)
    data.btnCallBack = function(text)
        --Event.Brocast("m_ChatAddFriends", { id = ins.m_data.id, desc = text })
        if string.len(text) > 30 then
            text = GetLanguage(15010018)
            Event.Brocast("SmallPop",text,80)
        else
            DataManager.ModelSendNetMes("gscode.OpCode", "addFriend","gs.ByteStr", { id = ins.m_data.id, desc = text })
            Event.Brocast("SmallPop", GetLanguage(13040004), 80)
        end
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end
--好友私聊
function PersonalHomeDialogPageCtrl:_friendChatBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.isOpenChat == nil or ins.m_data.isOpenChat == false then
        UIPanel.ClosePage()
        ct.OpenCtrl("ChatCtrl", {toggleId = 2, id = ins.m_data.id})
    end
end
--陌生人私聊
function PersonalHomeDialogPageCtrl:_strangerChatBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.isOpenChat == nil or ins.m_data.isOpenChat == false then
        UIPanel.ClosePage()
        ct.OpenCtrl("ChatCtrl", {toggleId = 3, id = ins.m_data.id})
    end
end
--公司
function PersonalHomeDialogPageCtrl:_companyBtnFunc(ins)
    PlayMusEff(1002)
    UIPanel.ClosePage()
    ct.OpenCtrl("CompanyCtrl", ins.m_data)
end
--avatar
function PersonalHomeDialogPageCtrl:_avatarBtnFunc(ins)
    PlayMusEff(1002)
    ct.OpenCtrl("AvtarCtrl")
end
--修改名字
function PersonalHomeDialogPageCtrl:_nameBtnFunc(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(17020001)
    data.inputDefaultStr = GetLanguage(17020002)
    data.btnCallBack = function(name)
        ins:_reqChangePlayerName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl",data)
end
--充值
function PersonalHomeDialogPageCtrl:_moneyBtnFunc(ins)
    --PlayMusEff(1002)
    --UIPanel.ClosePage()
    --ct.OpenCtrl("CompanyCtrl", ins.m_data)
end
--
function PersonalHomeDialogPageCtrl:_reqChangeDesToServer(str)
    local msgId = pbl.enum("gscode.OpCode","setRoleDescription")
    local lMsg = {str = str}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--
function PersonalHomeDialogPageCtrl:_reqChangePlayerName(str)
    local msgId = pbl.enum("gscode.OpCode","setPlayerName")
    local lMsg = {str = str}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end