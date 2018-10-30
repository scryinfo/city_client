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
    return "Exchange"
end

function ExchangeCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
    --关闭面板
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(ExchangePanel.backBtn.gameObject, function()
        UIPage.ClosePage();
    end );
end

function ExchangeCtrl:Awake(go)
    self.gameObject = go
    ExchangeCtrl.static.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour');

    self.sortMgr = ExchangeSortMgr:new(ExchangePanel.titleRoot)

    --行情收藏记录toggle
    ExchangePanel.quotesToggle.onValueChanged:AddListener(function (isOn)
        self:_quotesToggleValueChange(isOn)
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

    --滑动复用部分
    self.quotesSource = UnityEngine.UI.LoopScrollDataSource.New()  --行情以及收藏
    self.quotesSource.mProvideData = ExchangeCtrl.static.QuotesProvideData
    self.quotesSource.mClearData = ExchangeCtrl.static.QuotesClearData
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
    ExchangePanel.quotesToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.collectToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.recordToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.entrustmentToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.selfRecordToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.cityRecordToggle.onValueChanged:RemoveAllListeners();
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
    ExchangePanel.recordPage.localScale = Vector3.zero
    ExchangeCtrl.titleType = ExchangeTitleType.Quotes  --默认打开行情
    ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.Entrustment  --默认打开成交进度

    ExchangeCtrl.quoteItems = {}
    ExchangeCtrl.collectItems = {}
    ExchangeCtrl.entrustmentItems = {}
    ExchangeCtrl.selfRecordItems = {}
    ExchangeCtrl.cityRecordItems = {}

    Event.Brocast("m_ReqExchangeItemList");
end
---行情收藏记录的toggle
function ExchangeCtrl:_quotesToggleValueChange(isOn)
    ExchangePanel.noTipText.transform.localScale = Vector3.zero
    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Quotes then
            ExchangePanel._quotesToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Quotes
            ExchangePanel.quotesAndCollectPage.localScale = Vector3.one
            self.sortMgr:_reSetSortData()  --按照默认排序

            if #ExchangeCtrl.quoteDatas == 0 then
                return
            else
                ExchangePanel.quotesCollectScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.quoteDatas)
            end
        end
    else
        if ExchangeCtrl.titleType == ExchangeTitleType.Quotes then
            ExchangePanel._quotesToggleState(isOn)
            ExchangePanel.quotesAndCollectPage.localScale = Vector3.zero
        end
    end
end
function ExchangeCtrl:_collectToggleValueChange(isOn)
    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Collect then
            ExchangePanel._collectToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Collect
            ExchangePanel.quotesAndCollectPage.localScale = Vector3.one
            self.sortMgr:_reSetSortData()  --按照默认排序

            if #ExchangeCtrl.collectDatas == 0 then
                ExchangePanel.noTipText.text = "Currently no collection!"
                ExchangePanel.noTipText.transform.localScale = Vector3.one
                return
            else
                ExchangePanel.noTipText.transform.localScale = Vector3.zero
                ExchangePanel.quotesCollectScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.collectDatas)
            end
        end
    else
        if ExchangeCtrl.titleType == ExchangeTitleType.Collect then
            ExchangePanel._collectToggleState(isOn)
            ExchangePanel.quotesAndCollectPage.localScale = Vector3.zero
        end
    end
end
function ExchangeCtrl:_recordToggleValueChange(isOn)
    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
            --判断是否有数据，没有的话，就显示提示 text
            --打开详情界面
            ExchangePanel._recordToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Record
            self:_recordRootInit()

            --请求服务器成交进度信息
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
    ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.Entrustment  --默认打开成交进度
    ExchangePanel._entrustmentToggleState(true)
    ExchangePanel._selfRecordToggleState(false)
    ExchangePanel._cityRecordToggleState(false)
    ExchangePanel.recordPage.localScale = Vector3.one

    Event.Brocast("m_ReqExchangeMyDealLog")
    ---模拟服务器消息
    --self:_getEntrustmentRecord()

end

function ExchangeCtrl:_entrustmentToggleValueChange(isOn)
    if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
        return
    end

    if isOn then
        if ExchangeCtrl.recordTitleType ~= ExchangeRecordTitleType.Entrustment then
            ExchangePanel._entrustmentToggleState(isOn)
            ExchangePanel._cityRecordToggleState(not isOn)
            ExchangePanel._selfRecordToggleState(not isOn)
            ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.Entrustment

            if #ExchangeCtrl.entrustmentInfo == 0 then
                return
            else
                ExchangePanel.entrustmentScroll:ActiveLoopScroll(self.entrustmentSource, #ExchangeCtrl.entrustmentInfo)
            end
        end
    else
        ExchangePanel._entrustmentToggleState(isOn)
    end
end
function ExchangeCtrl:_selfRecordToggleValueChange(isOn)
    if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
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
--行情和收藏的界面
ExchangeCtrl.static.QuotesProvideData = function(transform, idx)
    idx = idx + 1
    if ExchangeCtrl.titleType == ExchangeTitleType.Collect then
        local collectItem = ExchangeQuoteItem:new(ExchangeCtrl.collectDatas[idx], transform)
        ExchangeCtrl.collectItems[idx] = collectItem

    elseif ExchangeCtrl.titleType == ExchangeTitleType.Quotes then
        local item = ExchangeQuoteItem:new(ExchangeCtrl.quoteDatas[idx], transform)
        ExchangeCtrl.quoteItems[idx] = item
    end

end
ExchangeCtrl.static.QuotesClearData = function(transform)
end

--交易委托
ExchangeCtrl.static.EntrustmentProvideData = function(transform, idx)
    idx = idx + 1
    local entrustmentItem = RecordEntrustmentItem:new(ExchangeCtrl.entrustmentInfo[idx], transform)
    entrustmentItem.idInTable = idx
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
        ExchangePanel.quotesCollectScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.quoteDatas)

    elseif ExchangeCtrl.titleType == ExchangeTitleType.Collect then
        ExchangeCtrl.collectDatas = self:_getSortDatas(ExchangeCtrl.collectDatas, sortData)
        ExchangePanel.quotesCollectScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.collectDatas)
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
            table.sort(tempDatas, function (m, n) return m.high > n.high end)
        else
            table.sort(tempDatas, function (m, n) return m.high < n.high end)
        end
    elseif sortType == ExchangeSortItemType.Change then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.change > n.change end)
        else
            table.sort(tempDatas, function (m, n) return m.change < n.change end)
        end
    elseif sortType == ExchangeSortItemType.LastPrice then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.lastPrice > n.lastPrice end)
        else
            table.sort(tempDatas, function (m, n) return m.lastPrice < n.lastPrice end)
        end
    elseif sortType == ExchangeSortItemType.Low then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.low > n.low end)
        else
            table.sort(tempDatas, function (m, n) return m.low < n.low end)
        end
    elseif sortType == ExchangeSortItemType.Volume then
        if isSmaller then
            table.sort(tempDatas, function (m, n) return m.volume > n.volume end)
        else
            table.sort(tempDatas, function (m, n) return m.volume < n.volume end)
        end
    end

    return tempDatas
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
        if data == itemId then
            data.isCollected = isCollected
            ExchangeCtrl.quoteDatas[itemId].isCollected = false
            table.remove(ExchangeCtrl.collectDatas, itemId)
            table.remove(ExchangeCtrl.collectItems, itemId)
            return
        end
    end
    ExchangeCtrl.collectItems[#ExchangeCtrl.collectItems + 1] = ExchangeCtrl.quoteDatas[itemId]
end
--取消挂单
function ExchangeCtrl:_deleteOrder(idInTable)
    table.remove(ExchangeCtrl.entrustmentInfo, idInTable)
    table.remove(ExchangeCtrl.entrustmentItems, idInTable)
    ExchangePanel.entrustmentScroll:ActiveLoopScroll(self.entrustmentSource, #ExchangeCtrl.entrustmentInfo);
end


---从modle传来的回调
function ExchangeCtrl:c_onReceiveExchangeItemList(datas)
    ----测试创建items
    --local quoteDatas = {}
    --quoteDatas[1] = {change = -0.78, lastPrice = 100, name = 001, isCollected = false, high = 1000, low = 0.5, volume = 500.003}
    --quoteDatas[2] = {change = 0.78, lastPrice = 223, name = 002, isCollected = true , high = 1230, low = 1.5, volume = 52.003}
    --quoteDatas[3] = {change = -0.53, lastPrice = 503, name = 003, isCollected = false, high = 1233, low = 15, volume = 12.003}
    --quoteDatas[4] = {change = 3.68, lastPrice = 126, name = 004, isCollected = false, high = 1234, low = 12.5, volume = 52.3}
    --quoteDatas[5] = {change = -5.2, lastPrice = 428, name = 005, isCollected = false, high = 1005, low = 45.5, volume = 59}
    --quoteDatas[6] = {change = 15.03, lastPrice = 998, name = 006, isCollected = true, high = 10005.002, low = 99, volume = 11000.0022}
    --
    --ExchangeCtrl.quoteDatas = quoteDatas
    --ExchangeCtrl.collectDatas = self:_getCollectDatas(quoteDatas)
    --ExchangePanel.noTipText.transform.localScale = Vector3.zero  --行情一定会有值，所以不显示提示
    --ExchangePanel.quotesCollectScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.quoteDatas);
    --self.sortMgr:_reSetSortData()  --按照默认排序

    ---正式代码 --因为服务器不保证数据顺序，所以每次数据更新时都遍历一次传来的表，获取以itemid为key的新表
    local quoteTable = {}
    for i, itemData in ipairs(datas) do
        quoteTable[itemData.itemId] = itemData
    end

    local collectIndexs = {}  --从role exchangeCollectedItem中获取
    local collectDatas = {}
    for i, collectId in ipairs(collectIndexs) do
        collectDatas[#collectDatas + 1] = quoteTable[collectId]
        quoteTable[collectId].isCollected = true
    end
    ExchangeCtrl.quoteDatas = quoteTable
    ExchangeCtrl.collectDatas = collectDatas
    ExchangePanel.noTipText.transform.localScale = Vector3.zero  --行情一定会有值，所以不显示提示
    ExchangePanel.quotesCollectScroll:ActiveLoopScroll(self.quotesSource, #ExchangeCtrl.quoteDatas);
    self.sortMgr:_reSetSortData()  --按照默认排序
end

--收到成交委托信息
function ExchangeCtrl:_getEntrustmentRecord(datas)
    --local entrustmentInfo = {}
    --entrustmentInfo[1] = {quantity = -0.78, unitPrice = 100, name = 001, isSell = false,total = 1000, totalCount = 1000, remainCount = 110, currentValue = 0.5}
    --entrustmentInfo[2] = {quantity = 0.78, unitPrice = 223, name = 002, isSell = true , total = 1230, totalCount = 1230, remainCount = 998, currentValue = 1.5}
    --entrustmentInfo[3] = {quantity = -5.2, unitPrice = 428, name = 005, isSell = false, total = 1005, totalCount = 1005, remainCount = 320, currentValue = 45.5}
    --entrustmentInfo[4] = {quantity = 15.03, unitPrice = 998, name = 006, isSell = true, total = 1587, totalCount = 1587, remainCount = 1   , currentValue = 99}
    --ExchangeCtrl.entrustmentInfo = entrustmentInfo
    --if #ExchangeCtrl.entrustmentInfo == 0 then
    --    ExchangePanel.noTipText.text = "No delegation at present!"
    --    ExchangePanel.noTipText.transform.localScale = Vector3.one
    --else
    --    ExchangePanel.noTipText.transform.localScale = Vector3.zero
    --    ExchangePanel.entrustmentScroll:ActiveLoopScroll(self.entrustmentSource, #ExchangeCtrl.entrustmentInfo);
    --end

    ExchangeCtrl.entrustmentInfo = datas
    if #ExchangeCtrl.entrustmentInfo == 0 then
        ExchangePanel.noTipText.text = "No delegation at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
    else
        table.sort(ExchangeCtrl.entrustmentInfo, function (m, n) return m.ts > n.ts end)
        ExchangePanel.noTipText.transform.localScale = Vector3.zero
        ExchangePanel.entrustmentScroll:ActiveLoopScroll(self.entrustmentSource, #ExchangeCtrl.entrustmentInfo);
    end
end
--收到自己的成交记录
function ExchangeCtrl:_getTransactionRecord(datas)
    --local selfRecordInfo = {}
    --selfRecordInfo[1] = {quantity = 3.68, unitPrice = 126, name = 004, isSell = true, total = 123.4, time = "2018/10/01 12:30:05"}
    --selfRecordInfo[2] = {quantity = -0.78, unitPrice = 100, name = 001, isSell = true,total = 10.03, time = "2018/10/01 12:30:05"}
    --selfRecordInfo[3] = {quantity = -0.53, unitPrice = 503, name = 003, isSell = false,total = 12.33, time = "2018/10/01 12:30:05"}
    --selfRecordInfo[4] = {quantity = 0.78, unitPrice = 223, name = 002, isSell = true , total = 12.30, time = "2018/10/01 12:30:05"}
    --ExchangeCtrl.selfRecordInfo = selfRecordInfo
    --
    --if #ExchangeCtrl.selfRecordInfo == 0 then
    --    ExchangePanel.noTipText.text = "No record at present!"
    --    ExchangePanel.noTipText.transform.localScale = Vector3.one
    --    return
    --else
    --    ExchangePanel.selfRecordScroll:ActiveLoopScroll(self.selfRecordSource, #ExchangeCtrl.selfRecordInfo)
    --    ExchangePanel.noTipText.transform.localScale = Vector3.zero
    --end

    ExchangeCtrl.selfRecordInfo = datas
    if #ExchangeCtrl.selfRecordInfo == 0 then
        ExchangePanel.noTipText.text = "No record at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
        return
    else
        table.sort(ExchangeCtrl.selfRecordInfo, function (m, n) return m.ts > n.ts end)
        ExchangePanel.selfRecordScroll:ActiveLoopScroll(self.selfRecordSource, #ExchangeCtrl.selfRecordInfo)
        ExchangePanel.noTipText.transform.localScale = Vector3.zero
    end
end
--收到全城的成交记录
function ExchangeCtrl:_getCityRecord(datas)
    ExchangeCtrl.cityRecordInfo = datas
    if #ExchangeCtrl.cityRecordInfo == 0 then
        ExchangePanel.noTipText.text = "No record at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
        return
    else
        table.sort(ExchangeCtrl.cityRecordInfo, function (m, n) return m.ts > n.ts end)
        ExchangePanel.cityRecordScroll:ActiveLoopScroll(self.cityRecordSource, #ExchangeCtrl.cityRecordInfo)
        ExchangePanel.noTipText.transform.localScale = Vector3.zero
    end
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



