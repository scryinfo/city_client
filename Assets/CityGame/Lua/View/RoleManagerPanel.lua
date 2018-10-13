
local transform;
local gameObject;

RoleManagerPanel = {};
local this = RoleManagerPanel;

--启动事件--
function RoleManagerPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function RoleManagerPanel.InitPanel()
    this.createRoleButton = transform:Find("DownPanel/CreateRoleButton").gameObject;
    this.selectRoleButton = transform:Find("DownPanel/SelectRoleButton").gameObject;
    this.startRoleButton = transform:Find("DownPanel/StartGameButton").gameObject;
end