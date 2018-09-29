---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/28 17:47
---
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/27 21:15
---
require('Framework/UI/UIPage')
local class = require 'Framework/class'

MainPageCtrl = class('MainPageCtrl',UIPage)

function MainPageCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end

function MainPageCtrl:getResPath()
    return "MainPage"
end

function MainPageCtrl:OnCreate(obj )
    UIPage.OnCreate(self,obj)
    local ctrl = self.gameObject:GetComponent('LuaBehaviour')
    ctrl:AddClick(MainPagePanel.btn_skill, self.OnClick_skill);
    ctrl:AddClick(MainPagePanel.btn_battle, self.OnClick_battle);
end

function MainPageCtrl:Awake(go)
    self.gameObject = go
end

function MainPageCtrl:OnClick_skill()
    log("abel_w6_UIFrame", "MainPageCtrl:OnClick_confim")
    UIPage:ShowPage(SkillPageCtrl)
end
function MainPageCtrl:OnClick_battle(obj)
    log("abel_w6_UIFrame", "BattleCtrl:OnClickGoBattle")
end

