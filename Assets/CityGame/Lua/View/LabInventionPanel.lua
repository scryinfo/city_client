---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/29 18:35
---
local transform
LabInventionPanel = {}
local this = LabInventionPanel

function LabInventionPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function LabInventionPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn")
    this.levelText = transform:Find("bottomRoot/left/levelRoot/levelText"):GetComponent("Text")
    this.progressSuccessTran = transform:Find("bottomRoot/left/progressRoot/successImg")  --完成时显示的图片
    this.progressWorkingImg = transform:Find("bottomRoot/left/progressRoot/workingImg/progressImg"):GetComponent("Image")  --正在发明中，设置fill amount
    this.timeDownText = transform:Find("bottomRoot/left/progressRoot/workingImg/timeDownText"):GetComponent("Text")  --倒计时
    this.emptyTextTran = transform:Find("bottomRoot/left/progressRoot/emptyText")  --还未点击研究时的显示

    this.itemNameText = transform:Find("bottomRoot/right/titleBg/itemNameText"):GetComponent("Text")
    this.iconImg = transform:Find("bottomRoot/right/iconImg"):GetComponent("Image")

    this.twoLineTran = transform:Find("bottomRoot/right/twoLine")
    this.twoLineItem = LabFormulaItem:new(this.twoLine)
    this.threeLineTran = transform:Find("bottomRoot/right/threeLine")
    this.threeLineItem = LabFormulaItem:new(this.threeLineTran)
    this.researchBtn = transform:Find("bottomRoot/workingImg/researchBtn")
end