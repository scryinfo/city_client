---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/13 11:26
---
AddProductionLineBoxCtrl = class('AddProductionLineBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(AddProductionLineBoxCtrl)

local ToNumber = tonumber
local addLineBox
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function AddProductionLineBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal)
end

function AddProductionLineBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AddProductionLineBoxPanel.prefab"
end
function AddProductionLineBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end
function AddProductionLineBoxCtrl:Awake(go)
    self.gameObject = go
end
function AddProductionLineBoxCtrl:Active()
    UIPanel.Active(self)
    addLineBox = self.gameObject:GetComponent('LuaBehaviour')
    addLineBox:AddClick(AddProductionLineBoxPanel.closeBtn.gameObject,self.clickCloseBtn,self)
    addLineBox:AddClick(AddProductionLineBoxPanel.leftBtn.gameObject,self.clickLeftBtn,self)
    addLineBox:AddClick(AddProductionLineBoxPanel.rightBtn.gameObject,self.clickRightBtn,self)
    addLineBox:AddClick(AddProductionLineBoxPanel.confirmBtn.gameObject,self.clickConfirmBtn,self)

    AddProductionLineBoxPanel.topName.text = GetLanguage(25030003)
    AddProductionLineBoxPanel.popularityText.text = GetLanguage(25020006)
    AddProductionLineBoxPanel.qualityText.text = GetLanguage(25020005)
    AddProductionLineBoxPanel.levelText.text = GetLanguage(25020007)
    AddProductionLineBoxPanel.productionText.text = GetLanguage(25030004)
    AddProductionLineBoxPanel.eachText.text = GetLanguage(31010042)
    AddProductionLineBoxPanel.time.text = GetLanguage(25030005)
    AddProductionLineBoxPanel.numberTip.text = GetLanguage(25030006)
    --addLineBox:AddClick(AddLineBoxPanel.leftBtn.gameObject,self.OnClick_leftBtn,self)
    --addLineBox:AddClick(AddLineBoxPanel.rightBtn.gameObject,self.OnClick_rightBtn,self)
    --addLineBox:AddClick(AddLineBoxPanel.closeBtn.gameObject,self.OnClick_closeBtn,self)

    AddProductionLineBoxPanel.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
    AddProductionLineBoxPanel.numberInput.onValueChanged:AddListener(function()
        self:inputUpdateText()
    end)
end
function AddProductionLineBoxCtrl:Refresh()
    self:_language()
    self:InitializeData()
end
function AddProductionLineBoxCtrl:Hide()
    UIPanel.Hide(self)
    AddProductionLineBoxPanel.numberSlider.onValueChanged:RemoveAllListeners()
end
------------------------------------------------------------------------初始化函数------------------------------------------------------------------------------------------
function AddProductionLineBoxCtrl:InitializeData()
    if not self.m_data then
        return
    end
    AddProductionLineBoxPanel.tipText.transform.localScale = Vector3.zero
    AddProductionLineBoxPanel.numberText.text = "0/0"
    AddProductionLineBoxPanel.timeText.text = "00:00:00"
    AddProductionLineBoxPanel.numberSlider.value = 1
    AddProductionLineBoxPanel.numberSlider.minValue = 1
    AddProductionLineBoxPanel.numberSlider.maxValue = PlayerBuildingBaseData[self.m_data.mId].storeCapacity
    --AddProductionLineBoxPanel.sliderNumberText.text = "×"..AddProductionLineBoxPanel.numberSlider.value
    AddProductionLineBoxPanel.nameText.text = GetLanguage(self.m_data.itemId)
    self.workerNum = PlayerBuildingBaseData[self.m_data.mId].maxWorkerNum

    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --如果是原料关闭商品属性展示
        AddProductionLineBoxPanel.popularity.transform.localScale = Vector3.zero
        AddProductionLineBoxPanel.quality.transform.localScale = Vector3.zero
        AddProductionLineBoxPanel.levelBg.transform.localScale = Vector3.zero
        AddProductionLineBoxPanel.scoreBg.transform.localScale = Vector3.zero
        AddProductionLineBoxPanel.iconBg.transform.localPosition = Vector3(0,30,0)
        LoadSprite(Material[self.m_data.itemId].img,AddProductionLineBoxPanel.iconImg,false)
        --local speed = 1 / (Material[self.m_data.itemId].numOneSec * self.workerNum)
        local speed = 1 / self.m_data.numOneSec
        AddProductionLineBoxPanel.speedText.text = self:GetOneSecNum(speed)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --如果是商品打开商品属性展示
        AddProductionLineBoxPanel.tipText.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.popularity.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.quality.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.levelBg.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.scoreBg.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.iconBg.transform.localPosition = Vector3(-292,30,0)
        LoadSprite(Good[self.m_data.itemId].img,AddProductionLineBoxPanel.iconImg,false)
        --local speed = 1 / (Good[self.m_data.itemId].numOneSec * self.workerNum)
        local speed = 1 / self.m_data.info.numOneSec
        AddProductionLineBoxPanel.speedText.text = self:GetOneSecNum(speed)
        --如果是商品，判断原料等级
        if Good[self.m_data.itemId].luxury == 1 then
            AddProductionLineBoxPanel.levelImg.color = getColorByVector3(oneLevel)
            AddProductionLineBoxPanel.levelValue.text = GetLanguage(25020028)
        elseif Good[self.m_data.itemId].luxury == 2 then
            AddProductionLineBoxPanel.levelImg.color = getColorByVector3(twoLevel)
            AddProductionLineBoxPanel.levelValue.text = GetLanguage(25020029)
        elseif Good[self.m_data.itemId].luxury == 3 then
            AddProductionLineBoxPanel.levelImg.color = getColorByVector3(threeLevel)
            AddProductionLineBoxPanel.levelValue.text = GetLanguage(25020030)
        end
        AddProductionLineBoxPanel.brandNameText.text = self.m_data.info.brandName
        AddProductionLineBoxPanel.popularityValue.text = self.m_data.info.brandScore
        AddProductionLineBoxPanel.qualityValue.text = self.m_data.info.qtyScore
    end
end
--多语言
function AddProductionLineBoxCtrl:_language()
    AddProductionLineBoxPanel.tipText.text = "当原料不足时,生产线会停止"
end
------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------------
--左Button
function AddProductionLineBoxCtrl:clickLeftBtn()

end
--右Button
function AddProductionLineBoxCtrl:clickRightBtn()

end
--关闭Button
function AddProductionLineBoxCtrl:clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--确定Button
function AddProductionLineBoxCtrl:clickConfirmBtn(go)
    PlayMusEff(1002)
    local number = AddProductionLineBoxPanel.numberSlider.value
    if go:NumberWhetherZero(number) == true then
        if go.m_data.buildingType == BuildingType.MaterialFactory then
            --原料厂
            Event.Brocast("m_ReqMaterialAddLine",go.m_data.insId,number,go.workerNum,go.m_data.itemId)
        elseif go.m_data.buildingType == BuildingType.ProcessingFactory then
            --加工厂
            Event.Brocast("m_ReqprocessingAddLine",go.m_data.insId,number,go.workerNum,go.m_data.itemId)
        end
    else
        Event.Brocast("SmallPop",GetLanguage(25030025),ReminderType.Common)
    end
end
--------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------------
--添加成功后
function AddProductionLineBoxCtrl:SucceedUpdatePanel(dataInfo)
    if dataInfo ~= nil then
        TimeSynchronized.SynchronizationServerTime(dataInfo.ts)
        UIPanel.ClosePage()
        ----查询当前生产线
        --Event.Brocast("m_GetLineData",self.m_data.insId)
        Event.Brocast("SmallPop",GetLanguage(25030010),ReminderType.Common)
        UIPanel.ClosePage()
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--保留小数点后两位
function AddProductionLineBoxCtrl:GetOneSecNum(str)
    local index = string.find(str, '%.')
    if not index then
        return str
    end
    local secStr = string.sub(str,1,index + 2)
    return secStr
end

--滑动条刷新输入框值
function AddProductionLineBoxCtrl:SlidingUpdateText()
    --AddProductionLineBoxPanel.sliderNumberText.text = "×"..AddProductionLineBoxPanel.numberSlider.value
    AddProductionLineBoxPanel.numberInput.text = AddProductionLineBoxPanel.numberSlider.value
    AddProductionLineBoxPanel.timeText.text = self:GetTime(AddProductionLineBoxPanel.numberSlider.value,self.workerNum)
end
--输入框事件
function AddProductionLineBoxCtrl:inputUpdateText()
    if AddProductionLineBoxPanel.numberInput.text == "" or ToNumber(AddProductionLineBoxPanel.numberInput.text) <= 0 then
        AddProductionLineBoxPanel.numberInput.text = 1
    end
    if ToNumber(AddProductionLineBoxPanel.numberInput.text) > PlayerBuildingBaseData[self.m_data.mId].storeCapacity then
        AddProductionLineBoxPanel.numberInput.text = PlayerBuildingBaseData[self.m_data.mId].storeCapacity
    end
    AddProductionLineBoxPanel.numberSlider.value = ToNumber(AddProductionLineBoxPanel.numberInput.text)
end
--检查要生产的数量是否为零
function AddProductionLineBoxCtrl:NumberWhetherZero(number)
    if number == 0 then
        return false
    end
    return true
end
--计算时间
function AddProductionLineBoxCtrl:GetTime(targetCount,workerNum)
    if targetCount == 0 or workerNum == 0 then
        return "00:00:00"
    end
    local time
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --time = targetCount / (Material[self.m_data.itemId].numOneSec * workerNum)
        time = targetCount / self.m_data.numOneSec
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --time = targetCount / (Good[self.m_data.itemId].numOneSec * workerNum)
        time = targetCount / self.m_data.info.numOneSec
    end
    local timeTable = getTimeBySec(time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end