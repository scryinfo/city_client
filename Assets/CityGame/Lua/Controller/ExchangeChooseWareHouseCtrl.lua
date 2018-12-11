---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/25 10:44
---
ExchangeChooseWareHouseCtrl = class('ExchangeChooseWareHouseCtrl',UIPage)
UIPage:ResgisterOpen(ExchangeChooseWareHouseCtrl)

function ExchangeChooseWareHouseCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ExchangeChooseWareHouseCtrl:bundleName()
    return "ExchangeChooseWareHousePanel"
end

function ExchangeChooseWareHouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function ExchangeChooseWareHouseCtrl:Awake(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour')

    self.chooseWareSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.chooseWareSource.mProvideData = ExchangeChooseWareHouseCtrl.static.ChooseWareProvideData
    self.chooseWareSource.mClearData = ExchangeChooseWareHouseCtrl.static.ChooseWareClearData
end

function ExchangeChooseWareHouseCtrl:Refresh()
    self:_initPanelData()
end

function ExchangeChooseWareHouseCtrl:Hide()
    UIPage.Hide(self)
    self.luaBehaviour:RemoveClick(ExchangeChooseWareHousePanel.backBtn.gameObject, self.OnClickBack, self)
    Event.RemoveListener("m_OnReceiveAllBuildingDetail", self._getBuildingDetailFunc, self)

    --ExchangeChooseWareHousePanel.wareHouseScroll:ActiveLoopScroll(self.chooseWareSource, 0)
end

function ExchangeChooseWareHouseCtrl:Close()
    --ExchangeDetailPanel.toggle01.onValueChanged:RemoveAllListeners()
end

function ExchangeChooseWareHouseCtrl:_initPanelData()
    self.luaBehaviour:AddClick(ExchangeChooseWareHousePanel.backBtn.gameObject, self.OnClickBack,self)
    Event.AddListener("m_OnReceiveAllBuildingDetail", self._getBuildingDetailFunc, self)
    Event.Brocast("m_ReqAllBuildingDetail")
end
--收到建筑信息之后再显示
function ExchangeChooseWareHouseCtrl:_getBuildingDetailFunc(data)
    local buildingInfo = self:_getAllStoreBuildings(data)
    if self.m_data.isSell then
        --遍历所有仓库，根据item的个数排序
        --需要建筑类型，大小，icon，最大容量-这几个可以通过id读配置表得到，建筑名字
        ExchangeChooseWareHouseCtrl.storeList = self:_getStoresData(buildingInfo, true, self.m_data.itemId)
    else
        --显示所有仓库的剩余量，多少排序
        --需要建筑类型，大小，icon-这几个可以通过id读配置表得到，建筑名字
        ExchangeChooseWareHouseCtrl.storeList = self:_getStoresData(buildingInfo, false)
    end
    ExchangeChooseWareHouseCtrl.wareHouseItems = {}
    if ExchangeChooseWareHouseCtrl.storeList ~= nil then
        ExchangeChooseWareHousePanel.wareHouseScroll:ActiveLoopScroll(self.chooseWareSource, #ExchangeChooseWareHouseCtrl.storeList)
    end
end
--获取所有带有store的建筑table
function ExchangeChooseWareHouseCtrl:_getAllStoreBuildings(data)
    local tempTable = {}
    if data.materialFactory then
        for i, building in ipairs(data.materialFactory) do
            tempTable[#tempTable + 1] = building
        end
    end
    if data.produceDepartment then
        for i, building in ipairs(data.produceDepartment) do
            tempTable[#tempTable + 1] = building
        end
    end
    if data.retailShop then
        for i, building in ipairs(data.retailShop) do
            tempTable[#tempTable + 1] = building
        end
    end
    if data.laboratory then
        for i, building in ipairs(data.laboratory) do
            tempTable[#tempTable + 1] = building
        end
    end
    return tempTable
end

function ExchangeChooseWareHouseCtrl:OnClickBack()
    UIPage.ClosePage()
end

---滑动复用
ExchangeChooseWareHouseCtrl.static.ChooseWareProvideData = function(transform, idx)
    idx = idx + 1
    local chooseItem = ExchangeWareHouseItem:new(ExchangeChooseWareHouseCtrl.storeList[idx], transform)
    ExchangeChooseWareHouseCtrl.wareHouseItems[idx] = chooseItem
end
ExchangeChooseWareHouseCtrl.static.ChooseWareClearData = function(transform)
end

--根据某个item的数量排序仓库数据
--需要建筑类型，大小，icon-这三个可以通过id读配置表得到，建筑名字，
function ExchangeChooseWareHouseCtrl:_getStoresData(datas, isSell, itemId)
    local tempDatas = {}
    if isSell then
        local buildingsStore = {}
        for i, building in pairs(datas) do
            if building.store then
                if getItemStore(building.store)[itemId] then
                    buildingsStore[#buildingsStore + 1] = {itemCount = getItemStore(building.store)[itemId], buildingTypeId = building.info.mId, buildingId = building.info.id, isSell = true, buildingName = "Building"..(#buildingsStore + 1)}
                end
            end
        end
        tempDatas = buildingsStore
        table.sort(tempDatas, function (m, n) return m.itemCount > n.itemCount end)
    else
        local buildingsStore = {}
        for i, building in pairs(datas) do
            if building.store then
                buildingsStore[#buildingsStore + 1] = {remainCapacity = self:_getRemianSpace(building.store, building.info.mId), buildingTypeId = building.info.mId, buildingId = building.info.id, isSell = false, buildingName = "Building"..(#buildingsStore + 1)}
            end
        end
        tempDatas = buildingsStore
        table.sort(tempDatas, function (m, n) return m.remainCapacity > n.remainCapacity end)
    end
    return tempDatas
end

--获取仓库还剩多少容量
function ExchangeChooseWareHouseCtrl:_getRemianSpace(store, buildTypeId)
    local totalCount = PlayerBuildingBaseData[buildTypeId].storeCapacity
    local inUsedCount = 0
    if store.reserved then
        for i, itemData in pairs(store.reserved) do
            inUsedCount = inUsedCount + itemData.num
        end
    end
    if store.inHand then
        for i, itemData in pairs(store.inHand) do
            inUsedCount = inUsedCount + itemData.num
        end
    end
    return totalCount - inUsedCount
end