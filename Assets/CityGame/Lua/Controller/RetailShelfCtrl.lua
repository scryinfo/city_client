RetailShelfCtrl = class('RetailShelfCtrl',UIPage)
UIPage:ResgisterOpen(RetailShelfCtrl)

local isShowList
local isShowLists
local switchIsShow
RetailShelfCtrl.retailShelfGoods = {}
RetailShelfCtrl.retailShelfUIData = {}
function RetailShelfCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailShelfCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RetailShelfPanel.prefab"
end

function RetailShelfCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
end

function RetailShelfCtrl:Awake(go)
    self.gameObject = go
    self.retailShelf = self.gameObject:GetComponent('LuaBehaviour')
    self.retailShelf:AddClick(RetailShelfPanel.return_Btn.gameObject, self.OnClick_return_Btn, self)
    self.retailShelf:AddClick(RetailShelfPanel.arrowBtn.gameObject,self.OnClick_arrowBtn,self)
    self.retailShelf:AddClick(RetailShelfPanel.levelArrowBtn.gameObject,self.OnClick_levelArrowBtn,self)
    self.retailShelf:AddClick(RetailShelfPanel.nameBtn.gameObject,self.OnClick_OnName,self)
    self.retailShelf:AddClick(RetailShelfPanel.quantityBtn.gameObject,self.OnClick_OnNumber,self)
    self.retailShelf:AddClick(RetailShelfPanel.priceBtn.gameObject,self.OnClick_OnPrice,self)
    self.retailShelf:AddClick(RetailShelfPanel.allBtn.gameObject,self.OnClick_OnAll,self)
    self.retailShelf:AddClick(RetailShelfPanel.normalBtn.gameObject,self.OnClick_OnNormal,self)
    self.retailShelf:AddClick(RetailShelfPanel.middleBtn.gameObject,self.OnClick_OnMiddle,self)
    self.retailShelf:AddClick(RetailShelfPanel.seniorBtn.gameObject,self.OnClick_OnSenior,self)
    self.retailShelf:AddClick(RetailShelfPanel.addBtn.gameObject,self.OnClick_addBtn,self)
    self.retailShelf:AddClick(RetailShelfPanel.buy_Btn,self.OnClick_playerBuy,self)
    self.retailShelf:AddClick(RetailShelfPanel.closeBtn,self.OnClick_playerBuy,self);
    self.retailShelf:AddClick(RetailShelfPanel.confirmBtn,self.OnClcik_buyConfirmBtn,self);

    isShowList = false;
    isShowLists = false;
    switchIsShow = false;
end

function RetailShelfCtrl:Refresh()
    if self.m_data == nil then
        return;
    end
    self.shelf = self.m_data.shelf
    self.shelf.type = BuildingInType.RetailShelf
    self.shelf.isOther = self.m_data.isOther
    self.shelf.buildingId = self.m_data.info.id
    self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.retailShelf,self.shelf)
    if self.m_data.isOther then
        RetailShelfPanel.retailAddItem.gameObject:SetActive(false);
        RetailShelfPanel.buy_Btn.transform.localScale = Vector3.New(1,1,1);
        self:shelfImgSetActive(self.GoodsUnifyMgr.retailShelfs,5)   --传零售店的实例表进来  要求余数的大小

    else
        RetailShelfPanel.buy_Btn.transform.localScale = Vector3.New(0,0,0);
    end
    RetailShelfPanel.capacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].shelfCapacity;
    RetailShelfPanel.capacitySlider.value = self:getShelfCapacity(self.m_data.shelf)
    RetailShelfPanel.numberText.text = getColorString(RetailShelfPanel.capacitySlider.value,RetailShelfPanel.capacitySlider.maxValue,"blue","white")
end
--打开名字数量价格排序
function RetailShelfCtrl:OnClick_arrowBtn(go)
    go:OnClick_OpenList(not isShowList,0)
end
--打开等级评分排序
function RetailShelfCtrl:OnClick_levelArrowBtn(go)
    go:OnClick_OpenList(not isShowLists,1)
end
--排序列表
function RetailShelfCtrl:OnClick_OpenList(isShow,number)
    if isShow then
        if number == 0 then
            RetailShelfPanel.listTable:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.arrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowList = isShow
        elseif number == 1 then
            RetailShelfPanel.listTables:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.levelArrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowLists = isShow
        end
    else
        if number == 0 then
            RetailShelfPanel.listTable:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.arrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowList = isShow
        elseif number == 1 then
            RetailShelfPanel.listTables:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.levelArrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowLists = isShow
        end
    end
end

--点击添加按钮Add
function RetailShelfCtrl:OnClick_addBtn(go)
    --local data = {}
    --data.buildingData = BuildingType.RetailShop;
    --go.GoodsUnifyMgr = GoodsUnifyMgr:new(go.retailShelf,data);
    if go.m_data == nil then
        return
    end
    --go:
end
--其他玩家购买窗口
function RetailShelfCtrl:OnClick_playerBuy(go)
    go:openPlayerBuy(not switchIsShow)
end

function RetailShelfCtrl:openPlayerBuy(isShow)
    if isShow then
        RetailShelfPanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        --Event.Brocast("c_buyGoodsItemChoose")
        RetailShelfPanel.content.offsetMax = Vector2.New(-740,0);
        --当右边购买界面打开时，重新刷新架子上的东西，求余 id%5 == 1 的时候打开架子
        --self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,3)
    else
        RetailShelfPanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        --Event.Brocast("c_buyGoodsItemDelete")
        RetailShelfPanel.content.offsetMax = Vector2.New(0,0);
        --self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,5)
    end
    switchIsShow = isShow
end

----购买物品
--function RetailShelfCtrl:OnClcik_buyConfirmBtn(ins)
--    if not ins.GoodsUnifyMgr.shelfBuyGoodslItems or #ins.GoodsUnifyMgr.shelfBuyGoodslItems < 1 then
--        return;
--    else
--        local buyListing = {}
--        buyListing.currentLocationName = PlayerBuildingBaseData[ins.m_data.info.mId].sizeName..PlayerBuildingBaseData[ins.m_data.info.mId].typeName;
--        buyListing.targetLocationName = "中心仓库";
--        buyListing.distance = math.sqrt(math.pow((45 - ins.m_data.info.pos.x),2) + math.pow((45 - ins.m_data.info.pos.y),2));
--        local price = 0;
--        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
--            price = price + tonumber(v.moneyText.text);
--        end
--        buyListing.goodsPrice = price;
--        local freight = 0;
--        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
--            freight = freight + (buyListing.distance * tonumber(v.numberScrollbar.value) * 10);
--            buyListing.number = tonumber(v.numberScrollbar.value)
--        end
--        buyListing.freight = freight
--        buyListing.total = price + freight;
--        local moneyValue = DataManager.GetMyMoney()
--
--        buyListing.btnClick = function()
--            if moneyValue < buyListing.total then
--                Event.Brocast("SmallPop","钱不够",280)
--                return;
--            end
--            for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
--                Event.Brocast("m_ReqBuyShelfGoods",ins.m_data.info.id,v.itemId,v.numberScrollbar.value,v.moneyText.text,ServerListModel.bagId);
--            end
--            DataManager.SetSubtractMyMoney(math.floor(buyListing.total))
--        end
--        ct.OpenCtrl("TransportBoxCtrl",buyListing);
--    end
--end

--名字排序
function RetailShelfCtrl:OnClick_OnName(go)
    RetailShelfPanel.nowText.text = "By name";
    go:OnClick_OpenList(not isShowList,0)
end
--数量排序
function RetailShelfCtrl:OnClick_OnNumber(go)
    RetailShelfPanel.nowText.text = "By quantity";
    go:OnClick_OpenList(not isShowList,0)
end
--价格排序
function RetailShelfCtrl:OnClick_OnPrice(go)
    RetailShelfPanel.nowText.text = "By price";
    go:OnClick_OpenList(not isShowList,0)
end
--全部排序
function RetailShelfCtrl:OnClick_OnAll(go)
    RetailShelfPanel.levelnowText.text = "All";
    go:OnClick_OpenList(not isShowLists,1)
end
--低等级排序
function RetailShelfCtrl:OnClick_OnNormal(go)
    RetailShelfPanel.levelnowText.text = "Normal";
    go:OnClick_OpenList(not isShowLists,1)
end
--中等级排序
function RetailShelfCtrl:OnClick_OnMiddle(go)
    RetailShelfPanel.levelnowText.text = "Middle";
    go:OnClick_OpenList(not isShowLists,1)
end
--高等级排序
function RetailShelfCtrl:OnClick_OnSenior(go)
    RetailShelfPanel.levelnowText.text = "Senior";
    go:OnClick_OpenList(not isShowLists,1)
end
--获取零售店货架容量
function RetailShelfCtrl:getShelfCapacity(table)
    local shelfCapacity = 0;
    if not table.inHand then
        shelfCapacity = 0;
        return shelfCapacity;
    else
        for k,v in pairs(table.inHand) do
            shelfCapacity = shelfCapacity + v.n
        end
        return shelfCapacity;
    end
end
--架子隐藏和显示
function RetailShelfCtrl:shelfImgSetActive(table,num)
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
function RetailShelfCtrl:OnClick_return_Btn()
    UIPage.ClosePage();
end
function RetailShelfCtrl:Hide()
    UIPage.Hide(self)
    return {insId = self.m_data.info.id}
end