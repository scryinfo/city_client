---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/12 15:07
---建筑主界面生产线详情界面
BuildingProductionDetailPart = class('BuildingProductionDetailPart',BuildingBaseDetailPart)

local Math_Ceil = math.ceil
local Math_Floor = math.floor
local nowTime = 0
local LastTime = 0
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function BuildingProductionDetailPart:PrefabName()
    return "BuildingProductionDetailPart"
end

function BuildingProductionDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    --待生产
    self.waitingQueueIns = {}
    --self.intTime = 1
    --self.m_Timer = Timer.New(slot(self.Update, self), 1, -1, true)
end
--function BuildingProductionDetailPart:Show()
--    BasePartDetail.Show(self)
--    --self.m_Timer:Start()
--end
function BuildingProductionDetailPart:Hide()
    BasePartDetail.Hide(self)
    UpdateBeat:Remove(self.Update,self)
    self.time = nil
    self.ScrollView.gameObject:SetActive(false)
    if next(self.waitingQueueIns) ~= nil then
        self:CloseDestroy(self.waitingQueueIns)
    end
    --if self.m_Timer ~= nil then
    --    self.m_Timer:Stop()
    --end
end
function BuildingProductionDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
    --获取最新的生产线数据
    Event.Brocast("m_GetLineData",data.insId)
end

function BuildingProductionDetailPart:_ResetTransform()
    --关闭Update
    UpdateBeat:Remove(self.Update,self)
    self.time = nil
    --清空生产队列Item数据
    if next(self.waitingQueueIns) ~= nil then
        self:CloseDestroy(self.waitingQueueIns)
    end
end

function BuildingProductionDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
    self.closeBtn = transform:Find("topRoot/closeBtn"):GetComponent("Button")

    self.addBtn = transform:Find("contentRoot/addBtnBg")
    self.addBtnBg = transform:Find("contentRoot/addBtnBg/addBtn"):GetComponent("Button")
    self.content = transform:Find("contentRoot/content")
    self.addTip = transform:Find("contentRoot/addBtnBg/addTip"):GetComponent("Text")
    --leftRoot
    self.lineInfo = transform:Find("contentRoot/content/leftRoot/lineInfo")
    self.nameBg = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/nameBg")
    self.goods = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods")
    self.tipText = transform:Find("contentRoot/content/leftRoot/lineInfo/tipText"):GetComponent("Text")

    self.iconImg = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/iconImg"):GetComponent("Image")
    self.nameText = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/nameBg/nameText"):GetComponent("Text")
    self.levelImg = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/levelImg"):GetComponent("Image")
    self.brandNameText = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")
    self.numberText = transform:Find("contentRoot/content/leftRoot/lineInfo/numberText"):GetComponent("Text")
    self.timeText = transform:Find("contentRoot/content/leftRoot/lineInfo/timeBg/timeText"):GetComponent("Text")
    self.deleBtn = transform:Find("contentRoot/content/leftRoot/lineInfo/deleBtn"):GetComponent("Button")
    self.timeSlider = transform:Find("contentRoot/content/leftRoot/lineInfo/timeSlider"):GetComponent("Slider")
    self.oneTimeText = transform:Find("contentRoot/content/leftRoot/lineInfo/timeText"):GetComponent("Text")
    --rightRoot
    self.numberTipText = transform:Find("contentRoot/content/rightRoot/topBg/numberTipText"):GetComponent("Text")
    self.lineNumberText = transform:Find("contentRoot/content/rightRoot/topBg/numberTipText/lineNumberText"):GetComponent("Text")
    self.ScrollView = transform:Find("contentRoot/content/rightRoot/content/ScrollView")
    self.Content = transform:Find("contentRoot/content/rightRoot/content/ScrollView/Viewport/Content")
    self.noLineTip = transform:Find("contentRoot/content/rightRoot/content/noLineTip"):GetComponent("Text")
    self.addBg = transform:Find("contentRoot/content/rightRoot/content/addBg")
    self.rightAddBg = transform:Find("contentRoot/content/rightRoot/content/addBg/addBtn"):GetComponent("Button")

    self.lineItemPrefab = transform:Find("contentRoot/content/rightRoot/content/ScrollView/Viewport/Content/LineItem").gameObject
end

function BuildingProductionDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject,function()
        self:clickCloseBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.addBtnBg.gameObject,function()
        self:clickAddBtnBg()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.rightAddBg.gameObject,function()
        self:clickAddBtnBg()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.deleBtn.gameObject,function()
        self:clickDeleBtn()
    end,self)
end

function BuildingProductionDetailPart:_RemoveClick()
    self.closeBtn.onClick:RemoveAllListeners()
    self.addBtnBg.onClick:RemoveAllListeners()
    self.rightAddBg.onClick:RemoveAllListeners()
    self.deleBtn.onClick:RemoveAllListeners()
end

function BuildingProductionDetailPart:_InitEvent()
    Event.AddListener("ProductionLineSettop",self.ProductionLineSettop,self)
    Event.AddListener("detailPartUpdateNowCount",self.updateNowCount,self)
    Event.AddListener("SettopSuccess",self.SettopSuccess,self)
    Event.AddListener("detailPartUpdateNowLine",self.updateNowLine,self)
    Event.AddListener("deleListLine",self.deleListLine,self)
    Event.AddListener("saveMaterialOrGoodsInfo",self.saveMaterialOrGoodsInfo,self)
    Event.AddListener("lineAddSucceed",self.lineAddSucceed,self)
    Event.AddListener("WarehousCapacityWhetherFull",self.WarehousCapacityWhetherFull,self)
    Event.AddListener("WarehousMaterialWhetherEnough",self.WarehousMaterialWhetherEnough,self)
end

function BuildingProductionDetailPart:_RemoveEvent()
    Event.RemoveListener("ProductionLineSettop",self.ProductionLineSettop,self)
    Event.RemoveListener("detailPartUpdateNowCount",self.updateNowCount,self)
    Event.RemoveListener("SettopSuccess",self.SettopSuccess,self)
    Event.RemoveListener("detailPartUpdateNowLine",self.updateNowLine,self)
    Event.RemoveListener("deleListLine",self.deleListLine,self)
    Event.RemoveListener("saveMaterialOrGoodsInfo",self.saveMaterialOrGoodsInfo,self)
    Event.RemoveListener("lineAddSucceed",self.lineAddSucceed,self)
    Event.RemoveListener("WarehousCapacityWhetherFull",self.WarehousCapacityWhetherFull,self)
    Event.RemoveListener("WarehousMaterialWhetherEnough",self.WarehousMaterialWhetherEnough,self)
end

function BuildingProductionDetailPart:_initFunc()
    self:_language()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingProductionDetailPart:_language()
    self.addTip.text = GetLanguage(25030001)
    self.numberTipText.text = GetLanguage(25030019)
end
--初始化UI数据
function BuildingProductionDetailPart:initializeUiInfoData(lineData)
    --self.time = nil
    self.tipText.text = ""
    self.isBoolCapacity = false
    self.isBoolMaterial = false

    if not lineData or next(lineData) == nil then
        self.addBtn.transform.localScale = Vector3.one
        self.content.transform.localScale = Vector3.zero
        self.lineNumberText.text = 0 .."/"..PlayerBuildingBaseData[self.m_data.info.mId].lineNum
    else
        self.itemId = lineData[1].itemId
        self.ScrollView.gameObject:SetActive(true)
        self.content.transform.localScale = Vector3.one
        self.addBtn.transform.localScale = Vector3.zero
        self.nameText.text = GetLanguage(lineData[1].itemId)
        if self.time == nil then
            self.timeText.text = self:GetTime(lineData[1])
            UpdateBeat:Add(self.Update,self)
        end
        --缓存正在生产中的线的目标产量
        self.targetCount = lineData[1].targetCount
        self.numberText.text = lineData[1].nowCount.."/"..self.targetCount
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            self.nameBg.transform.localPosition = Vector3(-140,-100,0)
            self.goods.transform.localScale = Vector3.zero
            LoadSprite(Material[lineData[1].itemId].img,self.iconImg,false)
            --生产一个需要的时间(毫秒)
            self.oneTotalTime = self:GetOneNumTime(self:getNumOneSec(lineData[1].itemId))
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            LoadSprite(Good[lineData[1].itemId].img,self.iconImg,false)
            --生产一个需要的时间(毫秒)
            self.oneTotalTime = self:GetOneNumTime(self:getNumOneSec(lineData[1].itemId))
            --如果是商品，判断原料等级
            if Good[lineData[1].itemId].luxury == 1 then
                self.levelImg.color = getColorByVector3(oneLevel)
            elseif Good[lineData[1].itemId].luxury == 2 then
                self.levelImg.color = getColorByVector3(twoLevel)
            elseif Good[lineData[1].itemId].luxury == 3 then
                self.levelImg.color = getColorByVector3(threeLevel)
            end
            self.brandNameText.text = DataManager.GetCompanyName()
            --self.brandValue.text = self:getLineInfo(lineData[1].itemId,true)
            --self.qualityValue.text = self:getLineInfo(lineData[1].itemId,false)
            self.brandValue.text = lineData[1].brandScore
            self.qualityValue.text = lineData[1].qtyScore
        end
        --当前生产中线开始的时间
        self.startTime = lineData[1].ts
        --当前服务器时间
        self.serverNowTime = TimeSynchronized.GetTheCurrentServerTime()
        --当前生产中线已经生产的时间
        self.pastTime = self.serverNowTime - self.startTime

        self.timeSlider.maxValue = Math_Ceil(self.oneTotalTime / 1000)
        --self.timeSlider.value = (self.oneTotalTime - (self.pastTime % self.oneTotalTime)) / 1000
        self.timeSlider.value = (self.pastTime % self.oneTotalTime) / 1000
        self.oneTimeText.text = self:GetStringTime((self.timeSlider.maxValue - self.timeSlider.value) * 1000)

        if self.Capacity == PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity then
            UpdateBeat:Remove(self.Update,self)
            self.time = nil
            self.timeSlider.value = 0
            self.oneTimeText.text = "00:00"
            self.tipText.text = GetLanguage(25030014)
        else
            --是商品时
            local goodsKey = 22
            if Math_Floor(self.itemId / 100000) == goodsKey then
                --原料不足时
                if self:checkMaterial(self.itemId) == false then
                    UpdateBeat:Remove(self.Update,self)
                    self.time = nil
                    self.oneTimeText.text = "00:00"
                    self.timeSlider.value = 0
                    self.tipText.text = GetLanguage(25030020)
                end
            end
        end

        self.lineNumberText.text = #lineData.."/"..PlayerBuildingBaseData[self.m_data.info.mId].lineNum
        if #lineData == PlayerBuildingBaseData[self.m_data.info.mId].lineNum then
            self.addBg.transform.localScale = Vector3.zero
        else
            self.addBg.transform.localScale = Vector3.one
        end
        --判断当前有没有代生产队列
        if #lineData == 1 then
            self.noLineTip.text = GetLanguage(25030012)
            self.noLineTip.transform.localScale = Vector3.one
        elseif #lineData > 1 then
            self.noLineTip.transform.localScale = Vector3.zero
            --判断当前是否已经创建好了队列
            if #lineData - 1 == #self.waitingQueueIns then
                self.Content.transform.localPosition = Vector3.zero
                return
            else
                self.Content.transform.localPosition = Vector3.one
                for i = 2, #lineData do
                    self:CreatedWaitingQueue(lineData[i],self.lineItemPrefab,self.Content,LineItem,self.mainPanelLuaBehaviour,self.waitingQueueIns,self.m_data.buildingType)
                end
                self.waitingQueueIns[1].placedTopBtn.transform.localScale = Vector3.zero
            end
        end
    end
end
-----------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------
--关闭详情
function BuildingProductionDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--打开添加生产线界面
function BuildingProductionDetailPart:clickAddBtnBg()
    PlayMusEff(1002)
    if self.m_data.info.state == "OPERATE" then
        ct.OpenCtrl("NewAddProductionLineCtrl",self.materialOrGoodsInfo)
        self:CloseDestroy(self.waitingQueueIns)
    else
        Event.Brocast("SmallPop",GetLanguage(20120001),ReminderType.Common)
        return
    end
end
--删除当前正在生产中的线
function BuildingProductionDetailPart:clickDeleBtn()
    PlayMusEff(1002)
    local data={ReminderType = ReminderType.Common,ReminderSelectType = ReminderSelectType.Select,
                content = GetLanguage(25030029),func = function()
            if self.m_data.buildingType == BuildingType.MaterialFactory then
                --原料厂
                Event.Brocast("m_ReqMaterialDeleteLine",self.m_data.insId,self.m_data.line[1].id)
            elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
                --加工厂
                Event.Brocast("m_ReqprocessingDeleteLine",self.m_data.insId,self.m_data.line[1].id)
            end
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--计算总时间
function BuildingProductionDetailPart:GetTime(lineData)
    local remainingNum = lineData.targetCount - lineData.nowCount
    if remainingNum == 0 then
        return "00:00:00"
    end
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        self.time = remainingNum / self:getNumOneSec(lineData.itemId)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        self.time = remainingNum / self:getNumOneSec(lineData.itemId)
    end
    local timeTable = getTimeBySec(self.time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end
--计算当前生产一个需要的时间(毫秒级)
function BuildingProductionDetailPart:GetOneNumTime(numOneSec)
    local seconds = 1 / numOneSec
    local ms = seconds * 1000
    return ms
end
--生产一个的时间转换 时分秒
function BuildingProductionDetailPart:GetStringTime(ms)
    local timeTable = getTimeBySec(ms / 1000)
    local timeStr = timeTable.minute..":"..timeTable.second
    return timeStr
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--刷新时间
function BuildingProductionDetailPart:Update()
    --刷新时间有问题，但不影响流程
    if self.isBoolCapacity == true then
        UpdateBeat:Remove(self.Update,self)
        self.time = nil
        self.timeSlider.value = 0
        self.oneTimeText.text = "00:00"
        self.tipText.text = GetLanguage(25030014)
        return
    else
        local goodsKey = 22
        if Math_Floor(self.itemId / 100000) == goodsKey then
            --原料不足时
            --这个要测试材料不足的情况
            if self.isBoolMaterial == true then
                UpdateBeat:Remove(self.Update,self)
                self.time = nil
                self.timeSlider.value = 0
                self.oneTimeText.text = "00:00"
                self.tipText.text = GetLanguage(25030020)
                return
            end
        end
    end

    ---刷新总时间
    if self.time ~= nil then
        self.time = self.time - UnityEngine.Time.unscaledDeltaTime
        local timeTable = getTimeBySec(self.time)
        local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
        self.timeText.text = timeStr
    end

    ---刷新单个时间
    --当前生产中线开始的时间
    if not self.m_data.line or next(self.m_data.line) == nil then
        self.startTime = 0
    else
        self.startTime = self.m_data.line[1].ts
    end
    --当前服务器时间
    self.serverNowTime = TimeSynchronized.GetTheCurrentServerTime()
    --当前生产中线已经生产的时间
    self.pastTime = self.serverNowTime - self.startTime
    --当前一个已经生产的时间
    local thisTime = (self.pastTime % self.oneTotalTime)
    nowTime = nowTime + UnityEngine.Time.unscaledDeltaTime * 1000
    if LastTime ~= thisTime then
        LastTime = thisTime
        nowTime = thisTime
    end
    if (nowTime / self.oneTotalTime) >= 1 then
        nowTime = 0
    end
    self.timeSlider.value = (nowTime / self.oneTotalTime) * self.timeSlider.maxValue
    self.oneTimeText.text = self:GetStringTime((self.timeSlider.maxValue - self.timeSlider.value + 1) * 1000)
end
------------------------------------------------------------------------------------事件函数------------------------------------------------------------------------------------
--置顶
function BuildingProductionDetailPart:ProductionLineSettop(data)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --原料厂
        Event.Brocast("m_ReqMaterialSetLineOrder",self.m_data.insId,data.lineId,2)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --加工厂
        Event.Brocast("m_ReqprocessingSetLineOrder",self.m_data.insId,data.lineId,2)
    end
end
--删除生产队列线
function BuildingProductionDetailPart:deleListLine(data)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        --原料厂
        Event.Brocast("m_ReqMaterialDeleteLine",self.m_data.insId,data.lineId)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        --加工厂
        Event.Brocast("m_ReqprocessingDeleteLine",self.m_data.insId,data.lineId)
    end
end
--查询生产线成功
function BuildingProductionDetailPart:lineAddSucceed(data)
    self.m_data.line = data.line
    self.Capacity = data.warehouseCapacity
    self:initializeUiInfoData(data.line)
end
------------------------------------------------------------------------------------回调函数------------------------------------------------------------------------------------
--置顶成功后调整位置
function BuildingProductionDetailPart:SettopSuccess(data)
    --调整gameObject位置,实例表位置
    local temporaryKey = nil
    local temporaryValue = nil
    self.waitingQueueIns[1].placedTopBtn.transform.localScale = Vector3.one
    for key,value in pairs(self.waitingQueueIns) do
        if value.lineId == data.lineId then
            value.prefab.transform:SetSiblingIndex(1)
            value.placedTopBtn.transform.localScale = Vector3.zero
            temporaryKey = key
            temporaryValue = value
        end
    end
    for key,value in pairs(self.m_data.line) do
        if value.lineId == data.lineId then
            temporaryKey = key
            temporaryValue = value
        end
    end
    table.remove(self.m_data.line,temporaryKey)
    table.insert(self.m_data.line,2,temporaryValue)
    table.remove(self.waitingQueueIns,temporaryKey)
    table.insert(self.waitingQueueIns,1,temporaryValue)
    Event.Brocast("SmallPop",GetLanguage(25030013), ReminderType.Succeed)
end
--刷新当前产量
function BuildingProductionDetailPart:updateNowCount(data)
    if data ~= nil then
        if self.targetCount ~= nil then
            self.numberText.text = data.nowCount.."/"..self.targetCount
        end
        if tonumber(string.sub(data.iKey.id,1,2)) == 22 then
            --如果是商品要扣除原料
            self:getWarehouseCapacity()
        end
    end
end
--删除正在生产中的线
function BuildingProductionDetailPart:updateNowLine(data)
    if data ~= nil then
        --清空生产队列Item数据
        UpdateBeat:Remove(self.Update,self)
        self.time = nil
        if next(self.waitingQueueIns) ~= nil then
            self:CloseDestroy(self.waitingQueueIns)
        end
        --获取最新的生产线数据
        Event.Brocast("m_GetLineData",data.buildingId)
    end
end
--缓存获取到当前建筑Eva加点后的生产速度(原料信息，商品信息)
function BuildingProductionDetailPart:saveMaterialOrGoodsInfo(data)
    if data then
        if not self.materialOrGoodsInfo then
            self.materialOrGoodsInfo = data
            self.materialOrGoodsInfo.buildingType = self.m_data.buildingType
            self.materialOrGoodsInfo.mId = self.m_data.info.mId
            --self:initializeUiInfoData(self.m_data.line)
        else
            return
        end
    end
end
--仓库是否没有容量
function BuildingProductionDetailPart:WarehousCapacityWhetherFull(data)
    self.isBoolCapacity = data.b
end
--生产商品时材料够不够
function BuildingProductionDetailPart:WarehousMaterialWhetherEnough(data)
    self.isBoolMaterial = data.b
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--删除一条待生产的线
function BuildingProductionDetailPart:updateListLine(id)
    if next(self.waitingQueueIns) == nil then
        return
    else
        destroy(self.waitingQueueIns[id].prefab.gameObject)
        table.remove(self.waitingQueueIns,id)
    end
    if #self.waitingQueueIns + 1 == PlayerBuildingBaseData[self.m_data.info.mId].lineNum then
        self.addBg.transform.localScale = Vector3.zero
    else
        self.addBg.transform.localScale = Vector3.one
    end
    self.lineNumberText.text = #self.waitingQueueIns + 1 .."/"..PlayerBuildingBaseData[self.m_data.info.mId].lineNum
    if next(self.waitingQueueIns) == nil then
        self.noLineTip.transform.localScale = Vector3.one
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--如果生产中是商品，检查原料够不够
function BuildingProductionDetailPart:checkMaterial(itemId)
    --如果仓库是空的
    if not self.m_data.store.inHand or next(self.m_data.store.inHand) == nil then
        return false
    end
    --如果仓库不是空的
    self.material = CompoundDetailConfig[itemId].goodsNeedMatData
    local materialNum = {}
    local isMeet = false
    --生产中商品需要的原料
    for key,value in pairs(self.material) do
        --仓库中有的原料
        isMeet = false
        for key1,value1 in pairs(self.m_data.store.inHand) do
            if value1.key.id == value.itemId then
                materialNum[#materialNum + 1] = Math_Floor(value1.n / value.num)
                isMeet = true
            end
        end
        if isMeet == false then
            materialNum[#materialNum + 1] = 0
        end
    end
    table.sort(materialNum)
    --最少能生产的数量
    self.lineMinValue = materialNum[1]
    local minValue = materialNum[1]
    if minValue <= 0 then
        return false
    else
        return true
    end
end
--如果是生产商品的话，生产出来扣除现有的原料
function BuildingProductionDetailPart:getWarehouseCapacity()
    for key,value in pairs(self.material) do
        for key1,value1 in pairs(self.m_data.store.inHand) do
            if value.itemId == value1.key.id then
                value1.n = value1.n - value.num
                if value1.n == 0 then
                    table.remove(self.m_data.store.inHand,key1)
                end
                break
            end
        end
    end
end
--获取当前生产中的秒产量(含Eva)
function BuildingProductionDetailPart:getNumOneSec(itemId)
    if not self.materialOrGoodsInfo or next(self.materialOrGoodsInfo) == nil then
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            return Material[itemId].numOneSec
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            return Good[itemId].numOneSec
        end
    else
        for key,value in pairs(self.materialOrGoodsInfo.items) do
            if value.key == itemId then
                return value.numOneSec
            end
        end
    end
end
--获取正在生产或待生产的中的brandName,brandScore,qualityScore
function BuildingProductionDetailPart:getLineInfo(itemId,isBool)
    for key,value in pairs(self.materialOrGoodsInfo.items) do
        if value.key == itemId and isBool == true then
            return value.brandScore
        elseif value.key == itemId and isBool == false then
            return value.qtyScore
        end
    end
end
