---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/26/026 17:17
---

ReminderCtrl = class('ReminderCtrl',UIPage)
UIPage:ResgisterOpen(ReminderCtrl) --注册打开的方法

function ReminderCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.HideOther,UICollider.Normal);
end

function ReminderCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ReminderPanel.prefab";
end

function ReminderCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end
local LuaBehaviour
local panel
function ReminderCtrl:Awake(go)
    self.gameObject = go;
    panel=ReminderPanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(ReminderPanel.confirmBtn.gameObject,self.OnClick_confirm,self);
    LuaBehaviour:AddClick(ReminderPanel.closeBtn.gameObject,self.OnClick_close,self);
end
--确定
function ReminderCtrl:OnClick_confirm(obj)
    if(obj.m_data.callback) then
        obj.m_data:callback()
    end
    obj:Hide();
end
--关闭
function ReminderCtrl:OnClick_close(obj)
    obj:Hide()
end
--刷新
function ReminderCtrl:Refresh()
    local data=self.m_data
    self:updateText(data)


end


function ReminderCtrl:updateText(data)
    panel.tipText.transform.localScale=Vector3.zero
    panel.tipsWitnIma.localScale=Vector3.zero
    if data.type=="stop"then
        panel.mainText.text=data.mainText
        panel.tipsWitnIma.localScale=Vector3.one

    elseif data.type=="remove" then
        panel.mainText.text=data.mainText
        panel.tipText.transform.localScale=Vector3.one

    elseif  data.type=="begin" then
        panel.mainText.text=data.mainText
        panel.tipText.transform.localScale=Vector3.one
        --panel.tipText.text=
    end
end