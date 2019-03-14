WarehouseCtrl = class('WarehouseCtrl',BuildingBaseCtrl)
UIPanel:ResgisterOpen(WarehouseCtrl)--注册打开的方法

local warehouse
local switchRightPanel
local itemStateBool
local switchIsShow    --false 打开上架  true 打开运输
local itemNumber  --用来记录销毁的数量
ct.itemPrefab =
{
    shelfItem  = 0,  --上架
    transportItem = 1,  --运输
}
function WarehouseCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end
function WarehouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WarehousePanel.prefab"
end
function WarehouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end
function WarehouseCtrl:Awake(go)
    warehouse = self.gameObject:GetComponent('LuaBehaviour')
    warehouse:AddClick(WarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self)
    warehouse:AddClick(WarehousePanel.shelfBtn.gameObject,self.ClickRightShelfBtn,self)
    warehouse:AddClick(WarehousePanel.shelfCloseBtn.gameObject,self.ClickRightShelfBtn,self)
    warehouse:AddClick(WarehousePanel.transportBtn.gameObject,self.ClickRightTransportBtn,self)
    warehouse:AddClick(WarehousePanel.shelfConfirmBtn.gameObject,self.OnClick_shelfConfirmBtn,self)
    warehouse:AddClick(WarehousePanel.transportCloseBtn.gameObject,self.ClickRightTransportBtn,self)
    warehouse:AddClick(WarehousePanel.transportopenBtn.gameObject,self.OnClick_transportopenBtn,self)
    warehouse:AddClick(WarehousePanel.transportConfirmBtn.gameObject,self.OnClick_transportConfirmBtn,self)

    switchRightPanel = false
    itemStateBool = nil
    switchIsShow = nil
    self.tempItemList = {}  --选中的数据
    self.recordIdList = {}  --记录选中的id
    self.warehouseDatas = {}  --仓库数据
    self.loadItemPrefab = nil
end
function WarehouseCtrl:Active()
    UIPanel.Active(self)
    WarehousePanel.tipText.text = GetLanguage(26040002)
    LoadSprite(GetSprite("Warehouse"), WarehousePanel.warehouseImg:GetComponent("Image"), false)
    self:_addListener()
    self:RefreshConfirmButton()
end
function WarehouseCtrl:_addListener()
    Event.AddListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
    Event.AddListener("DestroyWarehouseItem",self.DestroyWarehouseItem,self)
    Event.AddListener("MaterialUpdateLatestData",self.UpdateLatestData,self)
end
function WarehouseCtrl:_removeListener()
    Event.RemoveListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
    Event.RemoveListener("DestroyWarehouseItem",self.DestroyWarehouseItem,self)
    Event.RemoveListener("MaterialUpdateLatestData",self.UpdateLatestData,self)
end
function WarehouseCtrl:Refresh()
    itemNumber = nil
    self.luabehaviour = warehouse
    self.store = self.m_data.store
    self.buildingId = self.m_data.info.id
    self:InitializeCapacity()
    if next(self.warehouseDatas) == nil then
        self:CreateGoodsItems(self.store.inHand,WarehousePanel.warehouseItem,WarehousePanel.Content,WarehouseItem,self.luabehaviour,self.warehouseDatas)
    end
    --如果是从货架进来的
    if self.m_data.isShelf == true then
        switchIsShow = false
        WarehousePanel.shelfCloseBtn.transform.localScale = Vector3.zero
        self:OpenRightPanel(not switchRightPanel,switchIsShow)
    end
end
function WarehouseCtrl:Hide()
    UIPanel.Hide(self)
    self:_removeListener()
    self.m_data.isShow = false
    return {insId = self.m_data.info.id,self.m_data}
end
----------------------------------------------------------------------初始化函数------------------------------------------------------------------------------------------
--初始化仓库容量
function WarehouseCtrl:InitializeCapacity()
    WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
    WarehousePanel.Warehouse_Slider.value = self:GetWarehouseNum(self.store)
    WarehousePanel.Locked_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
    WarehousePanel.Locked_Slider.value = self:GatWarehouseCapacity(self.store)
    self.lockedNum = self.GetLockedNum(self.store)
    local numTab = {}
    numTab["num1"] = WarehousePanel.Warehouse_Slider.value
    numTab["num2"] = self.lockedNum
    numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
    numTab["col1"] = "Cyan"
    numTab["col2"] = "Teal"
    numTab["col3"] = "white"
    WarehousePanel.numberText.text = getColorString(numTab)
end
----------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------------
--点击打开上架Panel
function WarehouseCtrl:ClickRightShelfBtn(ins)
    PlayMusEff(1002)
    switchIsShow = false
    WarehousePanel.shelfCloseBtn.transform.localScale = Vector3.one
    ins:OpenRightPanel(not switchRightPanel,switchIsShow)
end
--点击打开运输Panel
function WarehouseCtrl:ClickRightTransportBtn(ins)
    PlayMusEff(1002)
    switchIsShow = true
    ins:OpenRightPanel(not switchRightPanel,switchIsShow)
end
--跳转选择仓库
function WarehouseCtrl:OnClick_transportopenBtn(ins)
    PlayMusEff(1002)
    local data = {}
    data.pos = {}
    data.pos.x = ins.m_data.info.pos.x
    data.pos.y = ins.m_data.info.pos.y
    data.buildingId = ins.buildingId
    data.nameText = WarehousePanel.nameText
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--上架确认
function WarehouseCtrl:OnClick_shelfConfirmBtn(ins)
    PlayMusEff(1002)
    local noMatch = {}
    for key1,value1 in pairs(ins.tempItemList) do
        --如果架子上是空的
        if not ins.m_data.shelf.good then
            if ins:WhetherValidShelfOp(value1) == true then
                Event.Brocast("m_ReqMaterialShelfAdd",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
            else
                noMatch[#noMatch + 1] = value1.itemId
            end
        else
            --如果架子上不是空的，先检查架子上有没有这个商品
            if ins:ShelfWhetherHave(ins.m_data.shelf.good,value1) == true then
                --如果有这个东西，需要发送两个协议，修改和上架
                if ins:WhetherValidShelfOp(value1) == true then
                    --修改协议
                    Event.Brocast("m_ReqMaterialModifyShelf",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
                    --上架协议
                    Event.Brocast("m_ReqMaterialShelfAdd",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
                else
                    noMatch[#noMatch + 1] = value1.itemId
                end
            else
                if ins:WhetherValidShelfOp(value1) == true then
                    --发送上架协议
                    Event.Brocast("m_ReqMaterialShelfAdd",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
                else
                    noMatch[#noMatch + 1] = value1.itemId
                end
            end
        end
    end
    --后边要改成如果上架的商品中有一个不匹配的，则全部都不能上架
    if next(noMatch) ~= nil then
        --打印上架不成功的itemId
        local noMatchStr = GetLanguage(noMatch[1])
        for i = 2, #noMatch do
            noMatchStr = noMatchStr..","..GetLanguage(noMatch[i])
        end
        Event.Brocast("SmallPop",noMatchStr,400)
    end
end
--运输确认
function WarehouseCtrl:OnClick_transportConfirmBtn(ins)
    PlayMusEff(1002)
    local targetBuildingId = ChooseWarehouseCtrl:GetBuildingId()
    local transportDatasInfo = {}
    transportDatasInfo.currentLocationName = ins.m_data.info.name
    transportDatasInfo.targetLocationName = ChooseWarehouseCtrl:GetName()
    local pos = {}
    pos.x = ins.m_data.info.pos.x
    pos.y = ins.m_data.info.pos.y
    transportDatasInfo.distance = ChooseWarehouseCtrl:GetDistance(pos)
    transportDatasInfo.number = ins.GetDataTableNum(ins.tempItemList)
    transportDatasInfo.freight = GetClientPriceString(ChooseWarehouseCtrl:GetPrice())
    transportDatasInfo.total = GetClientPriceString(transportDatasInfo.number * GetServerPriceNumber(transportDatasInfo.freight))
    transportDatasInfo.btnClick = function ()
        if transportDatasInfo.number == 0 then
            Event.Brocast("SmallPop",GetLanguage(27020004),300)
            return
        else
            for key,value in pairs(ins.tempItemList) do
                Event.Brocast("m_MaterialTransport",ins.buildingId,targetBuildingId,value.itemId,value.inputNumber.text,value.goodsDataInfo.key.producerId,value.goodsDataInfo.key.qty)
            end
        end
    end
    ct.OpenCtrl("TransportBoxCtrl",transportDatasInfo)
end
--退出仓库
function WarehouseCtrl:OnClick_returnBtn(ins)
    PlayMusEff(1002)
    if switchIsShow ~= nil then
        ins:OpenRightPanel(not switchRightPanel,switchIsShow)
    end
    ins:CloseDestroy(ins.warehouseDatas)
    UIPanel.ClosePage()
end
----------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------------
--上架或运输刷新仓库数据
function WarehouseCtrl:RefreshWarehouseData(dataInfo,whether)
    for key,value in pairs(self.warehouseDatas) do
        if value.itemId == dataInfo.item.key.id then
            if value.n == dataInfo.item.n then
                self:deleteGoodsItem(self.warehouseDatas,key)
            else
                value.numberText.text = value.n - dataInfo.item.n
                value.goodsDataInfo.n = tonumber(value.numberText.text)
                value.n = tonumber(value.numberText.text)
                local stateBool = true
                self:GoodsItemState(self.warehouseDatas,stateBool)--数量减少后刷新商品的状态为可以勾选
            end
            self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
            self:RefreshCapacity(dataInfo,whether)
        end
    end
    WarehousePanel.nameText.text = ""
    self:RefreshConfirmButton()
    if whether == true then
        Event.Brocast("SmallPop",GetLanguage(26040010),300)
    else
        Event.Brocast("SmallPop",GetLanguage(27020002),300)
        --如果上架成功，模拟服务器数据放到货架
        if not self.m_data.store.locked or next(self.m_data.store.locked) == nil then
            local locked = {}
            local goodData = {}
            local key = {}
            key.id = dataInfo.item.key.id
            goodData.key = key
            goodData.n = dataInfo.item.n
            locked[#locked + 1] = goodData
            self.m_data.store.locked = locked
        else
            for key1,value1 in pairs(self.m_data.store.locked) do
                if value1.key.id == dataInfo.item.key.id then
                    value1.n = value1.n + dataInfo.item.n
                end
            end
            for key2,value2 in pairs(self.m_data.shelf.good) do
                if value2.k.id == dataInfo.item.key.id then
                    value2.n = value2.n + dataInfo.item.n
                end
            end
        end
        --上架成功后模拟服务器数据改变m_data
        for key,value in pairs(self.m_data.store.inHand) do
            if value.key.id == dataInfo.item.key.id then
                if value.n == dataInfo.item.n then
                    table.remove(self.m_data.store.inHand,key)
                end
            end
        end
    end
    --如果货架上没有东西改变货架m_data
    if self.m_data.isShelf == true then
        self:SetShelfData(dataInfo)
    end
end
--销毁仓库原料或商品刷新
function WarehouseCtrl:DestroyAfterRefresh(dataInfo)
    for key,value in pairs(self.warehouseDatas) do
        if value.itemId == dataInfo.item.id then
            self:deleteGoodsItem(self.warehouseDatas,key)
        end
    end
    local numTab = {}
    numTab["num1"] = WarehousePanel.Warehouse_Slider.value - itemNumber
    numTab["num2"] = self.lockedNum
    numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
    numTab["col1"] = "Cyan"
    numTab["col2"] = "Teal"
    numTab["col3"] = "white"
    WarehousePanel.numberText.text = getColorString(numTab)
    itemNumber = nil
    Event.Brocast("SmallPop",GetLanguage(26030003),300)
end
----------------------------------------------------------------------事件函数--------------------------------------------------------------------------------------------
--勾选商品
function WarehouseCtrl:SelectedGoodsItem(ins)
    if self.recordIdList[ins.id] == nil then
        self.recordIdList[ins.id] = ins.id
        if self.loadItemPrefab == ct.itemPrefab.shelfItem then
            self:CreateGoodsDetails(ins.goodsDataInfo,WarehousePanel.DetailsItem,WarehousePanel.shelfContent,DetailsItem,self.luabehaviour,ins.id,self.tempItemList)
        elseif self.loadItemPrefab == ct.itemPrefab.transportItem then
            self:CreateGoodsDetails(ins.goodsDataInfo,WarehousePanel.TransportItem,WarehousePanel.transportContent,TransportItem,self.luabehaviour,ins.id,self.tempItemList)
        end
        self.warehouseDatas[ins.id]:c_GoodsItemSelected()
    else
        self.warehouseDatas[ins.id]:c_GoodsItemChoose()
        self:DestoryGoodsDetailsList(self.tempItemList,self.recordIdList,ins.id)
    end
    self:RefreshConfirmButton()
end
--销毁仓库原料或商品
function WarehouseCtrl:DestroyWarehouseItem(ins)
    itemNumber = ins.n
    local data = {}
    data.titleInfo = GetLanguage(30030001)
    data.contentInfo = GetLanguage(35030004)
    data.tipInfo = GetLanguage(30030002)
    data.btnCallBack = function()
        Event.Brocast("m_ReqMaterialDelItem",self.buildingId,ins.itemId,ins.producerId,ins.qty)
    end
    ct.OpenCtrl('ErrorBtnDialogPageCtrl',data)
end
--生产中刷新仓库数据
function WarehouseCtrl:UpdateLatestData(dataInfo)
    self:InitializeCapacity()
    if self.warehouseDatas then
        for key,value in pairs(self.warehouseDatas) do
            if dataInfo.itemId == value.itemId then
                value.n = dataInfo.nowCountStore
                value.numberText.text = dataInfo.nowCountStore
                value.goodsDataInfo.n = dataInfo.nowCountStore
                return
            end
        end
    end
    local inHand = {}
    local key = {}
    key.id = dataInfo.itemId
    inHand.key = key
    inHand.n = dataInfo.nowCountStore
    self:RefreshCreateItem(inHand,WarehousePanel.warehouseItem,WarehousePanel.Content,WarehouseItem,self.luabehaviour,self.warehouseDatas)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--打开上架或运输Panel
function WarehouseCtrl:OpenRightPanel(isShow,switchShow)
    if isShow then
        itemStateBool = true
        WarehousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
        WarehousePanel.Content.offsetMax = Vector2.New(-810,0)
        if switchShow == false then
            WarehousePanel.shelf:SetActive(true)
            self.loadItemPrefab = ct.itemPrefab.shelfItem
        else
            WarehousePanel.transport:SetActive(true)
            self.loadItemPrefab = ct.itemPrefab.transportItem
        end
        switchIsShow = switchShow
        self:GoodsItemState(self.warehouseDatas,itemStateBool)
        self:RefreshConfirmButton()
    else
        itemStateBool = false
        if switchShow == false then
            WarehousePanel.shelf:SetActive(false)
            self.loadItemPrefab = nil
        else
            WarehousePanel.transport:SetActive(false)
            self.loadItemPrefab = nil
            WarehousePanel.nameText.text = ""
        end
        WarehousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
        WarehousePanel.Content.offsetMax = Vector2.New(0,0)
        self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
        self:GoodsItemState(self.warehouseDatas,itemStateBool)
        switchIsShow = nil
    end
    switchRightPanel = isShow
end
--刷新确认上架或确认运输的按钮
function WarehouseCtrl:RefreshConfirmButton()
    if switchIsShow == false then
        if next(self.tempItemList) == nil then
            WarehousePanel.shelfUncheckBtn.transform.localScale = Vector3.one
            WarehousePanel.shelfConfirmBtn.transform.localScale = Vector3.zero
        else
            WarehousePanel.shelfUncheckBtn.transform.localScale = Vector3.zero
            WarehousePanel.shelfConfirmBtn.transform.localScale = Vector3.one
        end
    else
        if next(self.tempItemList) == nil or WarehousePanel.nameText.text == "" then
            WarehousePanel.transportUncheckBtn.transform.localScale = Vector3.one
            WarehousePanel.transportConfirmBtn.transform.localScale = Vector3.zero
        elseif next(self.tempItemList) ~= nil and WarehousePanel.nameText.text ~= "" then
            WarehousePanel.transportUncheckBtn.transform.localScale = Vector3.zero
            WarehousePanel.transportConfirmBtn.transform.localScale = Vector3.one
        end
    end
end
--检查上架商品是否匹配，是否输入数量和价格  --原料厂，零售店判断mId不同
function WarehouseCtrl:WhetherValidShelfOp(ins)
    local materialKey = 21              --可以上架的商品类型
    if GetServerPriceNumber(ins.inputPrice.text) == 0 then
        Event.Brocast("SmallPop","价格不能为0"--[[GetLanguage(26020004)]],300)
        return false
    end
    if ins.inputNumber.text == "0" or ins.inputNumber.text == "" then
        Event.Brocast("SmallPop","数量不能为0"--[[GetLanguage(26020004)]],300)
        return false
    end
    if math.floor(ins.itemId / 100000) ~= materialKey then
        return false
    end

    return true
end
--检查架子上是否有这个商品
function WarehouseCtrl:ShelfWhetherHave(table,value1)
    for key,value in pairs(table) do
        if value.k.id == value1.itemId then
            return true
        end
    end
    return false
end
--刷新仓库容量  --true 运输   --false 上架
function WarehouseCtrl:RefreshCapacity(dataInfo,whether)
    if whether == true then
        WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - dataInfo.item.n
        WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - dataInfo.item.n
        self.lockedNum = self.GetLockedNum(self.m_data.store)
        local numTab = {}
        numTab["num1"] = WarehousePanel.Warehouse_Slider.value
        numTab["num2"] = self.lockedNum
        numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
        numTab["col1"] = "Cyan"
        numTab["col2"] = "Teal"
        numTab["col3"] = "white"
        WarehousePanel.numberText.text = getColorString(numTab)
    else
        WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - dataInfo.item.n
        WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value + dataInfo.item.n
        self.lockedNum = self.lockedNum + dataInfo.item.n
        local numTab = {}
        numTab["num1"] = WarehousePanel.Warehouse_Slider.value
        numTab["num2"] = self.lockedNum
        numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
        numTab["col1"] = "Cyan"
        numTab["col2"] = "Teal"
        numTab["col3"] = "white"
        WarehousePanel.numberText.text = getColorString(numTab)
    end
end
--如果是从货架上架要改变self.m_data数据返回
function WarehouseCtrl:SetShelfData(dataInfo)
    local good = {}
    local goodData = {}
    local key = {}
    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
        key.id = dataInfo.item.key.id
        goodData.k = key
        goodData.n = dataInfo.item.n
        goodData.price = dataInfo.price
        good[#good + 1] = goodData
        self.m_data.shelf.good = good
    end
end


--[[
WarehouseCtrl = class('WarehouseCtrl',BuildingBaseCtrl);
UIPanel:ResgisterOpen(WarehouseCtrl) --注册打开的方法

--物品上架还是运输
ct.goodsState =
{
    shelf  = 0,  --上架
    transport = 1,  --运输
}
ct.sortingItemType = {
    Name = 1,      --名字
    Quantity = 2,  --数量
    Level = 3,     --评分
    Score = 4,     --等级
    Price = 5      --价格
}
--存放选中的物品,临时表
WarehouseCtrl.temporaryItems = {}
local isShowList;
local switchIsShow;
local warehouse

function WarehouseCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function WarehouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WarehousePanel.prefab";
end

function WarehouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end
function WarehouseCtrl:Awake(go)
    warehouse = self.gameObject:GetComponent('LuaBehaviour');
    warehouse:AddClick(WarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    warehouse:AddClick(WarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    warehouse:AddClick(WarehousePanel.nameBtn.gameObject,self.OnClick_OnName,self);
    warehouse:AddClick(WarehousePanel.quantityBtn.gameObject,self.OnClick_OnNumber,self);
    warehouse:AddClick(WarehousePanel.shelfBtn.gameObject,self.OnClick_shelfBtn,self);
    warehouse:AddClick(WarehousePanel.shelfCloseBtn.gameObject,self.OnClick_shelfBtn,self)
    warehouse:AddClick(WarehousePanel.transportBtn.gameObject,self.OnClick_transportBtn,self);
    warehouse:AddClick(WarehousePanel.transportCloseBtn.gameObject,self.OnClick_transportBtn,self);
    warehouse:AddClick(WarehousePanel.transportopenBtn.gameObject,self.OnClick_transportopenBtn,self);
    warehouse:AddClick(WarehousePanel.transportConfirmBtn.gameObject,self.OnClick_transportConfirmBtn,self);
    --warehouse:AddClick(WarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self)
    warehouse:AddClick(WarehousePanel.shelfConfirmBtn.gameObject,self.OnClick_shelfConfirmBtn,self);

    --暂时放到Awake
    Event.AddListener("c_temporaryifNotGoods",self.c_temporaryifNotGoods, self)

    --WarehousePanel.nameText.text = GetLanguage(26040002)

    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
    --初始化物品上架还是运输
    self.operation = nil;
end
function WarehouseCtrl:Active()
    UIPanel.Active(self)
    LoadSprite(GetSprite("Warehouse"), WarehousePanel.warehouseImg:GetComponent("Image"), false)
    WarehousePanel.tipText.text = GetLanguage(26040002)

    Event.AddListener("n_shelfAdd",self.n_shelfAdd,self)
    Event.AddListener("n_transports",self.n_transports,self)
    Event.AddListener("c_warehouseClick",self._selectedGoods, self)
    Event.AddListener("deleteObjeCallback",self.deleteObjeCallback,self)
    Event.AddListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
end
function WarehouseCtrl:Refresh()
    self.luabehaviour = warehouse
    self.store = self.m_data.store
    self.store.type = BuildingInType.Warehouse
    self.store.buildingId = self.m_data.info.id
    WarehouseCtrl.playerId = self.m_data.info.id
    self.mId = self.m_data.info.mId
    self.warehouseTotalNum = WarehouseCtrl:getWarehouseCapacity(self.m_data.store);
    self.warehouseNum = WarehouseCtrl:getWarehouseNum(self.m_data.store);
    self.lockedNum = WarehouseCtrl:getLockedNum(self.m_data.store)
    WarehousePanel.Locked_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity;
    WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity;
    WarehousePanel.Locked_Slider.value = self.warehouseTotalNum
    WarehousePanel.Warehouse_Slider.value = self.warehouseNum;
    local numTab = {}
    numTab["num1"] = self.warehouseNum
    numTab["num2"] = WarehousePanel.Locked_Slider.maxValue
    numTab["num3"] = self.lockedNum
    numTab["col1"] = "Cyan"
    numTab["col2"] = "white"
    numTab["col3"] = "Teal"
    WarehousePanel.numberText.text = getColorString(numTab);
    self:isShowDetermineBtn()
    if WarehousePanel.Content.childCount <= 0 then
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.store)
    else
        return
    end
    if self.m_data.shelfOpen ~= nil then
        self:OnClick_rightInfo(not switchIsShow,0)
    end
end
function WarehouseCtrl:OnClick_returnBtn(go)
    go:deleteObjInfo()
    PlayMusEff(1002)
    UIPanel.ClosePage()
    if switchIsShow then
        go:OnClick_rightInfo(not switchIsShow,1)
    end
end
function WarehouseCtrl:Hide()
    Event.RemoveListener("n_shelfAdd",self.n_shelfAdd,self)
    Event.RemoveListener("n_transports",self.n_transports,self)
    Event.RemoveListener("c_warehouseClick",self._selectedGoods, self)
    --Event.RemoveListener("c_temporaryifNotGoods",self.c_temporaryifNotGoods, self)
    Event.RemoveListener("deleteObjeCallback",self.deleteObjeCallback,self)
    Event.RemoveListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
    UIPanel.Hide(self)
    return {insId = self.m_data.info.id,self.m_data}
end
----搜索
--function WarehouseCtrl:OnClick_searchBtn(ins)
--
--end
--选中物品
function WarehouseCtrl:_selectedGoods(insData)
    if self.temporaryItems[insData.id] == nil then
        self.temporaryItems[insData.id] = insData.id
        if self.operation == ct.goodsState.shelf then
            self.GoodsUnifyMgr:_creatShelfGoods(insData,self.luabehaviour)
        elseif self.operation == ct.goodsState.transport then
            self.GoodsUnifyMgr:_creatTransportGoods(insData,self.luabehaviour)
            self:isShowDetermineBtn()
        end
        self.GoodsUnifyMgr.warehouseLuaTab[insData.id].circleTickImg.transform.localScale = Vector3.one
    else
        self.temporaryItems[insData.id] = nil;
        self.GoodsUnifyMgr.warehouseLuaTab[insData.id].circleTickImg.transform.localScale = Vector3.zero
        if self.operation == ct.goodsState.shelf then
            self.GoodsUnifyMgr:_deleteShelfItem(insData.id);
        elseif self.operation == ct.goodsState.transport then
            self.GoodsUnifyMgr:_deleteTransportItem(insData.id);
            self:isShowDetermineBtn()
        end
    end
end
--临时表里是否有这个物品
function WarehouseCtrl:c_temporaryifNotGoods(id)
    self.temporaryItems[id] = nil
    self.GoodsUnifyMgr.warehouseLuaTab[id].circleTickImg.transform.localScale = Vector3.zero
    if self.operation == ct.goodsState.shelf then
        self.GoodsUnifyMgr:_deleteShelfItem(id);
    elseif self.operation == ct.goodsState.transport then
        self.GoodsUnifyMgr:_deleteTransportItem(id);
        self:isShowDetermineBtn()
    end
end
--获取仓库总数量
function WarehouseCtrl:getWarehouseCapacity(table)
    local warehouseCapacity = 0  --仓库总容量
    local locked = 0             --仓库里锁着的
    if not table.inHand then
        warehouseCapacity = warehouseCapacity + locked
        return warehouseCapacity;
    else
        for k,v in pairs(table.inHand) do
            warehouseCapacity = warehouseCapacity + v.n
        end
        if not table.locked then
            locked = 0
        else
            for i,t in pairs(table.locked) do
                locked = locked + t.n
            end
        end
        warehouseCapacity = warehouseCapacity + locked
        return warehouseCapacity
    end
end
--获取仓库数量
function WarehouseCtrl:getWarehouseNum(table)
    local warehouseNum = 0
    if not table.inHand then
        return warehouseNum
    else
        for i,v in pairs(table.inHand) do
            warehouseNum = warehouseNum + v.n
        end
        return warehouseNum
    end
end
--获取锁着的数量
function WarehouseCtrl:getLockedNum(table)
    local lockedNum = 0
    if not table.inHand then
        return lockedNum
    end
    if not table.locked then
        return lockedNum
    end
    for i,v in pairs(table.locked) do
        lockedNum = lockedNum + v.n
    end
    return lockedNum
end

--Open shelf
function WarehouseCtrl:OnClick_shelfBtn(go)
    PlayMusEff(1002)
    if go.m_data.info.state == "OPERATE" then
        go:OnClick_rightInfo(not switchIsShow,0)
    else
        Event.Brocast("SmallPop",GetLanguage(35040013),300)
    end
end
--Open transpor
function WarehouseCtrl:OnClick_transportBtn(go)
    PlayMusEff(1002)
    if go.m_data.info.state == "OPERATE" then
        go:OnClick_rightInfo(not switchIsShow,1)
    else
        Event.Brocast("SmallPop",GetLanguage(35040013),300)
    end
end
--名字排序
function WarehouseCtrl:OnClick_OnName(ins)
    PlayMusEff(1002)
    WarehousePanel.nowText.text = "By name";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
    local nameType = ct.sortingItemType.Name
    WarehouseCtrl:_getSortItems(nameType,ins.GoodsUnifyMgr.WarehouseItems)
end
--数量排序
function WarehouseCtrl:OnClick_OnNumber(ins)
    PlayMusEff(1002)
    WarehousePanel.nowText.text = "By quantity";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
    local quantityType = ct.sortingItemType.Quantity
    WarehouseCtrl:_getSortItems(quantityType,ins.GoodsUnifyMgr.WarehouseItems)
end
--跳转选择仓库界面
function WarehouseCtrl:OnClick_transportopenBtn(go)
    --go:deleteObjInfo()
    PlayMusEff(1002)
    local data = {}
    data.pos = {}
    data.pos.x = go.m_data.info.pos.x
    data.pos.y = go.m_data.info.pos.y
    data.nameText = WarehousePanel.nameText
    data.buildingId = go.m_data.info.id
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--确定上架
function WarehouseCtrl.isValidShelfOp(go, v)
    local materialKey,goodsKey = 21,22 --道具类型
    local material,processing,retailStores = 11,12,13--建筑类型
    if GetServerPriceNumber(v.inputPrice.text) == 0 then
        return false
    end
    if v.inputNumber.text == "0" and v.inputNumber.text == "" then
        return false
    end
    if math.floor(go.mId / 100000) == material then
        if math.floor(v.itemId / 100000) ~= materialKey then
            return false
        end
    end
    if math.floor(go.mId / 100000) == processing then
        if math.floor(v.itemId / 100000) ~= goodsKey then
            return false
        end
    end
    if math.floor(go.mId / 100000) == retailStores then
        if math.floor(v.itemId / 100000) ~= goodsKey then
            return false
        end
    end
    return true
end
function WarehouseCtrl:OnClick_shelfConfirmBtn(go)
    PlayMusEff(1002)
    local noMatch ={}
    if not go.GoodsUnifyMgr.shelfPanelItem then
        return;
    else
        --shelfPanelItem 将要上架的道具列表
        for i,v in pairs(go.GoodsUnifyMgr.shelfPanelItem) do
            --local isvalidOp = true
            if not go.m_data.shelf.good then --未上架
                if WarehouseCtrl.isValidShelfOp(go,v) == true then
                    Event.Brocast("m_ReqShelfAdd",go.m_data.info.id,v.itemId,v.inputNumber.text,GetServerPriceNumber(v.inputPrice.text),v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                else
                    noMatch[#noMatch+1] = v
                end
            else
                --已上架
                for k,t in pairs(go.m_data.shelf.good) do
                    if v.itemId == t.k.id then
                        if WarehouseCtrl.isValidShelfOp(go,v) == true then
                            Event.Brocast("m_ReqModifyShelf",go.m_data.info.id,v.itemId,v.inputNumber.text,GetServerPriceNumber(v.inputPrice.text),v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                        else
                            noMatch[#noMatch+1] = v
                        end
                    end
                end
                if WarehouseCtrl.isValidShelfOp(go,v) == true then
                    Event.Brocast("m_ReqShelfAdd",go.m_data.info.id,v.itemId,v.inputNumber.text,GetServerPriceNumber(v.inputPrice.text),v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                else
                    noMatch[#noMatch+1] = v
                end
            end
        end
    end
    if #noMatch > 0 then
        local noMatchstr = ','
        for i, v in pairs(noMatch) do
            noMatchstr = v.itemId..","..noMatchstr
        end
        local itemIdStr = split(noMatchstr,",")
        local itemId = tonumber(itemIdStr[1])
        Event.Brocast("SmallPop",GetLanguage(itemId)..GetLanguage(26020004),300)
    end
end
--上架回调执行
function WarehouseCtrl:n_shelfAdd(msg)
    if not msg then
        return;
    end
    local Data = self.GoodsUnifyMgr.warehouseLuaTab
    for i,v in pairs(Data) do
        if v.itemId == msg.item.key.id then
            if v.n == msg.item.n then
                self.GoodsUnifyMgr:_WarehousedeleteGoods(i)
                for i,v in pairs(WarehouseCtrl.temporaryItems) do
                    self.GoodsUnifyMgr:_deleteShelfItem(v)
                    self:isShowDetermineBtn()
                end
            else
                v.numberText.text = v.goodsDataInfo.n - msg.item.n;
                v.goodsDataInfo.n = tonumber(v.numberText.text)
                for i in pairs(WarehouseCtrl.temporaryItems) do
                    Event.Brocast("c_temporaryifNotGoods", i)
                end
            end
        end
    end
    if msg.item.key.producerId == nil and msg.item.key.qty == nil then
        if not self.m_data.shelf.good then
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good[#good + 1] = data
            self.m_data.shelf.good = good
        else
            for i,v in pairs(self.m_data.shelf.good) do
                if v.k.id == msg.item.key.id then
                    v.n = v.n + msg.item.n
                    v.price = msg.price
                    return
                end
            end
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good = data
            self.m_data.shelf.good[#self.m_data.shelf.good + 1] = good
        end
    else
        if not self.m_data.shelf.good then
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            k.producerId = msg.item.key.producerId
            k.qty = msg.item.key.qty
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good[#good + 1] = data
            self.m_data.shelf.good = good
        else
            for i,v in pairs(self.m_data.shelf.good) do
                if v.k.id == msg.item.key.id then
                    v.n = v.n + msg.item.n
                    v.price = msg.price
                    return
                end
            end
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good = data
            self.m_data.shelf.good[#self.m_data.shelf.good + 1] = good
        end
    end
end
--确定运输
function WarehouseCtrl:OnClick_transportConfirmBtn(go)
    PlayMusEff(1002)
    if not GoodsUnifyMgr.transportPanelItem then
        return;
    end
    local btransportListing = {}
    btransportListing.currentLocationName = go.m_data.info.name..GetLanguage(21030008)
    btransportListing.targetLocationName = ChooseWarehouseCtrl:GetName()..GetLanguage(21030008)
    local pos = {}
    pos.x = go.m_data.info.pos.x
    pos.y = go.m_data.info.pos.y
    btransportListing.distance = ChooseWarehouseCtrl:GetDistance(pos)
    local number = 0
    for i,v in pairs(GoodsUnifyMgr.transportPanelItem) do
        number = number + v.numberScrollbar.value
    end
    btransportListing.number = number
    btransportListing.price = ChooseWarehouseCtrl:GetPrice()
    btransportListing.freight = GetClientPriceString(number * btransportListing.price)
    btransportListing.total = GetClientPriceString(number * btransportListing.price)
    btransportListing.capacity = ChooseWarehouseCtrl:GetCapacity()
    if number > btransportListing.capacity then
        Event.Brocast("SmallPop",GetLanguage(26040012),300)
        return
    end
    btransportListing.btnClick = function ()
        if number == 0 then
            Event.Brocast("SmallPop",GetLanguage(27020004),300)
            return
        else
            for i,v in pairs(GoodsUnifyMgr.transportPanelItem) do
                Event.Brocast("c_Transport",go.m_data.info.id,v.itemId,v.inputNumber.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
            end
        end
    end
    ct.OpenCtrl("TransportBoxCtrl",btransportListing);
end
--运输回调执行
function WarehouseCtrl:n_transports(Data)
    local table = self.GoodsUnifyMgr.warehouseLuaTab
    for i,v in pairs(table) do
        if v.itemId == Data.item.key.id then
            if v.goodsDataInfo.n == Data.item.n then
                self.GoodsUnifyMgr:_WarehousedeleteGoods(i)
                for i,v in pairs(WarehouseCtrl.temporaryItems) do
                   self.GoodsUnifyMgr:_deleteTransportItem(v)
                   self:isShowDetermineBtn()
                end
            else
                v.numberText.text = v.goodsDataInfo.n - Data.item.n;
                v.goodsDataInfo.n = tonumber(v.numberText.text)
                for i in pairs(WarehouseCtrl.temporaryItems) do
                    Event.Brocast("c_temporaryifNotGoods", i)
                end
            end
            WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - Data.item.n;
            local lockedNum = WarehouseCtrl:getLockedNum(self.m_data.store)
            local numTab = {}
            numTab["num1"] = WarehousePanel.Locked_Slider.value
            numTab["num2"] = WarehousePanel.Locked_Slider.maxValue
            numTab["num3"] = lockedNum
            numTab["col1"] = "Cyan"
            numTab["col2"] = "white"
            numTab["col3"] = "Teal"
            WarehousePanel.numberText.text = getColorString(numTab)
        end
    end
end
--点击删除物品
function WarehouseCtrl:deleteWarehouseItem(ins)
    local data = {}
    data.titleInfo = GetLanguage(30030001)
    data.contentInfo = GetLanguage(35030004)
    data.tipInfo = GetLanguage(30030002)
    data.btnCallBack = function ()
        local dataId = {}
        dataId.buildingId = self.m_data.insId
        dataId.id = ins.itemId
        Event.Brocast("mReqDelItem",ins.buildingId,ins.itemId,ins.producerId,ins.qty)
    end
    ct.OpenCtrl('ErrorBtnDialogPageCtrl',data)
end
--删除仓库物品回调
function WarehouseCtrl:deleteObjeCallback(msg)
    if not msg then
        return
    end
    for i,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
        if msg.item.id == v.itemId then
            v:closeEvent()
            WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - v.n
            WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - v.n
            local numTab = {}
            numTab["num1"] = WarehousePanel.Warehouse_Slider.value
            numTab["num2"] = WarehousePanel.Locked_Slider.maxValue
            numTab["num3"] = self.lockedNum
            numTab["col1"] = "Cyan"
            numTab["col2"] = "white"
            numTab["col3"] = "Teal"
            WarehousePanel.numberText.text = getColorString(numTab);
            destroy(v.prefab.gameObject);
            table.remove(self.GoodsUnifyMgr.warehouseLuaTab,i);
            Event.Brocast("SmallPop",GetLanguage(30030003),300)
        end
    end
    local i = 1
    for k,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
        self.GoodsUnifyMgr.warehouseLuaTab[i]:RefreshID(i)
        i = i + 1
    end
end
--刷新运输确定按钮
function WarehouseCtrl:isShowDetermineBtn()
    if not self.GoodsUnifyMgr then
        return
    end
    if not self.GoodsUnifyMgr.transportPanelItem then
        return
    end
    local num = 0
    for i,v in pairs(self.GoodsUnifyMgr.transportPanelItem) do
        num = num + i
    end
    if num ~= 0 and WarehousePanel.nameText.text ~= nil then
        WarehousePanel.transportConfirmBtn.localScale = Vector3.one
        WarehousePanel.transportUncheckBtn.localScale = Vector3.zero
    else
        WarehousePanel.transportConfirmBtn.localScale = Vector3.zero
        WarehousePanel.transportUncheckBtn.localScale = Vector3.one
    end
end
function WarehouseCtrl:OnClick_OnSorting(ins)
    PlayMusEff(1002)
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end
--打开排序
function WarehouseCtrl:OnClick_OpenList(isShow)
    if isShow then
        WarehousePanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        WarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        WarehousePanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        WarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end
--判断右侧是货架还是运输
function WarehouseCtrl:OnClick_rightInfo(isShow,number)
    if isShow then
        WarehousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        if number == 0 then
            WarehousePanel.shelf:SetActive(true);
            self.operation = ct.goodsState.shelf;
        else
            WarehousePanel.transport:SetActive(true);
            --WarehousePanel.nameText.text = "请选择仓库"
            --WarehousePanel.transportUncheckBtn.localScale = Vector3.one
            --WarehousePanel.transportConfirmBtn.localScale = Vector3.zero
            self:isShowDetermineBtn()
            self.operation = ct.goodsState.transport;
        end
        if self.GoodsUnifyMgr.warehouseLuaTab ~= nil then
            Event.Brocast("c_GoodsItemChoose")
        end
        WarehousePanel.Content.offsetMax = Vector2.New(-810,0);
    else
        WarehousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        if number == 0 then
            WarehousePanel.shelf:SetActive(false);
            for i in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", i)
            end
            self.operation = nil;
        else
            WarehousePanel.transport:SetActive(false);
            WarehousePanel.nameText.text = ""
            for i in pairs(WarehouseCtrl.temporaryItems) do
                self:c_temporaryifNotGoods(i)
            end
            self.operation = nil;
        end
        if self.GoodsUnifyMgr.warehouseLuaTab ~= nil then
            --for i,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
            --    v:c_GoodsItemDelete()
            --end
            Event.Brocast("c_GoodsItemDelete")
        end
        WarehousePanel.Content.offsetMax = Vector2.New(0,0);
    end
    switchIsShow = isShow;
end
--排序
function WarehouseCtrl:_getSortItems(type,sortingTable)
    if type == ct.sortingItemType.Name then
        table.sort(sortingTable, function (m, n) return m.name < n.name end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(WarehousePanel.ScrollView.transform);
            v.prefab.gameObject.transform:SetParent(WarehousePanel.Content.transform);
            v.id = i
            WarehouseItem:RefreshData(v.goodsDataInfo,i)
        end
    end
    if type == ct.sortingItemType.Quantity then
        table.sort(sortingTable, function (m, n) return m.n < n.n end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(WarehousePanel.ScrollView.transform);
            v.prefab.gameObject.transform:SetParent(WarehousePanel.Content.transform);
            v.id = i
            WarehouseItem:RefreshData(v.goodsDataInfo,i)
        end
    end
end
--关闭面板时清空UI信息，以备其他模块调用
function WarehouseCtrl:deleteObjInfo()
    if not self.GoodsUnifyMgr.warehouseLuaTab then
        return;
    else
        for i,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
            v:closeEvent();
            destroy(v.prefab.gameObject);
        end
    end
end
]]
