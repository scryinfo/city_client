TransportOrderCtrl = {};
local this = TransportOrderCtrl;

local TransportOrder;
local gameObject;

function TransportOrderCtrl.New()
    return this;
end
function TransportOrderCtrl.Awake()
    panelMgr:LoadPrefab_A('TransportOrder',this.OnCreate);
    TransportOrderCtrl.Initialize();
end
function TransportOrderCtrl.OnCreate(obj)
    gameObject = obj;

    TransportOrder = gameObject:GetComponent('LuaBehaviour');
    TransportOrder:AddClick(TransportOrderPanel.returnBtn,this.OnReturnBtn);
    TransportOrder:AddClick(TransportOrderPanel.confirmBtn,this.OnConfirmBtn);
end
function TransportOrderCtrl.OnReturnBtn(go)
    TransportOrderPanel.OnDestroy();

end
function TransportOrderCtrl.OnConfirmBtn(go)

end
--暂时初始化数据
function TransportOrderCtrl.Initialize()
    local time = os.date("%X");
    local distance = 50;
    TransportOrderPanel.fromName:GetComponent("Text").text = "Player1";
    TransportOrderPanel.toName:GetComponent("Text").text = "Player2";
    TransportOrderPanel.money_text:GetComponent("Text").text = "1000.0000";
    TransportOrderPanel.time_text:GetComponent("Text").text = time;
    TransportOrderPanel.distance_text:GetComponent("Text").text = distance.."km";
end