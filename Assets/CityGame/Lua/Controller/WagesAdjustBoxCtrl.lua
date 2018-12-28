-----
WagesAdjustBoxCtrl = class('WagesAdjustBoxCtrl',UIPage)
UIPage:ResgisterOpen(WagesAdjustBoxCtrl)

function WagesAdjustBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function WagesAdjustBoxCtrl:bundleName()
    return "WagesAdjustBoxPanel"
end

function WagesAdjustBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function WagesAdjustBoxCtrl:Awake(go)
    self:_getComponent(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject, self._onClickConfim, self)
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
    self.wageInput.onValueChanged:AddListener(function(value)
        local blackColor = "#4B4B4B"
        local perWageStr = string.format("%s<color=%s>%s</color>", getPriceString(value, 24, 18), blackColor, "/D")
        self.perWageText.text = perWageStr

        local totalWageStr = string.format("%s<color=%s>%s</color>", getPriceString(value * self.m_data.workerNum, 24, 18), blackColor, "/D")
        self.totalWageText.text = totalWageStr
    end)
end

function WagesAdjustBoxCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function WagesAdjustBoxCtrl:Refresh()
    self:_initData()
end

--function WagesAdjustBoxCtrl:Hide()
--    --UIPage:Hide()
--    self.luaBehaviour:RemoveClick(self.confirmBtn.gameObject, self._onClickConfim, self)
--    self.luaBehaviour:RemoveClick(self.closeBtn.gameObject, self._onClickClose, self)
--end

---寻找组件
function WagesAdjustBoxCtrl:_getComponent(go)
    self.confirmBtn = go.transform:Find("root/confirmBtn")
    self.closeBtn = go.transform:Find("root/closeBtn")
    self.perWageText = go.transform:Find("root/wage/perWageText"):GetComponent("Text")
    self.totalWageText = go.transform:Find("root/wage/totalWageText"):GetComponent("Text")

    self.wageInput = go.transform:Find("root/wageInput"):GetComponent("InputField")
end
---初始化
function WagesAdjustBoxCtrl:_initData()
    local dayWage = self.m_data.dayWage or 0
    local workerNum = self.m_data.workerNum or 0

    local blackColor = "#4B4B4B"
    local perWageStr = string.format("%s<color=%s>%s</color>", getPriceString(dayWage, 24, 18), blackColor, "/D")
    self.perWageText.text = perWageStr

    local totalWageStr = string.format("%s<color=%s>%s</color>", getPriceString(dayWage * workerNum, 24, 18), blackColor, "/D")
    self.totalWageText.text = totalWageStr
end

function WagesAdjustBoxCtrl:_onClickConfim(ins)
    local inputValue = ins.wageInput.text
    if inputValue == "" then
        return
    end

    if ins.m_data.callBackFunc then
        ins.m_data.callBackFunc()
    end
    ins:_onClickClose(ins)
end
function WagesAdjustBoxCtrl:_onClickClose(ins)
    ins:Hide()
end