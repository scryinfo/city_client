---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/7/24 14:39
---建筑经营详情

BuildingRevenueInfoCtrl = class('BuildingRevenueInfoCtrl',UIPanel)
UIPanel:ResgisterOpen(BuildingRevenueInfoCtrl)

local indexs   --用来记录经营界面当前折线图索引
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
end

function BuildingRevenueInfoCtrl:Active()
    UIPanel.Active(self)
    indexs = nil
    isbool = false
    --实例表
    self.itemPrefabTab = {}
    self.buildingType = BuildingType.Laboratory    --后边传数据进来要删除
    self:language()
    Event.AddListener("calculateLinePanel",self.calculateLinePanel,self)
end

function BuildingRevenueInfoCtrl:Refresh()
    if self.buildingType == BuildingType.MaterialFactory then
        self.topMaterialType.transform.localScale = Vector3.one
    elseif self.buildingType == BuildingType.ProcessingFactory then
        self.topGoodsType.transform.localScale = Vector3.one
    elseif self.buildingType == BuildingType.RetailShop then
    elseif self.buildingType == BuildingType.Municipal then
    elseif self.buildingType == BuildingType.Laboratory then
        self.topMaterialType.transform.localScale = Vector3.one
    end
    self:initializeUiBuildingInfo()
end

function BuildingRevenueInfoCtrl:Hide()
    UIPanel.Hide(self)
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
    --topMaterialType
    self.topMaterialType = go.transform:Find("topRoot/topMaterialType")
    self.goodsTypeText = go.transform:Find("topRoot/topMaterialType/goodsType/Text"):GetComponent("Text")
    self.todaySalesText = go.transform:Find("topRoot/topMaterialType/todaySales/Text"):GetComponent("Text")
    self.proportionText = go.transform:Find("topRoot/topMaterialType/proportion/Text"):GetComponent("Text")
    --topGoodsType
    self.topGoodsType = go.transform:Find("topRoot/topGoodsType")
    self._goodsTypeText = go.transform:Find("topRoot/topGoodsType/goodsType/Text"):GetComponent("Text")
    self.typeNameText = go.transform:Find("topRoot/topGoodsType/typeName/Text"):GetComponent("Text")
    self._todaySalesText = go.transform:Find("topRoot/topGoodsType/todaySales/Text"):GetComponent("Text")
    self._proportionText = go.transform:Find("topRoot/topGoodsType/proportion/Text"):GetComponent("Text")
    ---content
    --Content
    self.Content = go.transform:Find("content/ScrollView/Viewport/Content")
    self.linePanel = go.transform:Find("content/ScrollView/Viewport/Content/linePanel")
    self.itemMaterialBtn = go.transform:Find("content/ScrollView/Viewport/Content/itemMaterialBtn").gameObject
    self.itemGoodsBtn = go.transform:Find("content/ScrollView/Viewport/Content/itemGoodsBtn").gameObject
end
---------------------------------------------------------------初始化函数------------------------------------------------------------------------------
--初始化UI信息
function BuildingRevenueInfoCtrl:initializeUiBuildingInfo()
    --模拟数据--
    local datas = {}
    --随机数种子
    math.randomseed(os.time())

    if self.buildingType == BuildingType.MaterialFactory then
        for i = 1, 10 do
            local data = {}
            data.name = "小麦"..i
            data.itemId = 2101001
            data.todaySales = math.random(500,20000)
            data.proportion = math.random(1,3000)
            table.insert(datas,data)
        end
        for key,value in pairs(datas) do
            local obj = self:loadingItemPrefab(self.itemMaterialBtn,self.Content)
            local itemPrefab = itemMaterialBtn:new(value,obj,self.luaBehaviour,key)
            table.insert(self.itemPrefabTab,itemPrefab)
        end
    elseif self.buildingType == BuildingType.ProcessingFactory then
        for i = 1, 10 do
            local data = {}
            data.name = "小麦"..i
            data.itemId = 2101001
            data.brandName = "小麦牌"..i
            data.todaySales = math.random(500,20000)
            data.proportion = math.random(1,3000)
            table.insert(datas,data)
        end
        for key,value in pairs(datas) do
            local obj = self:loadingItemPrefab(self.itemGoodsBtn,self.Content)
            local itemPrefab = itemGoodsBtn:new(value,obj,self.luaBehaviour,key)
            table.insert(self.itemPrefabTab,itemPrefab)
        end
    elseif self.buildingType == BuildingType.RetailShop then
    elseif self.buildingType == BuildingType.Municipal then
    elseif self.buildingType == BuildingType.Laboratory then
        for i = 1, 10 do
            local data = {}
            data.name = "零售店"..i
            data.mId = 1300001
            data.todaySales = math.random(500,20000)
            data.proportion = math.random(1,3000)
            table.insert(datas,data)
        end
        for key,value in pairs(datas) do
            local obj = self:loadingItemPrefab(self.itemMaterialBtn,self.Content)
            local itemPrefab = itemMaterialBtn:new(value,obj,self.luaBehaviour,key)
            table.insert(self.itemPrefabTab,itemPrefab)
        end
    end
end
--多语言
function BuildingRevenueInfoCtrl:language()
    --根据建筑显示是原料还是商品还是建筑名字（研究所）
    if self.buildingType == BuildingType.MaterialFactory then
        self.goodsTypeText.text = "原料"
    elseif self.buildingType == BuildingType.ProcessingFactory then
        self.goodsTypeText.text = "商品"
    elseif self.buildingType == BuildingType.RetailShop then
        self.goodsTypeText.text = "商品"
    elseif self.buildingType == BuildingType.Municipal then
        self.goodsTypeText.text = "数据类型"
    elseif self.buildingType == BuildingType.Laboratory then
        self.goodsTypeText.text = "科技资料"
    end
    self.todaySalesText.text = "今日销售额"
    self.proportionText.text = "占昨日销售额比例"
end
-----------------------------------------------------------------------------点击函数-------------------------------------------------------------------------
--关闭
function BuildingRevenueInfoCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

-----------------------------------------------------------------------------事件函数-------------------------------------------------------------------------
--计算位置
function BuildingRevenueInfoCtrl:calculateLinePanel(index)
    self:openLinePanel(index)
    if isbool == false then
        return
    end
    if index == 1 then
        self.Content.transform.localPosition = Vector3(0,0,0)
    else
        self.Content.transform:GetComponent("RectTransform").anchoredPosition = Vector2.New(0, 225 * (index - 1))
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--打开折线图
function BuildingRevenueInfoCtrl:openLinePanel(index)
    if indexs == nil and isbool == false then
        indexs = index
        self.linePanel.transform:SetSiblingIndex(index + 2)
        self.linePanel.gameObject:SetActive(true)
        isbool = true
    elseif indexs == index and isbool == true then
        indexs = nil
        self.linePanel.gameObject:SetActive(false)
        isbool = false
    elseif indexs ~= index and isbool == true then
        indexs = index
        self.linePanel.transform:SetSiblingIndex(index + 2)
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