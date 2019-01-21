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
    createRoleBehaviour:AddClick(CreateRolePanel.male,self.OnMale,self)
    createRoleBehaviour:AddClick(CreateRolePanel.female,self.OnFemale,self)

end

function CreateRoleCtrl:Active()
    Event.AddListener("c_SameName",self.c_SameName,self)
end

function CreateRoleCtrl:_initInsData()
    DataManager.OpenDetailModel(CreateRoleModel,self.insId )

end

function CreateRoleCtrl:Hide()
    Event.RemoveListener("c_SameName",self.c_SameName,self)
end

function CreateRoleCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

--创建角色
function CreateRoleCtrl:OnCreateRole(go)
    local nickname = CreateRolePanel.nickname:GetComponent('InputField').text;
    local companyname = CreateRolePanel.companyname:GetComponent('InputField').text;
    if nickname == "" or companyname == "" then
        Event.Brocast("SmallPop"," 用户名或公司名为空",300)
    elseif gender == nil  then
        Event.Brocast("SmallPop"," 请选择性别",300)
    else
        local data = {}
        data.nickname = nickname
        data.companyname = companyname
        data.gender = gender
        data.faceId = go.m_data
        DataManager.DetailModelRpcNoRet(go.insId , 'm_createNewRole',data)
    end
end

--选择性别 男
function CreateRoleCtrl:OnMale()
    gender = true
    CreateRolePanel.male:GetComponent("Image").color =getColorByInt(255,218,72,255)
    CreateRolePanel.female:GetComponent("Image").color =getColorByInt(215,215,215,255)
    CreateRolePanel.maleScl.localScale = Vector3.one
    CreateRolePanel.femaleScl.localScale = Vector3.zero
end

--选择性别 女
function CreateRoleCtrl:OnFemale()
    gender = false
    CreateRolePanel.female:GetComponent("Image").color =getColorByInt(255,218,72,255)
    CreateRolePanel.male:GetComponent("Image").color =getColorByInt(215,215,215,255)
    CreateRolePanel.maleScl.localScale = Vector3.zero
    CreateRolePanel.femaleScl.localScale = Vector3.one
end

--重名
function CreateRoleCtrl:c_SameName()
    CreateRolePanel.duplicate.localScale = Vector3.one
    Event.Brocast("SmallPop"," 该名字也被注册,请重新输入",300)
end