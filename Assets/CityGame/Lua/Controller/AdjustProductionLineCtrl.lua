AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPanel);
UIPanel:ResgisterOpen(AdjustProductionLineCtrl) --How to open the registration

--Examples of raw material plants
AdjustProductionLineCtrl.materialProductionLine = {};
--Add production line temporary table
AdjustProductionLineCtrl.tempProductionLine = {}

AdjustProductionLineCtrl.idleWorkerNums = 0
local adjustLine
function AdjustProductionLineCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AdjustProductionLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AdjustProductionLinePanel.prefab"
end

function AdjustProductionLineCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function AdjustProductionLineCtrl:Awake(go)
    self.gameObject = go
    adjustLine = self.gameObject:GetComponent('LuaBehaviour')
    adjustLine:AddClick(AdjustProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.addBtn.gameObject,self.OnClick_addBtn,self);
    --adjustLine:AddClick(AdjustProductionLinePanel.determineBtn.gameObject,self.OnClick_determineBtn,self);

end
function AdjustProductionLineCtrl:Active()
    UIPanel.Active(self)

    AdjustProductionLinePanel.nameText.text = GetLanguage(32010001)
    AdjustProductionLinePanel.Capacity.text = GetLanguage(28010002)
    AdjustProductionLinePanel.idleText.text = GetLanguage(32010003)

    Event.AddListener("calculateTime",self.calculateTime,self)
    Event.AddListener("refreshSubtractWorkerNum",self.refreshSubtractWorkerNum,self)
    --Event.AddListener("refreshTime",self.refreshTime,self)
    Event.AddListener("_deleteProductionLine",self._deleteProductionLine,self)
    Event.AddListener("refreshNowConte",self.refreshNowConte,self)
    Event.AddListener("callbackDataInfo",self.callbackDataInfo,self)
end
function AdjustProductionLineCtrl:Refresh()
    if self.m_data ~= nil then
        self.data = self.m_data
    end
    self.luabehaviour = adjustLine
    AdjustProductionLinePanel.locked_Slider.maxValue = PlayerBuildingBaseData[self.data.info.mId].storeCapacity;
    AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[self.data.info.mId].storeCapacity;
    AdjustProductionLinePanel.locked_Slider.value = WarehouseCtrl:getWarehouseCapacity(self.data.store);
    AdjustProductionLinePanel.capacity_Slider.value = WarehouseCtrl:getWarehouseNum(self.data.store);
    AdjustProductionLineCtrl.warehouseCapacity = WarehouseCtrl:getWarehouseCapacity(self.data.store)  --Refresh time
    local lockedNum = WarehouseCtrl:getLockedNum(self.data.store)
    local numTab = {}
    numTab["num1"] = AdjustProductionLinePanel.locked_Slider.value
    numTab["num2"] = AdjustProductionLinePanel.capacity_Slider.maxValue
    numTab["num3"] = lockedNum
    numTab["col1"] = "Cyan"
    numTab["col2"] = "black"
    numTab["col3"] = "Teal"
    AdjustProductionLinePanel.numberText.text = getColorString(numTab)
    --The remaining capacity
    AdjustProductionLineCtrl.residualCapacity = tonumber(AdjustProductionLinePanel.capacity_Slider.maxValue) - tonumber(AdjustProductionLinePanel.capacity_Slider.value)
    self.buildingMaxWorkerNum = PlayerBuildingBaseData[self.data.info.mId].maxWorkerNum
    self.idleWorkerNum = self:getWorkerNum()
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    AdjustProductionLineCtrl.store = self.data.store
    if self.m_data.line then
        self.productionLine = self.m_data.line
        self.productionLine.buildingId = self.m_data.info.id
        self.productionLine.type = BuildingInType.ProductionLine
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour,self.productionLine);
    end
    --self:refreshTime(self.data.line)
    local idelTab = {}
    idelTab["num1"] = self.idleWorkerNum
    idelTab["num2"] = self.buildingMaxWorkerNum
    idelTab["col1"] = "red"
    idelTab["col2"] = "black"
    AdjustProductionLinePanel.idleNumberText.text = getColorString(idelTab)
end

function AdjustProductionLineCtrl:OnClick_returnBtn(go)
    --go:deleteTempTable();
    go:deleteObjInfo();
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
function AdjustProductionLineCtrl:Hide()
    Event.RemoveListener("calculateTime",self.calculateTime,self)
    Event.RemoveListener("refreshSubtractWorkerNum",self.refreshSubtractWorkerNum,self)
    --Event.RemoveListener("refreshTime",self.refreshTime,self)
    Event.RemoveListener("_deleteProductionLine",self._deleteProductionLine,self)
    Event.RemoveListener("refreshNowConte",self.refreshNowConte,self)
    Event.RemoveListener("callbackDataInfo",self.callbackDataInfo,self)
    UIPanel.Hide(self)
    return {insId = self.m_data.info.id,self.m_data}
end

function AdjustProductionLineCtrl:OnClick_addBtn(go)
    PlayMusEff(1002)
    if go.m_data.info.state == "OPERATE" then
        go:deleteTempTable()
        --go:deleteObjInfo();
        ct.OpenCtrl("AddProductionLineCtrl",go.m_data)
    else
        Event.Brocast("SmallPop",GetLanguage(35040013),300)
    end

end

--Calculate the total time of a production line
function AdjustProductionLineCtrl:calculateTime(msg)
    if not msg then
        return
    end
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if v.itemId == msg.line.itemId then
            --v.timeText.text = timeStr.
            v.goodsDataInfo = {}
            v.itemId = msg.line.itemId
            v.lineId = msg.line.id
            v.goodsDataInfo.workerNum = msg.line.workerNum
            v.goodsDataInfo.targetCount = msg.line.targetCount
            v.goodsDataInfo.nowCount = msg.line.nowCount
            v.timeText.text = v:getTimeNumber(msg.line)
            v.minText.text = v:getMinuteNum(msg.line)
        end
    end
end
--Calculate the output per minute of a line
function AdjustProductionLineCtrl:calculateMinuteNum(msg)
    local number = 0
    local materialKey,goodsKey = 21,22
    if math.floor(msg.line.itemId / 100000) == materialKey then
        number = Material[msg.line.itemId].numOneSec * msg.line.workerNum * 60
    elseif math.floor(msg.line.itemId / 100000) == goodsKey then
        number = Good[msg.line.itemId].numOneSec * msg.line.workerNum * 60
    end
    local numStr = math.floor(number).."/min"
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if v.itemId == msg.line.itemId then
            v.minText.text = numStr
        end
    end
end
--Delete production lines that are in production or finished
function AdjustProductionLineCtrl:_deleteProductionLine(msg)
    if not msg then
        return;
    end
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if v.buildingId == msg.buildingId and v.lineId == msg.lineId then
            if v.goodsDataInfo.workerNum ~= nil then
                self:refreshAddWorkerNum(v.goodsDataInfo.workerNum / 5)
            else
                self:refreshAddWorkerNum(0)
            end
            v:closeUpdate()
            destroy(v.prefab.gameObject);
            table.remove(AdjustProductionLineCtrl.materialProductionLine,i)
        end
    end
    if AdjustProductionLineCtrl.materialProductionLine == nil or AdjustProductionLineCtrl.materialProductionLine == {} then
        return
    end
    local i = 1
    for k,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        AdjustProductionLineCtrl.materialProductionLine[i]:RefreshID(i)
        i = i +1
    end
end
--Get the number of remaining employees
function AdjustProductionLineCtrl:getWorkerNum()
    local workerNum = 0  --Number of remaining employees
    local workNum = 0    --Number of employees working
    if not self.m_data.line then
        workerNum = self.buildingMaxWorkerNum
        return workerNum
    else
        for i,v in pairs(self.m_data.line) do
            workNum = workNum + v.workerNum
        end
        workerNum = self.buildingMaxWorkerNum - workNum
        return workerNum
    end
end
--Call back and refresh the remaining number of people after adding the production line successfully
function AdjustProductionLineCtrl:refreshSubtractWorkerNum(msg)
    self.idleWorkerNum = self.idleWorkerNum - msg.line.workerNum
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    local idelTab = {}
    idelTab["num1"] = self.idleWorkerNum
    idelTab["num2"] = self.buildingMaxWorkerNum
    idelTab["col1"] = "red"
    idelTab["col2"] = "black"
    AdjustProductionLinePanel.idleNumberText.text = getColorString(idelTab)
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        v.sNumberScrollbar.maxValue = v.sNumberScrollbar.value + AdjustProductionLineCtrl.idleWorkerNums / 5
    end
end
--After successfully deleting the production line, callback and refresh the remaining number
function AdjustProductionLineCtrl:refreshAddWorkerNum(number)
    self.idleWorkerNum = self.idleWorkerNum + number * 5
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    local idelTab = {}
    idelTab["num1"] = self.idleWorkerNum
    idelTab["num2"] = self.buildingMaxWorkerNum
    idelTab["col1"] = "red"
    idelTab["col2"] = "black"
    AdjustProductionLinePanel.idleNumberText.text = getColorString(idelTab)
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        v.sNumberScrollbar.maxValue = v.sNumberScrollbar.value + AdjustProductionLineCtrl.idleWorkerNums / 5
    end
end
--Add interface to get warehouse inventory quantity
function AdjustProductionLineCtrl.getGoodInventoryNum(itemId)
    if not itemId then
        return
    end
    if not AdjustProductionLineCtrl.store.inHand then
        local number = 0
        return number
    end
    for i,v in pairs(AdjustProductionLineCtrl.store.inHand) do
        if v.key.id == itemId then
            return v.n
        end
    end
        local number = 0
        return number
end
----Read production line, initialization time
--function AdjustProductionLineCtrl:refreshTime(infoTab)
--    if not infoTab then
--        return
--    end
--    for i,v in pairs(infoTab) do
--        local remainingNum = v.targetCount - v.nowCount
--        local materialKey,goodsKey = 21,22
--        local time = 0
--        if math.floor(v.itemId / 100000) == materialKey then
--            time = 1 / Material[v.itemId].numOneSec / v.workerNum * remainingNum
--        elseif math.floor(v.itemId / 100000) == goodsKey then
--            time = 1 / Good[v.itemId].numOneSec / v.workerNum * remainingNum
--        end
--        local timeTab = getTimeString(time)
--        if remainingNum > 0 then
--            AdjustProductionLineCtrl.materialProductionLine[i].timeText.text = timeTab
--        elseif remainingNum < 0 or remainingNum == 0 then
--            AdjustProductionLineCtrl.materialProductionLine[i].timeText.text = "00:00:00"
--        end
--    end
--end
--Receive callback to refresh output
function AdjustProductionLineCtrl:refreshNowConte(msg)
    if not msg then
        return;
    end
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if msg.id == v.lineId then
            if msg.nowCount ~= nil then
                v.time_Slider.value = msg.nowCount
            end
        end
    end
end
--Adjust the production line and adjust the number of employees
function AdjustProductionLineCtrl:callbackDataInfo(DataInfo)
    if not DataInfo then
        return
    end
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if DataInfo.lineId == v.lineId then
            if v.goodsDataInfo.workerNum < DataInfo.workerNum then
                local nowNum = DataInfo.workerNum - v.goodsDataInfo.workerNum
                self.idleWorkerNum = self.idleWorkerNum - nowNum
                local idelTab = {}
                idelTab["num1"] = self.idleWorkerNum
                idelTab["num2"] = self.buildingMaxWorkerNum
                idelTab["col1"] = "red"
                idelTab["col2"] = "black"
                AdjustProductionLinePanel.idleNumberText.text = getColorString(idelTab)
            elseif v.goodsDataInfo.workerNum > DataInfo.workerNum then
                local nowNum = v.goodsDataInfo.workerNum - DataInfo.workerNum
                self.idleWorkerNum = self.idleWorkerNum + nowNum
                local idelTab = {}
                idelTab["num1"] = self.idleWorkerNum
                idelTab["num2"] = self.buildingMaxWorkerNum
                idelTab["col1"] = "red"
                idelTab["col2"] = "black"
                AdjustProductionLinePanel.idleNumberText.text = getColorString(idelTab)
            end
            AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
            v:getRefreshTimeNumber(DataInfo)
            if DataInfo.lineId == v.lineId then
                if DataInfo.targetNum ~= nil then
                    v:RefreshUiItemInfo(DataInfo)
                end
            end
            for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
                v.sNumberScrollbar.maxValue = v.sNumberScrollbar.value + AdjustProductionLineCtrl.idleWorkerNums / 5
            end
        end
    end
end
--Clear the UI information when closing the panel in case other modules call
function AdjustProductionLineCtrl:deleteObjInfo()
    if not AdjustProductionLineCtrl.materialProductionLine or AdjustProductionLineCtrl.materialProductionLine == {} then
        return;
    else
        for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            v:closeUpdate()
            destroy(v.prefab.gameObject);
        end
        AdjustProductionLineCtrl.materialProductionLine = {};
    end
end
--Clean up temporary tables
function AdjustProductionLineCtrl:deleteTempTable()
    --Added but not produced
    if not AdjustProductionLineCtrl.materialProductionLine or AdjustProductionLineCtrl.materialProductionLine == {} then
        return
    else
        for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            if not v.lineId then
                destroy(v.prefab.gameObject)
                AdjustProductionLineCtrl.materialProductionLine[i] = nil;
            end
        end
    end
end

--Clear all changes to SmallProductionLineItem
function AdjustProductionLineCtrl.ClearOtherChangeState()
    if AdjustProductionLineCtrl.materialProductionLine ~= nil then
        for key, tempItem in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            if tempItem:GetChangeState() == true then
                tempItem.CloseAdjustmentTop(tempItem)
            end
        end
    end

end

function AdjustProductionLineCtrl.IsHaveNewLine()
    if AdjustProductionLineCtrl.materialProductionLine ~= nil then
        for key, tempItem in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            if tempItem.lineId == nil then
                return true
            end
        end
    end
    return false
end
