---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 9:53
---住宅开业
OpenHouseCtrlNew = class('OpenHouseCtrlNew',UIPanel)
UIPanel:ResgisterOpen(OpenHouseCtrlNew)

function OpenHouseCtrlNew:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.HideOther, UICollider.Normal)
end

function OpenHouseCtrlNew:bundleName()
    return "Assets/CityGame/Resources/View/OpenHousePanel.prefab"
end

function OpenHouseCtrlNew:OnCreate(obj )
    UIPanel.OnCreate(self, obj)
end

function OpenHouseCtrlNew:Awake(go)
    self.gameObject = go
    self:_getComponent(go)

    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn, self._onClickCloseBtn, self)
    self.luaBehaviour:AddClick(self.okBtn, self._onClickConfirm, self)
    self.luaBehaviour:AddClick(self.infoBtn, function ()
        self.competitivenessRoot.localScale = Vector3.one
        self.competitivenessText11.text = GetLanguage(43010002)
        self.competitivenessText12.text = GetLanguage(43010003)
    end , self)
    self.luaBehaviour:AddClick(self.competitivenessBtn, function ()
        self.competitivenessText11.text = ""
        self.competitivenessText12.text = ""
        self.competitivenessRoot.localScale = Vector3.zero
    end , self)
end

function OpenHouseCtrlNew:Refresh()
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "queryIndustryWages", "gs.QueryIndustryWages", self._getStandardWage, self)
    Event.AddListener("c_getHouseGuidePrice", self._getApartmentGuidePrice, self)

    self:_language()
    self:_initData()
end
--
function OpenHouseCtrlNew:Hide()
    UIPanel.Hide(self)
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "queryIndustryWages", self)
    Event.RemoveListener("c_getHouseGuidePrice", self._getApartmentGuidePrice, self)
end
--
function OpenHouseCtrlNew:_getComponent(go)
    local transform = go.transform
    self.closeBtn = transform:Find("root/closeBtn").gameObject
    self.okBtn = transform:Find("root/okBtn").gameObject
    self.standardWageText = transform:Find("root/salary/wage/standardWageText"):GetComponent("Text")
    self.staffNumText = transform:Find("root/salary/staffNum/staffNumText"):GetComponent("Text")
    self.totalText = transform:Find("root/salary/total/totalText"):GetComponent("Text")
    self.rentInput = transform:Find("root/rent/rentInput"):GetComponent("InputField")
    self.tipRoot = transform:Find("root/tipRoot")
    self.valueText = transform:Find("root/rent/priceBg/valueText"):GetComponent("Text")
    self.infoBtn = transform:Find("root/rent/priceBg/infoBtn").gameObject
    --
    self.competitivenessRoot = transform:Find("competitivenessRoot")
    self.competitivenessBtn = transform:Find("competitivenessRoot/btn").gameObject
    --
    self.roomCountText = transform:Find("root/roomCount/roomCountText"):GetComponent("Text")
    self.competitiSlider = transform:Find("root/competitiSlider"):GetComponent("Slider")
    self.comCenterText = transform:Find("root/competitiSlider/center/Image/Text/valueText"):GetComponent("Text")  --一半的竞争力

    self.titleText01 = transform:Find("root/titleText01"):GetComponent("Text")
    self.standardWageText02 = transform:Find("root/salary/wage/Text"):GetComponent("Text")
    self.standardWageText03 = transform:Find("root/salary/wage/Text02"):GetComponent("Text")
    self.staffNumText04 = transform:Find("root/salary/staffNum/Text"):GetComponent("Text")
    self.totalText05 = transform:Find("root/salary/total/Text"):GetComponent("Text")
    self.rentInputText06 = transform:Find("root/rent/rentInput/Placeholder"):GetComponent("Text")
    self.rentText07 = transform:Find("root/rent/priceBg/Text"):GetComponent("Text")
    self.rentText08 = transform:Find("root/rent/Text01"):GetComponent("Text")
    self.tipText09 = transform:Find("root/tipRoot/Text"):GetComponent("Text")
    self.competitivenessText10 = transform:Find("root/rent/priceBg/Text"):GetComponent("Text")
    self.competitivenessText11 = transform:Find("competitivenessRoot/tooltip/title"):GetComponent("Text")
    self.competitivenessText12 = transform:Find("competitivenessRoot/tooltip/content"):GetComponent("Text")
    self.comCenterText13 = transform:Find("root/competitiSlider/center/Image/Text"):GetComponent("Text")

    self:_awakeSliderInput()  --初始化
end
--
function OpenHouseCtrlNew:_awakeSliderInput()
    --
    EventTriggerMgr.Get(self.rentInput.gameObject).onSelect = function()
        OpenHouseCtrlNew.inputCanChange = true  --当input被选中时，则可以改变自己的值
    end
    self.rentInput.onValueChanged:AddListener(function (str)
        if str == "" or self.guideData == nil then
            return
        end
        local temp = ct.CalculationHouseCompetitivePower(self.guideData.guidePrice, tonumber(str) * 10000, self.guideData.npc)
        if temp >= functions.maxCompetitive then
            self.valueText.text = ">"..temp
        elseif temp <= functions.minCompetitive then
            self.valueText.text = "<"..temp
        else
            self.valueText.text = string.format("%0.1f", temp)
        end
        OpenHouseCtrlNew.sliderCanChange = self:_checkSliderChange(str)
        self.competitiSlider.value = temp
    end)
    --
    EventTriggerMgr.Get(self.competitiSlider.gameObject).onSelect = function()
        OpenHouseCtrlNew.sliderCanChange = true
    end
    self.competitiSlider.onValueChanged:AddListener(function (value)
        if self.guideData == nil then
            return
        end
        if value >= self.competitiSlider.maxValue or value <= self.competitiSlider.minValue then
            if OpenHouseCtrlNew.sliderCanChange ~= true then
                return
            end
        end
        local price = ct.CalculationHousePrice(self.guideData.guidePrice, value)
        self.rentInput.text = GetClientPriceString(price)
    end)
end
--判断是否需要改变slider的值
--当input输入的值超出范围，slider被归置为边界值1/99，这时则不能改变input的值
function OpenHouseCtrlNew:_checkSliderChange(inputValue)
    local min = ct.CalculationHousePrice(self.guideData.guidePrice, functions.maxCompetitive)
    local max = ct.CalculationHousePrice(self.guideData.guidePrice, functions.minCompetitive)
    local current = tonumber(inputValue) * 10000
    if current >= min and current <= max then
        return true
    else
        return false
    end
end
--
function OpenHouseCtrlNew:_language()
    self.titleText01.text = GetLanguage(24020001)
    self.standardWageText02.text = GetLanguage(24020002)
    self.standardWageText03.text = GetLanguage(24020003)
    self.staffNumText04.text = GetLanguage(24020004)..":"
    self.totalText05.text = GetLanguage(24020007)
    self.rentInputText06.text = GetLanguage(24020017)
    self.rentText07.text = GetLanguage(24020014)
    self.rentText08.text = GetLanguage(24020015)..":"
    self.tipText09.text = GetLanguage(24020016)
    self.competitivenessText10.text = GetLanguage(43010001)
    self.comCenterText13.text = GetLanguage(12345678)  --一半的竞争力
    --self.competitivenessText11.text = GetLanguage(43010002)
    --self.competitivenessText12.text = GetLanguage(43010003)
end
--
function OpenHouseCtrlNew:_initData()
    self.rentInput.text = ""
    self.competitivenessRoot.localScale = Vector3.zero
    self.competitiSlider.minValue = functions.minCompetitive
    self.competitiSlider.maxValue = functions.maxCompetitive

    if self.m_data == nil then
        return
    end
    DataManager.m_ReqHouseGuidPrice(self.m_data.info.id)  --请求竞争力参数

    self.tipRoot.localScale = Vector3.zero
    local buildingData = PlayerBuildingBaseData[self.m_data.info.mId]
    self.staffNum = buildingData.maxWorkerNum
    self.staffNumText.text = self.staffNum
    self.standardWage = DataManager.GetBuildingStandardWage(self.m_data.info.mId)
    self.roomCountText.text = string.format("%s <color=#FFFFFF>%d</color>", GetLanguage(12345678), buildingData.npc)

    if self.standardWage == nil then
        DataManager.m_ReqStandardWage(self.m_data.info.mId)
    else
        self.standardWageText.text = string.format("E%s", GetClientPriceString(self.standardWage))
        --local value = self.m_data.info.salary * self.staffNum * self.standardWage / 100
        local value = self.staffNum * self.standardWage  --temp修改
        self.totalText.text = "E"..GetClientPriceString(value)
        self.totalValue = value
    end
end
--
function OpenHouseCtrlNew:_getStandardWage(data)
    if data.industryWages ~= nil then
        self.standardWage = data.industryWages
        DataManager.SetBuildingStandardWage(data.type, data.industryWages)
        self.standardWageText.text = string.format("E%s", GetClientPriceString(data.industryWages))
        --local value = self.m_data.info.salary * self.staffNum * data.industryWages / 100
        local value = self.staffNum * data.industryWages  --temp修改
        self.totalText.text = "E"..GetClientPriceString(value)
        self.totalValue = value
    end
end
--
function OpenHouseCtrlNew:_getApartmentGuidePrice(data)
    if data ~= nil then
        self.guideData = data
        local tempPrice = ct.CalculationHouseSuggestPrice(data.guidePrice)
        local temp = ct.CalculationHouseCompetitivePower(data.guidePrice, data.guidePrice, data.npc)
        if temp >= functions.maxCompetitive then
            self.valueText.text = ">"..temp
        elseif temp <= functions.minCompetitive then
            self.valueText.text = "<"..temp
        else
            self.valueText.text = string.format("%0.1f", temp)
        end
        OpenHouseCtrlNew.sliderCanChange = false
        OpenHouseCtrlNew.inputCanChange = false
        self.competitiSlider.value = temp
        self.rentInput.text = GetClientPriceString(tempPrice)
    end
end
--
function OpenHouseCtrlNew:_onClickConfirm(ins)
    PlayMusEff(1002)
    if ins.rentInput.text == "" then
        ins.tipRoot.localScale = Vector3.one
        return
    end

    if DataManager.GetMoney() < ins.totalValue then
        Event.Brocast("SmallPop", GetLanguage(41010006), 300)
        return
    end

    if ins.m_data.callBackFunc ~= nil then
        local temp = os.date("%H:%M", os.time())
        local data = {salary = ins.totalText.text, time = temp, fun = function ()
            ins.m_data.callBackFunc(100, tonumber(ins.rentInput.text))
            UIPanel.ClosePage()
        end}
        ct.OpenCtrl("OpenBuildingCheckCtrl", data)
        ins.tipRoot.localScale = Vector3.zero
    end
end
--
function OpenHouseCtrlNew:_onClickCloseBtn(ins)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end