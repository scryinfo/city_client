local transform;
local gameObject;

StaffPanel = {}
local this = StaffPanel;

function StaffPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    --logWarn("Awake lua StaffPanel--->>>"..gameObject.name);
end
function StaffPanel.InitPanel()
    this.satisfaction_text = transform:Find("Satisfaction/Satisfaction_text").gameObject;
    this.perStaff_text = transform:Find("DetailsWage/PerStaff/PerStaff_text").gameObject;
    this.daily_text = transform:Find("DetailsWage/Daily/Daily_text").gameObject;
    this.AjustBtn = transform:Find("DetailsWage/AJUST_Btn").gameObject;

end
function StaffPanel.OnDestroy()
    logWarn("OnDestroy StaffPanel--->>>");
end