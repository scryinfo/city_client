---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---
-----

FlightChooseDateCtrl = class('FlightChooseDateCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightChooseDateCtrl)

function FlightChooseDateCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function FlightChooseDateCtrl:bundleName()
    return "Assets/CityGame/Resources/View/FlightChooseDatePanel.prefab"
end

function FlightChooseDateCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function FlightChooseDateCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    local behaviour = self.gameObject:GetComponent('LuaBehaviour')
    behaviour:AddClick(self.backBtn.gameObject, function ()
        self:backFunc()
    end , self)
    behaviour:AddClick(self.confirmBtn.gameObject, function ()
        self:confirmFunc()
    end , self)
end

function FlightChooseDateCtrl:Refresh()
    self:_initData()
end

function FlightChooseDateCtrl:Active()
    UIPanel.Active(self)
    self:_language()
end

function FlightChooseDateCtrl:Hide()
    UIPanel.Hide(self)
    self.yearValue = nil
    self.monthValue = nil
    self.dayValue = nil
end
--
function FlightChooseDateCtrl:_getComponent(go)
    if go == nil then
        return
    end
    local trans = go.transform
    self.backBtn = trans:Find("root/title/backBtn")
    self.confirmBtn = trans:Find("root/confirmBtn")
    self.dateText = trans:Find("root/title/Text"):GetComponent("Text")
    --
    self.yearToggle = trans:Find("root/toggleRoot/year"):GetComponent("Toggle")
    self.monthToggle = trans:Find("root/toggleRoot/month"):GetComponent("Toggle")
    self.dayToggle = trans:Find("root/toggleRoot/day"):GetComponent("Toggle")
    --
    self.dayPage = trans:Find("root/pageRoot/day")
    self.dayMonthText = trans:Find("root/pageRoot/day/monthText"):GetComponent("Text")
    local weekValue = trans:Find("root/pageRoot/day/weekValue")
    local dayValue = trans:Find("root/pageRoot/day/dayValue")
    self:_dayItemsInit(dayValue)
    self:_weekInit(weekValue)
    self.monthPage = trans:Find("root/pageRoot/month")
    self:_monthItemsInit(self.monthPage)
    self.yearPage = trans:Find("root/pageRoot/year")
    self:_yearItemsInit(self.yearPage)

    --年月日
    self.yearToggleText01 = trans:Find("root/toggleRoot/year/Text"):GetComponent("Text")
    self.monthToggleText02 = trans:Find("root/toggleRoot/month/Text"):GetComponent("Text")
    self.dayToggleText03 = trans:Find("root/toggleRoot/day/Text"):GetComponent("Text")

    --
    self.yearToggle.onValueChanged:AddListener(function (isOn)
        if isOn then
            self:_toggleShowDate("year")
        end
    end)
    self.monthToggle.onValueChanged:AddListener(function (isOn)
        if isOn then
            self:_toggleShowDate("month")
        end
    end)
    self.dayToggle.onValueChanged:AddListener(function (isOn)
        if isOn then
            self:_toggleShowDate("day")
        end
    end)
end
--
function FlightChooseDateCtrl:_toggleShowDate(str)
    if str == "year" then
        self.yearPage.localScale = Vector3.one
        self.monthPage.localScale = Vector3.zero
        self.dayPage.localScale = Vector3.zero
    elseif str == "month" then
        self.yearPage.localScale = Vector3.zero
        self.monthPage.localScale = Vector3.one
        self.dayPage.localScale = Vector3.zero
    elseif str == "day" then
        self.yearPage.localScale = Vector3.zero
        self.monthPage.localScale = Vector3.zero
        self.dayPage.localScale = Vector3.one
    end
end
--day item初始化
function FlightChooseDateCtrl:_dayItemsInit(trans)
    local count = trans.childCount
    self.dayList = {}
    for i = 1, count do
        local temp = trans:GetChild(i - 1)
        local item = FlightDateDayItem:new(temp, {index = i, callBack = function(value)
            if self.dayValue ~= nil then
                self.dayValue:setState(false)
            end
            self.dayValue = value
            self:updateDateShow(self.yearValue:getValue(), self.monthValue:getValue(), self.dayValue:getValue())
        end})
        self.dayList[i] = item
    end
end
--
function FlightChooseDateCtrl:_monthItemsInit(trans)
    local count = trans.childCount
    self.monthList = {}
    for i = 1, count do
        local temp = trans:GetChild(i - 1)
        local item = FlightDateMonthItem:new(temp, {value = i, callBack = function(value)
            if self.monthValue ~= nil then
                self.monthValue:setState(false)
            end
            self.monthValue = value
            self:updateDay()
        end})
        self.monthList[i] = item
    end
end
--
function FlightChooseDateCtrl:_yearItemsInit(trans)
    local count = trans.childCount
    self.yearList = {}
    for i = 1, count do
        local temp = trans:GetChild(i - 1)
        local item = FlightDateYearItem:new(temp, {callBack = function(value)
            if self.yearValue ~= nil then
                self.yearValue:setState(false)
            end
            self.yearValue = value
            self:updateDay()
        end})
        self.yearList[i] = item
    end
end
--
function FlightChooseDateCtrl:updateDay()
    local year = self.yearValue:getValue()
    local month = self.monthValue:getValue()
    local day = self.dayValue:getValue()
    self:updateDateShow(year, month, day)
    self:_showDay(year, month)
end
--更新顶部显示
function FlightChooseDateCtrl:updateDateShow(year, month, day)
    local monthStr
    if month == 1 then
        monthStr = GetLanguage(34010001)
    elseif month == 2 then
        monthStr = GetLanguage(34010002)
    elseif month == 3 then
        monthStr = GetLanguage(34010003)
    elseif month == 4 then
        monthStr = GetLanguage(34010004)
    elseif month == 5 then
        monthStr = GetLanguage(34010005)
    elseif month == 6 then
        monthStr = GetLanguage(34010006)
    elseif month == 7 then
        monthStr = GetLanguage(34010007)
    elseif month == 8 then
        monthStr = GetLanguage(34010008)
    elseif month == 9 then
        monthStr = GetLanguage(34010009)
    elseif month == 10 then
        monthStr = GetLanguage(34010010)
    elseif month == 11 then
        monthStr = GetLanguage(34010011)
    elseif month == 12 then
        monthStr = GetLanguage(34010012)
    end
    self.dateText.text = string.format("%s %d,%d", monthStr, day, year)
end
--
function FlightChooseDateCtrl:_weekInit(trans)
    local count = trans.childCount
    self.weekList = {}
    for i = 1, count do
        local temp = trans:GetChild(i - 1):GetComponent("Text")
        self.weekList[i] = temp
    end
end
--初始化年  --界面打开时初始化一次
function FlightChooseDateCtrl:_initYear(currentYear)
    local current = tonumber(currentYear)
    local before = current - 1
    local after = current + 1

    self.yearList[1]:setValue(before)
    self.yearList[2]:setValue(current)
    self.yearList[3]:setValue(after)

    self.yearList[1]:setState(false)
    self.yearList[2]:setState(true)
    self.yearList[3]:setState(false)
    self.yearValue = self.yearList[2]
end
--初始化年  --界面打开时初始化一次
function FlightChooseDateCtrl:_initMonth(currentMonth)
    for i, monthItem in ipairs(self.monthList) do
        if i == currentMonth then
            monthItem:setState(true)
            self.monthValue = monthItem
        else
            monthItem:setState(false)
        end
    end
end
--
function FlightChooseDateCtrl:_initData()
    if self.m_data ~= nil then
        local year = tonumber(os.date("%Y", self.m_data.selectDate))
        local month = tonumber(os.date("%m", self.m_data.selectDate))
        self.dayMonthText.text = month
        self:_initYear(year)
        self:_initMonth(month)
        self:_showDay(year, month)
        self:_toggleShowDate("day")
        self:updateDay()
    end
end
--
function FlightChooseDateCtrl:_showDay(year, month)
    local dayAmount = tonumber(os.date("%d", os.time({year = year, month = month + 1, day = 0})))
    local startWeek = tonumber(os.date("%w", os.time({year = year, month = month, day = 1})))

    for i, dayItem in ipairs(self.dayList) do
        if i < startWeek or i > startWeek + dayAmount then
            dayItem:hide()
        end
        if i >= startWeek and i < startWeek + dayAmount then
            dayItem:show()
            local dayId = i - startWeek + 1
            dayItem:setValue(dayId)
            local temp = os.time({year = year, month = month, day = dayId})
            if temp == self.m_data.selectDate then
                dayItem:setState(true)
                self.dayValue = dayItem
            else
                dayItem:setState(false)
            end
        end
    end
end
--
function FlightChooseDateCtrl:_language()
    self.yearToggleText01.text = GetLanguage(34010013)
    self.monthToggleText02.text = GetLanguage(34010014)
    self.dayToggleText03.text = GetLanguage(34010015)
    self:_weekLanguage()
end
--
function FlightChooseDateCtrl:_weekLanguage()
    self.weekList[1].text = GetLanguage(34020001)
    self.weekList[2].text = GetLanguage(34020002)
    self.weekList[3].text = GetLanguage(34020003)
    self.weekList[4].text = GetLanguage(34020004)
    self.weekList[5].text = GetLanguage(34020005)
    self.weekList[6].text = GetLanguage(34020006)
    self.weekList[7].text = GetLanguage(34020007)
end
--
function FlightChooseDateCtrl:backFunc()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--
function FlightChooseDateCtrl:confirmFunc()
    PlayMusEff(1002)
    if self.m_data.callback ~= nil then
        local time = os.time({year = self.yearValue:getValue(), month = self.monthValue:getValue(), day = self.dayValue:getValue()})
        self.m_data.callback(time)
        UIPanel.ClosePage()
    end
end