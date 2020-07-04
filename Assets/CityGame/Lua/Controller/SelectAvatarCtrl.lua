-----

SelectAvatarCtrl = {};
local this = SelectAvatarCtrl;

local selectAvatar;
local transform;
local gameObject;

--Building function--
function SelectAvatarCtrl.New()
	logWarn("SelectAvatarCtrl.New--->>");
	Event.AddListener("onRemoveAvatar", this.onRemoveAvatar);
	return this;
end

function SelectAvatarCtrl.Awake()
	logWarn("SelectAvatarCtrl.Awake--->>");
	panelMgr:LoadPrefab_A('SelectAvatar', nil, this, this.OnCreate);
end

--Start event--
function SelectAvatarCtrl.OnCreate(obj)
	gameObject = ct.InstantiatePrefab(obj);
	transform = gameObject.transform;

	selectAvatar = transform:GetComponent('LuaBehaviour');
	logWarn("Start lua--->>"..gameObject.name);

	selectAvatar:AddClick(SelectAvatarPanel.btnCreateAvatar, this.OnReqCreateAvatar);
	selectAvatar:AddClick(SelectAvatarPanel.btnRemoveAvatar, this.OnReqRemoveAvatar);
	selectAvatar:AddClick(SelectAvatarPanel.btnEnterGame, this.OnReqEnterGame);
	--resMgr:LoadPrefab('prompt', { 'PromptItem' }, this.InitPanel);

	--After the new is created, control operations
	this.UpdateAvatarList();
	
end

function SelectAvatarCtrl.SetAvatars( avatarList )
	this.avatars = avatarList;
end
function SelectAvatarCtrl.UpdateAvatarList()

	local i = 1;
	for k,v in pairs(this.avatars) do
		SelectAvatarPanel.btnAvatar[i].transform:Find('Label'):GetComponent('Text').text = v["name"];
		i = i + 1;
	end
    for j=i,3 do
    	SelectAvatarPanel.btnAvatar[j].transform:Find('Label'):GetComponent('Text').text = "空";
    end
end

function  SelectAvatarCtrl.OnReqCreateAvatar(go)
    --Open the role creation interface
    local ctrl = CtrlManager.GetCtrl(CtrlNames.CreateAvatar);
    if ctrl ~= nil then
        ctrl.Awake();
    end

    --Close the current interface
    this.Close();
end

--Delete character--
function SelectAvatarCtrl.OnReqRemoveAvatar(go)
	local name = "";
	for i=1,3 do
		if SelectAvatarPanel.btnAvatar[i].transform:GetComponent('Toggle').isOn == true then
			name = SelectAvatarPanel.btnAvatar[i].transform:Find('Label'):GetComponent('Text').text;
		end
	end

	local p = CityEngineLua.player();
	if p ~= nil then
		p:reqRemoveAvatar(name);
	end
end

function SelectAvatarCtrl.OnReqEnterGame(go)
   	local name, dbid;
   	local p = CityEngineLua.player();
	if p ~= nil then
		for i=1,3 do
			if SelectAvatarPanel.btnAvatar[i].transform:GetComponent('Toggle').isOn == true then
				name = SelectAvatarPanel.btnAvatar[i].transform:Find('Label'):GetComponent('Text').text;
				break;
			end
		end
		for key, value in pairs(this.avatars) do
			if value["name"] == name then
				dbid = key;
			end
		end
		p:reqSelectAvatarGame(dbid);
	end
end

--------------------Events sent by data-----------------------------


function SelectAvatarCtrl.onRemoveAvatar( dbid, dic )
	this.avatars = dic;
	this.UpdateAvatarList();
end



--Close event--
function SelectAvatarCtrl.Close()
	--panelMgr:ClosePanel(CtrlNames.SelectAvatar);
	destroy(gameObject);
end