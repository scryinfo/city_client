AddProductionLineCtrl = class('AddProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AddProductionLineCtrl)

function AddProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AddProductionLineCtrl:bundleName()
    return "AddProductionLine"
end

function AddProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local addLine = self.gameObject:GetComponent('LuaBehaviour');
    addLine:AddClick(AddProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);

    AddProductionLinePanel.foodBtn.onValueChanged:AddListener(function()
        self:OnClick_foodBtn();
    end)

    AddProductionLinePanel.viceFoodBtn.onValueChanged:AddListener(function()
        self:OnClick_viceFoodBtn();
    end)

    AddProductionLinePanel.dressBtn.onValueChanged:AddListener(function()
        self:OnClick_dressBtn();
    end)

    AddProductionLinePanel.foodMaterBtn.onValueChanged:AddListener(function()
        self:OnClick_foodMaterBtn();
    end)

    AddProductionLinePanel.baseMaterBtn.onValueChanged:AddListener(function()
        self:OnClick_baseMaterBtn();
    end)

    AddProductionLinePanel.advancedMaterBtn.onValueChanged:AddListener(function()
        self:OnClick_advancedMaterBtn();
    end)

    AddProductionLinePanel.otherBtn.onValueChanged:AddListener(function()
        self:OnClick_otherBtn();
    end)
end

function AddProductionLineCtrl:Awake(go)
    self.gameObject = go;
end

function AddProductionLineCtrl:Refesh()

end

function AddProductionLineCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end

function AddProductionLineCtrl:OnClick_foodBtn()
    if AddProductionLinePanel.foodBtn.isOn == true then
        logWarn("foodBtn")
    end
end

function AddProductionLineCtrl:OnClick_viceFoodBtn()
    if AddProductionLinePanel.viceFoodBtn.isOn == true then
        logWarn("viceFoodBtn")
    end
end

function AddProductionLineCtrl:OnClick_dressBtn()
    if AddProductionLinePanel.dressBtn.isOn == true then
        logWarn("dressBtn")
    end
end

function AddProductionLineCtrl:OnClick_foodMaterBtn()
    if AddProductionLinePanel.foodMaterBtn.isOn == true then
        logWarn("foodMaterBtn")
    end
end

function AddProductionLineCtrl:OnClick_baseMaterBtn()
    if AddProductionLinePanel.baseMaterBtn.isOn == true then
        logWarn("baseMaterBtn")
    end
end

function AddProductionLineCtrl:OnClick_advancedMaterBtn()
    if AddProductionLinePanel.advancedMaterBtn.isOn == true then
        logWarn("advancedMaterBtn")
    end
end

function AddProductionLineCtrl:OnClick_otherBtn()
    if AddProductionLinePanel.otherBtn.isOn == true then
        logWarn("otherBtn")
    end
end