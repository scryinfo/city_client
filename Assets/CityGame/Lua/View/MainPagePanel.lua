local transform;
local gameObject;

MainPagePanel = {};
local this = MainPagePanel;

--启动事件--
function MainPagePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function MainPagePanel.InitPanel()
	this.btn_skill = transform:Find("btn_skill").gameObject;
	this.btn_battle = transform:Find("btn_battle").gameObject;
end

--单击事件--
function MainPagePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

