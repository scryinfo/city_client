local transform;
local gameObject;

TopBarPanel = {};
local this = TopBarPanel;

--启动事件--
function TopBarPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function TopBarPanel.InitPanel()
	this.btn_notice = transform:Find("btn_notice").gameObject;
	this.btn_back = transform:Find("btn_back").gameObject;
	this.btn_main = transform:Find("btn_main").gameObject;

end

--单击事件--
function TopBarPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

