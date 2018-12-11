AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AdjustProductionLineCtrl) --注册打开的方法

--原料厂实例
AdjustProductionLineCtrl.materialProductionLine = {};
--原料厂UI信息
AdjustProductionLineCtrl.materialProductionUIInfo = {};
--原料厂预制
AdjustProductionLineCtrl.materialProductionPrefab = {};
--添加生产线临时表
AdjustProductionLineCtrl.tempProductionLine = {}

----加工厂实例
--AdjustProductionLineCtrl.materialProductionLine = {};
----加工厂UI信息
--AdjustProductionLineCtrl.materialProductionUIInfo = {};
----加工厂预制
--AdjustProductionLineCtrl.materialProductionPrefab = {};

AdjustProductionLineCtrl.idleWorkerNums = 0
local adjustLine
function AdjustProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AdjustProductionLineCtrl:bundleName()
    return "AdjustProductionLinePanel"
end

function AdjustProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);

    adjustLine:AddClick(AdjustProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.addBtn.gameObject,self.OnClick_addBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.determineBtn.gameObject,self.OnClick_determineBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.modifyBtn.gameObject,self.OnClick_modifyBtn,self);

    Event.AddListener("calculateTime",self.calculateTime,self)
    Event.AddListener("refreshIdleWorkerNum",self.refreshIdleWorkerNum,self)
    Event.AddListener("refreshTime",self.refreshTime,self)
    --self.buildingMaxWorkerNum = PlayerBuildingBaseData[MaterialModel.buildingCode].maxWorkerNum
    --self.idleWorkerNum = self:getWorkerNum()
    --AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    ----读取服务器发过来的信息，是否有生产线
    --GoodsUnifyMgr:_getProductionLine(self.data,self.adjustLine)
    --Event.Brocast("refreshTime",self.data.dataTab)
    --AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")
end

function AdjustProductionLineCtrl:Awake(go)
    self.gameObject = go

end

function AdjustProductionLineCtrl:Refresh()
    if self.m_data ~= nil then
        self.data = self.m_data
    end
    adjustLine = self.gameObject:GetComponent('LuaBehaviour')
    if self.data.buildingType == BuildingType.MaterialFactory then
        self.buildingMaxWorkerNum = PlayerBuildingBaseData[MaterialModel.buildingCode].maxWorkerNum
        AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[MaterialModel.buildingCode].storeCapacity;
        AdjustProductionLinePanel.capacity_Slider.value = WarehouseCtrl:getWarehouseCapacity(MaterialModel.materialWarehouse);
        AdjustProductionLinePanel.numberText.text = getColorString(AdjustProductionLinePanel.capacity_Slider.value,AdjustProductionLinePanel.capacity_Slider.maxValue,"blue","black")
    elseif self.data.buildingType == BuildingType.ProcessingFactory then
        self.buildingMaxWorkerNum = PlayerBuildingBaseData[ProcessingModel.buildingCode].maxWorkerNum
        AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[ProcessingModel.buildingCode].storeCapacity;
        AdjustProductionLinePanel.capacity_Slider.value = WarehouseCtrl:getWarehouseCapacity(ProcessingModel.processingWarehouse);
        AdjustProductionLinePanel.numberText.text = getColorString(AdjustProductionLinePanel.capacity_Slider.value,AdjustProductionLinePanel.capacity_Slider.maxValue,"blue","black")
    end
    self.idleWorkerNum = self:getWorkerNum()
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    --读取服务器发过来的信息，是否有生产线
    GoodsUnifyMgr:_getProductionLine(self.data,adjustLine)
    Event.Brocast("refreshTime",self.data.dataTab)
    AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")

    --local itemId = MaterialModel.buildingCode
    self:refreshWorkerNum()
    --AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[MaterialModel.buildingCode].storeCapacity;
    --AdjustProductionLinePanel.capacity_Slider.value = WarehouseCtrl:getWarehouseCapacity(MaterialModel.materialWarehouse);
    --AdjustProductionLinePanel.numberText.text = getColorString(AdjustProductionLinePanel.capacity_Slider.value,AdjustProductionLinePanel.capacity_Slider.maxValue,"blue","black")

end

function AdjustProductionLineCtrl:OnClick_returnBtn(go)
    go:deleteObjInfo()
    UIPage.ClosePage();
end

function AdjustProductionLineCtrl:OnClick_addBtn(go)
    go:deleteObjInfo()
    ct.OpenCtrl("AddProductionLineCtrl",go.m_data)
end

--计算一条生产线总时间
function AdjustProductionLineCtrl:calculateTime(msg)
    local time = 1 / Material[msg.itemId].numOneSec / msg.workerNum * msg.targetCount
    local timeTab = getTimeString(time)
    GoodsUnifyMgr.sendInfoTempTab[msg.itemId].timeText.text = timeTab
    GoodsUnifyMgr.sendInfoTempTab = nil
end

--添加生产线
function AdjustProductionLineCtrl:OnClick_determineBtn()
    local number,steffNumber,itemid = GoodsUnifyMgr:getSendInfo()
    if number == "0" then
        Event.Brocast("SmallPop","目标产量不能为0",300)
        return;
    end
    if steffNumber == "0" then
        Event.Brocast("SmallPop","员工人数不能为0",300)
        return;
    end
    if tonumber(steffNumber) < 5 then
        Event.Brocast("SmallPop","员工人数不足",300)
        return;
    end
    Event.Brocast("m_ReqAddLine",MaterialModel.buildingId,number,steffNumber,itemid);
end
--修改生产线
function AdjustProductionLineCtrl:OnClick_modifyBtn()
    Event.Brocast("m_ResModifyKLine",MaterialModel.buildingId,SmallProductionLineItem.number,SmallProductionLineItem.staffNumr,SmallProductionLineItem.lineid);
end
--获取剩余员工人数
function AdjustProductionLineCtrl:getWorkerNum()
    local workerNum = 0  --剩余员工数量
    local workNum = 0    --工作的员工数量
    if self.data.buildingType == BuildingType.MaterialFactory then
        if not MaterialModel.materialProductionLine then
            workerNum = self.buildingMaxWorkerNum
            return workerNum
        else
            for i,v in pairs(MaterialModel.materialProductionLine) do
                workNum = workNum + v.workerNum
            end
            workerNum = self.buildingMaxWorkerNum - workNum
            return workerNum
        end
    elseif self.data.buildingType == BuildingType.ProcessingFactory then
        if not ProcessingModel.processingProductionLine then
            workerNum = self.buildingMaxWorkerNum
            return workerNum
        else
            for i,v in pairs(ProcessingModel.processingProductionLine) do
                workNum = workNum + v.workerNum
            end
            workerNum = self.buildingMaxWorkerNum - workNum
            return workerNum
        end
    end

end
--刷新一条线可用的员工数量
function AdjustProductionLineCtrl:refreshWorkerNum()
    if not AdjustProductionLineCtrl.materialProductionLine then
        return;
    else
        for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            v.sNumberScrollbar.maxValue = self.idleWorkerNum
        end
    end
end
--添加生产线成功后回调刷新剩余人数
function AdjustProductionLineCtrl:refreshIdleWorkerNum(msg)
    self.idleWorkerNum = self.idleWorkerNum - msg.workerNum
    AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")
end
--读取生产线，初始化时间
function AdjustProductionLineCtrl:refreshTime(infoTab)
    if not infoTab then
        return
    end
    for i,v in pairs(infoTab) do
        local remainingNum = v.targetCount - v.nowCount
        local time = 1 / Material[v.itemId].numOneSec / v.workerNum * remainingNum
        local timeTab = getTimeString(time)
        if remainingNum > 0 then
            AdjustProductionLineCtrl.materialProductionLine[i].timeText.text = timeTab
        elseif remainingNum < 0 or remainingNum == 0 then
            AdjustProductionLineCtrl.materialProductionLine[i].timeText.text = "00:00:00"
        end
    end
end
--关闭面板时清空UI信息，以备其他模块调用
function AdjustProductionLineCtrl:deleteObjInfo()
    if not AdjustProductionLineCtrl.materialProductionLine then
        return;
    else
        for i,v in pairs(AdjustProductionLineCtrl.materialProductionLine) do
            destroy(v.prefab.gameObject);
        end
        AdjustProductionLineCtrl.materialProductionLine = {};
        AdjustProductionLineCtrl.materialProductionUIInfo = {};
        AdjustProductionLineCtrl.materialProductionPrefab = {};
    end
end