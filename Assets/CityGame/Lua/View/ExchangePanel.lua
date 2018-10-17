---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/15 17:23
---
require "Common/define"
require "Logic/ExchangeAbout/ExchangeSortItem"
require "Logic/ExchangeAbout/ExchangeSortMgr"

local transform

ExchangePanel = {};
local this = ExchangePanel;

function ExchangePanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function ExchangePanel.InitPanel()
    this.quotesToggle = transform:Find("toggleRoot/quotes"):GetComponent("Toggle");
    this.quotesOpen = transform:Find("toggleRoot/quotes/open");
    this.quotesClose = transform:Find("toggleRoot/quotes/close");
    this.collectToggle = transform:Find("toggleRoot/collect"):GetComponent("Toggle");
    this.collectOpen = transform:Find("toggleRoot/collect/open");
    this.collectClose = transform:Find("toggleRoot/collect/close");
    this.recordToggle = transform:Find("toggleRoot/record"):GetComponent("Toggle");
    this.recordOpen = transform:Find("toggleRoot/record/open");
    this.recordClose = transform:Find("toggleRoot/record/close");

    this.recordPage = transform:Find("togglePageRoot/record");  --记录page
    this.quotesAndCollectPage = transform:Find("togglePageRoot/quotesAndCollect");  --行情收藏page

    this.titleRoot = transform:Find("togglePageRoot/quotesAndCollect/titleRoot");
    this.sortMgr = ExchangeSortMgr:new(this.titleRoot)
end

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




