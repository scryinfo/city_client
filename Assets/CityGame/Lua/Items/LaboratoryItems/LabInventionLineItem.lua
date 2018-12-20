---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/19 15:20
---
LabInventionLineItem = class('LabInventionLineItem')
LabInventionLineItem.static.NoRollColor = Vector3.New(22, 38, 94)  --没有成果时候的颜色
LabInventionLineItem.static.FinishBulbHight = 176  --进度完成时灯泡背景的最高高度

function LabInventionLineItem:initialize(data, viewRect)
    self.viewRect = viewRect

    local viewTrans = self.viewRect
    self.nameText = viewTrans:Find("topRoot/nameText"):GetComponent("Text")
    self.itemBtn = viewTrans:Find("itemBtn"):GetComponent("Button")
    self.closeBtn = viewTrans:Find("topRoot/closeBtn"):GetComponent("Button")
    self.iconImg = viewTrans:Find("mainRoot/iconImg"):GetComponent("Image")
    self.staffText = viewTrans:Find("mainRoot/staffRoot/staffText"):GetComponent("Text")
    self.staffSlider = viewTrans:Find("mainRoot/staffRoot/staffSlider"):GetComponent("Slider")

    self.progressImgRect = viewTrans:Find("mainRoot/progressRoot/progressImg")
    self.bulbImg = viewTrans:Find("mainRoot/progressRoot/bulbImg"):GetComponent("Image")
    self.timeDownText = viewTrans:Find("mainRoot/progressRoot/timeDownText"):GetComponent("Text")
    self.progressCountText = viewTrans:Find("mainRoot/progressRoot/bulbImg/progressCountText"):GetComponent("Text")
    self.phaseItems = LabInventionItemPhaseItems:new(viewTrans:Find("mainRoot/successItems"))

    self:_initData(data)
    UpdateBeat:Add(self._update, self)

    self.itemBtn.onClick:RemoveAllListeners()
    self.itemBtn.onClick:AddListener(function ()
        ct.OpenCtrl("LabInventionCtrl", self.data, self.viewRect)
    end)
    self.closeBtn.onClick:RemoveAllListeners()
    self.closeBtn.onClick:AddListener(function ()
        self:_clickDeleteBtn()
    end)
    self.staffSlider.onValueChanged:RemoveAllListeners()
    self.staffSlider.onValueChanged:AddListener(function()
        self.staffSlider.value = data.workerNum
        Event.Brocast("c_OpenChangeStaffTip", self.data, self.viewRect)
    end)
    Event.AddListener("c_LabLineInfoUpdate", function (data)
        self:_updateInfo(data)
    end)
end

--初始化界面
function LabInventionLineItem:_initData(data)
    self.data = data
    local itemInfo = Material[data.itemId]
    if not itemInfo then
        itemInfo = Good[data.itemId]
    end
    if not itemInfo.name then
        ct.log("", "找不到itemId对应的数据"..self.itemId)
        return
    end
    self.data.itemInfo = itemInfo
    self.nameText.text = itemInfo.name
    --self.iconImg.sprite =
    self.staffText.text = tostring(data.workerNum)
    self.formularData = FormularConfig[1][data.itemId]
    --self.staffSlider.maxValue = self.formularData.phaseSec
    self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, 0)
    if not data.roll or data.roll <= 0 then
        self.bulbImg.color = getColorByVector3(LabInventionLineItem.static.NoRollColor)
        self.progressCountText.transform.localScale = Vector3.zero
    else
        self.bulbImg.color = Color.white
        self.progressCountText.text = tostring(data.roll)
    end

    --显示阶段状态
    self.data.phaseStates = {}
    for i = 1, self.formularData.phase do
        self.data.phaseStates[i] = LabInventionItemPhaseState.Null
    end
    if data.rollTarget then
        for i = 1, data.rollTarget do
            self.data.phaseStates[i] = LabInventionItemPhaseState.WillTo
        end
    end
    if data.phase then
        for i = 1, data.phase do
            self.data.phaseStates[i] = LabInventionItemPhaseState.Finish
        end
    end
    self.phaseItems:showState(self.data.phaseStates)  --显示5个阶段的状态
    self.startTimeDown = true
    self.timeDownText.transform.localScale = Vector3.one
    self.currentTime = os.time()
    if not self.data.run then
        self.startTimeDown = false
        self.timeDownText.transform.localScale = Vector3.zero
    end
end
--刷新数据
function LabInventionLineItem:_updateInfo(data)
    if data.id ~= self.data.id then
        return
    end
    --成果展示
    self.data.roll = data.roll
    self.data.leftSec = data.leftSec
    self.data.run = data.run
    if data.roll > 0 then
        self.bulbImg.color = Color.white
        self.progressCountText.text = tostring(data.roll)
    else
        self.bulbImg.color = getColorByVector3(LabInventionLineItem.static.NoRollColor)
        self.progressCountText.transform.localScale = Vector3.zero
    end
    --阶段显示
    for i = 1, data.phase do
        self.phaseStates[i] = LabInventionItemPhaseState.Finish
    end
    self.startTimeDown = true
    --self.currentTime = os.time()
    self.timeDownText.transform.localScale = Vector3.one
    if not self.data.run then
        self.startTimeDown = false
        self.timeDownText.transform.localScale = Vector3.zero
    end
end

--点击删除按钮
function LabInventionLineItem:_clickDeleteBtn()
    local info = {}
    info.titleInfo = "WARNING"
    info.contentInfo = "Delete the inventionLine?"
    info.tipInfo = "(The statistical data of brand will be reset!)"
    info.btnCallBack = function ()
        Event.Brocast("m_ReqLabDeleteLine", self.data.id)
    end
    ct.OpenCtrl("BtnDialogPageCtrl", info)
end
--倒计时
function LabInventionLineItem:_update()
    if self.startTimeDown then
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime
        local remainTime = self.data.finishTime - self.currentTime
        if remainTime < 0 then
            self.startTimeDown = false
            self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, LabInventionLineItem.static.FinishBulbHight)
            self.data.roll = self.data.roll + 1
            self.bottleImg.color = Color.white
            self.data.run = false
            return
        end

        local timeTable = getFormatUnixTime(remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        self.timeDownText.text = timeStr
        local height = (1 - remainTime / self.data.totalTime) * LabInventionLineItem.static.FinishBulbHight
        self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, height)

        if self.currentTime >= self.data.finishTime then
            self.startTimeDown = false
            self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, LabInventionLineItem.static.FinishBulbHight)
            self.data.roll = self.data.roll + 1
            self.bottleImg.color = Color.white
            self.data.run = false
            return
        end
    end
end