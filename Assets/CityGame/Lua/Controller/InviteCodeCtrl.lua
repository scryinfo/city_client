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
end

function InviteCodeCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_InviteCodeStatus",self.c_InviteCodeStatus,self)
    InviteCodePanel.name.text = GetLanguage(10030002)
    InviteCodePanel.code.text = GetLanguage(10030002)
    InviteCodePanel.placeholder.text = GetLanguage(10030018)
    InviteCodePanel.btnText.text = GetLanguage(10030019)
end

function InviteCodeCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_InviteCodeStatus",self.c_InviteCodeStatus,self)
    InviteCodePanel.inviteCode.text = ""
    InviteCodePanel.error.transform.localScale = Vector3.zero
end

--返回
function InviteCodeCtrl:OnBack()
    PlayMusEff(1002)
    CityEngineLua:reset()
    UIPanel.ClosePage()
end

function InviteCodeCtrl:OnBtn()
    PlayMusEff(1002)
    if InviteCodePanel.inviteCode.text == "" then
        InviteCodePanel.error.transform.localScale = Vector3.one
        InviteCodePanel.error.text = GetLanguage(10030018)
    else
        InviteCodePanel.error.transform.localScale = Vector3.zero
        Event.Brocast("m_InviteCode",InviteCodePanel.inviteCode.text)
    end
end

function InviteCodeCtrl:c_InviteCodeStatus(info)
    if info.status == "USEFUL" then
        ct.OpenCtrl("RegisterCtrl",InviteCodePanel.inviteCode.text)
    elseif info.status == "USED"  then
        InviteCodePanel.error.transform.localScale = Vector3.one
        InviteCodePanel.error.text = GetLanguage(10030005)
    elseif info.status == "ERROR"  then
        InviteCodePanel.error.transform.localScale = Vector3.one
        InviteCodePanel.error.text = GetLanguage(10030004)
    end
end