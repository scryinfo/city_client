---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/5/27 11:37
---
FlightRecordPageItem = class('FlightRecordPageItem')

--初始化方法
function FlightRecordPageItem:initialize(viewRect, data)
    self.viewRect = viewRect.transform

    self.btn = self.viewRect:Find("btn"):GetComponent("Button")
    self.flightText = self.viewRect:Find("flightText"):GetComponent("Text")  --航班名称
    self.numText = self.viewRect:Find("timeText/numText"):GetComponent("Text")  --航班号
    self.timeText = self.viewRect:Find("timeText"):GetComponent("Text")  --航班时间
    self.betResultText = self.viewRect:Find("Text"):GetComponent("Text")  --输赢显示
    self.moneyText = self.viewRect:Find("Text/moneyText"):GetComponent("Text")  --钱

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        self:ClickFunc()
    end)

    self:initData(data)
end
--刷新数据
function FlightRecordPageItem:initData(data)
    self.data = data
    local flightData = data.data
    self.timeText.text = self:_getDayStr(flightData.FlightDeptimePlanDate)  --计划起飞时间 --精确到天
    self.flightText.text = flightData.FlightCompany  --需要多语言
    self.numText.text = flightData.FlightNo  --CA4506

    local trueWidth01 = self.timeText.preferredWidth
    self.timeText.rectTransform.sizeDelta = Vector2.New(trueWidth01, self.timeText.rectTransform.sizeDelta.y)

    if data.win == nil then
        self.betResultText.text = GetLanguage(32040001)  --已投注
        self.moneyText.text = data.amount  --投注金额
        return
    end

    if data.win == true then
        self.betResultText.text = GetLanguage(32040003)  --赢
        self.moneyText.text = data.amount  --净赚积分
    else
        self.betResultText.text = GetLanguage(32040002)  --输
        self.moneyText.text = "-"..data.amount
    end
end
--获得2019-05-01格式的时间
function FlightRecordPageItem:_getDayStr(str)
    if str == nil or str == "" then
        return "--"
    end
    local temp = string.sub(str, 1, 10)
    return temp
end
--
function FlightRecordPageItem:ClickFunc()
    PlayMusEff(1002)
    ct.OpenCtrl("FlightDetailCtrl", {detail = self.data, dataType = 1})
end
--
function FlightRecordPageItem:Close()

end

