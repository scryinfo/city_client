---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/5/27 11:37
---
FlightRecordPageItem = class('FlightRecordPageItem')

--Initialization method
function FlightRecordPageItem:initialize(viewRect, data)
    self.viewRect = viewRect.transform

    self.btn = self.viewRect:Find("btn"):GetComponent("Button")
    self.flightText = self.viewRect:Find("flightText"):GetComponent("Text")  --Flight name
    self.numText = self.viewRect:Find("timeText/numText"):GetComponent("Text")  --flight number
    self.timeText = self.viewRect:Find("timeText"):GetComponent("Text")  --flight schedule
    self.betResultText = self.viewRect:Find("Text"):GetComponent("Text")  --Win or lose display
    self.moneyText = self.viewRect:Find("Text/moneyText"):GetComponent("Text")  --money

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        self:ClickFunc()
    end)

    self:initData(data)
end
--Refresh data
function FlightRecordPageItem:initData(data)
    self.data = data
    local flightData = data.data
    self.timeText.text = self:_getDayStr(flightData.FlightDeptimePlanDate)  --Planned departure time  -- accurate to days
    self.flightText.text = ct.GetFlightCompanyName(flightData.FlightNo)
    self.numText.text = flightData.FlightNo  --CA4506

    local trueWidth01 = self.timeText.preferredWidth
    self.timeText.rectTransform.sizeDelta = Vector2.New(trueWidth01, self.timeText.rectTransform.sizeDelta.y)

    if data.win == nil then
        self.betResultText.text = GetLanguage(32040001)  --Bet
        self.moneyText.text = data.amount  --Bet amount
        return
    end

    if data.win == true then
        self.betResultText.text = GetLanguage(32040003)  --win
        self.moneyText.text = data.amount  --Net earning points
    else
        self.betResultText.text = GetLanguage(32040002)  --lose
        self.moneyText.text = "-"..data.amount
    end
end
--Get the time in 2019-05-01 format
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
function FlightRecordPageItem:_updateText()
    local str1 = self.flightText.text
    if str1 == "" then
        str1 = GetLanguage(32030035)  --No data
    end
    self.flightText.text = ct.getFlightSubString(str1, 33, 18)
end
--
function FlightRecordPageItem:Close()

end

