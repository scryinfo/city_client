local transform;
local gameObject;

ChooseWarehousePanel = {};
local this = ChooseWarehousePanel;

function ChooseWarehousePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function ChooseWarehousePanel.InitPanel()
    this.returnBtn = transform:Find("ReturnBtn").gameObject;
    this.searchBtn = transform:Find("SearchBtn").gameObject;
end
function ChooseWarehousePanel.OnDeOnDestroy()
    destroy(gameObject);
end