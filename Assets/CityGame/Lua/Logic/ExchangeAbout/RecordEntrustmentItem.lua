---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/20 10:33
---交易委托记录

RecordEntrustmentItem = class('RecordEntrustmentItem')
RecordEntrustmentItem.static.SELL_GREEN = "#0B7B16"  --卖出的绿色数值
RecordEntrustmentItem.static.BUY_RED = "#E42E2E"
RecordEntrustmentItem.static.BAR_GREEN = Vector3.New(77,176,140)  --卖出的进度条颜色
RecordEntrustmentItem.static.BAR_RED = Vector3.New(192,88,88)
RecordEntrustmentItem.static.SliderImgMaxSizeDelta = Vector2.New(520, 30)  --委托进度条

--初始化方法
function RecordEntrustmentItem:initialize(data, viewRect)
    self.viewRect = viewRect;
    self.data = data;

    local viewTrans = self.viewRect;
    self.nameText = viewTrans:Find("name/nameText"):GetComponent("Text");
    self.iconImg = viewTrans:Find("name/iconBg/Image"):GetComponent("Image");

    self.quantityText = viewTrans:Find("quantity/quantityText"):GetComponent("Text");
    self.unitPriceText = viewTrans:Find("unitPrice/unitPriceText"):GetComponent("Text");
    self.totalText = viewTrans:Find("total/totalText"):GetComponent("Text");
    self.currentText = viewTrans:Find("current/currentText"):GetComponent("Text");
    self.progressText = viewTrans:Find("current/progressText"):GetComponent("Text");
    self.sliderImg = viewTrans:Find("current/slider/sliderImg"):GetComponent("Image");

    self.deleteBtn = viewTrans:Find("deleteBtn"):GetComponent("Button");
    self:_initData()

    self.deleteBtn.onClick:RemoveAllListeners();
    self.deleteBtn.onClick:AddListener(function ()
        self:_clickDeleteBtn()
    end)
end

--初始化界面
function RecordEntrustmentItem:_initData()
    local data = self.data
    self.nameText.text = data.name
    if data.sell then
        self.currentTextColor = RecordEntrustmentItem.static.SELL_GREEN
        self.currentBarColor = RecordEntrustmentItem.static.BAR_GREEN
    else
        self.currentTextColor = RecordEntrustmentItem.static.BUY_RED
        self.currentBarColor = RecordEntrustmentItem.static.BAR_RED
    end
    self.quantityText.text = string.format("<color=%s>%s</color>", self.currentTextColor, data.dealedAmount)
    self.unitPriceText.text = string.format("<color=%s>E%s</color>", self.currentTextColor, getPriceString(data.price, 30, 24))
    self.totalText.text = string.format("<color=%s>E%s</color>", self.currentTextColor, getPriceString(data.totalAmount, 30, 24))
    self.currentText.text = "E"..data.dealedPrice
    self.sliderImg.color = getColorByVector3(self.currentBarColor)
    self:_setSliderValue(data.dealedAmount, data.totalAmount)

end

--点击删除按钮
function RecordEntrustmentItem:_clickDeleteBtn()
    --打开弹框
    local showData = {}
    --local str1
    --if self.sell then
    --    str1 = "sell"
    --else
    --    str1 = "buy"
    --end
    --showData.contentInfo = string.format("Entrust to %s <color=%s>%s</color>x%d?", str1, "#CA8A00", self.name, self.dealed)
    showData.titleInfo = "REMINDER"
    showData.contentInfo = "Confirm to cancel the delegate?"
    showData.tipInfo = ""
    showData.btnCallBack = function()
        log("cycle_w11_exchange03", "向服务器发送请求")
        Event.Brocast("m_ReqExchangeCancel", self.id)
        Event.Brocast("c_onExchangeOrderCanel", self.idInTable)  --不确定idInTable是否有值
    end
    CityGlobal.OpenCtrl("BtnDialogPageCtrl", showData)
end

--设置slider的值
function RecordEntrustmentItem:_setSliderValue(remainCount, totalCount)
    local width = RecordEntrustmentItem.static.SliderImgMaxSizeDelta.x * (remainCount / totalCount)
    self.sliderImg.rectTransform.sizeDelta = Vector2.New(width, RecordEntrustmentItem.static.SliderImgMaxSizeDelta.y)
    self.progressText.text = string.format("%d/%d", remainCount, totalCount)
end

--刷新数据
function RecordEntrustmentItem:UpdateInfo(data)
    self.data.dealedPrice = self.data.dealedPrice + data.num * data.price  --累计的当前成交金额
    self.data.dealedAmount = self.data.dealedAmount + data.num  --累计的成交数量
    self:_setSliderValue(self.data.dealedAmount, self.data.totalAmount)
    self.currentText.text = "E"..self.data.dealedPrice

    if self.data.totalAmount <= self.data.dealedAmount then
        return true
    else
        return false
    end
end