-----
-----

CreateRoleCtrl = class('CreateRoleCtrl',UIPanel)
UIPanel:ResgisterOpen(CreateRoleCtrl)

local createRoleBehaviour;
local gender = nil;

function  CreateRoleCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CreateRolePanel.prefab"
end

function CreateRoleCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function CreateRoleCtrl:Refresh()
    self:_initInsData()
end

function CreateRoleCtrl:Awake()
    self.insId = OpenModelInsID.CreateRoleCtrl

    createRoleBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    createRoleBehaviour:AddClick(CreateRolePanel.createRoleBtn,self.OnCreateRole,self)
    createRoleBehaviour:AddClick(CreateRolePanel.back,self.OnBack,self)

end

function CreateRoleCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_SameName",self.c_SameName,self)

    CreateRolePanel.nicknameText.text = GetLanguage(10070002)
    CreateRolePanel.companynameText.text = GetLanguage(10070003)
    CreateRolePanel.name.text = GetLanguage(10070002)
    CreateRolePanel.CompanyName.text = GetLanguage(10070003)
    CreateRolePanel.nameText.text = GetLanguage(10070001)
    CreateRolePanel.create.text = GetLanguage(10070008)
end

function CreateRoleCtrl:_initInsData()
    DataManager.OpenDetailModel(CreateRoleModel,self.insId )

end

function CreateRoleCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_SameName",self.c_SameName,self)
end

function CreateRoleCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function CreateRoleCtrl:OnBack()
    UIPanel.ClosePage()
end

--创建角色
function CreateRoleCtrl:OnCreateRole(go)
    PlayMusEff(1002)
    local nickname = CreateRolePanel.nickname:GetComponent('InputField').text;
    local companyname = CreateRolePanel.companyname:GetComponent('InputField').text;
    if nickname == "" or companyname == "" then
        CreateRolePanel.nicknameDuplicateText.transform.localScale = Vector3.one
        CreateRolePanel.nicknameDuplicateText.text = GetLanguage(10070009)
    else
        local data = {}
        data.nickname = nickname
        data.companyname = companyname
        data.gender = go.m_data.gender
        data.faceId = go.m_data.faceId
        DataManager.DetailModelRpcNoRet(go.insId , 'm_createNewRole',data)
    end
end

--重名
function CreateRoleCtrl:c_SameName(reason)
    if reason == "roleNameDuplicated" then
        CreateRolePanel.companynameDuplicateText.transform.localScale = Vector3.zero
        CreateRolePanel.nicknameDuplicateText.transform.localScale = Vector3.one
        CreateRolePanel.nicknameDuplicateText.text = GetLanguage(10070005)
    elseif reason == "notAllow" then
        CreateRolePanel.companynameDuplicateText.transform.localScale = Vector3.one
        CreateRolePanel.nicknameDuplicateText.transform.localScale = Vector3.zero
        CreateRolePanel.companynameDuplicateText.text = GetLanguage(10070006)
    end
end