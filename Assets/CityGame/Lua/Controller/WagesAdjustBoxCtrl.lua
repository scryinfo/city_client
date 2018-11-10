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
end

function WagesAdjustBoxCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function WagesAdjustBoxCtrl:Refresh()
    self:_initData()
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject, self._onClickConfim, self)
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
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
    self.noDomicileRoot = go.transform:Find("root/noDomicileRoot")  --如果有未找到房子的npc，则需要显示
    self.noDomicileNumText = go.transform:Find("root/noDomicileRoot/noDomicileNumText"):GetComponent("Text")
    self.perWageText = go.transform:Find("root/wage/perWageText"):GetComponent("Text")
    self.totalWageText = go.transform:Find("root/wage/totalWageText"):GetComponent("Text")

    self.wageInput = go.transform:Find("root/wageInput"):GetComponent("InputField")
    self.suggestRect = go.transform:Find("root/suggestRect"):GetComponent("RectTransform")
    self.suggestRentalText = go.transform:Find("root/suggestRentalText"):GetComponent("Text")
    self.effectiveDateText = go.transform:Find("root/effectiveDateText"):GetComponent("Text")
    self.satisfactionSlider = go.transform:Find("root/satisfactionSlider"):GetComponent("Slider")
    self.satisfactionText = go.transform:Find("root/satisfactionSlider/FillArea/Fill/number"):GetComponent("Text")
    self.satisfactionStopTran = go.transform:Find("root/satisfactionSlider/stop")
end
---初始化
function WagesAdjustBoxCtrl:_initData()
    if self.m_data.noDomicileCount > 0 then
        self.noDomicileRoot.localScale = Vector3.one
        self.noDomicileNumText.text = string.format("%d<color=white>/%d</color>", self.m_data.noDomicileCount, self.m_data.totalStaffCount)
    else
        self.noDomicileRoot.localScale = Vector3.zero
    end

    local blackColor = "#4B4B4B"
    local perWageStr = string.format("%s<color=%s>%s</color>", getPriceString(self.m_data.dayWage, 24, 18), blackColor, "/D")
    self.perWageText.text = perWageStr

    local totalWageStr = string.format("%s<color=%s>%s</color>", getPriceString(self.m_data.dayWage * self.m_data.totalStaffCount, 24, 18), blackColor, "/D")
    self.totalWageText.text = totalWageStr

    local suggestStr = string.format("%sE<color=%s>%s</color>", getPriceString(self.m_data.dayWage, 20, 18), blackColor, "/D")
    self.suggestRentalText.text = suggestStr

    local trueTextW = self.suggestRentalText.preferredWidth
    local pos = self.suggestRect.anchoredPosition
    self.suggestRect.anchoredPosition = Vector2.New(70 + 164 - trueTextW, pos.y)

    self.satisfactionText.text = self.m_data.satisfaction
    if self.m_data.satisfaction <= 0.3 then
        self.satisfactionStopTran.localScale = Vector3.one
    else
        self.satisfactionStopTran.localScale = Vector3.zero
    end
    self.satisfactionText.text = self.m_data.satisfaction
    self.satisfactionSlider.value = self.m_data.satisfaction
    self.effectiveDateText.text = self.m_data.effectiveDate
end

function WagesAdjustBoxCtrl:_onClickConfim(ins)
    local inputValue = ins.wageInput.text
    if inputValue == "" then
        return
    end

    Event.Brocast("m_ReqHouseSetSalary", ins.m_data.buildingId, inputValue)
    ins:_onClickClose(ins)
end
function WagesAdjustBoxCtrl:_onClickClose(ins)
    ins:Hide()
    ins.luaBehaviour:RemoveClick(ins.confirmBtn.gameObject, ins._onClickConfim, ins)
    ins.luaBehaviour:RemoveClick(ins.closeBtn.gameObject, ins._onClickClose, ins)
end