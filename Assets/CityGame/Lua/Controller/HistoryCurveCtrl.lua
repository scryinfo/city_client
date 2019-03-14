---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/12 15:23
---历史曲线图ctrl
HistoryCurveCtrl = class('HistoryCurveCtrl',UIPanel)
UIPanel:ResgisterOpen(HistoryCurveCtrl)
--HistoryCurveCtrl.static.Head_PATH = "View/GoodsItem/RoleHeadItem"

local curveBehaviour;

function  HistoryCurveCtrl:bundleName()
    return "Assets/CityGame/Resources/View/HistoryCurvePanel.prefab"
end

function HistoryCurveCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function HistoryCurveCtrl:Awake()
    curveBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    curveBehaviour:AddClick(HistoryCurvePanel.xBtn,self.OnBack,self)
    --HistoryCurvePanel.curve.anchoredPosition3D = Vector3.New(-18524, 56,0)
    --HistoryCurvePanel.curve.sizeDelta = Vector2.New(19530, 450)
    self:initData()
end

function HistoryCurveCtrl:Active()
    UIPanel.Active(self)
end

function HistoryCurveCtrl:Refresh()
end

function HistoryCurveCtrl:Hide()
    UIPanel.Hide(self)
end

function HistoryCurveCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function HistoryCurveCtrl:initData()
    --local a = { "1","2","3","4","5","6","7","8","9","10"}
    ----local a = { [1] = "1",[2] = "2"}
    --local b = {{ Vector2.New(300, 100), Vector2.New(200, 0), Vector2.New(100, 300),  Vector2.New(0, 200) },
    --           { Vector2.New(300, 200), Vector2.New(200, 100), Vector2.New(100, 250), Vector2.New(0, 300)}
    --}
    --local c = {{ Color.New(53 / 255, 218 / 255, 233 / 255, 255 / 255)},
    --           { Color.New(233 / 255, 34 / 255, 104 / 255, 255 / 255) }
    --}
    --local d = {Vector2.New(300, 100), Vector2.New(200, 0), Vector2.New(100, 300),  Vector2.New(0, 200)}
    --local f = {Vector2.New(300, 200), Vector2.New(200, 100), Vector2.New(100, 250),  Vector2.New(0, 300)}
    --local g = {Vector2.New(300, 300), Vector2.New(200, 200), Vector2.New(100, 100),  Vector2.New(0, 400)}
    --HistoryCurvePanel.slide:SetXScaleValue(a,116)
    --HistoryCurvePanel.slide:SetCoordinate(d,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255))
    --HistoryCurvePanel.slide:SetCoordinate(f,Color.New(204 / 255, 108 / 255, 210 / 255, 255 / 255))
    --HistoryCurvePanel.slide:SetCoordinate(g,Color.New(240 / 255, 158 / 255, 111 / 255, 255 / 255))
    --HistoryCurvePanel.graph:DrawLine(d,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255))
    --HistoryCurvePanel.graph:DrawLine(f,Color.New(204 / 255, 108 / 255, 210 / 255, 255 / 255))
    --HistoryCurvePanel.graph:DrawLine(g,Color.New(240 / 255, 158 / 255, 111 / 255, 255 / 255))
    --HistoryCurvePanel.graph:BoundaryLine({300})
    HistoryCurvePanel.graph:DrawLine(self.m_data.supplyNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255))
    HistoryCurvePanel.slide:SetCoordinate(self.m_data.supplyNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255))
    HistoryCurvePanel.slide:SetXScaleValue(self.m_data.time,116)
    HistoryCurvePanel.graph:BoundaryLine(self.m_data.boundaryLine)



end

function HistoryCurveCtrl:OnBack()
    UIPanel.ClosePage()
end
