---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/4/10 17:31
---

-- 公司、Eva、可加点属性item
PropertyTrueItem = class("PropertyTrueItem")
PropertyTrueItem.static.NumberColor = "#5460AC" -- 数量特殊颜色
PropertyTrueItem.static.PercentColor = "#10C4FE" -- 加成特殊颜色
PropertyTrueItem.static.ExperienceColor = "#10C4FE" -- 经验特殊颜色
PropertyTrueItem.static.BTypeIcon = -- b类型显示配置
{
    ["Quality"] = "Assets/CityGame/Resources/Atlas/Company/icon-quality-w.png",
    ["ProduceSpeed"] = "Assets/CityGame/Resources/Atlas/Company/icon-produr-w.png",
    ["PromotionAbility"] = "Assets/CityGame/Resources/Atlas/Company/icon-ad-w.png",
    ["InventionUpgrade"] = "Assets/CityGame/Resources/Atlas/Company/icon-research-w.png",
    ["EvaUpgrade"] = "Assets/CityGame/Resources/Atlas/Company/icon-eva-w-s.png",
    ["WarehouseUpgrade"] = "Assets/CityGame/Resources/Atlas/Company/icon-warehouse-w.png",
}

-- 初始化
function PropertyTrueItem:initialize(prefab, data, configData)
    self.prefab = prefab
    self.data = data
    self.configData = configData

    local transform = prefab.transform
    self.typeImage = transform:Find("TypeImage"):GetComponent("Image")
    self.levelText = transform:Find("LevelText"):GetComponent("Text")
    self.nameNumberText = transform:Find("NameNumberText"):GetComponent("Text")
    self.experienceText = transform:Find("ExperienceTitleText/ExperienceText"):GetComponent("Text")
    self.levelSlider = transform:Find("LevelSlider"):GetComponent("Slider")
    self.totalLevelNumberText = transform:Find("LevelSlider/TotalLevelNumberText"):GetComponent("Text")
    self.addBtn = transform:Find("AddBtn"):GetComponent("Button")
    self.subtractBtn = transform:Find("SubtractBtn"):GetComponent("Button")
    self.addExNumInputField = transform:Find("AddExNumInputField"):GetComponent("InputField")

    self:_showBtnState(true)
    self:ShowData(self.data.lv, self.data.cexp)
    LoadSprite(PropertyTrueItem.static.BTypeIcon[data.bt], self.typeImage, true)

    self.addBtn.onClick:AddListener(function ()
        self:_showBtnState(false)
    end)

    self.subtractBtn.onClick:AddListener(function ()
        self:_showBtnState(true)
    end)

    self.addExNumInputField.onEndEdit:AddListener(function (inputValue)
        self:_preAddPoint(inputValue)
    end)
end

-- 显示真实数据（内有公式、要改）
function PropertyTrueItem:ShowData(lv, cexp)
    if lv >= 1 then
        local speed = "" -- 1=品质   2=品牌（无）   3=生产速度  4=推广能力    5=发明提升  6=EVA提升    7=仓库提升
        if self.data.bt == "Quality" then
            if self.data.at < 2100000 then -- 建筑品质加成
                speed = string.format( "%.2f", (1 + EvaUp[lv].add / 100000) * self.configData.basevalue)
            else -- 商品品质值
                speed = string.format( "%.2f",EvaUp[lv].add / 1000)
            end
        elseif self.data.bt == "ProduceSpeed" then
            speed = math.floor(1 / ((1 + EvaUp[lv].add / 100000) * self.configData.basevalue)) .. "s/个"
        elseif self.data.bt == "PromotionAbility" then
            speed = math.floor((1 + EvaUp[lv].add / 100000) * self.configData.basevalue) .. "s/个"
        elseif self.data.bt == "InventionUpgrade" then
            speed = math.floor(((1 + EvaUp[lv].add / 100000) * (self.configData.basevalue / 100000)) * 100) .. "%"
        elseif self.data.bt == "EvaUpgrade" then
            speed = math.floor(((1 + EvaUp[lv].add / 100000) * (self.configData.basevalue / 100000)) * 100) .. "%"
        elseif self.data.bt == "WarehouseUpgrade" then
            speed = math.floor((1 + EvaUp[lv].add / 100000) * self.configData.basevalue)
        end

        if lv == 1 then
            self.nameNumberText.text = string.format("%s:<color=%s><b>%s</b></color>",self.configData.name, PropertyTrueItem.static.NumberColor, speed)
        else
            --self.nameNumberText.text = string.format("%s:<color=%s><b>%s</b></color>  <color=%s><b>(+%s%)</b></color>",self.configData.name, PropertyTrueItem.static.NumberColor, tostring(speed), PropertyTrueItem.static.PercentColor, tostring(EvaUp[lv].add / 1000))
            self.nameNumberText.text = self.configData.name .. ":<color=" .. PropertyTrueItem.static.NumberColor .. "><b>" .. speed .. "</b></color>  <color=" .. PropertyTrueItem.static.PercentColor .. "><b>(+ " .. tostring(EvaUp[lv].add / 1000) .. "%)</b></color>"
            --self.nameNumberText.text = self.configData.name .. ":" .. speed .. EvaUp[lv].add / 1000 .. "%"
        end
    else
        self.nameNumberText.text = self.configData.name
    end
    self.levelText.text = string.format("Lv%s", lv)
    --self.experienceText.text = string.format("%s:<color=%s><b>%s</b></color>","Current experience value", PropertyTrueItem.static.ExperienceColor, cexp)
    self.experienceText.text = tostring(cexp)
    self.levelSlider.value = cexp / EvaUp[lv].upexp
    self.totalLevelNumberText.text = EvaUp[lv].upexp
end

-- 按钮切换
function PropertyTrueItem:_showBtnState(isShow)
    if isShow then
        self.subtractBtn.transform.localScale = Vector3.zero
        self.addExNumInputField.transform.localScale = Vector3.zero
        self.addExNumInputField.text = ""
        self.addBtn.transform.localScale = Vector3.zero
    else
        self.subtractBtn.transform.localScale = Vector3.one
        self.addExNumInputField.transform.localScale = Vector3.one
        self.addBtn.transform.localScale = Vector3.one
    end
end

-- 向服务器发送加点消息
function PropertyTrueItem:_addPoint()
    local inputValue = self.addExNumInputField.text
    if inputValue == nil or inputValue == "" or tonumber(inputValue) <= 0 or tonumber(inputValue) > DataManager.GetEvaPoint() then
        return
    end
    local numberInputValue = tonumber(inputValue)
    if numberInputValue <= 0 or numberInputValue > DataManager.GetEvaPoint() then
        return
    end
    --self.data.cexp = self.data.cexp + tonumber(inputValue)
    local evaData = {}
    evaData.id = self.data.id
    evaData.at = self.data.at
    evaData.b = self.data.b
    evaData.cexp = self.data.cexp + numberInputValue
    evaData.lv = self.data.lv
    evaData.pid = self.data.pid
    if self.data.bt == "Quality" then
        evaData.bt = 1
    elseif self.data.bt == "Brand" then
        evaData.bt = 2
    elseif self.data.bt == "ProduceSpeed" then
        evaData.bt = 3
    elseif self.data.bt == "PromotionAbility" then
        evaData.bt = 4
    elseif self.data.bt == "InventionUpgrade" then
        evaData.bt = 5
    elseif self.data.bt == "EvaUpgrade" then
        evaData.bt = 6
    elseif self.data.bt == "WarehouseUpgrade" then
        evaData.bt = 7
    end
    evaData.decEva = numberInputValue
    DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_UpdateMyEva', evaData)
end

-- 预看加点消息
function PropertyTrueItem:_preAddPoint(inputValue)
    if inputValue == nil or inputValue == "" or tonumber(inputValue) <= 0 or tonumber(inputValue) > DataManager.GetEvaPoint() then
        return
    end
    --local myName = self.name
    local function AddPointCalculate(myLv, myCexp)
        if myLv > #EvaUp then
            myLv = #EvaUp
            myCexp = EvaUp[#EvaUp].upexp
            self:ShowData(myLv, myCexp)
            return
        end
        if myCexp >= EvaUp[myLv].upexp then
            AddPointCalculate(myLv + 1, myCexp - EvaUp[myLv].upexp)
        else
            self:ShowData(myLv, myCexp)
        end
    end
    AddPointCalculate(self.data.lv, self.data.cexp + tonumber(inputValue))
end