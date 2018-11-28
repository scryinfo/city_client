ShelfCtrl = class('ShelfCtrl',UIPage)
UIPage:ResgisterOpen(ShelfCtrl) --注册打开的方法

local isShowList;
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)

function ShelfCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ShelfCtrl:bundleName()
    return "ShelfPanel"
end

function ShelfCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)

    local shelf = self.gameObject:GetComponent('LuaBehaviour')
    shelf:AddClick(ShelfPanel.return_Btn,self.OnClick_return_Btn, self);
    shelf:AddClick(ShelfPanel.arrowBtn.gameObject,self.OnClick_OnSorting, self);
    shelf:AddClick(ShelfPanel.nameBtn.gameObject,self.OnClick_OnName, self);
    shelf:AddClick(ShelfPanel.quantityBtn.gameObject,self.OnClick_OnNumber, self);
    shelf:AddClick(ShelfPanel.priceBtn.gameObject,self.OnClick_OnpriceBtn, self);
    shelf:AddClick(ShelfPanel.bgBtn,self.OnClick_createGoods, self);

    self.luabehaviour = shelf
    self.m_data = {};
    self.m_data.buildingType = BuildingInType.Shelf
    self.ShelfGoodsMgr = ShelfGoodsMgr:new(self.luabehaviour, self.m_data)

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
function ShelfCtrl:OnClick_OnName(ins)
    ShelfPanel.nowText.text = "By name";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local nameType = ct.sortingItemType.Name
    ShelfCtrl:_getSortItems(nameType,ins.ShelfGoodsMgr.items)
end
--根据数量排序
function ShelfCtrl:OnClick_OnNumber(ins)
    ShelfPanel.nowText.text = "By quantity";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local quantityType = ct.sortingItemType.Quantity
    ShelfCtrl:_getSortItems(quantityType,ins.ShelfGoodsMgr.items)
end
--根据价格排序
function ShelfCtrl:OnClick_OnpriceBtn(ins)
    ShelfPanel.nowText.text = "By price";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local priceType = ct.sortingItemType.Price
    ShelfCtrl:_getSortItems(priceType,ins.ShelfGoodsMgr.items)
end

function ShelfCtrl.OnClick_OnSorting(ins)
    ShelfCtrl.OnClick_OpenList(not isShowList);
end

function ShelfCtrl.OnClick_OpenList(isShow)
    if isShow then
        ShelfPanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ShelfPanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        ShelfPanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ShelfPanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

function ShelfCtrl:OnClick_createGoods()
    ct.OpenCtrl("WarehouseCtrl")
end

--排序
function ShelfCtrl:_getSortItems(type,sortingTable)
    if type == ct.sortingItemType.Name then
        table.sort(sortingTable, function (m, n) return m.name < n.name end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(ShelfPanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(ShelfPanel.Content.transform);
            v.id = i
            ShelfGoodsItem:RefreshData(v.goodsDataInfo,i)
        end
    end
    if type == ct.sortingItemType.Quantity then
        table.sort(sortingTable, function (m, n) return m.num < n.num end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(ShelfPanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(ShelfPanel.Content.transform);
            v.id = i
            ShelfGoodsItem:RefreshData(v.goodsDataInfo,i)
        end
    end
    if type == ct.sortingItemType.Price then
        table.sort(sortingTable, function (m, n) return m.price < n.price end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(ShelfPanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(ShelfPanel.Content.transform);
            v.id = i
            ShelfGoodsItem:RefreshData(v.goodsDataInfo,i)
        end
    end
end

function ShelfCtrl.OnCloseBtn()
    ShelfPanel.OnDestroy();
end