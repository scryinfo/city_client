---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 9:53
---住宅开业
OpenHouseCtrl = class('OpenHouseCtrl',UIPanel)
UIPanel:ResgisterOpen(OpenHouseCtrl)

function OpenHouseCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function OpenHouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/OpenHousePanel.prefab"
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
    self.rentPriceText = go.transform:Find("root/rent/priceText"):GetComponent("Text")
    self.roomText = go.transform:Find("root/rent/Text02/roomText"):GetComponent("Text")

    self.staffNumText = go.transform:Find("root/salary/staffNum/staffNumText"):GetComponent("Text")
    self.standardWageText = go.transform:Find("root/salary/wage/standardWageText"):GetComponent("Text")
    self.wageSlider = go.transform:Find("root/salary/wageSlider"):GetComponent("Slider")
    self.effectiveDateText = go.transform:Find("root/salary/effectiveDateText"):GetComponent("Text")

    self.select50Text = go.transform:Find("root/salary/wageLevel/00/selectText")
    self.select75Text = go.transform:Find("root/salary/wageLevel/01/selectText")
    self.select100Text = go.transform:Find("root/salary/wageLevel/02/selectText")
    self.simple50Text = go.transform:Find("root/salary/wageLevel/00/Text")
    self.simple75Text = go.transform:Find("root/salary/wageLevel/01/Text")
    self.simple100Text = go.transform:Find("root/salary/wageLevel/02/Text")

    self.effectText = go.transform:Find("root/salary/bg/bg01/effectText"):GetComponent("Text")
    self.totalText = go.transform:Find("root/salary/bg/bg02/totalText"):GetComponent("Text")
end
--
function OpenHouseCtrl:_initData()
    if self.m_data == nil then
        return
    end

    if self.m_data.salary ~= nil then
        self:_showPercentValue((self.m_data.salary - 50) / 15)  --工资比率
    else
        self:_showPercentValue(2)
    end

    local standardWage = DataManager.GetBuildingStandardWage()
    if standardWage == nil then
        DataManager.m_ReqStandardWage(self.m_data.buildingType)
    else
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(standardWage))
    end

    self.staffNumText.text = PlayerBuildingBaseData[self.m_data.buildingType].maxWorkerNum
    self.roomText.text = PlayerBuildingBaseData[self.m_data.buildingType].npc
    local trueTextW = self.effectiveDateText.preferredWidth
    self.effectiveDateText.rectTransform.sizeDelta = Vector2.New(trueTextW, self.effectiveDateText.rectTransform.sizeDelta.y)

    self.effectTime = TimeSynchronized.GetTheCurrentTime()
    self.effectiveDateText.text = os.date("%Y/%m%d %H:%M:%S", self.effectTime)
end
--根据选中的档位显示数据
function OpenHouseCtrl:_showPercentValue(level)
    if level == 0 then
        self.simple50Text.localScale = Vector3.zero
        self.simple75Text.localScale = Vector3.one
        self.simple100Text.localScale = Vector3.one

        self.select50Text.localScale = Vector3.one
        self.select75Text.localScale = Vector3.zero
        self.select100Text.localScale = Vector3.zero
    elseif level == 1 then
        self.simple50Text.localScale = Vector3.one
        self.simple75Text.localScale = Vector3.zero
        self.simple100Text.localScale = Vector3.one

        self.select50Text.localScale = Vector3.zero
        self.select75Text.localScale = Vector3.one
        self.select100Text.localScale = Vector3.zero
    elseif level == 2 then
        self.simple50Text.localScale = Vector3.one
        self.simple75Text.localScale = Vector3.one
        self.simple100Text.localScale = Vector3.zero

        self.select50Text.localScale = Vector3.zero
        self.select75Text.localScale = Vector3.zero
        self.select100Text.localScale = Vector3.one
    end
end
--
function OpenHouseCtrl:_getStandardWage(data)
    if data.industryWages ~= nil then
        DataManager.SetBuildingStandardWage(data.type, data.industryWages)
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(data.industryWages))
    end
end
--
function OpenHouseCtrl:_onClickConfirm(ins)
    if ins.rentInput.text == "" then
        return
    end

    if ins.m_data.callBackFunc ~= nil then
        local sliderValue = ins.wageSlider.value * 15 + 50
        ins.m_data.callBackFunc(sliderValue, tonumber(ins.rentInput.text))
    end
    UIPanel.ClosePage()
end
--
function OpenHouseCtrl:_onClickSuggestBtn(ins)

end
--
function OpenHouseCtrl:_onClickCloseBtn(ins)
    UIPanel.ClosePage()
end