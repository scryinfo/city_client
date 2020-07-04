local transform;
local gameObject;

ConstructSwitchPanel = {};
local this = ConstructSwitchPanel;


--Start event--
function ConstructSwitchPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--Initialization panel---
function ConstructSwitchPanel.InitPanel()
    this.BtnNode=  transform:Find("BtnNode"):GetComponent("RectTransform");
    this.btn_confirm = transform:Find("BtnNode/confirmBtn");
    this.btn_abolish = transform:Find("BtnNode/abolishBtn");
    this.confirmEnableIconTransform = transform:Find("BtnNode/confirmBtn/enableIcon");
end


function ConstructSwitchPanel.OnDestroy()

end

