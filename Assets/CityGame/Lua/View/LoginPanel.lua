local transform;
local gameObject;

LoginPanel = {};
local this = LoginPanel;

--Start event--
function LoginPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
end

--Initialize the panel--
function LoginPanel.InitPanel()
	this.btnLogin = transform:Find("Button_login").gameObject;
	this.btnLoginText = transform:Find("Button_login/Text").gameObject:GetComponent('Text');
	this.btnRegister = transform:Find("Button_register").gameObject;
	this.btnRegisterText = transform:Find("Button_register/Text").gameObject:GetComponent('Text');
	this.inputUsername = transform:Find("InputField_username").gameObject;
	this.account = transform:Find("InputField_username/accountBg/Text").gameObject:GetComponent('Text');
	this.InputField_show = transform:Find("InputField_show").gameObject:GetComponent("InputField");
	this.InputField_hide = transform:Find("InputField_hide").gameObject:GetComponent("InputField");
	this.inputUsernameTest = transform:Find("InputField_username/Placeholder").gameObject:GetComponent('Text');
	this.inputPassword = transform:Find("InputField_password").gameObject;
	this.password = transform:Find("InputField_password/passwordBg/Text").gameObject:GetComponent('Text');
	this.forget = transform:Find("InputField_password/forget").gameObject;  --Recover password
	this.inputPasswordTest = transform:Find("InputField_password/Placeholder").gameObject:GetComponent('Text');
	this.textStatus = transform:Find("Text_status").gameObject;
	this.remember = transform:Find("InputField_password/remember").gameObject:GetComponent("Toggle");   --Remember password
	this.rememberText = transform:Find("InputField_password/remember/Text").gameObject:GetComponent("Text");   --Remember password
	this.eye = transform:Find("InputField_password/eye").gameObject;   --Whether to show the password
	this.closeEye = transform:Find("InputField_password/eye/closeeye");   --Hide password
	this.openEye = transform:Find("InputField_password/eye/openeye");   --show password
	--this.norm = transform:Find("Button_login/norm").gameObject:GetComponent("Toggle");   --Consent guidelines
	--this.normText = transform:Find("Button_login/norm/normText").gameObject;   --User Guidelines
	--this.agree = transform:Find("Button_login/norm/normText/agree").gameObject:GetComponent("Text");

	--multi-language
	this.choose = transform:Find("language/choose").gameObject;
	this.languageText = transform:Find("language/languageText").gameObject:GetComponent('Text');
	this.closeBg = transform:Find("language/closeBg").gameObject;
	this.languageBg = transform:Find("language/languageBg");
	this.content = transform:Find("language/languageBg/Scroll View/Viewport/Content");
end

function LoginPanel.Start()

end
--Click event--
function LoginPanel.OnDestroy()

end

