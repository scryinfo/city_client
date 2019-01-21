-----
WagesAdjustBoxCtrl = class('WagesAdjustBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(WagesAdjustBoxCtrl)

WagesAdjustBoxCtrl.static.BlackColor = "#4B4B4B"

function WagesAdjustBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function WagesAdjustBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WagesAdjustBoxPanel.prefab"
end

function WagesAdjustBoxCtrl:Awake(go)
    self.gameObject = go
end

function WagesAdjustBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function WagesAdjustBoxCtrl:Awake(go)
    self:_getComponent(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject, self._onClickConfim, self)
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
end

function WagesAdjustBoxCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function WagesAdjustBoxCtrl:Refresh()
    self:_initData()
end

---寻找组件
function WagesAdjustBoxCtrl:_getComponent(go)
    self.confirmBtn = go.transform:Find("root/confirmBtn")
    self.closeBtn = go.transform:Find("root/closeBtn")
    self.perWageText = go.transform:Find("root/center/wage/perWageText"):GetComponent("Text")
    self.staffCountText = go.transform:Find("root/center/staff/staffCountText"):GetComponent("Text")
    self.totalWageText = go.transform:Find("root/center/total/totalWageText"):GetComponent("Text")
end
---初始化
function WagesAdjustBoxCtrl:_initData()
    local dayWage = self.m_data.dayWage or 0
    local workerNum = self.m_data.workerNum or 0

    local perWageStr = string.format("%s<color=%s>%s</color>", getPriceString(dayWage, 24, 20), WagesAdjustBoxCtrl.static.BlackColor, "/D")
    self.perWageText.text = perWageStr

    local totalWageStr = string.format("%s<color=%s>%s</color>", getPriceString(dayWage * workerNum, 36, 30), WagesAdjustBoxCtrl.static.BlackColor, "/D")
    self.totalWageText.text = totalWageStr
    self.staffCountText.text = workerNum
end

function WagesAdjustBoxCtrl:_onClickConfim(ins)
    if ins.m_data.callback ~= nil then
        ins.m_data.callback()
        ins.m_data.callback = nil
    end
    UIPanel.ClosePage()
end

function WagesAdjustBoxCtrl:_onClickClose(ins)
     UIPanel.ClosePage()
end