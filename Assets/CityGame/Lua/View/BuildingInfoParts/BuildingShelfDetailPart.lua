---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 11:37
---建筑主界面货架详情界面
BuildingShelfDetailPart = class('BuildingShelfDetailPart',BuildingBaseDetailPart)

function BuildingShelfDetailPart:PrefabName()
    return "BuildingShelfDetailPart"
end

function BuildingShelfDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    --货架数据
    self.shelfDatas = {}
    --购买列表(暂时购买成功后或退出建筑时清空)
    self.buyDatas = {}
end

function BuildingShelfDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end

function BuildingShelfDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    --TopRoot
    self.closeBtn = transform:Find("topRoot/closeBtn")
    self.sortingBtn = transform:Find("topRoot/sortingBtn")
    self.nowStateText = transform:Find("topRoot/sortingBtn/nowStateText"):GetComponent("Text")
    self.buyBtn = transform:Find("topRoot/buyBtn")
    self.number = transform:Find("topRoot/number")
    self.numberText = transform:Find("topRoot/number/numberText"):GetComponent("Text")

    --ContentRoot
    self.noTip = transform:Find("contentRoot/noTip")
    self.tipText = transform:Find("contentRoot/noTip/tipText"):GetComponent("Text")
    self.addbg = transform:Find("contentRoot/noTip/addbg")
    self.addBtn = transform:Find("contentRoot/noTip/addbg/addBtn")
    self.ScrollView = transform:Find("contentRoot/ScrollView")
    self.Content = transform:Find("contentRoot/ScrollView/Viewport/Content")
    self.contentAddBg = transform:Find("contentRoot/ScrollView/Viewport/Content/addbg")
    self.contentAddBtn = transform:Find("contentRoot/ScrollView/Viewport/Content/addbg/addBtn")
    self.ShelfItem = transform:Find("contentRoot/ScrollView/Viewport/Content/ShelfItem").gameObject
end

function BuildingShelfDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject,function()
        self:clickCloseBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.addBtn.gameObject,function()
        self:clickaddShelfBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.contentAddBtn.gameObject,function()
        self:clickaddShelfBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.buyBtn.gameObject,function()
        self:clickBuyBtn()
    end,self)
end

function BuildingShelfDetailPart:_ResetTransform()
    --关闭时清空Item数据
    if next(self.shelfDatas) ~= nil then
        self:CloseDestroy(self.shelfDatas)
    end
end

function BuildingShelfDetailPart:_RemoveClick()

end

function BuildingShelfDetailPart:_InitEvent()
    Event.AddListener("addBuyList",self.addBuyList,self)
    Event.AddListener("deleBuyList",self.deleBuyList,self)
    Event.AddListener("startBuy",self.startBuy,self)
    Event.AddListener("refreshShelfDetailPart",self.refreshShelfDetailPart,self)
    Event.AddListener("whetherSend",self.whetherSend,self)
    Event.AddListener("downShelf",self.downShelf,self)
    Event.AddListener("downShelfSucceed",self.downShelfSucceed,self)
    Event.AddListener("buySucceed",self.buySucceed,self)
end

function BuildingShelfDetailPart:_RemoveEvent()
    Event.RemoveListener("addBuyList",self.addBuyList,self)
    Event.RemoveListener("deleBuyList",self.deleBuyList,self)
    Event.RemoveListener("startBuy",self.startBuy,self)
    Event.RemoveListener("refreshShelfDetailPart",self.refreshShelfDetailPart,self)
    Event.RemoveListener("whetherSend",self.whetherSend,self)
    Event.RemoveListener("downShelf",self.downShelf,self)
    Event.RemoveListener("downShelfSucceed",self.downShelfSucceed,self)
    Event.RemoveListener("buySucceed",self.buySucceed,self)
end

function BuildingShelfDetailPart:_initFunc()
    self:_language()
    self:initializeUiInfoData(self.m_data.shelf.good)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingShelfDetailPart:_language()
    self.tipText.text = "There is no product yet!".."\n".."just go to produce some.good luck."
end
--初始化UI数据
function BuildingShelfDetailPart:initializeUiInfoData(shelfData)
    --是否是自己打开
    if self.m_data.isOther == true then
        self.contentAddBg.gameObject:SetActive(false)
        self.buyBtn.transform.localScale = Vector3.one
        self.number.transform.localScale = Vector3.zero
    else
        self.contentAddBg.gameObject:SetActive(true)
        self.buyBtn.transform.localScale = Vector3.zero
        self.number.transform.localScale = Vector3.zero
    end
    --货架是否是空的
    if not shelfData or next(shelfData) == nil then
        self.number.transform.localScale = Vector3.zero
        self.noTip.transform.localScale = Vector3.one
        self.ScrollView.transform.localScale = Vector3.zero
        if self.m_data.isOther == true then
            self.addbg.transform.localScale = Vector3.zero
        else
            self.addbg.transform.localScale = Vector3.one
        end
    else
        self.noTip.transform.localScale = Vector3.zero
        self.ScrollView.transform.localScale = Vector3.one

        if next(self.buyDatas) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
        end
        if #shelfData == #self.shelfDatas then
            return
        else
            self:CreateGoodsItems(shelfData,self.ShelfItem,self.Content,ShelfItem,self.mainPanelLuaBehaviour,self.shelfDatas,self.m_data.buildingType,self.m_data.insId,self.m_data.isOther)
        end
    end
end
-----------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------
--关闭详情
function BuildingShelfDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--点击上架
function BuildingShelfDetailPart:clickaddShelfBtn()
    local data = {}
    data.info = self.m_data
    ct.OpenCtrl("WarehouseDetailBoxCtrl",data)
end
--打开购买弹窗
function BuildingShelfDetailPart:clickBuyBtn()
    local data = {}
    data.buildingId = self.m_data.insId
    data.buildingInfo = self.m_data.info
    data.buildingType = self.m_data.buildingType
    data.itemPrefabTab = self.buyDatas
    data.stateType = GoodsItemStateType.buy
    ct.OpenCtrl("NewTransportBoxCtrl",data)
end
-----------------------------------------------------------------------------事件函数--------------------------------------------------------------------------------------
--添加到购买列表
function BuildingShelfDetailPart:addBuyList(data)
    --添加到购买列表
    table.insert(self.buyDatas,data)
    self.number.transform.localScale = Vector3.one
    self.numberText.text = #self.buyDatas
end
--删除购买列表
function BuildingShelfDetailPart:deleBuyList(id)
    --删除指定的数据
    if not id then
        return
    else
        table.remove(self.buyDatas,id)
        if next(self.buyDatas) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
            self.numberText.text = #self.buyDatas
        end
    end
end
--在货架时，开关值改变时是否发送消息
function BuildingShelfDetailPart:whetherSend(data)
    if data ~= nil then
        if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
            return
        end
        for key,value in pairs(self.m_data.shelf.good) do
            if value.k.id == data.itemId then
                if self.m_data.buildingType == BuildingType.MaterialFactory then
                    --原料场
                    Event.Brocast("m_ReqMaterialSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
                    --加工厂
                    Event.Brocast("m_ReqprocessingSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                elseif self.m_data.buildingType == BuildingType.RetailShop then
                    --零售店
                    Event.Brocast("m_ReqRetailStoresSetAutoReplenish",self.m_data.insId,data.itemId,data.producerId,data.qty,data.switch)
                elseif self.m_data.buildingType == BuildingType.TalentCenter then
                    --集散中心
                end
            end
        end
    end
end
--下架
function BuildingShelfDetailPart:downShelf(data)
    if data ~= nil then
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            --原料厂
            Event.Brocast("m_ReqMaterialShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            --加工厂
            Event.Brocast("m_ReqprocessingShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            --零售店
            Event.Brocast("m_ReqRetailStoresShelfDel",self.m_data.insId,data.itemId,data.number,data.producerId,data.qty)
        elseif self.m_data.buildingType == BuildingType.TalentCenter then
            --集散中心
        end
    end
end
--购买
function BuildingShelfDetailPart:startBuy(dataInfo,targetBuildingId)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --原料厂
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqMaterialBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --加工厂
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqprocessingBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.RetailShop then
        --零售店
        for key,value in pairs(dataInfo) do
            Event.Brocast("m_ReqRetailStoresBuyShelfGoods",self.m_data.insId,value.itemId,value.dataInfo.number,value.dataInfo.price,targetBuildingId,value.dataInfo.producerId,value.dataInfo.qty)
        end
    elseif self.m_data.buildingType == BuildingType.TalentCenter then
        --集散中心
    end
end
--刷新最新数据
function BuildingShelfDetailPart:refreshShelfDetailPart(dataInfo)
    self.m_data = dataInfo.info
    if next(self.shelfDatas) ~= nil then
        self:CloseDestroy(self.shelfDatas)
    end
    self:initializeUiInfoData(self.m_data.shelf.good)
end
-----------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------
--下架成功后
function BuildingShelfDetailPart:downShelfSucceed(data)
    if data ~= nil then
        --刷新货架
        for key,value in pairs(self.shelfDatas) do
            if value.itemId == data.item.key.id then
                if value.dataInfo.n == data.item.n then
                    self:deleteGoodsItem(self.shelfDatas,key)
                else
                    value.dataInfo.n = value.dataInfo.n - data.item.n
                    value.numberText.text = "×"..value.dataInfo.n
                end
            end
        end
        --刷新建筑货架信息
        for key,value in pairs(self.m_data.shelf.good) do
            if value.k.id == data.item.key.id then
                if value.n == data.item.n then
                    table.remove(self.m_data.shelf.good,key)
                else
                    value.n = value.n - data.item.n
                end
            end
        end
        --刷新建筑仓库信息
        if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
            local goods = {}
            local key = {}
            goods.key = key
            goods.key.id = data.item.key.id
            goods.key.producerId = data.item.key.producerId
            goods.key.qty = data.item.key.qty
            goods.n = data.item.n
            if not self.m_data.store.inHand then
                self.m_data.store.inHand = {}
            end
            self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goods
        else
            for key,value in pairs(self.m_data.store.inHand) do
                if value.key.id == data.item.key.id then
                    value.n = value.n + data.item.n
                    --下架成功后，如果货架是空的
                    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
                        self.noTip.transform.localScale = Vector3.one
                        self.ScrollView.transform.localScale = Vector3.zero
                    end
                    UIPanel.ClosePage()

                    return
                end
            end
            --如果没有在仓库找到这个商品
            self:wareHouseNoGoods(data)
        end
    end
    --下架成功后，如果货架是空的
    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
        self.noTip.transform.localScale = Vector3.one
        self.ScrollView.transform.localScale = Vector3.zero
    end
    UIPanel.ClosePage()
end
--购买成功
function BuildingShelfDetailPart:buySucceed(data)
    if data ~= nil then
        --刷新货架
        for key,value in pairs(self.shelfDatas) do
            if value.itemId == data.item.key.id then
                if value.dataInfo.n == data.item.n then
                    self:deleteGoodsItem(self.shelfDatas,key)
                else
                    value.dataInfo.n = value.dataInfo.n - data.item.n
                    value.numberText.text = "×"..value.dataInfo.n
                end
            end
        end
        --刷新建筑货架信息
        for key,value in pairs(self.m_data.shelf.good) do
            if value.k.id == data.item.key.id then
                if value.n == data.item.n then
                    table.remove(self.m_data.shelf.good,key)
                else
                    value.n = value.n - data.item.n
                end
            end
        end
    end
    --购买成功后，如果货架是空的
    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
        self.noTip.transform.localScale = Vector3.one
        self.addbg.transform.localScale = Vector3.zero
        self.ScrollView.transform.localScale = Vector3.zero
    end
    self.number.transform.localScale = Vector3.zero
    self.buyDatas = {}
    UIPanel.ClosePage()
end
--如果没有在仓库找到这个商品
function BuildingShelfDetailPart:wareHouseNoGoods(data)
    local goods = {}
    local key = {}
    goods.key = key
    goods.key.id = data.item.key.id
    goods.key.producerId = data.item.key.producerId
    goods.key.qty = data.item.key.qty
    goods.n = data.item.n
    self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goods
end










--ShelfCtrl = class('ShelfCtrl',BuildingBaseCtrl)
--UIPanel:ResgisterOpen(ShelfCtrl)--注册打开的方法
--
--local shelf
--local itemStateBool
--local switchRightPanel
--function ShelfCtrl:initialize()
--    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
--end
--function ShelfCtrl:bundleName()
--    return "Assets/CityGame/Resources/View/ShelfPanel.prefab"
--end
--function ShelfCtrl:OnCreate(obj)
--    UIPanel.OnCreate(self,obj)
--end
--function ShelfCtrl:Awake(go)
--    shelf = self.gameObject:GetComponent('LuaBehaviour')
--    shelf:AddClick(ShelfPanel.return_Btn,self.OnClick_return_Btn,self)
--    shelf:AddClick(ShelfPanel.buy_Btn,self.OnClick_playerBuy,self)
--    shelf:AddClick(ShelfPanel.closeBtn,self.OnClick_playerBuy,self)
--    shelf:AddClick(ShelfPanel.openBtn,self.OnClick_openBtn,self)
--    shelf:AddClick(ShelfPanel.addBtn,self.OnClick_addBtn, self)
--    shelf:AddClick(ShelfPanel.confirmBtn.gameObject,self.OnClcik_buyConfirmBtn,self)
--
--    itemStateBool = nil
--    switchRightPanel = false
--    self.tempItemList = {}  --选中的数据
--    self.recordIdList = {}  --记录选中的id
--    self.shelfDatas = {}  --货架上的数据
--end
--function ShelfCtrl:Active()
--    UIPanel.Active(self)
--    ShelfPanel.tipText.text = GetLanguage(26040002)
--    LoadSprite(GetSprite("Shelf"), ShelfPanel.shelfImg:GetComponent("Image"), false)
--    self:_addListener()
--    self:RefreshBuyButton()
--end
--function ShelfCtrl:_addListener()
--    Event.AddListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
--    Event.AddListener("OpenDetailsBox",self.OpenDetailsBox,self)
--end
--function ShelfCtrl:_removeListener()
--    Event.RemoveListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
--    Event.RemoveListener("OpenDetailsBox",self.OpenDetailsBox,self)
--end
--function ShelfCtrl:Refresh()
--    self.luabehaviour = shelf
--    self.shelf = self.m_data.shelf
--    self.isOther = self.m_data.isOther
--    self.buildingId = self.m_data.info.id
--    if self.isOther then
--        self:OthersInitializeData()
--    else
--        self:MeInitializeData()
--    end
--end
--function ShelfCtrl:Hide()
--    UIPanel.Hide(self)
--    self:_removeListener()
--    return {insId = self.m_data.info.id,self.m_data}
--end
------------------------------------------------------------------------初始化函数------------------------------------------------------------------------------------------
----自己
--function ShelfCtrl:MeInitializeData()
--    ShelfPanel.buy_Btn.transform.localScale = Vector3.zero;
--    ShelfPanel.shelfAddItem.gameObject:SetActive(true)
--    if next(self.shelfDatas) == nil then
--        self:CreateGoodsItems(self.shelf.good,ShelfPanel.ShelfGoodsItem,ShelfPanel.Content,ShelfGoodsItem,self.luabehaviour,self.shelfDatas,self.isOther,self.buildingId)
--    end
--    self.ShelfImgSetActive(self.shelfDatas,5,0)
--end
----别人
--function ShelfCtrl:OthersInitializeData()
--    ShelfPanel.buy_Btn.transform.localScale = Vector3.one;
--    ShelfPanel.shelfAddItem.gameObject:SetActive(false)
--    if next(self.shelfDatas) == nil then
--        self:CreateGoodsItems(self.shelf.good,ShelfPanel.ShelfGoodsItem,ShelfPanel.Content,ShelfGoodsItem,self.luabehaviour,self.shelfDatas,self.isOther,self.buildingId)
--    end
--    self.ShelfImgSetActive(self.shelfDatas,5,1)
--end
------------------------------------------------------------------------点击函数------------------------------------------------------------------------------------------
--function ShelfCtrl:OnClick_return_Btn(go)
--    PlayMusEff(1002)
--    if switchRightPanel == true then
--        go:openPlayerBuy(not switchRightPanel)
--    end
--    go:CloseDestroy(go.shelfDatas)
--    UIPanel.ClosePage()
--end
----点击打开购买Panel
--function ShelfCtrl:OnClick_playerBuy(go)
--    PlayMusEff(1002)
--    if go.m_data.info.state == "OPERATE" then
--        go:openPlayerBuy(not switchRightPanel)
--    else
--        Event.Brocast("SmallPop",GetLanguage(35040013),300)
--        return
--    end
--end
----跳转选择仓库
--function ShelfCtrl:OnClick_openBtn(go)
--    PlayMusEff(1002)
--    local data = {}
--    data.pos = {}
--    data.pos.x = go.m_data.info.pos.x
--    data.pos.y = go.m_data.info.pos.y
--    data.buildingId = go.buildingId
--    data.nameText = ShelfPanel.nameText
--    ct.OpenCtrl("ChooseWarehouseCtrl",data)
--end
----购买确认
--function ShelfCtrl:OnClcik_buyConfirmBtn(go)
--    PlayMusEff(1002)
--    local targetBuildingId = ChooseWarehouseCtrl:GetBuildingId()
--    local buyDataInfo = {}
--    buyDataInfo.currentLocationName = go.m_data.info.name
--    buyDataInfo.targetLocationName = ChooseWarehouseCtrl:GetName()
--    local pos = {}
--    pos.x = go.m_data.info.pos.x
--    pos.y = go.m_data.info.pos.y
--    buyDataInfo.distance = ChooseWarehouseCtrl:GetDistance(pos)
--    buyDataInfo.number = go.GetDataTableNum(go.tempItemList)
--    buyDataInfo.freight = GetClientPriceString(ChooseWarehouseCtrl:GetPrice())
--    buyDataInfo.goodsPrice = go:GetTotalPrice()
--    buyDataInfo.total = GetClientPriceString(buyDataInfo.number * GetServerPriceNumber(buyDataInfo.freight)) + buyDataInfo.goodsPrice
--    buyDataInfo.btnClick = function()
--        if buyDataInfo.number == 0 then
--            Event.Brocast("SmallPop",GetLanguage(27020004),300)
--            return
--        else
--            for key,value in pairs(go.tempItemList) do
--                Event.Brocast("m_ReqMaterialBuyShelfGoods",go.buildingId,value.itemId,value.inputNumber.text,
--                        value.goodsDataInfo.price,targetBuildingId,value.goodsDataInfo.k.producerId,value.goodsDataInfo.k.qty)
--            end
--        end
--    end
--    ct.OpenCtrl("TransportBoxCtrl",buyDataInfo)
--end
----打开仓库
--function ShelfCtrl:OnClick_addBtn(go)
--    PlayMusEff(1002)
--    go:CloseDestroy(go.shelfDatas)
--    go.m_data.isShelf = true
--    ct.OpenCtrl("WarehouseCtrl",go.m_data)
--end
------------------------------------------------------------------------回调函数-------------------------------------------------------------------------------------------
----刷新货架数据
--function ShelfCtrl:RefreshShelfData(dataInfo)
--    --如果货架调整框
--    if not dataInfo.wareHouseId then
--        --如果是调整价格
--        if dataInfo.price then
--            for key,value in pairs(self.shelfDatas) do
--                if value.itemId == dataInfo.item.key.id then
--                    value.moneyText.text = GetClientPriceString(dataInfo.price)
--                    value.price = dataInfo.price
--                end
--            end
--            Event.Brocast("SmallPop",GetLanguage(27010005),300)
--            return
--        end
--        --如果是调整数量
--        for key,value in pairs(self.shelfDatas) do
--            if value.itemId == dataInfo.item.key.id then
--                if value.num == dataInfo.item.n then
--                    self:deleteGoodsItem(self.shelfDatas,key)
--
--                    --下架后要把下架的商品数量添加到仓库
--                    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
--                        local inHand = {}
--                        local goodsData = {}
--                        local key = {}
--                        key.id = dataInfo.item.key.id
--                        goodsData.key = key
--                        goodsData.n = dataInfo.item.n
--                        inHand = goodsData
--                        self.m_data.store.inHand = {}
--                        self.m_data.store.inHand[#self.m_data.store.inHand + 1] = inHand
--                    else
--                        for key,value in pairs(self.m_data.store.inHand) do
--                            if value.key.id == dataInfo.item.key.id then
--                                value.n = value.n + dataInfo.item.n
--                            end
--                        end
--                    end
--                    for key1,value1 in pairs(self.m_data.shelf.good) do
--                        if value1.k.id == dataInfo.item.key.id then
--                            table.remove(self.m_data.shelf.good,key1)
--                        end
--                    end
--                    for key2,value2 in pairs(self.m_data.store.locked) do
--                        if value2.key.id == dataInfo.item.key.id then
--                            table.remove(self.m_data.store.locked,key2)
--                        end
--                    end
--                else
--                    value.numberText.text = value.num - dataInfo.item.n
--                    value.goodsDataInfo.n = tonumber(value.numberText.text)
--                    value.num = tonumber(value.numberText.text)
--
--                    --下架数量改变后，同时改变self.m_data数据
--                    --self:SetWarehouseDataInfo(dataInfo)
--                    ----下架数量改变后同时改变模拟服务器数据
--                    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
--                        local goodsData = {}
--                        local key = {}
--                        key.id = dataInfo.item.key.id
--                        goodsData.key = key
--                        goodsData.n = dataInfo.item.n
--                        if not self.m_data.store.inHand then
--                            self.m_data.store.inHand = {}
--                        end
--                        self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goodsData
--                    else
--                        for key,value in pairs(self.m_data.store.inHand) do
--                            if value.key.id == dataInfo.item.key.id then
--                                value.n = value.n + dataInfo.item.n
--                            end
--                        end
--                    end
--                    if not self.m_data.store.locked or next(self.m_data.store.locked) == nil then
--                        local goodsData = {}
--                        local key = {}
--                        key.id = dataInfo.item.key.id
--                        goodsData.key = key
--                        goodsData.n = dataInfo.item.n
--                        if not self.m_data.store.locked then
--                            self.m_data.store.locked = {}
--                        end
--                        self.m_data.store.locked[#self.m_data.store.locked + 1] = goodsData
--                    else
--                        for key1,value1 in pairs(self.m_data.store.locked) do
--                            if value1.key.id == dataInfo.item.key.id then
--                                value1.n = value1.n - dataInfo.item.n
--                            end
--                        end
--                    end
--                end
--            end
--        end
--        Event.Brocast("SmallPop",GetLanguage(27010003),300)
--    else
--        --如果是购买
--        for key,value in pairs(self.shelfDatas) do
--            if value.itemId == dataInfo.item.key.id then
--                if value.num == dataInfo.item.n then
--                    self:deleteGoodsItem(self.shelfDatas,key)
--                else
--                    value.numberText.text = value.num - dataInfo.item.n
--                    value.goodsDataInfo.n = tonumber(value.numberText.text)
--                    value.num = tonumber(value.numberText.text)
--                    local stateBool = true
--                    self:GoodsItemState(self.shelfDatas,stateBool)
--                end
--            end
--            self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
--        end
--        ShelfPanel.nameText.text = ""
--        self.ShelfImgSetActive(self.shelfDatas,5,1)
--        self:RefreshBuyButton()
--        Event.Brocast("SmallPop","购买成功"--[[GetLanguage(27010003)]],300)
--    end
--end
------------------------------------------------------------------------事件函数-------------------------------------------------------------------------------------------
----勾选商品
--function ShelfCtrl:SelectedGoodsItem(ins)
--    if self.recordIdList[ins.id] == nil then
--        self.recordIdList[ins.id] = ins.id
--        self:CreateGoodsDetails(ins.goodsDataInfo,ShelfPanel.BuyDetailsItem,ShelfPanel.buyContent,BuyDetailsItem,self.luabehaviour,ins.id,self.tempItemList)
--        self.shelfDatas[ins.id]:c_GoodsItemSelected()
--    else
--        self.shelfDatas[ins.id]:c_GoodsItemChoose()
--        self:DestoryGoodsDetailsList(self.tempItemList,self.recordIdList,ins.id)
--    end
--    self:RefreshBuyButton()
--end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----打开购买Panel
--function ShelfCtrl:openPlayerBuy(isShow)
--    if isShow then
--        itemStateBool = true
--        ShelfPanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
--        ShelfPanel.Content.offsetMax = Vector2.New(-740,0)
--        self.ShelfImgSetActive(self.shelfDatas,3,1)
--        self:GoodsItemState(self.shelfDatas,itemStateBool)
--        self:RefreshBuyButton()
--    else
--        itemStateBool = false
--        ShelfPanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
--        ShelfPanel.Content.offsetMax = Vector2.New(0,0)
--        self.ShelfImgSetActive(self.shelfDatas,5,1)
--        self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
--        self:GoodsItemState(self.shelfDatas,itemStateBool)
--        ShelfPanel.nameText.text = ""
--    end
--    switchRightPanel = isShow
--end
----刷新确认购买按钮
--function ShelfCtrl:RefreshBuyButton()
--    if next(self.tempItemList) == nil or ShelfPanel.nameText.text == "" then
--        ShelfPanel.uncheckBtn.transform.localScale = Vector3.one
--        ShelfPanel.confirmBtn.transform.localScale = Vector3.zero
--    elseif next(self.tempItemList) ~= nil and ShelfPanel.nameText.text ~= "" then
--        ShelfPanel.uncheckBtn.transform.localScale = Vector3.zero
--        ShelfPanel.confirmBtn.transform.localScale = Vector3.one
--    end
--end
----获取购买商品总价格
--function ShelfCtrl:GetTotalPrice()
--    local price = 0
--    for key,value in pairs(self.tempItemList) do
--        price = price + GetServerPriceNumber(value.tempPrice)
--    end
--    return GetClientPriceString(price)
--end
----货架点击Item详情弹框
--function ShelfCtrl:OpenDetailsBox(ins)
--    ins.buildingType = self.m_data.buildingType
--    ins.isOther = self.m_data.isOther
--    ct.OpenCtrl("DETAILSBoxCtrl",ins)
--end
----下架数量改变后，同时改变self.m_data数据
--function ShelfCtrl:SetWarehouseDataInfo(dataInfo)
--    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
--        local goodsData = {}
--        local key = {}
--        key.id = dataInfo.item.key.id
--        goodsData.key = key
--        goodsData.n = dataInfo.item.n
--        if not self.m_data.store.inHand then
--            self.m_data.store.inHand = {}
--        end
--        self.m_data.store.inHand[#self.m_data.store.inHand + 1] = goodsData
--    else
--        for key,value in pairs(self.m_data.store.inHand) do
--            if value.key.id == dataInfo.item.key.id then
--                value.n = value.n + dataInfo.item.n
--            end
--        end
--    end
--    if not self.m_data.store.locked or next(self.m_data.store.locked) == nil then
--        local goodsData = {}
--        local key = {}
--        key.id = dataInfo.item.key.id
--        goodsData.key = key
--        goodsData.n = dataInfo.item.n
--        if not self.m_data.store.locked then
--            self.m_data.store.locked = {}
--        end
--        self.m_data.store.locked[#self.m_data.store.locked + 1] = goodsData
--    else
--        for key1,value1 in pairs(self.m_data.store.locked) do
--            if value1.key.id == dataInfo.item.key.id then
--                value1.n = value1.n - dataInfo.item.n
--            end
--        end
--    end
--end
