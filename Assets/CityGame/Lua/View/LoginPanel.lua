local transform;
local gameObject;

LoginPanel = {};
local this = LoginPanel;

--启动事件--
function LoginPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
end

--初始化面板--
function LoginPanel.InitPanel()
	this.btnLogin = transform:Find("Button_login").gameObject;
	this.btnLoginText = transform:Find("Button_login/Text").gameObject:GetComponent('Text');
	this.btnRegister = transform:Find("Button_register").gameObject;
	this.inputUsername = transform:Find("InputField_username").gameObject;
	this.InputField_show = transform:Find("InputField_show").gameObject:GetComponent("InputField");
	this.InputField_hide = transform:Find("InputField_hide").gameObject:GetComponent("InputField");
	this.inputUsernameTest = transform:Find("InputField_username/Placeholder").gameObject:GetComponent('Text');
	this.inputPassword = transform:Find("InputField_password").gameObject;
	this.forget = transform:Find("InputField_password/forget").gameObject;  --找回密码
	this.inputPasswordTest = transform:Find("InputField_password/Placeholder").gameObject:GetComponent('Text');
	this.textStatus = transform:Find("Text_status").gameObject;
	this.remember = transform:Find("InputField_password/remember").gameObject:GetComponent("Toggle");   --记住密码
	this.eye = transform:Find("InputField_password/eye").gameObject;   --是否显示密码
	this.closeEye = transform:Find("InputField_password/eye/closeeye");   --隐藏密码
	this.openEye = transform:Find("InputField_password/eye/openeye");   --显示密码

	--多语言
	this.choose = transform:Find("language/choose").gameObject;
	this.languageText = transform:Find("language/languageText").gameObject:GetComponent('Text');
	this.closeBg = transform:Find("language/closeBg").gameObject;
	this.languageBg = transform:Find("language/languageBg");
	this.content = transform:Find("language/languageBg/Scroll View/Viewport/Content");
end

function LoginPanel.Start()

end
--单击事件--
function LoginPanel.OnDestroy()

end

