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
    --this.searchBtn = transform:Find("Button/searchBtn");
    this.returnBtn = transform:Find("Button/ReturnBtn");
    --this.openBtn = transform:Find("Button/SortingBtn/OpenBtn").gameObject;
    this.arrowBtn = transform:Find("Button/Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open下拉列表

    this.nowText = transform:Find("Button/Sorting/nowText"):GetComponent("Text");
    this.list = transform:Find("ListTable/List"):GetComponent("RectTransform");
    this.nameBtn = transform:Find("ListTable/List/nameBtn");
    this.quantityBtn = transform:Find("ListTable/List/quantityBtn");
    this.shelfBtn = transform:Find("Button/shelfBtn");
    this.transportBtn = transform:Find("Button/transportBtn");
    --Button shelf  右边面板
    this.rightInformation = transform:Find("RightInformation"):GetComponent("RectTransform");
    this.bg = transform:Find("RightInformation/bg"):GetComponent("RectTransform");
    this.shelf = transform:Find("RightInformation/bg/shelf").gameObject;
    this.transport = transform:Find("RightInformation/bg/transport").gameObject;
    this.shelfContent = transform:Find("RightInformation/bg/shelf/ScrollView/Viewport/Content");

    this.shelfCloseBtn = transform:Find("RightInformation/bg/shelf/closeBtn");
    this.shelfConfirmBtn = transform:Find("RightInformation/bg/shelf/confirmBtn");

    --Button transport
    this.transportCloseBtn = transform:Find("RightInformation/bg/transport/closeBtn");
    this.transportConfirmBtn = transform:Find("RightInformation/bg/transport/confirmBtn");
    this.transportUncheckBtn = transform:Find("RightInformation/bg/transport/uncheckBtn");
    this.moneyText = transform:Find("RightInformation/bg/transport/moneyText").gameObject;
    this.transportopenBtn = transform:Find("RightInformation/bg/transport/warehouseName/openBtn");
    this.nameText = transform:Find("RightInformation/bg/transport/warehouseName/nameText"):GetComponent("Text");
    this.transportContent = transform:Find("RightInformation/bg/transport/ScrollView/Viewport/Content");
    --Slider--Text
    this.Warehouse_Slider = transform:Find("WarehouseDetails/Warehouse_Slider"):GetComponent("Slider");
    this.numberText = transform:Find("WarehouseDetails/numberText"):GetComponent("Text");
    --Scroll View
    this.ScrollView = transform:Find("ScrollView"):GetComponent("RectTransform");
    this.Content = transform:Find("ScrollView/Viewport/Content"):GetComponent("RectTransform");

end
function WarehousePanel.OnDestroy()
    logWarn("OnDestroy WarehousePanel--->>>");
end