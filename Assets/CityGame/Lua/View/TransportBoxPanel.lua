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
    this.fromName = transform:Find("box_bg/from/fromName"):GetComponent("Text");   --出发
    this.targetName = transform:Find("box_bg/target/targetName"):GetComponent("Text");   --终点
    this.distanceText = transform:Find("box_bg/distance/distanceText"):GetComponent("Text");   --距离
    this.numberText = transform:Find("box_bg/number/numberText"):GetComponent("Text");   --数量

    this.goodsObj = transform:Find("box_bg/fee/goods"):GetComponent("RectTransform");  --购买要用的
    this.goodsMoney = transform:Find("box_bg/fee/goods/goodsMoney"):GetComponent("Text");   --商品的价钱
    this.transportObj = transform:Find("box_bg/fee/transport"):GetComponent("RectTransform");  --购买要用的
    this.transportMoney = transform:Find("box_bg/fee/transport/transportMoney"):GetComponent("Text");   --需要的运费

    this.transportsObj = transform:Find("box_bg/fee/transports"):GetComponent("RectTransform");  --运输要用的
    this.transportsMoney = transform:Find("box_bg/fee/transports/transportsMoney"):GetComponent("Text");    --运输要用的运费
    this.totalMoney = transform:Find("box_bg/fee/total/totalMoney"):GetComponent("Text");   --总计价钱
    this.total = transform:Find("box_bg/fee/total"):GetComponent("Text");  --总计

end
function ChooseWarehousePanel.OnDestroy()
    logWarn("OnDestroy TransportBoxPanel--->>>");
end