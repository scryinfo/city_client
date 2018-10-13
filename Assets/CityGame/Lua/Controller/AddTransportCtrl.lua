require "Common/define"

AddTransportCtrl = {};
local this = AddTransportCtrl;

local AddTransport;
local gameObject;

function AddTransportCtrl.New()
    return this;
end
function AddTransportCtrl.Awake()
    panelMgr:CreatePanel('AddTransport',this.OnCreate);
end
function AddTransportCtrl.OnCreate(obj)
    gameObject = obj;

    AddTransport = gameObject:GetComponent('LuaBehaviour');
    AddTransport:AddClick(AddTransportPanel.returnBtn,this.OnReturnBtn);
    AddTransport:AddClick(AddTransportPanel.confirmBtn,this.OnConfirmBtn);
end
function AddTransportCtrl.OnReturnBtn()
    AddTransportPanel.OnDestroy();
end
function AddTransportCtrl.OnConfirmBtn()
    local ctrl = CtrlManager.GetCtrl(CtrlNames.TransportOrder);
    if ctrl ~= nil then
        ctrl:Awake();
    end
end