local transform;
local gameObject;

ConstructDialogPagePanel = {};
local this = ConstructDialogPagePanel;


--Start event--
function ConstructDialogPagePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end

--Initialization panel--
function ConstructDialogPagePanel.InitPanel()
    this.btn_confirm = transform:Find("root/confimBtn")
    this.btn_abolish = transform:Find("root/closeBtn")
    this.icon_build = transform:Find("root/centerRoot/buildingImg").gameObject:GetComponent("Image")
    this.titleText =transform:Find("root/titleText").gameObject:GetComponent("Text")
    this.buildSizeText = transform:Find("root/centerRoot/buildingAreaText").gameObject:GetComponent("Text")
end


function ConstructDialogPagePanel.OnDestroy()

end

