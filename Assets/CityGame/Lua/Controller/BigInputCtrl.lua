---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/6/28 17:07
---


BigInputCtrl = class('BigInputCtrl',UIPanel)
UIPanel:ResgisterOpen(BigInputCtrl) --注册打开的方法

function BigInputCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function BigInputCtrl:bundleName()
    return "Assets/CityGame/Resources/View/Common/BigInputPanel.prefab"
end

function BigInputCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function BigInputCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.confimBtn, self._onClickConfim, self)
    self.rentInput.onValueChanged:AddListener(function ()
    end)
end
function BigInputCtrl:Active()
    UIPanel.Active(self)
end
function BigInputCtrl:Refresh()
    self:_initData()
end

function BigInputCtrl:Hide()
    UIPanel.Hide(self)
end

-- 寻找组件
function BigInputCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText").gameObject:GetComponent("Text")
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject
    self.confimBtn = go.transform:Find("root/confirmBtn").gameObject
    self.rentInput = go.transform:Find("root/rentInput").gameObject:GetComponent("InputField")
    self.rentInputPlaceholderText = go.transform:Find("root/rentInput/Placeholder"):GetComponent("Text")

    self.tipsText = go.transform:Find("root/tipsText").gameObject:GetComponent("Text")
end
-- 初始化
function BigInputCtrl:_initData()
    self.titleText.text = self.m_data.titleInfo
    self.tipsText.text = self.m_data.tipInfo
    self.rentInput.text = ""

    --设置默认显示str
    if self.m_data.contentStr ~= nil and self.m_data.contentStr ~= "" then
        self.rentInput.text = self.m_data.contentStr
    end

    -- 输入框的个数限制
    if self.m_data.characterLimit then
        self.rentInput.characterLimit = self.m_data.characterLimit
    else
        self.rentInput.characterLimit = 0
    end

    -- 输入法的提示值
    if self.m_data.inputDefaultStr ~= nil then
        self.rentInputPlaceholderText.text = self.m_data.inputDefaultStr
    else
        self.rentInputPlaceholderText.text = ""
    end
end

-- 点击确认按钮
function BigInputCtrl:_onClickConfim(ins)
    PlayMusEff(1002)
    local inputValue = ins.rentInput.text
    if inputValue == "" then
        return
    end

    if ins.m_data.btnCallBack then
        ins.m_data.btnCallBack(inputValue)
    end
    UIPanel.ClosePage()
end

-- 点击关闭按钮
function BigInputCtrl:_onClickClose()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end