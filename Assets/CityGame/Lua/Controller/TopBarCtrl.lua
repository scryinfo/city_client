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
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    topBat = self.gameObject:GetComponent('LuaBehaviour')
    topBat:AddClick(TopBarPanel.btn_notice, self.OnClick_notice);
    topBat:AddClick(TopBarPanel.btn_back, self.OnClick_back);
    topBat:AddClick(TopBarPanel.btn_main, self.OnClick_main);
end

function TopBarCtrl:Awake(go)
    self.gameObject = go
end

function TopBarCtrl:OnClick_back()
    log("abel_w6_UIFrame", "TopBarCtrl:OnClick_back")
    UIPage.ClosePage();
end

function TopBarCtrl:OnClick_notice()
    log("abel_w6_UIFrame", "TopBarCtrl:OnClick_notice")
    local notice = NoticeCtrl:new()
    notice:ShowPage(notice.OnCreate)
end

function TopBarCtrl:OnClick_main()
    log("abel_w6_UIFrame", "TopBarCtrl:OnClick_main")
    local ctr = MainPageCtrl:new()
    ctr:ShowPage(ctr.OnCreate)
end




