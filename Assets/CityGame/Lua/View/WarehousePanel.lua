local transform;
local gameObject;

WarehousePanel = {};
local this = WarehousePanel;

function WarehousePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function WarehousePanel.InitPanel()
    --Button
    this.searchBtn = transform:Find("Button/searchBtn");
    this.returnBtn = transform:Find("Button/ReturnBtn");
    --this.openBtn = transform:Find("Button/SortingBtn/OpenBtn").gameObject;
    this.arrowBtn = transform:Find("Button/Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open下拉列表
    this.nowText = transform:Find("Button/Sorting/nowText"):GetComponent("Text");
    this.list = transform:Find("Button/Sorting/List").gameObject;
    this.nameBtn = transform:Find("Button/Sorting/List/nameBtn");
    this.quantityBtn = transform:Find("Button/Sorting/List/quantityBtn");
    this.shelfBtn = transform:Find("Button/shelfBtn");
    this.transportBtn = transform:Find("Button/transportBtn");
    --Button shelf  右边面板
    this.rightInformation = transform:Find("RightInformation").gameObject;
    this.shelf = transform:Find("RightInformation/bg/shelf").gameObject;
    this.transport = transform:Find("RightInformation/bg/transport").gameObject;

    this.shelfCloseBtn = transform:Find("RightInformation/bg/shelf/closeBtn");
    this.shelfConfirmBtn = transform:Find("RightInformation/bg/shelf/confirmBtn").gameObject;
    --Button transport
    this.transportCloseBtn = transform:Find("RightInformation/bg/transport/closeBtn");
    this.transportConfirmBtn = transform:Find("RightInformation/bg/transport/confirmBtn").gameObject;
    this.moneyText = transform:Find("RightInformation/bg/transport/moneyText").gameObject;
    this.transportopenBtn = transform:Find("RightInformation/bg/transport/warehouseName/openBtn");
    this.nameText = transform:Find("RightInformation/bg/transport/warehouseName/nameText").gameObject;
    --Slider--Text
    this.Warehouse_Slider = transform:Find("WarehouseDetails/Warehouse_Slider").gameObject;
    this.NumberText = transform:Find("WarehouseDetails/NumberText").gameObject;
    --Scroll View
    this.ScrollView = transform:Find("ScrollView"):GetComponent("RectTransform");
    this.Content = transform:Find("ScrollView/Viewport/Content"):GetComponent("RectTransform");

end
function WarehousePanel.OnDestroy()
    logWarn("OnDestroy WarehousePanel--->>>");
end