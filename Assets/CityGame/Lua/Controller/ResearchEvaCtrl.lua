---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 15:33
---

ResearchCtrl = class("ResearchCtrl", UIPanel)
ResearchCtrl:ResgisterOpen(ResearchCtrl)

function ResearchCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function ResearchCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ResearchPanel.prefab"
end

function ResearchCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function ResearchCtrl:Awake(go)
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(CompanyPanel.backBtn, self.OnBack, self)
    luaBehaviour:AddClick(CompanyPanel.sureBtn, self.OnSure, self)
end

function ResearchCtrl:Active()
    UIPanel.Active(self)
end

function ResearchCtrl:Refresh()
    self:_updateData()
end

function ResearchCtrl:Hide()
    UIPanel.Hide(self)
end

-- 根据策划的配置表显示要研究的数据
function ResearchCtrl:_updateData()

end

-------------------------------------按钮点击事件-------------------------------------
function ResearchCtrl:OnBack(go)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

function ResearchCtrl:OnSure(go)
    PlayMusEff(1002)
    -- 调用ResearchInstituteModel，向服务器发送研究消息

    UIPanel.ClosePage()
end