---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/15 17:23
---
-----

local transform

ExchangePanel = {}
local this = ExchangePanel

function ExchangePanel.Awake(obj)
    transform = obj.transform

    this.InitPanel()
end

function ExchangePanel.InitPanel()
    this.noTipText = transform:Find("noTipText"):GetComponent("Text")

    this.quotesToggle = transform:Find("toggleRoot/quotes"):GetComponent("Toggle")
    this.quotesOpen = transform:Find("toggleRoot/quotes/open")
    this.quotesClose = transform:Find("toggleRoot/quotes/close")
    this.collectToggle = transform:Find("toggleRoot/collect"):GetComponent("Toggle")
    this.collectOpen = transform:Find("toggleRoot/collect/open")
    this.collectClose = transform:Find("toggleRoot/collect/close")
    this.recordToggle = transform:Find("toggleRoot/record"):GetComponent("Toggle")
    this.recordOpen = transform:Find("toggleRoot/record/open")
    this.recordClose = transform:Find("toggleRoot/record/close")
    this.backBtn = transform:Find("topRoot/backBtn")

    this.quotesPage = transform:Find("togglePageRoot/quotes")  --行情page
    this.titleRoot = transform:Find("togglePageRoot/quotes/titleRoot")
    this.quotesScroll = transform:Find("togglePageRoot/quotes/scrollRoot/scroll"):GetComponent("ActiveLoopScrollRect")
    this.collectPage = transform:Find("togglePageRoot/collect")  --收藏page
    this.collectTitleRoot = transform:Find("togglePageRoot/collect/titleRoot")
    this.collectScroll = transform:Find("togglePageRoot/collect/scrollRoot/scroll"):GetComponent("ActiveLoopScrollRect")

    this.recordPage = transform:Find("togglePageRoot/record")  --记录page
    this.entrustmentToggle = transform:Find("togglePageRoot/record/recordToggleRoot/entrustment"):GetComponent("Toggle")
    this.entrustmentShow = transform:Find("togglePageRoot/record/recordToggleRoot/entrustment/show")
    this.selfRecordToggle = transform:Find("togglePageRoot/record/recordToggleRoot/record"):GetComponent("Toggle")
    this.selfRecordShow = transform:Find("togglePageRoot/record/recordToggleRoot/record/show")
    this.cityRecordToggle = transform:Find("togglePageRoot/record/recordToggleRoot/cityRecord"):GetComponent("Toggle")
    this.cityRecordShow = transform:Find("togglePageRoot/record/recordToggleRoot/cityRecord/show")

    this.entrustmentPage = transform:Find("togglePageRoot/record/recordTogglePageRoot/entrustment")
    this.selfRecordPage = transform:Find("togglePageRoot/record/recordTogglePageRoot/record")
    this.cityRecordPage = transform:Find("togglePageRoot/record/recordTogglePageRoot/cityrecord")
    this.entrustmentScroll = transform:Find("togglePageRoot/record/recordTogglePageRoot/entrustment/scrollRoot/scroll"):GetComponent("ActiveLoopScrollRect")
    this.selfRecordScroll = transform:Find("togglePageRoot/record/recordTogglePageRoot/record/scrollRoot/scroll"):GetComponent("ActiveLoopScrollRect")
    this.cityRecordScroll = transform:Find("togglePageRoot/record/recordTogglePageRoot/cityrecord/scrollRoot/scroll"):GetComponent("ActiveLoopScrollRect")
    this.cityRecordDropfresh = transform:Find("togglePageRoot/record/recordTogglePageRoot/cityrecord/scrollRoot/scroll"):GetComponent("LoopDropfreshBar")


end
---行情收藏记录toggle
function ExchangePanel._quotesToggleState(isOn)
    if isOn then
        this.quotesOpen.localScale = Vector3.one
        this.quotesClose.localScale = Vector3.zero
    else
        this.quotesOpen.localScale = Vector3.zero
        this.quotesClose.localScale = Vector3.one
    end
end
function ExchangePanel._collectToggleState(isOn)
    if isOn then
        this.collectOpen.localScale = Vector3.one
        this.collectClose.localScale = Vector3.zero
    else
        this.collectOpen.localScale = Vector3.zero
        this.collectClose.localScale = Vector3.one
    end
end
function ExchangePanel._recordToggleState(isOn)
    if isOn then
        this.recordOpen.localScale = Vector3.one
        this.recordClose.localScale = Vector3.zero
    else
        this.recordOpen.localScale = Vector3.zero
        this.recordClose.localScale = Vector3.one
    end
end
---记录部分 --当前成交进度，成交记录，全城成交记录
function ExchangePanel._entrustmentToggleState(isOn)
    if isOn then
        this.entrustmentShow.localScale = Vector3.one
        --this.entrustmentPage.localScale = Vector3.one
    else
        this.entrustmentShow.localScale = Vector3.zero
        this.entrustmentPage.localScale = Vector3.zero
    end
end
function ExchangePanel._selfRecordToggleState(isOn)
    if isOn then
        this.selfRecordShow.localScale = Vector3.one
        --this.selfRecordPage.localScale = Vector3.one
    else
        this.selfRecordShow.localScale = Vector3.zero
        this.selfRecordPage.localScale = Vector3.zero
    end
end
function ExchangePanel._cityRecordToggleState(isOn)
    if isOn then
        this.cityRecordShow.localScale = Vector3.one
        --this.cityRecordPage.localScale = Vector3.one
    else
        this.cityRecordShow.localScale = Vector3.zero
        this.cityRecordPage.localScale = Vector3.zero
    end
end





