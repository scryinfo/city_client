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
    this.maleText = transform:Find("male/Text").gameObject:GetComponent("Text");
    this.female = transform:Find("female").gameObject;
    this.femaleText = transform:Find("female/Text").gameObject:GetComponent("Text");
    this.nickname = transform:Find("InputField_Nickname").gameObject;
    this.name = transform:Find("InputField_Nickname/Nickname").gameObject:GetComponent("Text");
    this.nicknameText = transform:Find("InputField_Nickname/Placeholder").gameObject:GetComponent("Text");
    this.companyname = transform:Find("InputField_Companyname").gameObject;
    this.Companyname = transform:Find("InputField_Companyname/Conmpanyname").gameObject:GetComponent("Text");
    this.companynameText = transform:Find("InputField_Companyname/Placeholder").gameObject:GetComponent("Text");
    this.maleScl = transform:Find("male/select");
    this.femaleScl = transform:Find("female/select");
    this.duplicate = transform:Find("InputField_Nickname/Duplicate");
    this.duplicateText = transform:Find("InputField_Nickname/Duplicate/Text"):GetComponent("Text");
end
