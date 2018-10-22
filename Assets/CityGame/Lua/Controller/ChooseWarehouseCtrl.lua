require ('Framework/UI/UIPage')
local class = require 'Framework/class'

ChooseWarehouseCtrl = class('ChooseWarehouseCtrl',UIPage);
local isShowList;
function ChooseWarehouseCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ChooseWarehouseCtrl:bundleName()
    return "ChooseWarehouse";
end

function ChooseWarehouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local chooseWarehouse = self.gameObject:GetComponent('LuaBehaviour');
    chooseWarehouse:AddClick(ChooseWarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.nameBtn.gameObject,self.OnClick_nameBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.quantityBtn.gameObject,self.OnClick_quantityBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.priceBtn.gameObject,self.OnClick_priceBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.timeBtn.gameObject,self.OnClick_timeBtn,self);
end
function ChooseWarehouseCtrl:Awake(go)
    self.gameObject = go;
    isShowList = false;
end
--返回
function ChooseWarehouseCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--搜索
function ChooseWarehouseCtrl:OnClick_searchBtn()

end
--根据名字排序
function ChooseWarehouseCtrl:OnClick_nameBtn()
    ChooseWarehousePanel.nowText.text = "By name";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据数量排序
function ChooseWarehouseCtrl:OnClick_quantityBtn()
    ChooseWarehousePanel.nowText.text = "By quantity";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据价格排序
function ChooseWarehouseCtrl:OnClick_priceBtn()
    ChooseWarehousePanel.nowText.text = "By price";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据时间排序
function ChooseWarehouseCtrl:OnClick_timeBtn()
    ChooseWarehousePanel.nowText.text = "By time";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end

function ChooseWarehouseCtrl:OnClick_OnSorting()
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end

function ChooseWarehouseCtrl:OnClick_OpenList(isShow)
    if isShow then
        ChooseWarehousePanel.list:SetActive(true);
        ChooseWarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        ChooseWarehousePanel.list:SetActive(false);
        ChooseWarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

function ChooseWarehouseCtrl:Refresh()

end