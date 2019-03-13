---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---土地拍卖
MapRightGroundAucPage = class('MapRightGroundAucPage', MapRightPageBase)

--初始化方法
function MapRightGroundAucPage:initialize(viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")

    self.closeBtn = viewRect:Find("root/closeBtn")
    self.soonRoot = viewRect:Find("root/soonRoot")
    self.soonTimeDownText = viewRect:Find("root/soonRoot/soonTimeDownText"):GetComponent("Text")
    self.startTimeText = viewRect:Find("root/soonRoot/startTimeText"):GetComponent("Text")
    self.floorPriceText = viewRect:Find("root/soonRoot/floorRoot/floorPriceText"):GetComponent("Text")

    self.nowRoot = viewRect:Find("root/nowRoot")
    self.nowTimeDownText = viewRect:Find("root/nowRoot/nowTimeDownText"):GetComponent("Text")
    self.nowTimeDownImage = viewRect:Find("root/nowRoot/Image")

    self.historyContent = viewRect:Find("root/nowRoot/historyRoot/scrollRect/content")
    self.historyItemPrefab = viewRect:Find("root/nowRoot/historyRoot/GAucHistoryItem")

    self.historyRoot = viewRect:Find("root/nowRoot/historyRoot")
    self.noneHistoryRoot = viewRect:Find("root/nowRoot/noneHistoryRoot")
    self.nowFloorPriceText = viewRect:Find("root/nowRoot/noneHistoryRoot/floorRoot/floorPriceText"):GetComponent("Text")

    self.averageRangeText = viewRect:Find("root/rangeNpcRoot/averageRangeText"):GetComponent("Text")
    self.goHereBtn = viewRect:Find("root/nowRoot/goHereBtn"):GetComponent("Button")

    self.personFlowText01 = viewRect:Find("root/rangeNpcRoot/Text"):GetComponent("Text")
    self.soonFloorText02 = viewRect:Find("root/soonRoot/floorRoot/Text01"):GetComponent("Text")
    self.nowBidText03 = viewRect:Find("root/nowRoot/Text01"):GetComponent("Text")
    self.nowFloorPriceText05 = viewRect:Find("root/nowRoot/noneHistoryRoot/floorRoot/Text"):GetComponent("Text")

    self.closeBtn.onClick:AddListener(function ()
        self:close()
    end)
    self.goHereBtn.onClick:AddListener(function ()
        self:_goHereBtn()
    end)
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, -1, true)
end
--
function MapRightGroundAucPage:refreshData(data)
    self.viewRect.anchoredPosition = Vector2.zero
    self.data = data
    if self.data == nil then
        return
    end

    self.m_Timer:Reset(slot(self._itemTimer, self), 1, -1, true)
    self.m_Timer:Start()
    self.averageRangeText.text = 0
    local groundInfo = GroundAucConfig[self.data.id]
    --如果开始拍卖，还需判断是否有人出价
    if self.data.isStartAuc then
        self:setSoonAndNow(true)
        --判断是否有人出价
        if self.data.endTs == nil or self.data.endTs == 0 then
            self:setBidState(false)
            self.nowFloorPriceText.text = getPriceString(GetClientPriceString(groundInfo.basePrice), 30, 24)
        else
            self:setBidState(true)
            self.bidHistory = ct.deepCopy(self.data.bidHistory)
            self:_createHistory()
            self.historyContent.localPosition = Vector2.zero
            self.startTimeDownForFinish = true  --拍卖结束倒计时
        end
    else
        self:setSoonAndNow(false)

        self.floorPriceText.text = getPriceString(GetClientPriceString(groundInfo.basePrice), 30, 24)
        local timeData = getFormatUnixTime(groundInfo.beginTime)
        self.startTimeText.text = timeData.hour..":"..timeData.minute..":"..timeData.second
        self.startTimeDownForStart = true  --即将拍卖倒计时
    end
    self:openShow()
end
--重置状态
function MapRightGroundAucPage:openShow()
    self:_language()
    self.viewRect.anchoredPosition = Vector2.zero
end
--多语言
function MapRightGroundAucPage:_language()
    self.personFlowText01.text = GetLanguage(22010004)
    self.soonFloorText02.text = GetLanguage(22010002)
    self.nowBidText03.text = GetLanguage(22010002)
    self.nowFloorPriceText05.text = GetLanguage(22010002)
end
--关闭
function MapRightGroundAucPage:close()
    self.viewRect.anchoredPosition = Vector2.New(506, 0)
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end

    self.startTimeDownForStart = false
    self.startTimeDownForFinish = false
    self:_removeListener()
    self:_cleanHistoryObj()
    self.bidHistory = {}
end
--去地图上的一个建筑
function MapRightGroundAucPage:_goHereBtn()
    --MapBubbleManager.GoHereFunc(self.data.buildingBase)
end

------------------
function MapRightGroundAucPage:_addListener()
    Event.AddListener("c_BidInfoUpdate", self._mapBidInfoUpdate, self)
    Event.AddListener("c_BidEnd", self._mapBidEnd, self)
    Event.AddListener("c_BidStart", self._mapBidStart, self)
    Event.AddListener("c_ReturnGAucHistoryObj", self._returnHistoryObj, self)
end
function MapRightGroundAucPage:_removeListener()
    Event.RemoveListener("c_BidInfoUpdate", self._mapBidInfoUpdate, self)
    Event.RemoveListener("c_BidEnd", self._mapBidEnd, self)
    Event.RemoveListener("c_BidStart", self._mapBidStart, self)
    Event.RemoveListener("c_ReturnGAucHistoryObj", self._returnHistoryObj, self)
end
--
function MapRightGroundAucPage:_itemTimer()
    self:SoonTimeDownFunc()
    self:NowTimeDownFunc()
end
--历史记录简易池
function MapRightGroundAucPage:_createHistory()
    self:_cleanHistory()  --清除history item

    table.sort(self.bidHistory, function (m, n) return m.ts > n.ts end)
    for i, value in ipairs(self.bidHistory) do
        if i == 1 then
            value.isFirst = true
        else
            value.isFirst = false
        end
        local go = self:_getValuableHistoryObj()
        go.transform:SetParent(self.historyContent.transform)
        go.transform.localScale = Vector3.one
        self.historyLuaItems[i] = GAucHistoryItem:new(value, go.transform)
    end
end
--获取一个有效的item
function MapRightGroundAucPage:_getValuableHistoryObj()
    if self.historyObjs == nil or #self.historyObjs == 0 then
        local go = UnityEngine.GameObject.Instantiate(self.historyItemPrefab)
        --go.transform.localScale = Vector3.one
        return go
    else
        local go = self.historyObjs[1]
        --go.transform.localScale = Vector3.one
        table.remove(self.historyObjs, 1)
        return go
    end
end
--回收obj
function MapRightGroundAucPage:_returnHistoryObj(go)
    if self.historyObjs == nil then
        self.historyObjs = {}
    end
    go.transform:SetParent(self.historyRoot.transform)
    go.transform.localScale = Vector3.zero
    table.insert(self.historyObjs, 1, go)
end
--隐藏界面时，清掉记录
function MapRightGroundAucPage:_cleanHistoryObj()
    if self.historyObjs == nil then
        return
    end
    for i, go in pairs(self.historyObjs) do
        go.transform:SetParent(self.historyRoot.transform)
        go.transform.localScale = Vector3.zero
    end
end

---倒计时---
--即将拍卖倒计时
function MapRightGroundAucPage:SoonTimeDownFunc()
    if self.startTimeDownForStart == true then
        local startAucTime = GroundAucConfig[self.data.id].beginTime * 1000
        local remainTime = startAucTime - TimeSynchronized.GetTheCurrentServerTime()
        if remainTime <= 0 then
            self.startTimeDownForStart = false
            return
        end

        local timeTable = getFormatUnixTime(remainTime / 1000)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.soonTimeDownText.text = timeStr
    end
end
--拍卖结束倒计时
function MapRightGroundAucPage:NowTimeDownFunc()
    if self.startTimeDownForFinish == true then
        if self.data.endTs == nil then
            return
        end
        local finishTime = self.data.endTs
        local remainTime = finishTime - TimeSynchronized.GetTheCurrentServerTime()
        if remainTime < 0 then
            self.startTimeDownForFinish = false
            self:close()
            return
        end

        local timeTable = getFormatUnixTime(remainTime / 1000)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.nowTimeDownText.text = timeStr
    end
end

--拍卖信息更新
function MapRightGroundAucPage:_mapBidInfoUpdate(data)
    if data.id ~= self.data.id then
        return
    end

    self:setBidState(true)
    if self.bidHistory == nil then
        self.bidHistory = {}
    end
    self:_cleanHistory()  --清除history item
    self.data.endTs = data.ts + GAucModel.BidTime
    local temp = {biderId = data.biderId, price = data.price, ts = data.ts}
    table.insert(self.bidHistory, 1, temp)
    self:_createHistory()
    self.startTimeDownForFinish = true
end
--清除历史item
function MapRightGroundAucPage:_cleanHistory()
    if self.historyLuaItems ~= nil and #self.historyLuaItems ~= 0 then
        for i, value in pairs(self.historyLuaItems) do
            value:close()
            value = nil
        end
    end
    self.historyLuaItems = {}
end

--拍卖结束
function MapRightGroundAucPage:_mapBidEnd(id)
    if id == self.data.id then
        self:close()
    end
end
--开始拍卖
function MapRightGroundAucPage:_mapBidStart(groundData)
    if groundData.id ~= self.data.id then
        return
    end

    self:setSoonAndNow(true)
    self:setBidState(false)
    self.nowFloorPriceText.text = getPriceString(GetClientPriceString(GroundAucConfig[self.data.id].basePrice), 30, 24)
end

--拍卖中有没有人出价
function MapRightGroundAucPage:setBidState(hasBid)
    if hasBid == true then
        self.historyRoot.localScale = Vector3.one
        self.noneHistoryRoot.localScale = Vector3.zero
        self.nowTimeDownText.transform.localScale = Vector3.one
        self.nowTimeDownImage.transform.localScale = Vector3.one
    else
        self.historyRoot.localScale = Vector3.zero
        self.noneHistoryRoot.localScale = Vector3.one
        self.nowTimeDownText.transform.localScale = Vector3.zero
        self.nowTimeDownImage.transform.localScale = Vector3.zero
    end
end
--拍卖中或者即将拍卖
function MapRightGroundAucPage:setSoonAndNow(isNow)
    if isNow == true then
        self.soonRoot.localScale = Vector3.zero
        self.nowRoot.localScale = Vector3.one
    else
        self.soonRoot.localScale = Vector3.one
        self.nowRoot.localScale = Vector3.zero
    end
end
------------------