---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/18 10:11
---
NewTransportBoxCtrl = class('NewTransportBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(NewTransportBoxCtrl)

local ToNumber = tonumber
function NewTransportBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function NewTransportBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/NewTransportBoxPanel.prefab"
end

function NewTransportBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function NewTransportBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.chooseWarehouseBtn.gameObject,self._clickChooseWarehouseBtn,self)
    self.luaBehaviour:AddClick(self.startBtn.gameObject,self._clickStartBtn,self)
end

function NewTransportBoxCtrl:Active()
    UIPanel.Active(self)
    self:_language()
    Event.AddListener("deleteItemPrefab",self.deleteItemPrefab,self)
end

function NewTransportBoxCtrl:Refresh()
    self:initializeUiInfoData()
end

function NewTransportBoxCtrl:Hide()
    UIPanel.Hide(self)
    self:CloseDestroy()
    self.targetWarehouse.text = ""
    Event.RemoveListener("deleteItemPrefab",self.deleteItemPrefab,self)
end

-------------------------------------------------------------Get components-------------------------------------------------------------------------------
function NewTransportBoxCtrl:_getComponent(go)
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topNameText = go.transform:Find("contentRoot/top/topNameText"):GetComponent("Text")

    --content
    self.tipContentText = go.transform:Find("contentRoot/content/contentText"):GetComponent("Text")
    self.Content = go.transform:Find("contentRoot/content/ScrollView/Viewport/Content")
    self.TransportItem = go.transform:Find("contentRoot/content/ScrollView/Viewport/Content/TransportItem").gameObject

    --buttonRoot
    self.chooseWarehouseBtn = go.transform:Find("contentRoot/buttonRoot/chooseWarehouseBtn")
    self.startBtn = go.transform:Find("contentRoot/buttonRoot/startBtn")
    self.startText = go.transform:Find("contentRoot/buttonRoot/startBtn/text"):GetComponent("Text")
    self.targetWarehouse = go.transform:Find("contentRoot/buttonRoot/targetWarehouse"):GetComponent("InputField")
    self.placeholderText = go.transform:Find("contentRoot/buttonRoot/targetWarehouse/Placeholder"):GetComponent("Text")
    self.priceText = go.transform:Find("contentRoot/buttonRoot/totalPrice/priceText"):GetComponent("Text")
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--Initialize UI data
function NewTransportBoxCtrl:initializeUiInfoData()
    if next(self.m_data.itemPrefabTab) == nil then
        self.tipContentText.transform.localScale = Vector3.one
    else
        self.tipContentText.transform.localScale = Vector3.zero
        if not self.itemTable then
            self.itemTable = {}
        end
        local unitPrice = ChooseWarehouseCtrl:GetPrice()
        if self.targetWarehouse.text == nil or self.targetWarehouse.text == "" then
             unitPrice = 0
        end
        self:CreateGoodsItems(self.m_data.itemPrefabTab,self.TransportItem,self.Content,TransportItem,self.luaBehaviour,self.m_data.buildingType,unitPrice)
    end
    self.priceText.text = self:calculateTotalPrice()
end
--Set up multiple languages
function NewTransportBoxCtrl:_language()
    --Shopping cart or shipping list
    if self.m_data.stateType == GoodsItemStateType.transport then
        self.topNameText.text = GetLanguage(25020013)
        self.startText.text = GetLanguage(25020036)
        self.tipContentText.text = GetLanguage(25020023)
    elseif self.m_data.stateType == GoodsItemStateType.buy then
        self.topNameText.text = GetLanguage(25070002)
        self.startText.text = GetLanguage(22040001)
        self.tipContentText.text = GetLanguage(25070015)
    end
    self.placeholderText.text = GetLanguage(25020015)
    self.priceText.text = "0.0000"
end
-----------------------------------------------------------------Click Function----------------------------------------------------------------------------
--close
function NewTransportBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--Jump to select warehouse
function NewTransportBoxCtrl:_clickChooseWarehouseBtn(ins)
    PlayMusEff(1002)
    if not ins.itemTable or next(ins.itemTable) == nil then
        Event.Brocast("SmallPop",GetLanguage(25020023), 300)
        return
    end
    local totalNum = 0
    for key,value in pairs(ins.itemTable) do
        totalNum = totalNum + value.dataInfo.number
    end
    local data = {}
    data.pos = {}
    data.pos.x = ins.m_data.buildingInfo.pos.x
    data.pos.y = ins.m_data.buildingInfo.pos.y
    data.buildingId = ins.m_data.buildingId
    data.number = totalNum
    data.nameText = ins.targetWarehouse
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--Click shipping
function NewTransportBoxCtrl:_clickStartBtn(ins)
    ins.targetBuildingId = ChooseWarehouseCtrl:GetBuildingId()
    if not ins.itemTable or next(ins.itemTable) == nil then
        Event.Brocast("SmallPop",GetLanguage(25020023), 300)
        return
    end
    if ins.targetBuildingId == nil then
        Event.Brocast("SmallPop",GetLanguage(25070012), 300)
        return
    end
    if ins.targetWarehouse.text == nil or ins.targetWarehouse.text == "" then
        Event.Brocast("SmallPop",GetLanguage(25070012), 300)
        return
    end
    if ins.m_data.stateType == GoodsItemStateType.transport then
        Event.Brocast("startTransport",ins.itemTable,ins.targetBuildingId)
    elseif ins.m_data.stateType == GoodsItemStateType.buy then
        Event.Brocast("startBuy",ins.itemTable,ins.targetBuildingId)
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--Delete a product
function NewTransportBoxCtrl:deleteItemPrefab(id)
    --Is the shipping or purchase list empty
    if next(self.itemTable) == nil then
        return
    else
        if self.itemTable[id].dataInfo.state == GoodsItemStateType.transport then
            Event.Brocast("deleTransportList",id)
        elseif self.itemTable[id].dataInfo.state == GoodsItemStateType.buy then
            Event.Brocast("deleBuyList",id)
        end
        destroy(self.itemTable[id].prefab.gameObject)
        table.remove(self.itemTable,id)
        --Whether it is currently empty after deleting one, reorder if it is not empty
        if next(self.itemTable) == nil then
            self.tipContentText.transform.localScale = Vector3.one
            return
        else
            local id = 1
            for key,value in pairs(self.itemTable) do
                value:RefreshID(id)
                id = id + 1
            end
        end
        self.priceText.text = self:calculateTotalPrice()
    end
end
--Calculate the total cost
function NewTransportBoxCtrl:calculateTotalPrice()
    local totalPrice = 0
    if not self.itemTable or next(self.itemTable) == nil then
        return GetClientPriceString(totalPrice)
    end
    for key,value in pairs(self.itemTable) do
        totalPrice = totalPrice + ToNumber(GetServerPriceNumber(value.freightPriceText.text)) + ToNumber(GetServerPriceNumber(value.goodsPriceText.text))
    end
    return GetClientPriceString(totalPrice)
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--Generate itemPrefab
function NewTransportBoxCtrl:CreateGoodsItems(dataInfo,itemPrefab,itemRoot,className,behaviour,goodsType,unitPrice)
    if not dataInfo then
        return
    end
    for key,value in pairs(dataInfo) do
        local obj = self:loadingItemPrefab(itemPrefab,itemRoot)
        local itemGoodsIns = className:new(value,obj,behaviour,key,goodsType,unitPrice)
        table.insert(self.itemTable,itemGoodsIns)
    end
end
--Load instantiated Prefab
function NewTransportBoxCtrl:loadingItemPrefab(itemPrefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
    local objRect = obj.transform:GetComponent("RectTransform");
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one;
    --obj.transform:SetSiblingIndex(1)
    obj:SetActive(true)
    return obj
end
--Clear Item data on exit
function NewTransportBoxCtrl:CloseDestroy()
    if not self.itemTable or next(self.itemTable) == nil then
        return
    else
        for key,valueObj in pairs(self.itemTable) do
            destroy(valueObj.prefab.gameObject)
            self.itemTable[key] = nil
        end
    end
end