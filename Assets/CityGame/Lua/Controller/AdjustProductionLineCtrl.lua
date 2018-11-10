AdjustProductionLineCtrl = class('AdjustProductionLineCtrl',UIPage);

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
    local number,steffNumber,itemid = ShelfGoodsMgr:testSend()
    if tonumber(number) == 0 then
        ct.log("system","数量不能为0")
        return;
    end
    if tonumber(steffNumber) == 0 then
        ct.log("system","人数不能为0")
        return;
    end
    if tonumber(steffNumber) < 5 then
        ct.log("system","人数不足")
        return;
    end
    Event.Brocast("m_OnDetermineBtn",number,steffNumber,itemid);
end