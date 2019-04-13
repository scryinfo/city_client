local transform;
--local gameObject;

InventPopPanel = {};
local this = InventPopPanel;

--启动事件
function InventPopPanel.Awake(obj)

    transform = obj.transform;
    this.InitPanle();

end
--初始化界面
function InventPopPanel.InitPanle()

    this.countInp = transform:Find("PopCommpent/countInput"):GetComponent("InputField");

end

function InventPopPanel.ChangeLan()

end