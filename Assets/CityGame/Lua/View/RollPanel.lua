local transform;
--local gameObject;

RollPanel = {};
local this = RollPanel;

--启动事件
function RollPanel.Awake(obj)

    transform = obj.transform;
    this.InitPanle();

end
--初始化界面
function RollPanel.InitPanle()

    this.scrolParent = transform:Find("PopCommpent/Scroll/Viewport/Content")
    this.titleText = transform:Find("PopCommpent/titleText"):GetComponent("Text")

end

function RollPanel.ChangeLan()

end