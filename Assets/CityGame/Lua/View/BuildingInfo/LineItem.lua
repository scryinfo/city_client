---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by fisher.
--- DateTime: 2019/3/4 15:50
---
LineItem = class("LineItem")

--主页生产线
function LineItem:initialize(lineInfo,prefab,LuaBehaviour,buildingId)
    self.prefab = prefab;
    self.lineInfo = lineInfo
    self.itemId = lineInfo.itemId
    self.lineId = lineInfo.id
    self.workerNum = lineInfo.workerNum

    self.itemGoodsbg = self.prefab.transform:Find("itembg/itemGoodsbg")
    self.itemMaterialbg = self.prefab.transform:Find("itembg/itemMaterialbg")
    self.brandbg = self.prefab.transform:Find("itembg/brandbg")
    self.brandName = self.prefab.transform:Find("itembg/brandbg/brandName"):GetComponent("Text")
    self.brand = self.prefab.transform:Find("itembg/brand")
    self.brandValue = self.prefab.transform:Find("itembg/brand/brandValue"):GetComponent("Text")   --品牌评分
    self.quality = self.prefab.transform:Find("itembg/quality")
    self.qualityValue = self.prefab.transform:Find("itembg/quality/qualityValue"):GetComponent("Text")   --品质评分
    self.nameText = self.prefab.transform:Find("itembg/nameText"):GetComponent("Text")
    self.icon = prefab.transform:Find("itembg/icon"):GetComponent("Image")
    self.accreditIcon = prefab.transform:Find("itembg/accreditIcon")
    self.timeText = prefab.transform:Find("time/timeText"):GetComponent("Text")
    self.productionSlider = prefab.transform:Find("productionSlider"):GetComponent("Slider")
    self.numberText = prefab.transform:Find("numberText"):GetComponent("Text")
    self.deleteBtn = prefab.transform:Find("deleteBtn")
    self.countdownText = prefab.transform:Find("countdownText"):GetComponent("Text")

    self:InitializeData()
    LuaBehaviour:AddClick(self.deleteBtn.gameObject,function()
        PlayMusEff(1002)
        Event.Brocast("m_ReqMaterialDeleteLine",buildingId,self.lineId)
    end)
    Event.AddListener("c_refreshNowConte",self.refreshNowConte,self)
end
--生产线初始化
function LineItem:InitializeData()
    local materialKey,goodsKey = 21,22  --商品类型
    if math.floor(self.itemId / 100000) == materialKey then
        --生产一个需要的时间
        self.numOneTime = self:GetNumOneTime(Material[self.itemId].numOneSec,self.workerNum)
        self.brandbg.localScale = Vector3.New(0,0,0)
        self.brand.localScale = Vector3.New(0,0,0)
        self.quality.localScale = Vector3.New(0,0,0)
        self.itemGoodsbg.localScale = Vector3.New(0,0,0)
        LoadSprite(Material[self.itemId].img,self.icon,false)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        --生产一个需要的时间
        self.numOneTime = self:GetNumOneTime(Good[self.itemId].numOneSec,self.workerNum)
        self.brandbg.localScale = Vector3.New(0,0,0)
        self.brand.localScale = Vector3.New(0,0,0)
        self.quality.localScale = Vector3.New(0,0,0)
        self.itemMaterialbg.localScale = Vector3.New(0,0,0)
        LoadSprite(Good[self.itemId].img,self.icon,false)
        ---self.brandValue =
        ---self.qualityValue =
    end
    --生产开始的时间
    self.startTime = self.lineInfo.ts
    --服务器当前时间
    self.nowTime = TimeSynchronized.GetTheCurrentServerTime()
    --已经生产的时间
    self.remainTime = self.nowTime - self.startTime

    self.brandName.text = GetLanguage(4301011)
    self.nameText.text = GetLanguage(self.itemId)
    self.accreditIcon.localScale = Vector3.New(0,0,0)
    local number = {}
    number["num1"] = self.lineInfo.nowCount
    number["num2"] = self.lineInfo.targetCount
    number["col1"] = "blue"
    number["col2"] = "black"
    self.numberText.text = getColorString(number)
    self.productionSlider.maxValue = self.numOneTime / 1000
    self.productionSlider.value = math.ceil((self.numOneTime - (self.remainTime % self.numOneTime) )/ 1000)
    self.countdownText.text = self:GetStringTime(self.productionSlider.value * 1000)
    self.timeText.text = self:GetTime(self.lineInfo.targetCount,self.lineInfo.nowCount,self.lineInfo.workerNum)
    UpdateBeat:Add(self.Update,self)
end
--计算总时间
function LineItem:GetTime(targetCount,nowCount,workerNum)
    local remainingNum = targetCount - nowCount
    if remainingNum == 0 then
        return "00:00:00"
    end
    local materialKey,goodsKey = 21,22  --商品类型
    local timeSpended = TimeSynchronized.GetTheCurrentServerTime() - self.lineInfo.ts
    if math.floor(self.itemId / 100000) == materialKey then
        self.time = remainingNum / (Material[self.itemId].numOneSec * workerNum) - timeSpended
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.time = remainingNum / (Good[self.itemId].numOneSec * workerNum) - timeSpended
    end
    local timeTable = getTimeBySec(self.time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end
--生产一个需要的时间(毫秒)
function LineItem:GetNumOneTime(numOneSec,workerNum)
    local seconds = 1 / (numOneSec * workerNum)
    local ms = seconds * 1000
    return ms
end
--转换时间 时分秒
function LineItem:GetStringTime(ms)
    self.oneTime = ms / 1000
    local timeTable = getTimeBySec(ms / 1000)
    local timeStr = timeTable.minute..":"..timeTable.second
    return timeStr
end
--刷新时间
function LineItem:Update()
    --总时间
    if self.time <= 0 then
        self.timeText.text = "00:00:00"
        UpdateBeat:Remove(self.Update,self)
        return
    end
    self.time = self.time - UnityEngine.Time.unscaledDeltaTime
    local timeTable = getTimeBySec(self.time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    self.timeText.text = timeStr

    --单个时间
    self.oneTime = self.oneTime - UnityEngine.Time.unscaledDeltaTime
    local timeTable1 = getTimeBySec(self.oneTime)
    local timeStr1 = timeTable1.minute..":"..timeTable1.second
    self.countdownText.text = timeStr1
    --self.productionSlider.value = self.productionSlider.value + UnityEngine.Time.unscaledDeltaTime
    --生产开始的时间
    self.startTime = self.lineInfo.ts
    --服务器当前时间
    self.nowTime = TimeSynchronized.GetTheCurrentServerTime()
    --已经生产的时间
    self.remainTime = self.nowTime - self.startTime
    self.productionSlider.value = self.productionSlider.maxValue - math.ceil((self.numOneTime - (self.remainTime % self.numOneTime) )/ 1000)
    if self.oneTime <= 0 then
        self.oneTime = self.numOneTime
        self.countdownText.text = self:GetStringTime(self.oneTime)
        self.productionSlider.value = 0
    end
end
--刷新目前产量
function LineItem:refreshNowConte(dataInfo)
    if not dataInfo then
        return
    end
    local number = {}
    number["num1"] = dataInfo.nowCount
    number["num2"] = self.lineInfo.targetCount
    number["col1"] = "blue"
    number["col2"] = "black"
    if HomeProductionLineItem.lineItemTable ~= nil then
        for key,value in pairs(HomeProductionLineItem.lineItemTable) do
            value.numberText.text = getColorString(number)
        end
    end
end
--移除事件
function LineItem:closeEvent()
    UpdateBeat:Remove(self.Update,self);
    Event.RemoveListener("c_refreshNowConte",self)
end