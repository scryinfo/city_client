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
    this.createRoleBtn = transform:Find("CreateRoleButton").gameObject;
    this.male = transform:Find("male").gameObject;
    this.female = transform:Find("female").gameObject;
    this.nickname = transform:Find("InputField_Nickname").gameObject;
    this.companyname = transform:Find("InputField_Companyname").gameObject;
    this.maleScl = transform:Find("male/select");
    this.femaleScl = transform:Find("female/select");
    this.duplicate = transform:Find("InputField_Nickname/Duplicate");
end
