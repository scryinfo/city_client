local transform;
--local gameObject;

InventSetPopPanel = {};
local this = InventSetPopPanel;

--启动事件
function InventSetPopPanel.Awake(obj)

    transform = obj.transform;
    this.InitPanle();

end
--初始化界面
function InventSetPopPanel.InitPanle()

    this.xBtn = transform:Find("set/xBtn").gameObject
    this.name = transform:Find("set/name"):GetComponent("Text")
    this.price = transform:Find("set/price"):GetComponent("InputField")
    this.time = transform:Find("set/time"):GetComponent("InputField")
    this.open = transform:Find("set/open"):GetComponent("Toggle")
    this.openBtn = transform:Find("set/open/btnImage"):GetComponent("RectTransform")
    this.close = transform:Find("set/close")
    this.confirm = transform:Find("set/confirm").gameObject
    this.referencePrice = findByName(transform,"referencePriceText"):GetComponent("Text")
    this.pricee = transform:Find("set/price/Image/Placeholder"):GetComponent("Text")
    this.timee = transform:Find("set/time/Image/Placeholder"):GetComponent("Text")
    this.external = transform:Find("set/open/external"):GetComponent("Text")
    this.closeText = transform:Find("set/close/closeText"):GetComponent("Text")

    --竞争力
    this.conpetitivebess = transform:Find("set/conpetitivebess")
    this.conpetitivebessText = transform:Find("set/conpetitivebess/conpetitivebessText"):GetComponent("Text")
    this.value = transform:Find("set/conpetitivebess/valueText"):GetComponent("Text")
    this.infoBtn = transform:Find("set/conpetitivebess/infoBtn").gameObject
    this.tooltip = transform:Find("competitivenessRoot")
    this.infoCloseBtn = transform:Find("competitivenessRoot/btn").gameObject
    this.title = transform:Find("competitivenessRoot/tooltip/title"):GetComponent("Text")
    this.content = transform:Find("competitivenessRoot/tooltip/content"):GetComponent("Text")
    this.closeTooltip = transform:Find("set/closeTooltip").gameObject
end

function InventSetPopPanel.ChangeLan()

end