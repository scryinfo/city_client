---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 9:53
---建筑开业设置工资
BuildingSetSalaryCtrl = class('BuildingSetSalaryCtrl',UIPanel)
UIPanel:ResgisterOpen(BuildingSetSalaryCtrl)

local black = "#333333"
local red = "#D65151"

function BuildingSetSalaryCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function BuildingSetSalaryCtrl:bundleName()
    return "Assets/CityGame/Resources/View/BuildingSetSalaryPanel.prefab"
end

function BuildingSetSalaryCtrl:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function BuildingSetSalaryCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn, self._onClickCloseBtn, self)
    self.luaBehaviour:AddClick(self.okBtn, self._onClickConfirm, self)
    self.wageSlider.onValueChanged:AddListener(function (value)
        local tempValue = math.floor(value)
        self:_showPercentValue(tempValue)
    end)
end

function BuildingSetSalaryCtrl:Refresh()
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "queryIndustryWages", "gs.QueryIndustryWages", self._getStandardWage, self)

    self:_initData()
end
--
function BuildingSetSalaryCtrl:Hide()
    UIPanel.Hide(self)
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "queryIndustryWages", self)
end
--
function BuildingSetSalaryCtrl:_getComponent(go)
    local transform = go.transform
    self.closeBtn = transform:Find("root/closeBtn").gameObject
    self.okBtn = transform:Find("root/okBtn").gameObject
    self.staffNumText = go.transform:Find("root/staffNum/staffNumText"):GetComponent("Text")
    self.standardWageText = go.transform:Find("root/wage/standardWageText"):GetComponent("Text")
    self.wageSlider = go.transform:Find("root/wageSlider"):GetComponent("Slider")
    self.effectiveDateText = go.transform:Find("root/effectiveDateText"):GetComponent("Text")

    self.select50Text = go.transform:Find("root/wageLevel/00/selectText")
    self.select75Text = go.transform:Find("root/wageLevel/01/selectText")
    self.select100Text = go.transform:Find("root/wageLevel/02/selectText")
    self.simple50Text = go.transform:Find("root/wageLevel/00/Text")
    self.simple75Text = go.transform:Find("root/wageLevel/01/Text")
    self.simple100Text = go.transform:Find("root/wageLevel/02/Text")

    self.effectText = go.transform:Find("root/bg/bg01/effectText"):GetComponent("Text")
    self.effectExpWordText = transform:Find("root/bg/bg01/Text01"):GetComponent("Text")
    self.totalText = go.transform:Find("root/bg/bg02/totalText"):GetComponent("Text")
end
--
function BuildingSetSalaryCtrl:_initData()
    if self.m_data == nil then
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

    self.effectExpWordText.text = GetLanguage(BuildingSalaryEffectConfig[self.m_data.info.mId].languageId)
    local staffNum = PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum
    self.staffNum = staffNum
    self.staffNumText.text = staffNum
    local standardWage = DataManager.GetBuildingStandardWage()
    if standardWage == nil then
        DataManager.m_ReqStandardWage(self.m_data.info.mId)
    else
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(standardWage))
        local value = self.m_data.info.salary * staffNum * standardWage
        self.totalText.text = "E"..GetClientPriceString(value)
    end

    local trueTextW = self.effectiveDateText.preferredWidth
    self.effectiveDateText.rectTransform.sizeDelta = Vector2.New(trueTextW, self.effectiveDateText.rectTransform.sizeDelta.y)
    self.effectTime = TimeSynchronized.GetTheCurrentTime()
    self.effectiveDateText.text = os.date("%Y/%m/%d %H:%M:%S", self.effectTime)
end
--根据选中的档位显示数据
function BuildingSetSalaryCtrl:_showPercentValue(level)
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
    elseif level == 1 then
        self.simple50Text.localScale = Vector3.one
        self.simple75Text.localScale = Vector3.zero
        self.simple100Text.localScale = Vector3.one

        self.select50Text.localScale = Vector3.zero
        self.select75Text.localScale = Vector3.one
        self.select100Text.localScale = Vector3.zero
        self.effectText.text = string.format("<color=%s>%s</color>", red, BuildingSalaryEffectConfig[self.m_data.info.mId].effect75)
    elseif level == 2 then
        self.simple50Text.localScale = Vector3.one
        self.simple75Text.localScale = Vector3.one
        self.simple100Text.localScale = Vector3.zero

        self.select50Text.localScale = Vector3.zero
        self.select75Text.localScale = Vector3.zero
        self.select100Text.localScale = Vector3.one
        self.effectText.text = string.format("<color=%s>%s</color>", black, BuildingSalaryEffectConfig[self.m_data.info.mId].effect100)
    end
end
--
function BuildingSetSalaryCtrl:_getStandardWage(data)
    if data.industryWages ~= nil then
        DataManager.SetBuildingStandardWage(data.type, data.industryWages)
        self.standardWageText.text = string.format("E%s/d", GetClientPriceString(data.industryWages))
    end
end
--
function BuildingSetSalaryCtrl:_onClickConfirm(ins)
    if ins.m_data.callBackFunc ~= nil then
        local sliderValue = ins.wageSlider.value * 25 + 50
        ins.m_data.callBackFunc(sliderValue)
    end
    UIPanel.ClosePage()
end
--
function BuildingSetSalaryCtrl:_onClickCloseBtn(ins)
    UIPanel.ClosePage()
end