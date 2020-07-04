local transform;
local gameObject;

NoticePanel = {};
local this = NoticePanel;

--Start event--
function NoticePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--Initialize the panel--
function NoticePanel.InitPanel()
	this.btn_confim = transform:Find("content/btn_confim").gameObject;
end

--Click event--
function NoticePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

