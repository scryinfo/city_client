local transform;
local gameObject;

SelectAvatarPanel = {};
local this = SelectAvatarPanel;

--Start event--
function SelectAvatarPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--Initial panel--
function SelectAvatarPanel.InitPanel()
	this.btnCreateAvatar = transform:Find("Button_CreateAvatar").gameObject;
	this.btnRemoveAvatar = transform:Find('Button_RemoveAvatar').gameObject;
	this.btnEnterGame = transform:Find('Button_EnterGame').gameObject;
	this.btnAvatar = {};
	this.btnAvatar[1] = transform:Find('Avatars/Toggle0').gameObject;
	this.btnAvatar[2] = transform:Find('Avatars/Toggle1').gameObject;
	this.btnAvatar[3] = transform:Find('Avatars/Toggle2').gameObject;
    
end

--Click event--
function SelectAvatarPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end