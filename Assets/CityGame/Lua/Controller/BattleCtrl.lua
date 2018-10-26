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
-----


BattleCtrl = class('BattleCtrl',UIPage)

function BattleCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end

function BattleCtrl:bundleName()
    return "Battle"
end

function BattleCtrl:OnCreate(obj )
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    local Notice = gameObject:GetComponent('LuaBehaviour');
end

function BattleCtrl:Awake(go)
    self.gameObject = go
    local lbr = self.gameObject:GetComponent('LuaBehaviour')
    lbr:AddClick(BattlePanel.btn_skill, self.OnClickSkillGo);
    lbr:AddClick(BattlePanel.btn_battle, self.OnClickGoBattle);
end

function BattleCtrl:Close()
    destroy(self.gameObject);
end

function BattleCtrl:OnClickSkillGo()
    log("abel_w6_UIFrame", "BattleCtrl:OnClickSkillGo")
    UIPage:ShowPage(SkillPageCtrl)

end
function BattleCtrl:OnClickGoBattle()
    log("abel_w6_UIFrame", "BattleCtrl:OnClickGoBattle")
end


