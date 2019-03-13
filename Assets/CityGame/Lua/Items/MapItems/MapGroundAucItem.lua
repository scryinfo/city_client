---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---
MapGroundAucItem = class('MapGroundAucItem', MapBubbleBase)
--
function MapGroundAucItem:_childInit()
    self.scaleRoot = self.viewRect.transform:Find("root")  --需要缩放的部分

    self.now = self.viewRect.transform:Find("root/now")
    self.nowBinding = self.viewRect.transform:Find("root/now/bgBtn/binding")  --正在出价中
    self.nowTimeText = self.viewRect.transform:Find("root/now/bgBtn/binding/timeDownRoot/nowTimeText"):GetComponent("Text")
    self.nowText01 = self.viewRect.transform:Find("root/now/bgBtn/binding/Text"):GetComponent("Text")
    self.noneBidText02 = self.viewRect.transform:Find("root/now/bgBtn/noneBidText"):GetComponent("Text")
    self.nowBgBtn = self.viewRect.transform:Find("root/now/bgBtn"):GetComponent("Button")

    self.soon = self.viewRect.transform:Find("root/soon")
    self.soonTimeText = self.viewRect.transform:Find("root/soon/bgBtn/timeDownRoot/soonTimeText"):GetComponent("Text")
    self.soonText02 = self.viewRect.transform:Find("root/soon/bgBtn/Text"):GetComponent("Text")
    self.soonBgBtn = self.viewRect.transform:Find("root/soon/bgBtn"):GetComponent("Button")

    self.nowText01.text = GetLanguage(22010001)
    self.soonText02.text = GetLanguage(22020003)
    self.noneBidText02.text = GetLanguage(22010001)

    self.nowBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)
    self.soonBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)

    self:initData(self.data)
end
--
function MapGroundAucItem:initData(data)
    self.data = data

    self.timeDown = true
    if self.data.isStartAuc == true then
        --判断是否有出价
        if data.bidHistory == nil or #data.bidHistory == 0 then
            self.isStartBid = false
            self.noneBidText02.transform.localScale = Vector3.one
            self.nowBinding.localScale = Vector3.zero
        else
            self.isStartBid = true
            self.noneBidText02.transform.localScale = Vector3.zero
            self.nowBinding.localScale = Vector3.one
            table.sort(self.data.bidHistory, function (m, n) return m.ts > n.ts end)
            self.data.endTs = self.data.bidHistory[1].ts + GAucModel.BidTime
        end
    end

    local pos = Vector3.New(GroundAucConfig[self.data.id].area[1].x, 0, GroundAucConfig[self.data.id].area[1].y)
    if self.data.isStartAuc == true then
        self.now.transform.localScale = Vector3.one
        self.soon.transform.localScale = Vector3.zero
    else
        self.now.transform.localScale = Vector3.zero
        self.soon.transform.localScale = Vector3.one
    end
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, -1, true)
    self.m_Timer:Start()
end
--
function UIBubbleGroundAucItem:_itemTimer()
    if self.timeDown == true then
        self:NowTimeDownFunc()
        self:SoonTimeDownFunc()
    end
end
--打开右侧地图拍卖page
function UIBubbleGroundAucItem:_openGroundAucFunc()
    if self.data == nil then
        return
    end

end

--信息更新
function UIBubbleGroundAucItem:_bidInfoUpdate(data)
    if data.id == self.data.id then
        if self.data.bidHistory == nil then
            self.data.bidHistory = {}
        end
        self.data.endTs = data.ts + GAucModel.BidTime
        local temp = {biderId = data.biderId, price = data.price, ts = data.ts}
        table.insert(self.data.bidHistory, 1, temp)
        self.isStartBid = true
        self.noneBidText02.transform.localScale = Vector3.zero
        self.nowBinding.localScale = Vector3.one
    end
end
--
function UIBubbleGroundAucItem:_hideFunc()
    if self.bubbleObj ~= nil then
        self.bubbleObj.transform.localScale = Vector3.zero
    end
end
function UIBubbleGroundAucItem:_showFunc()
    if self.bubbleObj ~= nil then
        self.bubbleObj.transform.localScale = Vector3.one
    end
end

function UIBubbleGroundAucItem:_childClose()
    self.timeDown = false
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
end
--正在拍卖的倒计时
function UIBubbleGroundAucItem:NowTimeDownFunc()
    if self.isStartBid == true then
        if self.data.endTs == nil then
            return
        end
        local finishTime = self.data.endTs
        local remainTime = finishTime - TimeSynchronized.GetTheCurrentServerTime()
        if remainTime <= 0 then
            self.timeDown = false
            self.isStartBid = false
            self:close()
            return
        end

        local timeTable = getFormatUnixTime(remainTime / 1000)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.nowTimeText.text = timeStr
    end
end
--即将拍卖的倒计时
function UIBubbleGroundAucItem:SoonTimeDownFunc()
    if self.data.isStartAuc == false then
        local startAucTime = GroundAucConfig[self.data.id].beginTime * 1000
        local remainTime = startAucTime - TimeSynchronized.GetTheCurrentServerTime()
        if remainTime <= 0 then
            self.data.isStartAuc = true
            --开始拍卖
            self.now.transform.localScale = Vector3.one
            self.soon.transform.localScale = Vector3.zero
            self.noneBidText02.transform.localScale = Vector3.one
            self.nowBinding.localScale = Vector3.zero
            Event.Brocast("c_BidStart", self.data)  --切换界面
            return
        end

        local timeTable = getFormatUnixTime(remainTime / 1000)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.soonTimeText.text = timeStr
    end
end