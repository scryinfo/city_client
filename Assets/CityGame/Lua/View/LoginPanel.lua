local transform;
local gameObject;

LoginPanel = {};
local this = LoginPanel;

--启动事件--
function LoginPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function LoginPanel.InitPanel()
	this.btnLogin = transform:Find("Button_login").gameObject;
	this.btnLoginText = transform:Find("Button_login/Text").gameObject:GetComponent('Text');
	this.btnRegister = transform:Find("Button_register").gameObject;
	this.inputUsername = transform:Find("InputField_username").gameObject;
	this.inputUsernameTest = transform:Find("InputField_username/Placeholder").gameObject:GetComponent('Text');
	this.inputPassword = transform:Find("InputField_password").gameObject;
	this.inputPasswordTest = transform:Find("InputField_password/Placeholder").gameObject:GetComponent('Text');
	this.textStatus = transform:Find("Text_status").gameObject;
end

function LoginPanel.Start()

end
--单击事件--
function LoginPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

