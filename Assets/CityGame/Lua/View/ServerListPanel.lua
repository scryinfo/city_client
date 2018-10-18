local transform;
local gameObject;

ServerListPanel = {};
local this = ServerListPanel;


--启动事件--
function ServerListPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function ServerListPanel.InitPanel()
    this.serverOneBtn = transform:Find("LeftServerList/ServerOneButton").gameObject;
    this.serverOneText = transform:Find("LeftServerList/ServerOneButton/ServerOneText").gameObject;
    this.serverTwoBtn = transform:Find("LeftServerList/ServerTwoButton").gameObject;
    this.serverTwoText = transform:Find("LeftServerList/ServerTwoButton/ServerTwoText").gameObject;

    this.oKBtn = transform:Find("RightDownButton/OKButton").gameObject;
    this.serverText = transform:Find("RightDownButton/ServerText").gameObject;
end
