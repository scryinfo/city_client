AddProductionLineCtrl = class('AddProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AddProductionLineCtrl)

--UI信息
AddProductionLineCtrl.productionItemTab = {};
--用来判断这个物体是否选中
AddProductionLineCtrl.temporaryIdTable = {}

function AddProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AddProductionLineCtrl:bundleName()
    return "AddProductionLinePanel"
end

function AddProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local addLine = self.gameObject:GetComponent('LuaBehaviour');

    self.luabehaviour = addLine
    self.m_data = {}
    self.m_data.buildingType = BuildingInType.ProductionLine;
    self.ShelfGoodsMgr = ShelfGoodsMgr:new(self.luabehaviour,self.m_data);


    addLine:AddClick(AddProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    addLine:AddClick(AddProductionLinePanel.determineBtn.gameObject,self.OnClick_determineBtn,self);

    --本地事件注册
    Event.AddListener("_selectedProductionLine",self._selectedProductionLine,self);


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

--选中生产的原料或商品
function AddProductionLineCtrl:_selectedProductionLine(id,itemId,name)
    if self.temporaryIdTable[id] == nil then
        self.temporaryIdTable[id] = id;
        self.itemId = itemId;
        self.name = name;
        self.ShelfGoodsMgr.productionItems[id].selectedImg.transform.localScale = Vector3.one
    else
        self.temporaryIdTable[id] = nil;
        self.ShelfGoodsMgr.productionItems[id].selectedImg.transform.localScale = Vector3.zero
    end
end

function AddProductionLineCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--确定
function AddProductionLineCtrl:OnClick_determineBtn(go)
    go.ShelfGoodsMgr:_creatProductionLine(go.name,go.itemId);
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