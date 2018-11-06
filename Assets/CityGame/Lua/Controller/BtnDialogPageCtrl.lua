---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/30 16:30
---只含有按钮的简单弹框
BtnDialogPageCtrl = class('BtnDialogPageCtrl',UIPage)
UIPage:ResgisterOpen(BtnDialogPageCtrl)

function BtnDialogPageCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function BtnDialogPageCtrl:bundleName()
    --return "Common/BtnDialogPagePanel"
    return "BtnDialogPagePanel"
end

function BtnDialogPageCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function BtnDialogPageCtrl:Awake(go)
    self:_getComponent(go)
   -- self:_initData()

    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    --self.luaBehaviour:AddClick(self.confimBtn.gameObject, self._onClickConfim, self)
    --self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
end

function BtnDialogPageCtrl:Refresh()
    self:_initData()
    self.luaBehaviour:AddClick(self.confimBtn.gameObject, self._onClickConfim, self);
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self);
end

---寻找组件
function BtnDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText"):GetComponent("Text")
    self.mainContentText = go.transform:Find("root/mainContentText"):GetComponent("Text")
    self.tipText = go.transform:Find("root/tipContentText"):GetComponent("Text")
    self.closeBtn = go.transform:Find("root/closeBtn")
    self.confimBtn = go.transform:Find("root/confimBtn")
end
---初始化
function BtnDialogPageCtrl:_initData()
    self.titleText.text = self.m_data.titleInfo
    self.mainContentText.text = self.m_data.contentInfo
    self.tipText.text = self.m_data.tipInfo
end

function BtnDialogPageCtrl:_onClickConfim(ins)
    ct.log("cycle_w6_houseAndGround", "BtnDialogPageCtrl:_onClickConfim")
    if ins.m_data.btnCallBack then
        ins.m_data.btnCallBack()
        ins.m_data.btnCallBack = nil
    end
    ins:_onClickClose(ins)
end
function BtnDialogPageCtrl:_onClickClose(ins)
    ins.luaBehaviour:RemoveClick(ins.confimBtn.gameObject, ins._onClickConfim, ins)
    ins.luaBehaviour:RemoveClick(ins.closeBtn.gameObject, ins._onClickClose, ins)
    ins:Hide()
end


