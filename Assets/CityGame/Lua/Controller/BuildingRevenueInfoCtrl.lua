---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/7/24 14:39
---建筑经营详情

BuildingRevenueInfoCtrl = class('BuildingRevenueInfoCtrl',UIPanel)
UIPanel:ResgisterOpen(BuildingRevenueInfoCtrl)

local typeId  --用来区分当前建筑类型
local index   --用来记录经营界面当前折线图索引
local dataInfo    --用来缓存当前打开历史详情的数据信息
local indexs  --用来记录经营界面当前点击的是否是开启状态
local isbool  --用来记录经营界面当前是否有折线图处于打开状态
function BuildingRevenueInfoCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function BuildingRevenueInfoCtrl:bundleName()
    return "Assets/CityGame/Resources/View/BuildingRevenueInfoPanel.prefab"
end

function BuildingRevenueInfoCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function BuildingRevenueInfoCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.salesBtn.gameObject,self._clickSalesBtn,self)
    self.luaBehaviour:AddClick(self.salesVolumeBtn.gameObject,self._clickSalesVolumeBtn,self)
end

function BuildingRevenueInfoCtrl:Active()
    UIPanel.Active(self)
    index = nil
    indexs = nil
    isbool = false
    dataInfo = nil
    self.time = 0.1
    self.timer = Timer.New(slot(self.UpData, self), 0.1, -1, true)
    --实例表
    self.itemPrefabTab = {}
    self:language()
    Event.AddListener("calculateLinePanel",self.calculateLinePanel,self)
end

function BuildingRevenueInfoCtrl:Refresh()
    if self.m_data then
        self.m_data.insId = OpenModelInsID.BuildingRevenueInfoCtrl
        typeId = string.sub(self.m_data.mId,1,2)
        DataManager.OpenDetailModel(BuildingRevenueInfoModel,self.m_data.insId)
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            self.topMaterialType.transform.localScale = Vector3.one
            self.topGoodsType.transform.localScale = Vector3.zero
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqBuildingRevenueInfo',self.m_data.id,typeId)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            self.topMaterialType.transform.localScale = Vector3.zero
            self.topGoodsType.transform.localScale = Vector3.one
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqBuildingRevenueInfo',self.m_data.id,typeId)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            self.topMaterialType.transform.localScale = Vector3.zero
            self.topGoodsType.transform.localScale = Vector3.one
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqBuildingRevenueInfo',self.m_data.id,typeId)
        elseif self.m_data.buildingType == BuildingType.Municipal then

        elseif self.m_data.buildingType == BuildingType.Laboratory then

        end
    end
end

function BuildingRevenueInfoCtrl:Hide()
    UIPanel.Hide(self)
    self.timer:Stop()
    self:CloseDestroy(self.itemPrefabTab)
    self.linePanel.gameObject:SetActive(false)
    Event.RemoveListener("calculateLinePanel",self.calculateLinePanel,self)
end
-------------------------------------------------------------获取组件---------------------------------------------------------------------------------
function BuildingRevenueInfoCtrl:_getComponent(go)
    ---TopRoot
    --top
    self.closeBtn = go.transform:Find("topRoot/top/closeBtn")
    self.topName = go.transform:Find("topRoot/top/topName"):GetComponent("Text")
    ---content
    --topMaterialType
    self.topMaterialType = go.transform:Find("content/topMaterialType")
    self.goodsTypeText = go.transform:Find("content/topMaterialType/goodsType/Text"):GetComponent("Text")
    self.todaySalesText = go.transform:Find("content/topMaterialType/todaySales/Text"):GetComponent("Text")
    self.proportionText = go.transform:Find("content/topMaterialType/proportion/Text"):GetComponent("Text")
    --topGoodsType
    self.topGoodsType = go.transform:Find("content/topGoodsType")
    self._goodsTypeText = go.transform:Find("content/topGoodsType/goodsType/Text"):GetComponent("Text")
    self.typeNameText = go.transform:Find("content/topGoodsType/typeName/Text"):GetComponent("Text")
    self._todaySalesText = go.transform:Find("content/topGoodsType/todaySales/Text"):GetComponent("Text")
    self._proportionText = go.transform:Find("content/topGoodsType/proportion/Text"):GetComponent("Text")

    --Content
    self.Content = go.transform:Find("content/ScrollView/Viewport/Content"):GetComponent("RectTransform")
    self.ScrollbarVertical = go.transform:Find("content/ScrollView/ScrollbarVertical"):GetComponent("Scrollbar")
    self.linePanel = go.transform:Find("content/ScrollView/Viewport/Content/linePanel")

    self.salesBtn = go.transform:Find("content/ScrollView/Viewport/Content/linePanel/salesBtn")
    self.selectedSales = go.transform:Find("content/ScrollView/Viewport/Content/linePanel/salesBtn/selectedSales")
    self.salesVolumeBtn = go.transform:Find("content/ScrollView/Viewport/Content/linePanel/salesVolumeBtn")
    self.selectedSalesVolume = go.transform:Find("content/ScrollView/Viewport/Content/linePanel/salesVolumeBtn/selectedSalesVolume")
    self.testText = go.transform:Find("content/ScrollView/Viewport/Content/linePanel/testText"):GetComponent("Text")

    self.tipImg = go.transform:Find("content/tipImg")
    self.tipText = go.transform:Find("content/tipImg/tipText"):GetComponent("Text")

    self.itemMaterialBtn = go.transform:Find("content/ScrollView/Viewport/Content/itemMaterialBtn").gameObject
    self.itemGoodsBtn = go.transform:Find("content/ScrollView/Viewport/Content/itemGoodsBtn").gameObject
end
---------------------------------------------------------------初始化函数------------------------------------------------------------------------------
--初始化UI信息
function BuildingRevenueInfoCtrl:initializeUiInfo()
    if not self.revenueInfo.todaySaleDetail then
        self.tipImg.transform.localScale = Vector3.one
    else
        self.tipImg.transform.localScale = Vector3.zero
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            for key,value in pairs(self.revenueInfo.todaySaleDetail) do
                local obj = self:loadingItemPrefab(self.itemMaterialBtn,self.Content)
                local itemPrefab = itemMaterialBtn:new(value,obj,self.luaBehaviour,key)
                table.insert(self.itemPrefabTab,itemPrefab)
            end
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            for key,value in pairs(self.revenueInfo.todaySaleDetail) do
                local obj = self:loadingItemPrefab(self.itemGoodsBtn,self.Content)
                local itemPrefab = itemGoodsBtn:new(value,obj,self.luaBehaviour,key)
                table.insert(self.itemPrefabTab,itemPrefab)
            end
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            for key,value in pairs(self.revenueInfo.todaySaleDetail) do
                local obj = self:loadingItemPrefab(self.itemGoodsBtn,self.Content)
                local itemPrefab = itemGoodsBtn:new(value,obj,self.luaBehaviour,key)
                table.insert(self.itemPrefabTab,itemPrefab)
            end
        end
    end
end
--初始化打开面板信息
function BuildingRevenueInfoCtrl:initializePanelUiInfo(data)
    self.selectedSales.transform.localScale = Vector3.one
    self.selectedSalesVolume.transform.localScale = Vector3.zero
    if data.historyDetail then
        self.testText.text = GetLanguage(data.historyDetail[1].itemId).."七天的销售额是 E"..GetClientPriceString(data.historyDetail[1].saleDetail.income + data.account)
    else
        self.testText.text = GetLanguage(data.itemId).."七天的销售额是 E"..GetClientPriceString(data.account)
    end
end
--多语言
function BuildingRevenueInfoCtrl:language()
    self.tipText.text = "暂无详情"
    self.topName.text = "收入详情"
    self.todaySalesText.text = "今日销售额"
    self.proportionText.text = "占昨日销售额比例"
    --根据建筑显示是原料还是商品还是建筑名字（研究所）
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        self.goodsTypeText.text = "原料"
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        self.goodsTypeText.text = "商品"
    elseif self.m_data.buildingType == BuildingType.RetailShop then
        self.goodsTypeText.text = "商品"
    elseif self.m_data.buildingType == BuildingType.Municipal then
        self.goodsTypeText.text = "数据类型"
    elseif self.m_data.buildingType == BuildingType.Laboratory then
        self.goodsTypeText.text = "科技资料"
    end
end
-----------------------------------------------------------------------------回调函数-------------------------------------------------------------------------
--请求建筑经营详情成功
function BuildingRevenueInfoCtrl:revenueInfoData(data)
    if data ~= nil then
        self.revenueInfo = data
        --初始化UI信息
        self:initializeUiInfo()
    end
end
--请求建筑历史经营详情成功
function BuildingRevenueInfoCtrl:historyRevenueInfoData(data)
    if data ~= nil then
        dataInfo = data
        dataInfo.num = self.num
        dataInfo.itemId = self.itemId
        dataInfo.account = self.account
        self:openLinePanel(index)
        if isbool == false then
            return
        end
        if indexs == 1 then
            --self.Content.anchoredPosition = Vector3(0,0,0)
            self.Content:DOLocalMove(Vector2.New(0, 0),0.1):SetEase(DG.Tweening.Ease.Linear)
            self:initializePanelUiInfo(dataInfo)
        else
            self.timer:Start()
        end
    end
end
-----------------------------------------------------------------------------点击函数-------------------------------------------------------------------------
--关闭
function BuildingRevenueInfoCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--查看7天的销售额
function BuildingRevenueInfoCtrl:_clickSalesBtn(ins)
    PlayMusEff(1002)
    ins.selectedSales.transform.localScale = Vector3.one
    ins.selectedSalesVolume.localScale = Vector3.zero
    if dataInfo.historyDetail then
        ins.testText.text = GetLanguage(dataInfo.historyDetail[1].itemId).."七天的销售额是 E"..GetClientPriceString(dataInfo.historyDetail[1].saleDetail.income + dataInfo.account)
    else
        ins.testText.text = GetLanguage(dataInfo.itemId).."七天的销售额是 E"..GetClientPriceString(dataInfo.account)
    end
end
--查看7天的销售量
function BuildingRevenueInfoCtrl:_clickSalesVolumeBtn(ins)
    PlayMusEff(1002)
    ins.selectedSales.transform.localScale = Vector3.zero
    ins.selectedSalesVolume.localScale = Vector3.one
    if dataInfo.historyDetail then
        ins.testText.text = GetLanguage(dataInfo.historyDetail[1].itemId).."七天的销售量是 "..(dataInfo.historyDetail[1].saleDetail.saleNum + dataInfo.num).."个"
    else
        ins.testText.text = GetLanguage(dataInfo.itemId).."七天的销售量是 "..(dataInfo.num).."个"
    end
end
-----------------------------------------------------------------------------事件函数-------------------------------------------------------------------------
--计算位置
function BuildingRevenueInfoCtrl:calculateLinePanel(ins)
    index = ins.keyId
    --因为7天历史统计服不包括今天的，所以在查的时候缓存下今天的数据，方便查出来后把今天卖出去的数量加上
    self.itemId = ins.data.itemId
    self.num = ins.data.num
    self.account = ins.data.saleAccount
    if indexs == index and isbool == true then
        self:openLinePanel(index)
    else
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqBuildingHistoryRevenueInfo',self.m_data.id,tonumber(typeId),ins.data.itemId,ins.data.producerId)
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--打开折线图
function BuildingRevenueInfoCtrl:openLinePanel(index)
    if isbool == false then
        indexs = index
        self.linePanel.transform:SetSiblingIndex(index + 2)
        self.linePanel.gameObject:SetActive(true)
        isbool = true
    elseif indexs == index and isbool == true then
        indexs = nil
        self.linePanel.gameObject:SetActive(false)
        self.timer:Stop()
        isbool = false
    elseif indexs ~= index and isbool == true then
        indexs = index
        self.linePanel.transform:SetSiblingIndex(index + 2)
    end
end
function BuildingRevenueInfoCtrl:UpData()
    self.time = self.time - 0.1
    if self.time < 0.1 or self.time < 0 then
        self.time = 0.1
--[[        if indexs == #self.itemPrefabTab then
            --如果点击打开的是最后一个，直接把位置拉倒最后
            --self.ScrollbarVertical.value = 0
            self.Content:DOLocalMove(Vector2.New(0, 132 * (indexs - 1) + (indexs * 5)),0.1):SetEase(DG.Tweening.Ease.Linear)
        else
            --self.Content.anchoredPosition = Vector2.New(0, 132 * (indexs - 1) + (indexs * 5))
            self.Content:DOLocalMove(Vector2.New(0, 132 * (indexs - 1) + (indexs * 5)),0.1):SetEase(DG.Tweening.Ease.Linear)
        end]]
        --暂时不要效果，隐藏
        --self.Content:DOLocalMove(Vector2.New(0, 132 * (indexs - 1) + (indexs * 5)),0.1):SetEase(DG.Tweening.Ease.Linear)
        self:initializePanelUiInfo(dataInfo)
        self.timer:Stop()
    end
end
--加载实例化Prefab
function BuildingRevenueInfoCtrl:loadingItemPrefab(itemPrefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
    local objRect = obj.transform:GetComponent("RectTransform")
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one
    obj:SetActive(true)
    return obj
end
--关闭时清空
function BuildingRevenueInfoCtrl:CloseDestroy(dataTable)
    if next(dataTable) == nil then
        return
    else
        for key,valueObj in pairs(dataTable) do
            destroy(valueObj.prefab.gameObject)
            dataTable[key] = nil
        end
    end
end