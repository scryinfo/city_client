require('Controller/RoleManagerCtrl')
require('Controller/ServerListCtrl')

LoginCtrl = class('LoginCtrl',UIPanel)
UIPanel:ResgisterOpen(LoginCtrl) --This is the registered open class method

require'View/BuildingInfo/SmallPopItem'--Small popup script
--Constructor--
function LoginCtrl:initialize()
	UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)

	self.logined = false
	--self.offset.y = -200

	--self.uiPath = "Login"
end

function LoginCtrl:bundleName()
	return "Assets/CityGame/Resources/View/LoginPanel.prefab"
end

function LoginCtrl:Awake(go)
	ct.log("abel_w6_UIFrame","LoginCtrl:Awake--->>");
	self.gameObject = go
	UnityEngine.GameObject.AddComponent(go, ct.getType(UnityEngine.Input_BanChinse))
	self.insId = OpenModelInsID.LoginCtrl

	--Register click event
	local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
	self.input =  self.gameObject:GetComponent('Input_BanChinse');
	LuaBehaviour:AddClick(LoginPanel.btnLogin, self.OnLogin,self);
	LuaBehaviour:AddClick(LoginPanel.btnRegister, self.OnRegister,self);
	LuaBehaviour:AddClick(LoginPanel.forget, self.OnForget,self);
	LuaBehaviour:AddClick(LoginPanel.eye, self.OnEye,self);  --Whether to show the password
	LuaBehaviour:AddClick(LoginPanel.choose, self.OnChoose,self);  --Open multilingual
	LuaBehaviour:AddClick(LoginPanel.closeBg, self.OnCloseBg,self);  --Turn off multilingual
	--LuaBehaviour:AddClick(LoginPanel.normText, self.OnNormText,self);  --User Guidelines
	--LuaBehaviour:AddClick(LoginPanel.btnChooseGameServer, self.onClickChooseGameServer,self);


	self.showPassword = false


	--multi-language
	local languageId = UnityEngine.PlayerPrefs.GetInt("Language")
	if languageId == 0 then
		LoginPanel.languageText.text = GetLanguage(10020010)
	elseif languageId == 1 then
		LoginPanel.languageText.text = GetLanguage(10020011)
	elseif languageId == 2 then
		LoginPanel.languageText.text = GetLanguage(10020012)
	elseif languageId == 3 then
		LoginPanel.languageText.text = GetLanguage(10020013)
	end
	self.languageItem = {}
	for i, v in ipairs(LanguageTypeConfig) do
		local function callback(prefab)
			self.languageItem[i] = LanguageItem:new(prefab,v,i,LuaBehaviour)
			if self.languageItem[i].data.id == languageId  then
				self.languageItem[i]:Set(self.languageItem[i])
			end
		end
		createPrefab("Assets/CityGame/Resources/View/GoodsItem/LanguageItem.prefab",LoginPanel.content, callback)
	end
	for i, v in pairs(self.languageItem) do
		if v.data.id == languageId  then
           v:Set(v)
		end
	end
	--Do you remember the password
	LoginPanel.remember.onValueChanged:AddListener(function(isOn)
		self:_OnToggle(isOn)
	end)

    --Password cannot be entered in Chinese
	LoginPanel.inputPassword:GetComponent('InputField').onValueChanged:AddListener(function()
		self:_OnPassword(self)
	end)

	--Agree user guidelines
	--LoginPanel.norm.isOn = true
end

function LoginCtrl:Active()
	UIPanel.Active(self)
	--General message registration
	Event.AddListener("c_onLoginFailed", self.c_onLoginFailed, self);
	Event.AddListener("c_LoginSuccessfully", self.c_LoginSuccessfully, self);
	Event.AddListener("c_GsConnected", self.c_GsConnected, self);
	Event.AddListener("c_ConnectionStateChange", self.c_ConnectionStateChange, self);
	Event.AddListener("c_Disconnect", self.c_Disconnect, self);
	Event.AddListener("c_Aslogin", self.c_Aslogin, self);
	Event.AddListener("c_ChangeLanguage", self.c_ChangeLanguage, self);

	--multi-language
	LoginPanel.inputUsernameTest.text = GetLanguage(10020001)
	LoginPanel.account.text = GetLanguage(10020001)
	LoginPanel.inputPasswordTest.text = GetLanguage(10020002)
	LoginPanel.password.text = GetLanguage(10020002)
	LoginPanel.btnLoginText.text = GetLanguage(10020006)
	LoginPanel.btnRegisterText.text = GetLanguage(10020005)
	LoginPanel.forget:GetComponent("Text").text = GetLanguage(10020003)
	LoginPanel.rememberText.text = GetLanguage(10020004)
	--LoginPanel.normText:GetComponent("Text").text = GetLanguage(10020015)
	--LoginPanel.agree.text = GetLanguage(10020014)
end

function LoginCtrl:c_ChangeLanguage()
	--multi-language
	LoginPanel.inputUsernameTest.text = GetLanguage(10020001)
	LoginPanel.account.text = GetLanguage(10020001)
	LoginPanel.inputPasswordTest.text = GetLanguage(10020002)
	LoginPanel.password.text = GetLanguage(10020002)
	LoginPanel.btnLoginText.text = GetLanguage(10020006)
	LoginPanel.btnRegisterText.text = GetLanguage(10020005)
	LoginPanel.forget:GetComponent("Text").text = GetLanguage(10020003)
	LoginPanel.rememberText.text = GetLanguage(10020004)
	--LoginPanel.normText:GetComponent("Text").text = GetLanguage(10020015)
	--LoginPanel.agree.text = GetLanguage(10020014)
end

function LoginCtrl:Refresh()
	--ct.log("abel_w6_UIFrame_1","[LoginCtrl:Refresh] UI数据刷新， 数据为: m_data =",self.m_data);
	self:_initData()
	UnitTest.Exec_now("cycle_0612_flightTest", "e_cycle_0612_flightTest")
end

function LoginCtrl:Hide()
	UIPanel.Hide(self)
	Event.RemoveListener("c_onLoginFailed", self.c_onLoginFailed);
	Event.RemoveListener("c_LoginSuccessfully", self.c_LoginSuccessfully);
	Event.RemoveListener("c_GsConnected", self.c_GsConnected);
	Event.RemoveListener("c_ConnectionStateChange", self.c_ConnectionStateChange);
	Event.RemoveListener("c_Disconnect", self.c_Disconnect);
	Event.RemoveListener("c_Aslogin", self.c_Aslogin);
	Event.RemoveListener("c_ChangeLanguage",self.c_ChangeLanguage,self)

	LoginPanel.inputUsername:GetComponent('InputField').text = ""
	LoginPanel.inputPassword:GetComponent('InputField').text = ""

end

function LoginCtrl:_initData()
	LoginPanel.textStatus.transform.localScale = Vector3.zero
	DataManager.OpenDetailModel(LoginModel,self.insId)
	--Connect as
	--CityEngineLua.login_loginapp(true)
	if UnityEngine.PlayerPrefs.GetString("username") ~= "" then
		LoginPanel.inputUsername:GetComponent('InputField').text = UnityEngine.PlayerPrefs.GetString("username")
	end
	local remember = UnityEngine.PlayerPrefs.GetInt("remember")
	if remember == 0 then
		LoginPanel.remember.isOn = false
		LoginPanel.inputPassword:GetComponent('InputField').text = ""
	elseif remember == 1 then
		LoginPanel.remember.isOn = true
		LoginPanel.inputPassword:GetComponent('InputField').text = UnityEngine.PlayerPrefs.GetString("password")
	end
end
--Start event--
function LoginCtrl:OnCreate(go)
	UIPanel.OnCreate(self,go)

	--ct.log("abel_w6_UIFrame","Start lua--->>"..self.gameObject.name);

	--启用 c_AddClick_self 单元测试
	--ct.log("abel_w7_AddClick","[UnitTest.Exec_now test_AddClick_self] ")
	--UnitTest.Exec_now("abel_w7_AddClick", "c_AddClick_self",self)
	--UnitTest.Exec_now("abel_w7_RemoveClick", "c_RemoveClick_self",self)
	--UnitTest.Exec_now("fisher_w8_RemoveClick", "c_MaterialModel_ShowPage",self)
	--UnitTest.Exec_now("wk24_abel_mutiConnect", "c_wk24_abel_mutiConnect",self)
end

--Close event--
function LoginCtrl:Close()
	UIPanel.Close(self)
	Event.Brocast("c_RemoveListener")
end

function LoginCtrl:onClickChooseGameServer(serverId)
	Event.Brocast("m_chooseGameServer", serverId);
end

--Do you remember the password
function LoginCtrl:_OnToggle(isOn)
	PlayMusEff(1002)
	if isOn then
		UnityEngine.PlayerPrefs.SetInt("remember",1)
	else
		UnityEngine.PlayerPrefs.SetInt("remember",0)
		UnityEngine.PlayerPrefs.SetString("password","")
	end
end

--Password cannot be entered in Chinese
function LoginCtrl:_OnPassword()
	local a = LoginPanel.inputPassword:GetComponent('InputField')
	self.input:BanChinese(a)
end

--Whether to show the password
function LoginCtrl:OnEye(go)
	PlayMusEff(1002)
	go:ShowPassword( not go.showPassword)
end

--Developer password
function LoginCtrl:ShowPassword(isOn)
	if isOn then  --open
		LoginPanel.openEye.localScale = Vector3.one
		LoginPanel.closeEye.localScale = Vector3.zero
		LoginPanel.inputPassword:GetComponent('InputField').contentType = LoginPanel.InputField_show.contentType
		LoginPanel.inputPassword:GetComponent('InputField'):Select();
	else  --close
		LoginPanel.openEye.localScale = Vector3.zero
		LoginPanel.closeEye.localScale = Vector3.one
		LoginPanel.inputPassword:GetComponent('InputField').contentType = LoginPanel.InputField_hide.contentType
		LoginPanel.inputPassword:GetComponent('InputField'):Select();
	end
	self.showPassword = isOn
end

--Open multilingual
function LoginCtrl:OnChoose(go)
	PlayMusEff(1002)
    go:SwitchLanguage(true)
end

--Turn off multilingual
function LoginCtrl:OnCloseBg(go)
	PlayMusEff(1002)
	go:SwitchLanguage(false)
end

--Open user guidelines
function LoginCtrl:OnNormText()
	PlayMusEff(1002)
	--ct.OpenCtrl("UserNanualCtrl")
end

--Open and close multiple languages
function LoginCtrl:SwitchLanguage(isOn)
	if isOn then
		LoginPanel.languageBg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
		LoginPanel.closeBg.transform.localScale = Vector3.one
	else
		LoginPanel.languageBg:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
		LoginPanel.closeBg.transform.localScale = Vector3.zero
	end
end
 --log in
function LoginCtrl:OnLogin(go)
	PlayMusEff(1002)
	LoginPanel.textStatus.transform.localScale = Vector3.zero
	LoginPanel.textStatus:GetComponent('Text').text = ""
	local username = LoginPanel.inputUsername:GetComponent('InputField').text;
	local pw = LoginPanel.inputPassword:GetComponent('InputField').text;

	if username == "" or pw == "" then
		LoginPanel.textStatus.transform.localScale = Vector3.one
		LoginPanel.textStatus:GetComponent('Text').text =GetLanguage(10020008)
	--elseif LoginPanel.norm.isOn == false then
	--	LoginPanel.textStatus.transform.localScale = Vector3.one
	--	LoginPanel.textStatus:GetComponent('Text').text = GetLanguage(10020016)
	else
		Event.Brocast("m_OnAsLogin", username, pw, "lxq");
	end
end

--Login callback
function LoginCtrl:c_Aslogin(info,msgId)
	LoginPanel.textStatus.transform.localScale = Vector3.zero
	LoginPanel.textStatus:GetComponent('Text').text = ""
	if msgId == 0 then
		if info.reason == "accountInFreeze" then
			LoginPanel.textStatus.transform.localScale = Vector3.one
			LoginPanel.textStatus:GetComponent('Text').text = GetLanguage(10020017)
		end
	else
		if info.status == "FAIL_ACCOUNT_UNREGISTER" then
			LoginPanel.textStatus.transform.localScale = Vector3.one
			LoginPanel.textStatus:GetComponent('Text').text = GetLanguage(10020018)
		elseif info.status == "FAIL_ERROR" then
			LoginPanel.textStatus.transform.localScale = Vector3.one
			LoginPanel.textStatus:GetComponent('Text').text = GetLanguage(10020007)
		end
	end
end
--registered--
function LoginCtrl:OnRegister(go)
	PlayMusEff(1002)
	CityEngineLua.currstate = "register"
	CityEngineLua.login_loginapp(true)
	ct.OpenCtrl("InviteCodeCtrl")
end

--Recover password
function LoginCtrl:OnForget()
	PlayMusEff(1002)
	CityEngineLua.currstate = "forget"
	CityEngineLua.login_loginapp(true)
	ct.OpenCtrl("RetrievePasswordCtrl")
end
------------------callback--------------
function LoginCtrl:onReqAvatarList( avatarList )
	-- Close the login interface
    --self.Close();
    --local ctrl = CtrlManager.GetCtrl(CtrlNames.SelectAvatar);
    --if ctrl ~= nil then
        --ctrl.SelectAvatar(avatarList);
        --ctrl.Awake();
    --end
	Event.Brocast("ReqAvatarList", username, pw, "lxq");
end

function LoginCtrl:c_Disconnect( errorCode )
	-- Printing will fail here, LoginPanel can no longer visit Destroy and asked
	--LoginPanel.textStatus:GetComponent('Text').text = "Server disconnected, error code: "..errorCode;
	--logDebug("cz login login failed, error code: ", errorCode)
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

function LoginCtrl:c_ConnectionStateChange( state )

end

function LoginCtrl:c_LoginSuccessfully( success )
	if success then
		if LoginPanel.textStatus:GetComponent('Text') ~= nil then
			LoginPanel.textStatus:GetComponent('Text').text = "登录成功";
			self.logined = true
		end
	else
		LoginPanel.textStatus:GetComponent('Text').text = "登录失败";
	end
end

function LoginCtrl:c_GsConnected( success )
	if success then
		--LoginPanel.textStatus:GetComponent('Text').text = "Game server connection succeeded!";
	else
		--LoginPanel.textStatus:GetComponent('Text').text = "Game server Connection failed";
	end
end

function LoginCtrl:gettestValue()
	return testValue
end

function LoginCtrl:OnClickTest(obj)
	ct.log("abel_w7_AddClick","[test_AddClick_self]  OnClickTest obj == nil")
	local xxx = obj
	local x = LoginCtrl.testValue
	local yyy = LoginCtrl:gettestValue()
	local xxx1  = xxx
end

function LoginCtrl:OnClickTest1(obj)
	ct.log("abel_w7_AddClick","[test_AddClick_self]  OnClickTest1 obj ~= nil and obj.testValue =",obj.testValue)
	local xxx = obj.testValue
	local x = LoginCtrl.testValue
	local yyy = LoginCtrl:gettestValue()
	local xxx1  = xxx
end

UnitTest.TestBlockStart()-------------------------------------------------------------

UnitTest.Exec("abel_w4", "test_OnLogin",  function ()
	ct.log("abel_w7","[test_OnLogin]  测试开始")
	LoginCtrl:c_LoginSuccessfully( false )
end)

--ct.log("abel_w7_AddClick","[UnitTest.Exec test_AddClick_self] ")
UnitTest.Exec("abel_w7_AddClick", "test_AddClick_self",  function ()
	ct.log("abel_w7_AddClick","[test_AddClick_self]  测试开始")
	Event.AddListener("c_AddClick_self", function (obj)
		obj.testValue = 888
		local LuaBehaviour = obj.gameObject:GetComponent('LuaBehaviour')
		LuaBehaviour:AddClick(LoginPanel.btnLogin ,obj.OnClickTest);
		LuaBehaviour:AddClick(LoginPanel.btnLogin ,obj.OnClickTest1,obj);
	end)
end)

UnitTest.Exec("abel_w7_RemoveClick", "test_RemoveClick_self",  function ()
	ct.log("abel_w7_RemoveClick","[test_RemoveClick_self]  测试开始")
	Event.AddListener("c_RemoveClick_self", function (obj)
		obj.testValue = 666
		local LuaBehaviour = obj.gameObject:GetComponent('LuaBehaviour')
		LuaBehaviour:AddClick(LoginPanel.btnLogin ,obj.OnClickTest1,obj);
		LuaBehaviour:RemoveClick(LoginPanel.btnLogin ,obj.OnClickTest1,obj);
	end)
end)

function LoginCtrl:rpcTest(a,b)
	ct.log("abel_w17_ctrlRpcTest","[rpcTest] invoked")
	return a+b
end

UnitTest.TestBlockEnd()---------------------------------------------------------------

