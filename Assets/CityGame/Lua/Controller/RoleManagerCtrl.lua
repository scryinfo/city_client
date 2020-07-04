
-----
-----

RoleManagerCtrl = class('RoleManagerCtrl',UIPage)

local RoleManagerBehaviour
local gameObject

function  RoleManagerCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RoleManagerPanel.prefab"
end

function RoleManagerCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--Change password verification callback
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--You can go back, after opening the UI, do not hide other UI
end

function RoleManagerCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    RoleManagerBehaviour =  self.gameObject:GetComponent('LuaBehaviour');
    RoleManagerBehaviour:AddClick(RoleManagerPanel.startRoleButton.gameObject,self.OnStartGame,self);
end

--Start the game--
function RoleManagerCtrl.OnStartGame()
    ct.log("rodger_w8_GameMainInterface","[test_OnStartGame]  测试完毕")
    UIPage:ClearAllPages()
    UIPage:ShowPage(GameMainInterfaceCtrl)
end