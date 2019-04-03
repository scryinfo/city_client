ReminderTipsCtrl = class('ReminderTipsCtrl',UIPanel)
UIPanel:ResgisterOpen(ReminderTipsCtrl) --注册打开的方法

function ReminderTipsCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function ReminderTipsCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ReminderTipsPanel.prefab";
end

function ReminderTipsCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

local panel,popCompent,LuaBehaviour
function ReminderTipsCtrl:Awake(go)
    panel = ReminderTipsPanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    popCompent = PopCommpent:new(go,LuaBehaviour)
end


function ReminderTipsCtrl:Refresh()
    local data = self.m_data

    self:changeLan()
    popCompent:Refesh(data)
end


function ReminderTipsCtrl:changeLan(data)
    panel.mainText.text=GetLanguage(40010013)
    panel.one.text=GetLanguage(40010010)
    panel.second.text=GetLanguage(40010011)
    panel.third.text=GetLanguage(40010012)
    panel.fourth.text=GetLanguage(40010019)
end
