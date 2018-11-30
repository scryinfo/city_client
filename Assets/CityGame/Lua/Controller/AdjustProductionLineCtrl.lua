AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AdjustProductionLineCtrl) --注册打开的方法

--实例
AdjustProductionLineCtrl.productionLineTab = {};
--UI信息
AdjustProductionLineCtrl.productionLineUIInfo = {};
--预制
AdjustProductionLineCtrl.productionLinePrefab = {};
AdjustProductionLineCtrl.idleWorkerNums = 0
function AdjustProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AdjustProductionLineCtrl:bundleName()
    return "AdjustProductionLinePanel"
end

function AdjustProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local adjustLine = self.gameObject:GetComponent('LuaBehaviour')
    adjustLine:AddClick(AdjustProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.addBtn.gameObject,self.OnClick_addBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.determineBtn.gameObject,self.OnClick_determineBtn,self);
    adjustLine:AddClick(AdjustProductionLinePanel.modifyBtn.gameObject,self.OnClick_modifyBtn,self);



    Event.AddListener("calculateTime",self.calculateTime,self)
    Event.AddListener("refreshIdleWorkerNum",self.refreshIdleWorkerNum,self)
    Event.AddListener("refreshTime",self.refreshTime,self)
    self.buildingMaxWorkerNum = PlayerBuildingBaseData[MaterialModel.buildingCode].maxWorkerNum
    self.idleWorkerNum = self:getWorkerNum()
    AdjustProductionLineCtrl.idleWorkerNums = self.idleWorkerNum
    --读取服务器发过来的信息，是否有生产线
    ShelfGoodsMgr:_getProductionLine(self.m_data,adjustLine)
    Event.Brocast("refreshTime",self.m_data)
    AdjustProductionLinePanel.idleNumberText.text = getColorString(self.idleWorkerNum,self.buildingMaxWorkerNum,"red","black")
end

function AdjustProductionLineCtrl:Awake(go)
    self.gameObject = go
end

function AdjustProductionLineCtrl:Refresh()
    local itemId = PlayerTempModel.roleData.buys.materialFactory[1].info.mId
    self:refreshWorkerNum()
    AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[itemId].storeCapacity;
    AdjustProductionLinePanel.capacity_Slider.value = WarehouseCtrl:getNumber(MaterialModel.MaterialWarehouse);
    AdjustProductionLinePanel.numberText.text = getColorString(AdjustProductionLinePanel.capacity_Slider.value,AdjustProductionLinePanel.capacity_Slider.maxValue,"blue","black")

end

function AdjustProductionLineCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end

function AdjustProductionLineCtrl:OnClick_addBtn()
    ct.OpenCtrl("AddProductionLineCtrl")
end
--计算一条生产线总时间
function AdjustProductionLineCtrl:calculateTime(msg)
    local time = 1 / Material[msg.itemId].numOneSec / msg.workerNum * msg.targetCount
    local timeTab = AdjustProductionLineCtrl:formattingTime(time)
    ShelfGoodsMgr.sendInfoTempTab[msg.itemId].timeText.text = timeTab
    ShelfGoodsMgr.sendInfoTempTab = nil
end

--添加生产线
function AdjustProductionLineCtrl:OnClick_determineBtn()
    --local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    local number,steffNumber,itemid = ShelfGoodsMgr:getSendInfo()
    if number == nil then
        ct.log("system","数量不能为0")
        return;
    end
    if steffNumber == nil then
        ct.log("system","人数不能为0")
        return;
    end
    if tonumber(steffNumber) < 5 then
        ct.log("system","人数不足")
        return;
    end
    Event.Brocast("m_ReqAddLine",MaterialModel.buildingId,number,steffNumber,itemid);
end
--修改生产线
function AdjustProductionLineCtrl:OnClick_modifyBtn()
    --local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    Event.Brocast("m_ResModifyKLine",MaterialModel.buildingId,SmallProductionLineItem.number,SmallProductionLineItem.staffNumr,SmallProductionLineItem.lineid);
end

--格式化时分秒  00:00:00
function AdjustProductionLineCtrl:formattingTime(time)
    if time < 0 then
        return;
    end
    local hour,minute,second = 0,0,0
    second = time % 60
    minute = time / 60
    if minute > 60 then
        hour = minute / 60
        minute = minute % 60
    end
    hour,minute,second = math.floor(hour),math.floor(minute),math.ceil(second)
    if #tostring(hour) == 1 then
        hour = "0"..hour
    end
    if #tostring(minute) == 1 then
        minute = "0"..minute
    end
    if #tostring(second) == 1 then
        second = "0"..second
    end
    return hour..":"..minute..":"..second
end
--获取剩余员工人数
function AdjustProductionLineCtrl:getWorkerNum()
    local workerNum = 0  --剩余员工数量
    local workNum = 0    --工作的员工数量
    if not MaterialModel.MaterialProductionLine then
        workerNum = self.buildingMaxWorkerNum
        return workerNum
    else
        for i,v in pairs(MaterialModel.MaterialProductionLine) do
            workNum = workNum + v.workerNum
        end
        workerNum = self.buildingMaxWorkerNum - workNum
        return workerNum
    end
end
--刷新一条线可用的员工数量
function AdjustProductionLineCtrl:refreshWorkerNum()
    for i,v in pairs(AdjustProductionLineCtrl.productionLineTab) do
        v.sNumberScrollbar.maxValue = self.idleWorkerNum
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
        local timeTab = AdjustProductionLineCtrl:formattingTime(time)
        if remainingNum > 0 then
            AdjustProductionLineCtrl.productionLineTab[i].timeText.text = timeTab
        elseif remainingNum < 0 or remainingNum == 0 then
            AdjustProductionLineCtrl.productionLineTab[i].timeText.text = "00:00:00"
        end
    end
end