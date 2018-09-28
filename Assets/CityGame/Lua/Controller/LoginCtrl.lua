require "Common/define"

require('Framework/UI/UIPage')
local class = require 'Framework/class'
LoginCtrl = class('LoginCtrl',UIPage)

local login;
local transform;
local gameObject;

--构建函数--
function LoginCtrl:initialize()
	UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
	self.uiPath = "Login"
end

function LoginCtrl:Awake(go)
	log("abel_w6_UIFrame","LoginCtrl:Awake--->>");
	self.gameObject = go
end

--启动事件--
function LoginCtrl:OnCreate(obj)
	UIPage.OnCreate(self,obj)
	login = self.gameObject:GetComponent('LuaBehaviour');
	login:AddClick(LoginPanel.btnLogin, self.OnLogin);
	login:AddClick(LoginPanel.btnRegister, self.OnRegister);
	login:AddClick(LoginPanel.btnChooseGameServer, self.onClickChooseGameServer);

	log("abel_w6_UIFrame","Start lua--->>"..self.gameObject.name);
	--普通消息注册
	Event.AddListener("c_onLoginFailed", self.c_onLoginFailed, self);
	Event.AddListener("c_LoginSuccessfully", self.c_LoginSuccessfully, self);
	Event.AddListener("c_GsConnected", self.c_GsConnected, self);
	Event.AddListener("c_ConnectionStateChange", self.c_ConnectionStateChange, self);
	Event.AddListener("c_Disconnect", self.c_Disconnect, self);

	--启用 c_AddClick_self 单元测试
	UnitTest.Exec_now("abel_w5", "c_AddClick_self",self)
end

function LoginCtrl:onClickChooseGameServer(serverId)
	Event.Brocast("m_chooseGameServer", serverId);
end
--登录--
function LoginCtrl:OnLogin(go)
	local username = LoginPanel.inputUsername:GetComponent('InputField').text;
	local pw = LoginPanel.inputPassword:GetComponent('InputField').text;
	--CityEngineLua.login(username, pw, "lxq");
	Event.Brocast("m_OnAsLogin", username, pw, "lxq");
end
--注册--
function LoginCtrl:OnRegister(go)
    --目前还没有手动注册
    Event.Brocast("m_Gslogin");
end

--关闭事件--
function LoginCtrl:Close()
	--panelMgr:ClosePanel(CtrlNames.Login);
	destroy(gameObject);
	--Event.RemoveListener("c_LoginSuccessfully", self.c_LoginSuccessfully);
	Event.RemoveListener("c_onLoginFailed", self.c_onLoginFailed);
	Event.RemoveListener("c_LoginSuccessfully", self.c_LoginSuccessfully);
	Event.RemoveListener("c_GsConnected", self.c_GsConnected);
	Event.RemoveListener("c_ConnectionStateChange", self.c_ConnectionStateChange);
	Event.RemoveListener("c_Disconnect", self.c_Disconnect);
end

------------------回调--------------
function LoginCtrl:onReqAvatarList( avatarList )
	-- 关闭登录界面
    --self.Close();
    --local ctrl = CtrlManager.GetCtrl(CtrlNames.SelectAvatar);
    --if ctrl ~= nil then
        --ctrl.SelectAvatar(avatarList);
        --ctrl.Awake();
    --end
	Event.Brocast("ReqAvatarList", username, pw, "lxq");
end

function LoginCtrl:c_Disconnect( errorCode )
	--这里打印会失败, LoginPanel 已经不能访Destroy问了
	LoginPanel.textStatus:GetComponent('Text').text = "服务器断开连接， 错误码： "..errorCode;
	--logDebug("cz login 登录失败,error code: ", errorCode)
end

function  LoginCtrl:c_onCreateAccountResult( errorCode, data )
	if errorCode ~= 0 then
		LoginPanel.textStatus:GetComponent('Text').text = "账号注册错误"..errorCode;
	else
		LoginPanel.textStatus:GetComponent('Text').text = "注册账号成功! 请点击登录进入游戏";
	end
end

function LoginCtrl:c_onLoginFailed( errorCode )
	LoginPanel.textStatus:GetComponent('Text').text = "登录失败"..errorCode;
end

function LoginCtrl:c_ConnectionStateChange( isSuccess )
	if isSuccess == true then
		LoginPanel.textStatus:GetComponent('Text').text = "连接成功，正在登陆";
	else
		LoginPanel.textStatus:GetComponent('Text').text = "连接错误";
	end
end

function LoginCtrl:c_LoginSuccessfully( success )
	if success then
		LoginPanel.textStatus:GetComponent('Text').text = "登录成功";
	else
		LoginPanel.textStatus:GetComponent('Text').text = "登录失败";
	end
end

function LoginCtrl:c_GsConnected( success )
	if success then
		LoginPanel.textStatus:GetComponent('Text').text = "Game server 连接成功!";
	else
		LoginPanel.textStatus:GetComponent('Text').text = "Game server 连接失败";
	end
end

function LoginCtrl:gettestValue()
	return testValue
end

function LoginCtrl:OnClickTest(obj)
	log("abel_w5","[test_AddClick_self]  OnClickTest obj == nil")
	local xxx = obj
	local x = LoginCtrl.testValue
	local yyy = LoginCtrl:gettestValue()
	local xxx1  = xxx
end

function LoginCtrl:OnClickTest1(obj)
	log("abel_w5","[test_AddClick_self]  OnClickTest1 obj ~= nil and obj.testValue =",obj.testValue)
	local xxx = obj.testValue
	local x = LoginCtrl.testValue
	local yyy = LoginCtrl:gettestValue()
	local xxx1  = xxx
end
TestGroup.active_TestGroup("abel_w5") --激活测试组

UnitTest.Exec("abel_w4", "test_OnLogin",  function ()
	log("abel_w7","[test_OnLogin]  测试开始")
	LoginCtrl:c_LoginSuccessfully( false )
end)

UnitTest.Exec("abel_w5", "test_AddClick_self",  function ()
	log("abel_w5","[test_AddClick_self]  测试开始")
	Event.AddListener("c_AddClick_self", function (obj)
		obj.testValue = 666
		login = obj.gameObject:GetComponent('LuaBehaviour')
		login:AddClick(LoginPanel.btnLogin ,obj.OnClickTest);
		login:AddClick(LoginPanel.btnLogin ,obj.OnClickTest1,obj);
	end)
end)




