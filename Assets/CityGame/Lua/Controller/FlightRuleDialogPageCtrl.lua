---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/30 16:30
---只含有按钮的简单弹框
FlightRuleDialogPageCtrl = class('FlightRuleDialogPageCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightRuleDialogPageCtrl)

function FlightRuleDialogPageCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end
--
function FlightRuleDialogPageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/Common/FlightRulePanel.prefab"
end
--
function FlightRuleDialogPageCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end
--
function FlightRuleDialogPageCtrl:Awake(go)
    self:_getComponent(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.checkBtn.gameObject, self._onClickClose, self)
end
--
function FlightRuleDialogPageCtrl:Refresh()
    self:_initData()
end
--
function FlightRuleDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/Text01"):GetComponent("Text")
    self.rule01 = go.transform:Find("root/01/Text"):GetComponent("Text")
    self.rule02 = go.transform:Find("root/02/Text"):GetComponent("Text")
    self.rule03 = go.transform:Find("root/03/Text"):GetComponent("Text")
    self.rule04 = go.transform:Find("root/04/Text"):GetComponent("Text")
    self.checkBtn = go.transform:Find("root/checkBtn")
end
--
function FlightRuleDialogPageCtrl:_initData()
    self.titleText.text = GetLanguage(12345678)
end
--
function FlightRuleDialogPageCtrl:_onClickClose()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end


