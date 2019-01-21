---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/21 16:35
---土地拍卖已经开始气泡
UIBubbleGroundAucItem = class('UIBubbleGroundAucItem')
function UIBubbleGroundAucItem:initialize(data)
    self.data = data
    self.data.aucInfo.isStartAuc = data.isStartAuc
    self.bubbleRect = data.bubbleObj:GetComponent("RectTransform")
    self.bubbleObj = data.bubbleObj

    local viewTrans = self.bubbleObj.transform
    self.now = viewTrans:Find("now")
    self.nowTimeText = viewTrans:Find("now/bgBtn/timeDownRoot/nowTimeText"):GetComponent("Text")
    self.nowBgBtn = viewTrans:Find("now/bgBtn"):GetComponent("Button")

    self.soon = viewTrans:Find("soon")
    self.soonTimeText = viewTrans:Find("soon/bgBtn/timeDownRoot/soonTimeText"):GetComponent("Text")
    self.soonBgBtn = viewTrans:Find("soon/bgBtn"):GetComponent("Button")

    self.nowBgBtn.onClick:RemoveAllListeners()
    self.nowBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)
    self.soonBgBtn.onClick:RemoveAllListeners()
    self.soonBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)

    if self.data.isStartAuc == true then
        self.now.transform.localScale = Vector3.one
        self.soon.transform.localScale = Vector3.zero
    else
        self.now.transform.localScale = Vector3.zero
        self.soon.transform.localScale = Vector3.one
    end
    self.timeDown = true
    self.intTime = 1
    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
    --Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.AddListener("c_BubbleAllHide", self._hideFunc, self)
    Event.AddListener("c_BubbleAllShow", self._showFunc, self)
end

--打开拍卖界面，即将拍卖
function UIBubbleGroundAucItem:_openGroundAucFunc()
    --if self.data.aucInfo == nil then
    --    return
    --end
    ct.OpenCtrl("GroundAuctionCtrl", self.data.aucInfo)
end

--信息更新
function UIBubbleGroundAucItem:_bidInfoUpdate(data)
    if data.id == self.data.aucInfo.id then
        self.data.aucInfo.price = data.price
        self.data.aucInfo.biderId = data.biderId
    end
end
--获取是否点击到对应地块
function UIBubbleGroundAucItem:_checkIsClickGround(blockId)
    if self.data == nil then
        return false
    end
    for i, pos in pairs(self.data.aucInfo.area) do
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
function UIBubbleGroundAucItem:_getTimeDownInfo()
    return self.data.aucInfo.beginTime, self.data.aucInfo.durationSec
end

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

function UIBubbleGroundAucItem:Close()
    self.timeDown = false
    Event.RemoveListener("c_RefreshLateUpdate", self.LateUpdate, self)
    --Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.RemoveListener("c_BubbleAllHide", self._hideFunc, self)
    Event.RemoveListener("c_BubbleAllShow", self._showFunc, self)
    destroy(self.bubbleObj.gameObject)
    GAucModel.valuableStartAucObj.transform.localScale = Vector3.zero

    self.bubbleObj = nil
    self = nil
end

function UIBubbleGroundAucItem:LateUpdate()
    if self.timeDown == false then
        return
    end
    if self.bubbleObj ~= nil then
        self.bubbleRect.anchoredPosition = ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint(self.data.targetPos + Vector3.New(0.5, 0, 0.5)))
    else
        self.timeDown = false
        return
    end
    --计时器，每秒调用
    self.intTime = self.intTime + UnityEngine.Time.unscaledDeltaTime
    if self.intTime >= 1 then
        self.intTime = 0
        self:NowTimeDownFunc()
        self:SoonTimeDownFunc()
    end
end
--正在拍卖的倒计时
function UIBubbleGroundAucItem:NowTimeDownFunc()
    if self.data.isStartAuc == true then
        local finishTime = self.data.aucInfo.beginTime + self.data.aucInfo.durationSec
        local remainTime = finishTime - TimeSynchronized.GetTheCurrentTime()
        if remainTime <= 0 then
            self.timeDown = false
            --拍卖结束
            UIBubbleManager.closeItem(self, self.data.aucInfo.id)
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
        local startAucTime = self.data.aucInfo.beginTime
        local remainTime = startAucTime - TimeSynchronized.GetTheCurrentTime()
        if remainTime <= 0 then
            self.data.isStartAuc = true
            self.data.aucInfo.isStartAuc = true
            --开始拍卖
            self.now.transform.localScale = Vector3.one
            self.soon.transform.localScale = Vector3.zero
            GAucModel._getValuableStartAucObj().transform.position = self.data.targetPos
            Event.Brocast("c_BidStart", self.data.aucInfo)  --切换界面
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.soonTimeText.text = timeStr
    end
end