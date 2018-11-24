AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AdjustProductionLineCtrl) --注册打开的方法

--实例
AdjustProductionLineCtrl.productionLineTab = {};
--UI信息
AdjustProductionLineCtrl.productionLineUIInfo = {};
--预制
AdjustProductionLineCtrl.productionLinePrefab = {};
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


    --读取服务器发过来的信息，是否有生产线
    ShelfGoodsMgr:_getProductionLine(self.m_data,adjustLine)
    Event.AddListener("calculateTime",self.calculateTime,self)

end

function AdjustProductionLineCtrl:Awake(go)
    self.gameObject = go
end

function AdjustProductionLineCtrl:Refresh()
    local itemId = PlayerTempModel.roleData.buys.materialFactory[1].info.mId
    AdjustProductionLinePanel.capacity_Slider.value = 0;
    AdjustProductionLinePanel.capacity_Slider.maxValue = PlayerBuildingBaseData[itemId].storeCapacity;
    AdjustProductionLinePanel.numberText.text = AdjustProductionLinePanel.capacity_Slider.value.."/<color=black>"..AdjustProductionLinePanel.capacity_Slider.maxValue.."</color>"
    --AdjustProductionLinePanel.numberText.text = AdjustProductionLinePanel.capacity_Slider.maxValue
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
    for i,v in pairs(AdjustProductionLineCtrl.productionLineTab) do
        if v.itemId == msg.itemId then
            v.timeText.text = timeTab
        end
    end
end

--添加生产线
function AdjustProductionLineCtrl:OnClick_determineBtn()
    local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
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
    Event.Brocast("m_ReqDetermineBtn",buildingId,number,steffNumber,itemid);
end
--修改生产线
function AdjustProductionLineCtrl:OnClick_modifyBtn()
    local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    Event.Brocast("m_ResModifyKLine",buildingId,SmallProductionLineItem.number,SmallProductionLineItem.staffNumr,SmallProductionLineItem.lineid);
end

--格式化时分秒  00:00:00
function AdjustProductionLineCtrl:formattingTime(time)
    local hour,minute,second = 0,0,0
    second = time%60
    minute = time/60
    if minute > 60 then
        hour = minute/60
        minute = minute%60
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