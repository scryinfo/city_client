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
    return "ExchangeChooseWareHouse"
end

function ExchangeChooseWareHouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function ExchangeChooseWareHouseCtrl:Awake(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour');

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
end

function ExchangeChooseWareHouseCtrl:Close()
    --ExchangeDetailPanel.toggle01.onValueChanged:RemoveAllListeners()
end

function ExchangeChooseWareHouseCtrl:_initPanelData()
    self.luaBehaviour:AddClick(ExchangeChooseWareHousePanel.backBtn.gameObject, self.OnClickBack,self)
    if self.m_data.isSell then
        --遍历所有仓库，根据item的个数排序
        --需要建筑类型，大小，icon，最大容量-这几个可以通过id读配置表得到，建筑名字
        ExchangeChooseWareHouseCtrl.storeList = self:_getStoresData(PlayerTempModel.storeList, true, self.m_data.itemId)
    else
        --显示所有仓库的剩余量，多少排序
        --需要建筑类型，大小，icon-这几个可以通过id读配置表得到，建筑名字
        ExchangeChooseWareHouseCtrl.storeList = self:_getStoresData(PlayerTempModel.storeList, false)
    end
    ExchangeChooseWareHouseCtrl.wareHouseItems = {}
    if ExchangeChooseWareHouseCtrl.storeList ~= nil then
        ExchangeChooseWareHousePanel.wareHouseScroll:ActiveLoopScroll(self.chooseWareSource, #ExchangeChooseWareHouseCtrl.storeList)
    end
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

---sort
function ExchangeChooseWareHouseCtrl:_getSortDatas(datas, isSell)
    local tempDatas = datas
    if isSell then
        table.sort(tempDatas, function (m, n) return m.remainCount > n.remainCount end)
    else
        table.sort(tempDatas, function (m, n) return m.capacityCount > n.capacityCount end)
    end
    return tempDatas
end
--根据某个item的数量排序仓库数据
--需要建筑类型，大小，icon-这三个可以通过id读配置表得到，建筑名字，
function ExchangeChooseWareHouseCtrl:_getStoresData(datas, isSell, itemId)
    local tempDatas = datas

    if tempDatas == nil then return nil end

    if isSell then
        for i, storeItem in ipairs(tempDatas) do
            local totalCount = 0
            for j, usedItem in ipairs(storeItem.inHand) do
                if itemId == usedItem.id then
                    totalCount = totalCount + usedItem.num
                    break
                end
            end
            storeItem.totalCount = totalCount

            ---测试
            storeItem.buildingName = "Building"..i
            storeItem.isSell = true
        end
        table.sort(tempDatas, function (m, n) return m.totalCount > n.totalCount end)
    else
        for i, storeItem in ipairs(tempDatas) do
            local inUsedCount = 0
            for j, usedItem in ipairs(storeItem.inHand) do
                inUsedCount = inUsedCount + usedItem.num
            end
            storeItem.remainCapacity = PlayerBuildingBaseData[storeItem.buildingTypeId].storeCapacity - inUsedCount
            storeItem.inUsedCount = inUsedCount

            ---测试
            storeItem.buildingName = "Building"..i
            storeItem.isSell = false
        end
        table.sort(tempDatas, function (m, n) return m.remainCapacity > n.remainCapacity end)
    end
    return tempDatas
end