require('Framework/UI/UIPage')
local class = require 'Framework/class'

WagesAdjustBoxCtrl = class('WagesAdjustBoxCtrl',UIPage)

function WagesAdjustBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function WagesAdjustBoxCtrl:bundleName()
    return "WagesAdjustBox";
end

function WagesAdjustBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    gameObject = obj;
    local WagesAdjustBox = gameObject:GetComponent('LuaBehaviour');
end

function WagesAdjustBoxCtrl:Awake(go)
    self.gameObject = go;
    local WagesAdjustBox = self.gameObject:GetComponent('LuaBehaviour');
    WagesAdjustBox:AddClick(WagesAdjustBoxPanle.confirmBtn,self.OnClick_confirm,self);
    WagesAdjustBox:AddClick(WagesAdjustBoxPanle.closeBtn,self.OnClick_close,self);
end
--确定
function WagesAdjustBoxCtrl:OnClick_confirm(obj)
    obj:Hide();
end
--关闭
function WagesAdjustBoxCtrl:OnClick_close(obj)
    obj:Hide();
end
--刷新
function WagesAdjustBoxCtrl:Refresh()
--[[    WagesAdjustBoxPanle.noDomicileNumber:GetComponent("Text").text = "12/<color=white>100</color>";
    WagesAdjustBoxPanle.capitaWageMoney:GetComponent("Text").text = "1234567.<size=18>0000</size>";]]

end