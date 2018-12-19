ShelfCtrl = class('ShelfCtrl',UIPage)
UIPage:ResgisterOpen(ShelfCtrl) --注册打开的方法

local isShowList;
local switchIsShow;
local shelf;
local listTrue = Vector3.New(0,0,180);
local listFalse = Vector3.New(0,0,0);
--存放选中的物品，临时表
ShelfCtrl.temporaryItems = {}
function ShelfCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ShelfCtrl:bundleName()
    return "ShelfPanel"
end

function ShelfCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)

    shelf:AddClick(ShelfPanel.return_Btn,self.OnClick_return_Btn, self);
    shelf:AddClick(ShelfPanel.arrowBtn.gameObject,self.OnClick_OnSorting, self);
    shelf:AddClick(ShelfPanel.nameBtn.gameObject,self.OnClick_OnName, self);
    shelf:AddClick(ShelfPanel.quantityBtn.gameObject,self.OnClick_OnNumber, self);
    shelf:AddClick(ShelfPanel.priceBtn.gameObject,self.OnClick_OnpriceBtn, self);
    shelf:AddClick(ShelfPanel.addBtn,self.OnClick_createGoods, self);
    shelf:AddClick(ShelfPanel.buy_Btn,self.OnClick_playerBuy,self);
    shelf:AddClick(ShelfPanel.closeBtn,self.OnClick_playerBuy,self);
    shelf:AddClick(ShelfPanel.confirmBtn,self.OnClcik_buyConfirmBtn,self);

    --Event.AddListener("refreshShelfInfo",self.refreshShelfInfo,self)
    Event.AddListener("_selectedBuyGoods",self._selectedBuyGoods,self);
    Event.AddListener("c_tempTabNotGoods",self.c_tempTabNotGoods,self);
end

function ShelfCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
end

function ShelfCtrl:Refresh()
    shelf = self.gameObject:GetComponent('LuaBehaviour')
    if self.m_data == nil then
        return
    end
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        self.luabehaviour = shelf
        self.m_data.type = BuildingInType.Shelf
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.m_data)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        self.luabehaviour = shelf
        self.m_data.type = BuildingInType.Shelf
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.m_data)
    end
    if self.m_data.isOther then
        ShelfPanel.buy_Btn.transform.localScale = Vector3.New(1,1,1);
        ShelfPanel.shelfAddItem.gameObject:SetActive(false)
        self:shelfImgSetActive(self.GoodsUnifyMgr.items,5)
    else
        ShelfPanel.buy_Btn.transform.localScale = Vector3.New(0,0,0);
    end
end
----刷新数据
--function ShelfCtrl:refreshShelfInfo(data)
--    if not data then
--        return;
--    end
--    --self.WarehouseModelData = {}
--    --local configTable = {}
--    --local uiTab = {}
--    --uiTab.name = Material[v.key.id].name
--    --uiTab.num = v.n
--    --uiTab.itemId = v.key.id
--    --configTable[i] = uiTab
--
--    local prefabData = {}
--    prefabData._prefab = self:_creatGoods(GoodsUnifyMgr.static.Staff_PATH,ShelfPanel.Content)
--
--    local warehouseLuaItem = ShelfGoodsItem:refreshInfo(data,prefabData._prefab)
--end
--选中物品
function ShelfCtrl:_selectedBuyGoods(id,itemId)
    if self.temporaryItems[id] == nil then
        self.temporaryItems[id] = id
        self.GoodsUnifyMgr:_buyShelfGoods(id,self.luabehaviour,itemId)
        self.GoodsUnifyMgr.items[id].circleTickImg.transform.localScale = Vector3.one
    else
        self.temporaryItems[id] = nil;
        self.GoodsUnifyMgr.items[id].circleTickImg.transform.localScale = Vector3.zero
        self.GoodsUnifyMgr:_deleteBuyGoods(id);
    end
end
--临时表里是否有这个物品
function ShelfCtrl:c_tempTabNotGoods(id)
    self.temporaryItems[id] = nil
    self.GoodsUnifyMgr.items[id].circleTickImg.transform.localScale = Vector3.zero
    self.GoodsUnifyMgr:_deleteBuyGoods(id);
end
--购买物品
function ShelfCtrl:OnClcik_buyConfirmBtn(ins)
    if not ins.GoodsUnifyMgr.shelfBuyGoodslItems or #ins.GoodsUnifyMgr.shelfBuyGoodslItems < 1 then
        return;
    else
        local buyListing = {}
        buyListing.currentLocationName = PlayerBuildingBaseData[ins.m_data.info.mId].sizeName..PlayerBuildingBaseData[ins.m_data.info.mId].typeName;
        buyListing.targetLocationName = "中心仓库";
        buyListing.distance = "0km";
        buyListing.time = "00:00:00";
        local price = 0;
        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
            price = price + tonumber(v.moneyText.text);
        end
        buyListing.goodsPrice = price;
        buyListing.freight = "0";
        buyListing.total = price;
        ct.OpenCtrl("TransportBoxCtrl",buyListing);
    end
end

function ShelfCtrl:OnClick_return_Btn(go)
    go:deleteObjInfo();
    UIPage.ClosePage();
end
--根据名字排序
function ShelfCtrl:OnClick_OnName(ins)
    ShelfPanel.nowText.text = "By name";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local nameType = ct.sortingItemType.Name
    ShelfCtrl:_getSortItems(nameType,ins.GoodsUnifyMgr.items)
end
--根据数量排序
function ShelfCtrl:OnClick_OnNumber(ins)
    ShelfPanel.nowText.text = "By quantity";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local quantityType = ct.sortingItemType.Quantity
    ShelfCtrl:_getSortItems(quantityType,ins.GoodsUnifyMgr.items)
end
--根据价格排序
function ShelfCtrl:OnClick_OnpriceBtn(ins)
    ShelfPanel.nowText.text = "By price";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local priceType = ct.sortingItemType.Price
    ShelfCtrl:_getSortItems(priceType,ins.GoodsUnifyMgr.items)
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

function ShelfCtrl:OnClick_playerBuy(go)
    go:openPlayerBuy(not switchIsShow)
end

function ShelfCtrl:openPlayerBuy(isShow)
    if isShow then
        ShelfPanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        Event.Brocast("c_buyGoodsItemChoose")
        ShelfPanel.Content.offsetMax = Vector2.New(-740,0);
        --当右边购买界面打开时，重新刷新架子上的东西，求余 id%5 == 1 的时候打开架子
        self:shelfImgSetActive(self.GoodsUnifyMgr.items,3)
    else
        ShelfPanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        Event.Brocast("c_buyGoodsItemDelete")
        ShelfPanel.Content.offsetMax = Vector2.New(0,0);
        self:shelfImgSetActive(self.GoodsUnifyMgr.items,5)
    end
    switchIsShow = isShow
end

function ShelfCtrl:OnClick_createGoods(go)
    if go.m_data == nil then
        return
    end
    if go.m_data.buildingType == BuildingType.MaterialFactory then
        ct.OpenCtrl("WarehouseCtrl",go.m_data)
    elseif go.m_data.buildingType == BuildingType.ProcessingFactory then
        ct.OpenCtrl("WarehouseCtrl",go.m_data)
    end
end
--架子隐藏和显示
function ShelfCtrl:shelfImgSetActive(table,num)
    if not table then
        return
    end
    for i,v in pairs(table) do
        if i % 5 == 1 then
            v.shelfImg:SetActive(true);
        else
            v.shelfImg:SetActive(false);
        end
    end
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
----生成预制
--function ShelfCtrl:_creatGoods(path,parent)
--    local prefab = UnityEngine.Resources.Load(path);
--    local go = UnityEngine.GameObject.Instantiate(prefab);
--    local rect = go.transform:GetComponent("RectTransform");
--    go.transform:SetParent(parent.transform);
--    rect.transform.localScale = Vector3.one;
--    return go
--end
--关闭面板时清空UI信息，以备其他模块调用
function ShelfCtrl:deleteObjInfo()
    if not self.GoodsUnifyMgr.items then
        return;
    else
        for i,v in pairs(self.GoodsUnifyMgr.items) do
            v:closeEvent();
            destroy(v.prefab.gameObject);
        end
        self.GoodsUnifyMgr.items = {};
        self.ModelDataList = {};
    end
end
function ShelfCtrl.OnCloseBtn()
    ShelfPanel.OnDestroy();
end