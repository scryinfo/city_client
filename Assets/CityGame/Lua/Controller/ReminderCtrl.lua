
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

function ReminderCtrl:Awake(go)
    self.panel = ReminderPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.popCompent = PopCommpent:new(go,LuaBehaviour)
end

function ReminderCtrl:Refresh()
    local data = self.m_data
    self:updateText(data)
    self.popCompent:Refesh(data)
end


function ReminderCtrl:updateText(data)
    if data.content then
        self.panel.mainText.text = data.content
    else
        self.panel.mainText.text = GetLanguage(40010009)
    end
end

