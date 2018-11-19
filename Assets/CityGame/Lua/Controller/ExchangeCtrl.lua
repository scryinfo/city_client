---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/15 17:16
---交易所
ExchangeTitleType =
{
    Quotes = 1,
    Collect = 2,
    Record = 3,
}
ExchangeRecordTitleType =
{
    Entrustment = 1,  --当前成交进度
    SelfRecord = 2,
    CityRecord = 3,
}

ExchangeCtrl = class('ExchangeCtrl',UIPage)
UIPage:ResgisterOpen(ExchangeCtrl)

function ExchangeCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ExchangeCtrl:bundleName()
    return "ExchangePanel"
end

function ExchangeCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
    --关闭面板
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    LuaBehaviour:AddClick(ExchangePanel.backBtn.gameObject, function()
        UIPage.ClosePage()
    end )
end

function ExchangeCtrl:Awake(go)
    self.gameObject = go
    ExchangeCtrl.static.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.sortMgr = ExchangeSortMgr:new(ExchangePanel.titleRoot)
    self.collectSortMgr = ExchangeSortMgr:new(ExchangePanel.collectTitleRoot)

    --行情收藏记录toggle
    ExchangePanel.quotesToggle.onValueChanged:AddListener(function (isOn)
        self: _quotesToggleValueChange(isOn)
    end)
    ExchangePanel.collectToggle.onValueChanged:AddListener(function (isOn)
        self:_collectToggleValueChange(isOn)
    end)
    ExchangePanel.recordToggle.onValueChanged:AddListener(function (isOn)
        self:_recordToggleValueChange(isOn)
    end)
    --记录总toggle
    ExchangePanel.entrustmentToggle.onValueChanged:AddListener(function (isOn)
        self:_entrustmentToggleValueChange(isOn)
    end)
    ExchangePanel.selfRecordToggle.onValueChanged:AddListener(function (isOn)
        self:_selfRecordToggleValueChange(isOn)
    end)
    ExchangePanel.cityRecordToggle.onValueChanged:AddListener(function (isOn)
        self:_cityRecordToggleValueChange(isOn)
    end)
    --ExchangePanel.cityRecordDropfresh.mOnDropfresh = self._cityRecordDropfresh
    --ExchangePanel.cityRecordDropfresh.mOnDropfresh:InitDropFresh(0.75)

    --滑动复用部分
    self.quotesSource = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.quotesSource.mProvideData = ExchangeCtrl.static.QuotesProvideData
    self.quotesSource.mClearData = ExchangeCtrl.static.QuotesClearData
    self.collectSource = UnityEngine.UI.LoopScrollDataSource.New()  --收藏
    self.collectSource.mProvideData = ExchangeCtrl.static.CollectProvideData
    self.collectSource.mClearData = ExchangeCtrl.static.CollectClearData
    self.entrustmentSource = UnityEngine.UI.LoopScrollDataSource.New()  --记录委托
    self.entrustmentSource.mProvideData = ExchangeCtrl.static.EntrustmentProvideData
    self.entrustmentSource.mClearData = ExchangeCtrl.static.EntrustmentClearData
    self.selfRecordSource = UnityEngine.UI.LoopScrollDataSource.New()  --自己的成交记录
    self.selfRecordSource.mProvideData = ExchangeCtrl.static.SelfRecordProvideData
    self.selfRecordSource.mClearData = ExchangeCtrl.static.SelfRecordClearData
    self.cityRecordSource = UnityEngine.UI.LoopScrollDataSource.New()  --全城成交记录
    self.cityRecordSource.mProvideData = ExchangeCtrl.static.CityRecordProvideData
    self.cityRecordSource.mClearData = ExchangeCtrl.static.CityRecordClearData
end

function ExchangeCtrl:Refresh()
    self:_initPanelData()
end

function ExchangeCtrl:Close()
    ExchangePanel.quotesToggle.onValueChanged:RemoveAllListeners()
    ExchangePanel.collectToggle.onValueChanged:RemoveAllListeners()
    ExchangePanel.recordToggle.onValueChanged:RemoveAllListeners()
    ExchangePanel.entrustmentToggle.onValueChanged:RemoveAllListeners()
    ExchangePanel.selfRecordToggle.onValueChanged:RemoveAllListeners()
    ExchangePanel.cityRecordToggle.onValueChanged:RemoveAllListeners()
end

function ExchangeCtrl:_addListener()
    Event.AddListener("c_onExchangeSort", self._exchangeSortByValue, self)
    Event.AddListener("c_onChangeCollectState", self._changeCollectState, self)
    Event.AddListener("c_onExchangeOrderCanel", self._deleteOrder, self)

    Event.AddListener("c_onReceiveExchangeItemList", self.c_onReceiveExchangeItemList, self)
    Event.AddListener("c_onReceiveExchangeMyOrder", self._getEntrustmentRecord, self)
    Event.AddListener("c_onReceiveExchangeMyDealLog", self._getTransactionRecord, self)
    Event.AddListener("c_onReceiveExchangeAllDealLog", self._getCityRecord, self)
    Event.AddListener("c_onReceiveExchangeDeal", self._getCityRecord, self)

end
function ExchangeCtrl:_removeListener()
    --Event.RemoveListener("c_onExchangeSort", self._exchangeSortByValue, self)
end

function ExchangeCtrl:_initPanelData()
    self:_addListener()

    --设置默认行情打开
    ExchangePanel._quotesToggleState(true)
    ExchangePanel._collectToggleState(false)
    ExchangePanel._recordToggleState(false)
    ExchangePanel.collectPage.localScale = Vector3.zero
    ExchangePanel.recordPage.localScale = Vector3.zero

    self.isStartToggle = false
    ExchangePanel.quotesToggle.isOn = true
    ExchangePanel.collectToggle.isOn = false
    ExchangePanel.recordToggle.isOn = false
    self.isStartToggle = true

    ExchangeCtrl.quoteItems = {}
    ExchangeCtrl.collectItems = {}
    ExchangeCtrl.entrustmentItems = {}
    ExchangeCtrl.selfRecordItems = {}
    ExchangeCtrl.cityRecordItems = {}

    self:_creatGoodsConfig()

    Event.Brocast("m_ReqExchangeItemList")
end
---根据配置表创建所有item
--require("Config/Material")
function ExchangeCtrl:_creatGoodsConfig()
    local datas = {}
    for k, itemMat in pairs(Material) do
        datas[itemMat.itemId] = itemMat
        datas[itemMat.itemId].lowPrice = 0.00
        datas[itemMat.itemId].highPrice = 0.00
        datas[itemMat.itemId].nowPrice = 0.00
        datas[itemMat.itemId].sumDealedPrice = 0.00
        datas[itemMat.itemId].priceChange = 0.00
    end
    ExchangeCtrl.quoteConfigDatas = datas
end

---行情收藏记录的toggle
function ExchangeCtrl:_quotesToggleValueChange(isOn)
    if not self.isStartToggle then
        return
    end

    ExchangePanel.noTipText.transform.localScale = Vector3.zero
    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Quotes then
            ExchangePanel._quotesToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Quotes

            if #ExchangeCtrl.quoteDatas == 0 then
                return
            else
                self.sortMgr:_reSetSortData()  --按照默认排序
                ExchangePanel.quotesPage.localScale = Vector3.one
                ExchangePanel.quotesScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.quoteDatas)
            end
        end
    else
        if ExchangeCtrl.titleType == ExchangeTitleType.Quotes then
            ExchangePanel._quotesToggleState(isOn)
            ExchangePanel.quotesPage.localScale = Vector3.zero
        end
    end
end
function ExchangeCtrl:_collectToggleValueChange(isOn)
    if not self.isStartToggle then
        return
    end

    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Collect then
            ExchangePanel._collectToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Collect

            if #ExchangeCtrl.collectDatas == 0 then
                ExchangePanel.noTipText.text = "Currently no collection!"
                ExchangePanel.noTipText.transform.localScale = Vector3.one
                ExchangePanel.collectPage.localScale = Vector3.zero
                return
            else
                self.collectSortMgr:_reSetSortData()  --按照默认排序
                ExchangePanel.collectPage.localScale = Vector3.one
                ExchangePanel.noTipText.transform.localScale = Vector3.zero
                ExchangePanel.collectScroll:ActiveLoopScroll(self.collectSource, #ExchangeCtrl.collectDatas)
            end
        end
    else
        if ExchangeCtrl.titleType == ExchangeTitleType.Collect then
            ExchangePanel._collectToggleState(isOn)
            ExchangePanel.collectPage.localScale = Vector3.zero
        end
    end
end
function ExchangeCtrl:_recordToggleValueChange(isOn)
    if not self.isStartToggle then
        return
    end

    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
            --判断是否有数据，没有的话，就显示提示 text
            --打开详情界面
            ExchangePanel._recordToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Record
            self:_recordRootInit()
        end
    else
        if ExchangeCtrl.titleType == ExchangeTitleType.Record then
            ExchangePanel._recordToggleState(isOn)
            ExchangePanel.recordPage.localScale = Vector3.zero
        end
    end
end
---记录界面的toggle
function ExchangeCtrl:_recordRootInit()
    ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.CityRecord  --默认打开成交进度
    ExchangePanel._entrustmentToggleState(true)
    ExchangePanel._selfRecordToggleState(false)
    ExchangePanel._cityRecordToggleState(false)
    ExchangePanel.recordPage.localScale = Vector3.one

    self.recordStartToggle = false
    ExchangePanel.entrustmentToggle.isOn = true
    ExchangePanel.selfRecordToggle.isOn = false
    ExchangePanel.cityRecordToggle.isOn = false
    self.recordStartToggle = true
    self:_entrustmentToggleValueChange(true)
end

function ExchangeCtrl:_entrustmentToggleValueChange(isOn)
    if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
        return
    end
    if not self.recordStartToggle then
        return
    end

    if isOn then
        if ExchangeCtrl.recordTitleType ~= ExchangeRecordTitleType.Entrustment then
            ExchangePanel._entrustmentToggleState(isOn)
            ExchangePanel._cityRecordToggleState(not isOn)
            ExchangePanel._selfRecordToggleState(not isOn)
            ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.Entrustment

            Event.Brocast("m_ReqExchangeMyOrder")
        end
    else
        ExchangePanel._entrustmentToggleState(isOn)
    end
end
function ExchangeCtrl:_selfRecordToggleValueChange(isOn)
    if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
        return
    end
    if not self.recordStartToggle then
        return
    end

    if isOn then
        if ExchangeCtrl.recordTitleType ~= ExchangeRecordTitleType.SelfRecord then
            ExchangePanel._selfRecordToggleState(isOn)
            ExchangePanel._cityRecordToggleState(not isOn)
            ExchangePanel._entrustmentToggleState(not isOn)
            ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.SelfRecord

            Event.Brocast("m_ReqExchangeMyDealLog")
            ---请求服务器信息，当前模拟已经有数据
            --self:_getTransactionRecord()
        end
    else
        ExchangePanel._selfRecordToggleState(isOn)
    end
end
function ExchangeCtrl:_cityRecordToggleValueChange(isOn)
    if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
        return
    end
    if not self.recordStartToggle then
        return
    end

    if isOn then
        if ExchangeCtrl.recordTitleType ~= ExchangeRecordTitleType.CityRecord then
            ExchangePanel._cityRecordToggleState(isOn)
            ExchangePanel._entrustmentToggleState(not isOn)
            ExchangePanel._selfRecordToggleState(not isOn)
            ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.CityRecord

            Event.Brocast("m_ReqExchangeAllDealLog")
            -----请求服务器信息，当前模拟已经有数据
            --self:_getCityRecord()
        end
    else
        ExchangePanel._cityRecordToggleState(isOn)
    end
end

---滑动复用
--行情
ExchangeCtrl.static.QuotesProvideData = function(transform, idx)
    idx = idx + 1
    local item = ExchangeQuoteItem:new(ExchangeCtrl.quoteDatas[idx], transform)
    ExchangeCtrl.quoteItems[idx] = item
end
ExchangeCtrl.static.QuotesClearData = function(transform)
end
--收藏
ExchangeCtrl.static.CollectProvideData = function(transform, idx)
    idx = idx + 1
    local collectItem = ExchangeQuoteItem:new(ExchangeCtrl.collectDatas[idx], transform)
    ExchangeCtrl.collectItems[idx] = collectItem
end
ExchangeCtrl.static.CollectClearData = function(transform)
end
--交易委托
ExchangeCtrl.static.EntrustmentProvideData = function(transform, idx)
    idx = idx + 1
    ExchangeCtrl.entrustmentInfo[idx].idInTable = idx
    local entrustmentItem = RecordEntrustmentItem:new(ExchangeCtrl.entrustmentInfo[idx], transform)
    ExchangeCtrl.entrustmentItems[idx] = entrustmentItem
end
ExchangeCtrl.static.EntrustmentClearData = function(transform)
end

--自己的成交记录
ExchangeCtrl.static.SelfRecordProvideData = function(transform, idx)
    idx = idx + 1
    local selfRecordItem = RecordTransactionItem:new(ExchangeCtrl.selfRecordInfo[idx], transform)
    ExchangeCtrl.selfRecordItems[idx] = selfRecordItem
end
ExchangeCtrl.static.SelfRecordClearData = function(transform)
end

--全城成交记录
ExchangeCtrl.static.CityRecordProvideData = function(transform, idx)
    idx = idx + 1
    local cityRecordItem = RecordTransactionItem:new(ExchangeCtrl.cityRecordInfo[idx], transform)
    ExchangeCtrl.cityRecordItems[idx] = cityRecordItem
end
ExchangeCtrl.static.CityRecordClearData = function(transform)
end

---排序
function ExchangeCtrl:_exchangeSortByValue(sortData)
    if ExchangeCtrl.titleType == ExchangeTitleType.Quotes then  --行情的排序
        ExchangeCtrl.quoteDatas = self:_getSortDatas(ExchangeCtrl.quoteDatas, sortData)
        ExchangePanel.quotesScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.quoteDatas)

    elseif ExchangeCtrl.titleType == ExchangeTitleType.Collect then
        ExchangeCtrl.collectDatas = self:_getSortDatas(ExchangeCtrl.collectDatas, sortData)
        ExchangePanel.collectScroll:ActiveLoopScroll(self.collectSource, #ExchangeCtrl.collectDatas)
    end
end
--获取收藏的数据
function ExchangeCtrl:_getCollectDatas(totalDatas)
    local collectDatas = {}
    for i, data in ipairs(totalDatas) do
        if data.isCollected then
            collectDatas[#collectDatas + 1] = data
        end
    end
    return collectDatas
end
--根据属性排序table
function ExchangeCtrl:_getSortDatas(datas, sortData)
    local tempDatas = datas
    local sortType = sortData.sortItemType
    local isSmaller = sortData.isSmaller
    if sortType == ExchangeSortItemType.Name then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.name > n.name end)
        else
            table.sort(tempDatas, function (m, n) return m.name < n.name end)
        end
    elseif sortType == ExchangeSortItemType.High then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.highPrice > n.highPrice end)
        else
            table.sort(tempDatas, function (m, n) return m.highPrice < n.highPrice end)
        end
    elseif sortType == ExchangeSortItemType.Change then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.priceChange > n.priceChange end)
        else
            table.sort(tempDatas, function (m, n) return m.priceChange < n.priceChange end)
        end
    elseif sortType == ExchangeSortItemType.LastPrice then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.nowPrice > n.nowPrice end)
        else
            table.sort(tempDatas, function (m, n) return m.nowPrice < n.nowPrice end)
        end
    elseif sortType == ExchangeSortItemType.Low then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.lowPrice > n.lowPrice end)
        else
            table.sort(tempDatas, function (m, n) return m.lowPrice < n.lowPrice end)
        end
    elseif sortType == ExchangeSortItemType.Volume then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.sumDealedPrice > n.sumDealedPrice end)
        else
            table.sort(tempDatas, function (m, n) return m.sumDealedPrice < n.sumDealedPrice end)
        end
    end

    return tempDatas
end
--获取顺序表
function ExchangeCtrl:_getListTable(dicTable)
    local tempTable = {}
    for key, value in pairs(dicTable) do
        tempTable[#tempTable + 1] = value
    end
    return tempTable
end
--更改收藏状态
function ExchangeCtrl:_changeCollectState(isCollected, itemId)
    if isCollected then
        --向服务器发送取消收藏的信息
        Event.Brocast("m_ReqExchangeUnCollect", itemId)
        self:_changeCollectData(false, itemId)
    else
        Event.Brocast("m_ReqExchangeCollect", itemId)
        self:_changeCollectData(true, itemId)
    end
end
function ExchangeCtrl:_changeCollectData(isCollected, itemId)
    for i, data in ipairs(ExchangeCtrl.collectDatas) do
        --如果之前存在于数组中，则是由收藏变为取消收藏
        if data.itemId == itemId then
            data.isCollected = isCollected
            ExchangeCtrl.quoteDatas[i].isCollected = false
            ExchangeCtrl.quoteConfigDatas[itemId].isCollected = false
            table.remove(ExchangeCtrl.collectDatas, i)
            table.remove(ExchangeCtrl.collectItems, i)
            return
        end
    end
    --ExchangeCtrl.collectItems[#ExchangeCtrl.collectItems + 1] = ExchangeCtrl.quoteDatas[itemId]

    for i, itemData in ipairs(ExchangeCtrl.quoteDatas) do
        if itemData.itemId == itemId then
            ExchangeCtrl.quoteDatas[i].isCollected = true
            ExchangeCtrl.quoteConfigDatas[itemId].isCollected = true
            ExchangeCtrl.collectDatas[#ExchangeCtrl.collectDatas + 1] = ExchangeCtrl.quoteDatas[i]
            return
        end
    end
end
--取消挂单
function ExchangeCtrl:_deleteOrder(idInTable)
    table.remove(ExchangeCtrl.entrustmentInfo, idInTable)
    table.remove(ExchangeCtrl.entrustmentItems, idInTable)
    if #ExchangeCtrl.entrustmentInfo == 0 then
        ExchangePanel.noTipText.text = "No delegation at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
        ExchangePanel.entrustmentPage.localScale = Vector3.zero
    end

    ExchangePanel.entrustmentScroll:ActiveLoopScroll(self.entrustmentSource, #ExchangeCtrl.entrustmentInfo)
end

---下拉刷新回调
function ExchangeCtrl:_cityRecordDropfresh()
    Event.Brocast("m_ReqExchangeAllDealLog")
end

---从modle传来的回调
function ExchangeCtrl:c_onReceiveExchangeItemList(datas)
    if datas.summary then
        for i, itemData in ipairs(datas.summary) do
            ExchangeCtrl.quoteConfigDatas[itemData.itemId].itemId = itemData.itemId
            ExchangeCtrl.quoteConfigDatas[itemData.itemId].lowPrice = itemData.lowPrice
            ExchangeCtrl.quoteConfigDatas[itemData.itemId].highPrice = itemData.highPrice
            ExchangeCtrl.quoteConfigDatas[itemData.itemId].nowPrice = itemData.nowPrice
            ExchangeCtrl.quoteConfigDatas[itemData.itemId].sumDealedPrice = itemData.sumDealedPrice
            ExchangeCtrl.quoteConfigDatas[itemData.itemId].priceChange = itemData.priceChange
        end
    end

    local collectIndexs = PlayerTempModel.collectList
    local collectDatas = {}
    if collectIndexs ~= nil then
        for i, collectId in ipairs(collectIndexs) do
            collectDatas[#collectDatas + 1] = ExchangeCtrl.quoteConfigDatas[collectId]
            ExchangeCtrl.quoteConfigDatas[collectId].isCollected = true
        end
    end

    ExchangeCtrl.collectDatas = collectDatas
    ExchangeCtrl.quoteDatas = self:_getListTable(ExchangeCtrl.quoteConfigDatas)
    ExchangePanel.noTipText.transform.localScale = Vector3.zero  --行情一定会有值，所以不显示提示
    self:_quotesToggleValueChange(true)
    self.sortMgr:_reSetSortData()  --按照默认排序
end

--收到成交委托信息
function ExchangeCtrl:_getEntrustmentRecord(datas)
    if not datas.order or #datas.order == 0 then
        ExchangePanel.noTipText.text = "No delegation at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
        ExchangePanel.entrustmentPage.localScale = Vector3.zero
        return
    end

    ExchangeCtrl.entrustmentInfo = datas.order
    table.sort(ExchangeCtrl.entrustmentInfo, function (m, n) return m.ts > n.ts end)
    ExchangePanel.noTipText.transform.localScale = Vector3.zero
    ExchangePanel.entrustmentPage.localScale = Vector3.one
    ExchangePanel.entrustmentScroll:ActiveLoopScroll(self.entrustmentSource, #ExchangeCtrl.entrustmentInfo)
end
--收到自己的成交记录
function ExchangeCtrl:_getTransactionRecord(datas)
    if not datas.log or #datas.log == 0 then
        ExchangePanel.noTipText.text = "No record at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
        ExchangePanel.selfRecordPage.localScale = Vector3.zero
        return
    end

    ExchangeCtrl.selfRecordInfo = {}
    for i, item in ipairs(datas.log) do
        if item.sellerId == PlayerTempModel.roleData.id then
            item.isSell = true
            ExchangeCtrl.selfRecordInfo[#ExchangeCtrl.selfRecordInfo + 1] = item
        end
        if item.buyerId == PlayerTempModel.roleData.id then
            item.isSell = false
            ExchangeCtrl.selfRecordInfo[#ExchangeCtrl.selfRecordInfo + 1] = item
        end
    end
    table.sort(ExchangeCtrl.selfRecordInfo, function (m, n) return m.ts > n.ts end)
    ExchangePanel.selfRecordPage.localScale = Vector3.one
    ExchangePanel.selfRecordScroll:ActiveLoopScroll(self.selfRecordSource, #ExchangeCtrl.selfRecordInfo)
    ExchangePanel.noTipText.transform.localScale = Vector3.zero
end
--收到全城的成交记录
function ExchangeCtrl:_getCityRecord(datas)
    if not datas.log or #datas.log == 0 then
        ExchangePanel.noTipText.text = "No record at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
        ExchangePanel.cityRecordPage.localScale = Vector3.zero
        return
    end
    ExchangeCtrl.cityRecordInfo = {}
    for i, item in ipairs(datas.log) do
        if item.dealed == item.sellTotalAmount then
            item.isSell = true
            ExchangeCtrl.cityRecordInfo[#ExchangeCtrl.cityRecordInfo + 1] = item
        end
        if item.dealed == item.buyTotalAmount then
            item.isSell = false
            ExchangeCtrl.cityRecordInfo[#ExchangeCtrl.cityRecordInfo + 1] = item
        end
    end
    table.sort(ExchangeCtrl.cityRecordInfo, function (m, n) return m.ts > n.ts end)
    ExchangePanel.cityRecordPage.localScale = Vector3.one
    ExchangePanel.cityRecordScroll:ActiveLoopScroll(self.cityRecordSource, #ExchangeCtrl.cityRecordInfo)
    ExchangePanel.noTipText.transform.localScale = Vector3.zero
end
--收到成交信息
function ExchangeCtrl:_exchangeDealSuccess(data)
    for i, itemData in ipairs(ExchangeCtrl.entrustmentInfo) do
        if itemData.id == data.buyOrderId or itemData.id == data.sellOrderId then
            if ExchangeCtrl.entrustmentItems[i]:UpdateInfo(data) then  --如果数量为0，则删掉当前单
                self:_deleteOrder(i)
            end
        end
    end
end



