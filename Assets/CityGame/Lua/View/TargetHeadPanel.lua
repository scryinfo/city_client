local transform;
local gameObject;

TargetHeadPanel = {};
local this = TargetHeadPanel;

---Initial panel---
function TargetHeadPanel.Awake(obj)

	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

---Initial panel----
function TargetHeadPanel.InitPanel()
	this.sliderHp = transform:Find("Slider_targetHP"):GetComponent("Slider");
	this.textTargetName = transform:Find("Text_targetName"):GetComponent("Text");
end

--Click event--
function TargetHeadPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

