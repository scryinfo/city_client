---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/17 16:36
---
local transform
LabScientificLinePanel = {}
local this = LabScientificLinePanel

function LabScientificLinePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function LabScientificLinePanel.InitPanel()
    this.researchBtn = transform:Find("titleRoot/research/Btn"):GetComponent("Button")
    this.researchOpen = transform:Find("titleRoot/research/open")
    this.researchClose = transform:Find("titleRoot/research/close")
    this.inventionBtn = transform:Find("titleRoot/invention/Btn"):GetComponent("Button")
    this.inventionOpen = transform:Find("titleRoot/invention/open")
    this.inventionClose = transform:Find("titleRoot/invention/close")
    this.backBtn = transform:Find("topRoot/backBtn"):GetComponent("Button")
    this.staffCountText = transform:Find("titleRoot/staffRoot/staffCountText"):GetComponent("Text")

    this.researchScroll = transform:Find("bottomPageRoot/research/scroll"):GetComponent("ActiveLoopScrollRect")
    this.inventionScroll = transform:Find("bottomPageRoot/invention/scroll"):GetComponent("ActiveLoopScrollRect")

    --提示框部分
    this.changeStaffCountBtn = transform:Find("changeStaffCountBtn"):GetComponent("Button")
    this.researchTipItem = LabScientificChangeStaffItem:new(transform:Find("changeStaffCountBtn/researchChangeStaffItem"), this.changeStaffCountBtn)
    this.inventTipItem = LabScientificChangeStaffItem:new(transform:Find("changeStaffCountBtn/inventChangeStaffItem"), this.changeStaffCountBtn)
end
---状态显示
function LabScientificLinePanel._researchToggleState(isOn)
    if isOn then
        this.researchOpen.localScale = Vector3.one
        this.researchClose.localScale = Vector3.zero
        this.researchScroll.transform.localScale = Vector3.one
    else
        this.researchOpen.localScale = Vector3.zero
        this.researchClose.localScale = Vector3.one
        this.researchScroll.transform.localScale = Vector3.zero
    end
end
function LabScientificLinePanel._inventionToggleState(isOn)
    if isOn then
        this.inventionOpen.localScale = Vector3.one
        this.inventionClose.localScale = Vector3.zero
        this.inventionScroll.transform.localScale = Vector3.one
        --this.inventionScroll.gameObject:SetActive(true)
    else
        this.inventionOpen.localScale = Vector3.zero
        this.inventionClose.localScale = Vector3.one
        this.inventionScroll.transform.localScale = Vector3.zero
        --this.inventionScroll.gameObject:SetActive(false)
    end
end