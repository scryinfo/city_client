-----
WagesAdjustBoxCtrl = class('WagesAdjustBoxCtrl',UIPage)
UIPage:ResgisterOpen(WagesAdjustBoxCtrl)

function WagesAdjustBoxCtrl:initialize()
    UIPage.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function WagesAdjustBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WagesAdjustBoxPanel.prefab"
end

function WagesAdjustBoxCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
    obj.transform:SetAsFirstSibling()
end

function WagesAdjustBoxCtrl:Awake(go)
    self:_getComponent(go)
    self.luaBehaviour = go:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject, self._onClickConfim, self)
    self.luaBehaviour:AddClick(self.closeBtn.gameObject, self._onClickClose, self)
    self.wageInput.onValueChanged:AddListener(function(value)

        if self.wageInput.text=="" then
            return
        end

        local blackColor = "#4B4B4B"
        local perWageStr = string.format("%s<color=%s>%s</color>", getPriceString(value, 24, 18), blackColor, "/D")
        self.perWageText.text = perWageStr

        local totalWageStr = string.format("%s<color=%s>%s</color>", getPriceString(value * self.m_data.workerNum, 24, 18), blackColor, "/D")
        self.totalWageText.text = totalWageStr
    end)

    Event.AddListener("mCloes",self.mCloes,self)

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

    local m_data=ins.m_data
    local data={}
    data.type="begin"
    data.mainText="Processing plant successfully opened"
    data.callback=function()
                     Event.Brocast("m_ReqHouseSetSalary1",m_data.buildInfo.id,100)
                     Event.Brocast("m_startBusiness",m_data.buildInfo.id)
                     Event.Brocast("mCloes")
                     --m_data:func()
                     --Event.Brocast("SmallPop","Success",300)
                   end
    ct.OpenCtrl("ReminderCtrl",data)
  
end

function WagesAdjustBoxCtrl:_onClickClose(ins)
     ins:Hide()
end

function  WagesAdjustBoxCtrl:mCloes()
    self:Hide()
end