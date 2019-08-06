---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/27 11:29
--- 使用数据面板
UserDataCtrl = class('UserDataCtrl',UIPanel)
UIPanel:ResgisterOpen(UserDataCtrl)

local userDataCtrlBehaviour
function UserDataCtrl:bundleName()
    return "Assets/CityGame/Resources/View/UserDataPanel.prefab"
end

function UserDataCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)
end

function UserDataCtrl:Awake(go)
    self:_getComponent(go)
    userDataCtrlBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    userDataCtrlBehaviour:AddClick(self.bg,self.OnBg,self)
    userDataCtrlBehaviour:AddClick(self.btn,self.OnBtn,self)
    userDataCtrlBehaviour:AddClick(self.buyBtn,self.OnBuyBtn,self)

    self.input.onValueChanged:AddListener(function()
        self:OnInput()
    end)
    self.slider.onValueChanged:AddListener(function()
        self:OnSlider()
    end)
end

function UserDataCtrl:Active()
    UIPanel.Active(self)
    self.title = GetLanguage(24020009)
end

function UserDataCtrl:Refresh()
    self:initData()
end

function UserDataCtrl:Hide()
    UIPanel.Hide(self)
    self.input.text = "0"
    self.slider.value = 0
end

function UserDataCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

--获取组件
function UserDataCtrl:_getComponent(go)
    self.bg = go.transform:Find("bg").gameObject
    self.title = go.transform:Find("content/title"):GetComponent("Text")
    self.baseBg = go.transform:Find("content/top/bg/base")
    self.base = go.transform:Find("content/top/bg/base/Text"):GetComponent("Text")
    self.saleBg = go.transform:Find("content/top/bg/sale")
    self.sale = go.transform:Find("content/top/bg/sale/Text"):GetComponent("Text")
    self.dataName = go.transform:Find("content/top/bg/barnd/Text"):GetComponent("Text")
    self.impact = go.transform:Find("content/top/bg/Text"):GetComponent("Text")
    self.name = go.transform:Find("content/top/card/name/Text"):GetComponent("Text")
    self.icon = go.transform:Find("content/top/card/cardImage/Image"):GetComponent("Image")
    self.quantity = go.transform:Find("content/quantity"):GetComponent("Text")
    self.inputBg = go.transform:Find("content/quantity/inputBg")
    self.input = go.transform:Find("content/quantity/inputBg/input"):GetComponent("InputField")
    self.buyInputBg = go.transform:Find("content/quantity/buyInputBg")
    self.buyInput = go.transform:Find("content/quantity/buyInputBg/input"):GetComponent("InputField")
    self.slider = go.transform:Find("content/quantity/inputBg/input/Slider"):GetComponent("Slider")
    self.btn =  go.transform:Find("content/quantity/inputBg/btn").gameObject
    self.btnText =  go.transform:Find("content/quantity/inputBg/btn/Text"):GetComponent("Text")
    self.buyBtn =  go.transform:Find("content/quantity/buyInputBg/buyBtn").gameObject
    self.buyBtnText =  go.transform:Find("content/quantity/buyInputBg/buyBtn/Text"):GetComponent("Text")
end

--初始化数据
function UserDataCtrl:initData()
    if self.m_data.myOwner then
        --self.btnText = GetLanguage()
        self.btn.transform.localScale = Vector3.one
        self.buyInputBg.localScale = Vector3.zero
        self.baseBg.localScale = Vector3.one
        self.saleBg.localScale = Vector3.one
        self.base.text = "x" .. self.m_data.wareHouse
        self.sale.text = "x" .. self.m_data.sale
        self.slider.maxValue = self.m_data.wareHouse
    else
        --self.btnText = GetLanguage()
        self.btn.transform.localScale = Vector3.zero
        self.buyInputBg.localScale = Vector3.one
        self.baseBg.localScale = Vector3.zero
        self.saleBg.localScale = Vector3.zero
        self.slider.maxValue = self.m_data.sale
    end
    LoadSprite(ResearchConfig[self.m_data.itemId].iconPath, self.icon, true)
end

--返回
function UserDataCtrl:OnBg()
    UIPanel.ClosePage()
end

function UserDataCtrl:OnInput()
    if self.input.text == "" then
        return
    end
    self.input.text = tonumber(self.input.text)
    if self.m_data.myOwner then
        if tonumber(self.input.text) > self.m_data.wareHouse then
            self.input.text = self.m_data.wareHouse
        end
    else
       if tonumber(self.input.text) > self.m_data.sale then
            self.input.text = self.m_data.sale
        end
    end
    self.slider.value = tonumber(self.input.text)
    if self.m_data.myOwner == false then
        self.buyInput.text = self.slider.value * self.m_data.price
    end
end

function UserDataCtrl:OnSlider()
    self.input.text = self.slider.value
    if self.m_data.myOwner then
        if tonumber(self.input.text) > self.m_data.wareHouse then
            self.input.text = self.m_data.wareHouse
        end
    else
        if tonumber(self.input.text) > self.m_data.sale then
            self.input.text = self.m_data.sale
        end
    end
end

function UserDataCtrl:OnBtn(go)
    if go.slider.value == 0 then
        Event.Brocast("SmallPop","请输入使用数量",ReminderType.Warning)
        return
    end
    if go.m_data.userFunc then
        go.m_data.userFunc(go.slider.value)
        go.m_data.userFunc = nil
    end
end

function UserDataCtrl:OnBuyBtn(go)
    if go.slider.value == 0 then
        Event.Brocast("SmallPop","请输入使用数量",ReminderType.Warning)
        return
    end
    if go.m_data.buyFunc then
        go.m_data.buyFunc(go.slider.value,go.slider.value * go.m_data.price)
        go.m_data.buyFunc = nil
    end
end