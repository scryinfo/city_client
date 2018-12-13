---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/28 17:36
---
LabBuildingInventionItem = class('LabBuildingInventionItem')
LabBuildingInventionItem.static.NoRollColor = Vector3.New(22, 38, 94)  --没有成果时候的颜色

function LabBuildingInventionItem:initialize(data, viewRect)
    self.viewRect = viewRect

    local viewTrans = self.viewRect
    self.nameText = viewTrans:Find("topRoot/nameText"):GetComponent("Text")
    self.iconImg = viewTrans:Find("mainRoot/iconImg"):GetComponent("Image")
    self.bulbImg = viewTrans:Find("mainRoot/progressRoot/bulbImg"):GetComponent("Image")
    self.timeDownText = viewTrans:Find("mainRoot/progressRoot/progressSlider/bg/timeDownText"):GetComponent("Text")
    self.progressCountText = viewTrans:Find("mainRoot/progressRoot/right/bulbImg/progressCountText"):GetComponent("Text")
    self.phaseItems = LabInventionItemPhaseItems:new(viewTrans:Find("mainRoot/successItems"))
    self.progressSlider = viewTrans:Find("mainRoot/progressRoot/progressSlider"):GetComponent("Slider")

    self:_initData()
    UpdateBeat:Add(self._update, self)
end
function LabBuildingInventionItem:_initData(data)
    self.data = data
    self.leftSec = self.data.leftSec
    local itemInfo = Material[data.itemId]
    if not itemInfo then
        itemInfo = Good[data.itemId]
    end
    if not itemInfo.name then
        ct.log("", "找不到itemId对应的数据"..self.itemId)
        return
    end

    self.nameText.text = itemInfo.name
    --self.iconImg.sprite =
    self.formularData = FormularConfig[data.itemId]
    self.progressSlider.maxValue = self.formularData.phaseSec
    if data.roll > 0 then
        self.bulbImg.color = Color.white
        self.progressCountText.text = tostring(data.roll)
    else
        self.bulbImg.color = getColorByVector3(LabBuildingInventionItem.static.NoRollColor)
        self.progressCountText.transform.localScale = Vector3.zero
    end

    --显示阶段状态
    self.phaseStates = {}
    for i = 1, self.formularData.phase do
        self.phaseStates[i] = LabInventionItemPhaseState.Null
    end
    for i = 1, data.rollTarget do
        self.phaseStates[i] = LabInventionItemPhaseState.WillTo
    end
    for i = 1, data.phase do
        self.phaseStates[i] = LabInventionItemPhaseState.Finish
    end
    self.phaseItems:showState(self.phaseStates)  --显示5个阶段的状态
    self.startTimeDown = true
end
--倒计时
function LabBuildingInventionItem:_update()
    if self.startTimeDown then
        self.leftSec = self.leftSec - UnityEngine.Time.unscaledDeltaTime
        if self.leftSec < 0 then
            self.startTimeDown = false
            self.progressSlider.value = self.formularData.phaseSec
            return
        end
        local timeTable = getTimeBySec(self.leftSec)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        self.timeDownText.text = timeStr
        self.progressSlider.value = self.formularData.phaseSec - self.leftSec
    end
end