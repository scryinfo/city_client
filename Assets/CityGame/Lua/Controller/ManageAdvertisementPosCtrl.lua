---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/26/026 17:44
---



require "Common/define"
require('Framework/UI/UIPage')

local isShowList;
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)

local class = require 'Framework/class'
ManageAdvertisementPosCtrl = class('ManageAdvertisementPosCtrl',UIPage)

UIPage:ResgisterOpen(ManageAdvertisementPosCtrl) --注册打开的方法

--构建函数
function ManageAdvertisementPosCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ManageAdvertisementPosCtrl:bundleName()
    return "ManageAdvertisementPos";
end

function ManageAdvertisementPosCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    isShowList = false;
end

function ManageAdvertisementPosCtrl:Awake(go)
    self.gameObject = go;
    local materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    --排序
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.nameBtn.gameObject,self.OnClick_OnName,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.quantityBtn.gameObject,self.OnClick_OnNumber,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.goodsBtn.gameObject,self.OnClick_OnGoods,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.buildingBtn.gameObject,self.OnClick_OnBuild,self);
    self:OnClick_OnGoods();
    -----创建广告管理
    local creatData={count=10,buildingType=BuildingType.MunicipalManage}
    self.ItemCreatDeleteMgr =ItemCreatDeleteMgr:new(materialBehaviour,creatData)
end


--返回
function ManageAdvertisementPosCtrl:OnClick_backBtn(ins)
    UIPage.ClosePage();
    for i, v in pairs(ins.ItemCreatDeleteMgr.addedItemList) do
         destroy(v)
    end
    for i, v in pairs(ins.ItemCreatDeleteMgr.selectItemList) do
        v:SetActive(true);
    end
   end

--打开信息界面
function ManageAdvertisementPosCtrl:OnClick_infoBtn()

end
--刷新数据
function ManageAdvertisementPosCtrl:Refresh()
   -- ins.ItemCreatDeleteMgr.index
end



--根据名字排序
function ManageAdvertisementPosCtrl:OnClick_OnName()
    ManageAdvertisementPosPanel.nowText.text = "By name";
    ManageAdvertisementPosCtrl:OnClick_OpenList(not isShowList);
end
--根据数量排序
function ManageAdvertisementPosCtrl:OnClick_OnNumber()
    ManageAdvertisementPosPanel.nowText.text = "By quantity";
    ManageAdvertisementPosCtrl:OnClick_OpenList(not isShowList);
end

--展开排序列表
function ManageAdvertisementPosCtrl:OnClick_OnSorting(ins)
    ManageAdvertisementPosCtrl:OnClick_OpenList(not isShowList);
end
--排序列表动画
function ManageAdvertisementPosCtrl:OnClick_OpenList(isShow)
    if isShow then
        --WarehousePanel.list:SetActive(true);
        ManageAdvertisementPosPanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ManageAdvertisementPosPanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        --WarehousePanel.list:SetActive(false);
        ManageAdvertisementPosPanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ManageAdvertisementPosPanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end


--设置显隐
function ManageAdvertisementPosCtrl:OnClick_OnGoods()
    ManageAdvertisementPosPanel.goodsScroll.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.buildingScroll.gameObject:SetActive(false);
end

function ManageAdvertisementPosCtrl:OnClick_OnBuild()
    ManageAdvertisementPosPanel.buildingScroll.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.goodsScroll.gameObject:SetActive(false);
end


























