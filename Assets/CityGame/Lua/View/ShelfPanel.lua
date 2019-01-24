local transform;
local gameObject;

ShelfPanel = {};
local this = ShelfPanel;

function ShelfPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function ShelfPanel.InitPanel()
    --Button --Text
    this.search_Btn = transform:Find("search_Btn").gameObject;  --搜索按钮
    this.return_Btn = transform:Find("return_Btn").gameObject;  --返回按钮
    this.refresh_Btn = transform:Find("refresh_Btn").gameObject;--刷新按钮
    this.buy_Btn = transform:Find("buy_Btn").gameObject;        --购买按钮
    this.arrowBtn = transform:Find("Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open下拉列表
    this.shelfImg = transform:Find("shelf");
    this.nameBtn = transform:Find("ListTable/List/nameBtn");  --名字排序
    this.quantityBtn = transform:Find("ListTable/List/quantityBtn");  --数量排序
    this.priceBtn = transform:Find("ListTable/List/priceBtn");  --价格排序
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
end
function ShelfPanel.OnDestroy()

end