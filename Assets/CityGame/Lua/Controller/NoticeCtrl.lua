---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/28 17:47
---
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/27 21:15
---
-----


NoticeCtrl = class('NoticeCtrl',UIPage)

function NoticeCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function NoticeCtrl:bundleName()
    return "Notice"
end

function NoticeCtrl:OnCreate(obj )
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    local Notice = gameObject:GetComponent('LuaBehaviour');
end

function NoticeCtrl:Awake(go)
    self.gameObject = go
    local Notice = self.gameObject:GetComponent('LuaBehaviour')
    Notice:AddClick(NoticePanel.btn_confim, self.OnClick_confim, self);
end

function NoticeCtrl:Refresh()

end

function NoticeCtrl:OnClick_confim(obj)
    ct.log("abel_w6_UIFrame", "NoticeCtrl:OnClick_confim")
    obj:Hide();
end



