require('Framework/UI/UIPage')
local class = require 'Framework/class'

WarehouseCtrl = class('WarehouseCtrl',UIPage);
local isShowList;
local switchIsShow;
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)

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
    warehouse:AddClick(WarehousePanel.transportBtn.gameObject,self.OnClick_transportBtn,self);
    warehouse:AddClick(WarehousePanel.transportCloseBtn.gameObject,self.OnClick_transportBtn,self);
    warehouse:AddClick(WarehousePanel.transportopenBtn.gameObject,self.OnClick_transportopenBtn,self);
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
    WarehouseCtrl:OnClick_rightShelf(not switchIsShow,0)
end

--右边Transpor
function WarehouseCtrl:OnClick_transportBtn(ins)
    WarehouseCtrl:OnClick_rightShelf(not switchIsShow,1)
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
--跳转选择仓库界面
function WarehouseCtrl:OnClick_transportopenBtn(ins)

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

function WarehouseCtrl:OnClick_rightShelf(isShow,number)
    local rightInformation = WarehousePanel.rightInformation:GetComponent("RectTransform")
    if isShow then
        WarehousePanel.rightInformation:SetActive(true);
        if number == 0 then
            WarehousePanel.shelf:SetActive(true);
        else
            WarehousePanel.transport:SetActive(true);
        end
        rightInformation.offsetMin = Vector2.New(0,0);
        rightInformation.offsetMax = Vector2.New(0,0);
        WarehousePanel.Content.offsetMax = Vector2.New(-810,0);
    else
        WarehousePanel.rightInformation:SetActive(false);
        if number == 0 then
            WarehousePanel.shelf:SetActive(false);
        else
            WarehousePanel.transport:SetActive(false);
        end
        rightInformation.offsetMin = Vector2.New(850,0);
        rightInformation.offsetMax = Vector2.New(-850,0);
        WarehousePanel.Content.offsetMax = Vector2.New(0,0);

    end
    switchIsShow = isShow;
end