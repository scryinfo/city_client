---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/25 16:13
---数据出售DetailPart
DataSaleDetailPart = class('DataSaleDetailPart', BasePartDetail)
--
function DataSaleDetailPart:PrefabName()
    return "DataSaleDetailPart"
end
--
function  DataSaleDetailPart:_InitEvent()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getScienceShelfData","gs.ScienceShelfData",self.n_OnDataSale,self)
    Event.AddListener("c_AddShelf",self.c_AddShelf,self)
    Event.AddListener("c_DelShelf",self.c_DelShelf,self)
    Event.AddListener("c_SetShelf",self.c_SetShelf,self)
    Event.AddListener("c_BuyCount",self.c_BuyCount,self)
end
--
function DataSaleDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.m_LuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.emptyAdd, self.OnEmptyAdd, self)
    mainPanelLuaBehaviour:AddClick(self.add, self.OnAdd, self)
end
--
function DataSaleDetailPart:_ResetTransform()
    if self.dataSaleCardItem then
        for i, v in pairs(self.dataSaleCardItem) do
            destroy(v.prefab.gameObject)
        end
    end
end
--
function DataSaleDetailPart:_RemoveEvent()
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "getScienceShelfData",self.n_OnDataSale,self)
    Event.RemoveListener("c_AddShelf",self.c_AddShelf,self)
    Event.RemoveListener("c_DelShelf",self.c_DelShelf,self)
    Event.RemoveListener("c_SetShelf",self.c_SetShelf,self)
    Event.RemoveListener("c_BuyCount",self.c_BuyCount,self)
end
--
function DataSaleDetailPart:_RemoveClick()
end

function DataSaleDetailPart:Show(data)
    BasePartDetail.Show(self,data)
    Event.AddListener("part_SurveyLineUpData",self.SurveyLineUpData,self)
    DataManager.ModelSendNetMes("gscode.OpCode", "getScienceShelfData","gs.Id",{id = data.info.id})
end
function DataSaleDetailPart:Hide()
    BasePartDetail.Hide(self)
    Event.RemoveListener("part_SurveyLineUpData",self.SurveyLineUpData,self)
    self.noEmpty:SetActive(false)
    if self.dataSaleCardItem then
        for i, v in pairs(self.dataSaleCardItem) do
            destroy(v.prefab.gameObject)
        end
    end
    self.dataSaleCardItem = {}
end
--
function DataSaleDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
end

--
function DataSaleDetailPart:_InitTransform()
    self:_getComponent(self.transform)
end

--
function DataSaleDetailPart:_getComponent(transform)
    self.myOwnerID = DataManager.GetMyOwnerID()
    self.empty = transform:Find("contentRoot/empty")
    self.tipText = transform:Find("contentRoot/empty/tipText"):GetComponent("Text")
    self.emptyAdd = transform:Find("contentRoot/empty/add").gameObject
    self.noEmpty = transform:Find("contentRoot/noEmpty").gameObject
    self.add = transform:Find("contentRoot/noEmpty/add").gameObject
    self.scroll = transform:Find("contentRoot/noEmpty/Scroll View"):GetComponent("RectTransform")
    self.content = transform:Find("contentRoot/noEmpty/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    self.dataSaleCard = transform:Find("contentRoot/noEmpty/Scroll View/Viewport/Content/DataSaleCardItem").gameObject
end

--货架详情回调
function DataSaleDetailPart:n_OnDataSale(info)
    if next(info.shelf) == nil then
        self:_isEmpty(true)
    else
        self:_isEmpty(false)
        self.dataSaleCardItem = {}
        for i, v in ipairs(info.shelf.good) do
            local prefabs = self:createPrefab(self.dataSaleCard,self.content)
            if self.m_data.info.ownerId == self.myOwnerID  then
                self.dataSaleCardItem[i] = DataSaleCardItem:new(self.m_LuaBehaviour,prefabs,v,info.buildingId,true,self.myOwnerID)
            else
                self.dataSaleCardItem[i] = DataSaleCardItem:new(self.m_LuaBehaviour,prefabs,v,info.buildingId,false,self.myOwnerID)
            end
        end
    end
end

function DataSaleDetailPart:_isEmpty(empty)
    if empty then
        if self.m_data.info.ownerId == self.myOwnerID then
            self.emptyAdd.transform.localScale = Vector3.one
        else
            self.emptyAdd.transform.localScale = Vector3.zero
        end
        self.empty.localScale = Vector3.one
        self.noEmpty:SetActive(false)
    else
        if self.m_data.info.ownerId == self.myOwnerID then
            self.add:SetActive(true)
            self.scroll.anchoredPosition = Vector3.New(843,-229,0)
        else
            self.add:SetActive(false)
            self.scroll.anchoredPosition = Vector3.New(535,-229,0)
        end
        self.empty.localScale = Vector3.zero
        self.noEmpty:SetActive(true)
    end
end

--点击空白界面添加
function DataSaleDetailPart:OnEmptyAdd(go)
    local data = {}
    data.insId = go.m_data.info.id
    data.type = DataType.DataSale
    ct.OpenCtrl("ChooseDataTypeCtrl",data)
end

--点击Add
function DataSaleDetailPart:OnAdd(go)
    local data = {}
    data.insId = go.m_data.info.id
    data.type = DataType.DataSale
    ct.OpenCtrl("ChooseDataTypeCtrl",data)
end

function DataSaleDetailPart:createPrefab(prefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(prefab)
    local objRect = obj.transform:GetComponent("RectTransform")
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one
    objRect.transform.localPosition = Vector3.zero
    obj:SetActive(true)
    return obj
end

--上架回调
function DataSaleDetailPart:c_AddShelf(info)
    if self.dataSaleCardItem == nil or next(self.dataSaleCardItem) == nil then
        self:_isEmpty(false)
    end
    local prefabs = self:createPrefab(self.dataSaleCard,self.content)
    local data = {}
    data.autoReplenish = info.autoRepOn
    data.k = info.item.key
    data.n = info.item.n
    data.price = info.price
    data.storeNum = info.storeNum
    local temp
    if self.m_data.info.ownerId == self.myOwnerID  then
        temp = DataSaleCardItem:new(self.m_LuaBehaviour,prefabs,data,info.buildingId,true,self.myOwnerID)
    else
        temp = DataSaleCardItem:new(self.m_LuaBehaviour,prefabs,data,info.buildingId,false,self.myOwnerID)
    end
    if self.dataSaleCardItem == nil then
        self.dataSaleCardItem = {}
    end
    table.insert(self.dataSaleCardItem,temp)
end

--下架回调
function DataSaleDetailPart:c_DelShelf(info)
    if self.dataSaleCardItem then
        local index
        for i, v in pairs(self.dataSaleCardItem) do
            if v.type == info.item.key.id then
                index = i
                destroy(v.prefab.gameObject)
            end
        end
        if index then
            table.remove(self.dataSaleCardItem,index)
        end
        if next(self.dataSaleCardItem) == nil then
            self:_isEmpty(true)
        end
    end
end

--修改回调
function DataSaleDetailPart:c_SetShelf(info)
    UIPanel.ClosePage()
    if self.dataSaleCardItem then
        for i, v in pairs(self.dataSaleCardItem) do
            if v.type == info.item.key.id then
                v.n = info.item.n
                v.storeNum = info.storeNum
                v.prices = info.price
                v.autoReplenish = info.autoRepOn
                if info.autoRepOn then
                    v.auto.localScale = Vector3.one
                else
                    v.auto.localScale = Vector3.zero
                end
                v.num.text = "x" .. info.item.n
                v.price.text = GetClientPriceString(info.price)
            end
        end
    end
end

--购买点数回调
function DataSaleDetailPart:c_BuyCount(info)
    if self.dataSaleCardItem and next(self.dataSaleCardItem) then
        local index
        for i, v in pairs(self.dataSaleCardItem) do
            if v.type == info.item.key.id then
                v.n = v.n - info.item.n
                v.num.text = "x" .. v.n
                if v.n <= 0 then
                   index = i
                    destroy(v.prefab.gameObject)
                end
            end
        end
        if index then
            table.remove(self.dataSaleCardItem,index)
        end
        if next(self.dataSaleCardItem) == nil then
            self:_isEmpty(true)
        end
    end
end

--调查线变化
function DataSaleDetailPart:SurveyLineUpData(info)
    if self.dataSaleCardItem and next(self.dataSaleCardItem) then
        for i, v in pairs(self.dataSaleCardItem) do
            if v.type == info.iKey.id then
                if v.autoReplenish then
                    v.n = info.nowCountInLocked
                    v.num.text = "x" .. v.n
                    v.storeNum = 0
                else
                    v.storeNum = info.nowCountInStore
                end
            end
        end
    end
end