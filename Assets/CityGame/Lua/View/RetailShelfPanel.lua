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
    --名字数量价格排序
    this.arrowBtn = transform:Find("sorting/arrowBtn");
    this.nowText = transform:Find("sorting/bg/nowText"):GetComponent("Text");
    this.listTable = transform:Find("listTable/list"):GetComponent("RectTransform");
    this.nameBtn = transform:Find("listTable/list/nameBtn");
    this.quantityBtn = transform:Find("listTable/list/quantityBtn");
    this.priceBtn = transform:Find("listTable/list/priceBtn");

    --等级评分排序
    this.levelArrowBtn = transform:Find("sortings/arrowBtn");
    this.levelnowText = transform:Find("sortings/bg/nowText"):GetComponent("Text");
    this.listTables = transform:Find("listTables/list"):GetComponent("RectTransform");
    this.allBtn = transform:Find("listTables/list/allBtn");
    this.normalBtn = transform:Find("listTables/list/normalBtn");
    this.middleBtn = transform:Find("listTables/list/middleBtn");
    this.seniorBtn = transform:Find("listTables/list/seniorBtn");

    --内容
    this.content = transform:Find("scrollView/viewport/content");
    this.addBtn = transform:Find("scrollView/viewport/content/retailAddItem/bgBtn");

end
function RetailShelfPanel.OnDestroy()

end