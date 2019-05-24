---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/5/22 10:32
---新版提示框Ctrl
NewReminderCtrl = class('NewReminderCtrl',UIPanel)
UIPanel:ResgisterOpen(NewReminderCtrl)

local reminderBehaviour;

function  NewReminderCtrl:bundleName()
    return "Assets/CityGame/Resources/View/NewReminderPanel.prefab"
end

function NewReminderCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function NewReminderCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function NewReminderCtrl:Awake()
    reminderBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    reminderBehaviour:AddClick(NewReminderPanel.close,self.OnClose,self)
    reminderBehaviour:AddClick(NewReminderPanel.selectConfirm,self.OnSelectConfirm,self)
    reminderBehaviour:AddClick(NewReminderPanel.notConfirm,self.OnNotConfirm,self)
end

function NewReminderCtrl:Active()
    UIPanel.Active(self)
end

function NewReminderCtrl:Refresh()
    if self.m_data ~= nil then
        if self.m_data.ReminderType == ReminderType.Common then
            NewReminderPanel.poptitle.color = getColorByInt(84,107,203,255)
            NewReminderPanel.name.text = "REMINDER"
        elseif self.m_data.ReminderType == ReminderType.Warning then
            NewReminderPanel.poptitle.color = getColorByInt(197,67,67,255)
            NewReminderPanel.name.text = "REMINDER"
        elseif self.m_data.ReminderType == ReminderType.Succeed then
            NewReminderPanel.poptitle.color = getColorByInt(225,158,29,255)
            NewReminderPanel.name.text = "SUCCESS"
        end
        if self.m_data.ReminderSelectType == ReminderSelectType.Select then
            NewReminderPanel.select.localScale = Vector3.one
            NewReminderPanel.notChoose.localScale = Vector3.zero
        elseif self.m_data.ReminderSelectType == ReminderSelectType.NotChoose then
            NewReminderPanel.select.localScale = Vector3.zero
            NewReminderPanel.notChoose.localScale = Vector3.one
        end
        NewReminderPanel.content.text = self.m_data.content
    end
end

function NewReminderCtrl:Hide()
    UIPanel.Hide(self)
end

--返回
function NewReminderCtrl:OnClose()
    UIPanel.ClosePage()
end

--点击具有选择性的确定（有取消按钮）
function NewReminderCtrl:OnSelectConfirm(go)
    UIPanel.ClosePage()
    if go.m_data.func then
        go.m_data:func()
        go.m_data.func = nil
    end
end

--点击不具有选择性的确定（没有取消按钮）
function NewReminderCtrl:OnNotConfirm(go)
    UIPanel.ClosePage()
    if go.m_data.func then
        go.m_data:func()
        go.m_data.func = nil
    end
end