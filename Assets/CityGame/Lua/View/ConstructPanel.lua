local transform;
local gameObject;

ConstructPanel = {};
local this = ConstructPanel;


--启动事件--
function ConstructPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--初始化面板--
function ConstructPanel.InitPanel()
    this.btn_back = transform:Find("backBtn").gameObject;
    this.root_content = transform:Find("bottomScroll/Viewport/Content").gameObject;
    --TODO：根据建筑配置表创造建筑
end

--单击事件--
function ConstructPanel.OnDestroy()

end

