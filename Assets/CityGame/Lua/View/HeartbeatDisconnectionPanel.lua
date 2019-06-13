local transform;
local gameObject;

HeartbeatDisconnectionPanel = {};
local this = HeartbeatDisconnectionPanel;


--启动事件--
function HeartbeatDisconnectionPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--初始化面板--
function HeartbeatDisconnectionPanel.InitPanel()
    this.moveIcon = transform:Find("signal/moveIcon")
    this.Tipstext = transform:Find("Text"):GetComponent("Text")
end


