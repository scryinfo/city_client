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
    this.arrowBtn = transform:Find("Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open下拉列表
    this.nameBtn = transform:Find("List/nameBtn").gameObject;  --名字排序
    this.quantityBtn = transform:Find("List/quantityBtn").gameObject;  --数量排序
    this.priceBtn = transform:Find("List/priceBtn").gameObject;  --价格排序
    this.nowText = transform:Find("Sorting/bg/nowText"):GetComponent("Text");
    this.list = transform:Find("List").gameObject;
    --Scroll View
    this.Content = transform:Find("Scroll View/Viewport/Content");
    this.bgBtn = transform:Find("Scroll View/Viewport/Content/ShelfAddItem/bgBtn").gameObject;
    --RightInformation  --Text Button
    this.closeBtn = transform:Find("RightInformation/bg/buy/closeBtn").gameObject;
    this.confirmBtn = transform:Find("RightInformation/bg/buy/confirmBtn").gameObject;
    this.priceText = transform:Find("RightInformation/bg/buy/priceText"):GetComponent("RectTransform");
    this.nameText = transform:Find("RightInformation/bg/buy/warehouseName/nameText"):GetComponent("RectTransform");
    this.openBtn = transform:Find("RightInformation/bg/buy/warehouseName/openBtn").gameObject;
end
function ShelfPanel.OnDestroy()

end