local transform;
local gameObject;

BattlePanel = {};
local this = BattlePanel;

--Start event--
function BattlePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--Initialize the panel--
function BattlePanel.InitPanel()
	this.btn_skill = transform:Find("content/btn_skill").gameObject;
	this.btn_battle = transform:Find("content/btn_battle").gameObject;
end

--Click event--
function BattlePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

