local transform;
local gameObject;

ProcessWarehousePanel = {};
local this = ProcessWarehousePanel;

function ProcessWarehousePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function ProcessWarehousePanel.InitPanel()
    --Button
    --this.searchBtn = transform:Find("Button/searchBtn");
    this.returnBtn = transform:Find("Button/ReturnBtn");
    --this.openBtn = transform:Find("Button/SortingBtn/OpenBtn").gameObject;
    this.arrowBtn = transform:Find("Button/Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open drop-down list
    this.warehouseImg = transform:Find("bg/warehouse");

    this.nowText = transform:Find("Button/Sorting/nowText"):GetComponent("Text");
    this.list = transform:Find("ListTable/List"):GetComponent("RectTransform");
    this.nameBtn = transform:Find("ListTable/List/nameBtn");
    this.quantityBtn = transform:Find("ListTable/List/quantityBtn");
    this.shelfBtn = transform:Find("Button/shelfBtn");
    this.transportBtn = transform:Find("Button/transportBtn");
    --Button shelf  Right panel
    this.rightInformation = transform:Find("RightInformation"):GetComponent("RectTransform");
    this.bg = transform:Find("RightInformation/bg"):GetComponent("RectTransform");
    this.shelf = transform:Find("RightInformation/bg/shelf").gameObject;
    this.shelfContent = transform:Find("RightInformation/bg/shelf/ScrollView/Viewport/Content");

    this.shelfCloseBtn = transform:Find("RightInformation/bg/shelf/closeBtn");
    this.shelfConfirmBtn = transform:Find("RightInformation/bg/shelf/confirmBtn");
    this.shelfUncheckBtn = transform:Find("RightInformation/bg/shelf/uncheckBtn")

    --Button transport
    this.transport = transform:Find("RightInformation/bg/transport").gameObject;
    this.transportCloseBtn = transform:Find("RightInformation/bg/transport/closeBtn");
    this.transportConfirmBtn = transform:Find("RightInformation/bg/transport/confirmBtn");
    this.transportUncheckBtn = transform:Find("RightInformation/bg/transport/uncheckBtn");
    this.moneyText = transform:Find("RightInformation/bg/transport/moneyText").gameObject;
    this.transportopenBtn = transform:Find("RightInformation/bg/transport/warehouseName/openBtn");
    this.nameText = transform:Find("RightInformation/bg/transport/warehouseName/nameText"):GetComponent("Text");
    this.transportContent = transform:Find("RightInformation/bg/transport/ScrollView/Viewport/Content");
    this.tipText = transform:Find("RightInformation/bg/transport/tipText"):GetComponent("Text")
    --Slider--Text
    this.Warehouse_Slider = transform:Find("WarehouseDetails/Warehouse_Slider"):GetComponent("Slider");
    this.Locked_Slider = transform:Find("WarehouseDetails/Locked_Slider"):GetComponent("Slider");
    this.numberText = transform:Find("WarehouseDetails/numberText"):GetComponent("Text");
    --Scroll View
    this.ScrollView = transform:Find("ScrollView"):GetComponent("RectTransform");
    this.Content = transform:Find("ScrollView/Viewport/Content"):GetComponent("RectTransform");
    --Right panel
    this.warehouseItem = transform:Find("ScrollView/Viewport/Content/WarehouseItem").gameObject
    this.DetailsItem = transform:Find("RightInformation/bg/shelf/ScrollView/Viewport/Content/DetailsItem").gameObject
    this.TransportItem = transform:Find("RightInformation/bg/transport/ScrollView/Viewport/Content/TransportItem").gameObject

end
function ProcessWarehousePanel.OnDestroy()
    logWarn("OnDestroy ProcessWarehousePanel--->>>");
end