---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 09:24
---建筑主界面仓库详情界面
BuildingWarehouseDetailPart = class('BuildingWarehouseDetailPart',BuildingBaseDetailPart)

function BuildingWarehouseDetailPart:PrefabName()
    return "BuildingWarehouseDetailPart"
end

function BuildingWarehouseDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    --仓库数据
    self.warehouseDatas = {}
    --运输列表(运输成功后或退出建筑时清空)
    self.transportTab = {}
end

function BuildingWarehouseDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end

function BuildingWarehouseDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    --TopRoot
    self.closeBtn = transform:Find("topRoot/closeBtn")
    self.sortingBtn = transform:Find("topRoot/sortingBtn")
    self.nowStateText = transform:Find("topRoot/sortingBtn/nowStateText"):GetComponent("Text")
    self.transportBtn = transform:Find("topRoot/transportBtn")
    self.number = transform:Find("topRoot/number")
    self.numberText = transform:Find("topRoot/number/numberText"):GetComponent("Text")
    self.warehouseCapacitySlider = transform:Find("topRoot/warehouseCapacitySlider"):GetComponent("Slider")
    self.capacityNumberText = transform:Find("topRoot/warehouseCapacitySlider/numberText"):GetComponent("Text")
    self.capacityText = transform:Find("topRoot/capacityText"):GetComponent("Text")

    --ContentRoot
    self.noTip = transform:Find("contentRoot/noTip")
    self.tipText = transform:Find("contentRoot/noTip/tipText"):GetComponent("Text")
    self.Content = transform:Find("contentRoot/ScrollView/Viewport/Content")
    self.WarehouseItem = transform:Find("contentRoot/ScrollView/Viewport/Content/WarehouseItem").gameObject
end

function BuildingWarehouseDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject,function()
        self:clickCloseBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.transportBtn.gameObject,function()
        self:clickTransportBtn()
    end,self)
end

function BuildingWarehouseDetailPart:_ResetTransform()
    --关闭时清空Item数据
    if next(self.warehouseDatas) ~= nil then
        self:CloseDestroy(self.warehouseDatas)
    end
end

function BuildingWarehouseDetailPart:_RemoveClick()

end

function BuildingWarehouseDetailPart:_InitEvent()
    Event.AddListener("addTransportList",self.addTransportList,self)
    Event.AddListener("deleTransportList",self.deleTransportList,self)
end

function BuildingWarehouseDetailPart:_RemoveEvent()
    Event.RemoveListener("addTransportList",self.addTransportList,self)
    Event.RemoveListener("deleTransportList",self.deleTransportList,self)
end

function BuildingWarehouseDetailPart:_initFunc()
    self:_language()
    self:initializeUiInfoData(self.m_data.store.inHand)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingWarehouseDetailPart:_language()
    self.capacityText.text = "容量"
    self.tipText.text = "There is no product yet!".."\n".."just go to produce some.good luck."
end
--初始化UI数据
function BuildingWarehouseDetailPart:initializeUiInfoData(storeData)
    if not storeData then
        self.number.transform.localScale = Vector3.zero
        self.noTip.transform.localScale = Vector3.one
        self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
        self.warehouseCapacitySlider.value = 0
        self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue
    else
        self.noTip.transform.localScale = Vector3.zero
        self.warehouseCapacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
        self.warehouseCapacitySlider.value = self:_getWarehouseCapacity(self.m_data.store)
        self.capacityNumberText.text = self.warehouseCapacitySlider.value.."/"..self.warehouseCapacitySlider.maxValue
        if next(self.transportTab) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
        end
        if #storeData == #self.warehouseDatas then
            return
        else
            self.transportBool = GoodsItemStateType.transport
            self:CreateGoodsItems(storeData,self.WarehouseItem,self.Content,WarehouseItem,self.mainPanelLuaBehaviour,self.warehouseDatas,self.m_data.buildingType,self.transportBool)
        end
    end
end
-----------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------
--关闭详情
function BuildingWarehouseDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--打开运输弹窗
function BuildingWarehouseDetailPart:clickTransportBtn()
    local data = {}
    data.buildingId = self.m_data.insId
    data.buildingInfo = self.m_data.info
    data.buildingType = self.m_data.buildingType
    data.transportTab = self.transportTab
    ct.OpenCtrl("NewTransportBoxCtrl",data)
end
-----------------------------------------------------------------------------事件函数---------------------------------------------------------------------------------------
--添加运输列表
function BuildingWarehouseDetailPart:addTransportList(data)
    --添加到运输列表
    table.insert(self.transportTab,data)
    self.number.transform.localScale = Vector3.one
    self.numberText.text = #self.transportTab
end
--删除运输列表
function BuildingWarehouseDetailPart:deleTransportList(id)
    --删除指定的数据
    if not id then
        return
    else
        table.remove(self.transportTab,id)
        if next(self.transportTab) == nil then
            self.number.transform.localScale = Vector3.zero
        else
            self.number.transform.localScale = Vector3.one
            self.numberText.text = #self.transportTab
        end
    end
end





--WarehouseCtrl = class('WarehouseCtrl',BuildingBaseCtrl)
--UIPanel:ResgisterOpen(WarehouseCtrl)--注册打开的方法
--
--local warehouse
--local switchRightPanel
--local itemStateBool
--local switchIsShow    --false 打开上架  true 打开运输
--local itemNumber  --用来记录销毁的数量
--ct.itemPrefab =
--{
--    shelfItem  = 0,  --上架
--    transportItem = 1,  --运输
--}
--function WarehouseCtrl:initialize()
--    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
--end
--function WarehouseCtrl:bundleName()
--    return "Assets/CityGame/Resources/View/WarehousePanel.prefab"
--end
--function WarehouseCtrl:OnCreate(obj)
--    UIPanel.OnCreate(self,obj)
--end
--function WarehouseCtrl:Awake(go)
--    warehouse = self.gameObject:GetComponent('LuaBehaviour')
--    warehouse:AddClick(WarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self)
--    warehouse:AddClick(WarehousePanel.shelfBtn.gameObject,self.ClickRightShelfBtn,self)
--    warehouse:AddClick(WarehousePanel.shelfCloseBtn.gameObject,self.ClickRightShelfBtn,self)
--    warehouse:AddClick(WarehousePanel.transportBtn.gameObject,self.ClickRightTransportBtn,self)
--    warehouse:AddClick(WarehousePanel.shelfConfirmBtn.gameObject,self.OnClick_shelfConfirmBtn,self)
--    warehouse:AddClick(WarehousePanel.transportCloseBtn.gameObject,self.ClickRightTransportBtn,self)
--    warehouse:AddClick(WarehousePanel.transportopenBtn.gameObject,self.OnClick_transportopenBtn,self)
--    warehouse:AddClick(WarehousePanel.transportConfirmBtn.gameObject,self.OnClick_transportConfirmBtn,self)
--
--    switchRightPanel = false
--    itemStateBool = nil
--    switchIsShow = nil
--    self.tempItemList = {}  --选中的数据
--    self.recordIdList = {}  --记录选中的id
--    self.warehouseDatas = {}  --仓库数据
--    self.loadItemPrefab = nil
--end
--function WarehouseCtrl:Active()
--    UIPanel.Active(self)
--    WarehousePanel.tipText.text = GetLanguage(26040002)
--    LoadSprite(GetSprite("Warehouse"), WarehousePanel.warehouseImg:GetComponent("Image"), false)
--    self:_addListener()
--    self:RefreshConfirmButton()
--end
--function WarehouseCtrl:_addListener()
--    Event.AddListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
--    Event.AddListener("DestroyWarehouseItem",self.DestroyWarehouseItem,self)
--    Event.AddListener("MaterialUpdateLatestData",self.UpdateLatestData,self)
--    Event.AddListener("SetAutoReplenish",self.SetAutoReplenish,self)
--end
--function WarehouseCtrl:_removeListener()
--    Event.RemoveListener("SelectedGoodsItem",self.SelectedGoodsItem,self)
--    Event.RemoveListener("DestroyWarehouseItem",self.DestroyWarehouseItem,self)
--    Event.RemoveListener("MaterialUpdateLatestData",self.UpdateLatestData,self)
--    Event.RemoveListener("SetAutoReplenish",self.SetAutoReplenish,self)
--end
--function WarehouseCtrl:Refresh()
--    itemNumber = nil
--    self.luabehaviour = warehouse
--    self.store = self.m_data.store
--    self.buildingId = self.m_data.info.id
--    self:InitializeCapacity()
--    if next(self.warehouseDatas) == nil then
--        self:CreateGoodsItems(self.store.inHand,WarehousePanel.warehouseItem,WarehousePanel.Content,WarehouseItem,self.luabehaviour,self.warehouseDatas)
--    end
--    --如果是从货架进来的
--    if self.m_data.isShelf == true then
--        switchIsShow = false
--        WarehousePanel.shelfCloseBtn.transform.localScale = Vector3.zero
--        self:OpenRightPanel(not switchRightPanel,switchIsShow)
--    end
--end
--function WarehouseCtrl:Hide()
--    UIPanel.Hide(self)
--    self:_removeListener()
--    self.m_data.isShow = false
--    return {insId = self.m_data.info.id,self.m_data}
--end
------------------------------------------------------------------------初始化函数------------------------------------------------------------------------------------------
----初始化仓库容量
--function WarehouseCtrl:InitializeCapacity()
--    WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
--    WarehousePanel.Warehouse_Slider.value = self:GetWarehouseNum(self.store)
--    WarehousePanel.Locked_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity
--    WarehousePanel.Locked_Slider.value = self:GatWarehouseCapacity(self.store)
--    self.lockedNum = self.GetLockedNum(self.store)
--    local numTab = {}
--    numTab["num1"] = WarehousePanel.Warehouse_Slider.value
--    numTab["num2"] = self.lockedNum
--    numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
--    numTab["col1"] = "Cyan"
--    numTab["col2"] = "Teal"
--    numTab["col3"] = "white"
--    WarehousePanel.numberText.text = getColorString(numTab)
--end
------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------------
----点击打开上架Panel
--function WarehouseCtrl:ClickRightShelfBtn(ins)
--    PlayMusEff(1002)
--    switchIsShow = false
--    WarehousePanel.shelfCloseBtn.transform.localScale = Vector3.one
--    ins:OpenRightPanel(not switchRightPanel,switchIsShow)
--end
----点击打开运输Panel
--function WarehouseCtrl:ClickRightTransportBtn(ins)
--    PlayMusEff(1002)
--    switchIsShow = true
--    ins:OpenRightPanel(not switchRightPanel,switchIsShow)
--end
----跳转选择仓库
--function WarehouseCtrl:OnClick_transportopenBtn(ins)
--    PlayMusEff(1002)
--    local data = {}
--    data.pos = {}
--    data.pos.x = ins.m_data.info.pos.x
--    data.pos.y = ins.m_data.info.pos.y
--    data.buildingId = ins.buildingId
--    data.nameText = WarehousePanel.nameText
--    ct.OpenCtrl("ChooseWarehouseCtrl",data)
--end
----上架确认
--function WarehouseCtrl:OnClick_shelfConfirmBtn(ins)
--    PlayMusEff(1002)
--    local noMatch = {}
--    for key1,value1 in pairs(ins.tempItemList) do
--        --如果架子上是空的
--        if not ins.m_data.shelf.good then
--            if ins:WhetherValidShelfOp(value1) == true then
--                Event.Brocast("m_ReqMaterialShelfAdd",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty,value1.ToggleBtn.isOn)
--                --Event.Brocast("m_ReqMaterialSetAutoReplenish",ins.buildingId,value1.itemId,value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty,ins.ToggleBtn)
--            else
--                noMatch[#noMatch + 1] = value1.itemId
--            end
--        else
--            --如果架子上不是空的，先检查架子上有没有这个商品
--            if ins:ShelfWhetherHave(ins.m_data.shelf.good,value1) == true then
--                --如果有这个东西，需要发送两个协议，修改和上架
--                if ins:WhetherValidShelfOp(value1) == true then
--                    --修改协议
--                    Event.Brocast("m_ReqMaterialModifyShelf",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
--                    --上架协议
--                    Event.Brocast("m_ReqMaterialShelfAdd",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
--                else
--                    noMatch[#noMatch + 1] = value1.itemId
--                end
--            else
--                if ins:WhetherValidShelfOp(value1) == true then
--                    --发送上架协议
--                    Event.Brocast("m_ReqMaterialShelfAdd",ins.buildingId,value1.itemId,value1.inputNumber.text,GetServerPriceNumber(value1.inputPrice.text),value1.goodsDataInfo.key.producerId,value1.goodsDataInfo.key.qty)
--                else
--                    noMatch[#noMatch + 1] = value1.itemId
--                end
--            end
--        end
--    end
--    --后边要改成如果上架的商品中有一个不匹配的，则全部都不能上架
--    if next(noMatch) ~= nil then
--        --打印上架不成功的itemId
--        local noMatchStr = GetLanguage(noMatch[1])
--        for i = 2, #noMatch do
--            noMatchStr = noMatchStr..","..GetLanguage(noMatch[i])
--        end
--        Event.Brocast("SmallPop",noMatchStr.."类型不符",400)
--    end
--end
----运输确认
--function WarehouseCtrl:OnClick_transportConfirmBtn(ins)
--    PlayMusEff(1002)
--    local targetBuildingCapacity = ChooseWarehouseCtrl:GetCapacity()
--    local targetBuildingId = ChooseWarehouseCtrl:GetBuildingId()
--    local transportDatasInfo = {}
--    transportDatasInfo.currentLocationName = ins.m_data.info.name
--    transportDatasInfo.targetLocationName = ChooseWarehouseCtrl:GetName()
--    local pos = {}
--    pos.x = ins.m_data.info.pos.x
--    pos.y = ins.m_data.info.pos.y
--    transportDatasInfo.distance = ChooseWarehouseCtrl:GetDistance(pos)
--    transportDatasInfo.number = ins.GetDataTableNum(ins.tempItemList)
--    transportDatasInfo.freight = GetClientPriceString(ChooseWarehouseCtrl:GetPrice())
--    transportDatasInfo.total = GetClientPriceString(transportDatasInfo.number * GetServerPriceNumber(transportDatasInfo.freight))
--    transportDatasInfo.btnClick = function ()
--        if targetBuildingCapacity < transportDatasInfo.number then
--            Event.Brocast("SmallPop",GetLanguage(26040012),300)
--            return
--        end
--        if transportDatasInfo.number == 0 then
--            Event.Brocast("SmallPop",GetLanguage(27020004),300)
--            return
--        else
--            for key,value in pairs(ins.tempItemList) do
--                Event.Brocast("m_MaterialTransport",ins.buildingId,targetBuildingId,value.itemId,value.inputNumber.text,value.goodsDataInfo.key.producerId,value.goodsDataInfo.key.qty)
--            end
--        end
--    end
--    ct.OpenCtrl("TransportBoxCtrl",transportDatasInfo)
--end
----退出仓库
--function WarehouseCtrl:OnClick_returnBtn(ins)
--    PlayMusEff(1002)
--    if switchIsShow ~= nil then
--        ins:OpenRightPanel(not switchRightPanel,switchIsShow)
--    end
--    ins:CloseDestroy(ins.warehouseDatas)
--    UIPanel.ClosePage()
--end
------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------------
----上架或运输刷新仓库数据
--function WarehouseCtrl:RefreshWarehouseData(dataInfo,whether)
--    for key,value in pairs(self.warehouseDatas) do
--        if value.itemId == dataInfo.item.key.id then
--            if value.n == dataInfo.item.n then
--                self:deleteGoodsItem(self.warehouseDatas,key)
--            else
--                value.numberText.text = value.n - dataInfo.item.n
--                value.goodsDataInfo.n = tonumber(value.numberText.text)
--                value.n = tonumber(value.numberText.text)
--                local stateBool = true
--                self:GoodsItemState(self.warehouseDatas,stateBool)--数量减少后刷新商品的状态为可以勾选
--            end
--            self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
--            self:RefreshCapacity(dataInfo,whether)
--        end
--    end
--    WarehousePanel.nameText.text = ""
--    self:RefreshConfirmButton()
--    if whether == true then
--        Event.Brocast("SmallPop",GetLanguage(26040010),300)
--    else
--        Event.Brocast("SmallPop",GetLanguage(27020002),300)
--        --如果上架成功，模拟服务器数据放到货架
--        if not self.m_data.store.locked or next(self.m_data.store.locked) == nil then
--            local locked = {}
--            local goodData = {}
--            local key = {}
--            key.id = dataInfo.item.key.id
--            goodData.key = key
--            goodData.n = dataInfo.item.n
--            locked[#locked + 1] = goodData
--            self.m_data.store.locked = locked
--        else
--            --for key1,value1 in pairs(self.m_data.store.locked) do
--            --    if value1.key.id == dataInfo.item.key.id then
--            --        value1.n = value1.n + dataInfo.item.n
--            --    end
--            --end
--            self:SetShelfLocked(dataInfo)
--            --for key2,value2 in pairs(self.m_data.shelf.good) do
--            --    if value2.k.id == dataInfo.item.key.id then
--            --        value2.n = value2.n + dataInfo.item.n
--            --    end
--            --end
--            self:SetShelfGood(dataInfo)
--        end
--        --上架成功后模拟服务器数据改变m_data
--        for key,value in pairs(self.m_data.store.inHand) do
--            if value.key.id == dataInfo.item.key.id then
--                if value.n == dataInfo.item.n then
--                    table.remove(self.m_data.store.inHand,key)
--                end
--            end
--        end
--    end
--    --如果货架上没有东西改变货架m_data
--    if self.m_data.isShelf == true then
--        self:SetShelfData(dataInfo)
--    end
--end
----销毁仓库原料或商品刷新
--function WarehouseCtrl:DestroyAfterRefresh(dataInfo)
--    for key,value in pairs(self.warehouseDatas) do
--        if value.itemId == dataInfo.item.id then
--            self:deleteGoodsItem(self.warehouseDatas,key)
--        end
--    end
--    local numTab = {}
--    numTab["num1"] = WarehousePanel.Warehouse_Slider.value - itemNumber
--    numTab["num2"] = self.lockedNum
--    numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
--    numTab["col1"] = "Cyan"
--    numTab["col2"] = "Teal"
--    numTab["col3"] = "white"
--    WarehousePanel.numberText.text = getColorString(numTab)
--    itemNumber = nil
--    Event.Brocast("SmallPop",GetLanguage(26030003),300)
--end
------------------------------------------------------------------------事件函数--------------------------------------------------------------------------------------------
----勾选商品
--function WarehouseCtrl:SelectedGoodsItem(ins)
--    if self.recordIdList[ins.id] == nil then
--        self.recordIdList[ins.id] = ins.id
--        if self.loadItemPrefab == ct.itemPrefab.shelfItem then
--            self:CreateGoodsDetails(ins.goodsDataInfo,WarehousePanel.DetailsItem,WarehousePanel.shelfContent,DetailsItem,self.luabehaviour,ins.id,self.tempItemList)
--        elseif self.loadItemPrefab == ct.itemPrefab.transportItem then
--            self:CreateGoodsDetails(ins.goodsDataInfo,WarehousePanel.TransportItem,WarehousePanel.transportContent,TransportItem,self.luabehaviour,ins.id,self.tempItemList)
--        end
--        self.warehouseDatas[ins.id]:c_GoodsItemSelected()
--    else
--        self.warehouseDatas[ins.id]:c_GoodsItemChoose()
--        self:DestoryGoodsDetailsList(self.tempItemList,self.recordIdList,ins.id)
--    end
--    self:RefreshConfirmButton()
--end
----销毁仓库原料或商品
--function WarehouseCtrl:DestroyWarehouseItem(ins)
--    itemNumber = ins.n
--    local data = {}
--    data.titleInfo = GetLanguage(30030001)
--    data.contentInfo = GetLanguage(35030004)
--    data.tipInfo = GetLanguage(30030002)
--    data.btnCallBack = function()
--        Event.Brocast("m_ReqMaterialDelItem",self.buildingId,ins.itemId,ins.producerId,ins.qty)
--    end
--    ct.OpenCtrl('ErrorBtnDialogPageCtrl',data)
--end
----生产中刷新仓库数据
--function WarehouseCtrl:UpdateLatestData(dataInfo)
--    self:InitializeCapacity()
--    if self.warehouseDatas then
--        for key,value in pairs(self.warehouseDatas) do
--            if dataInfo.itemId == value.itemId then
--                value.n = dataInfo.nowCountStore
--                value.numberText.text = dataInfo.nowCountStore
--                value.goodsDataInfo.n = dataInfo.nowCountStore
--                return
--            end
--        end
--    end
--    local inHand = {}
--    local key = {}
--    key.id = dataInfo.itemId
--    inHand.key = key
--    inHand.n = dataInfo.nowCountStore
--    self:RefreshCreateItem(inHand,WarehousePanel.warehouseItem,WarehousePanel.Content,WarehouseItem,self.luabehaviour,self.warehouseDatas)
--end
----自动补货
--function WarehouseCtrl:SetAutoReplenish(ins)
--    self.ToggleBtn = ins.ToggleBtn.isOn
--    --Event.Brocast("m_ReqMaterialSetAutoReplenish",self.buildingId,ins.goodsDataInfo.key.id,ins.goodsDataInfo.key.producerId,ins.goodsDataInfo.key.qty,ins.ToggleBtn.isOn)
--end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----打开上架或运输Panel
--function WarehouseCtrl:OpenRightPanel(isShow,switchShow)
--    if isShow then
--        itemStateBool = true
--        WarehousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
--        WarehousePanel.Content.offsetMax = Vector2.New(-810,0)
--        if switchShow == false then
--            WarehousePanel.shelf:SetActive(true)
--            self.loadItemPrefab = ct.itemPrefab.shelfItem
--        else
--            WarehousePanel.transport:SetActive(true)
--            self.loadItemPrefab = ct.itemPrefab.transportItem
--        end
--        switchIsShow = switchShow
--        self:GoodsItemState(self.warehouseDatas,itemStateBool)
--        self:RefreshConfirmButton()
--    else
--        itemStateBool = false
--        if switchShow == false then
--            WarehousePanel.shelf:SetActive(false)
--            self.loadItemPrefab = nil
--        else
--            WarehousePanel.transport:SetActive(false)
--            self.loadItemPrefab = nil
--            WarehousePanel.nameText.text = ""
--        end
--        WarehousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic)
--        WarehousePanel.Content.offsetMax = Vector2.New(0,0)
--        self:CloseGoodsDetails(self.tempItemList,self.recordIdList)
--        self:GoodsItemState(self.warehouseDatas,itemStateBool)
--        switchIsShow = nil
--    end
--    switchRightPanel = isShow
--end
----刷新确认上架或确认运输的按钮
--function WarehouseCtrl:RefreshConfirmButton()
--    if switchIsShow == false then
--        if next(self.tempItemList) == nil then
--            WarehousePanel.shelfUncheckBtn.transform.localScale = Vector3.one
--            WarehousePanel.shelfConfirmBtn.transform.localScale = Vector3.zero
--        else
--            WarehousePanel.shelfUncheckBtn.transform.localScale = Vector3.zero
--            WarehousePanel.shelfConfirmBtn.transform.localScale = Vector3.one
--        end
--    else
--        if next(self.tempItemList) == nil or WarehousePanel.nameText.text == "" then
--            WarehousePanel.transportUncheckBtn.transform.localScale = Vector3.one
--            WarehousePanel.transportConfirmBtn.transform.localScale = Vector3.zero
--        elseif next(self.tempItemList) ~= nil and WarehousePanel.nameText.text ~= "" then
--            WarehousePanel.transportUncheckBtn.transform.localScale = Vector3.zero
--            WarehousePanel.transportConfirmBtn.transform.localScale = Vector3.one
--        end
--    end
--end
----检查上架商品是否匹配，是否输入数量和价格  --原料厂，零售店判断mId不同
--function WarehouseCtrl:WhetherValidShelfOp(ins)
--    local materialKey = 21              --可以上架的商品类型
--    if GetServerPriceNumber(ins.inputPrice.text) == 0 then
--        Event.Brocast("SmallPop","价格不能为0"--[[GetLanguage(26020004)]],300)
--        return false
--    end
--    if ins.inputNumber.text == "0" or ins.inputNumber.text == "" then
--        Event.Brocast("SmallPop","数量不能为0"--[[GetLanguage(26020004)]],300)
--        return false
--    end
--    if math.floor(ins.itemId / 100000) ~= materialKey then
--        return false
--    end
--
--    return true
--end
----检查架子上是否有这个商品
--function WarehouseCtrl:ShelfWhetherHave(table,value1)
--    for key,value in pairs(table) do
--        if value.k.id == value1.itemId then
--            return true
--        end
--    end
--    return false
--end
----刷新仓库容量  --true 运输   --false 上架
--function WarehouseCtrl:RefreshCapacity(dataInfo,whether)
--    if whether == true then
--        WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - dataInfo.item.n
--        WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - dataInfo.item.n
--        self.lockedNum = self.GetLockedNum(self.m_data.store)
--        local numTab = {}
--        numTab["num1"] = WarehousePanel.Warehouse_Slider.value
--        numTab["num2"] = self.lockedNum
--        numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
--        numTab["col1"] = "Cyan"
--        numTab["col2"] = "Teal"
--        numTab["col3"] = "white"
--        WarehousePanel.numberText.text = getColorString(numTab)
--    else
--        WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - dataInfo.item.n
--        WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value + dataInfo.item.n
--        self.lockedNum = self.lockedNum + dataInfo.item.n
--        local numTab = {}
--        numTab["num1"] = WarehousePanel.Warehouse_Slider.value
--        numTab["num2"] = self.lockedNum
--        numTab["num3"] = WarehousePanel.Warehouse_Slider.maxValue
--        numTab["col1"] = "Cyan"
--        numTab["col2"] = "Teal"
--        numTab["col3"] = "white"
--        WarehousePanel.numberText.text = getColorString(numTab)
--    end
--end
----如果是从货架上架要改变self.m_data数据返回
--function WarehouseCtrl:SetShelfData(dataInfo)
--    local good = {}
--    local goodData = {}
--    local key = {}
--    if not self.m_data.shelf.good or next(self.m_data.shelf.good) == nil then
--        key.id = dataInfo.item.key.id
--        --key.producerId = dataInfo.item.key.producerId
--        --key.qty = dataInfo.item.key.qty
--        goodData.k = key
--        goodData.n = dataInfo.item.n
--        goodData.price = dataInfo.price
--        --good[#good + 1] = goodData
--        if not self.m_data.shelf.good then
--            self.m_data.shelf.good = {}
--        end
--        self.m_data.shelf.good[#self.m_data.shelf.good + 1] = goodData
--    end
--end
----
--function WarehouseCtrl:SetShelfLocked(dataInfo)
--    for key,value in pairs(self.m_data.store.locked) do
--        if value.key.id == dataInfo.item.key.id then
--            value.n = value.n + dataInfo.item.n
--            return
--        end
--    end
--    local locked = {}
--    local goodData = {}
--    local key = {}
--    key.id = dataInfo.item.key.id
--    --key.producerId = dataInfo.item.key.producerId
--    --key.qty = dataInfo.item.key.qty
--    goodData.key = key
--    goodData.n = dataInfo.item.n
--    --locked[#locked + 1] = goodData
--    self.m_data.store.locked[#self.m_data.store.locked + 1] = goodData
--end
----
--function WarehouseCtrl:SetShelfGood(dataInfo)
--    for key,value in pairs(self.m_data.shelf.good) do
--        if value.k.id == dataInfo.item.key.id then
--            value.n = value.n + dataInfo.item.n
--            return
--        end
--    end
--    local good = {}
--    local goodData = {}
--    local key = {}
--    key.id = dataInfo.item.key.id
--    --key.producerId = dataInfo.item.key.producerId
--    --key.qty = dataInfo.item.key.qty
--    goodData.k = key
--    goodData.n = dataInfo.item.n
--    goodData.price = dataInfo.price
--    --good[#good + 1] = goodData
--    self.m_data.shelf.good[#self.m_data.shelf.good + 1] = goodData
--end