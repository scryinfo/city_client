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

    this.priceInp = transform:Find("PopCommpent/priceInp"):GetComponent("InputField");
    this.countInp = transform:Find("PopCommpent/countInp"):GetComponent("InputField");

    this.isOpenBtn = transform:Find("PopCommpent/Button")
    this.isOpenBtnText = transform:Find("PopCommpent/Button/Text"):GetComponent("Text");

end

function InventSetPopPanel.ChangeLan()

end