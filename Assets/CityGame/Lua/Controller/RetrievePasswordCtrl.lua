---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/5/20 16:47
---找回密码ctrl
RetrievePasswordCtrl = class('RetrievePasswordCtrl',UIPanel)
UIPanel:ResgisterOpen(RetrievePasswordCtrl)

local retrievePasswordBehaviour;

function  RetrievePasswordCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RetrievePasswordPanel.prefab"
end

function RetrievePasswordCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function RetrievePasswordCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function RetrievePasswordCtrl:Awake()
    retrievePasswordBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    retrievePasswordBehaviour:AddClick(RetrievePasswordPanel.back,self.OnBack,self)
    retrievePasswordBehaviour:AddClick(RetrievePasswordPanel.next,self.OnNext,self)
    retrievePasswordBehaviour:AddClick(RetrievePasswordPanel.gain,self.OnGain,self)  --获取验证码

    self.time = 60
    RetrievePasswordPanel.time.text = self.time .. "s..."
    --初始化循环参数
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self._Updata, self), 1, -1, true)

end

function RetrievePasswordCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_GetCode",self.c_GetCode,self)
    Event.AddListener("c_ModifyPwdVerify",self.c_ModifyPwdVerify,self)
end

function RetrievePasswordCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_GetCode",self.c_GetCode,self)
    Event.RemoveListener("c_ModifyPwdVerify",self.c_ModifyPwdVerify,self)

    RetrievePasswordPanel.phone.text = ""
    RetrievePasswordPanel.authCode.text = ""
    RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
    RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.zero

    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
    self.time = 60
    RetrievePasswordPanel.countDown.localScale = Vector3.zero
    RetrievePasswordPanel.gainText.transform.localScale = Vector3.one
    RetrievePasswordPanel.gain:GetComponent("Button").interactable = true
end

--更新
function RetrievePasswordCtrl:_Updata()
    self.time = self.time - 1
    if self.time <= 0 then
        if self.m_Timer ~= nil then
            self.m_Timer:Stop()
        end
        self.time = 60
        RetrievePasswordPanel.countDown.localScale = Vector3.zero
        RetrievePasswordPanel.gainText.transform.localScale = Vector3.one
        RetrievePasswordPanel.gain:GetComponent("Button").interactable = true
    end
    RetrievePasswordPanel.time.text = self.time .. "s..."
end


--返回
function RetrievePasswordCtrl:OnBack(go)
    local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.Select,
                content = "Give up retrieving password?!",func = function()
            UIPanel.ClosePage()
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end

--核对验证码
function RetrievePasswordCtrl:OnNext()
    if RetrievePasswordPanel.phone.text == "" then
        RetrievePasswordPanel.authCode.transform.localScale = Vector3.zero
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.one
        RetrievePasswordPanel.phoneHint.text = "请输入手机号"
    elseif RetrievePasswordPanel.authCode.text == "" then
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
        RetrievePasswordPanel.authCode.transform.localScale = Vector3.one
        RetrievePasswordPanel.authCode.text = "请输入验证码"
    else
        RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.zero
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
        local data = {}
        data.phone = RetrievePasswordPanel.phone.text
        data.authCode = RetrievePasswordPanel.authCode.text
        Event.Brocast("m_ModifyPwdVerify",data)
    end
end

--获取验证码
function RetrievePasswordCtrl:OnGain()
    if RetrievePasswordPanel.phone.text == "" then
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.one
        RetrievePasswordPanel.phoneHint.text = "请输入手机号"
    else
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
        Event.Brocast("m_GetCode",RetrievePasswordPanel.phone.text)
    end
end

--获取验证码回调
function RetrievePasswordCtrl:c_GetCode(info,msgId)
    if msgId == 0 then
        if info.reason == "highFrequency" then
            RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
            RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.one
            RetrievePasswordPanel.authCodeHint.text = "请求过于频繁,请稍候重试"
        elseif info.reason == "paramError" then
            RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.zero
            RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.one
            RetrievePasswordPanel.phoneHint.text = "手机号格式错误"
        end
    else
        RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.zero
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
        RetrievePasswordPanel.gain:GetComponent("Button").interactable = false
        self.m_Timer:Start()
        RetrievePasswordPanel.countDown.localScale = Vector3.one
        RetrievePasswordPanel.gainText.transform.localScale = Vector3.zero
    end
end

--修改密码验证回调
function RetrievePasswordCtrl:c_ModifyPwdVerify(info)
    if info.status == "FAIL_ACCOUNT_UNREGISTER" then
        RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.zero
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.one
        RetrievePasswordPanel.phoneHint.text = "账号未注册"
    elseif info.status == "FAIL_AUTHCODE_ERROR" then
        RetrievePasswordPanel.phoneHint.transform.localScale = Vector3.zero
        RetrievePasswordPanel.authCodeHint.transform.localScale = Vector3.one
        RetrievePasswordPanel.authCodeHint.text = "验证码错误"
    elseif info.status == "SUCCESS" then
        ct.OpenCtrl("SetPasswordCtrl")
    end
end