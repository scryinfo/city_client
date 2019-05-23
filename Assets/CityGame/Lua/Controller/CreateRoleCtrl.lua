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

    CreateRolePanel.nicknameText.text = GetLanguage(10040008)
    CreateRolePanel.companynameText.text = GetLanguage(10040009)
    CreateRolePanel.name.text = GetLanguage(10040001)
    CreateRolePanel.duplicateText.text = GetLanguage(10040004)
    CreateRolePanel.Companyname.text = GetLanguage(10040005)
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
        Event.Brocast("SmallPop",GetLanguage(10040006),300)
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
function CreateRoleCtrl:c_SameName()
    CreateRolePanel.duplicateText.transform.localScale = Vector3.one
end