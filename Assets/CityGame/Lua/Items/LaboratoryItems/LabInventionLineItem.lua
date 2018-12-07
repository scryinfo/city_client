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
    self.closeBtn = viewTrans:Find("itemBtn"):GetComponent("Button")
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

    end)
    self.closeBtn.onClick:RemoveAllListeners()
    self.closeBtn.onClick:AddListener(function ()
        self:_clickDeleteBtn()
    end)
    --self.staffScrollbar.onValueChanged:RemoveAllListeners()
    --self.staffScrollbar.onValueChanged:AddListener(function()
    --
    --end)
end

--初始化界面
function LabInventionLineItem:_initData(data)
    self.data = data
    self.leftSec = data.leftSec
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
    self.staffText.text = tostring(data.workerNum)
    self.formularData = FormularConfig[data.itemId]
    --self.staffSlider.maxValue = self.formularData.phaseSec
    self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, 0)
    if data.roll > 0 then
        self.bulbImg.color = Color.white
        self.progressCountText.text = tostring(data.roll)
    else
        self.bulbImg.color = getColorByVector3(LabInventionLineItem.static.NoRollColor)
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
--点击删除按钮
function LabInventionLineItem:_clickDeleteBtn()
    local info = {}
    info.titleInfo = "WARNING"
    info.contentInfo = "Delete the advertisment?"
    info.tipInfo = "(The statistical data of brand will be reset!)"
    info.btnCallBack = function ()
        Event.Brocast("")
    end
    ct.OpenCtrl("BtnDialogPageCtrl", info)
end
--点击发明界面
function LabInventionLineItem:_clickOpenInventionPanelBtn()
    ct.OpenCtrl("ExchangeTransactionCtrl", self.data)
end
--倒计时
function LabInventionLineItem:_update()
    if self.startTimeDown then
        self.leftSec = self.leftSec - UnityEngine.Time.unscaledDeltaTime
        if self.leftSec < 0 then
            self.startTimeDown = false
            self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, LabInventionLineItem.static.FinishBulbHight)
            return
        end
        local timeTable = getTimeBySec(self.leftSec)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        self.timeDownText.text = timeStr
        local height = (self.formularData.phaseSec - self.leftSec) / self.formularData.phaseSec * LabInventionLineItem.static.FinishBulbHight
        self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, height)
    end
end