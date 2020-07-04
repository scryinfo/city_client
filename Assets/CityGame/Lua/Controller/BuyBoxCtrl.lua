---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/20 11:35
---Buy popup
BuyBoxCtrl = class('BuyBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(BuyBoxCtrl)

local ToNumber = tonumber
local StringSun = string.sub
local Math_Floor = math.floor
--Luxury class
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function BuyBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function BuyBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/BuyBoxPanel.prefab"
end

function BuyBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function BuyBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.bgBtn.gameObject,self._clickCloseBtn,self)
    --self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.buyBtn.gameObject,self._clickBuyBtn,self)
    self.numberSlider.onValueChanged:AddListener(function()
        self:UpdateSlidingText()
    end)
    self.numberInput.onEndEdit:AddListener(function()
        self:UpdateInputText()
    end)
end

function BuyBoxCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
end

function BuyBoxCtrl:Hide()
    UIPanel.Hide(self)

end
-------------------------------------------------------------Get components-------------------------------------------------------------------------------
function BuyBoxCtrl:_getComponent(go)
    --bgBtn
    self.bgBtn = go.transform:Find("bgBtn")
    --top
    --self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content
    --self.iconbg = go.transform:Find("contentRoot/content/goodsInfo/iconbg")
    self.iconImg = go.transform:Find("contentRoot/content/goodsInfo/iconbg/iconImg"):GetComponent("Image")
    self.nameText = go.transform:Find("contentRoot/content/goodsInfo/iconbg/name/nameText"):GetComponent("Text")
    self.priceText = go.transform:Find("contentRoot/content/goodsInfo/iconbg/price/priceText"):GetComponent("Text")
    --如果是原料关闭商品属性展示,否则打开
    self.scoreBg = go.transform:Find("contentRoot/content/goodsInfo/scoreBg")
    self.brandName = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandName"):GetComponent("Text")
    self.brandNameText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandName/brandNameText"):GetComponent("Text")
    --self.popularityText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity"):GetComponent("Text")
    self.popularityValue = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularityValue"):GetComponent("Text")
    --self.qualityText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality"):GetComponent("Text")
    self.qualityValue = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/qualityValue"):GetComponent("Text")
    self.levelBg = go.transform:Find("contentRoot/content/goodsInfo/levelBg")
    self.levelImg = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg"):GetComponent("Image")
    --self.levelText = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level"):GetComponent("Text")
    self.levelValue = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/levelText"):GetComponent("Text")

    self.number = go.transform:Find("contentRoot/content/goodsInfo/number")
    self.shelf = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber")
    --self.numberTipText = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber/numberTipText"):GetComponent("Text")
    self.shelfNumberText = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber/shelfNumberText"):GetComponent("Text")
    --self.tipText = go.transform:Find("contentRoot/content/tipText"):GetComponent("Text")
    self.numberTip = go.transform:Find("contentRoot/content/numberInput/numberTip"):GetComponent("Text")
    self.numberInput = go.transform:Find("contentRoot/content/numberInput"):GetComponent("InputField")
    self.numberSlider = go.transform:Find("contentRoot/content/numberSlider"):GetComponent("Slider")
    --self.numberText = go.transform:Find("contentRoot/content/numberSlider/HandleSlideArea/Handle/numberBg/numberText"):GetComponent("Text")
    --bottom
    self.buyBtn = go.transform:Find("contentRoot/bottom/buyBtn")
    self.buyText = go.transform:Find("contentRoot/bottom/buyBtn/text"):GetComponent("Text")
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--Initialize UI data
function BuyBoxCtrl:initializeUiInfoData()
    local materialKey,goodsKey = 21,22
    self.iconImg.sprite = SpriteManager.GetSpriteByPool(self.m_data.itemId)
    if ToNumber(StringSun(self.m_data.itemId,1,2)) == materialKey then
        self:materialOrGoods(self.m_data.itemId)
        --LoadSprite(Material[self.m_data.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.m_data.itemId,1,2)) == goodsKey then
        self:materialOrGoods(self.m_data.itemId)
        --LoadSprite(Good[self.m_data.itemId].img,self.iconImg,false)
        --If it is a commodity, determine the raw material grade
        if Good[self.m_data.itemId].luxury == 1 then
            self.levelImg.color = getColorByVector3(oneLevel)
            self.levelValue.text = GetLanguage(25020028)
        elseif Good[self.m_data.itemId].luxury == 2 then
            self.levelImg.color = getColorByVector3(twoLevel)
            self.levelValue.text = GetLanguage(25020029)
        elseif Good[self.m_data.itemId].luxury == 3 then
            self.levelImg.color = getColorByVector3(threeLevel)
            self.levelValue.text = GetLanguage(25020030)
        end
        self.brandNameText.text = self.m_data.dataInfo.k.brandName
        self.popularityValue.text = self.m_data.dataInfo.k.brandScore
        self.qualityValue.text = self.m_data.dataInfo.k.qualityScore
    end
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.priceText.text = GetClientPriceString(self.m_data.dataInfo.price)
    self.numberSlider.maxValue = self.m_data.dataInfo.n
    self.numberSlider.minValue = 1
    self.numberSlider.value = 1
    self.numberInput.text = "1"
    self.numberInput.characterLimit = #tostring(self.m_data.dataInfo.n) + 1
    local function callback1(number)
        self.shelfNumberText.text = "×"..number
    end
    Event.Brocast("getShelfItemIdCount",self.m_data.itemId,self.m_data.dataInfo.k.producerId,callback1)
end
--Set up multiple languages
function BuyBoxCtrl:_language()
    self.topName.text = GetLanguage(28040035)
    --self.tipText.text = GetLanguage(25070001)
    self.buyText.text = GetLanguage(25070014)
    self.brandName.text = GetLanguage(25020040)
    self.numberTip.text = GetLanguage(25070001)
    --self.popularityText.text = GetLanguage(25020006)
    --self.qualityText.text = GetLanguage(25020005)
    --self.levelText.text = GetLanguage(25020007)
    --self.numberTipText.text = GetLanguage(25020037)
end
--Swipe to update text in input box
function BuyBoxCtrl:UpdateSlidingText()
    --self.numberText.text = "×"..self.numberSlider.value
    self.numberInput.text = tostring(self.numberSlider.value)
end
--Input box update slider
function BuyBoxCtrl:UpdateInputText()
    if self.numberInput.text == "" or ToNumber(self.numberInput.text) <= 0 then
        self.numberInput.text = 1
        self.numberSlider.value = 1
        return
    end
    if ToNumber(self.numberInput.text) > self.numberSlider.maxValue then
        self.numberInput.text = self.numberSlider.maxValue
        self.numberSlider.value = ToNumber(self.numberInput.text)
        return
    end
    self.numberSlider.value = ToNumber(self.numberInput.text)
end
---------------------------------------------------------------Click function-------------------------------------------------------------------------------------
--close
function BuyBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--Add to cart
function BuyBoxCtrl:_clickBuyBtn(ins)
    local goods = {}
    goods.state = GoodsItemStateType.buy
    goods.itemId = ins.m_data.dataInfo.k.id
    goods.producerId = ins.m_data.dataInfo.k.producerId
    goods.qty = ins.m_data.dataInfo.k.qty
    goods.level = ins.m_data.dataInfo.k.level
    goods.price = ins.m_data.dataInfo.price
    goods.qualityScore = ins.m_data.dataInfo.k.qualityScore
    goods.brandScore = ins.m_data.dataInfo.k.brandScore
    goods.brandName = ins.m_data.dataInfo.k.brandName
    if ins.numberSlider.value == 0 then
        Event.Brocast("SmallPop", GetLanguage(25030025), ReminderType.Common)
        return
    else
        goods.number = ins.numberSlider.value
    end
    Event.Brocast("addBuyList",goods)
    UIPanel.ClosePage()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
--Initial UI display, raw materials or commodities
function BuyBoxCtrl:materialOrGoods(itemId)
    local materialKey,goodsKey = 21,22
    if Math_Floor(itemId / 100000) == materialKey then
        self.scoreBg.transform.localScale = Vector3.zero
        self.levelBg.transform.localScale = Vector3.zero
        self.number.transform.localPosition = Vector3.New(114,-20,0)
    elseif Math_Floor(itemId / 100000) == goodsKey then
        self.scoreBg.transform.localScale = Vector3.one
        self.levelBg.transform.localScale = Vector3.one
        self.number.transform.localPosition = Vector3.New(114,-110,0)
    end
end