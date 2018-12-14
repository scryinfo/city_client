---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/28 17:37
---
LabBuildingResearchItem = class('LabBuildingResearchItem')
LabBuildingResearchItem.static.NoRollColor = Vector3.New(22, 38, 94)  --没有成果时候的颜色

function LabBuildingResearchItem:initialize(data, viewRect)
    self.viewRect = viewRect

    local viewTrans = self.viewRect
    self.nameText = viewTrans:Find("topRoot/nameText"):GetComponent("Text")
    self.levelText = viewTrans:Find("topRoot/levelText"):GetComponent("Text")
    self.levelUpImg = viewTrans:Find("topRoot/levelText/levelUpImg"):GetComponent("Image")
    self.iconImg = viewTrans:Find("mainRoot/iconImg"):GetComponent("Image")
    self.bottleImg = viewTrans:Find("mainRoot/right/bottleImg"):GetComponent("Image")
    self.progressSlider = viewTrans:Find("mainRoot/progressRoot/progressSlider"):GetComponent("Slider")
    self.timeDownText = viewTrans:Find("mainRoot/progressRoot/progressSlider/bg/timeDownText"):GetComponent("Text")

    self:_initData(data)
    UpdateBeat:Add(self._update, self)
end
function LabBuildingResearchItem:_initData(data)
    self.data = data
    self.leftSec = self.data.leftSec

    local goodData = Good[data.itemId]
    self.nameText.text = goodData.name
    --self.iconImg.sprite =
    self.levelText.text = data.lv
    self.phaseSec = FormularConfig[data.itemId].phaseSec
    self.progressSlider.maxValue = self.phaseSec

    if data.roll > 0 then
        self.bottleImg.color = Color.white
    else
        self.bottleImg.color = getColorByVector3(LabBuildingResearchItem.static.NoRollColor)
    end
    if self.run then
        self.startTimeDown = true
    end
end
--倒计时
function LabBuildingResearchItem:_update()
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
        self.progressSlider.value = self.phaseSec - self.leftSec
    end
end