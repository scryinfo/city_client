local transform;
local gameObject;

MainPagePanel = {};
local this = MainPagePanel;

--Start event--
function MainPagePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--Initial panel--
function MainPagePanel.InitPanel()
	this.btn_skill = transform:Find("btn_skill").gameObject;
	this.btn_battle = transform:Find("btn_battle").gameObject;
end

--Click event--
function MainPagePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

