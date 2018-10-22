local transform;
local gameObject;

CreateRolePanel = {};
local this = CreateRolePanel;

--启动事件--
function CreateRolePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CreateRolePanel.InitPanel()
    this.createRoleBtn = transform:Find("DownCreateRole/CreateRoleButton").gameObject;
end
