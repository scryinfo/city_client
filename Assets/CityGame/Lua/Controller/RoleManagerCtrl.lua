
require('Framework/UI/UIPage')
require "Common/define"
require('Controller/GameMainInterfaceCtrl')

local class = require 'Framework/class'
RoleManagerCtrl = class('RoleManagerCtrl',UIPage)

local RoleManagerBehaviour
local gameObject

function  RoleManagerCtrl:bundleName()
    return "RoleManager"
end

function RoleManagerCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function RoleManagerCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    RoleManagerBehaviour =  self.gameObject:GetComponent('LuaBehaviour');
    RoleManagerBehaviour:AddClick(RoleManagerPanel.startRoleButton.gameObject,self.OnStartGame,self);
end

--开始游戏--
function RoleManagerCtrl.OnStartGame()
    log("rodger_w8_GameMainInterface","[test_OnStartGame]  测试完毕")
    UIPage:ClearAllPages()
    UIPage:ShowPage(GameMainInterfaceCtrl)
end