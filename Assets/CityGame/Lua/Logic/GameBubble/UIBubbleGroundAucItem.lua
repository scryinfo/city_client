---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/21 16:35
---土地拍卖已经开始气泡
UIBubbleGroundAucItem = class('UIBubbleGroundAucItem')
function UIBubbleGroundAucItem:initialize(data)
    self.data = data
    --self.data.aucInfo.isStartAuc = data.isStartAuc
    self.bubbleRect = data.bubbleObj:GetComponent("RectTransform")
    self.bubbleObj = data.bubbleObj

    local viewTrans = self.bubbleObj.transform
    self.now = viewTrans:Find("now")
    self.nowBinding = viewTrans:Find("now/bgBtn/binding")  --正在出价中
    self.nowTimeText = viewTrans:Find("now/bgBtn/binding/timeDownRoot/nowTimeText"):GetComponent("Text")
    self.nowText01 = viewTrans:Find("now/bgBtn/binding/Text"):GetComponent("Text")
    self.noneBidText02 = viewTrans:Find("now/bgBtn/noneBidText"):GetComponent("Text")
    self.nowBgBtn = viewTrans:Find("now/bgBtn"):GetComponent("Button")

    self.soon = viewTrans:Find("soon")
    self.soonTimeText = viewTrans:Find("soon/bgBtn/timeDownRoot/soonTimeText"):GetComponent("Text")
    self.soonText02 = viewTrans:Find("soon/bgBtn/Text"):GetComponent("Text")
    self.soonBgBtn = viewTrans:Find("soon/bgBtn"):GetComponent("Button")

    self.nowText01.text = GetLanguage(22010001)
    self.soonText02.text = GetLanguage(22020003)
    self.noneBidText02.text = GetLanguage(22010001)

    self.nowBgBtn.onClick:RemoveAllListeners()
    self.nowBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)
    self.soonBgBtn.onClick:RemoveAllListeners()
    self.soonBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)

    self.timeDown = true
    self.intTime = 1
    if data.endTs == nil then
        self.data.isStartAuc = false
    else
        self.data.isStartAuc = true
        --判断是否有出价
        if data.bidHistory ~= nil or data.endTs ~= 0 then
            self.isStartBid = true
            self.noneBidText02.transform.localScale = Vector3.zero
            self.nowBinding.localScale = Vector3.one
        else
            self.timeDown = false
            self.noneBidText02.transform.localScale = Vector3.one
            self.nowBinding.localScale = Vector3.zero
        end
    end

    self.data.targetPos = Vector3.New(GroundAucConfig[self.data.id].area[1].x, 0, GroundAucConfig[self.data.id].area[1].y)
    if self.data.isStartAuc == true then
        self.now.transform.localScale = Vector3.one
        self.soon.transform.localScale = Vector3.zero
        self.groundGo = GAucModel._getValuableStartAucObj()  --设置场景中的拍卖gameobject
    else
        self.now.transform.localScale = Vector3.zero
        self.soon.transform.localScale = Vector3.one
        self.groundGo = GAucModel._getValuableWillAucObj()
    end
    self.groundGo.transform.position = self.data.targetPos
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, -1, true)
    self.m_Timer:Start()

    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.AddListener("c_BubbleAllHide", self._hideFunc, self)
    Event.AddListener("c_BubbleAllShow", self._showFunc, self)
    Event.AddListener("c_ChangeLanguage", self._changeLanguageFunc, self)
end

function UIBubbleGroundAucItem:_itemTimer()
    if self.timeDown == true then
        self:NowTimeDownFunc()
        self:SoonTimeDownFunc()
    end
end

--打开拍卖界面，即将拍卖
function UIBubbleGroundAucItem:_openGroundAucFunc()
    --if self.data.aucInfo == nil then
    --    return
    --end
    PlayMusEff(1002)
    ct.OpenCtrl("GroundAuctionCtrl", self.data)
end

--信息更新
function UIBubbleGroundAucItem:_bidInfoUpdate(data)
    if data.id == self.data.id then
        if self.data.bidHistory == nil then
            self.data.bidHistory = {}
        end
        local time = TimeSynchronized.GetTheCurrentTime()
        self.data.endTs = time + 60
        local temp = {biderId = data.biderId, price = data.nowPrice, ts = time}
        table.insert(self.data.bidHistory, 1, temp)
    end
end
--获取是否点击到对应地块
function UIBubbleGroundAucItem:_checkIsClickGround(blockId)
    if self.data == nil then
        return false
    end
    for i, pos in pairs(GroundAucConfig[self.data.id].area) do
        local tempBlockId = TerrainManager.GridIndexTurnBlockID(pos)
        if tempBlockId == blockId then
            self:_openGroundAucFunc()
            return true
        end
    end
end
--获取当前拍卖状态
function UIBubbleGroundAucItem:_getAucState()
    return self.data.isStartAuc
end
--获取当前拍卖状态
--function UIBubbleGroundAucItem:_getTimeDownInfo()
--    return self.data.aucInfo.beginTime, self.data.aucInfo.durationSec
--end

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
function UIBubbleGroundAucItem:_changeLanguageFunc()
    self.nowText01.text = GetLanguage(22010001)
    self.soonText02.text = GetLanguage(22020003)
    self.noneBidText02.text = GetLanguage(22010001)
end

function UIBubbleGroundAucItem:Close()
    self.timeDown = false
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
    Event.RemoveListener("c_RefreshLateUpdate", self.LateUpdate, self)
    --Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.RemoveListener("c_BubbleAllHide", self._hideFunc, self)
    Event.RemoveListener("c_BubbleAllShow", self._showFunc, self)
    Event.RemoveListener("c_ChangeLanguage", self._changeLanguageFunc, self)
    destroy(self.bubbleObj.gameObject)

    self.bubbleObj = nil
    self = nil
end

function UIBubbleGroundAucItem:LateUpdate()
    if self.bubbleObj ~= nil then
        self.bubbleRect.anchoredPosition = ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint(self.data.targetPos + Vector3.New(0.5, 0, 0.5)))
    end
end
--正在拍卖的倒计时
function UIBubbleGroundAucItem:NowTimeDownFunc()
    if self.isStartBid == true then
        local finishTime = self.data.endTs
        local remainTime = finishTime - TimeSynchronized.GetTheCurrentTime()
        if remainTime <= 0 then
            self.timeDown = false
            self.isStartBid = false
            self.groundGo.transform.localScale = Vector3.zero
            --拍卖结束
            UIBubbleManager.closeItem(self, self.data.id)
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.nowTimeText.text = timeStr
    end
end
--即将拍卖的倒计时
function UIBubbleGroundAucItem:SoonTimeDownFunc()
    if self.data.isStartAuc == false then
        local startAucTime = GroundAucConfig[self.data.id].beginTime
        local remainTime = startAucTime - TimeSynchronized.GetTheCurrentTime()
        if remainTime <= 0 then
            self.data.isStartAuc = true
            --开始拍卖
            self.now.transform.localScale = Vector3.one
            self.soon.transform.localScale = Vector3.zero
            self.noneBidText02.transform.localScale = Vector3.one
            self.nowBinding.localScale = Vector3.zero
            GAucModel._getValuableStartAucObj().transform.position = self.data.targetPos
            GAucModel.updateSoonItem(self.data.id + 1)
            Event.Brocast("c_BidStart", self.data)  --切换界面
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.soonTimeText.text = timeStr
    end
end