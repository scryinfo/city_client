local transform;
local gameObject;

TransportOrderPanel = {};
local this = TransportOrderPanel;

function TransportOrderPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function TransportOrderPanel.InitPanel()
    this.money_text = transform:Find("Details/Money/Text").gameObject;
    this.time_text = transform:Find("Details/Time/Text").gameObject;
    this.distance_text = transform:Find("Details/Distance/Text").gameObject;
    this.fromName = transform:Find("FromName").gameObject;
    this.toName = transform:Find("ToName").gameObject;
    this.returnBtn = transform:Find("Return_Btn").gameObject;
    this.confirmBtn = transform:Find("Confirm_Btn").gameObject;
    this.contentPos = transform:Find("Scroll View/Viewport/Content").gameObject;
end
function TransportOrderPanel.OnDestroy()
    destroy(gameObject);
end