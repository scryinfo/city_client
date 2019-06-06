---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/3 18:02
---广告公司对外开放设置面板
SetOpenUpCtrl = class('SetOpenUpCtrl',UIPanel)
UIPanel:ResgisterOpen(SetOpenUpCtrl)

local setOpenUpBehaviour

function SetOpenUpCtrl:bundleName()
    return "Assets/CityGame/Resources/View/SetOpenUpPanel.prefab"
end

function SetOpenUpCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function SetOpenUpCtrl:Awake()
    setOpenUpBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.xBtn,self.OnxBtn,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.confirm,self.OnConfirm,self);
    SetOpenUpPanel.open.onValueChanged:AddListener(function(isOn)
        self:OnOpen(isOn)
    end)
    self:initData()
end

function SetOpenUpCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_CloseSetOpenUp",self.c_CloseSetOpenUp,self)
    if self.m_data.takeOnNewOrder then
        SetOpenUpPanel.price.text = GetClientPriceString(self.m_data.curPromPricePerHour)
        SetOpenUpPanel.time.text = math.floor(self.m_data.promRemainTime/3600000)
    end

    SetOpenUpPanel.name.text = GetLanguage(27040010)
    SetOpenUpPanel.external.text = GetLanguage(27040002)
    SetOpenUpPanel.pricePlaceholder.text = GetLanguage(27040012)
    SetOpenUpPanel.timePlaceholder.text = GetLanguage(27040011)
    SetOpenUpPanel.closeText.text = GetLanguage(27040001)
end

function SetOpenUpCtrl:Refresh()
    self.openUp = self.m_data.takeOnNewOrder
    if self.openUp then
        SetOpenUpPanel.open.isOn = true
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(88, 0, 0)
        SetOpenUpPanel.close.localScale = Vector3.zero
    else
        SetOpenUpPanel.open.isOn = false
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(2, 0, 0)
        SetOpenUpPanel.close.localScale = Vector3.one
    end
end

function SetOpenUpCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_CloseSetOpenUp",self.c_CloseSetOpenUp,self)
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

--对外开放
function SetOpenUpCtrl:OnOpen(isOn)
    PlayMusEff(1002)
    self.openUp = isOn
    if isOn then
        --SetOpenUpPanel.openBtn:DOMove(Vector3.New(88,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(88,0,0)
        SetOpenUpPanel.close.localScale = Vector3.zero
    else
        --SetOpenUpPanel.openBtn:DOMove(Vector3.New(2,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        SetOpenUpPanel.openBtn.anchoredPosition = Vector3.New(2,0,0)
        SetOpenUpPanel.close.localScale = Vector3.one
    end
end

--点击确定
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
                DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_PromotionSetting',go.m_data.insId,false,tonumber(SetOpenUpPanel.price.text), tonumber(SetOpenUpPanel.time.text))
            end
        end
    end
end

--关闭界面
function SetOpenUpCtrl:c_CloseSetOpenUp()
    UIPanel.ClosePage()
end