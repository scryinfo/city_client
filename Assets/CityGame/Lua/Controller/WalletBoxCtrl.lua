---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/6/19 11:08
---钱包密码弹窗
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
end

function WalletBoxCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
end

function WalletBoxCtrl:Hide()
    UIPanel.Hide(self)
end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function WalletBoxCtrl:_getComponent(go)
    --topRoot
    self.topText = go.transform:Find("contentRoot/topBg/topText"):GetComponent("Text")
    self.passwordInput = go.transform:Find("contentRoot/passwordInput"):GetComponent("InputField")
    self.undoBtn = go.transform:Find("contentRoot/undoBtn")
    self.confirmBtn = go.transform:Find("contentRoot/confirmBtn")
end
-------------------------------------------------------------初始化---------------------------------------------------------------------------------
--初始化UI
function WalletBoxCtrl:initializeUiInfoData()
    self.passwordInput.text = ""
end
--设置多语言
function WalletBoxCtrl:_language()

end
-------------------------------------------------------------点击函数---------------------------------------------------------------------------------
--取消
function WalletBoxCtrl:_clickUndoBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--确认
function WalletBoxCtrl:_clickConfirmBtn(ins)
    PlayMusEff(1002)
    local passWordPath = CityLuaUtil.getAssetsPath().."/Lua/pb/passWard.data"
    local str = ct.file_readString(passWordPath)
    if ins.passwordInput.text == str then
        Event.Brocast("ReqCreateOrder",ins.m_data.userId,ins.m_data.amount)
        UIPanel.ClosePage()
        --在充值成功后打开这个  赋值钱包地址
        --Event.Brocast("openQRCode")
    else
        ins.passwordInput.text = ""
        Event.Brocast("SmallPop","密码输入错误", ReminderType.Warning)
        return
    end
end
