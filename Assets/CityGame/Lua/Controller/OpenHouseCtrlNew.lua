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
    end , self)
    self.luaBehaviour:AddClick(self.competitivenessBtn, function ()
        self.competitivenessRoot.localScale = Vector3.zero
    end , self)
end

function OpenHouseCtrlNew:Refresh()
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "queryIndustryWages", "gs.QueryIndustryWages", self._getStandardWage, self)
    DataManager.ModelRegisterNetMsg(self.m_data.info.id, "gscode.OpCode", "apartmentGuidePrice", "gs.AartmentMsg", self._getApartmentGuidePrice, self)

    self:_language()
    self:_initData()
end
--
function OpenHouseCtrlNew:Hide()
    UIPanel.Hide(self)
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "queryIndustryWages", self)
    DataManager.ModelRemoveNetMsg(self.m_data.info.id, "gscode.OpCode", "apartmentGuidePrice", "gs.AartmentMsg")
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
    self.competitivenessRoot = transform:Find("root/competitivenessRoot")
    self.competitivenessBtn = transform:Find("root/competitivenessRoot/btn").gameObject

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
    self.competitivenessText11 = transform:Find("root/competitivenessRoot/Text01"):GetComponent("Text")
    self.competitivenessText12 = transform:Find("root/competitivenessRoot/Text02"):GetComponent("Text")

    self.rentInput.onValueChanged:AddListener(function (str)
        if str == "" then
            return
        end
        local temp = ct.CalculationHouseCompetitivePower(self.guideData.avgPrice, tonumber(str), self.guideData.score, self.guideData.avgScore)
        self.valueText.text = temp
    end)
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
    self.competitivenessText11.text = GetLanguage(43010002)
    self.competitivenessText12.text = GetLanguage(43010003)
end
--
function OpenHouseCtrlNew:_initData()
    self.rentInput.text = ""
    self.competitivenessRoot.localScale = Vector3.zero

    if self.m_data == nil then
        return
    end
    DataManager.m_ReqHouseGuidPrice(self.m_data.info.id)  --请求竞争力参数
    self.tipRoot.localScale = Vector3.zero
    local staffNum = PlayerBuildingBaseData[self.m_data.info.mId].maxWorkerNum
    self.staffNum = staffNum
    self.staffNumText.text = staffNum
    self.standardWage = DataManager.GetBuildingStandardWage(self.m_data.info.mId)

    if self.standardWage == nil then
        DataManager.m_ReqStandardWage(self.m_data.info.mId)
    else
        self.standardWageText.text = string.format("E%s", GetClientPriceString(self.standardWage))
        --local value = self.m_data.info.salary * staffNum * self.standardWage / 100
        local value = staffNum * self.standardWage  --temp修改
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
        DataManager.m_ReqHouseGuidPrice(self.m_data.info.id)  --请求竞争力参数
    end
end
--
function OpenHouseCtrlNew:_getApartmentGuidePrice(data)
    if data ~= nil and data.apartmentPrice ~= nil then
        local value = data.apartmentPrice[1]
        self.guideData = value
        local tempPrice = ct.CalculationHouseSuggestPrice(value.avgPrice)
        self.rentInput.text = GetClientPriceString(tempPrice)
        local temp = ct.CalculationHouseCompetitivePower(value.avgPrice, value.avgPrice, value.score, value.avgScore)
        self.valueText.text = temp
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