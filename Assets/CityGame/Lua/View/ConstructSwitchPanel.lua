local transform;
local gameObject;

ConstructSwitchPanel = {};
local this = ConstructSwitchPanel;


--启动事件--
function ConstructSwitchPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--初始化面板--
function ConstructSwitchPanel.InitPanel()
    this.BtnNode=  transform:Find("BtnNode"):GetComponent("RectTransform");
    this.btn_confirm = transform:Find("BtnNode/confirmBtn");
    this.btn_abolish = transform:Find("BtnNode/abolishBtn");
    this.confirmEnableIconTransform = transform:Find("BtnNode/confirmBtn/enableIcon");
end


function ConstructSwitchPanel.OnDestroy()

end

