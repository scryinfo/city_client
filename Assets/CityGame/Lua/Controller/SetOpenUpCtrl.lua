---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/3 18:02
---Advertising companies open to the outside world to set up panels
SetOpenUpCtrl = class('SetOpenUpCtrl',UIPanel)
UIPanel:ResgisterOpen(SetOpenUpCtrl)

local setOpenUpBehaviour

function SetOpenUpCtrl:bundleName()
    return "Assets/CityGame/Resources/View/SetOpenUpPanel.prefab"
end

function SetOpenUpCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--You can go back and hide other panels after the UI opens
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--Can go back, after the UI is opened, other UI is not hidden
end
function SetOpenUpCtrl:Awake()
    setOpenUpBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.xBtn,self.OnxBtn,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.confirm,self.OnConfirm,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.infoBtn,self.OnInfoBtn,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.closeTooltip,self.OnCloseTooltip,self);

    self.myOwnerID = DataManager.GetMyOwnerID()

    SetOpenUpPanel.open.onValueChanged:AddListener(function(isOn)
        self:OnOpen(isOn)
    end)
    SetOpenUpPanel.price.onValueChanged:AddListener(function()
        self:OnPrice(self)
    end)
    self:initData()
end

function SetOpenUpCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_CloseSetOpenUp",self.c_CloseSetOpenUp,self)
    Event.AddListener("c_GuidePrice",self.GuidePrice,self)
    if self.m_data.takeOnNewOrder then
        SetOpenUpPanel.price.text = GetClientPriceString(self.m_data.curPromPricePerHour)
        SetOpenUpPanel.time.text = math.floor(self.m_data.promRemainTime/3600000)
    end

    SetOpenUpPanel.name.text = GetLanguage(27040010)
    SetOpenUpPanel.external.text = GetLanguage(27040002)
    SetOpenUpPanel.pricePlaceholder.text = GetLanguage(27040012)
    SetOpenUpPanel.timePlaceholder.text = GetLanguage(27040011)
    SetOpenUpPanel.closeText.text = GetLanguage(27040001)
    SetOpenUpPanel.conpetitivebessText.text = GetLanguage(43010001)
    SetOpenUpPanel.title.text = GetLanguage(43060001)
    SetOpenUpPanel.content.text = GetLanguage(43060002)
end

function SetOpenUpCtrl:Refresh()
    self.openUp = self.m_data.takeOnNewOrder
    if self.openUp then
        SetOpenUpPanel.conpetitivebess.localScale = Vector3.one
        SetOpenUpPanel.open.isOn = true
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(88, 0, 0)
        SetOpenUpPanel.close.localScale = Vector3.zero
    else
        SetOpenUpPanel.conpetitivebess.localScale = Vector3.zero
        SetOpenUpPanel.open.isOn = false
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(2, 0, 0)
        SetOpenUpPanel.close.localScale = Vector3.one
    end
end

function SetOpenUpCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_CloseSetOpenUp",self.c_CloseSetOpenUp,self)
    Event.RemoveListener("c_GuidePrice",self.GuidePrice,self)
    SetOpenUpPanel.time.text = ""
end

function SetOpenUpCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function SetOpenUpCtrl:initData()
end

function SetOpenUpCtrl:OnxBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

--Open to the outside world
function SetOpenUpCtrl:OnOpen(isOn)
    PlayMusEff(1002)
    self.openUp = isOn
    if isOn then
        SetOpenUpPanel.conpetitivebess.localScale = Vector3.one
        --SetOpenUpPanel.openBtn:DOMove(Vector3.New(88,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(88,0,0)
        SetOpenUpPanel.close.localScale = Vector3.zero
        if not self.m_data.takeOnNewOrder then
            SetOpenUpPanel.price.text = GetClientPriceString(ct.CalculationPromoteSuggestPrice(self.m_data.guidePrice, self.m_data.RDAbility, self.m_data.averageRDAbility))
        end
    else
        SetOpenUpPanel.conpetitivebess.localScale = Vector3.zero
        --SetOpenUpPanel.openBtn:DOMove(Vector3.New(2,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(2,0,0)
        SetOpenUpPanel.close.localScale = Vector3.one
    end
end

--Enter price
function SetOpenUpCtrl:OnPrice()
    if SetOpenUpPanel.price.text == "" then
       return
    end
    if string.find(SetOpenUpPanel.price.text, '%.') == nil then
        SetOpenUpPanel.price.text = tonumber(SetOpenUpPanel.price.text)
    else
        SetOpenUpPanel.price.text = radixPointNum(SetOpenUpPanel.price.text,4)
    end
    local price = SetOpenUpPanel.price.text
    SetOpenUpPanel.value.text = ct.CalculationAdvertisementCompetitivePower(self.m_data.guidePrice,GetServerPriceNumber(price), self.m_data.RDAbility ,2251, self.m_data.averageRDAbility)
    --DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_promotionGuidePrice',self.m_data.insId,self.myOwnerID) --Get recommended price
    self.m_data.openOtherText.text = SetOpenUpPanel.value.text
end

--Click determine
function SetOpenUpCtrl:OnConfirm(go)
    PlayMusEff(1002)
    if go.openUp then
        if SetOpenUpPanel.price.text == "" or SetOpenUpPanel.time.text == "" then
            Event.Brocast("SmallPop",GetLanguage(27040029),300)
            return
        end
        if tonumber(SetOpenUpPanel.time.text ) == 0 then
            Event.Brocast("SmallPop",GetLanguage(27040027),300)
        else
            local price = tonumber(SetOpenUpPanel.price.text)
            local time = tonumber(SetOpenUpPanel.time.text)
            DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_PromotionSetting',go.m_data.insId,true,price,time)
        end
    else
        if not go.m_data.takeOnNewOrder then
            UIPanel.ClosePage()
        else
            if  SetOpenUpPanel.time.text == "" then
                SetOpenUpPanel.time.text = 0
            else
                DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_PromotionSetting',go.m_data.insId,false,0, 0)
            end
        end
    end
end

function SetOpenUpCtrl:OnInfoBtn()
    SetOpenUpPanel.tooltip.gameObject:SetActive(true)
    SetOpenUpPanel.closeTooltip.transform.localScale = Vector3.one
end

function SetOpenUpCtrl:OnCloseTooltip()
    SetOpenUpPanel.tooltip.gameObject:SetActive(false)
    SetOpenUpPanel.closeTooltip.transform.localScale = Vector3.zero
end

--Close the interface
function SetOpenUpCtrl:c_CloseSetOpenUp()
    UIPanel.ClosePage()
end

--Competitiveness
function SetOpenUpCtrl:GuidePrice(info)
    local value = info.proPrice[1].guidePrice
    local curAbilitys = 0
    if  info.proPrice[1].curAbilitys then
        for i, v in pairs(info.proPrice[1].curAbilitys) do
            curAbilitys = curAbilitys + v
        end
        curAbilitys = curAbilitys / #info.proPrice[1].curAbilitys
    end
    local competitive = ct.CalculationAdvertisementCompetitivePower(value,self.price,curAbilitys,2251)
    SetOpenUpPanel.value.text = competitive
end