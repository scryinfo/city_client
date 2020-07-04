local transform;
local gameObject;

TopBarPanel = {};
local this = TopBarPanel;

--Start event-
function TopBarPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--Initial panel--
function TopBarPanel.InitPanel()
	this.btn_notice = transform:Find("btn_notice").gameObject;
	this.btn_back = transform:Find("btn_back").gameObject;
end

--Click event--
function TopBarPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

