AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AdjustProductionLineCtrl) --注册打开的方法

--原料厂实例
AdjustProductionLineCtrl.materialProductionLine = {};
--添加生产线临时表
AdjustProductionLineCtrl.tempProductionLine = {}

AdjustProductionLineCtrl.idleWorkerNums = 0
local adjustLine
function AdjustProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AdjustProductionLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AdjustProductionLinePanel.prefab"
end

function AdjustProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);

    adjustLine:AddClick(AdjustProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.addBtn.gameObject,self.OnClick_addBtn,self);
    --adjustLine:AddClick(AdjustProductionLinePanel.determineBtn.gameObject,self.OnClick_determineBtn,self);
    Event.AddListener("calculateTime",self.calculateTime,self)
    Event.AddListener("refreshSubtractWorkerNum",self.refreshSubtractWorkerNum,self)
    --Event.AddListener("refreshTime",self.refreshTime,self)
    Event.AddListener("_deleteProductionLine",self._deleteProductionLine,self)
    Event.AddListener("refreshNowConte",self.refreshNowConte,self)
end

function AdjustProductionLineCtrl:Awake(go)
    self.gameObject = go
end

function AdjustProductionLineCtrl:Refresh()
    if self.m_data ~= nil then
        self.data = self.m_data
    end
    adjustLine = self.gameObject:GetComponent('LuaBehaviour')
    self.luabehaviour = adjustLine
    AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[self.data.info.mId].storeCapacity;
    AdjustProductionLinePanel.capacity_Slider.value = WarehouseCtrl:getWarehouseCapacity(self.data.store);
    AdjustProductionLinePanel.numberText.text = getColorString(AdjustProductionLinePanel.capacity_Slider.value,AdjustProductionLinePanel.capacity_Slider.maxValue,"blue","black")
    --剩余容量
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
    AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")
end

function AdjustProductionLineCtrl:OnClick_returnBtn(go)
    go:deleteObjInfo();
    --go:deleteTempTable();
    UIPage.ClosePage();
end
function AdjustProductionLineCtrl:Hide()
    UIPage.Hide(self)
    return {insId = self.m_data.info.id}
end

function AdjustProductionLineCtrl:OnClick_addBtn(go)
    ct.OpenCtrl("AddProductionLineCtrl",go.m_data)
end

--计算一条生产线总时间
function AdjustProductionLineCtrl:calculateTime(msg)
    if not msg then
        return
    end
    local materialKey,goodsKey = 21,22
    local time = 0
    if math.floor(msg.line.itemId / 100000) == materialKey then
        time = 1 / Material[msg.line.itemId].numOneSec / msg.line.workerNum * msg.line.targetCount
    elseif math.floor(msg.line.itemId / 100000) == goodsKey then
        time = 1 / Good[msg.line.itemId].numOneSec / msg.line.workerNum * msg.line.targetCount
    end
    local timeTab = getTimeBySec(time)
    local timeStr = timeTab.hour..":"..timeTab.minute..":"..timeTab.second
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if v.itemId == msg.line.itemId then
            v.timeText.text = timeStr
        end
    end
end
--计算一条线每分钟的产量
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
----修改生产线
--function AdjustProductionLineCtrl:OnClick_modifyBtn()
--    Event.Brocast("m_ResModifyKLine",ins.data.info.id,SmallProductionLineItem.number,SmallProductionLineItem.staffNumr,SmallProductionLineItem.lineid);
--end
--删除生产中或生产完的生产线
function AdjustProductionLineCtrl:_deleteProductionLine(msg)
    if not msg then
        return;
    end
    for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if v.buildingId == msg.buildingId and v.lineId == msg.lineId then
            self:refreshAddWorkerNum(tonumber(v.sNumberScrollbar.value))
            destroy(v.prefab.gameObject);
            table.remove(AdjustProductionLineCtrl.materialProductionLine,i)
        end
    end
    local i = 1
    for k,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        AdjustProductionLineCtrl.materialProductionLine[i]:RefreshID(i)
        i = i +1
    end
end
--获取剩余员工人数
function AdjustProductionLineCtrl:getWorkerNum()
    local workerNum = 0  --剩余员工数量
    local workNum = 0    --工作的员工数量
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
--添加生产线成功后回调刷新剩余人数
function AdjustProductionLineCtrl:refreshSubtractWorkerNum(msg)
    self.idleWorkerNum = self.idleWorkerNum - msg.line.workerNum
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")
end
--删除生产线成功后回调刷新剩余人数
function AdjustProductionLineCtrl:refreshAddWorkerNum(number)
    self.idleWorkerNum = self.idleWorkerNum + number * 5
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")
end
--添加界面获取仓库库存数量
function AdjustProductionLineCtrl.getGoodInventoryNum(itemId)
    if itemId then
        if AdjustProductionLineCtrl.store then
            if AdjustProductionLineCtrl.store.inHand == nil then
                local num = 0
                return num
            end
            for i,v in pairs(AdjustProductionLineCtrl.store.inHand) do
                if v.key.id == itemId then
                    return v.n
                else
                    local num = 0
                    return num
                end
            end
        else
            local num = 0
            return num
        end
    end
end
----读取生产线，初始化时间
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
--接收回调刷新产量
function AdjustProductionLineCtrl:refreshNowConte(msg)
    if not msg then
        return;
    end
    for i,k in pairs(AdjustProductionLineCtrl.materialProductionLine) do
        if msg.id == k.lineId then
            --local remainingNum = k.inputNumber.text - msg.nowCount
            k.time_Slider.value = msg.nowCount
        end
    end
end
--关闭面板时清空UI信息，以备其他模块调用
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
--清理临时表
function AdjustProductionLineCtrl:deleteTempTable()
    --添加了但是没有生产的
    if not GoodsUnifyMgr.tempLineItem or GoodsUnifyMgr.tempLineItem == nil then
        return;
    else
        for i,v in pairs(GoodsUnifyMgr.tempLineItem) do
            destroy(v.prefab.gameObject)
        end
        --GoodsUnifyMgr.tempLineUIInfo = {};
        --GoodsUnifyMgr.tempLinePrefab = {};
        GoodsUnifyMgr.tempLineItem = {};
    end
end