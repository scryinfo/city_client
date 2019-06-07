---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 14:57
---含有input输入框的弹窗
InputDialogPageCtrl = class('InputDialogPageCtrl',UIPanel)
UIPanel:ResgisterOpen(InputDialogPageCtrl) --注册打开的方法

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
        --ct.log("cycle_w12_hosueServer", "----")  --敏感词检测
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
---寻找组件
function InputDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText").gameObject:GetComponent("Text")
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject
    self.confimBtn = go.transform:Find("root/confirmBtn").gameObject
    self.rentInput = go.transform:Find("root/rentInput").gameObject:GetComponent("InputField")
    self.rentInputPlaceholderText = go.transform:Find("root/rentInput/Placeholder"):GetComponent("Text")

    self.errorTipRoot = go.transform:Find("root/tipRoot")
    self.errorTipText = go.transform:Find("root/tipRoot/Text").gameObject:GetComponent("Text")
    --self.changeNameTipText = go.transform:Find("root/changeNameTipText").gameObject:GetComponent("Text")  --改名字提示 --每七天改一次
end
---初始化
function InputDialogPageCtrl:_initData()
    self:_language()

    self.titleText.text = self.m_data.titleInfo
    self.rentInput.text = ""
    self.errorTipRoot.localScale = Vector3.zero
    if self.m_data.inputDefaultStr ~= nil then
        self.rentInputPlaceholderText.text = self.m_data.inputDefaultStr
    else
        self.rentInputPlaceholderText.text = GetLanguage(17020002)
    end
end

function InputDialogPageCtrl:_language() end

---点击确认按钮
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
---点击关闭按钮
function InputDialogPageCtrl:_onClickClose()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
-----------------------------------------------------------------------回调函数---------------------------------------------------------------------------
--改名字失败
function InputDialogPageCtrl:setBuildingNameFailure(data)
    if data then
        self.errorTipRoot.localScale = Vector3.one
        self.errorTipText.text = GetLanguage(17020005)
    end
end
--修改玩家姓名
function InputDialogPageCtrl:setPlayerNameCallback(data)
    if data.reason ~= nil then
        self.errorTipRoot.localScale = Vector3.one
        if data.reason == "roleNameDuplicated" then
            self.errorTipText.text = GetLanguage(17020003)
        elseif data.reason == "roleNameSetInCd" then
            self.errorTipText.text = GetLanguage(17020005)
        end
    else
        Event.Brocast("SmallPop", GetLanguage(17020006), 300)
        UIPanel.ClosePage()
    end
end