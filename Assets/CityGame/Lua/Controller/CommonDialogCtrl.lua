---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/1 17:00
---

CommonDialogCtrl = class('CommonDialogCtrl',UIPanel)
UIPanel:ResgisterOpen(CommonDialogCtrl) --注册打开的方法

function CommonDialogCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function CommonDialogCtrl:bundleName()
    return "Assets/CityGame/Resources/View/Common/CommonDialogPanel.prefab"
end

function CommonDialogCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function CommonDialogCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_initData()

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
end

function CommonDialogCtrl:Refresh()
    self:_initData()

    self.luaBehaviour:AddClick(self.closeBtn, self._onClickClose, self)
    self.luaBehaviour:AddClick(self.confimBtn, self._onClickConfim, self)
    self.input.onValueChanged:AddListener(function ()
        ct.log("cycle_w12_hosueServer", "----")  --敏感词检测
    end)
end

--寻找组件
function CommonDialogCtrl:_getComponent(go)
    self.titleText = go.transform:Find("Root/TitleText").gameObject:GetComponent("Text")
    self.closeBtn = go.transform:Find("Root/CloseBtn").gameObject
    self.confimBtn = go.transform:Find("Root/ConfirmBtn").gameObject
    self.input = go.transform:Find("Root/Input").gameObject:GetComponent("InputField")
    self.tipsText = go.transform:Find("Root/TipsText"):GetComponent("Text")
end

--初始化
function CommonDialogCtrl:_initData()
    self.titleText.text = self.m_data.titleInfo
    self.tipsText.text = self.m_data.tipInfo
    if self.m_data.inputInfo then
        self.input.text = self.m_data.inputInfo
    end
end

--点击确认按钮
function CommonDialogCtrl:_onClickConfim(ins)
    ---在这的self 是传进来的btn组件，table才是实例
    local inputValue = ins.input.text
    if inputValue == "" then
        return
    end

    ---测试
    if ins.m_data.btnCallBack then
        ins.m_data.btnCallBack(inputValue)
    end
    ins:_onClickClose(ins)
end

--点击关闭按钮
function CommonDialogCtrl:_onClickClose(ins)
    --ct.log("cycle_w12_hosueServer", "InputDialogPageCtrl:_onClickClose")
    ins.input.text = ""
    ins.luaBehaviour:RemoveClick(ins.confimBtn.gameObject, ins._onClickConfim, ins)
    ins.luaBehaviour:RemoveClick(ins.closeBtn.gameObject, ins._onClickClose, ins)
    UIPanel.ClosePage()
end

function CommonDialogCtrl:Hide()
    UIPanel.Hide(self)
end