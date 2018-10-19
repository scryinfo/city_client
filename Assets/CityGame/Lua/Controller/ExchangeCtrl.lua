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

require('Framework/UI/UIPage')
require('Logic/ExchangeAbout/ExchangeQuoteItem')
local class = require 'Framework/class'

ExchangeCtrl = class('ExchangeCtrl',UIPage)

function ExchangeCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ExchangeCtrl:bundleName()
    return "Exchange"
end

function ExchangeCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
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
end

function ExchangeCtrl:Refresh()
    self:_initPanelData()
end

function ExchangeCtrl:Close()
    ExchangePanel.quotesToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.collectToggle.onValueChanged:RemoveAllListeners();
    ExchangePanel.recordToggle.onValueChanged:RemoveAllListeners();
end

function ExchangeCtrl:_initPanelData()
    Event.AddListener("c_onExchangeSort", self._exchangeSortByValue, self)

    --设置默认行情打开
    ExchangePanel._quotesToggleState(true)
    ExchangePanel._collectToggleState(false)
    ExchangePanel._recordToggleState(false)
    ExchangePanel.recordPage.localScale = Vector3.zero
    ExchangeCtrl.titleType = ExchangeTitleType.Quotes  --默认打开行情
    ExchangeCtrl.recordTitleType = ExchangeRecordTitleType.Entrustment  --默认打开成交进度

    --测试创建items
    local sourceInfo = {}
    sourceInfo[1] = {change = -0.78, lastPrice = 100, name = 001, isCollected = false, high = 1000, low = 0.5, volume = 500.003}
    sourceInfo[2] = {change = 0.78, lastPrice = 223, name = 002, isCollected = true , high = 1230, low = 1.5, volume = 52.003}
    sourceInfo[3] = {change = -0.53, lastPrice = 503, name = 003, isCollected = false, high = 1233, low = 15, volume = 12.003}
    sourceInfo[4] = {change = 3.68, lastPrice = 126, name = 004, isCollected = false, high = 1234, low = 12.5, volume = 52.3}
    sourceInfo[5] = {change = -5.2, lastPrice = 428, name = 005, isCollected = false, high = 1005, low = 45.5, volume = 59}
    sourceInfo[6] = {change = 15.03, lastPrice = 998, name = 006, isCollected = true, high = 10005.002, low = 99, volume = 11000.0022}
    ExchangeCtrl.sourceInfo = sourceInfo
    ExchangeCtrl.collectDatas = self:_getCollectDatas(sourceInfo)
    ExchangePanel.noTipText.transform.localScale = Vector3.zero  --行情一定会有值，所以不显示提示

    local loopSource = UnityEngine.UI.LoopScrollDataSource.New()  --滑动复用部分
    loopSource.mProvideData = ExchangeCtrl.static.QuotesProvideData
    loopSource.mClearData = ExchangeCtrl.static.QuotesClearData
    ExchangePanel.quotesCollectScroll:ActiveScroll(loopSource, 6);

    self.sortMgr:_reSetSortData()  --按照默认排序
end
---行情收藏记录的toggle
function ExchangeCtrl:_quotesToggleValueChange(isOn)
    if isOn then
        if ExchangeCtrl.titleType ~= ExchangeTitleType.Quotes then
            ExchangePanel._quotesToggleState(isOn)
            ExchangeCtrl.titleType = ExchangeTitleType.Quotes
            ExchangePanel.quotesAndCollectPage.localScale = Vector3.one
            self.sortMgr:_reSetSortData()  --按照默认排序

            if #ExchangeCtrl.sourceInfo == 0 then
                return
            else
                ExchangePanel.quotesCollectScroll:RefillCells(#ExchangeCtrl.sourceInfo)
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
                ExchangePanel.quotesCollectScroll:RefillCells(#ExchangeCtrl.collectDatas)
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

    local entrustmentInfo = {}
    entrustmentInfo[1] = {quantity = -0.78, unitPrice = 100, name = 001, isSell = false,totalCount = 1000, remainCount = 110, currentValue = 0.5}
    entrustmentInfo[2] = {quantity = 0.78, unitPrice = 223, name = 002, isSell = true , totalCount = 1230, remainCount = 998, currentValue = 1.5}
    entrustmentInfo[3] = {quantity = -0.53, unitPrice = 503, name = 003, isSell = false,totalCount = 1233, remainCount = 75, currentValue = 15}
    entrustmentInfo[4] = {quantity = 3.68, unitPrice = 126, name = 004, isSell = false, totalCount = 1234, remainCount = 1000, currentValue = 12.5}
    entrustmentInfo[5] = {quantity = -5.2, unitPrice = 428, name = 005, isSell = false, totalCount = 1005, remainCount = 320, currentValue = 45.5}
    entrustmentInfo[6] = {quantity = 15.03, unitPrice = 998, name = 006, isSell = true, totalCount = 1587, remainCount = 1   , currentValue = 99}
    ExchangeCtrl.entrustmentInfo = entrustmentInfo
    if #ExchangeCtrl.entrustmentInfo == 0 then
        ExchangePanel.noTipText.text = "No delegation at present!"
        ExchangePanel.noTipText.transform.localScale = Vector3.one
    else
        ExchangePanel.noTipText.transform.localScale = Vector3.zero
    end

    local entrustmentSource = UnityEngine.UI.LoopScrollDataSource.New()  --滑动复用部分
    entrustmentSource.mProvideData = ExchangeCtrl.static.EntrustmentProvideData
    entrustmentSource.mClearData = ExchangeCtrl.static.EntrustmentClearData
    ExchangePanel.quotesCollectScroll:ActiveScroll(entrustmentSource, 6);

end

function ExchangeCtrl:_entrustmentToggleValueChange(isOn)
    if ExchangeCtrl.titleType ~= ExchangeTitleType.Record then
        return
    end

    if isOn then
        --if ExchangeCtrl.titleType ~= ExchangeTitleType.Quotes then
        --    ExchangePanel._quotesToggleState(isOn)
        --    ExchangeCtrl.titleType = ExchangeTitleType.Quotes
        --    ExchangePanel.quotesAndCollectPage.localScale = Vector3.one
        --
        --    if #ExchangeCtrl.sourceInfo == 0 then
        --        return
        --    else
        --        ExchangePanel.quotesCollectScroll:RefillCells(#ExchangeCtrl.sourceInfo)
        --    end
        --end
    else
        --if ExchangeCtrl.titleType == ExchangeTitleType.Quotes then
        --    ExchangePanel._quotesToggleState(isOn)
        --    ExchangePanel.quotesAndCollectPage.localScale = Vector3.zero
        --end
    end
end

---滑动复用
--行情和收藏的界面
ExchangeCtrl.static.QuotesProvideData = function(transform, idx)
    idx = idx + 1
    if ExchangeCtrl.titleType == ExchangeTitleType.Collect then
        local collectItem = ExchangeQuoteItem:new(ExchangeCtrl.collectDatas[idx], transform, ExchangeCtrl.static.luaBehaviour)

    elseif ExchangeCtrl.titleType == ExchangeTitleType.Quotes then
        local item = ExchangeQuoteItem:new(ExchangeCtrl.sourceInfo[idx], transform, ExchangeCtrl.static.luaBehaviour)
    end

end
ExchangeCtrl.static.QuotesClearData = function(transform)
    --log("cycle_w8_exchange01_loopScroll", "回收"..transform.name)
end

--交易委托
ExchangeCtrl.static.EntrustmentProvideData = function(transform, idx)
    idx = idx + 1
    --local collectItem = ExchangeQuoteItem:new(ExchangeCtrl.collectDatas[idx], transform, ExchangeCtrl.static.luaBehaviour)

end
ExchangeCtrl.static.EntrustmentClearData = function(transform)
    --log("cycle_w8_exchange01_loopScroll", "回收"..transform.name)
end

---排序
function ExchangeCtrl:_exchangeSortByValue(sortData)
    --log("cycle_w9_exchange01", "排序啦啦啦")
    if ExchangeCtrl.titleType == ExchangeTitleType.Quotes then  --行情的排序
        ExchangeCtrl.sourceInfo = self:_getSortDatas(ExchangeCtrl.sourceInfo, sortData)
        ExchangePanel.quotesCollectScroll:RefillCells(#ExchangeCtrl.sourceInfo)
    elseif ExchangeCtrl.titleType == ExchangeTitleType.Collect then
        ExchangeCtrl.collectDatas = self:_getSortDatas(ExchangeCtrl.collectDatas, sortData)
        ExchangePanel.quotesCollectScroll:RefillCells(#ExchangeCtrl.collectDatas)
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



