local transform;
local gameObject;

WagesAdjustBoxPanel = {};
local this = WagesAdjustBoxPanel;

--启动事件
function WagesAdjustBoxPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanle();
end
--初始化界面
function WagesAdjustBoxPanel.InitPanle()
    this.confirmBtn = transform:Find("root/confirmBtn").gameObject;
    this.closeBtn = transform:Find("root/closeBtn").gameObject;
    this.noDomicileNumber = transform:Find("root/noDomicile/number").gameObject;
    this.capitaWageMoney = transform:Find("root/wage/capitaWage/moneyText").gameObject;
    this.totalWageMoney = transform:Find("root/wage/totalWage/moneyText").gameObject;
    this.inputWage = transform:Find("root/InputWage").gameObject;
    this.suggestWage = transform:Find("root/suggest/moneyText").gameObject;
    this.timeInForce = transform:Find("root/timeInForce/timeText").gameObject;
    this.satisfactionSlider = transform:Find("root/satisfactionSlider").gameObject;
end
function WagesAdjustBoxPanel.OnDestroy()

end