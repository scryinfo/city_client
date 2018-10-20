local transform;
local gameObject;

AddTransportPanel = {};
local this = AddTransportPanel;

function AddTransportPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function AddTransportPanel.InitPanel()
    this.returnBtn = transform:Find("ReturnBtn").gameObject;
    this.confirmBtn = transform:Find("ConfirmBtn").gameObject;
end
function AddTransportPanel.OnDestroy()
    destroy(gameObject);
end