---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/5/15 11:37
---邀请码Ctrl
InviteCodeCtrl = class('InviteCodeCtrl',UIPanel)
UIPanel:ResgisterOpen(InviteCodeCtrl)

local inviteCodeBehaviour;

function  InviteCodeCtrl:bundleName()
    return "Assets/CityGame/Resources/View/InviteCodePanel.prefab"
end

function InviteCodeCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function InviteCodeCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function InviteCodeCtrl:Awake()
    inviteCodeBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    inviteCodeBehaviour:AddClick(InviteCodePanel.back,self.OnBack,self)
    inviteCodeBehaviour:AddClick(InviteCodePanel.btn,self.OnBtn,self)
    InviteCodePanel.inviteCode.onValueChanged:AddListener(function ()
        self:OnInviteCode(self)
    end )
end

function InviteCodeCtrl:Active()
    UIPanel.Active(self)
   Event.AddListener("c_InviteCodeStatus",self.c_InviteCodeStatus,self)
end

function InviteCodeCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_InviteCodeStatus",self.c_InviteCodeStatus,self)
end

--返回
function InviteCodeCtrl:OnBack()
    UIPanel.ClosePage()
end

--改变输入框
function InviteCodeCtrl:OnInviteCode()
    InviteCodePanel.btn:GetComponent("Button").interactable = true
end

function InviteCodeCtrl:OnBtn()
    if InviteCodePanel.inviteCode == "" then
        Event.Brocast("SmallPop","邀请码不能为空", 300)
    else
        Event.Brocast("m_InviteCode",InviteCodePanel.inviteCode.text)
    end
end

function InviteCodeCtrl:c_InviteCodeStatus(info)
    if info.status == "USEFUL" then
        ct.OpenCtrl("RegisterCtrl",InviteCodePanel.inviteCode.text)
    elseif info.status == "USED"  then
        InviteCodePanel.error.transform.localScale = Vector3.one
        InviteCodePanel.error.text = "邀请码也过期"
        InviteCodePanel.btn:GetComponent("Button").interactable = false
    elseif info.status == "ERROR"  then
        InviteCodePanel.error.transform.localScale = Vector3.one
        InviteCodePanel.error.text = "邀请码错误"
        InviteCodePanel.btn:GetComponent("Button").interactable = false
    end
end