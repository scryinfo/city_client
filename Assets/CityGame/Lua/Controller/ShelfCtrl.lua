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
    return "Assets/CityGame/Resources/View/ShelfPanel.prefab"
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
    shelf:AddClick(ShelfPanel.confirmBtn.gameObject,self.OnClcik_buyConfirmBtn,self);
    shelf:AddClick(ShelfPanel.openBtn,self.OnClick_openBtn,self);

    Event.AddListener("_selectedBuyGoods",self._selectedBuyGoods,self);
    Event.AddListener("c_tempTabNotGoods",self.c_tempTabNotGoods,self);
    Event.AddListener("receiveBuyRefreshInfo",self.receiveBuyRefreshInfo,self);
end

function ShelfCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
end

function ShelfCtrl:Refresh()
    shelf = self.gameObject:GetComponent('LuaBehaviour')
    if self.m_data[1] ~= nil then
        self.m_data = self.m_data[1]
    end
    self.data = self.m_data
    self.luabehaviour = shelf
    self.shelf = self.m_data.shelf
    self.shelf.type = BuildingInType.Shelf
    self.shelf.isOther = self.m_data.isOther
    self.shelf.buildingId = self.m_data.info.id
    self:isShowDetermineBtn()
    if ShelfPanel.Content.childCount <= 1 then
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.shelf)
    end
    if self.m_data.isOther then
        ShelfPanel.buy_Btn.transform.localScale = Vector3.New(1,1,1);
        ShelfPanel.shelfAddItem.gameObject:SetActive(false)
        self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,5)
    else
        ShelfPanel.buy_Btn.transform.localScale = Vector3.New(0,0,0);
    end

end
--选中物品
function ShelfCtrl:_selectedBuyGoods(ins)
    if self.temporaryItems[ins.id] == nil then
        self.temporaryItems[ins.id] = ins.id
        self.GoodsUnifyMgr:_buyShelfGoods(ins,self.luabehaviour)
        self.GoodsUnifyMgr.shelfLuaTab[ins.id].circleTickImg.transform.localScale = Vector3.one
    else
        self.temporaryItems[ins.id] = nil;
        self.GoodsUnifyMgr.shelfLuaTab[ins.id].circleTickImg.transform.localScale = Vector3.zero
        self.GoodsUnifyMgr:_deleteBuyGoods(ins.id);
    end
    self:isShowDetermineBtn()
end
--临时表里是否有这个物品
function ShelfCtrl:c_tempTabNotGoods(id)
    self.temporaryItems[id] = nil
    self.GoodsUnifyMgr.shelfLuaTab[id].circleTickImg.transform.localScale = Vector3.zero
    self.GoodsUnifyMgr:_deleteBuyGoods(id);
    self:isShowDetermineBtn()
end
--跳转选择仓库界面
function ShelfCtrl:OnClick_openBtn(go)
    local data = {}
    data.pos = {}
    data.pos.x = go.m_data.info.pos.x
    data.pos.y = go.m_data.info.pos.y
    data.nameText = ShelfPanel.nameText
    data.buildingId = go.m_data.info.id
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--购买物品
function ShelfCtrl:OnClcik_buyConfirmBtn(ins)
    if not ins.GoodsUnifyMgr.shelfBuyGoodslItems or #ins.GoodsUnifyMgr.shelfBuyGoodslItems < 1 then
        return;
    else
        local buyListing = {}
        buyListing.currentLocationName = PlayerBuildingBaseData[ins.m_data.info.mId].sizeName..PlayerBuildingBaseData[ins.m_data.info.mId].typeName;
        --buyListing.targetLocationName = "中心仓库";
        --buyListing.distance = math.sqrt(math.pow((45 - ins.m_data.info.pos.x),2) + math.pow((45 - ins.m_data.info.pos.y),2));
        buyListing.targetLocationName = ChooseWarehouseCtrl:GetName();
        local pos = {}
        pos.x = ins.m_data.info.pos.x
        pos.y = ins.m_data.info.pos.y
        buyListing.distance = ChooseWarehouseCtrl:GetDistance(pos)
        local price = 0;
        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
            price = price + tonumber(v.moneyText.text);
        end
        buyListing.goodsPrice = price;
        local freight = 0;
        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
            freight = freight + (buyListing.distance * tonumber(v.numberScrollbar.value) * 10);
            buyListing.number = tonumber(v.numberScrollbar.value)
        end
        buyListing.freight = freight
        buyListing.total = price + freight;
        --local moneyValue = DataManager.GetMyMoney()

        buyListing.btnClick = function()
            --if moneyValue < buyListing.total then
            --    Event.Brocast("SmallPop","钱不够",280)
            --    return;
            --end
            local buildingId = ChooseWarehouseCtrl:GetBuildingId()
            for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
                Event.Brocast("m_ReqBuyShelfGoods",ins.m_data.info.id,v.itemId,v.numberScrollbar.value,v.moneyText.text,buildingId);
            end
            --DataManager.SetSubtractMyMoney(math.floor(buyListing.total))
        end
        ct.OpenCtrl("TransportBoxCtrl",buyListing);
    end
end

function ShelfCtrl:OnClick_return_Btn(go)
    go:deleteObjInfo();
    UIPage.ClosePage();
    if switchIsShow then
        go:openPlayerBuy(not switchIsShow)
    end
end
function ShelfCtrl:Hide()
    UIPage.Hide(self)
    return {insId = self.m_data.info.id}
end
--根据名字排序
function ShelfCtrl:OnClick_OnName(ins)
    ShelfPanel.nowText.text = "By name";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local nameType = ct.sortingItemType.Name
    ShelfCtrl:_getSortItems(nameType,ins.GoodsUnifyMgr.shelfLuaTab)
end
--根据数量排序
function ShelfCtrl:OnClick_OnNumber(ins)
    ShelfPanel.nowText.text = "By quantity";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local quantityType = ct.sortingItemType.Quantity
    ShelfCtrl:_getSortItems(quantityType,ins.GoodsUnifyMgr.shelfLuaTab)
end
--根据价格排序
function ShelfCtrl:OnClick_OnpriceBtn(ins)
    ShelfPanel.nowText.text = "By price";
    ShelfCtrl.OnClick_OpenList(not isShowList);
    local priceType = ct.sortingItemType.Price
    ShelfCtrl:_getSortItems(priceType,ins.GoodsUnifyMgr.shelfLuaTab)
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
--其他玩家购买窗口
function ShelfCtrl:OnClick_playerBuy(go)
    go:openPlayerBuy(not switchIsShow)
end

function ShelfCtrl:openPlayerBuy(isShow)
    if isShow then
        ShelfPanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        Event.Brocast("c_buyGoodsItemChoose")
        ShelfPanel.Content.offsetMax = Vector2.New(-740,0);
        ShelfPanel.confirmBtn.localScale = Vector3.zero
        ShelfPanel.uncheckBtn.localScale = Vector3.one
        ShelfPanel.nameText.text = "请选择仓库";
        --当右边购买界面打开时，重新刷新架子上的东西，求余 id%5 == 1 的时候打开架子
        self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,3)
    else
        ShelfPanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        Event.Brocast("c_buyGoodsItemDelete")
        ShelfPanel.Content.offsetMax = Vector2.New(0,0);
        self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,5)
        if self.GoodsUnifyMgr.shelfBuyGoodslItems ~= nil then
            for i,v in pairs(self.GoodsUnifyMgr.shelfBuyGoodslItems) do
                self:c_tempTabNotGoods(i)
            end
        end
    end
    switchIsShow = isShow
end
--购买成功后回调
function ShelfCtrl:receiveBuyRefreshInfo(Data)
    if not Data then
        return;
    end
    for i,v in pairs(self.GoodsUnifyMgr.shelfLuaTab) do
        if v.itemId == Data.item.key.id then
            if v.goodsDataInfo.n == Data.item.n then
                self.GoodsUnifyMgr:_deleteGoods(v)
                for i,v in pairs(ShelfCtrl.temporaryItems) do
                    self.GoodsUnifyMgr:_deleteBuyGoods(v)
                    self:isShowDetermineBtn()
                end
            else
                v.numberText.text = v.goodsDataInfo.n - Data.item.n;
                v.goodsDataInfo.n = v.numberText.text
                for i in pairs(ShelfCtrl.temporaryItems) do
                    Event.Brocast("c_tempTabNotGoods", i)
                end
            end
        end
    end
    Event.Brocast("SmallPop","购买成功",300)
end
function ShelfCtrl:OnClick_createGoods(go)
    if go.data == nil then
        return
    end
    go:deleteObjInfo();
    ct.OpenCtrl("WarehouseCtrl",go.data)
    --if go.data.buildingType == BuildingType.MaterialFactory then
    --    ct.OpenCtrl("WarehouseCtrl",go.data)
    --elseif go.data.buildingType == BuildingType.ProcessingFactory then
    --    ct.OpenCtrl("WarehouseCtrl",go.data)
    --end
end
--刷新购买确定按钮
function ShelfCtrl:isShowDetermineBtn()
    if not self.GoodsUnifyMgr then
        return
    end
    if not self.GoodsUnifyMgr.shelfBuyGoodslItems then
        return
    end
    local num = 0
    for i,v in pairs(self.GoodsUnifyMgr.shelfBuyGoodslItems) do
        num = num + i
    end
    if num ~= 0 and ShelfPanel.nameText.text ~= "请选择仓库" then
        ShelfPanel.confirmBtn.localScale = Vector3.one
        ShelfPanel.uncheckBtn.localScale = Vector3.zero
    else
        ShelfPanel.confirmBtn.localScale = Vector3.zero
        ShelfPanel.uncheckBtn.localScale = Vector3.one
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
    if not self.GoodsUnifyMgr.shelfLuaTab then
        return;
    else
        for i,v in pairs(self.GoodsUnifyMgr.shelfLuaTab) do
            v:closeEvent();
            destroy(v.prefab.gameObject);
        end
    end
end
function ShelfCtrl.OnCloseBtn()
    ShelfPanel.OnDestroy();
end