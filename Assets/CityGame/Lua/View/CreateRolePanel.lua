local transform;
local gameObject;

CreateRolePanel = {};
local this = CreateRolePanel;

--Start event--
function CreateRolePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--Initialization panel----
function CreateRolePanel.InitPanel()
    this.createRoleBtn = transform:Find("CreateRoleButton").gameObject;
    this.nameText = transform:Find("nameBg/name").gameObject:GetComponent("Text");
    this.back = transform:Find("back").gameObject;
    this.nickname = transform:Find("InputField_Nickname").gameObject;
    this.name = transform:Find("InputField_Nickname/nickNameBg/Nickname").gameObject:GetComponent("Text");
    this.nicknameText = transform:Find("InputField_Nickname/Placeholder").gameObject:GetComponent("Text");
    this.companyname = transform:Find("InputField_Companyname").gameObject;
    this.CompanyName = transform:Find("InputField_Companyname/conmpanyNameBg/conmpanyName").gameObject:GetComponent("Text");
    this.companynameText = transform:Find("InputField_Companyname/Placeholder").gameObject:GetComponent("Text");
    this.nicknameDuplicateText = transform:Find("InputField_Nickname/hint"):GetComponent("Text");
    this.companynameDuplicateText = transform:Find("InputField_Companyname/hint"):GetComponent("Text");
    this.create = transform:Find("CreateRoleButton/Text"):GetComponent("Text");
end
