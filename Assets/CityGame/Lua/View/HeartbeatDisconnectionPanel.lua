local transform;
local gameObject;

HeartbeatDisconnectionPanel = {};
local this = HeartbeatDisconnectionPanel;


--Start event--
function HeartbeatDisconnectionPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--Initialize the panel--
function HeartbeatDisconnectionPanel.InitPanel()
    this.moveIcon = transform:Find("signal/moveIcon")
    this.Tipstext = transform:Find("Text"):GetComponent("Text")
end


