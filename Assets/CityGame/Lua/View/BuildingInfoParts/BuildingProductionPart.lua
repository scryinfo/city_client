---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 14:57
---建筑主界面生产线

BuildingProductionPart = class("BuildingProductionPart",BasePart)

function BuildingProductionPart:PrefabName()
    return "BuildingProductionPart"
end

function BuildingProductionPart:GetDetailClass()
    return BuildingProductionDetailPart
end

function BuildingProductionPart:_InitTransform()
    self:_getComponent(self.transform)
end

function BuildingProductionPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end

function BuildingProductionPart:_ResetTransform()
    --关闭Update
    UpdateBeat:Remove(self.Update,self)
    Event.RemoveListener("partUpdateNowCount",self.updateNowCount,self)
    Event.RemoveListener("partUpdateNowLine",self.updateNowLine,self)
end

function BuildingProductionPart:_getComponent(transform)
    if transform == nil then
        return
    end
    self.TopLineInfo = transform:Find("Top/TopLineInfo")
    self.goodsIcon = transform:Find("Top/TopLineInfo/goodsIcon"):GetComponent("Image")
    self.timeText = transform:Find("Top/TopLineInfo/timeText"):GetComponent("Text")
    self.numberSlider = transform:Find("Top/TopLineInfo/numberSlider"):GetComponent("Slider")
    self.numberText = transform:Find("Top/TopLineInfo/numberSlider/numberText"):GetComponent("Text")
    self.tipText = transform:Find("Top/tipText"):GetComponent("Text")
    self.unselectTitleText = transform:Find("UnselectBtn/titleText"):GetComponent("Text")
    self.selectTitleText = transform:Find("SelectBtn/titleText"):GetComponent("Text")
end

function BuildingProductionPart:_InitChildClick(mainPanelLuaBehaviour)

    Event.AddListener("partUpdateNowCount",self.updateNowCount,self)
    Event.AddListener("partUpdateNowLine",self.updateNowLine,self)
end

function BuildingProductionPart:_initFunc()
    self:_language()
    if not self.m_data.line or next(self.m_data.line) == nil then
        self.TopLineInfo.transform.localScale = Vector3.zero
        self.tipText.transform.localScale = Vector3.one
    else
        self.TopLineInfo.transform.localScale = Vector3.one
        self.tipText.transform.localScale = Vector3.zero

        if self.m_data.buildingType == BuildingType.MaterialFactory then
            LoadSprite(Material[self.m_data.line[1].itemId].img,self.goodsIcon,false)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            LoadSprite(Good[self.m_data.line[1].itemId].img,self.goodsIcon,false)
        end
        self.numberSlider.maxValue = self.m_data.line[1].targetCount
        self.numberSlider.value = self.m_data.line[1].nowCount
        self.numberText.text = self.numberSlider.value.."/"..self.numberSlider.maxValue
        if self.time == nil then
            self.timeText.text = self:GetTime(self.m_data.line[1])
            UpdateBeat:Add(self.Update,self)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingProductionPart:_language()
    self.unselectTitleText.text = "生产线"
    self.selectTitleText.text = "生产线"
end
--计算总时间
function BuildingProductionPart:GetTime(lineData)
    local remainingNum = lineData.targetCount - lineData.nowCount
    if remainingNum == 0 then
        return "00:00:00"
    end
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        self.time = remainingNum / (Material[lineData.itemId].numOneSec * lineData.workerNum)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        self.time = remainingNum / (Good[lineData.itemId].numOneSec * lineData.workerNum)
    end
    local timeTable = getTimeBySec(self.time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end
--刷新时间
function BuildingProductionPart:Update()
    if self.time == nil or self.time <= 0 then
        self.TopLineInfo.transform.localScale = Vector3.zero
        self.tipText.transform.localScale = Vector3.one
        UpdateBeat:Remove(self.Update,self)
    end
    self.time = self.time - UnityEngine.Time.unscaledDeltaTime
    local timeTable = getTimeBySec(self.time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    self.timeText.text = timeStr
end
------------------------------------------------------------------------------------回调函数------------------------------------------------------------------------------------
--刷新当前产量
function BuildingProductionPart:updateNowCount(data)
    if data ~= nil then
        self.numberSlider.maxValue = self.m_data.line[1].targetCount
        self.numberSlider.value = data.nowCount
        self.numberText.text = self.numberSlider.value.."/"..self.numberSlider.maxValue
        self.m_data.line[1].nowCount = data.nowCount
    end
end
--删除正在生产中的线
function BuildingProductionPart:updateNowLine(data)
    if data ~= nil then
        self.time = nil
        UpdateBeat:Remove(self.Update,self)
        --重新初始化界面
        self:_initFunc()
    end
end