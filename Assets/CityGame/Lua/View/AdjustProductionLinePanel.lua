local transform;
local gameObject;

AdjustProductionLinePanel = {};
local this = AdjustProductionLinePanel;

--启动事件
function AdjustProductionLinePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
--初始化面板
function AdjustProductionLinePanel.InitPanel()
    --Button
    this.returnBtn = transform:Find("Button/returnBtn");
    --this.determineBtn = transform:Find("Button/determineBtn");
    this.addBtn = transform:Find("ScrollView/Viewport/Content/productionLineAdd");
    --Slider --Text
    this.capacity_Slider = transform:Find("bg/Topbg01/Capacity_Slider"):GetComponent("Slider");
    this.numberText = transform:Find("bg/Topbg01/numberText"):GetComponent("Text");

    --idle
    this.idleNumberText = transform:Find("bg/Topbg01/Staffbg/numberText"):GetComponent("Text");
    --Scroll View
    this.content = transform:Find("ScrollView/Viewport/Content").gameObject;

end
function AdjustProductionLinePanel.OnDestroy()
    logWarn("OnDestroy AdjustProductionLinePanel--->>>");
end