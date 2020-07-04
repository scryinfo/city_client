local transform;
local gameObject;

TransportBoxPanel = {};
local this = TransportBoxPanel;

function TransportBoxPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function TransportBoxPanel.InitPanel()
    this.confirmBtn = transform:Find("box_bg/confirmBtn");
    this.closeBtn = transform:Find("box_bg/closeBtn");
    this.name = transform:Find("box_bg/name"):GetComponent("Text");
    this.fromName = transform:Find("box_bg/from/fromName"):GetComponent("Text"); --Start
    this.targetName = transform:Find("box_bg/target/targetName"):GetComponent("Text"); --End
    this.distanceText = transform:Find("box_bg/distance/distanceText"):GetComponent("Text"); --Distance
    this.numberText = transform:Find("box_bg/number/numberText"):GetComponent("Text"); --Number

    this.goodsObj = transform:Find("box_bg/fee/goods"):GetComponent("RectTransform"); --Purchase
    this.goodsMoney = transform:Find("box_bg/fee/goods/goodsMoney"):GetComponent("Text"); --   the price of the product
    this.transportObj = transform:Find("box_bg/fee/transport"):GetComponent("RectTransform"); --Purchase
    this.transportMoney = transform:Find("box_bg/fee/transport/transportMoney"):GetComponent("Text");  --  required freight

    this.transportsObj = transform:Find("box_bg/fee/transports"):GetComponent("RectTransform"); --Used for transportation
    this.transportsMoney = transform:Find("box_bg/fee/transports/transportsMoney"):GetComponent("Text"); --The freight to be used for transportation
    this.totalMoney = transform:Find("box_bg/fee/total/totalMoney"):GetComponent("Text");  -- total price
    this.total = transform:Find("box_bg/fee/total"):GetComponent("Text"); --Total

end
function ChooseWarehousePanel.OnDestroy()
    logWarn("OnDestroy TransportBoxPanel--->>>");
end