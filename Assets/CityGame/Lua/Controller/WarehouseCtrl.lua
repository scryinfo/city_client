require('Framework/UI/UIPage')
local class = require 'Framework/class'

WarehouseCtrl = class('WarehouseCtrl',UIPage);
local isShowList;
local switchIsShow;
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)
local leftTopFalse = Vector2.New(850.0);
local rightBottomFalse = Vector2.New(-850,0);

function WarehouseCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function WarehouseCtrl:bundleName()
    return "Warehouse";
end

function WarehouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local warehouse = self.gameObject:GetComponent('LuaBehaviour');
    warehouse:AddClick(WarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    warehouse:AddClick(WarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    warehouse:AddClick(WarehousePanel.nameBtn.gameObject,self.OnClick_OnName,self);
    warehouse:AddClick(WarehousePanel.quantityBtn.gameObject,self.OnClick_OnNumber,self);
    warehouse:AddClick(WarehousePanel.shelfBtn.gameObject,self.OnClick_shelfBtn,self);
    warehouse:AddClick(WarehousePanel.shelfCloseBtn.gameObject,self.OnClick_shelfBtn,self)
end

function WarehouseCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
end

function WarehouseCtrl:Refresh()

end

function WarehouseCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--右边Shelf
function WarehouseCtrl:OnClick_shelfBtn(ins)
    WarehouseCtrl:OnClick_rightShelf(not switchIsShow)
end
--根据名字排序
function WarehouseCtrl:OnClick_OnName(ins)
    WarehousePanel.nowText.text = "By name";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据数量排序
function WarehouseCtrl:OnClick_OnNumber(ins)
    WarehousePanel.nowText.text = "By quantity";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end

function WarehouseCtrl:OnClick_OnSorting(ins)
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end

function WarehouseCtrl:OnClick_OpenList(isShow)
    if isShow then
        WarehousePanel.list:SetActive(true);
        WarehousePanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        WarehousePanel.list:SetActive(false);
        WarehousePanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

function WarehouseCtrl:OnClick_rightShelf(isShow)
    local rightInformation = WarehousePanel.rightInformation:GetComponent("RectTransform")
    if isShow then
        WarehousePanel.rightInformation:SetActive(true);


        WarehousePanel.shelf:SetActive(true);
        rightInformation.offsetMin = Vector2.New(0,0);
        rightInformation.offsetMax = Vector2.New(0,0);
        WarehousePanel.Content.offsetMax = Vector2.New(-810,0);
    else
        WarehousePanel.rightInformation:SetActive(false);


        WarehousePanel.shelf:SetActive(false);
        rightInformation.offsetMin = Vector2.New(850,0);
        rightInformation.offsetMax = Vector2.New(-850,0);
        WarehousePanel.Content.offsetMax = Vector2.New(0,0);

    end
    switchIsShow = isShow;
end