-----

CreateAvatarCtrl = {};
local this = CreateAvatarCtrl;

local CreateAvatar;
local transform;
local gameObject;

--Build function--
function CreateAvatarCtrl.New()
	logWarn("CreateAvatarCtrl.New--->>");
	return this;
end

function CreateAvatarCtrl.Awake()
	logWarn("CreateAvatarCtrl.Awake--->>");
	panelMgr:LoadPrefab_A('CreateAvatar', nil, this, this.OnCreate);

	Event.AddListener("onCreateAvatarResult", this.onCreateAvatarResult);
end

--Start event--
function CreateAvatarCtrl.OnCreate(obj)
	gameObject = ct.InstantiatePrefab(obj);

	CreateAvatar = gameObject:GetComponent('LuaBehaviour');
	CreateAvatar:AddClick(CreateAvatarPanel.btnCreateAvatar, this.OnCreateAvatar);
	CreateAvatar:AddClick(CreateAvatarPanel.btnCancel, this.OnCancel);

	logWarn("Start lua--->>"..gameObject.name);

end

function CreateAvatarCtrl.OnCreateAvatar()
	local role = "战士";
	for i=1,2 do
		if CreateAvatarPanel.toggleProf[i].transform:GetComponent('Toggle').isOn == true then
			if i == 1 then
				role = "战士";
			else
				role = "法师";
			end
		end
	end

	local p = CityEngineLua.player();
	if p ~= nil then
		p:reqCreateAvatar(CreateAvatarPanel.inputCreateAvatarName:GetComponent('InputField').text, role);
	end
end

function  CreateAvatarCtrl.OnCancel()
	this.Close();
	--New select role interface
    local ctrl = CtrlManager.GetCtrl(CtrlNames.SelectAvatar);
    if ctrl ~= nil then
        ctrl.Awake();
    end
end

--------------Callback--------------------------------------------------
function CreateAvatarCtrl.onCreateAvatarResult( errorCode, dic )
	if errorCode ~= 0 then
		CreateAvatarPanel.textStatus:GetComponent('Text').text = "创建失败，错误码："..errorCode;
		return;
	end

	this.Close();
	--New select role interface
    local ctrl = CtrlManager.GetCtrl(CtrlNames.SelectAvatar);
    if ctrl ~= nil then
        ctrl.Awake();
        ctrl.SetAvatars(dic);
    end
end

--Close event--
function CreateAvatarCtrl.Close()
	destroy(gameObject);
end