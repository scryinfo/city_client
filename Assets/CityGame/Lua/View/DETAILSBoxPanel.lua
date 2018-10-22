local transform;
local gameObject;

DETAILSBoxPanel = {};
local this = DETAILSBoxPanel;

function DETAILSBoxPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function DETAILSBoxPanel.InitPanel()
    this.XBtn = transform:Find("XBtn");
    this.confirmBtn = transform:Find("confirmBtn");
end