local transform;
local gameObject;

WagesAdjustBoxPanle = {};
local this = WagesAdjustBoxPanle;

--启动事件
function WagesAdjustBoxPanle.Awake()
    gameObject = obj;
    transform = obj.gameObject;

    this.InitPanle();
end
--初始化界面
function WagesAdjustBoxPanle.InitPanle()
    this.confirmBtn = transform:Find("root/confirmBtn").gameObject;
    this.closeBtn = transform:Find("root/closeBtn").gameObject;
    this.noDomicileNumber = transform:Find("root/noDomicile/number").gameObject;
    this.capitaWageMoney = transform:Find("root/wage/capitaWage/moneyText").gameObject;
    this.totalWageMoney = transform:Find("root/wage/totalWage/moneyText").gameObject;
    this.inputWage = transform:Find("root/InputWage").gameObject;
    this.suggestWage = transform:Find("root/suggest/moneyText").gameObject;
    this.timeInForce = transform:Find("root/timeInForce/timeText").gameObject;
    this.satisfactionSlider = transform("root/satisfactionSlider").gameObject;
end
function WagesAdjustBoxPanle.OnDestroy()

end