---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/21 16:35
---土地拍卖已经开始气泡
UIBubbleGroundAucItem = class('UIBubbleGroundAucItem')
local selfBoxwidth = 200    --给出200像素的富裕空间  其实只需要最大宽高的一半
local minAnchorX = nil
local maxAnchorX = nil
local minAnchorY = nil
local maxAnchorY = nil
local mainCamera = nil
function UIBubbleGroundAucItem:initialize(data)
    self.data = data
    --self.data.aucInfo.isStartAuc = data.isStartAuc
    self.bubbleRect = data.bubbleObj:GetComponent("RectTransform")
    self.bubbleObj = data.bubbleObj

    local viewTrans = self.bubbleObj.transform
    self.now = viewTrans:Find("now")
    self.nowBinding = viewTrans:Find("now/bgBtn/binding")  --正在出价中
    self.nowTimeText = viewTrans:Find("now/bgBtn/binding/timeText"):GetComponent("Text")
    self.nowText01 = viewTrans:Find("now/bgBtn/binding/typeText"):GetComponent("Text")
    self.noneBidText02 = viewTrans:Find("now/bgBtn/noneBidText"):GetComponent("Text")
    self.nowBgBtn = viewTrans:Find("now/bgBtn"):GetComponent("Button")

    self.soon = viewTrans:Find("soon")
    self.soonTimeText = viewTrans:Find("soon/bgBtn/root/timeText"):GetComponent("Text")
    self.soonText02 = viewTrans:Find("soon/bgBtn/root/typeText"):GetComponent("Text")
    self.soonBgBtn = viewTrans:Find("soon/bgBtn"):GetComponent("Button")

    self.nowText01.text = GetLanguage(21010001)
    self.soonText02.text = GetLanguage(21010009)
    self.noneBidText02.text = GetLanguage(21010001)

    self.nowBgBtn.onClick:RemoveAllListeners()
    self.nowBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)
    self.soonBgBtn.onClick:RemoveAllListeners()
    self.soonBgBtn.onClick:AddListener(function ()
        self:_openGroundAucFunc()
    end)

    self.timeDown = true
    if self.data.isStartAuc == true then
        --判断是否有出价
        if data.bidHistory == nil or #data.bidHistory == 0 then
            self.isStartBid = false
            --self.noneBidText02.transform.localScale = Vector3.one
            --self.nowBinding.localScale = Vector3.zero
            self.noneBidText02.gameObject:SetActive(true)
            self.nowBinding.gameObject:SetActive(false)
        else
            self.isStartBid = true
            --self.noneBidText02.transform.localScale = Vector3.zero
            --self.nowBinding.localScale = Vector3.one
            self.noneBidText02.gameObject:SetActive(false)
            self.nowBinding.gameObject:SetActive(true)
            table.sort(self.data.bidHistory, function (m, n) return m.ts > n.ts end)
            self.data.endTs = self.data.bidHistory[1].ts + GAucModel.BidTime
        end
    end

    local groundConfigData = GroundAucConfig[self.data.id]
    --local groundConfigData = GroundAucConfig[1]
    local pos = Vector3.New(groundConfigData.centerPos.x, 0, groundConfigData.centerPos.y)
    if self.data.isStartAuc == true then
        --self.now.transform.localScale = Vector3.one
        --self.soon.transform.localScale = Vector3.zero
        self.now.gameObject:SetActive(true)
        self.soon.gameObject:SetActive(false)
        self.groundGo = GAucModel._getValuableStartAucObj(groundConfigData.area)  --设置场景中的拍卖gameobject
    else
        --self.now.transform.localScale = Vector3.zero
        --self.soon.transform.localScale = Vector3.one
        self.now.gameObject:SetActive(false)
        self.soon.gameObject:SetActive(true)
        self.groundGo = GAucModel._getValuableWillAucObj(groundConfigData.area)
    end
    self.data.targetPos = pos
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, -1, true)
    self.m_Timer:Start()

    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    Event.AddListener("c_BubbleAllHide", self._hideFunc, self)
    Event.AddListener("c_BubbleAllShow", self._showFunc, self)
    Event.AddListener("c_ChangeLanguage", self._changeLanguageFunc, self)

    --显示范围内才显示
    if minAnchorX == nil then
        minAnchorX = - selfBoxwidth
        maxAnchorX = UnityEngine.Screen.width * Game.ScreenRatio + selfBoxwidth
        minAnchorY = - selfBoxwidth
        maxAnchorY = UnityEngine.Screen.height * Game.ScreenRatio + selfBoxwidth
        mainCamera = UnityEngine.Camera.main
    end
    self.m_anchoredPos =  self.bubbleRect.anchoredPosition
    self:ShowOrHideSelf(self:JudgeSelfIsShow())
end

--判断是否在屏幕内
function UIBubbleGroundAucItem:JudgeSelfIsShow()
    if  self.m_anchoredPos ~= nil then
        if self.m_anchoredPos.x >= minAnchorX and  self.m_anchoredPos.x <= maxAnchorX and self.m_anchoredPos.y >= minAnchorY and  self.m_anchoredPos.y <= maxAnchorY  then
            return true
        end
    end
    return false
end

--判断是否在屏幕内
function UIBubbleGroundAucItem:IsMove()
    --先判断是否是在屏幕显示范围内，做显示/隐藏处理
    self:ShowOrHideSelf(self:JudgeSelfIsShow())
    --根据是否在屏幕范围内显示隐藏自身
    if self.IsShow then
        self.bubbleRect.anchoredPosition = self.m_anchoredPos
    end
end

function UIBubbleGroundAucItem:ShowOrHideSelf(tempBool)
    if type(tempBool) == "boolean" and tempBool ~= self.IsShow then
        self.IsShow = tempBool
        self.bubbleObj:SetActive(self.IsShow)
    end
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
        self:_checkHighestPrice(data)
        self.isStartBid = true
        --self.noneBidText02.transform.localScale = Vector3.zero
        --self.nowBinding.localScale = Vector3.one
        self.noneBidText02.gameObject:SetActive(false)
        self.nowBinding.gameObject:SetActive(true)
    end
end
--判断是否是最高价
function UIBubbleGroundAucItem:_checkHighestPrice(data)
    if self.data.bidHistory == nil then
        self.data.bidHistory = {}
        local temp = {biderId = data.biderId, price = data.price, ts = data.ts}
        table.insert(self.data.bidHistory, 1, temp)
        self.data.endTs = data.ts + GAucModel.BidTime
        return
    end

    local tempHigh = self.data.bidHistory[1]
    if tempHigh.price < data.price then
        local temp = {biderId = data.biderId, price = data.price, ts = data.ts}
        table.insert(self.data.bidHistory, 1, temp)
        self.data.endTs = data.ts + GAucModel.BidTime
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
    self.nowText01.text = GetLanguage(21010001)
    self.soonText02.text = GetLanguage(21010009)
    self.noneBidText02.text = GetLanguage(21010001)
end

--小地图需要的数据
function UIBubbleGroundAucItem:getValuableData()
    if self.data ~= nil then
        local temp = {}
        temp.id = self.data.id
        temp.isStartAuc = self.data.isStartAuc
        temp.bidHistory = self.data.bidHistory
        temp.isStartBid = self.isStartBid
        temp.endTs = self.data.endTs
        return temp
    end
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
    if self.bubbleObj ~= nil and self.data.targetPos ~=nil then
        self.m_anchoredPos  = ScreenPosTurnActualPos(mainCamera:WorldToScreenPoint(self.data.targetPos + Vector3.New(0.5, 0, 0.5)))
        self:IsMove()
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
            GAucModel._returnNowToPool(self.groundGo)
            --拍卖结束
            UIBubbleManager.closeItem(self, self.data.id)
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
           --self.now.transform.localScale = Vector3.one
           --self.soon.transform.localScale = Vector3.zero
           --self.noneBidText02.transform.localScale = Vector3.one
           --self.nowBinding.localScale = Vector3.zero
            self.now.gameObject:SetActive(true)
            self.soon.gameObject:SetActive(false)
            self.noneBidText02.gameObject:SetActive(true)
            self.nowBinding.gameObject:SetActive(false)
            GAucModel._returnSoonToPool(self.groundGo)
            self.groundGo = GAucModel._getValuableStartAucObj(GroundAucConfig[self.data.id].area)
            GAucModel.updateSoonItem(self.data.id + 1)
            Event.Brocast("c_BidStart", self.data)  --切换界面
            return
        end

        local timeTable = getFormatUnixTime(remainTime / 1000)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.soonTimeText.text = timeStr
    end
end