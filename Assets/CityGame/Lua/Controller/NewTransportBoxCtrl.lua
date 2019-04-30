---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
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
    Event.RemoveListener("deleteItemPrefab",self.deleteItemPrefab,self)
end

-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
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
    self.targetWarehouse = go.transform:Find("contentRoot/buttonRoot/targetWarehouse"):GetComponent("InputField")
    self.placeholderText = go.transform:Find("contentRoot/buttonRoot/targetWarehouse/Placeholder"):GetComponent("Text")
    self.priceText = go.transform:Find("contentRoot/buttonRoot/totalPrice/priceText"):GetComponent("Text")
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--初始化UI数据
function NewTransportBoxCtrl:initializeUiInfoData()
    if next(self.m_data.itemPrefabTab) == nil then
        self.tipContentText.transform.localScale = Vector3.one
    else
        self.tipContentText.transform.localScale = Vector3.zero
        if not self.itemTable then
            self.itemTable = {}
        end
        local unitPrice = ChooseWarehouseCtrl:GetPrice()
        self.targetBuildingId = ChooseWarehouseCtrl:GetBuildingId()
        self:CreateGoodsItems(self.m_data.itemPrefabTab,self.TransportItem,self.Content,TransportItem,self.luaBehaviour,self.m_data.buildingType,unitPrice)
    end
    self.priceText.text = self:calculateTotalPrice()
end
--设置多语言
function NewTransportBoxCtrl:_language()
    self.topNameText.text = "TRANSPORTATION LIST"
    self.tipContentText.text = "Tgere is no goods yet!"
    self.placeholderText.text = "请选择仓库"
    self.priceText.text = "0.0000"
end
-----------------------------------------------------------------点击函数----------------------------------------------------------------------------
--关闭
function NewTransportBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--跳转选择仓库
function NewTransportBoxCtrl:_clickChooseWarehouseBtn(ins)
    PlayMusEff(1002)
    if not ins.itemTable or next(ins.itemTable) == nil then
        Event.Brocast("SmallPop","没有要运输的商品", 300)
        return
    end
    local data = {}
    data.pos = {}
    data.pos.x = ins.m_data.buildingInfo.pos.x
    data.pos.y = ins.m_data.buildingInfo.pos.y
    data.buildingId = ins.m_data.buildingId
    data.nameText = ins.targetWarehouse
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--点击运输
function NewTransportBoxCtrl:_clickStartBtn(ins)
    if not ins.itemTable or next(ins.itemTable) == nil then
        Event.Brocast("SmallPop","没有要运输的商品", 300)
        return
    end
    if ins.targetBuildingId == nil then
        Event.Brocast("SmallPop",GetLanguage(21020002), 300)
        return
    end
    if ins.m_data.stateType == GoodsItemStateType.transport then
        Event.Brocast("startTransport",ins.itemTable,ins.targetBuildingId)
    elseif ins.m_data.stateType == GoodsItemStateType.buy then
        Event.Brocast("startBuy",ins.itemTable,ins.targetBuildingId)
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--删除某个商品
function NewTransportBoxCtrl:deleteItemPrefab(id)
    --运输或购买列表是否为空
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
        --删除一个之后当前是否为空，不为空重新排序
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
    end
end
--计算总费用
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
--生成itemPrefab
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
--加载实例化Prefab
function NewTransportBoxCtrl:loadingItemPrefab(itemPrefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
    local objRect = obj.transform:GetComponent("RectTransform");
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one;
    --obj.transform:SetSiblingIndex(1)
    obj:SetActive(true)
    return obj
end
--退出时清空Item数据
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