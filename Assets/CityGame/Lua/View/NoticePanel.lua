local transform;
local gameObject;

NoticePanel = {};
local this = NoticePanel;

--启动事件--
function NoticePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function NoticePanel.InitPanel()
	this.btn_confim = transform:Find("content/btn_confim").gameObject;
end

--单击事件--
function NoticePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

