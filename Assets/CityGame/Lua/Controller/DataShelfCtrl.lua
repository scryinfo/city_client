---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/2 18:14
--- 数据公司上架界面
DataShelfCtrl = class('DataShelfCtrl',UIPanel)
UIPanel:ResgisterOpen(DataShelfCtrl)

local shelfBehaviour
function DataShelfCtrl:bundleName()
    return "Assets/CityGame/Resources/View/DataShelfPanel.prefab"
end

function DataShelfCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function DataShelfCtrl:Awake(obj)
    self:_getComponent(obj)
    shelfBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    shelfBehaviour:AddClick(self.back,self.OnBack,self)
    shelfBehaviour:AddClick(self.tipBtn,self.OnTipBtn,self)    --自动补货介绍
    shelfBehaviour:AddClick(self.competitivenessBtn,self.OnCompetitivenessBtn,self)    --竞争力介绍
    shelfBehaviour:AddClick(self.downShelfBtn,self.OnDownShelfBtn,self)    --下架
    shelfBehaviour:AddClick(self.addShelfBtn,self.OnAddShelfBtn,self)    --上架
    shelfBehaviour:AddClick(self.confirmBtn,self.OnConfirmBtn,self)    --修改货架
    shelfBehaviour:AddClick(self.close,self.OnClose,self)

    Event.AddListener("c_DelShelf",self.c_DelShelf,self)

    self.automaticSwitch.onValueChanged:AddListener(function(isOn)     --自动补货
        self:OnAutomaticSwitch(isOn)
    end)
    self.inputNum.onValueChanged:AddListener(function()     --数量
        self:OnInputNum()
    end)
    self.sliderNum.onValueChanged:AddListener(function()     --数量
        self:OnSliderNum()
    end)
end

function DataShelfCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_RecommendPrice",self.c_RecommendPrice,self)
    self.competitivenessTipText.text = GetLanguage(43060001)
    self.competitivenessContentText.text = GetLanguage(43060002)
    self.tipText.text = GetLanguage(25020027)
    self.name.text = GetLanguage(27060006)
    self.explain.text = GetLanguage(ResearchConfig[self.m_data.itemId].content)
    self.replenishment.text = GetLanguage(27060009)
    self.numText.text = GetLanguage(27060008)
    self.competitiveness.text = GetLanguage(27060015)
    self.price.text = GetLanguage(27060010)
    self.recommend.text = GetLanguage(27060016)
    self.addShelfText.text = GetLanguage(27060017)
    self.shelfText.text = GetLanguage(27060013)
end

function DataShelfCtrl:Refresh()
    self:initData()
end

function DataShelfCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_RecommendPrice",self.c_RecommendPrice,self)
    self.inputNum.text = ""
    self.sliderNum.value = 0
    self.inputPrice.text = ""
    self.sliderPrice.value = 0
end

function DataShelfCtrl:Close()
    Event.RemoveListener("c_DelShelf",self,c_DelShelf,self)
end

function DataShelfCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

--获取组件
function DataShelfCtrl:_getComponent(go)
    self.back = go.transform:Find("bgBtn").gameObject
    self.name = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    self.explain = go.transform:Find("contentRoot/content/goodsInfo/bg/Text"):GetComponent("Text")
    self.base = go.transform:Find("contentRoot/content/goodsInfo/bg/base/Text"):GetComponent("Text")
    self.sale = go.transform:Find("contentRoot/content/goodsInfo/bg/sale/Text"):GetComponent("Text")
    self.iconName = go.transform:Find("contentRoot/content/goodsInfo/card/name/Text"):GetComponent("Text")
    self.icon = go.transform:Find("contentRoot/content/goodsInfo/card/cardImage/Image"):GetComponent("Image")
    self.automaticSwitch = go.transform:Find("contentRoot/content/detailsInfo/automaticSwitch"):GetComponent("Toggle") --自动补货
    self.automaticSwitchBtn = go.transform:Find("contentRoot/content/detailsInfo/automaticSwitch/btnImage"):GetComponent("RectTransform")
    self.replenishment = go.transform:Find("contentRoot/content/detailsInfo/tipText"):GetComponent("Text")
    self.numText = go.transform:Find("contentRoot/content/detailsInfo/totalNumber"):GetComponent("Text")
    self.totalNum = go.transform:Find("contentRoot/content/detailsInfo/totalNumber/bg/totalNumberText"):GetComponent("Text")
    self.totalBg = go.transform:Find("contentRoot/content/detailsInfo/totalNumber/bg")
    self.inputNum = go.transform:Find("contentRoot/content/detailsInfo/numberInput"):GetComponent("InputField")
    self.tipBtn = go.transform:Find("contentRoot/content/detailsInfo/tipBtn").gameObject
    self.tipBg = go.transform:Find("contentRoot/content/detailsInfo/tipBtn/tipBg")
    self.tipText = go.transform:Find("contentRoot/content/detailsInfo/tipBtn/tipBg/Text"):GetComponent("Text")
    self.sliderNum = go.transform:Find("contentRoot/content/detailsInfo/numberSlider"):GetComponent("Slider")
    self.competitiveness = go.transform:Find("contentRoot/content/detailsInfo/Text"):GetComponent("Text")
    self.competitivenessText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/priceText"):GetComponent("Text")
    self.competitivenessBtn = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBtn").gameObject
    self.competitivenessTip = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBgBtn").gameObject
    self.competitivenessTipText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBgBtn/tipText"):GetComponent("Text")
    self.competitivenessContentText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBgBtn/content"):GetComponent("Text")
    self.price = go.transform:Find("contentRoot/content/detailsInfo/price"):GetComponent("Text")
    self.inputPrice = go.transform:Find("contentRoot/content/detailsInfo/priceInput"):GetComponent("InputField")
    self.sliderPrice = go.transform:Find("contentRoot/content/detailsInfo/competitivenessSlider"):GetComponent("Slider")
    self.recommend = go.transform:Find("contentRoot/content/detailsInfo/competitivenessSlider/FillArea/line/Image/Text"):GetComponent("Text")
    self.recommendValue = go.transform:Find("contentRoot/content/detailsInfo/competitivenessSlider/FillArea/line/Image/Text/value"):GetComponent("Text")
    self.downShelfBtn = go.transform:Find("contentRoot/bottom/downShelfBtn").gameObject    --下架
    self.shelfText = go.transform:Find("contentRoot/bottom/downShelfBtn/text"):GetComponent("Text")
    self.addShelfBtn = go.transform:Find("contentRoot/bottom/addShelfBtn").gameObject    --上架
    self.addShelfText = go.transform:Find("contentRoot/bottom/addShelfBtn/text"):GetComponent("Text")
    self.confirmBtn = go.transform:Find("contentRoot/bottom/confirmBtn").gameObject     --修改货架
    self.close = go.transform:Find("close").gameObject     --修改货架

    self.recommendValue.text = 50
    self:_awakeSliderInput()
end

--滑动条input联动
function DataShelfCtrl:_awakeSliderInput()
    self.inputPrice.onValueChanged:AddListener(function (str)
        if str == "" or self.guidePrice == nil then
            return
        end
        local finalStr = ct.getCorrectPrice(str)
        if finalStr ~= str then
            self.inputPrice.text = finalStr  --限制用户小数输入
            return
        end
        local temp = ct.CalculationAdvertisementCompetitivePower(self.guidePrice, tonumber(str) * 10000, self.m_data.itemId)  --计算竞争力
        if temp >= functions.maxCompetitive then
            self.competitivenessText.text = ">"..temp
        elseif temp <= functions.minCompetitive then
            self.competitivenessText.text = "<"..temp
        else
            self.competitivenessText.text = string.format("%0.1f", temp)
        end
        DataShelfCtrl.sliderCanChange = false  --当input输入时，禁用slider
        self.sliderPrice.value = temp
    end)
    --
    EventTriggerMgr.Get(self.sliderPrice.gameObject).onSelect = function()
        DataShelfCtrl.sliderCanChange = true
    end
    EventTriggerMgr.Get(self.sliderPrice.gameObject).onUpdateSelected = function()  --当slider被选中，则可以改变input的值
        DataShelfCtrl.sliderCanChange = true
    end
    self.sliderPrice.onValueChanged:AddListener(function (value)
        if self.guidePrice == nil or DataShelfCtrl.sliderCanChange ~= true then
            return
        end
        local price = ct.CalculationPromoteSuggestPrice(self.guidePrice, value)
        self.inputPrice.text = GetClientPriceString(price)
    end)
end

--初始化数据
function DataShelfCtrl:initData()
    LoadSprite(ResearchConfig[self.m_data.itemId].iconPath, self.icon, true)
    self.iconName.text = GetLanguage(ResearchConfig[self.m_data.itemId].name)
    self.base.text = "x" .. self.m_data.wareHouse
    self.sale.text = "x" .. self.m_data.sale
    self.sliderNum.maxValue = self.m_data.wareHouse + self.m_data.sale
    self.sliderPrice.maxValue = 99
    DataManager.DetailModelRpcNoRet(self.m_data.building, 'm_recommendPrice',self.m_data.building,DataManager.GetMyOwnerID(),self.m_data.itemId)
    if self.m_data.shelf == Shelf.AddShelf then
        self.addShelfBtn.transform.localScale = Vector3.one
        self.confirmBtn.transform.localScale = Vector3.zero
        self.automaticSwitch.isOn = false
        self.isOn = false
        self.downShelfBtn.transform.localScale = Vector3.zero
    elseif self.m_data.shelf == Shelf.SetShelf then
        self.addShelfBtn.transform.localScale = Vector3.zero
        self.confirmBtn.transform.localScale = Vector3.one
        self.automaticSwitch.isOn = self.m_data.autoReplenish
        self.isOn = self.m_data.autoReplenish
        if self.isOn then
            self.automaticSwitchBtn.localPosition = Vector3.New(45,0,0)
            self.totalNum.text =  self.m_data.wareHouse + self.m_data.sale
        else
            self.automaticSwitchBtn.localPosition = Vector3.New(-45,0,0)
        end
        self.inputNum.text = self.m_data.sale
        self.sliderNum.value = self.m_data.sale
        self.downShelfBtn.transform.localScale = Vector3.one
    end
end

--返回
function DataShelfCtrl:OnBack()
    UIPanel.ClosePage()
end

--自动补货介绍
function DataShelfCtrl:OnTipBtn(go)
    go.tipBg.localScale = Vector3.one
    go.close.transform.localScale = Vector3.one
end

--竞争力介绍
function DataShelfCtrl:OnCompetitivenessBtn(go)
    go.competitivenessTip:SetActive(true)
    go.close.transform.localScale = Vector3.one
end

--下架
function DataShelfCtrl:OnDownShelfBtn(go)
    local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.Select,
                content = GetLanguage(25060017),func = function()
            DataManager.DetailModelRpcNoRet(go.m_data.building, 'm_delShelf',go.m_data.building,go.m_data.itemId,go.sliderNum.value)
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end

--上架
function DataShelfCtrl:OnAddShelfBtn(go)
        if go.isOn then
            local num = go.m_data.wareHouse + go.m_data.sale
            if num == 0 then
                Event.Brocast("SmallPop",GetLanguage(25030025), ReminderType.Warning)
                return
            end
            DataManager.DetailModelRpcNoRet(go.m_data.building, 'm_addShelf',go.m_data.building,go.m_data.itemId,num,GetServerPriceNumber(go.inputPrice.text),go.isOn)
        else
            if go.sliderNum.value == 0 then
                Event.Brocast("SmallPop",GetLanguage(25030025), ReminderType.Warning)
                return
            end
            DataManager.DetailModelRpcNoRet(go.m_data.building, 'm_addShelf',go.m_data.building,go.m_data.itemId,go.sliderNum.value,GetServerPriceNumber(go.inputPrice.text),go.isOn)
        end
end

--修改货架
function DataShelfCtrl:OnConfirmBtn(go)
        if go.isOn then
            local num = go.m_data.wareHouse + go.m_data.sale
            if num == 0 then
                Event.Brocast("SmallPop",GetLanguage(25030025), ReminderType.Warning)
                return
            end
            DataManager.DetailModelRpcNoRet(go.m_data.building, 'm_setShelf',go.m_data.building,go.m_data.itemId,num,GetServerPriceNumber(go.inputPrice.text),go.isOn)
        else
            if go.sliderNum.value == 0 then
                Event.Brocast("SmallPop",GetLanguage(25030025), ReminderType.Warning)
                return
            end
            DataManager.DetailModelRpcNoRet(go.m_data.building, 'm_setShelf',go.m_data.building,go.m_data.itemId,go.sliderNum.value,GetServerPriceNumber(go.inputPrice.text),go.isOn)
        end
end

--自动补货
function DataShelfCtrl:OnAutomaticSwitch(isOn)
    self.isOn = isOn
    if isOn then
        self.automaticSwitchBtn:DOLocalMove(Vector3.New(45,0,0),0.1):SetEase(DG.Tweening.Ease.Linear)
        self.totalBg.localScale = Vector3.one
        self.inputNum.transform.localScale = Vector3.zero
        self.sliderNum.transform.localScale = Vector3.zero
        self.totalNum.text = self.m_data.wareHouse + self.m_data.sale
    else
        self.automaticSwitchBtn:DOLocalMove(Vector3.New(-45,0,0),0.1):SetEase(DG.Tweening.Ease.Linear)
        self.totalBg.localScale = Vector3.zero
        self.inputNum.transform.localScale = Vector3.one
        self.sliderNum.transform.localScale = Vector3.one
    end
end

function DataShelfCtrl:OnClose(go)
    go.tipBg.localScale = Vector3.zero
    go.close.transform.localScale = Vector3.zero
    go.competitivenessTip:SetActive(false)
end

--数量
function DataShelfCtrl:OnInputNum()
    if self.inputNum.text == "" then
        self.inputNum.text = 0
    end
    if tonumber(self.inputNum.text) >= self.m_data.wareHouse + self.m_data.sale then
        self.inputNum.text = self.m_data.wareHouse + self.m_data.sale
    end
    self.inputNum.text = tonumber(self.inputNum.text)
    self.sliderNum.value = tonumber(self.inputNum.text)
end

--数量
function DataShelfCtrl:OnSliderNum()
    self.inputNum.text = self.sliderNum.value
end

--价格
function DataShelfCtrl:OnInputPrice()
    if self.inputPrice.text == "" then
        self.inputPrice.text = 0
    end
    self.inputPrice.text = tonumber(self.inputPrice.text)
    self.sliderPrice.value = tonumber(self.inputPrice.text)
end

--价格
function DataShelfCtrl:OnSliderPrice()
    if self.sliderPrice.value <= 100 then
        self.inputPrice.text = self.sliderPrice.value
    end
end

--下架回调
function DataShelfCtrl:c_DelShelf(info)
    Event.Brocast("SmallPop",GetLanguage(27060014), ReminderType.Succeed)
    UIPanel.ClosePage()
end

--推荐定价
function DataShelfCtrl:c_RecommendPrice(info)
    if info.msg then
        self.guidePrice = ct.CalculationPromoteRecommendPrice(info.msg,self.m_data.itemId)
        local temp
        if self.m_data.shelf == Shelf.AddShelf then
            temp = ct.CalculationAdvertisementCompetitivePower(self.guidePrice, self.guidePrice, self.m_data.itemId)
        elseif self.m_data.shelf == Shelf.SetShelf then
            temp = ct.CalculationAdvertisementCompetitivePower(self.guidePrice, self.m_data.price, self.m_data.itemId)
        end
        if temp >= functions.maxCompetitive then
            self.competitivenessText.text = ">"..temp
        elseif temp <= functions.minCompetitive then
            self.competitivenessText.text = "<"..temp
        else
            self.competitivenessText.text = string.format("%0.1f", temp)
        end
        DataShelfCtrl.sliderCanChange = false
        self.sliderPrice.value = temp
        if self.m_data.shelf == Shelf.AddShelf then
            self.inputPrice.text = GetClientPriceString(self.guidePrice)
        elseif self.m_data.shelf == Shelf.SetShelf then
            self.inputPrice.text = GetClientPriceString(self.m_data.price)
        end
    end
end
