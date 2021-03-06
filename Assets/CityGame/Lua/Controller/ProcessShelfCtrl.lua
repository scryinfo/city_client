ProcessShelfCtrl = class('ProcessShelfCtrl',BuildingBaseCtrl)
UIPanel:ResgisterOpen(ProcessShelfCtrl)--How to open the registration

local shelf
local itemStateBool
local switchRightPanel
function ProcessShelfCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end
function ProcessShelfCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ProcessShelfPanel.prefab"
end
function ProcessShelfCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end
function ProcessShelfCtrl:Awake(go)
    shelf = self.gameObject:GetComponent('LuaBehaviour')
    shelf:AddClick(ProcessShelfPanel.return_Btn,self.OnClick_return_Btn,self)
    shelf:AddClick(ProcessShelfPanel.buy_Btn,self.OnClick_playerBuy,self)
    shelf:AddClick(ProcessShelfPanel.closeBtn,self.OnClick_playerBuy,self)
    shelf:AddClick(ProcessShelfPanel.openBtn,self.OnClick_openBtn,self)
    shelf:AddClick(ProcessShelfPanel.addBtn,self.OnClick_addBtn,self)
    shelf:AddClick(ProcessShelfPanel.confirmBtn.gameObject,self.OnClcik_buyConfirmBtn,self)

    itemStateBool = nil
    switchRightPanel = false
    self.tempItemList = {}  --Selected data
    self.recordIdList = {}  --Record the selected id
    self.shelfDatas = {}  --Data on the shelf
end
function ProcessShelfCtrl:Active()
    UIPanel.Active(self)
    ProcessShelfPanel.tipText.text = GetLanguage(26040002)
    LoadSprite(GetSprite("Shelf"), ProcessShelfPanel.shelfImg:GetComponent("Image"), false)
    self:_addListener()
    self:RefreshBuyButton()
end
function ProcessShelfCtrl:_addListener()
    Event.AddListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
    Event.AddListener("OpenDetailsBox",self.OpenDetailsBox,self)
end
function ProcessShelfCtrl:_removeListener()
    Event.RemoveListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
    Event.RemoveListener("OpenDetailsBox",self.OpenDetailsBox,self)
end
function ProcessShelfCtrl:Refresh()
    self.luabehaviour = shelf
    self.shelf = self.m_data.shelf
    self.isOther = self.m_data.isOther
    self.buildingId = self.m_data.info.id
    if self.isOther then
        self:OthersInitializeData()
    else
        self:MeInitializeData()
    end
end
function ProcessShelfCtrl:Hide()
    UIPanel.Hide(self)
    self:_removeListener()
    return {insId = self.m_data.info.id,self.m_data}
end
----------------------------------------------------------------------Initialization function------------------------------------------------------------------------------------------
--Self
function ProcessShelfCtrl:MeInitializeData()
    ProcessShelfPanel.buy_Btn.transform.localScale = Vector3.zero;
    ProcessShelfPanel.shelfAddItem.gameObject:SetActive(true)
    if next(self.shelfDatas) == nil then
        self:CreateGoodsItems(self.shelf.good,ProcessShelfPanel.ShelfGoodsItem,ProcessShelfPanel.Content,ShelfGoodsItem,self.luabehaviour,self.shelfDatas,self.isOther,self.buildingId)
    end
    self.ShelfImgSetActive(self.shelfDatas,5,0)
end
--others
function ProcessShelfCtrl:OthersInitializeData()
    ProcessShelfPanel.buy_Btn.transform.localScale = Vector3.one;
    ProcessShelfPanel.shelfAddItem.gameObject:SetActive(false)
    if next(self.shelfDatas) == nil then
        self:CreateGoodsItems(self.shelf.good,ProcessShelfPanel.ShelfGoodsItem,ProcessShelfPanel.Content,ShelfGoodsItem,self.luabehaviour,self.shelfDatas,self.isOther,self.buildingId)
    end
    self.ShelfImgSetActive(self.shelfDatas,5,1)
end
----------------------------------------------------------------------Click function------------------------------------------------------------------------------------------
function ProcessShelfCtrl:OnClick_return_Btn(ins)
    PlayMusEff(1002)
    if switchRightPanel == true then
        ins:openPlayerBuy(not switchRightPanel)
    end
    ins:CloseDestroy(ins.shelfDatas)
    UIPanel.ClosePage()
end
--Click to buy Panel
function ProcessShelfCtrl:OnClick_playerBuy(ins)
    PlayMusEff(1002)
    if ins.m_data.info.state == "OPERATE" then
        ins:openPlayerBuy(not switchRightPanel)
    else
        Event.Brocast("SmallPop",GetLanguage(35040013),300)
        return
    end
end
--Jump to select warehouse
function ProcessShelfCtrl:OnClick_openBtn(ins)
    PlayMusEff(1002)
    local data = {}
    data.pos = {}
    data.pos.x = ins.m_data.info.pos.x
    data.pos.y = ins.m_data.info.pos.y
    data.buildingId = ins.buildingId
    data.nameText = ProcessShelfPanel.nameText
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--Purchase confirmation
function ProcessShelfCtrl:OnClcik_buyConfirmBtn(ins)
    PlayMusEff(1002)
    local targetBuildingId = ChooseWarehouseCtrl:GetBuildingId()
    local buyDataInfo = {}
    buyDataInfo.currentLocationName = ins.m_data.info.name
    buyDataInfo.targetLocationName = ChooseWarehouseCtrl:GetName()
    local pos = {}
    pos.x = ins.m_data.info.pos.x
    pos.y = ins.m_data.info.pos.y
    buyDataInfo.distance = ChooseWarehouseCtrl:GetDistance(pos)
    buyDataInfo.number = ins.GetDataTableNum(ins.tempItemList)
    buyDataInfo.freight = GetClientPriceString(ChooseWarehouseCtrl:GetPrice())
    buyDataInfo.goodsPrice = ins:GetTotalPrice()
    buyDataInfo.total = GetClientPriceString(buyDataInfo.number * GetServerPriceNumber(buyDataInfo.freight)) + buyDataInfo.goodsPrice
    buyDataInfo.btnClick = function()
        if buyDataInfo.number == 0 then
            Event.Brocast("SmallPop",GetLanguage(27020004),300)
            return
        else
            for key,value in pairs(ins.tempItemList) do
                Event.Brocast("m_ReqProcessBuyShelfGoods",ins.buildingId,value.itemId,value.inputNumber.text,
                        value.goodsDataInfo.price,targetBuildingId,value.goodsDataInfo.k.producerId,value.goodsDataInfo.k.qty)
            end
        end
    end
    ct.OpenCtrl("TransportBoxCtrl",buyDataInfo)
end
--Open warehouse
function ProcessShelfCtrl:OnClick_addBtn(go)
    PlayMusEff(1002)
    go:CloseDestroy(go.shelfDatas)
    go.m_data.isShelf = true
    ct.OpenCtrl("ProcessWarehouseCtrl",go.m_data)
end
----------------------------------------------------------------------Callback function----------------------------------------------------------------------------------------
--Refresh shelf data
function ProcessShelfCtrl:RefreshShelfData(dataInfo)
    --If the shelf adjustment box
    if not dataInfo.wareHouseId then
        --If it is price adjustment
        if dataInfo.price then
            for key,value in pairs(self.shelfDatas) do
                if value.itemId == dataInfo.item.key.id then
                    value.moneyText.text = GetClientPriceString(dataInfo.price)
                    value.price = dataInfo.price
                end
            end
            Event.Brocast("SmallPop",GetLanguage(27010005),300)
            return
        end
        --If it is an adjustment quantity
        for key,value in pairs(self.shelfDatas) do
            if value.itemId == dataInfo.item.key.id then
                if value.num == dataInfo.item.n then
                    self:deleteGoodsItem(self.shelfDatas,key)

                    --After the shelf is removed, the quantity of the shelf product should be added to the warehouse
                    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
                        local inHand = {}
                        local goodsData = {}
                        local key = {}
                        key.id = dataInfo.item.key.id
                        key.producerId = dataInfo.item.key.producerId
                        key.qty = dataInfo.item.key.qty
                        goodsData.key = key
                        goodsData.n = dataInfo.item.n
                        inHand = goodsData
                        self.m_data.store.inHand = {}
                        self.m_data.store.inHand[#self.m_data.store.inHand + 1] = inHand
                    else
                        for key,value in pairs(self.m_data.store.inHand) do
                            if value.key.id == dataInfo.item.key.id then
                                value.n = value.n + dataInfo.item.n
                            end
                        end
                    end
                    for key1,value1 in pairs(self.m_data.shelf.good) do
                        if value1.k.id == dataInfo.item.key.id then
                            table.remove(self.m_data.shelf.good,key1)
                        end
                    end
                    for key2,value2 in pairs(self.m_data.store.locked) do
                        if value2.key.id == dataInfo.item.key.id then
                            table.remove(self.m_data.store.locked,key2)
                        end
                    end
                else
                    value.numberText.text = value.num - dataInfo.item.n
                    value.goodsDataInfo.n = tonumber(value.numberText.text)
                    value.num = tonumber(value.numberText.text)
                    --Simultaneously change the simulation server data after the number of off shelves
                    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
                        local goodsData = {}
                        local key = {}
                        key.id = dataInfo.item.key.id
                        key.producerId = dataInfo.item.key.producerId
                        key.qty = dataInfo.item.key.qty
                        goodsData.key = key
                        goodsData.n = dataInfo.item.n
                        if not self.m_data.store.inHand then
                            self.m_data.store.inHand = {}
                        end
                        self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goodsData
                    else
                        for key,value in pairs(self.m_data.store.inHand) do
                            if value.key.id == dataInfo.item.key.id then
                                value.n = value.n + dataInfo.item.n
                            end
                        end
                    end
                    if not self.m_data.store.locked or next(self.m_data.store.locked) == nil then
                        local goodsData = {}
                        local key = {}
                        key.id = dataInfo.item.key.id
                        key.producerId = dataInfo.item.key.producerId
                        key.qty = dataInfo.item.key.qty
                        goodsData.key = key
                        goodsData.n = dataInfo.item.n
                        if not self.m_data.store.locked then
                            self.m_data.store.locked = {}
                        end
                        self.m_data.store.locked[#self.m_data.store.locked + 1] = goodsData
                    else
                        for key1,value1 in pairs(self.m_data.store.locked) do
                            if value1.key.id == dataInfo.item.key.id then
                                value1.n = value1.n - dataInfo.item.n
                            end
                        end
                    end
                end
            end
        end
        Event.Brocast("SmallPop",GetLanguage(27010003),300)
    else
        --If it is a purchase
        for key,value in pairs(self.shelfDatas) do
            if value.itemId == dataInfo.item.key.id then
                if value.num == dataInfo.item.n then
                    self:deleteGoodsItem(self.shelfDatas,key)
                else
                    value.numberText.text = value.num - dataInfo.item.n
                    value.goodsDataInfo.n = tonumber(value.numberText.text)
                    value.num = tonumber(value.numberText.text)
                    local stateBool = true
                    self:GoodsItemState(self.shelfDatas,stateBool)
                end
            end
            self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
        end
        ProcessShelfPanel.nameText.text = ""
        self.ShelfImgSetActive(self.shelfDatas,5,1)
        self:RefreshBuyButton()
        Event.Brocast("SmallPop","购买成功"--[[GetLanguage(27010003)]],300)
    end
end
----------------------------------------------------------------------Event function-------------------------------------------------------------------------------------------
--Check products
function ProcessShelfCtrl:SelectedGoodsItem(ins)
    if self.recordIdList[ins.id] == nil then
        self.recordIdList[ins.id] = ins.id
        self:CreateGoodsDetails(ins.goodsDataInfo,ProcessShelfPanel.BuyDetailsItem,ProcessShelfPanel.buyContent,BuyDetailsItem,self.luabehaviour,ins.id,self.tempItemList)
        self.shelfDatas[ins.id]:c_GoodsItemSelected()
    else
        self.shelfDatas[ins.id]:c_GoodsItemChoose()
        self:DestoryGoodsDetailsList(self.tempItemList,self.recordIdList,ins.id)
    end
    self:RefreshBuyButton()
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Open Purchase Panel
function ProcessShelfCtrl:openPlayerBuy(isShow)
    if isShow then
        itemStateBool = true
        ProcessShelfPanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
        ProcessShelfPanel.Content.offsetMax = Vector2.New(-740,0)
        self.ShelfImgSetActive(self.shelfDatas,3,1)
        self:GoodsItemState(self.shelfDatas,itemStateBool)
        self:RefreshBuyButton()
    else
        itemStateBool = false
        ProcessShelfPanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
        ProcessShelfPanel.Content.offsetMax = Vector2.New(0,0)
        self.ShelfImgSetActive(self.shelfDatas,5,1)
        self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
        self:GoodsItemState(self.shelfDatas,itemStateBool)
        ProcessShelfPanel.nameText.text = ""
    end
    switchRightPanel = isShow
end
--Refresh purchase confirmation button
function ProcessShelfCtrl:RefreshBuyButton()
    if next(self.tempItemList) == nil or ProcessShelfPanel.nameText.text == "" then
        ProcessShelfPanel.uncheckBtn.transform.localScale = Vector3.one
        ProcessShelfPanel.confirmBtn.transform.localScale = Vector3.zero
    elseif next(self.tempItemList) ~= nil and ProcessShelfPanel.nameText.text ~= "" then
        ProcessShelfPanel.uncheckBtn.transform.localScale = Vector3.zero
        ProcessShelfPanel.confirmBtn.transform.localScale = Vector3.one
    end
end
--Get the total price of the purchased goods
function ProcessShelfCtrl:GetTotalPrice()
    local price = 0
    for key,value in pairs(self.tempItemList) do
        price = price + GetServerPriceNumber(value.tempPrice)
    end
    return GetClientPriceString(price)
end
--Click on the item details box on the shelf
function ProcessShelfCtrl:OpenDetailsBox(ins)
    ins.buildingType = self.m_data.buildingType
    ins.isOther = self.m_data.isOther
    ct.OpenCtrl("DETAILSBoxCtrl",ins)
end





--ProcessShelfCtrl = class('ProcessShelfCtrl',UIPanel)
--UIPanel:ResgisterOpen(ProcessShelfCtrl)
--
--local isShowList;
--local switchIsShow;
--local shelf;
--local listTrue = Vector3.New(0,0,180);
--local listFalse = Vector3.New(0,0,0);
----Store selected items, temporary table
--ProcessShelfCtrl.temporaryItems = {}
--function ProcessShelfCtrl:initialize()
--    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
--end
--
--function ProcessShelfCtrl:bundleName()
--    return "Assets/CityGame/Resources/View/ProcessShelfPanel.prefab"
--end
--
--function ProcessShelfCtrl:OnCreate(obj)
--    UIPanel.OnCreate(self,obj)
--end
--
--function ProcessShelfCtrl:Awake(go)
--    shelf = self.gameObject:GetComponent('LuaBehaviour')
--    shelf:AddClick(ProcessShelfPanel.return_Btn,self.OnClick_return_Btn, self);
--    shelf:AddClick(ProcessShelfPanel.arrowBtn.gameObject,self.OnClick_OnSorting, self);
--    shelf:AddClick(ProcessShelfPanel.nameBtn.gameObject,self.OnClick_OnName, self);
--    shelf:AddClick(ProcessShelfPanel.quantityBtn.gameObject,self.OnClick_OnNumber, self);
--    shelf:AddClick(ProcessShelfPanel.priceBtn.gameObject,self.OnClick_OnpriceBtn, self);
--    shelf:AddClick(ProcessShelfPanel.addBtn,self.OnClick_createGoods, self);
--    shelf:AddClick(ProcessShelfPanel.buy_Btn,self.OnClick_playerBuy,self);
--    shelf:AddClick(ProcessShelfPanel.closeBtn,self.OnClick_playerBuy,self);
--    shelf:AddClick(ProcessShelfPanel.confirmBtn.gameObject,self.OnClcik_buyConfirmBtn,self);
--    shelf:AddClick(ProcessShelfPanel.openBtn,self.OnClick_openBtn,self);
--
--    self.gameObject = go
--    isShowList = false;
--    switchIsShow = false;
--    ProcessShelfPanel.nameText.text = GetLanguage(26040002)
--    Event.AddListener("shelfRefreshUiInfo",self.refreshUiInfo,self)
--end
--function ProcessShelfCtrl:Active()
--    UIPanel.Active(self)
--    ProcessShelfPanel.tipText.text = GetLanguage(26040002)
--    LoadSprite(GetSprite("Shelf"), ProcessShelfPanel.shelfImg:GetComponent("Image"), false)
--    Event.AddListener("_selectedBuyGoods",self._selectedBuyGoods,self);
--    Event.AddListener("c_tempTabNotGoods",self.c_tempTabNotGoods,self);
--    Event.AddListener("receiveBuyRefreshInfo",self.receiveBuyRefreshInfo,self);
--end
--function ProcessShelfCtrl:Refresh()
--    if self.m_data[1] ~= nil then
--        self.m_data = self.m_data[1]
--    end
--    self.data = self.m_data
--    self.luabehaviour = shelf
--    self.shelf = self.m_data.shelf
--    self.shelf.type = BuildingInType.Shelf
--    self.shelf.isOther = self.m_data.isOther
--    self.shelf.buildingId = self.m_data.info.id
--    self:isShowDetermineBtn()
--    if ProcessShelfPanel.Content.childCount <= 1 then
--        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.shelf)
--    end
--    if self.m_data.isOther then
--        if self.m_data.info.state == "OPERATE" then
--            ProcessShelfPanel.buy_Btn.transform.localScale = Vector3.New(1,1,1);
--        else
--            ProcessShelfPanel.buy_Btn.transform.localScale = Vector3.New(0,0,0);
--        end
--        ProcessShelfPanel.shelfAddItem.gameObject:SetActive(false)
--        self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,5)
--
--    else
--        ProcessShelfPanel.shelfAddItem.gameObject:SetActive(true)
--        ProcessShelfPanel.buy_Btn.transform.localScale = Vector3.New(0,0,0);
--    end
--
--end
----Selected items
--function ProcessShelfCtrl:_selectedBuyGoods(ins)
--    if self.temporaryItems[ins.id] == nil then
--        self.temporaryItems[ins.id] = ins.id
--        self.GoodsUnifyMgr:_buyShelfGoods(ins,self.luabehaviour)
--        self.GoodsUnifyMgr.shelfLuaTab[ins.id].circleTickImg.transform.localScale = Vector3.one
--    else
--        self.temporaryItems[ins.id] = nil;
--        self.GoodsUnifyMgr.shelfLuaTab[ins.id].circleTickImg.transform.localScale = Vector3.zero
--        self.GoodsUnifyMgr:_deleteBuyGoods(ins.id);
--    end
--    self:isShowDetermineBtn()
--end
----Is this item in the temporary table
--function ProcessShelfCtrl:c_tempTabNotGoods(id)
--    self.temporaryItems[id] = nil
--    self.GoodsUnifyMgr.shelfLuaTab[id].circleTickImg.transform.localScale = Vector3.zero
--    self.GoodsUnifyMgr:_deleteBuyGoods(id);
--    self:isShowDetermineBtn()
--end
----跳转选择仓库界面
--function ProcessShelfCtrl:OnClick_openBtn(go)
--    PlayMusEff(1002)
--    local data = {}
--    data.pos = {}
--    data.pos.x = go.m_data.info.pos.x
--    data.pos.y = go.m_data.info.pos.y
--    data.nameText = ProcessShelfPanel.nameText
--    data.buildingId = go.m_data.info.id
--    ct.OpenCtrl("ChooseWarehouseCtrl",data)
--end
----购买物品
--function ProcessShelfCtrl:OnClcik_buyConfirmBtn(ins)
--    PlayMusEff(1002)
--    if not ins.GoodsUnifyMgr.shelfBuyGoodslItems or #ins.GoodsUnifyMgr.shelfBuyGoodslItems < 1 then
--        return;
--    else
--        local buyListing = {}
--        buyListing.currentLocationName = ins.m_data.info.name
--        --buyListing.targetLocationName = "中心仓库";
--        --buyListing.distance = math.sqrt(math.pow((45 - ins.m_data.info.pos.x),2) + math.pow((45 - ins.m_data.info.pos.y),2));
--        buyListing.targetLocationName = ChooseWarehouseCtrl:GetName();
--        local pos = {}
--        pos.x = ins.m_data.info.pos.x
--        pos.y = ins.m_data.info.pos.y
--        buyListing.distance = ChooseWarehouseCtrl:GetDistance(pos)
--        local price = 0;
--        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
--            price = price + GetServerPriceNumber(v.tempPrice)
--        end
--        buyListing.goodsPrice = GetClientPriceString(price);
--        local freight = 0;
--        local onePrice = ChooseWarehouseCtrl:GetPrice()
--        for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
--            freight = freight + (onePrice * v.numberScrollbar.value);
--            buyListing.number = tonumber(v.numberScrollbar.value)
--        end
--        buyListing.freight = GetClientPriceString(freight)
--        buyListing.total = GetClientPriceString(price + freight);
--        --local moneyValue = DataManager.GetMyMoney()
--        buyListing.btnClick = function()
--            --if moneyValue < buyListing.total then
--            --    Event.Brocast("SmallPop","钱不够",280)
--            --    return;
--            --end
--            local buildingId = ChooseWarehouseCtrl:GetBuildingId()
--            for i,v in pairs(ins.GoodsUnifyMgr.shelfBuyGoodslItems) do
--                Event.Brocast("m_ReqBuyShelfGoods",ins.m_data.info.id,v.itemId,v.numberScrollbar.value,v.goodsDataInfo.price,buildingId,v.goodsDataInfo.k.producerId,v.goodsDataInfo.k.qty);
--            end
--            --DataManager.SetSubtractMyMoney(math.floor(buyListing.total))
--        end
--        ct.OpenCtrl("TransportBoxCtrl",buyListing);
--    end
--end
--
--function ProcessShelfCtrl:OnClick_return_Btn(go)
--    go:deleteObjInfo();
--    PlayMusEff(1002)
--    UIPanel.ClosePage()
--    if switchIsShow then
--        go:openPlayerBuy(not switchIsShow)
--    end
--end
--function ProcessShelfCtrl:Hide()
--    Event.RemoveListener("_selectedBuyGoods",self._selectedBuyGoods,self);
--    Event.RemoveListener("c_tempTabNotGoods",self.c_tempTabNotGoods,self);
--    Event.RemoveListener("receiveBuyRefreshInfo",self.receiveBuyRefreshInfo,self);
--    UIPanel.Hide(self)
--    return {insId = self.m_data.info.id,self.m_data}
--end
----Sort by name
--function ProcessShelfCtrl:OnClick_OnName(ins)
--    PlayMusEff(1002)
--    ProcessShelfPanel.nowText.text = "By name";
--    ProcessShelfCtrl.OnClick_OpenList(not isShowList);
--    local nameType = ct.sortingItemType.Name
--    ProcessShelfCtrl:_getSortItems(nameType,ins.GoodsUnifyMgr.shelfLuaTab)
--end
----Sort by quantity
--function ProcessShelfCtrl:OnClick_OnNumber(ins)
--    PlayMusEff(1002)
--    ProcessShelfPanel.nowText.text = "By quantity";
--    ProcessShelfCtrl.OnClick_OpenList(not isShowList);
--    local quantityType = ct.sortingItemType.Quantity
--    ProcessShelfCtrl:_getSortItems(quantityType,ins.GoodsUnifyMgr.shelfLuaTab)
--end
----Sort by price
--function ProcessShelfCtrl:OnClick_OnpriceBtn(ins)
--    PlayMusEff(1002)
--    ProcessShelfPanel.nowText.text = "By price";
--    ProcessShelfCtrl.OnClick_OpenList(not isShowList);
--    local priceType = ct.sortingItemType.Price
--    ProcessShelfCtrl:_getSortItems(priceType,ins.GoodsUnifyMgr.shelfLuaTab)
--end
--
--function ProcessShelfCtrl.OnClick_OnSorting(ins)
--    PlayMusEff(1002)
--    ProcessShelfCtrl.OnClick_OpenList(not isShowList);
--end
--
--function ProcessShelfCtrl.OnClick_OpenList(isShow)
--    if isShow then
--        ProcessShelfPanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
--        ProcessShelfPanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
--    else
--        ProcessShelfPanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
--        ProcessShelfPanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
--    end
--    isShowList = isShow;
--end
----Purchase window for other players
--function ProcessShelfCtrl:OnClick_playerBuy(go)
--    PlayMusEff(1002)
--    go:openPlayerBuy(not switchIsShow)
--end
--
--function ProcessShelfCtrl:openPlayerBuy(isShow)
--    if isShow then
--        ProcessShelfPanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
--        Event.Brocast("c_buyGoodsItemChoose")
--        ProcessShelfPanel.Content.offsetMax = Vector2.New(-740,0);
--        ProcessShelfPanel.confirmBtn.localScale = Vector3.zero
--        ProcessShelfPanel.uncheckBtn.localScale = Vector3.one
--        --ProcessShelfPanel.nameText.text = "请选择仓库";
--        --当右边购买界面打开时，重新刷新架子上的东西，求余 id%5 == 1 的时候打开架子
--        self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,3)
--    else
--        ProcessShelfPanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
--        ProcessShelfPanel.Content.offsetMax = Vector2.New(0,0);
--        self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,5)
--        if self.GoodsUnifyMgr.shelfBuyGoodslItems ~= nil then
--            for i,v in pairs(self.GoodsUnifyMgr.shelfBuyGoodslItems) do
--                self:c_tempTabNotGoods(i)
--            end
--        end
--        if self.GoodsUnifyMgr.shelfLuaTab ~= {} then
--            Event.Brocast("c_buyGoodsItemDelete")
--        end
--    end
--    switchIsShow = isShow
--end
----Callback after successful purchase
--function ProcessShelfCtrl:receiveBuyRefreshInfo(Data)
--    if not Data then
--        return;
--    end
--    for i,v in pairs(self.GoodsUnifyMgr.shelfLuaTab) do
--        if v.itemId == Data.item.key.id then
--            if v.goodsDataInfo.n == Data.item.n then
--                self.GoodsUnifyMgr:_deleteGoods(v)
--                self:shelfImgSetActive(self.GoodsUnifyMgr.shelfLuaTab,3)
--
--                Event.Brocast("c_buyGoodsItemChoose")
--
--                for i,v in pairs(ProcessShelfCtrl.temporaryItems) do
--                    self.GoodsUnifyMgr:_deleteBuyGoods(v)
--                    self:isShowDetermineBtn()
--                end
--            else
--                v.numberText.text = v.goodsDataInfo.n - Data.item.n;
--                v.goodsDataInfo.n = tonumber(v.numberText.text)
--                for i in pairs(ProcessShelfCtrl.temporaryItems) do
--                    self:c_tempTabNotGoods(i)
--                    --Event.Brocast("c_tempTabNotGoods", i)
--                end
--                Event.Brocast("SmallPop",GetLanguage(27010006),300)
--            end
--        end
--    end
--end
------Refresh the callback after modifying the price
--function ProcessShelfCtrl:refreshUiInfo(msg)
--    if not msg then
--        return
--    end
--    for i,v in pairs(self.GoodsUnifyMgr.shelfLuaTab) do
--        if v.itemId == msg.item.key.id then
--            v.moneyText.text = "E"..GetClientPriceString(msg.price)
--            v.numberText.text = tonumber(v.numberText.text) + msg.item.n
--        end
--    end
--end
--function ProcessShelfCtrl:OnClick_createGoods(go)
--    PlayMusEff(1002)
--    if go.m_data.info.state == "OPERATE" then
--        if go.data == nil then
--            return
--        end
--        go:deleteObjInfo();
--        go.data.shelfOpen = 1
--        ct.OpenCtrl("WarehouseCtrl",go.data)
--    else
--        Event.Brocast("SmallPop",GetLanguage(35040013),300)
--    end
--end
----Refresh purchase confirmation button
--function ProcessShelfCtrl:isShowDetermineBtn()
--    if not self.GoodsUnifyMgr then
--        return
--    end
--    if not self.GoodsUnifyMgr.shelfBuyGoodslItems then
--        return
--    end
--    local num = 0
--    for i,v in pairs(self.GoodsUnifyMgr.shelfBuyGoodslItems) do
--        num = num + i
--    end
--    if num ~= 0 and ProcessShelfPanel.nameText.text ~= nil then
--        ProcessShelfPanel.confirmBtn.localScale = Vector3.one
--        ProcessShelfPanel.uncheckBtn.localScale = Vector3.zero
--    else
--        ProcessShelfPanel.confirmBtn.localScale = Vector3.zero
--        ProcessShelfPanel.uncheckBtn.localScale = Vector3.one
--    end
--end
----Hidden and displayed shelves
--function ProcessShelfCtrl:shelfImgSetActive(table,num)
--    if not table then
--        return
--    end
--    for i,v in pairs(table) do
--        if i % 5 == 1 then
--            v.shelfImg:SetActive(true);
--        else
--            v.shelfImg:SetActive(false);
--        end
--    end
--end
----sort
--function ProcessShelfCtrl:_getSortItems(type,sortingTable)
--    if type == ct.sortingItemType.Name then
--        table.sort(sortingTable, function (m, n) return m.name < n.name end )
--        for i, v in ipairs(sortingTable) do
--            v.prefab.gameObject.transform:SetParent(ProcessShelfPanel.scrollView.transform);
--            v.prefab.gameObject.transform:SetParent(ProcessShelfPanel.Content.transform);
--            v.id = i
--            ShelfGoodsItem:RefreshData(v.goodsDataInfo,i)
--        end
--    end
--    if type == ct.sortingItemType.Quantity then
--        table.sort(sortingTable, function (m, n) return m.num < n.num end )
--        for i, v in ipairs(sortingTable) do
--            v.prefab.gameObject.transform:SetParent(ProcessShelfPanel.scrollView.transform);
--            v.prefab.gameObject.transform:SetParent(ProcessShelfPanel.Content.transform);
--            v.id = i
--            ShelfGoodsItem:RefreshData(v.goodsDataInfo,i)
--        end
--    end
--    if type == ct.sortingItemType.Price then
--        table.sort(sortingTable, function (m, n) return m.price < n.price end )
--        for i, v in ipairs(sortingTable) do
--            v.prefab.gameObject.transform:SetParent(ProcessShelfPanel.scrollView.transform);
--            v.prefab.gameObject.transform:SetParent(ProcessShelfPanel.Content.transform);
--            v.id = i
--            ShelfGoodsItem:RefreshData(v.goodsDataInfo,i)
--        end
--    end
--end
------Generate prefab
----function ProcessShelfCtrl:_creatGoods(path,parent)
----    local prefab = UnityEngine.Resources.Load(path);
----    local go = UnityEngine.GameObject.Instantiate(prefab);
----    local rect = go.transform:GetComponent("RectTransform");
----    go.transform:SetParent(parent.transform);
----    rect.transform.localScale = Vector3.one;
----    return go
----end
----Clear the UI information when closing the panel in case other modules call
--function ProcessShelfCtrl:deleteObjInfo()
--    if not self.GoodsUnifyMgr.shelfLuaTab then
--        return;
--    else
--        for i,v in pairs(self.GoodsUnifyMgr.shelfLuaTab) do
--            v:closeEvent();
--            destroy(v.prefab.gameObject);
--        end
--    end
--end
--function ProcessShelfCtrl.OnCloseBtn()
--    ProcessShelfPanel.OnDestroy();
--end