local transform;
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


    --this.leftBtnGroup = {};
    --this.leftBtnGroup[1] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/foodBtn"):GetComponent("Toggle");
    --this.leftBtnGroup[2] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/viceFoodBtn"):GetComponent("Toggle");
    --this.leftBtnGroup[3] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/dressBtn"):GetComponent("Toggle");
    --this.leftBtnGroup[4] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/foodMaterBtn"):GetComponent("Toggle");
    --this.leftBtnGroup[5] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/baseMaterBtn"):GetComponent("Toggle");
    --this.leftBtnGroup[6] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/advancedMaterBtn"):GetComponent("Toggle");
    --this.leftBtnGroup[7] = transform:Find("leftInfoBtn/bg/ScrollView/Viewport/Content/otherBtn"):GetComponent("Toggle");
end
