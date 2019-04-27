---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/19 10:34
---货架详情弹窗
ShelfBoxCtrl = class('ShelfBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(ShelfBoxCtrl)

local isShow = false
local Math_Floor = math.floor
function ShelfBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function ShelfBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ShelfBoxPanel.prefab"
end

function ShelfBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function ShelfBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_language()
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.tipBtn.gameObject,self._clickTipBtn,self)
    self.luaBehaviour:AddClick(self.addShelfBtn.gameObject,self._clickAddShelfBtn,self)

    self.automaticSwitch.onValueChanged:AddListener(function()
        self:ToggleUndateText()
    end)
    self.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
end

function ShelfBoxCtrl:Refresh()
    self:initializeUiInfoData()
end

function ShelfBoxCtrl:Hide()
    UIPanel.Hide(self)

end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function ShelfBoxCtrl:_getComponent(go)
    --top
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content  goodsInfo
    self.iconImg = go.transform:Find("contentRoot/content/goodsInfo/iconbg/iconImg"):GetComponent("Image")
    self.nameText = go.transform:Find("contentRoot/content/goodsInfo/iconbg/nameBg/nameText"):GetComponent("Text")
    self.brandNameText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandNameText"):GetComponent("Text")
    --如果是原料关闭商品属性展示,否则打开
    self.popularity = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity")
    self.popularityText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity"):GetComponent("Text")
    self.popularityValue = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity/popularityValue"):GetComponent("Text")
    self.quality = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality")
    self.qualityText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality"):GetComponent("Text")
    self.qualityValue = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality/qualityValue"):GetComponent("Text")
    self.levelBg = go.transform:Find("contentRoot/content/goodsInfo/levelBg")
    self.levelImg = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg"):GetComponent("Image")
    self.levelText = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level"):GetComponent("Text")
    self.levelValue = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level/levelText"):GetComponent("Text")

    self.number = go.transform:Find("contentRoot/content/goodsInfo/number")
    self.warehouseNumberText = go.transform:Find("contentRoot/content/goodsInfo/number/warehouseNumber/warehouseNumberText"):GetComponent("Text")
    self.shelfNumberText = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber/shelfNumberText"):GetComponent("Text")
    --detailsInfo
    self.numberTip = go.transform:Find("contentRoot/content/detailsInfo/numberTip"):GetComponent("Text")
    self.numberSlider = go.transform:Find("contentRoot/content/detailsInfo/numberSlider"):GetComponent("Slider")
    self.numberText = go.transform:Find("contentRoot/content/detailsInfo/numberSlider/HandleSlideArea/Handle/numberBg/numberText"):GetComponent("Text")
    self.tipBtn = go.transform:Find("contentRoot/content/detailsInfo/tipBtn")
    self.tipText = go.transform:Find("contentRoot/content/detailsInfo/tipBtn/tipText"):GetComponent("Text")
    self.tipBg = go.transform:Find("contentRoot/content/detailsInfo/tipBtn/tipBg")
    self.tipContentText = go.transform:Find("contentRoot/content/detailsInfo/tipBtn/tipBg/Text"):GetComponent("Text")
    self.automaticSwitch = go.transform:Find("contentRoot/content/detailsInfo/automaticSwitch"):GetComponent("Toggle")
    self.btnImage = go.transform:Find("contentRoot/content/detailsInfo/automaticSwitch/btnImage")
    self.priceTip = go.transform:Find("contentRoot/content/detailsInfo/price"):GetComponent("Text")
    self.priceInput = go.transform:Find("contentRoot/content/detailsInfo/priceInput"):GetComponent("InputField")
    self.advicePrice = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tip"):GetComponent("Text")
    self.advicePriceText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/priceText"):GetComponent("Text")
    self.tipPriceDetailsBtn = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipPriceDetailsBtn")
    --bottom
    self.downShelfBtn = go.transform:Find("contentRoot/bottom/downShelfBtn")
    self.addShelfBtn = go.transform:Find("contentRoot/bottom/addShelfBtn")
    self.confirmBtn = go.transform:Find("contentRoot/bottom/confirmBtn")
end
--------------------------------------------------------------------------初始化--------------------------------------------------------------------------
--初始化UI数据
function ShelfBoxCtrl:initializeUiInfoData()
    local materialKey,goodsKey = 21,22
    if Math_Floor(self.m_data.itemId / 100000) == materialKey then
        self.popularity.transform.localScale = Vector3.zero
        self.quality.transform.localScale = Vector3.zero
        self.levelBg.transform.localScale = Vector3.zero
        self.number.transform.localPosition = Vector3.New(183,-45,0)
        LoadSprite(Material[self.m_data.itemId].img,self.iconImg,false)
    elseif Math_Floor(self.m_data.itemId / 100000) == goodsKey then
        self.popularity.transform.localScale = Vector3.one
        self.quality.transform.localScale = Vector3.one
        self.levelBg.transform.localScale = Vector3.one
        self.number.transform.localPosition = Vector3.New(183,-135,0)
        LoadSprite(Good[self.m_data.itemId].img,self.iconImg,false)
        --self.popularityValue.text =
        --self.qualityValue.text =
        --self.levelValue.text =
    end
    --自己在货架打开时
    if not self.m_data.stateType then
        self.downShelfBtn.transform.localScale = Vector3.one
        self.confirmBtn.transform.localScale = Vector3.one
        self.addShelfBtn.transform.localScale = Vector3.zero
        self.automaticSwitch.isOn = self.m_data.dataInfo.autoReplenish
        self.numberSlider.maxValue = self.m_data.dataInfo.n
        self.numberSlider.value = self.m_data.dataInfo.n
        self.numberText.text = "×"..self.numberSlider.value
        self.priceInput.text = GetClientPriceString(self.m_data.dataInfo.price)
    else
        --上架的时候打开时
        self.downShelfBtn.transform.localScale = Vector3.zero
        self.confirmBtn.transform.localScale = Vector3.zero
        self.addShelfBtn.transform.localScale = Vector3.one
        self.numberSlider.maxValue = self.m_data.dataInfo.n
        self.numberSlider.value = 0
        self.numberText.text = "×"..self.numberSlider.value
        self.priceInput.text = "0"
    end
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.tipBg.transform.localScale = Vector3.zero
    self.advicePriceText.text = "0000.0000"
end
--设置多语言
function ShelfBoxCtrl:_language()
    self.topName.text = "详情"
    self.popularityText.text = "知名度:"
    self.qualityText.text = "品质:"
    self.levelText.text = "奢侈等级:"
    self.numberTip.text = "销售数量"
    self.tipText.text = "自动补货"
    self.tipContentText.text = "The goods will be sold as many as they aer in warehouse if you open the switch."
    self.priceTip.text = "价格"
    self.advicePrice.text = "参考价格:"
end
--------------------------------------------------------------------------点击函数--------------------------------------------------------------------------
--关闭
function ShelfBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--打开关闭提示
function ShelfBoxCtrl:_clickTipBtn(ins)
    PlayMusEff(1002)
    ins:openTipText(not isShow)
end
--点击上架
function ShelfBoxCtrl:_clickAddShelfBtn(ins)
    if ins:WhetherValidShelfOp(ins) == true then
        local data = {}
        data.itemId = ins.m_data.itemId
        data.producerId = ins.m_data.dataInfo.key.producerId
        data.qty = ins.m_data.dataInfo.key.qty
        data.number = ins.numberSlider.value
        data.price = GetServerPriceNumber(ins.priceInput.text)
        data.switch = ins.automaticSwitch.isOn
        Event.Brocast("addShelf",data)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
--设置提示开关
function ShelfBoxCtrl:openTipText(isBool)
    if isBool then
        self.tipBg.transform.localScale = Vector3.one
    else
        self.tipBg.transform.localScale = Vector3.zero
    end
    isShow = isBool
end
--自动补货按钮
function ShelfBoxCtrl:ToggleUndateText()
    if self.automaticSwitch.isOn == true then
        self.btnImage.localPosition = Vector2.New(45,0)
        self.numberSlider.value = self.numberSlider.maxValue
        self.numberSlider.interactable = false
    else
        self.btnImage.localPosition = Vector2.New(-45,0)
        self.numberSlider.interactable = true
        self.numberSlider.value = 0
    end
end
--滑动条更新文本
function ShelfBoxCtrl:SlidingUpdateText()
    self.numberText.text = "×"..self.numberSlider.value
end
--上架时检查操作是否成功
function ShelfBoxCtrl:WhetherValidShelfOp(ins)
    if GetServerPriceNumber(ins.priceInput.text) == 0 or ins.priceInput.text == "" then
        ct.log("fisher_w31_time","价格不能为0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        return false
    end
    if ins.numberSlider.value == 0 then
        ct.log("fisher_w31_time","数量不能为0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        return false
    end
    return true
end