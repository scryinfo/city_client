local transform;
local gameObject;

ProcessShelfPanel = {};
local this = ProcessShelfPanel;

function ProcessShelfPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function ProcessShelfPanel.InitPanel()
    --Button --Text
    this.search_Btn = transform:Find("search_Btn").gameObject; --search button
    this.return_Btn = transform:Find("return_Btn").gameObject; --back button
    this.refresh_Btn = transform:Find("refresh_Btn").gameObject;--Refresh button
    this.buy_Btn = transform:Find("buy_Btn").gameObject; --buy button
    this.arrowBtn = transform:Find("Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open drop-down list
    this.shelfImg = transform:Find("shelf");
    this.nameBtn = transform:Find("ListTable/List/nameBtn"); --Name sort
    this.quantityBtn = transform:Find("ListTable/List/quantityBtn"); --Quantity sort
    this.priceBtn = transform:Find("ListTable/List/priceBtn"); --Price sorting
    this.nowText = transform:Find("Sorting/bg/nowText"):GetComponent("Text");
    this.list = transform:Find("ListTable/List"):GetComponent("RectTransform");
    this.tipText = transform:Find("RightInformation/bg/buy/tipText"):GetComponent("Text");
    --Scroll View
    this.scrollView = transform:Find("Scroll View")
    this.Content = transform:Find("Scroll View/Viewport/Content");
    this.addBtn = transform:Find("Scroll View/Viewport/Content/ShelfAddItem/addBtn").gameObject;
    this.shelfAddItem = transform:Find("Scroll View/Viewport/Content/ShelfAddItem")
    --RightInformation  --Text Button
    this.bg = transform:Find("RightInformation/bg"):GetComponent("RectTransform");
    this.closeBtn = transform:Find("RightInformation/bg/buy/closeBtn").gameObject;
    this.confirmBtn = transform:Find("RightInformation/bg/buy/confirmBtn");
    this.uncheckBtn = transform:Find("RightInformation/bg/buy/uncheckBtn")
    this.priceText = transform:Find("RightInformation/bg/buy/priceText"):GetComponent("RectTransform");
    this.nameText = transform:Find("RightInformation/bg/buy/warehouseName/nameText"):GetComponent("Text");
    this.openBtn = transform:Find("RightInformation/bg/buy/warehouseName/openBtn").gameObject;
    this.buyContent = transform:Find("RightInformation/bg/buy/ScrollView/Viewport/Content");
    --Prefab
    this.ShelfGoodsItem = transform:Find("Scroll View/Viewport/Content/ShelfGoodsItem").gameObject
    this.BuyDetailsItem = transform:Find("RightInformation/bg/buy/ScrollView/Viewport/Content/BuyDetailsItem").gameObject
end
function ProcessShelfPanel.OnDestroy()

end