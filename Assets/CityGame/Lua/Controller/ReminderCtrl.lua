
ReminderCtrl = class('ReminderCtrl',UIPanel)
UIPanel:ResgisterOpen(ReminderCtrl) --注册打开的方法

function ReminderCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function ReminderCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ReminderPanel.prefab";
end

function ReminderCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

local panel,popCompent,LuaBehaviour
function ReminderCtrl:Awake(go)
    panel = ReminderPanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    popCompent = PopCommpent:new(go,LuaBehaviour)
end


function ReminderCtrl:Refresh()
    local data = self.m_data
    self:updateText(data)
    popCompent:Refesh(data)
end


function ReminderCtrl:updateText(data)
        panel.mainText.text=GetLanguage(40010009)
end

