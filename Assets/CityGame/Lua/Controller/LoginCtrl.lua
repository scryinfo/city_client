require "Common/define"

LoginCtrl = {};
local this = LoginCtrl;

local login;
local transform;
local gameObject;

--构建函数--
function LoginCtrl.New()
	logDebug("LoginCtrl.New--->>");
	return this;
end

function LoginCtrl.Awake()
	logDebug("LoginCtrl.Awake--->>");
	panelMgr:CreatePanel('Login', this.OnCreate);
end

--启动事件--
function LoginCtrl.OnCreate(obj)
	gameObject = obj;

	login = gameObject:GetComponent('LuaBehaviour');
	login:AddClick(LoginPanel.btnLogin, this.OnLogin);
	login:AddClick(LoginPanel.btnRegister, this.OnRegister);
	login:AddClick(LoginPanel.btnChooseGameServer, this.onClickChooseGameServer);

	logDebug("Start lua--->>"..gameObject.name);
	--普通消息注册
	Event.AddListener("c_onLoginFailed", this.c_onLoginFailed);
	Event.AddListener("c_LoginSuccessfully", this.c_LoginSuccessfully);
	Event.AddListener("c_GsConnected", this.c_GsConnected);
	Event.AddListener("c_ConnectionStateChange", this.c_ConnectionStateChange);
	Event.AddListener("c_Disconnect", this.c_Disconnect);

end

function LoginCtrl.onClickChooseGameServer(serverId)
	Event.Brocast("m_chooseGameServer", serverId);
end
--登录--
function LoginCtrl.OnLogin(go)
	local username = LoginPanel.inputUsername:GetComponent('InputField').text;
	local pw = LoginPanel.inputPassword:GetComponent('InputField').text;
	--CityEngineLua.login(username, pw, "lxq");
	Event.Brocast("m_OnAsLogin", username, pw, "lxq");
end
--注册--
function LoginCtrl.OnRegister(go)
    --目前还没有手动注册
    Event.Brocast("m_Gslogin");
end

--关闭事件--
function LoginCtrl.Close()
	--panelMgr:ClosePanel(CtrlNames.Login);
	destroy(gameObject);
	--Event.RemoveListener("c_LoginSuccessfully", this.c_LoginSuccessfully);
	Event.RemoveListener("c_onLoginFailed", this.c_onLoginFailed);
	Event.RemoveListener("c_LoginSuccessfully", this.c_LoginSuccessfully);
	Event.RemoveListener("c_GsConnected", this.c_GsConnected);
	Event.RemoveListener("c_ConnectionStateChange", this.c_ConnectionStateChange);
	Event.RemoveListener("c_Disconnect", this.c_Disconnect);
end

------------------回调--------------
function LoginCtrl.onReqAvatarList( avatarList )
	-- 关闭登录界面
    --this.Close();
    --local ctrl = CtrlManager.GetCtrl(CtrlNames.SelectAvatar);
    --if ctrl ~= nil then
        --ctrl.SelectAvatar(avatarList);
        --ctrl.Awake();
    --end
	Event.Brocast("ReqAvatarList", username, pw, "lxq");
end

function LoginCtrl.c_Disconnect( errorCode )
	--这里打印会失败, LoginPanel 已经不能访Destroy问了
	LoginPanel.textStatus:GetComponent('Text').text = "服务器断开连接， 错误码： "..errorCode;
	--logDebug("cz login 登录失败,error code: ", errorCode)
end

function  LoginCtrl.c_onCreateAccountResult( errorCode, data )
	if errorCode ~= 0 then
		LoginPanel.textStatus:GetComponent('Text').text = "账号注册错误"..errorCode;
	else
		LoginPanel.textStatus:GetComponent('Text').text = "注册账号成功! 请点击登录进入游戏";
	end
end

function LoginCtrl.c_onLoginFailed( errorCode )
	LoginPanel.textStatus:GetComponent('Text').text = "登录失败"..errorCode;
end

function LoginCtrl.c_ConnectionStateChange( isSuccess )
	if isSuccess == true then
		LoginPanel.textStatus:GetComponent('Text').text = "连接成功，正在登陆";
	else
		LoginPanel.textStatus:GetComponent('Text').text = "连接错误";
	end
end

function LoginCtrl.c_LoginSuccessfully( success )
	if success then
		LoginPanel.textStatus:GetComponent('Text').text = "登录成功";
	else
		LoginPanel.textStatus:GetComponent('Text').text = "登录失败";
	end
end

function LoginCtrl.c_GsConnected( success )
	if success then
		LoginPanel.textStatus:GetComponent('Text').text = "Game server 连接成功!";
	else
		LoginPanel.textStatus:GetComponent('Text').text = "Game server 连接失败";
	end
end

--TestGroup.active_TestGroup("abel_w7") --激活测试组

UnitTest("abel_w7", "test_OnLogin",  function ()
	log("abel_w7","[test_OnLogin]  测试完毕")
	LoginCtrl.c_LoginSuccessfully( false )
end)




