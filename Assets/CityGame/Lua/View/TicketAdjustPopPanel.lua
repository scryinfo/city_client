---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/12/012 16:31
---


local transform;
local gameObject;

TicketAdjustPopPanel = {};
local this = TicketAdjustPopPanel;

--启动事件
function TicketAdjustPopPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanle();
end
--初始化界面
function TicketAdjustPopPanel.InitPanle()
    this.confirmBtn = transform:Find("root/confirmBtn");
    this.closeBtn = transform:Find("root/closeBtn");


    this.capitaWageMoney = transform:Find("root/wage/capitaWage/moneyText").gameObject;

    this.inputWage = transform:Find("root/InputWage").gameObject;
    this.suggestWage = transform:Find("root/suggest/moneyText").gameObject;
    this.timeInForce = transform:Find("root/timeInForce/timeText").gameObject;

end
function TicketAdjustPopPanel.OnDestroy()

end


