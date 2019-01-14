-----
-----

CreateRoleCtrl = class('CreateRoleCtrl',UIPage)
UIPage:ResgisterOpen(CreateRoleCtrl)

local createRoleBehaviour;
local gameObject;
local gender;

function  CreateRoleCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CreateRolePanel.prefab"
end

function CreateRoleCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function CreateRoleCtrl:Refresh()
    self:_initInsData()
end

function CreateRoleCtrl:Awake()
    self.insId = OpenModelInsID.CreateRoleCtrl
end

function CreateRoleCtrl:_initInsData()
    DataManager.OpenDetailModel(CreateRoleModel,self.insId )

end
function CreateRoleCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    createRoleBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    createRoleBehaviour:AddClick(CreateRolePanel.createRoleBtn,self.OnCreateRole,self)
    createRoleBehaviour:AddClick(CreateRolePanel.male,self.OnMale,self)
    createRoleBehaviour:AddClick(CreateRolePanel.female,self.OnFemale,self)
end

--创建角色
function CreateRoleCtrl:OnCreateRole(go)
    local nickname = CreateRolePanel.nickname:GetComponent('InputField').text;
    local companyname = CreateRolePanel.companyname:GetComponent('InputField').text;
    if nickname == "" or companyname == "" then
        Event.Brocast("SmallPop"," 用户名或公司名为空",300)
    elseif gender ==nickname  then
        Event.Brocast("SmallPop"," 请选择性别",300)
    else
        local data = {}
        data.nickname = nickname
        data.companyname = companyname
        data.gender = gender
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