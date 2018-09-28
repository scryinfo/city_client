---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/27 21:15
---
require('Framework/UI/UIPage')
local class = require 'Framework/class'

TopBarCtrl = class('TopBarCtrl',UIPage)

function TopBarCtrl:initialize()
    UIPage.initialize(self,UIType.Fixed,UIMode.DoNothing,UICollider.None)
    self.uiPath = "TopBar"
end

--function TopBarCtrl.OnCreate(obj ,self)
--    UIPage.OnCreate(self,obj)
--    gameObject = obj;
--    topBat = gameObject:GetComponent('LuaBehaviour');
--end
function TopBarCtrl:OnCreate(obj )
    UIPage:OnCreate(obj)
    gameObject = obj;
    topBat = gameObject:GetComponent('LuaBehaviour');
end

function TopBarCtrl:Awake(go)
    self.gameObject = go
    topBat = gameObject:GetComponent('LuaBehaviour')
    topBat:AddClick(TopBarCtrl.btn_notice, self.OnClick_notice);
    topBat:AddClick(TopBarCtrl.btn_back, self.OnClick_back);
end

function TopBarCtrl:OnClick_back()
    log("abel_w6_UIFrame", "UITopBar:OnClick_back")
end

function TopBarCtrl:OnClick_notice()
    log("abel_w6_UIFrame", "UITopBar:OnClick_notice")
end

UnitTest.Exec("abel_w6_UIFrame", "test_UIPage_ShowPage",  function ()
    --log("abel_w6_UIFrame","[test_UIPage_ShowPage]  ")
    local topbar = TopBarCtrl:new()
    topbar.type = UIType.None
    topbar:ShowPage(topbar.OnCreate)
end)


