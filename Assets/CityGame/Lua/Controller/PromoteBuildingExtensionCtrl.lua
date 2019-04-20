---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/11 16:36
---推广公司建筑扩展
PromoteBuildingExtensionCtrl = class('PromoteBuildingExtensionCtrl',UIPanel)
UIPanel:ResgisterOpen(PromoteBuildingExtensionCtrl)

local buildingExtensionBehaviour
local myOwnerID = nil

function PromoteBuildingExtensionCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PromoteBuildingExtensionPanel.prefab"
end

function PromoteBuildingExtensionCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function PromoteBuildingExtensionCtrl:Awake()
    buildingExtensionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    buildingExtensionBehaviour:AddClick(PromoteBuildingExtensionPanel.xBtn,self.OnXBtn,self);
    buildingExtensionBehaviour:AddClick(PromoteBuildingExtensionPanel.curve,self.OnCurve,self);
    self:initData()

    myOwnerID = DataManager.GetMyOwnerID()      --自己的唯一ids
end

function PromoteBuildingExtensionCtrl:Active()
    UIPanel.Active(self)
end

function PromoteBuildingExtensionCtrl:Refresh()
    --判断是自己还是别人打开了界面
    if self.m_data.info.ownerId == myOwnerID then
        PromoteBuildingExtensionPanel.myTime.localScale = Vector3.one
        PromoteBuildingExtensionPanel.queue.transform.localScale = Vector3.one
        PromoteBuildingExtensionPanel.otherTimeBg.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.moneyBg.localScale = Vector3.zero
    else
        PromoteBuildingExtensionPanel.myTime.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.queue.transform.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.otherTimeBg.localScale = Vector3.one
        PromoteBuildingExtensionPanel.moneyBg.localScale = Vector3.one
    end
    if self.m_data.type == 1 then
        PromoteBuildingExtensionPanel.house.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.supermarket.localScale = Vector3.one
    elseif self.m_data.type == 2 then
        PromoteBuildingExtensionPanel.house.localScale = Vector3.one
        PromoteBuildingExtensionPanel.supermarket.localScale = Vector3.zero
    end
end

function PromoteBuildingExtensionCtrl:Hide()
    UIPanel.Hide(self)

end

function PromoteBuildingExtensionCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function PromoteBuildingExtensionCtrl:initData()

end

--返回
function PromoteBuildingExtensionCtrl:OnXBtn()
    UIPanel.ClosePage()
end

--打开曲线图
function PromoteBuildingExtensionCtrl:OnCurve()
    ct.OpenCtrl("PromoteCurveCtrl")
end
