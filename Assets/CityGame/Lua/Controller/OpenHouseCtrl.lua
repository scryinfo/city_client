---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 9:53
---住宅开业
OpenHouseCtrl = class('OpenHouseCtrl',UIPanel)
UIPanel:ResgisterOpen(OpenHouseCtrl)

local black = "#333333"
local red = "#D65151"

function OpenHouseCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function OpenHouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/OpenHousePanelOld.prefab"
end

function OpenHouseCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function OpenHouseCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn, self._onClickCloseBtn, self)
    self.luaBehaviour:AddClick(self.okBtn, self._onClickConfirm, self)
    self.luaBehaviour:AddClick(self.suggestRentBtn, self._onClickSuggestBtn, self)
    self.wageSlider.onValueChanged:AddListener(function (value)
        local tempValue = math.floor(value)
        self:_showPercentValue(tempValue)
    end)
end

function OpenHouseCtrl:Refresh()
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "queryIndustryWages", "gs.QueryIndustryWages", self._getStandardWage, self)

    self:_initData()
end
--
function OpenHouseCtrl:Hide()
    UIPanel.Hide(self)
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "queryIndustryWages", self)
end
--
function OpenHouseCtrl:_getComponent(go)
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject
    self.okBtn = go.transform:Find("root/okBtn").gameObject
    self.suggestRentBtn = go.transform:Find("root/rent/priceBg/infoBtn").gameObject

    self.rentInput = go.transform:Find("root/rent/rentInput"):GetComponent("InputField")
    self.rentPriceText = go.transform:Find("root/rent/priceBg/priceText"):GetComponent("Text")
    self.roomText = go.transform:Find("root/rent/Text02/roomText"):GetComponent("Text")

    self.staffNumText = go.transform:Find("root/salary/staffNum/staffNumText"):GetComponent("Text")
    self.standardWageText = go.transform:Find("root/salary/wage/standardWageText"):GetComponent("Text")
    self.wageSlider = go.transform:Find("root/salary/wageSlider"):GetComponent("Slider")
    self.effectiveDateText = go.transform:Find("root/salary/effectTimeText"):GetComponent("Text")

    self.select50Text = go.transform:Find("root/salary/level/00/selectText")
    self.select75Text = go.transform:Find("root/salary/level/01/selectText")
    self.select100Text = go.transform:Find("root/salary/level/02/selectText")
    self.simple50Text = go.transform:Find("root/salary/level/00/Text")
    self.simple75Text = go.transform:Find("root/salary/level/01/Text")
    self.simple100Text = go.transform:Find("root/salary/level/02/Text")

    self.effectText = go.transform:Find("root/salary/bg/bg01/effectText"):GetComponent("Text")  --效果具体数值
    self.effectExpWordText = go.transform:Find("root/salary/bg/bg01/Text01"):GetComponent("Text")  --效果描述
    self.totalText = go.transform:Find("root/salary/bg/bg02/totalText"):GetComponent("Text")
end
--
function OpenHouseCtrl:_initData()
    self.rentInput.text = ""

    if self.m_data == nil then
        return
    end

    if self.m_data.info.salary ~= nil or self.m_data.info.salary == 0 then
        self.wageSlider.value = 2
        self:_showPercentValue(2)
    else
        local value = (self.m_data.info.salary - 50) / 25
        if value < 0 then
            value = 0
        end
        self.wageSlider.value = value
        self:_showPercentValue(value)  --工资比率
    end

    --self.effectExpWordText.text = GetLanguage(BuildingSalaryEffectConfig[self.m_data.info.mId].languageId)
    self.effectExpWordText.text = "Value:"  --temp
    local staffNum = PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum
    self.staffNumText.text = staffNum
    local standardWage = DataManager.GetBuildingStandardWage(self.m_data.info.mId)
    if standardWage == nil then
        DataManager.m_ReqStandardWage(self.m_data.info.mId)
    else
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(standardWage))
        local value = self.m_data.info.salary * staffNum * standardWage / 100
        self.totalText.text = "E"..GetClientPriceString(value)
        self.standardWage = standardWage
    end

    local trueTextW = self.effectiveDateText.preferredWidth
    self.effectiveDateText.rectTransform.sizeDelta = Vector2.New(trueTextW, self.effectiveDateText.rectTransform.sizeDelta.y)
    self.effectTime = TimeSynchronized.GetTheCurrentTime()
    self.effectiveDateText.text = os.date("%Y/%m/%d %H:%M:%S", self.effectTime)
end
--根据选中的档位显示数据
function OpenHouseCtrl:_showPercentValue(level)
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
function OpenHouseCtrl:_changeTotalWage(level)
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
function OpenHouseCtrl:_getStandardWage(data)
    if data.industryWages ~= nil then
        DataManager.SetBuildingStandardWage(data.type, data.industryWages)
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(data.industryWages))
        self.standardWage = data.industryWages
        self:_changeTotalWage(self.wageSlider.value)
    end
end
--
function OpenHouseCtrl:_onClickConfirm(ins)
    if ins.rentInput.text == "" then
        return
    end

    if ins.m_data.callBackFunc ~= nil then
        local sliderValue = ins.wageSlider.value * 25 + 50
        ins.m_data.callBackFunc(sliderValue, tonumber(ins.rentInput.text))
    end
    UIPanel.ClosePage()
end
--建议工资按钮[暂无]
function OpenHouseCtrl:_onClickSuggestBtn(ins)

end
--
function OpenHouseCtrl:_onClickCloseBtn(ins)
    UIPanel.ClosePage()
end