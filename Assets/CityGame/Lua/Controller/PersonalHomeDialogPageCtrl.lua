---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/27 11:25
---个人主页弹窗
PersonalHomeDialogPageCtrl = class('PersonalHomeDialogPageCtrl',UIPage)
UIPage:ResgisterOpen(PersonalHomeDialogPageCtrl) --注册打开的方法

function PersonalHomeDialogPageCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function PersonalHomeDialogPageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PersonalHomeDialogPagePanel.prefab"
end

function PersonalHomeDialogPageCtrl:OnCreate(obj )
    UIPage.OnCreate(self, obj)
end

function PersonalHomeDialogPageCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_initData()

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.changeSayBtn.gameObject, self._changeDesFunc, self)
    self.luaBehaviour:AddClick(self.addFriendBtn.gameObject, self._reqAddFriend, self)
    self.luaBehaviour:AddClick(self.sendMessageBtn.gameObject, self._chatBtnFunc, self)
end

function PersonalHomeDialogPageCtrl:Refresh()
    self:_initData()
end

function PersonalHomeDialogPageCtrl:Close()
    --self:_removeListener()
end
---寻找组件
function PersonalHomeDialogPageCtrl:_getComponent(go)
    self.closeBtn = go.transform:Find("root/topBg/closeBtn")
    self.sayText = go.transform:Find("root/sayRoot/sayText"):GetComponent("Text")
    self.changeSayBtn = go.transform:Find("root/sayRoot/changeBtn")
    self.nameText = go.transform:Find("root/infoRoot/name/nameText"):GetComponent("Text")
    self.famaleTran = go.transform:Find("root/infoRoot/name/nameText/famale")
    self.maleTran = go.transform:Find("root/infoRoot/name/nameText/male")
    self.companyText = go.transform:Find("root/infoRoot/company/companyText"):GetComponent("Text")

    self.otherOpen = go.transform:Find("root/otherOpen")
    self.addFriendBtn = go.transform:Find("root/otherOpen/addFriendBtn")
    self.sendMessageBtn = go.transform:Find("root/otherOpen/sendMessageBtn")
end
---初始化
function PersonalHomeDialogPageCtrl:_initData()
    if self.m_data.id ~= DataManager.GetMyOwnerID() then
        self.otherOpen.localScale = Vector3.one
        self.changeSayBtn.localScale = Vector3.zero
    else
        self.otherOpen.localScale = Vector3.zero
        self.changeSayBtn.localScale = Vector3.one
    end

    if self.m_data.male == false then
        self.famaleTran.localScale = Vector3.one
        self.maleTran.localScale = Vector3.zero
    else
        self.famaleTran.localScale = Vector3.zero
        self.maleTran.localScale = Vector3.one
    end
    self.sayText.text = self.m_data.des
    if self.m_data.des == nil or self.m_data.des == "" then
        self.sayText.text = "Everything i do i wanna put a shine on it, do it one more time, i gotta give it up."  --默认值
    end
    self.nameText.text = self.m_data.name
    self.nameText.rectTransform.sizeDelta = Vector2.New(self.nameText.preferredWidth + 45, self.nameText.rectTransform.sizeDelta.y)  --加一个性别图片的宽度
    self.companyText.text = self.m_data.companyName
end
---点击关闭按钮
function PersonalHomeDialogPageCtrl:_onClickClose(ins)
    ins:Hide()
end
--修改des
function PersonalHomeDialogPageCtrl:_changeDesFunc(ins)
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
    local data = {}
    data.titleInfo = "REMINDER"
    data.tipInfo = "Please input verification information!"
    data.btnCallBack = function(text)
        Event.Brocast("m_ChatAddFriends", { id = ins.m_data.id, desc = text })
        Event.Brocast("SmallPop","Your request has been sent.",80)
    end
    ct.OpenCtrl("CommonDialogCtrl", data)
end
--私聊
function PersonalHomeDialogPageCtrl:_chatBtnFunc(ins)
    -- 判断是否是自己的好友
    local friendsBasicData = DataManager.GetMyFriends()
    if friendsBasicData[ins.m_data.id] == nil then
        ct.OpenCtrl("ChatCtrl", {toggleId = 3, id = ins.m_data.id})
    else
        ct.OpenCtrl("ChatCtrl", {toggleId = 2, id = ins.m_data.id})
    end
    ins:Hide()
end
--
function PersonalHomeDialogPageCtrl:_reqChangeDesToServer(str)
    local msgId = pbl.enum("gscode.OpCode","setRoleDescription")
    local lMsg = {str = str}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end