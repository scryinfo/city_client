---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/28 17:37
---
LabBuildingResearchItem = class('LabBuildingResearchItem')
LabBuildingResearchItem.static.NoRollColor = Vector3.New(22, 38, 94)  --Color when there is no fruit

function LabBuildingResearchItem:initialize(data, viewRect)
    self.viewRect = viewRect

    local viewTrans = self.viewRect
    self.nameText = viewTrans:Find("topRoot/nameText"):GetComponent("Text")
    self.levelText = viewTrans:Find("topRoot/levelText"):GetComponent("Text")
    self.levelUpImg = viewTrans:Find("topRoot/levelText/levelUpImg"):GetComponent("Image")
    self.iconImg = viewTrans:Find("mainRoot/iconImg"):GetComponent("Image")
    self.bottleImg = viewTrans:Find("mainRoot/progressRoot/right/bottleImg"):GetComponent("Image")
    self.progressSlider = viewTrans:Find("mainRoot/progressRoot/progressSlider"):GetComponent("Slider")
    self.timeDownText = viewTrans:Find("mainRoot/progressRoot/progressSlider/timeDownText"):GetComponent("Text")

    self:_initData(data)
    UpdateBeat:Add(self._update, self)
end
function LabBuildingResearchItem:_initData(data)
    self.data = data
    --self.leftSec = self.data.leftSec

    local goodData = Good[data.itemId]
    self.nameText.text = goodData.name
    LoadSprite(goodData.img, self.iconImg, true)
    self.iconImg:SetNativeSize()
    self.levelText.text = "Lv"..tostring(DataManager.GetMyGoodLvByItemId(data.itemId))
    self.progressSlider.maxValue = 1

    if data.roll > 0 then
        self.bottleImg.color = Color.white
        self.progressSlider.value = self.progressSlider.maxValue
    else
        self.progressSlider.value = 0
        self.bottleImg.color = getColorByVector3(LabBuildingResearchItem.static.NoRollColor)
    end
    if data.run then
        self.startTimeDown = true
        self.currentTime = os.time()
        self.timeDownText.transform.localScale = Vector3.one
    else
        self.startTimeDown = false
        self.timeDownText.transform.localScale = Vector3.zero
    end
end
--Countdown
function LabBuildingResearchItem:_update()
    if self.startTimeDown then
        self.currentTime = self.currentTime + UnityEngine.Time.unscaledDeltaTime
        local remainTime = self.data.finishTime - self.currentTime
        if remainTime < 0 then
            self.startTimeDown = false
            self.progressSlider.value = self.progressSlider.maxValue
            self.bottleImg.color = Color.white
            return
        end

        local timeTable = getTimeBySec(remainTime)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        self.timeDownText.text = timeStr
        self.progressSlider.value = 1 - remainTime / self.data.totalTime

        if self.currentTime >= self.data.finishTime then
            self.startTimeDown = false
            self.progressSlider.value = self.progressSlider.maxValue
            self.bottleImg.color = Color.white
            return
        end
    end
end