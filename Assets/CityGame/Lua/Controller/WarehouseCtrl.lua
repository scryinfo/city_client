require('Framework/UI/UIPage')
local class = require 'Framework/class'

WarehouseCtrl = class('WarehouseCtrl',UIPage);
local isShowList;
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
    warehouse:AddClick(WarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn);
    warehouse:AddClick(WarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting);

end

function WarehouseCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
end

function WarehouseCtrl:Refresh()

end

function WarehouseCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end

--根据名字排序
function WarehouseCtrl.OnClick_OnName(go)
    WarehousePanel.nowText.text = "By name";
    WarehouseCtrl.OnClick_OpenList(not isShowList);
end
--根据数量排序
function WarehouseCtrl.OnClick_OnNumber(go)
    WarehousePanel.nowText.text = "By quantity";
    WarehouseCtrl.OnClick_OpenList(not isShowList);
end
--根据价格排序
function WarehouseCtrl.OnClick_OnpriceBtn(go)
    WarehousePanel.nowText.text = "By price";
    WarehouseCtrl.OnClick_OpenList(not isShowList);
end

function WarehouseCtrl.OnClick_OnSorting(go)
    WarehouseCtrl.OnClick_OpenList(not isShowList);
end

function WarehouseCtrl.OnClick_OpenList(isShow)
    if isShow then
        WarehousePanel.list:SetActive(true);
        WarehousePanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        WarehousePanel.list:SetActive(false);
        WarehousePanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end