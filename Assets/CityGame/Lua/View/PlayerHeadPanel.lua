local transform;
local gameObject;

PlayerHeadPanel = {};
local this = PlayerHeadPanel;

--Start event---
function PlayerHeadPanel.Awake(obj)

	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--Initialize the panel--
function PlayerHeadPanel.InitPanel()
	this.sliderHp = transform:Find("Slider_targetHP"):GetComponent("Slider");
	this.textTargetName = transform:Find("Text_targetName"):GetComponent("Text");
	this.textHpDetail = transform:Find("Text_hp"):GetComponent("Text");
end

--Click event----
function PlayerHeadPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

