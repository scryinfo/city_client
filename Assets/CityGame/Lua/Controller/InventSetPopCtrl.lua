
InventSetPopCtrl = class('InventSetPopCtrl',UIPanel)
UIPanel:ResgisterOpen(InventSetPopCtrl) --How to open the registration
---====================================================================================Frame function==============================================================================================
local panel

function InventSetPopCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function InventSetPopCtrl:bundleName()
    return "Assets/CityGame/Resources/View/InventSetPopPanel.prefab";
end
function InventSetPopCtrl:Active()
    UIPanel.Active(self)
end

function InventSetPopCtrl:Refresh()
    local data = self.m_data.ins.m_data

    self:updateText(data)
    self:UpDateUI(data)
end

function InventSetPopCtrl:Awake(go)
    panel = InventSetPopPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')

    LuaBehaviour:AddClick(panel.xBtn,self.OnxBtn,self)
    LuaBehaviour:AddClick(panel.confirm,self.OnConfirm,self)
    --LuaBehaviour:AddClick(panel.infoBtn,self.OnInfo,self)
    LuaBehaviour:AddClick(panel.infoBtn,function ()
        InventSetPopPanel.tooltip.localScale = Vector3.one
        InventSetPopPanel.title.text = GetLanguage(43050001)
        InventSetPopPanel.content.text = GetLanguage(43050002)
    end ,self)
    LuaBehaviour:AddClick(panel.infoCloseBtn,function ()
        InventSetPopPanel.title.text = ""
        InventSetPopPanel.content.text = ""
        InventSetPopPanel.tooltip.localScale = Vector3.zero
    end ,self)

    panel.open.onValueChanged:AddListener(function(isOn)
        self:OnOpen(isOn)
    end)
    InventSetPopPanel.price.onValueChanged:AddListener(function()
        self:OnPrice(self)
    end)
end

function InventSetPopCtrl:Hide()
    UIPanel.Hide(self)
end

---====================================================================================Click function==============================================================================================

--set
function InventSetPopCtrl:OnConfirm(ins)

    local isopen =  panel.open.isOn
    if isopen then
        if panel.price.text == "" or panel.time.text == "" or panel.price.text == "0" or panel.time.text == "0" then
            Event.Brocast("SmallPop","时间或价格不能为空",300)
            return
        end

        local price = GetServerPriceNumber(panel.price.text)
        local count = tonumber(panel.time.text)
        --Event.Brocast("c_UpdateInventSet",count,price)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSettings',isopen)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSetting',price,count)
    else
        --Event.Brocast("c_UpdateInventSet",0,0)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSettings',isopen)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSetting', 0, 0)
    end
    UIPanel.ClosePage()
end

function InventSetPopCtrl:OnxBtn()
    UIPanel.ClosePage()
end

function InventSetPopCtrl:OnInfo(go)
    if go.isOpenTips then
        go.isOpenTips = false
        InventSetPopPanel.tooltip.localScale = Vector3.zero
    else
        go.isOpenTips = true
        InventSetPopPanel.tooltip.localScale = Vector3.one
    end
end

---====================================================================================Business logic==============================================================================================


function InventSetPopCtrl:updateText(data)
    -- panel.mainText.text = GetLanguage(40010009)
    panel.referencePrice.text = data.recommendPrice
    panel.pricee.text = GetLanguage(27040012)
    panel.timee.text = GetLanguage(28040047)
    panel.name.text = GetLanguage(27040010)
    panel.external.text = GetLanguage(27040002)
    panel.closeText.text = GetLanguage(27040001)
    panel.conpetitivebessText.text = GetLanguage(43010001)
    --panel.title.text = GetLanguage(43050001)
    --panel.content.text = GetLanguage(43050002)
end

function InventSetPopCtrl:UpDateUI(data)
    panel.time.text = ""
    self.isOpenTips = true
    self:OnInfo(self)

    self.openUp =  not data.exclusive

    if panel.open.isOn == self.openUp then
        self:OnOpen(self.openUp)
    end

    if self.openUp then
        panel.open.isOn = true
        panel.openBtn.anchoredPosition = Vector3.New(88, 0, 0)
        panel.close.localScale = Vector3.zero
    else
        panel.open.isOn = false
        panel.price.text = "0"
        panel.openBtn.anchoredPosition = Vector3.New(2, 0, 0)
        panel.close.localScale = Vector3.one
    end
end

--Open to the outside world
function InventSetPopCtrl:OnOpen(isOn)
    if isOn then
        InventSetPopPanel.conpetitivebess.localScale = Vector3.one
        panel.openBtn.anchoredPosition = Vector3.New(88,0,0)
        panel.close.localScale = Vector3.zero
        if self.m_data.ins.m_data.pricePreTime > 0 then
            panel.price.text = GetClientPriceString(self.m_data.ins.m_data.pricePreTime)
        else
            panel.price.text = GetClientPriceString(ct.CalculationLaboratorySuggestPrice(self.m_data.ins.m_data.guidePrice, self.m_data.ins.m_data.RDAbility,self.m_data.ins.m_data.averageRDAbility))
        end
    else
        InventSetPopPanel.conpetitivebess.localScale = Vector3.zero
        panel.openBtn.anchoredPosition = Vector3.New(2,0,0)
        panel.close.localScale = Vector3.one
    end
end

--Enter price
function InventSetPopCtrl:OnPrice()
    if InventSetPopPanel.price.text == "" then
        InventSetPopPanel.price.text = 0
    end
    local temp = InventSetPopPanel.price.text
    InventSetPopPanel.value.text = ct.CalculationLaboratoryCompetitivePower(self.m_data.ins.m_data.guidePrice, GetServerPriceNumber(temp), self.m_data.ins.m_data.RDAbility,self.m_data.ins.m_data.averageRDAbility)
end