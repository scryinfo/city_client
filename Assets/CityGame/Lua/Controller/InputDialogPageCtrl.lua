---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 14:57
---Popup window with input input box
InputDialogPageCtrl = class('InputDialogPageCtrl',UIPanel)
UIPanel:ResgisterOpen(InputDialogPageCtrl) --How to open the registration

function InputDialogPageCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function InputDialogPageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/Common/InputDialogPagePanel.prefab"
end

function InputDialogPageCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function InputDialogPageCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.confimBtn, self._onClickConfim, self)
    self.rentInput.onValueChanged:AddListener(function ()
        --ct.log("cycle_w12_hosueServer", "----")  --Sensitive word detection
    end)
end
function InputDialogPageCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("setBuildingNameFailure",self.setBuildingNameFailure,self)
    Event.AddListener("c_SetPlayerNameEvent",self.setPlayerNameCallback,self)
end
function InputDialogPageCtrl:Refresh()
    self:_initData()
end

function InputDialogPageCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("setBuildingNameFailure",self.setBuildingNameFailure,self)
    Event.RemoveListener("c_SetPlayerNameEvent",self.setPlayerNameCallback,self)
end
---Find components
function InputDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText").gameObject:GetComponent("Text")
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject
    self.confimBtn = go.transform:Find("root/confirmBtn").gameObject
    self.rentInput = go.transform:Find("root/rentInput").gameObject:GetComponent("InputField")
    self.rentInputPlaceholderText = go.transform:Find("root/rentInput/Placeholder"):GetComponent("Text")

    self.errorTipRoot = go.transform:Find("root/tipRoot")
    self.errorTipText = go.transform:Find("root/tipRoot/Text").gameObject:GetComponent("Text")
    --self.changeNameTipText = go.transform:Find("root/changeNameTipText").gameObject:GetComponent("Text")  --Tips for changing the name - every seven days
end
---初始化
function InputDialogPageCtrl:_initData()
    self:_language()

    self.titleText.text = self.m_data.titleInfo
    self.rentInput.text = ""
    if self.m_data.limit == nil then
        self.m_data.limit = 8  --Give a default value
    end
    self.rentInput.characterLimit = self.m_data.limit
    self.errorTipRoot.localScale = Vector3.one
    self.errorTipText.text = GetLanguage(17020005)
    if self.m_data.inputDefaultStr ~= nil then
        self.rentInputPlaceholderText.text = self.m_data.inputDefaultStr
    else
        self.rentInputPlaceholderText.text = GetLanguage(18010007)
    end
end

function InputDialogPageCtrl:_language() end

---Click the confirm button
function InputDialogPageCtrl:_onClickConfim(ins)
    PlayMusEff(1002)
    local inputValue = ins.rentInput.text
    if inputValue == "" then
        return
    end

    if ins.m_data.btnCallBack then
        ins.m_data.btnCallBack(inputValue)
    end
    --ins:_onClickClose()
end
---Click the close button
function InputDialogPageCtrl:_onClickClose()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
-----------------------------------------------------------------------Callback---------------------------------------------------------------------------
--Change of name failed
function InputDialogPageCtrl:setBuildingNameFailure(data)
    if data ~= nil then
        if data.reason == "timeNotSatisfy" then
            UIPanel.ClosePage()
            Event.Brocast("SmallPop", GetLanguage(17020008), ReminderType.Warning)
        end
    end
end
--Modify player name
function InputDialogPageCtrl:setPlayerNameCallback(data)
    if data.reason ~= nil then
        self.errorTipRoot.localScale = Vector3.one
        if data.reason == "roleNameDuplicated" then
            --self.errorTipText.text = GetLanguage(17020003)
            Event.Brocast("SmallPop", GetLanguage(17020003), ReminderType.Warning)
        elseif data.reason == "roleNameSetInCd" then
            --self.errorTipText.text = GetLanguage(17020005)
            Event.Brocast("SmallPop", GetLanguage(17020008), ReminderType.Warning)
        end
    else
        Event.Brocast("SmallPop", GetLanguage(17020006), ReminderType.Succeed)
        UIPanel.ClosePage()
    end
end