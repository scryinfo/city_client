---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/1/14 14:59
---中心建筑ctrl

CenterBuildingCtrl = class('CenterBuildingCtrl',UIPanel)
UIPanel:ResgisterOpen(CenterBuildingCtrl)

local centerBuildingBehaviour;

function  CenterBuildingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CenterBuildingPanel.prefab"
end

function CenterBuildingCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function CenterBuildingCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function CenterBuildingCtrl:Awake()
    centerBuildingBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.bg,self.OnBg,self)
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.cityInfo,self.OnCityInfo,self)
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.centerWarehouse,self.OnCenterWarehouse,self)
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.technology,self.OnTechnology,self)
end

function CenterBuildingCtrl:Active()
    UIPanel.Active(self)

    local cityinfoPath,centerWarehousePath,technologyPath
    LoadSprite(GetSprite("CBCityInfo"), CenterBuildingPanel.cityInfo:GetComponent("Image"), false)
    LoadSprite(GetSprite("CBWareHouse"), CenterBuildingPanel.centerWarehouse:GetComponent("Image"), false)
    LoadSprite(GetSprite("CBSoon"), CenterBuildingPanel.technology:GetComponent("Image"), false)
end

function CenterBuildingCtrl:Hide()
    UIPanel.Hide(self)
end

function CenterBuildingCtrl:OnBg()
    PlayMusEff(1002)
    UIPanel.ClosePage();
end

--点击城市信息
function CenterBuildingCtrl:OnCityInfo()
    PlayMusEff(1002)
    --ct.OpenCtrl("CityInfoCtrl")
end

--点击中心仓库
function CenterBuildingCtrl:OnCenterWarehouse()
    PlayMusEff(1002)
    ct.OpenCtrl("CenterWareHouseCtrl")
end

--点击待定
function CenterBuildingCtrl:OnTechnology()
    PlayMusEff(1002)
end