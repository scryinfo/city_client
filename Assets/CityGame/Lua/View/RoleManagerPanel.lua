
local transform;
local gameObject;

RoleManagerPanel = {};
local this = RoleManagerPanel;

--Start event--
function RoleManagerPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--Initialize the panel--
function RoleManagerPanel.InitPanel()
    this.createRoleButton = transform:Find("DownPanel/CreateRoleButton").gameObject;
    this.selectRoleButton = transform:Find("DownPanel/SelectRoleButton").gameObject;
    this.startRoleButton = transform:Find("DownPanel/StartGameButton").gameObject;
end