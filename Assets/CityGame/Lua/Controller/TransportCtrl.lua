-----

TransportCtrl = {};
local this = TransportCtrl;

local Transport;
local gameObject;

function TransportCtrl.New()
    logWarn("TransportCtrl.New--->>>");
    return this;
end
function TransportCtrl.Awake()
    logWarn("TransportCtrl.Awake--->>>");
    panelMgr:LoadPrefab_A('Transport', nil, this,this.OnCreate);
end
function TransportCtrl.OnCreate(obj)
    gameObject = ct.InstantiatePrefab(obj);

    Transport = gameObject:GetComponent('LuaBehaviour');
    Transport:AddClick(TransportPanel.addBtn,this.OnAddBtn);
end
function TransportCtrl.OnAddBtn(go)
    local ctrl = CtrlManager.GetCtrl(CtrlNames.AddTransport);
    if ctrl ~= nil then
        ctrl:Awake();
    end
end