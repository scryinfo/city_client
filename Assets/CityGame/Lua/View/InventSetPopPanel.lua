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

end

function InventSetPopPanel.ChangeLan()

end