---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/15 17:19
---交易所行情item

ExchangeQuoteItem = class('ExchangeQuoteItem')
ExchangeQuoteItem.static.CHANGE_GREEN = "#0B7B16"  --改变量的绿色数值
ExchangeQuoteItem.static.CHANGE_RED = "#E42E2E"

--初始化方法
function ExchangeQuoteItem:initialize(data, viewRect)
    self.viewRect = viewRect;
    self.data = data;

    local viewTrans = self.viewRect;
    self.nameText = viewTrans:Find("name/nameText"):GetComponent("Text");
    self.iconImg = viewTrans:Find("name/iconBg/Image"):GetComponent("Image");
    self.collectBtn = viewTrans:Find("name/collectRoot/btn"):GetComponent("Button");
    self.collectGrayTran = viewTrans:Find("name/collectRoot/gray");
    self.collectYellowTran = viewTrans:Find("name/collectRoot/yellow");

    self.lastPriceText = viewTrans:Find("lastPrice/lastPriceText"):GetComponent("Text");
    self.lastPriceGreenTran = viewTrans:Find("lastPrice/green");
    self.lastPriceRedTran = viewTrans:Find("lastPrice/red");
    self.changeText = viewTrans:Find("change/changeText"):GetComponent("Text");
    self.highText = viewTrans:Find("high/highText"):GetComponent("Text");
    self.lowText = viewTrans:Find("low/lowText"):GetComponent("Text");
    self.volumeText = viewTrans:Find("volume/volumeText"):GetComponent("Text");
    self.exchangeBtn = viewTrans:Find("exchange/exchangeBtn"):GetComponent("Button");
    self.detailBtn = viewTrans:Find("detailBtn")
    if self.detailBtn ~= nil then
        self.detailBtn = self.detailBtn:GetComponent("Button");
    end
    self:_initData()

    self.collectBtn.onClick:RemoveAllListeners();
    self.collectBtn.onClick:AddListener(function ()
        self:_clickCollectBtn()
    end)
    self.exchangeBtn.onClick:RemoveAllListeners();
    self.exchangeBtn.onClick:AddListener(function ()
        self:_clickExchnageBtn()
    end)
    if self.detailBtn ~= nil then
        self.detailBtn.onClick:RemoveAllListeners();
        self.detailBtn.onClick:AddListener(function ()
            self:_clickDetailBtn()
        end)
    end
end

--初始化界面
function ExchangeQuoteItem:_initData()
    local data = self.data
    self:_setCollectState(data.isCollected)
    self.nameText.text = data.name
    self.lastPriceText.text = "E"..getPriceString(data.lastPrice, 30, 24)
    if data.change >= 0 then
        self.changeText.text = string.format("<color=%s>+%6.2f%%</color>", ExchangeQuoteItem.static.CHANGE_GREEN, data.change)
        --设置箭头位置
        self.lastPriceGreenTran.localScale = Vector3.one
        self.lastPriceRedTran.localScale = Vector3.zero
        local greenPos = self.lastPriceGreenTran.localPosition
        self.lastPriceGreenTran.localPosition = Vector3.New(-63 + self.lastPriceText.preferredWidth, greenPos.y, greenPos.z)
    else
        self.changeText.text = string.format("<color=%s>%6.2f%%</color>", ExchangeQuoteItem.static.CHANGE_RED, data.change)
        --设置箭头位置
        self.lastPriceGreenTran.localScale = Vector3.zero
        self.lastPriceRedTran.localScale = Vector3.one
        local redPos = self.lastPriceRedTran.localPosition
        self.lastPriceRedTran.localPosition = Vector3.New(-63 + self.lastPriceText.preferredWidth, redPos.y, redPos.z)
    end

    self.highText.text = "E"..data.high
    self.lowText.text = "E"..data.low
    self.volumeText.text = "E"..data.volume
end
--点击交易按钮
function ExchangeQuoteItem:_clickExchnageBtn()
    ct.OpenCtrl("ExchangeTransactionCtrl", self.data)
end
--点击打开详情
function ExchangeQuoteItem:_clickDetailBtn()
    ct.OpenCtrl("ExchangeDetailCtrl", self.data)
end
--点击收藏按钮
function ExchangeQuoteItem:_clickCollectBtn()
    self:_setCollectState(not self.data.isCollected)
    if self.data.isCollected then
        --向服务器发送取消收藏的信息
        ct.log("cycle_w9_exchange01", "取消收藏")
        self.data.isCollected = false
    else
        --向服务器发送收藏
        ct.log("cycle_w9_exchange01", "添加收藏")
        self.data.isCollected = true
    end
end

function ExchangeQuoteItem:_setCollectState(isCollected)
    if isCollected then
        self.collectYellowTran.localScale = Vector3.one;
        self.collectGrayTran.localScale = Vector3.zero;
    else
        self.collectYellowTran.localScale = Vector3.zero;
        self.collectGrayTran.localScale = Vector3.one;
    end
end




