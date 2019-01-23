---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/25 18:02
---
local transform
GroundTransDetailPanel = {}
local this = GroundTransDetailPanel

function GroundTransDetailPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function GroundTransDetailPanel.InitPanel()
    this.bgBtn = transform:Find("bgBtn")
    this.averageRangeText = transform:Find("root/bg02/averageRangeText")
    this.buildingCountBlackText = transform:Find("root/bg02/buildingRoot/buildingCount/buildingCountBlackText")  --叠在文下面的黑色文本
    this.buildingCountText = transform:Find("root/bg02/buildingRoot/buildingCount/buildingCountBlackText/buildingCountText")  --显示文字
    this.buildingScroll = transform:Find("root/bg02/buildingRoot/scroll"):GetComponent("ActiveLoopScrollRect")

    this.areaText = transform:Find("root/bg02/areaText")
    this.noneStateTran = transform:Find("root/bg02/stateBtnRoot/noneState")
    this.rentBtnTran = transform:Find("root/bg02/stateBtnRoot/noneState/rentBtn")
    this.sellBtnTran = transform:Find("root/bg02/stateBtnRoot/noneState/sellBtn")

    this.sellingBtnTran = transform:Find("root/bg02/stateBtnRoot/sellingBtn")
    this.rentingBtnTran = transform:Find("root/bg02/stateBtnRoot/rentingBtn")
    this.selfCheckBtnTran = transform:Find("root/bg02/stateBtnRoot/selfCheckBtn")
    this.otherCheckBtnTran = transform:Find("root/bg02/stateBtnRoot/otherCheckBtn")
    --
    this.titleText01 = transform:Find("root/bg02/Image/Text"):GetComponent("Text")
    this.averageText02 = transform:Find("root/bg02/Text01"):GetComponent("Text")
    this.buildingText03 = transform:Find("root/bg02/buildingRoot/buildingCount/Text"):GetComponent("Text")
    this.areaText04 = transform:Find("root/bg02/Text"):GetComponent("Text")
    this.rentText05 = transform:Find("root/bg02/stateBtnRoot/noneState/rentBtn/Text"):GetComponent("Text")
    this.sellText06 = transform:Find("root/bg02/stateBtnRoot/noneState/sellBtn/Text"):GetComponent("Text")
    this.sellingText07 = transform:Find("root/bg02/stateBtnRoot/sellingBtn/Text"):GetComponent("Text")
    this.rentingText08 = transform:Find("root/bg02/stateBtnRoot/rentingBtn/Text"):GetComponent("Text")
end
--关掉所有状态
function GroundTransDetailPanel._closeAllBtnTran()
    this.noneStateTran.localScale = Vector3.zero
    this.sellingBtnTran.localScale = Vector3.zero
    this.rentingBtnTran.localScale = Vector3.zero
    this.selfCheckBtnTran.localScale = Vector3.zero
    this.otherCheckBtnTran.localScale = Vector3.zero
end