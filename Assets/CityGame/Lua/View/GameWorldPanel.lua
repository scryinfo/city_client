local transform;
local gameObject;

GameWorldPanel = {};
local this = GameWorldPanel;

--启动事件--
function GameWorldPanel.Awake(obj)

	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function GameWorldPanel.InitPanel()
	this.btnSend = transform:Find("Button_send").gameObject;
	this.PanelDie = transform:Find("Panel_die").gameObject;
	this.btnRelive = transform:Find("Panel_die/Button_relive").gameObject;
	this.btnClose = transform:Find("Button_close").gameObject;
	this.textContent = transform:Find("Scroll View/Viewport/trans_content").gameObject;
	this.sb_vertical = transform:Find("Scroll View/Scrollbar Vertical"):GetComponent("Scrollbar");
	this.input_content = transform:Find("InputField_content"):GetComponent("InputField");
	this.btnResetView = transform:Find("Button_resetView").gameObject;
	this.btnSkill1 = transform:Find("Button_skill1").gameObject;
	this.btnSkill2 = transform:Find("Button_skill2").gameObject;
	this.btnSkill3 = transform:Find("Button_skill3").gameObject;
	this.btnTabTarget = transform:Find("Button_tabTarget").gameObject;
	
end

--单击事件--
function GameWorldPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

