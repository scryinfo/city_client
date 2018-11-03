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
    this.serverOneBtn = transform:Find("LeftServerList/Scroll View/Viewport/Content/ServerOneButton").gameObject;
    this.serverOneText = transform:Find("LeftServerList/Scroll View/Viewport/Content/ServerOneButton/ServerOneText").gameObject;
    this.serverTwoBtn = transform:Find("LeftServerList/Scroll View/Viewport/Content/ServerTwoButton").gameObject;
    this.serverTwoText = transform:Find("LeftServerList/Scroll View/Viewport/Content/ServerTwoButton/ServerTwoText").gameObject;

    this.oKBtn = transform:Find("RightDownButton/OKButton").gameObject;
    this.serverText = transform:Find("RightDownButton/ServerText").gameObject;
end
