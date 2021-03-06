local transform;
local gameObject;

AdjustProductionLinePanel = {};
local this = AdjustProductionLinePanel;

--Start event
function AdjustProductionLinePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
--Initialize the panel
function AdjustProductionLinePanel.InitPanel()
    --Button
    this.returnBtn = transform:Find("Button/returnBtn");
    --this.determineBtn = transform:Find("Button/determineBtn");
    this.addBtn = transform:Find("ScrollView/Viewport/Content/productionLineAdd");
    --Slider --Text
    this.capacity_Slider = transform:Find("bg/Topbg01/Capacity_Slider"):GetComponent("Slider");
    this.locked_Slider = transform:Find("bg/Topbg01/Locked_Slider"):GetComponent("Slider")
    this.numberText = transform:Find("bg/Topbg01/numberText"):GetComponent("Text");
    this.Capacity = transform:Find("bg/Topbg01/Capacity"):GetComponent("Text");
    --idle
    this.idleNumberText = transform:Find("bg/Topbg01/Staffbg/numberText"):GetComponent("Text");
    this.nameText = transform:Find("bg/Topbg/nameText"):GetComponent("Text");
    this.idleText = transform:Find("bg/Topbg01/Staffbg/idle"):GetComponent("Text");
    --Scroll View
    this.content = transform:Find("ScrollView/Viewport/Content").gameObject;

end
function AdjustProductionLinePanel.OnDestroy()
    logWarn("OnDestroy AdjustProductionLinePanel--->>>");
end