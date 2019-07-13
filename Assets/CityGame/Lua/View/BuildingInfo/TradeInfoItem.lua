---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/6/27 16:18
---交易详情item
TradeInfoItem = class('TradeInfoItem')
--初始化方法
function TradeInfoItem:initialize(dataInfo, viewRect)
    self.dataInfo = dataInfo
    self.viewRect = viewRect
    local viewTrans = self.viewRect
    viewTrans.localScale = Vector3.one

    self.name = viewTrans:Find("name"):GetComponent("Text")
    self.state = viewTrans:Find("name/state"):GetComponent("Image")
    self.defeated = viewTrans:Find("name/state/defeated"):GetComponent("Text")
    self.address = viewTrans:Find("address"):GetComponent("Text")
    self.addressText = viewTrans:Find("address/Text"):GetComponent("Text")
    self.money = viewTrans:Find("money"):GetComponent("Text")
    self.date = viewTrans:Find("date"):GetComponent("Text")

    self.moneys = tonumber(dataInfo.ddd)

    if self.moneys >= 0 then
        self.name.text = GetLanguage(33010002)
        self.money.text = "+" .. getMoneyString(ct.scientificNotation2Normal(self.moneys * 1000000))
        self.address.transform.localScale = Vector3.zero
    else
        self.name.text = GetLanguage(33010003)
        self.address.transform.localScale = Vector3.one
        self.address.text = GetLanguage(33040003)
        self.addressText.text = dataInfo.ddd_to
        self.money.text = getMoneyString(ct.scientificNotation2Normal(self.moneys * 1000000))
    end
    if dataInfo.status == 0 then
        self.defeated.transform.localScale = Vector3.zero
        LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/point.png", self.state, true)
        local ts = getFormatUnixTime(dataInfo.create_time/1000)
        self.date.text = ts.month .. "." .. ts.day .. "." .. ts.year .. " " .. ts.hour .. ":" .. ts.minute .. ":" .. ts.second
    elseif dataInfo.status == 1 then
        self.defeated.transform.localScale = Vector3.zero
        local ts = getFormatUnixTime(dataInfo.create_time/1000)
        self.date.text = ts.month .. "." .. ts.day .. "." .. ts.year .. " " .. ts.hour .. ":" .. ts.minute .. ":" .. ts.second
        LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/icon-greentick.png", self.state, true)
    elseif dataInfo.status == 2 then
        self.defeated.transform.localScale = Vector3.one
        self.defeated.text = GetLanguage(33040008)
        local ts = getFormatUnixTime(dataInfo.completion_time/1000)
        self.date.text = ts.month .. "." .. ts.day .. "." .. ts.year .. " " .. ts.hour .. ":" .. ts.minute .. ":" .. ts.second
        LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/icon-x.png", self.state, true)
    end

end
