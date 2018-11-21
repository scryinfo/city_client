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
    ShelfGoodsMgr:_getProductionLine(self.m_data)
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

--确定生产
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
--修改
function AdjustProductionLineCtrl:OnClick_modifyBtn()
    --local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    --local number
    --Event.Brocast("m_ResModifyKLine");
end