StaffCtrl = {}
local this = StaffCtrl;

local Staff;
local gameObject;
local satisfaction_text;
local PerStaff_money;
local daily_money;

function StaffCtrl.New()
    logWarn("StaffCtrl.New--->>>");
    return this;
end
function StaffCtrl.Awake()
    logWarn("StaffCtrl.Awake--->>>");
    local pos = Vector3.New(-755,-314,0);
    StaffCtrl.CreateStaff(pos);
    --panelMgr:createWindows('Staff',this.OnCreate);
    StaffCtrl.Initialize();
end
function StaffCtrl.OnCreate(obj)

    Staff = gameObject:GetComponent('LuaBehaviour');
    Staff:AddClick(StaffPanel.AjustBtn,this.OnAjust);
end
function StaffCtrl.OnAjust(go)
    local ctrl = CtrlManager.GetCtrl(CtrlNames.wages);
    if ctrl ~= nil then
        ctrl:Awake();
    end
end
--暂时用来初始化Staff数据
function StaffCtrl.Initialize()
    satisfaction_text = 50;
    PerStaff_money = 20000;
    daily_money = 20000*10;
    StaffPanel.satisfaction_text:GetComponent("Text").text = satisfaction_text.."%";
    StaffPanel.perStaff_text:GetComponent("Text").text = PerStaff_money;
    StaffPanel.daily_text:GetComponent("Text").text = daily_money;
end
function StaffCtrl.CreateStaff(position)
    panelMgr:CreateWindow('Staff',position,this.OnCreate);
end
