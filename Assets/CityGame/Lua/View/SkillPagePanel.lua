local transform;
local gameObject;

SkillPagePanel = {};
local this = SkillPagePanel;

--启动事件--
function SkillPagePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	--this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);

	this.skillList = transform:Find("list").gameObject;
	this.skillDesc = transform:Find("desc").gameObject;
	--this.skillDesc.transform.Find("btn_upgrade").GetComponent("Button").onClick.AddListener(OnClickUpgrade);

	this.skillItem = transform:Find("list/Viewport/Content/item").gameObject;
	this.skillItem:SetActive(false);
end

--初始化面板--
function SkillPagePanel.InitPanel()
	--this.btn_confim = transform:Find("content/btn_confim").gameObject;
end

--单击事件--
function SkillPagePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

