---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/5/27 11:37
---
FlightMainPageItem = class('FlightMainPageItem')
FlightMainPageItem.static.OccupancyTextColor = "#FFFFFF"

--初始化方法
function FlightMainPageItem:initialize(viewRect, data)
    self.viewRect = viewRect.transform

    self.btn = self.viewRect:Find("btn"):GetComponent("Button")
    --self.rateText = self.viewRect:Find("rateText"):GetComponent("Text")  --准点率
    self.flightText = self.viewRect:Find("flightText"):GetComponent("Text")  --航班名称
    self.numText = self.viewRect:Find("timeText/numText"):GetComponent("Text")  --航班号
    self.betMoneyText = self.viewRect:Find("betMoney"):GetComponent("Text")  --累积投注
    self.timeText = self.viewRect:Find("timeText"):GetComponent("Text")  --航班时间
    self.startPlaceText = self.viewRect:Find("startPlaceText"):GetComponent("Text")  --起始位置
    self.endPlaceText = self.viewRect:Find("endPlaceText"):GetComponent("Text")  --目的地
    self.startCodeText = self.viewRect:Find("startCodeText"):GetComponent("Text")  --起始位置code
    self.endCodeText = self.viewRect:Find("endCodeText"):GetComponent("Text")  --目的地code
    self.alreadyTran = self.viewRect:Find("alreadyRoot")  --已投注的标识

    self.betMoneyText01 = self.viewRect:Find("betMoney/Text"):GetComponent("Text")  --累积押注
    self.alreadyTranText02 = self.viewRect:Find("alreadyRoot/Text"):GetComponent("Text")  --已押注
    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        self:ClickFunc()
    end)

    self:initData(data)
end
--刷新数据
function FlightMainPageItem:initData(data)
    local trueWidth01 = self.timeText.preferredWidth
    self.timeText.rectTransform.sizeDelta = Vector2.New(trueWidth01, self.timeText.rectTransform.sizeDelta.y)

    self.betMoneyText.text = data
    local trueWidth02 = self.betMoneyText.preferredWidth
    self.betMoneyText.rectTransform.sizeDelta = Vector2.New(trueWidth02, self.betMoneyText.rectTransform.sizeDelta.y)
end
--
function FlightMainPageItem:Language()
    self.betMoneyText01.text = GetLanguage(32030005)
    self.alreadyTranText02.text = GetLanguage(32030029)
end
--
function FlightMainPageItem:ClickFunc()

end
--
function FlightMainPageItem:Close()

end

