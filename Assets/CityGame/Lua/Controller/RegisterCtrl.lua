---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/5/15 18:08
---注册ctrl
RegisterCtrl = class('RegisterCtrl',UIPanel)
UIPanel:ResgisterOpen(RegisterCtrl)

local registerBehaviour;

function  RegisterCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RegisterPanel.prefab"
end

function RegisterCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function RegisterCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function RegisterCtrl:Awake()
    registerBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    registerBehaviour:AddClick(RegisterPanel.back,self.OnBack,self)  --获取
    registerBehaviour:AddClick(RegisterPanel.gain,self.OnGain,self)  --获取
    registerBehaviour:AddClick(RegisterPanel.register,self.OnRegister,self)  --注册
    self.time = 60
    RegisterPanel.time.text = self.time .. "s..."
    --初始化循环参数
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self._Updata, self), 1, -1, true)

end

function RegisterCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_GetCode",self.c_GetCode,self)
    Event.AddListener("c_OnResult",self.c_OnResult,self)

    RegisterPanel.name.text = GetLanguage(10030001)
    RegisterPanel.phonePlaceholder.text = GetLanguage(10030006)
    RegisterPanel.phoneText.text = GetLanguage(10030006)
    RegisterPanel.passwordPlaceholder.text = GetLanguage(10030007)
    RegisterPanel.passwordText.text = GetLanguage(10030007)
    RegisterPanel.confirmPlaceholder.text = GetLanguage(10030008)
    RegisterPanel.confirmText.text = GetLanguage(10030008)
    RegisterPanel.authCodePlaceholder.text = GetLanguage(10030009)
    RegisterPanel.authCodeText.text = GetLanguage(10030009)
    RegisterPanel.gainText.text = GetLanguage(10030010)
    RegisterPanel.registerText.text = GetLanguage(10030011)
end

function RegisterCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_GetCode",self.c_GetCode,self)
    Event.RemoveListener("c_OnResult",self.c_OnResult,self)
    RegisterPanel.phone.text = ""
    RegisterPanel.password.text = ""
    RegisterPanel.confirm.text = ""
    RegisterPanel.authCode.text = ""
    RegisterPanel.phoneHint.transform.localScale = Vector3.zero
    RegisterPanel.passwordHint.transform.localScale = Vector3.zero
    RegisterPanel.confirmHint.transform.localScale = Vector3.zero
    RegisterPanel.authCodeHint.transform.localScale = Vector3.zero
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
    self.time = 60
    RegisterPanel.countDown.localScale = Vector3.zero
    RegisterPanel.gainText.transform.localScale = Vector3.one
    RegisterPanel.gain:GetComponent("Button").interactable = true
end

--返回
function RegisterCtrl:OnBack(go)
    PlayMusEff(1002)
    local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.Select,
                content = GetLanguage(10030016),func = function()
            UIPanel.ClosePage()
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end

--点击获取验证码
function RegisterCtrl:OnGain(go)
    PlayMusEff(1002)
    if RegisterPanel.phone.text == "" then
        RegisterPanel.phoneHint.transform.localScale = Vector3.one
        RegisterPanel.phoneHint.text = GetLanguage(10030020)
    else
        RegisterPanel.phoneHint.transform.localScale = Vector3.zero
        Event.Brocast("m_GetCode",RegisterPanel.phone.text)
    end
end

--获取验证码回调
function RegisterCtrl:c_GetCode(info,msgId)
    if msgId == 0 then
        if info.reason == "highFrequency" then
            RegisterPanel.authCodeHint.transform.localScale = Vector3.one
            RegisterPanel.phoneHint.transform.localScale = Vector3.zero
            RegisterPanel.authCodeHint.text = GetLanguage(10030025)
        elseif info.reason == "paramError" then
            RegisterPanel.authCodeHint.transform.localScale = Vector3.zero
            RegisterPanel.phoneHint.transform.localScale = Vector3.one
            RegisterPanel.phoneHint.text = GetLanguage(10040002)
        end
    else
        RegisterPanel.authCodeHint.transform.localScale = Vector3.zero
        RegisterPanel.phoneHint.transform.localScale = Vector3.zero
        RegisterPanel.gain:GetComponent("Button").interactable = false
        self.m_Timer:Start()
        RegisterPanel.countDown.localScale = Vector3.one
        RegisterPanel.gainText.transform.localScale = Vector3.zero
    end
end

--更新
function RegisterCtrl:_Updata()
        self.time = self.time - 1
    if self.time <= 0 then
        if self.m_Timer ~= nil then
            self.m_Timer:Stop()
        end
        self.time = 60
        RegisterPanel.countDown.localScale = Vector3.zero
        RegisterPanel.gainText.transform.localScale = Vector3.one
        RegisterPanel.gain:GetComponent("Button").interactable = true
    end
    RegisterPanel.time.text = self.time .. "s..."
end

--注册
function RegisterCtrl:OnRegister(go)
    PlayMusEff(1002)
    RegisterPanel.phoneHint.transform.localScale = Vector3.zero
    RegisterPanel.passwordHint.transform.localScale = Vector3.zero
    RegisterPanel.confirmHint.transform.localScale = Vector3.zero
    RegisterPanel.authCodeHint.transform.localScale = Vector3.zero

    if RegisterPanel.phone.text == "" then
        RegisterPanel.phoneHint.transform.localScale = Vector3.one
        RegisterPanel.phoneHint.text = GetLanguage(10030020)
    elseif RegisterPanel.password.text == "" then
        RegisterPanel.passwordHint.transform.localScale = Vector3.one
        RegisterPanel.passwordHint.text = GetLanguage(10030021)
    elseif RegisterPanel.confirm.text == "" then
        RegisterPanel.confirmHint.transform.localScale = Vector3.one
        RegisterPanel.confirmHint.text = GetLanguage(10030022)
    elseif RegisterPanel.authCode.text == "" then
        RegisterPanel.authCodeHint.transform.localScale = Vector3.one
        RegisterPanel.authCodeHint.text = GetLanguage(10030023)
    elseif string.find(RegisterPanel.password.text,"%s") ~= nil then
        RegisterPanel.passwordHint.transform.localScale = Vector3.one
        RegisterPanel.passwordHint.text = GetLanguage(10030024)
    elseif #RegisterPanel.password.text < 8 or #RegisterPanel.password.text > 12 then
        RegisterPanel.passwordHint.transform.localScale = Vector3.one
        RegisterPanel.passwordHint.text = GetLanguage(10030013)
    elseif RegisterPanel.password.text ~= RegisterPanel.confirm.text  then
        RegisterPanel.confirmHint.transform.localScale = Vector3.one
        RegisterPanel.confirmHint.text = GetLanguage(10030012)
    else
        local data = {}
        data.InviteCode = go.m_data
        data.phone = RegisterPanel.phone.text
        data.password = RegisterPanel.password.text
        data.authCode = RegisterPanel.authCode.text
        Event.Brocast("m_OnRegister",data)
    end
end

--注册回调
function RegisterCtrl:c_OnResult(info)
    RegisterPanel.phoneHint.transform.localScale = Vector3.zero
    RegisterPanel.authCodeHint.transform.localScale = Vector3.zero
    if info.status == "FAIL_ACCOUNT_EXIST" then
        RegisterPanel.phoneHint.transform.localScale = Vector3.one
        RegisterPanel.phoneHint.text = GetLanguage(10030026)

    elseif info.status == "FAIL_AUTHCODE_ERROR" then
        RegisterPanel.authCodeHint.transform.localScale = Vector3.one
        RegisterPanel.authCodeHint.text = GetLanguage(10030014)

    elseif info.status == "FAIL_INVCODE_USED" then
        local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.NotChoose,
                    content = GetLanguage(10030015),func = function()
                UIPanel.ClosePage()
            end  }
        ct.OpenCtrl('NewReminderCtrl',data)
    elseif info.status == "FAIL" then
        local info_RegisterErrorNetMsg = {}
        info_RegisterErrorNetMsg.titleInfo = "未注册处理方法的网络错误"
        --替換為多語言
        info_RegisterErrorNetMsg.contentInfo = "服务器异常"
        info_RegisterErrorNetMsg.tipInfo = ""
        ct.OpenCtrl("ErrorBtnDialogPageCtrl", info_RegisterErrorNetMsg)
    elseif info.status == "SUCCESS" then
        local data={ReminderType = ReminderType.Succeed,ReminderSelectType = ReminderSelectType.NotChoose,
                    content =  GetLanguage(10030017),func = function()
                ct.OpenCtrl('LoginCtrl',Vector2.New(0, 0))
            end  }
        ct.OpenCtrl('NewReminderCtrl',data)
    end
end