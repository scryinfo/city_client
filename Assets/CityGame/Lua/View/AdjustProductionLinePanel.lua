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
    this.returnBtn = transform:Find("Button/ReturnBtn").gameObject;
    this.addBtn = transform:Find("Button/AddBtn").gameObject;
    --Slider --Text
    this.capacity_Slider = transform:Find("bg/Topbg01/Capacity_Slider").gameObject;
    this.numberText = transform:Find("bg/Topbg01/numberText").gameObject;
    --idle
    this.idleNumberText = transform:Find("bg/Topbg01/Staffbg/numberText").gameObject;
    --Scroll View
    this.content = transform:Find("Scroll View/Viewport/Content").gameObject;
end
function AdjustProductionLinePanel.OnDestroy()
    logWarn("OnDestroy AdjustProductionLinePanel--->>>");
end