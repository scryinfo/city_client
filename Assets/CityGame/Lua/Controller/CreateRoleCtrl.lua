-----
-----

CreateRoleCtrl = class('CreateRoleCtrl',UIPage)
UIPage:ResgisterOpen(CreateRoleCtrl)

local createRoleBehaviour;
local gameObject;

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
end

--创建角色
function CreateRoleCtrl:OnCreateRole(go)
   --Event.Brocast("m_createNewRole")
    DataManager.DetailModelRpcNoRet(go.insId , 'm_createNewRole')
end