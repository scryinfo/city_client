--require "Common/define"
require ('Framework/UI/UIPage')
require "View/BuildingInfo/ShelfGoodsMgr"

ShelfCtrl = class('ShelfCtrl',UIPage)

local isShowList;
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)
--预制体
ShelfCtrl.static.SHELFICON_PATH = 'View/GoodsItem/ShelfGoodsItem'
function ShelfCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ShelfCtrl:bundleName()
    return "Shelf"
end

function ShelfCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)

    local shelf = self.gameObject:GetComponent('LuaBehaviour')
    shelf:AddClick(ShelfPanel.return_Btn,self.OnClick_return_Btn, self);
    shelf:AddClick(ShelfPanel.arrowBtn.gameObject,self.OnClick_OnSorting, self);
    shelf:AddClick(ShelfPanel.nameBtn,self.OnClick_OnName, self);
    shelf:AddClick(ShelfPanel.quantityBtn,self.OnClick_OnNumber, self);
    shelf:AddClick(ShelfPanel.priceBtn,self.OnClick_OnpriceBtn, self);
    shelf:AddClick(ShelfPanel.bgBtn,self.OnClick_createGoods, self);
    self.luabehaviour = shelf

    self.m_data = {};
    self.m_data.buildingType = BuildingInType.Shelf
end

function ShelfCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
end

function ShelfCtrl:Refesh()

end

function ShelfCtrl:OnClick_return_Btn()
    UIPage.ClosePage();
end
--根据名字排序
function ShelfCtrl.OnClick_OnName(go)
    ShelfPanel.nowText.text = "By name";
    ShelfCtrl.OnClick_OpenList(not isShowList);
end
--根据数量排序
function ShelfCtrl.OnClick_OnNumber(go)
    ShelfPanel.nowText.text = "By quantity";
    ShelfCtrl.OnClick_OpenList(not isShowList);
end
--根据价格排序
function ShelfCtrl.OnClick_OnpriceBtn(go)
    ShelfPanel.nowText.text = "By price";
    ShelfCtrl.OnClick_OpenList(not isShowList);
end

function ShelfCtrl.OnClick_OnSorting(go)
    ShelfCtrl.OnClick_OpenList(not isShowList);
end

function ShelfCtrl.OnClick_OpenList(isShow)
    if isShow then
        --ShelfPanel.list:SetActive(true);
        ShelfPanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ShelfPanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        --ShelfPanel.list:SetActive(false);
        ShelfPanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ShelfPanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

function ShelfCtrl:OnClick_createGoods(ins)
    ShelfGoodsMgr:new(ins.luabehaviour,ins.m_data)
end

function ShelfCtrl.OnCloseBtn()
    ShelfPanel.OnDestroy();
end