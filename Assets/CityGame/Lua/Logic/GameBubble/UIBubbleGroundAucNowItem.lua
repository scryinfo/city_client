---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/21 16:35
---土地拍卖已经开始气泡
UIBubbleGroundAucNowItem = class('UIBubbleGroundAucNowItem')
function UIBubbleGroundAucNowItem:initialize(data)
    self.data = data
    self.bubbleRect = data.bubbleRect

    local viewTrans = self.bubbleRect.transform
    self.nowTimeText = viewTrans:Find("bgBtn/timeDownRoot/nowTimeText"):GetComponent("Text")
    self.bgBtn = viewTrans:Find("bgBtn"):GetComponent("Button")

    self.bgBtn.onClick:RemoveAllListeners()
    self.bgBtn.onClick:AddListener(function ()
        self:_clickBtn()
    end)

    self.currentTime = os.time()
    self.startTimeDown = true
    self.timeDown = true
    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
    Event.AddListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
    --UpdateBeat:Add(self.Update, self)
    --LateUpdateBeat:Add(self.LateUpdate, self)
end

--打开拍卖界面，即将拍卖
function UIBubbleGroundAucNowItem:_clickBtn()
    ct.OpenCtrl("GroundAuctionCtrl", self.data)
end

--信息更新
function UIBubbleGroundAucNowItem:_bidInfoUpdate(data)
    if data.id == self.data.id then
        self.data.price = data.num
    end
end

function UIBubbleGroundAucNowItem:Close()
    self.timeDown = false
    Event.RemoveListener("c_RefreshLateUpdate", self.LateUpdate, self)
    Event.RemoveListener("c_BidInfoUpdate", self._bidInfoUpdate, self)
end

function UIBubbleGroundAucNowItem:LateUpdate()
    if not self.timeDown then
        return
    end
    if self.data.groundObj and self.bubbleRect then
        --update 预制与ui item 之间的位置
        self.bubbleRect.anchoredPosition = UnityEngine.Camera.main:WorldToScreenPoint(self.data.groundObj.transform.position + Vector3.New(0.5, 0.5, 0.05))
    else
        ct.log("cycle_w6_GroundAuc", "---------------")
    end
    --倒计时
    if self.startTimeDown then
        --倒计时
        local finishTime = self.data.beginTime + self.data.durationSec
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime

        local remainTime = finishTime - self.currentTime
        if remainTime < 0 then
            self.startTimeDown = false
            --self.data.elmObj.transform.localScale = Vector3.zero
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.minute..":"..timeTable.second
        self.nowTimeText.text = timeStr

        if self.currentTime >= finishTime then
            self.startTimeDown = false
            --self.data.elmObj.transform.localScale = Vector3.zero
            return
        end
    end

end