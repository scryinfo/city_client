---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/5/15 18:03
---注册界面
local transform;
local gameObject;

RegisterPanel = {};
local this = RegisterPanel;

--启动事件--
function RegisterPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;
    this.InitPanel();
end

--初始化面板--
function RegisterPanel.InitPanel()
    this.phone = transform:Find("phoneText/phone"):GetComponent('InputField');
    this.password = transform:Find("passwordText/password"):GetComponent('InputField');
    this.confirm = transform:Find("confirmText/confirm"):GetComponent('InputField');
    this.authCode = transform:Find("authCodeText/authCode"):GetComponent('InputField');
    this.gain = transform:Find("authCodeText/gain").gameObject;
    this.gainText = transform:Find("authCodeText/gain/Text"):GetComponent("Text");
    this.countDown = transform:Find("authCodeText/gain/countDown");  --倒计时
    this.time = transform:Find("authCodeText/gain/countDown/time"):GetComponent("Text");  --倒计时
    this.passwordHint = transform:Find("passwordText/hint"):GetComponent("Text");  --确认密码提示
    this.confirmHint = transform:Find("confirmText/hint"):GetComponent("Text");  --确认密码提示
    this.phoneHint = transform:Find("phoneText/hint"):GetComponent("Text");   --手机号格式提示
    this.authCodeHint = transform:Find("authCodeText/hint"):GetComponent("Text"); --验证码提示

    this.register = transform:Find("register").gameObject;
end
