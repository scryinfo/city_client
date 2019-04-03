local transform;


ReminderTipsPanel = {};
local this = ReminderTipsPanel;

--启动事件
function ReminderTipsPanel.Awake(obj)
    transform = obj.transform;
    this.InitPanle();
end
--初始化界面
function ReminderTipsPanel.InitPanle()
    this.mainText=transform:Find("PopCommpent/mainContentText"):GetComponent("Text");

    this.one=transform:Find("PopCommpent/tipwthIma/one"):GetComponent("Text");
    this.second=transform:Find("PopCommpent/tipwthIma/second"):GetComponent("Text");
    this.third=transform:Find("PopCommpent/tipwthIma/third"):GetComponent("Text");
    this.fourth=transform:Find("PopCommpent/tipwthIma/fourth"):GetComponent("Text");
end

function ReminderTipsPanel.ChangeLan()
    this.one.text=GetLanguage(40010010)
    this.second.text=GetLanguage(40010011)
    this.third.text=GetLanguage(40010012)
    this.fourth.text=GetLanguage(40010019)
end