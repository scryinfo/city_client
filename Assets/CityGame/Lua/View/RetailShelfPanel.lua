local transform;
local gameObject;

RetailShelfPanel = {};
local this = RetailShelfPanel;

function RetailShelfPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function RetailShelfPanel.InitPanel()
    this.capacitySlider = transform:Find("sliderBg/capacitySlider"):GetComponent("Slider");
    this.numberText = transform:Find("sliderBg/numberText"):GetComponent("Text");
    this.return_Btn = transform:Find("return_Btn");
    this.buy_Btn = transform:Find("buy_Btn").gameObject;
    --Name quantity price sort
    this.arrowBtn = transform:Find("sorting/arrowBtn");
    this.nowText = transform:Find("sorting/bg/nowText"):GetComponent("Text");
    this.listTable = transform:Find("listTable/list"):GetComponent("RectTransform");
    this.nameBtn = transform:Find("listTable/list/nameBtn");
    this.quantityBtn = transform:Find("listTable/list/quantityBtn");
    this.priceBtn = transform:Find("listTable/list/priceBtn");

    ---Rank rating ranking
    this.levelArrowBtn = transform:Find("sortings/arrowBtn");
    this.levelnowText = transform:Find("sortings/bg/nowText"):GetComponent("Text");
    this.listTables = transform:Find("listTables/list"):GetComponent("RectTransform");
    this.allBtn = transform:Find("listTables/list/allBtn");
    this.normalBtn = transform:Find("listTables/list/normalBtn");
    this.middleBtn = transform:Find("listTables/list/middleBtn");
    this.seniorBtn = transform:Find("listTables/list/seniorBtn");

    --content
    this.content = transform:Find("scrollView/viewport/content");
    this.addBtn = transform:Find("scrollView/viewport/content/retailAddItem/bgBtn");
    this.retailAddItem = transform:Find("scrollView/viewport/content/retailAddItem");

    --rightInformation
    this.bg = transform:Find("rightInformation/bg"):GetComponent("RectTransform");
    this.closeBtn = transform:Find("rightInformation/bg/buy/closeBtn").gameObject;
    this.confirmBtn = transform:Find("rightInformation/bg/buy/confirmBtn").gameObject;
    this.priceText = transform:Find("rightInformation/bg/buy/priceText"):GetComponent("RectTransform");
    this.nameText = transform:Find("rightInformation/bg/buy/warehouseName/nameText"):GetComponent("RectTransform");
    this.openBtn = transform:Find("rightInformation/bg/buy/warehouseName/openBtn").gameObject;
    this.buyContent = transform:Find("rightInformation/bg/buy/ScrollView/Viewport/Content");
    --Prefabricated
    this.RetailGoodsItem = transform:Find("scrollView/viewport/content/RetailGoodsItem").gameObject
end
function RetailShelfPanel.OnDestroy()

end