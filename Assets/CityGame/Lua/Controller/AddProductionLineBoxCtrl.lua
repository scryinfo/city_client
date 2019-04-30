---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/13 11:26
---
AddProductionLineBoxCtrl = class('AddProductionLineBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(AddProductionLineBoxCtrl)

local addLineBox
--local Math_Floor = math.floor
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


    --addLineBox:AddClick(AddLineBoxPanel.leftBtn.gameObject,self.OnClick_leftBtn,self)
    --addLineBox:AddClick(AddLineBoxPanel.rightBtn.gameObject,self.OnClick_rightBtn,self)
    --addLineBox:AddClick(AddLineBoxPanel.closeBtn.gameObject,self.OnClick_closeBtn,self)

    AddProductionLineBoxPanel.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
end
function AddProductionLineBoxCtrl:Refresh()
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
    AddProductionLineBoxPanel.numberSlider.value = 0
    AddProductionLineBoxPanel.numberSlider.maxValue = PlayerBuildingBaseData[self.m_data.mId].storeCapacity
    AddProductionLineBoxPanel.sliderNumberText.text = "×"..AddProductionLineBoxPanel.numberSlider.value
    AddProductionLineBoxPanel.nameText.text = GetLanguage(self.m_data.itemId)
    self.workerNum = PlayerBuildingBaseData[self.m_data.mId].maxWorkerNum

    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --如果是原料关闭商品属性展示
        AddProductionLineBoxPanel.popularity.transform.localScale = Vector3.zero
        AddProductionLineBoxPanel.quality.transform.localScale = Vector3.zero
        AddProductionLineBoxPanel.levelBg.transform.localScale = Vector3.zero
        LoadSprite(Material[self.m_data.itemId].img,AddProductionLineBoxPanel.iconImg,false)
        local speed = 1 / (Material[self.m_data.itemId].numOneSec * self.workerNum)
        AddProductionLineBoxPanel.speedText.text = self:GetOneSecNum(speed).."s"
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --如果是商品打开商品属性展示
        AddProductionLineBoxPanel.popularity.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.quality.transform.localScale = Vector3.one
        AddProductionLineBoxPanel.levelBg.transform.localScale = Vector3.one
        LoadSprite(Good[self.m_data.itemId].img,AddProductionLineBoxPanel.iconImg,false)
        local speed = 1 / (Good[self.m_data.itemId].numOneSec * self.workerNum)
        AddProductionLineBoxPanel.speedText.text = self:GetOneSecNum(speed).."s"
    end
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
        Event.Brocast("SmallPop",GetLanguage(26020003),300)
    end
end
--------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------------
--添加成功后
function AddProductionLineBoxCtrl:SucceedUpdatePanel(dataInfo)
    if dataInfo ~= nil then
        TimeSynchronized.SynchronizationServerTime(dataInfo.ts)
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            UIPanel.BackToPageInstance(MaterialFactoryCtrl,self.m_data)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            UIPanel.BackToPageInstance(ProcessingFactoryCtrl,self.m_data)
        end
        Event.Brocast("SmallPop",GetLanguage(28010007),300)
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
    AddProductionLineBoxPanel.sliderNumberText.text = "×"..AddProductionLineBoxPanel.numberSlider.value
    AddProductionLineBoxPanel.timeText.text = self:GetTime(AddProductionLineBoxPanel.numberSlider.value,self.workerNum)
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
        time = targetCount / (Material[self.m_data.itemId].numOneSec * workerNum)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        time = targetCount / (Good[self.m_data.itemId].numOneSec * workerNum)
    end
    local timeTable = getTimeBySec(time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end