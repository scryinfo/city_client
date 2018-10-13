local transform;
local gameObject;

TransportPanel = {};
local this = TransportPanel;

function TransportPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua TransportPanel--->>>"..gameObject.name);
end
function TransportPanel.InitPanel()
    this.addBtn = transform:Find("AddBtn").gameObject;
    this.content = transform:Find("Scroll View/Viewport/Content").gameObject;
end
function TransportPanel.OnDestroy()
    logWarn("OnDestroy TransportPanel--->>>");
end