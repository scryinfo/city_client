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
    ["Quality"] = "Assets/CityGame/Resources/Atlas/Eva/icon-quality.png",
    ["ProduceSpeed"] = "Assets/CityGame/Resources/Atlas/Eva/icon-Productionspeed.png",
    ["PromotionAbility"] = "Assets/CityGame/Resources/Atlas/Eva/icon-ad-w.png",
    ["InventionUpgrade"] = "Assets/CityGame/Resources/Atlas/Eva/icon-research.png",
    ["EvaUpgrade"] = "Assets/CityGame/Resources/Atlas/Eva/icon-eva-w-s.png",
    --["WarehouseUpgrade"] = "Assets/CityGame/Resources/Atlas/Company/icon-warehouse-w.png",
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
    transform:Find("ExperienceTitleText"):GetComponent("Text").text = GetLanguage(31010012)
    self.experienceText = transform:Find("ExperienceTitleText/ExperienceText"):GetComponent("Text")
    self.levelSlider = transform:Find("LevelSlider"):GetComponent("Slider")
    self.totalLevelNumberText = transform:Find("LevelSlider/TotalLevelNumberText"):GetComponent("Text")
    self.addBtn = transform:Find("AddBtn"):GetComponent("Button")
    self.subtractBtn = transform:Find("SubtractBtn"):GetComponent("Button")
    self.addExNumInputField = transform:Find("AddExNumInputField"):GetComponent("InputField")

    self:_showBtnState(false)
    self:_setBtnInteractable()

    self.strId = string.format("%d%s", self.configData.Atype, self.configData.Btype)
    if EvaCtrl.static.evaCtrl.addEvaLvData and EvaCtrl.static.evaCtrl.addEvaLvData[self.strId] then
        self:ShowData(EvaCtrl.static.evaCtrl.addEvaLvData[self.strId].myLv, EvaCtrl.static.evaCtrl.addEvaLvData[self.strId].myCexp)
        local recordData = EvaCtrl.static.evaCtrl:GetEvaRecordData()
        if #recordData == 1 then
            if EvaCtrl.static.evaCtrl.addData and EvaCtrl.static.evaCtrl.addData[recordData[1]] then
                self:_setAddExNumInputField(tostring(EvaCtrl.static.evaCtrl.addData[recordData[1]].value))
            end
        elseif #recordData == 2 then
            if EvaCtrl.static.evaCtrl.addData and EvaCtrl.static.evaCtrl.addData[recordData[1]] and EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]] then
                self:_setAddExNumInputField(tostring(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].value))
            end
        elseif #recordData == 3 then
            if EvaCtrl.static.evaCtrl.addData and EvaCtrl.static.evaCtrl.addData[recordData[1]] and EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]] and EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]].optionValue[self.data.bt]then
                self:_setAddExNumInputField(tostring(EvaCtrl.static.evaCtrl.addData[recordData[1]].value))
            end
        end
    else
        self:ShowData(self.data.lv, self.data.cexp)
        self:_setAddExNumInputField("")
    end
    LoadSprite(PropertyTrueItem.static.BTypeIcon[data.bt], self.typeImage, true)

    self.addBtn.onClick:RemoveAllListeners()
    self.addBtn.onClick:AddListener(function ()
        --self:_showBtnState(false)
        self:_onChangeInputNum(1)
    end)

    self.subtractBtn.onClick:RemoveAllListeners()
    self.subtractBtn.onClick:AddListener(function ()
        --self:_showBtnState(true)
        self:_onChangeInputNum(-1)
    end)

    self.addExNumInputField.onEndEdit:RemoveAllListeners()
    self.addExNumInputField.onEndEdit:AddListener(function (inputValue)
        if inputValue == nil or inputValue == "" then
            return
        end
        local addNumber = tonumber(inputValue)
        if addNumber < 0 or tonumber(inputValue) > DataManager.GetEvaPoint() then
            self:_setAddExNumInputField("")
            return
        end
        self:_preAddPoint(addNumber)
    end)
end

-- 显示真实数据（内有公式、要改）
function PropertyTrueItem:ShowData(lv, cexp)
    --if lv >= 1 then
        --local speed = "" -- 1=品质   2=品牌（无）   3=生产速度  4=推广能力    5=发明提升  6=EVA提升    7=仓库提升
        --if self.data.bt == "Quality" then
        --    if self.data.at < 2100000 then -- 建筑品质加成
        --        speed = string.format( "%.2f", (1 + EvaUp[lv].add / 100000) * self.configData.basevalue)
        --    else -- 商品品质值
        --        speed = string.format( "%.2f",EvaUp[lv].add / 1000)
        --    end
        --elseif self.data.bt == "ProduceSpeed" then
        --    speed = math.floor(1 / ((1 + EvaUp[lv].add / 100000) * self.configData.basevalue)) .. "s/个"
        --elseif self.data.bt == "PromotionAbility" then
        --    speed = math.floor((1 + EvaUp[lv].add / 100000) * self.configData.basevalue) .. "s/个"
        --elseif self.data.bt == "InventionUpgrade" then
        --    speed = math.floor(((1 + EvaUp[lv].add / 100000) * (self.configData.basevalue / 100000)) * 100) .. "%"
        --elseif self.data.bt == "EvaUpgrade" then
        --    speed = math.floor(((1 + EvaUp[lv].add / 100000) * (self.configData.basevalue / 100000)) * 100) .. "%"
        --elseif self.data.bt == "WarehouseUpgrade" then
        --    speed = math.floor((1 + EvaUp[lv].add / 100000) * self.configData.basevalue)
        --end

        --if lv == 1 then
        --    self.nameNumberText.text = string.format("%s:<color=%s><b>%s</b></color>",self.configData.name, PropertyTrueItem.static.NumberColor, speed)
        --else
            --self.nameNumberText.text = string.format("%s:<color=%s><b>%s</b></color>  <color=%s><b>(+%s%)</b></color>",self.configData.name, PropertyTrueItem.static.NumberColor, tostring(speed), PropertyTrueItem.static.PercentColor, tostring(EvaUp[lv].add / 1000))
            --self.nameNumberText.text = self.configData.name .. ":<color=" .. PropertyTrueItem.static.NumberColor .. "><b>" .. speed .. "</b></color>  <color=" .. PropertyTrueItem.static.PercentColor .. "><b>(+ " .. tostring(EvaUp[lv].add / 1000) .. "%)</b></color>"
            --self.nameNumberText.text = self.configData.name .. ":" .. speed .. EvaUp[lv].add / 1000 .. "%"
    --    end
    --else
        self.nameNumberText.text = GetLanguage(self.configData.name)
    --end
    self.levelText.text = string.format("Lv%s", lv)
    --self.experienceText.text = string.format("%s:<color=%s><b>%s</b></color>","Current experience value", PropertyTrueItem.static.ExperienceColor, cexp)
    self.experienceText.text = tostring(cexp)
    self.levelSlider.value = cexp / EvaUp[lv].upexp
    self.totalLevelNumberText.text = EvaUp[lv].upexp
end

-- 设置按钮状态
function PropertyTrueItem:_setBtnInteractable()
    local isCan
    local evaPoint = DataManager.GetEvaPoint()
    if evaPoint and evaPoint > 0 then
        isCan = true
    else
        isCan = false
    end
    self.subtractBtn.interactable = isCan
    self.addBtn.interactable = isCan
end

-- 按钮切换
function PropertyTrueItem:_showBtnState(isShow)
    if isShow then
        self.subtractBtn.transform.localScale = Vector3.zero
        self.addExNumInputField.transform.localScale = Vector3.zero
        self:_setAddExNumInputField("")
        self.addBtn.transform.localScale = Vector3.zero
    else
        self.subtractBtn.transform.localScale = Vector3.one
        self.addExNumInputField.transform.localScale = Vector3.one
        self.addBtn.transform.localScale = Vector3.one
    end
end

-- 设置输入框的值
function PropertyTrueItem:_setAddExNumInputField(str)
    self.addExNumInputField.text = str
end

-- 加/减一点
function PropertyTrueItem:_onChangeInputNum(num)
    local inputValue = self.addExNumInputField.text
    if inputValue == nil or inputValue == "" then
        return
    end
    local addNumber = tonumber(inputValue)

    -- 为零时，不能再减
    if addNumber == 0 and num == -1 then
        return
    end

    -- 为最大数时，不能再加
    if addNumber == DataManager.GetEvaPoint() and num == 1 then
        return
    end

    --if addNumber < 0 or tonumber(inputValue) > DataManager.GetEvaPoint() then
    --    self:_setAddExNumInputField("")
    --    return
    --end
    self:_setAddExNumInputField(tostring(addNumber + num))
    self:_preAddPoint(addNumber + num)
end

-- 预看加点消息
function PropertyTrueItem:_preAddPoint(addNumber)

    --if addNumber == 0 then
    --
    --end
    local function AddPointCalculate(myLv, myCexp)
        if myLv > #EvaUp then
            myLv = #EvaUp
            myCexp = EvaUp[#EvaUp].upexp
            self:ShowResultData(myLv, addNumber, myCexp)
            return
        end
        if myCexp >= EvaUp[myLv].upexp then
            AddPointCalculate(myLv + 1, myCexp - EvaUp[myLv].upexp)
        else
            self:ShowResultData(myLv, addNumber, myCexp)
        end
    end
    AddPointCalculate(self.data.lv, self.data.cexp + addNumber)
end

-- 显示结果数据数据
function PropertyTrueItem:ShowResultData(myLv, addNumber, myCexp)
    -- 刷新界面
    self:ShowData(myLv, myCexp)
    --local strId = string.format("%d%s", self.configData.Atype, self.configData.Btype)
    EvaCtrl.static.evaCtrl.addEvaLvData[self.strId] = {myLv = myLv, myCexp = myCexp}

    -- 获取到现在的层级
    local recordData = EvaCtrl.static.evaCtrl:GetEvaRecordData()
    if recordData[1] == 2 then
        if self.configData.Btype == "ProduceSpeed" then
            EvaPanel.ResultRootO:_showData(myLv)
        elseif self.configData.Btype == "Quality" then
            EvaPanel.ResultRootTwo:_showData(myLv)
        end
    else
        EvaPanel.ResultRootO:_showData(myLv)
    end
    if #recordData == 1 then
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]] then
            EvaCtrl.static.evaCtrl.addData[recordData[1]] = {}
        end
        EvaCtrl.static.evaCtrl.addData[recordData[1]].value = addNumber
        EvaCtrl.static.evaCtrl.evaTitleItem[recordData[1]]:_setAddNumber(addNumber)
    elseif #recordData == 2 then
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]] then
            EvaCtrl.static.evaCtrl.addData[recordData[1]] = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]] then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]] = {}
        end
        EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].value = addNumber
        for _, k in ipairs(EvaCtrl.optionTwoScript) do
            if k.index == recordData[2] then
                k:_setAddNumber(addNumber)
                break
            end
        end
        local totalNum = 0
        for _, v in pairs(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue) do
            totalNum = totalNum + v.value
        end
        EvaCtrl.static.evaCtrl.addData[recordData[1]].value = totalNum
        EvaCtrl.static.evaCtrl.evaTitleItem[recordData[1]]:_setAddNumber(totalNum)
    elseif #recordData == 3 then
        --{
        --    [1] =
        --    {
        --   value = 1,
        --   optionValue =
        --   {
        --       {
        --           optionValue = {},
        --       }
        --   } }
        --}
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]] then
            EvaCtrl.static.evaCtrl.addData[recordData[1]] = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]] then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]] = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]] then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]] = {}
        end
        if not EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]].optionValue then
            EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]].optionValue = {}
        end
        EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]].optionValue[self.data.bt] = addNumber
        local totalNum3 = 0
        for _, v in pairs(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]].optionValue) do
            totalNum3 = totalNum3 + v
        end
        for _, k in ipairs(EvaCtrl.optionThereScript) do
            if k.index == recordData[3] then
                k:_setAddNumber(totalNum3)
                break
            end
        end
        EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue[recordData[3]].value = totalNum3
        local totalNum2 = 0
        for _, x in pairs(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].optionValue) do
            totalNum2 = totalNum2 + x.value
        end
        EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[recordData[2]].value = totalNum2
        for _, j in ipairs(EvaCtrl.optionTwoScript) do
            if j.index == recordData[2] then
                j:_setAddNumber(totalNum2)
                break
            end
        end
        local totalNum1 = 0
        for _, y in pairs(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue) do
            totalNum1 = totalNum1 + y.value
        end
        EvaCtrl.static.evaCtrl.evaTitleItem[recordData[1]]:_setAddNumber(totalNum1)
    end
    --{
    -- 保存需要发送的eva数据
    if addNumber == 0 then
        EvaCtrl.static.evaCtrl.addEvaData[self.strId] = nil
    else
        local evaData = {}
        evaData.id = self.data.id
        evaData.at = self.data.at
        evaData.b = self.data.b
        evaData.cexp = self.data.cexp + addNumber
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
        evaData.decEva = addNumber
        EvaCtrl.static.evaCtrl.addEvaData[self.strId] = evaData
    end
    --    [1] = {value = 1, optionValue ={ } }, -- 原料厂
    --    [2] = {value = 1, optionValue ={ { optionValue = {}} } -- 加工厂
    --}
    -- 保存界面数据，bing
    --EvaCtrl.static.evaCtrl.addData[strId] = addNumber
    --if EvaCtrl.static.evaCtrl.addData[strId] then
    --
    --end
    --local recordData = EvaCtrl.static.evaCtrl:GetEvaRecordData()
end