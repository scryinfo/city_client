---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/1/14 14:59
---中心建筑ctrl

CenterBuildingCtrl = class('CenterBuildingCtrl',UIPage)
UIPage:ResgisterOpen(CenterBuildingCtrl)

local centerBuildingBehaviour;

function  CenterBuildingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CenterBuildingPanel.prefab"
end

function CenterBuildingCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function CenterBuildingCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    centerBuildingBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.bg,self.OnBg,self)
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.cityInfo,self.OnCityInfo,self)
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.centerWarehouse,self.OnCenterWarehouse,self)
    centerBuildingBehaviour:AddClick(CenterBuildingPanel.technology,self.OnTechnology,self)
end

function CenterBuildingCtrl:OnBg()
    UIPage.ClosePage();
end

--点击城市信息
function CenterBuildingCtrl:OnCityInfo()

end

--点击中心仓库
function CenterBuildingCtrl:OnCenterWarehouse()
    ct.OpenCtrl("CenterWareHouseCtrl",PlayerTempModel.roleData)
end

--点击人才建筑
function CenterBuildingCtrl:OnTechnology()

end