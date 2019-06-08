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
    this.content = transform:Find("LeftServerList/Scroll View/Viewport/Content").gameObject;
    this.back = transform:Find("back").gameObject;
    this.oKBtn = transform:Find("OKButton").gameObject;
    this.name = transform:Find("nameBg/name"):GetComponent("Text");
    this.oKBtnText = transform:Find("OKButton/Text"):GetComponent("Text");
end
