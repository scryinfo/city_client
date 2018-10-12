local transform;
local gameObject;

BattlePanel = {};
local this = BattlePanel;

--启动事件--
function BattlePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function BattlePanel.InitPanel()
	this.btn_skill = transform:Find("content/btn_skill").gameObject;
	this.btn_battle = transform:Find("content/btn_battle").gameObject;
end

--单击事件--
function BattlePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

