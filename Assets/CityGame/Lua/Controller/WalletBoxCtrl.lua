---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/6/19 11:08
---Wallet password popup
WalletBoxCtrl = class('WalletBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(WalletBoxCtrl)

function WalletBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function WalletBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WalletBoxPanel.prefab"
end

function WalletBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function WalletBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.undoBtn.gameObject,self._clickUndoBtn,self)
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject,self._clickConfirmBtn,self)
    --self.luaBehaviour:AddClick(self.forget.gameObject,self._clickForget,self)
end

function WalletBoxCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
end

function WalletBoxCtrl:Hide()
    UIPanel.Hide(self)
end
-------------------------------------------------------------Get components ---.----------------------------------------------------------------------------
function WalletBoxCtrl:_getComponent(go)
    --topRoot
    self.topText = go.transform:Find("contentRoot/topBg/topText"):GetComponent("Text")
    self.passwordInput = go.transform:Find("contentRoot/passwordInput"):GetComponent("InputField")
    self.undoBtn = go.transform:Find("contentRoot/undoBtn")
    self.undoBtnText = go.transform:Find("contentRoot/undoBtn/Text"):GetComponent("Text")
    self.confirmBtn = go.transform:Find("contentRoot/confirmBtn")
    self.confirmBtnText = go.transform:Find("contentRoot/confirmBtn/Text"):GetComponent("Text")
    self.forget = go.transform:Find("contentRoot/forget"):GetComponent("Text")
end
-------------------------------------------------------------Initialization---------------------------------------------------------------------------------
--Initialize the UI
function WalletBoxCtrl:initializeUiInfoData()
    self.passwordInput.text = ""
end
--Set up multiple languages
function WalletBoxCtrl:_language()
   self.topText.text = GetLanguage(33020001)
   self.forget.text = GetLanguage(33020002)
   self.undoBtnText.text = GetLanguage(33020003)
   self.confirmBtnText.text = GetLanguage(33020004)
end
--------------------------------------------------------------Click function-----------------------------------------------------------------------------------
--cancel
function WalletBoxCtrl:_clickUndoBtn()
    PlayMusEff(1002)
    local data={ReminderType = ReminderType.Common,ReminderSelectType = ReminderSelectType.Select,
                content = GetLanguage(33020028),func = function()
            UIPanel.ClosePage()
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end
--confirm
function WalletBoxCtrl:_clickConfirmBtn(ins)
    PlayMusEff(1002)
    if ct.VerifyPassword(ins.passwordInput.text) == true then
        if ins.m_data.type == "topUp" then
            Event.Brocast("ReqCreateOrder",ins.m_data.userId,ins.m_data.amount,ins.passwordInput.text)
        elseif ins.m_data.type == "withdraw" then
            Event.Brocast("ReqDisChargeOrder",ins.m_data.userId,ins.passwordInput.text)
        end
        UIPanel.ClosePage()
        --After the recharge is successful, open the assigned wallet address
        --Event.Brocast("openQRCode")
    else
        ins.passwordInput.text = ""
        Event.Brocast("SmallPop",GetLanguage(33030015), ReminderType.Warning)
        return
    end
end

--forget password
function WalletBoxCtrl:_clickForget()

end
