---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/30 16:30
---只含有按钮的简单弹框

require('Framework/UI/UIPage')
local class = require 'Framework/class'

BtnDialogPageCtrl = class('BtnDialogPageCtrl',UIPage)

function BtnDialogPageCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function BtnDialogPageCtrl:bundleName()
    return "BtnDialogPage"
end

function BtnDialogPageCtrl:OnCreate(obj )
    UIPage.OnCreate(self, obj)
end

function BtnDialogPageCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_initData()

    local dialog = self.gameObject:GetComponent('LuaBehaviour')
    dialog:AddClick(self.closeBtn, self._onClickConfim, self);
end

function BtnDialogPageCtrl:Refresh()

end
---寻找组件
function BtnDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText").gameObject:GetComponent("Text");
    self.mainContentText = go.transform:Find("root/mainContentText").gameObject:GetComponent("Text");
    self.tipText = go.transform:Find("root/tipText").gameObject:GetComponent("Text");
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject;
end
---初始化
function BtnDialogPageCtrl:_initData()
    self.titleText.text = self.m_data.titleInfo;
    self.mainContentText.text = self.m_data.contentInfo;
    self.tipText.text = self.m_data.tipInfo;
end

function BtnDialogPageCtrl:_onClickConfim(obj)
    log("cycle_w6_houseAndGround", "BtnDialogPageCtrl:_onClickConfim")
    if obj.m_data.btnCallBack then
        obj.m_data.btnCallBack()
    end

    obj:Hide();
end

