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
    --this.nowText = transform:Find("Button/Sorting/nowText"):GetComponent("Text");
    this.confirmBtn = transform:Find("box_bg/confirmBtn");
    this.closeBtn = transform:Find("box_bg/closeBtn");
    this.fromName = transform:Find("box_bg/from/fromName"):GetComponent("Text");   --出发
    this.targetName = transform:Find("box_bg/target/targetName"):GetComponent("Text");   --终点
    this.distanceText = transform:Find("box_bg/distance/distanceText"):GetComponent("Text");   --距离
    this.timeText = transform:Find("box_bg/time/timeText"):GetComponent("Text");   --时间
    this.goodsMoney = transform:Find("box_bg/fee/goods/goodsMoney"):GetComponent("Text");   --商品的价钱
    this.transportMoney = transform:Find("box_bg/fee/transport/transportMoney"):GetComponent("Text");   --需要的运费
    this.totalMoney = transform:Find("box_bg/fee/total/totalMoney"):GetComponent("Text");   --总计价钱
end
function ChooseWarehousePanel.OnDestroy()
    logWarn("OnDestroy TransportBoxPanel--->>>");
end