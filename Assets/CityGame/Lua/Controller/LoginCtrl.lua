require('Controller/RoleManagerCtrl')
require('Controller/ServerListCtrl')

LoginCtrl = class('LoginCtrl',UIPanel)
UIPanel:ResgisterOpen(LoginCtrl) --这个是注册打开的类方法

LoginCtrl.SmallPop_Path="View/GoodsItem/TipsParticle"--小弹窗路径
require'View/BuildingInfo/SmallPopItem'--小弹窗脚本
--构建函数--
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
	self.insId = OpenModelInsID.LoginCtrl

	--注册点击事件
	local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
	BuilldingBubbleInsManger.LuaBehaviour=LuaBehaviour
	LuaBehaviour:AddClick(LoginPanel.btnLogin, self.OnLogin,self);
	LuaBehaviour:AddClick(LoginPanel.btnRegister, self.OnRegister,self);
	--LuaBehaviour:AddClick(LoginPanel.btnChooseGameServer, self.onClickChooseGameServer,self);

	self.root=self.gameObject.transform.root;
end

function LoginCtrl:Active()
	UIPanel.Active(self)
	--普通消息注册
	Event.AddListener("c_onLoginFailed", self.c_onLoginFailed, self);
	Event.AddListener("c_LoginSuccessfully", self.c_LoginSuccessfully, self);
	Event.AddListener("c_GsConnected", self.c_GsConnected, self);
	Event.AddListener("c_ConnectionStateChange", self.c_ConnectionStateChange, self);
	Event.AddListener("c_Disconnect", self.c_Disconnect, self);
	--Event.AddListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);

	-----小弹窗
	Event.AddListener("SmallPop",self.c_SmallPop,self)

	--多语言
	LoginPanel.inputUsernameTest.text = GetLanguage(10020001)
	LoginPanel.inputPasswordTest.text = GetLanguage(10020002)
	LoginPanel.btnLoginText.text = GetLanguage(10020003)
	--local path = GetLanguage(10020003)
	--LoadSprite(path, LoginPanel.btnLogin:GetComponent("Image"), true)

end

function LoginCtrl:Refresh()
	ct.log("abel_w6_UIFrame_1","[LoginCtrl:Refresh] UI数据刷新， 数据为: m_data =",self.m_data);
	self:_initData()
	--if self.m_data ~= nil then
	--	self:setPosition(self.m_data.x,self.m_data.y)
	--end
end

function LoginCtrl:Hide()
	UIPanel.Hide(self)
	self:close()
end

function LoginCtrl:_initData()
	DataManager.OpenDetailModel(LoginModel,self.insId)
end
--启动事件--
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

--关闭事件--
function LoginCtrl:close()
	Event.RemoveListener("c_onLoginFailed", self.c_onLoginFailed);
	Event.RemoveListener("c_LoginSuccessfully", self.c_LoginSuccessfully);
	Event.RemoveListener("c_GsConnected", self.c_GsConnected);
	Event.RemoveListener("c_ConnectionStateChange", self.c_ConnectionStateChange);
	Event.RemoveListener("c_Disconnect", self.c_Disconnect);
	--Event.RemoveListener("c_GsLoginSuccess", self.c_GsLoginSuccess);
	Event.Brocast("c_RemoveListener")
	destroy(self.gameObject);
end

function LoginCtrl:onClickChooseGameServer(serverId)
	Event.Brocast("m_chooseGameServer", serverId);
end
--登录--
function LoginCtrl:OnLogin(go)
	PlayMusEff(1002)
	local username = LoginPanel.inputUsername:GetComponent('InputField').text;
	local pw = LoginPanel.inputPassword:GetComponent('InputField').text;
	if username == "" then
		--ct.log("system"," 账号不能为空")
		Event.Brocast("SmallPop",GetLanguage(10020004),300)
	else
		--CityEngineLua.login(username, pw, "lxq");
		Event.Brocast("m_OnAsLogin", username, pw, "lxq");
		LoginPanel.btnLogin:GetComponent("Button").enabled = false
	end
end
--注册--
function LoginCtrl:OnRegister(go)
	PlayMusEff(1002)
	if go.logined == false then
		ct.log("system","点击 登录按钮 连接账号服务器，然后才能登录游戏服务器")
	else
		--目前还没有手动注册
		Event.Brocast("m_Gslogin");
	end
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
	--LoginPanel.textStatus:GetComponent('Text').text = "服务器断开连接， 错误码： "..errorCode;
	--logDebug("cz login 登录失败,error code: ", errorCode)
end

--[[function LoginCtrl:c_GsLoginSuccess()
	--UIPanel:ClearAllPages()
	--UIPanel:ShowPage(RoleManagerCtrl)
	--UIPanel:ShowPage(TopBarCtrl)
	--UIPanel:ShowPage(MainPageCtrl,"UI数据传输测试")
end--]]

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
		--LoginPanel.textStatus:GetComponent('Text').text = "Game server 连接成功!";
	else
		--LoginPanel.textStatus:GetComponent('Text').text = "Game server 连接失败";
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

--生成预制
function LoginCtrl:c_creatGoods(path,parent)
	local prefab = UnityEngine.Resources.Load(path);
	local go = UnityEngine.GameObject.Instantiate(prefab);
	local rect = go.transform:GetComponent("RectTransform");
	go.transform:SetParent(parent);--.transform
	rect.transform.localScale = Vector3.one;
	rect.transform.localPosition=Vector3.zero
	return go
end
---小弹窗
function LoginCtrl:c_SmallPop(string,spacing)
	if not self.prefab  then
		self.prefab =self:c_creatGoods(self.SmallPop_Path,self.root)
	end
	SmallPopItem:new(string,spacing,self.prefab ,self);
end


