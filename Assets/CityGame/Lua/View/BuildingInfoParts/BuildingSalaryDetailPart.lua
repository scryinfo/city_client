---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---建筑主界面调整工资
BuildingSalaryDetailPart = class('BuildingSalaryDetailPart', BasePartDetail)

local black = "#333333"
local red = "#D65151"

--
function BuildingSalaryDetailPart:PrefabName()
    return "BuildingSalaryDetailPart"
end
--
function  BuildingSalaryDetailPart:_InitEvent()
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "queryIndustryWages", "gs.QueryIndustryWages", self._getStandardWage, self)
end
--
function BuildingSalaryDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.wageSlider.onValueChanged:AddListener(function (value)
        local tempValue = math.floor(value)
        self:_showPercentValue(tempValue)
    end)

    --mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject, function ()
    --    self:clickCloseBtn()
    --end , self)
    mainPanelLuaBehaviour:AddClick(self.confirmBtn.gameObject, function ()
        self:clickConfirmBtn()
    end , self)
end
--
function BuildingSalaryDetailPart:_ResetTransform()
    self.totalText.text = "E0.0000"
    self.staffNumText.text = 0
    self.standardWageText.text = "E0.0000"
    self.totalText.text = "E0.0000"
    self.effectiveDateText.text = ""
    self.effectText.text = "0%"
    self.effectExpWordText.text = ""

    self.wageSlider.value = 0
    self:_showPercentValue(0)

    self:_language()
end
--
function BuildingSalaryDetailPart:_RemoveEvent()
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "queryIndustryWages", self)
end
--
function BuildingSalaryDetailPart:_RemoveClick()
    self.wageSlider.onValueChanged:RemoveAllListeners()
    --self.closeBtn.onClick:RemoveAllListeners()
    self.confirmBtn.onClick:RemoveAllListeners()
end
--
function BuildingSalaryDetailPart:_ChildHide()
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
end
--
function BuildingSalaryDetailPart:RefreshData(data)
    self:_ResetTransform()
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
--
function BuildingSalaryDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    self.m_Timer = Timer.New(slot(self._itemTimer, self), 1, -1, true)
end
--
function BuildingSalaryDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    --self.closeBtn = transform:Find("root/closeBtn"):GetComponent("Button")
    self.confirmBtn = transform:Find("root/confirmBtn"):GetComponent("Button")

    self.staffNumText = transform:Find("root/staffNum/staffNumText"):GetComponent("Text")
    self.standardWageText = transform:Find("root/wage/standardWageText"):GetComponent("Text")
    self.wageSlider = transform:Find("root/wageSlider"):GetComponent("Slider")
    self.effectiveDateText = transform:Find("root/effectiveDateText"):GetComponent("Text")

    self.select50Text = transform:Find("root/wageLevel/00/selectText")
    self.select75Text = transform:Find("root/wageLevel/01/selectText")
    self.select100Text = transform:Find("root/wageLevel/02/selectText")
    self.simple50Text = transform:Find("root/wageLevel/00/Text")
    self.simple75Text = transform:Find("root/wageLevel/01/Text")
    self.simple100Text = transform:Find("root/wageLevel/02/Text")

    self.effectText = transform:Find("root/bg/bg01/effectText"):GetComponent("Text")
    self.effectExpWordText = transform:Find("root/bg/bg01/Text01"):GetComponent("Text")
    self.totalText = transform:Find("root/bg/bg02/totalText"):GetComponent("Text")
    --
    self.wagesText01 = transform:Find("root/Text01"):GetComponent("Text")
    self.totalText02 = transform:Find("root/bg/bg02/Text02"):GetComponent("Text")
    self.staffNumText03 = transform:Find("root/staffNum/Text"):GetComponent("Text")
    self.standardWageText04 = transform:Find("root/wage/Text"):GetComponent("Text")
    self.effectTimeText05 = transform:Find("root/effectiveDateText/Text"):GetComponent("Text")
end
--
function BuildingSalaryDetailPart:_language()
    self.wagesText01.text = "Giving wage:"
    self.totalText02.text = "Total:"
    self.staffNumText03.text = "Number of staff:"
    self.standardWageText04.text = "Standard wages:"
    self.effectTimeText05.text = "Wage settlement time:"
end

--
function BuildingSalaryDetailPart:_initFunc()
    if self.m_data.info.state ~= "OPERATE" then
        return
    end
    if self.m_data.info.salary ~= nil then
        local value = (self.m_data.info.salary - 50) / 25
        if value < 0 then
            value = 0
        end
        self.wageSlider.value = value
        self:_showPercentValue(value)  --工资比率
    else
        self.wageSlider.value = 2
        self:_showPercentValue(2)
    end

    --self.effectExpWordText.text = GetLanguage(BuildingSalaryEffectConfig[self.m_data.info.mId].languageId)
    self.effectExpWordText.text = "Value:"
    local staffNum = PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum
    self.staffNumText.text = staffNum
    local standardWage = DataManager.GetBuildingStandardWage(self.m_data.info.mId)
    if standardWage == nil then
        DataManager.m_ReqStandardWage(self.m_data.info.mId)
    else
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(standardWage))
        local value = self.m_data.info.salary * staffNum * standardWage / 100  --因为工资百分比是整数
        self.totalText.text = "E"..GetClientPriceString(value)
        self.standardWage = standardWage
    end

    self.m_Timer:Reset(slot(self._itemTimer, self), 1, -1, true)
    self.m_Timer:Start()
    self:_checkShowTime()

    self.effectiveDateText.text = os.date("%Y/%m/%d %H:%M:%S", self.effectTime)
    local trueTextW = self.effectiveDateText.preferredWidth
    self.effectiveDateText.rectTransform.sizeDelta = Vector2.New(trueTextW, self.effectiveDateText.rectTransform.sizeDelta.y)
end
--
function BuildingSalaryDetailPart:_itemTimer()
    self:_checkShowTime()
end
--
function BuildingSalaryDetailPart:_checkShowTime()
    local nowTs = TimeSynchronized.GetTheCurrentTime()
    --local salaryTime = self.m_data.info.setSalaryTs
    local salaryTime = 1554977340
    local dateTable = getFormatUnixTimeNumber(salaryTime)
    local nowDateTable = getFormatUnixTimeNumber(nowTs)
    if dateTable.hour < nowDateTable.hour then
        nowDateTable.day = nowDateTable.day + 1

    elseif dateTable.hour == nowDateTable.hour then
        if dateTable.min < nowDateTable.min then
            nowDateTable.day = nowDateTable.day + 1

        elseif dateTable.min == nowDateTable.min then
            if dateTable.sec < nowDateTable.sec then
                nowDateTable.day = nowDateTable.day + 1
            end
        end
    end
    nowDateTable.hour = dateTable.hour
    nowDateTable.min = dateTable.min
    nowDateTable.sec = dateTable.sec
    self.effectTime = os.time(nowDateTable)
    self.effectiveDateText.text = os.date("%Y/%m/%d %H:%M:%S", self.effectTime)
end

--根据选中的档位显示数据
function BuildingSalaryDetailPart:_showPercentValue(level)
    if self.m_data == nil then
        return
    end
    if level == 0 then
        self.simple50Text.localScale = Vector3.zero
        self.simple75Text.localScale = Vector3.one
        self.simple100Text.localScale = Vector3.one

        self.select50Text.localScale = Vector3.one
        self.select75Text.localScale = Vector3.zero
        self.select100Text.localScale = Vector3.zero
        self.effectText.text = string.format("<color=%s>%s</color>", red, BuildingSalaryEffectConfig[self.m_data.info.mId].effect50)
        self:_changeTotalWage(0)
    elseif level == 1 then
        self.simple50Text.localScale = Vector3.one
        self.simple75Text.localScale = Vector3.zero
        self.simple100Text.localScale = Vector3.one

        self.select50Text.localScale = Vector3.zero
        self.select75Text.localScale = Vector3.one
        self.select100Text.localScale = Vector3.zero
        self.effectText.text = string.format("<color=%s>%s</color>", red, BuildingSalaryEffectConfig[self.m_data.info.mId].effect75)
        self:_changeTotalWage(1)
    elseif level == 2 then
        self.simple50Text.localScale = Vector3.one
        self.simple75Text.localScale = Vector3.one
        self.simple100Text.localScale = Vector3.zero

        self.select50Text.localScale = Vector3.zero
        self.select75Text.localScale = Vector3.zero
        self.select100Text.localScale = Vector3.one
        self.effectText.text = string.format("<color=%s>%s</color>", black, BuildingSalaryEffectConfig[self.m_data.info.mId].effect100)
        self:_changeTotalWage(2)
    end
end
--
function BuildingSalaryDetailPart:_getStandardWage(data)
    if data.industryWages ~= nil then
        DataManager.SetBuildingStandardWage(data.type, data.industryWages)
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(data.industryWages))
        self.standardWage = data.industryWages
        self:_changeTotalWage(self.wageSlider.value)
    end
end
--
function BuildingSalaryDetailPart:_changeTotalWage(level)
    if self.standardWage == nil then
        self.totalText.text = "E0.0000"
        return
    end

    local value
    if level == 0 then
        value = 50 * PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum * self.standardWage / 100
    elseif level == 1 then
        value = 75 * PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum * self.standardWage / 100
    elseif level == 2 then
        value = 100 * PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum * self.standardWage / 100
    end
    self.totalText.text = "E"..GetClientPriceString(value)
end
--
function BuildingSalaryDetailPart:clickConfirmBtn()
    local value = self.wageSlider.value * 25 + 50
    if value == self.m_data.info.salary then
        Event.Brocast("SmallPop", "设置没有更改", 300)
        return
    end
    self:_ReqSetSalary(self.m_data.info.id, TimeSynchronized.GetTheCurrentServerTime(), value)
end
--
function BuildingSalaryDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--
function BuildingSalaryDetailPart:_ReqSetSalary(insId, ts, salary)
    local msgId = pbl.enum("gscode.OpCode","setSalary")
    local pMsg = assert(pbl.encode("gs.SetSalary", {buildingId = insId, ts = ts, Salary = salary}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end