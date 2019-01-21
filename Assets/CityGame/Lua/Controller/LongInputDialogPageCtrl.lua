---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/27 14:50
---长字段输入弹窗
LongInputDialogPageCtrl = class('LongInputDialogPageCtrl',UIPanel)
UIPanel:ResgisterOpen(LongInputDialogPageCtrl) --注册打开的方法

function LongInputDialogPageCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function LongInputDialogPageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/Common/LongInputDialogPagePanel.prefab"
end

function LongInputDialogPageCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function LongInputDialogPageCtrl:Awake(go)
    self:_getComponent(go)

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject, self._onClickConfim, self)
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
end

function LongInputDialogPageCtrl:Refresh()
    self:_initData()
end

---寻找组件
function LongInputDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText"):GetComponent("Text")
    self.closeBtn = go.transform:Find("root/closeBtn")
    self.confirmBtn = go.transform:Find("root/confirmBtn")
    self.input = go.transform:Find("root/input"):GetComponent("InputField")
end
---初始化
function LongInputDialogPageCtrl:_initData()
    if self.m_data.titleInfo then
        self.titleText.text = self.m_data.titleInfo
    end
end

function LongInputDialogPageCtrl:_onClickConfim(ins)
    if ins.m_data.btnCallBack then
        if ins.input.text ~= nil and ins.input.text ~= "" then
            ins.m_data.btnCallBack(ins.input.text)
        end
        ins.m_data.btnCallBack = nil
    end
    ins:_onClickClose(ins)
end
function LongInputDialogPageCtrl:_onClickClose(ins)
    ins:Hide()
end