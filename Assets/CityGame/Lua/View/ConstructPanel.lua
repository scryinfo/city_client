local transform;
local gameObject;

ConstructPanel = {};
local this = ConstructPanel;


--Start event--
function ConstructPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--Initialization panel---
function ConstructPanel.InitPanel()
    this.btn_back = transform:Find("backBtn").gameObject;
    this.root_content = transform:Find("bottomScroll/Viewport/Content").gameObject;
    --TODO：Create buildings according to the building configuration table
end

--Click event--
function ConstructPanel.OnDestroy()

end

