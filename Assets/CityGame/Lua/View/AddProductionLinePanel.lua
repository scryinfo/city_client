local transform
AddProductionLinePanel = {}
local this = AddProductionLinePanel

function AddProductionLinePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function AddProductionLinePanel.InitPanel()
    this.returnBtn = transform:Find("Button/returnBtn")
    this.leftBtnParent = transform:Find("leftBtnParent"):GetComponent("RectTransform")
    this.leftBtn = transform:Find("leftBtnParent/leftBtn")
    this.leftDisableImg = transform:Find("leftBtnParent/disableImg")
    this.rightBtnParent = transform:Find("rightBtnParent"):GetComponent("RectTransform")
    this.rightBtn = transform:Find("rightBtnParent/rightBtn"):GetComponent("Button")
    this.rightDisableImg = transform:Find("rightBtnParent/disableImg")
    this.leftInfo = transform:Find("leftInfo")
    this.rightInfo = transform:Find("rightInfo")
    this.hLine = transform:Find("centerRoot/lineRoot/hLine")
    this.vLine = transform:Find("centerRoot/lineRoot/vLine")
    this._getCenterItems(transform:Find("centerRoot/itemRoot"))

    this.leftToggleMgr = AddProductionLineMgr:new(this.leftInfo, AddLineButtonPosValue.Left)
    this.rightToggleMgr = AddProductionLineMgr:new(this.rightInfo, AddLineButtonPosValue.Right)
end

function AddProductionLinePanel._getCenterItems(viewTran)
    this.centerItems = {}
    local childCount = viewTran.childCount - 1
    for i = 0, childCount - 1 do
        local tran = viewTran:Find("item0"..i + 1)
        this.centerItems[#this.centerItems + 1] = AddDetailItem:new(tran)
    end
    this.productionItem = AddDetailItem:new(viewTran:Find("productionItem"))
end




--[[local transform;
local gameObject;

AddProductionLinePanel = {}
local this = AddProductionLinePanel;

--启动事件
function AddProductionLinePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
--初始化面板
function AddProductionLinePanel.InitPanel()
    this.returnBtn = transform:Find("Button/returnBtn");
    this.findBtn = transform:Find("Button/findBtn");
    this.content = transform:Find("classificationbg/ScrollView/Viewport/Content");
    this.determineBtn = transform:Find("Button/determineBtn");

    this.foodBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/foodBtn"):GetComponent("Toggle");
    this.viceFoodBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/viceFoodBtn"):GetComponent("Toggle");
    this.dressBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/dressBtn"):GetComponent("Toggle");
    this.foodMaterBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/foodMaterBtn"):GetComponent("Toggle");
    this.baseMaterBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/baseMaterBtn"):GetComponent("Toggle");
    this.advancedMaterBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/advancedMaterBtn"):GetComponent("Toggle");
    this.otherBtn = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/otherBtn"):GetComponent("Toggle");

end]]
