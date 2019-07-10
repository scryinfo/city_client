---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/19 10:34
---货架详情弹窗
ShelfBoxCtrl = class('ShelfBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(ShelfBoxCtrl)

local isShow = false
local isShowPrice = false
local Math_Floor = math.floor
local ToNumber = tonumber
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
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
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.tipBtn.gameObject,self._clickTipBtn,self)
    self.luaBehaviour:AddClick(self.addShelfBtn.gameObject,self._clickAddShelfBtn,self)
    self.luaBehaviour:AddClick(self.downShelfBtn.gameObject,self._clickDownShelfBtn,self)
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject,self._clickConfirmBtn,self)
    self.luaBehaviour:AddClick(self.tipPriceBtn.gameObject,self._clickTipPriceBtn,self)
    self.luaBehaviour:AddClick(self.tipPriceBg.gameObject,self._clickTipPriceBgBtn,self)

    self.automaticSwitch.onValueChanged:AddListener(function()
        self:ToggleUndateText()
    end)
    self.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
    self.priceInput.onValueChanged:AddListener(function()
        self:InputUpdateText()
    end)
end

function ShelfBoxCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
end

function ShelfBoxCtrl:Hide()
    UIPanel.Hide(self)
    isShow = false
    isShowPrice = false
end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function ShelfBoxCtrl:_getComponent(go)
    --top
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content  goodsInfo
    self.iconbg = go.transform:Find("contentRoot/content/goodsInfo/iconbg")
    self.iconImg = go.transform:Find("contentRoot/content/goodsInfo/iconbg/iconImg"):GetComponent("Image")
    self.nameText = go.transform:Find("contentRoot/content/goodsInfo/iconbg/nameBg/nameText"):GetComponent("Text")

    self.scoreBg = go.transform:Find("contentRoot/content/goodsInfo/scoreBg")
    self.brand = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg")
    self.brandName = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandName"):GetComponent("Text")
    self.brandNameText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandName/brandNameText"):GetComponent("Text")
    --如果是原料关闭商品属性展示,否则打开
    self.popularityText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity"):GetComponent("Text")
    self.popularityValue = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/popularity/popularity/popularityValue"):GetComponent("Text")
    self.qualityText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality"):GetComponent("Text")
    self.qualityValue = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/quality/quality/qualityValue"):GetComponent("Text")
    self.levelBg = go.transform:Find("contentRoot/content/goodsInfo/levelBg")
    self.levelImg = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg"):GetComponent("Image")
    self.levelText = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level"):GetComponent("Text")
    self.levelValue = go.transform:Find("contentRoot/content/goodsInfo/levelBg/levelImg/level/levelText"):GetComponent("Text")

    self.number = go.transform:Find("contentRoot/content/goodsInfo/number")
    self.warehouse = go.transform:Find("contentRoot/content/goodsInfo/number/warehouseNumber")
    self.shelf = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber")
    self.warehouseNumberText = go.transform:Find("contentRoot/content/goodsInfo/number/warehouseNumber/warehouseNumberText"):GetComponent("Text")
    self.warehouseNumberTipText = go.transform:Find("contentRoot/content/goodsInfo/number/warehouseNumber/numberTipText"):GetComponent("Text")
    self.shelfNumberText = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber/shelfNumberText"):GetComponent("Text")
    self.shelfNumberTipText = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber/numberTipText"):GetComponent("Text")
    --detailsInfo
    self.totalNumber = go.transform:Find("contentRoot/content/detailsInfo/totalNumber"):GetComponent("Text")
    self.totalNumberText = go.transform:Find("contentRoot/content/detailsInfo/totalNumber/totalNumberText"):GetComponent("Text")
    self.numberTip = go.transform:Find("contentRoot/content/detailsInfo/numberSlider/numberTip"):GetComponent("Text")
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
    self.advicePrice = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tip")
    self.advicePriceText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/priceText"):GetComponent("Text")
    self.CompetitivenessText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/priceText/Text"):GetComponent("Text")
    self.tipPriceBtn = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBtn")
    self.tipPriceBg = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBgBtn")
    self.tipPriceText = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipBgBtn/tipText"):GetComponent("Text")

    self.tipPriceDetailsBtn = go.transform:Find("contentRoot/content/detailsInfo/tipPriceBg/tipPriceDetailsBtn")
    --bottom
    self.downShelfBtn = go.transform:Find("contentRoot/bottom/downShelfBtn")
    self.addShelfBtn = go.transform:Find("contentRoot/bottom/addShelfBtn")
    self.addShelfText = go.transform:Find("contentRoot/bottom/addShelfBtn/text"):GetComponent("Text")
    self.confirmBtn = go.transform:Find("contentRoot/bottom/confirmBtn")
end
--------------------------------------------------------------------------初始化--------------------------------------------------------------------------
--初始化UI数据
function ShelfBoxCtrl:initializeUiInfoData()
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        local function callbacks(guidePrice)
            self.guidePrice = guidePrice
        end
        Event.Brocast("getShelfItemGuidePrice",self.m_data.itemId,callbacks)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        local function callbacks(averagePrice,averageScore,score)
            self.averagePrice = averagePrice --平均价
            self.averageScore = averageScore --平均分
            self.score = score        --评分
        end
        Event.Brocast("getShelfItemProcessing",self.m_data.itemId,callbacks)
    elseif self.m_data.buildingType == BuildingType.RetailShop then
        local function callbacks(averagePrice,averageScore,averageBuildingScore,playerGoodsScore,playerBuildingScore)
            self.averagePrice = averagePrice --平均价
            self.averageScore = averageScore --平均分
            self.averageBuildingScore = averageBuildingScore        --评分
            self.playerGoodsScore = playerGoodsScore            --玩家商品评分
            self.playerBuildingScore = playerBuildingScore         --玩家店铺评分
        end
        Event.Brocast("getRetailItemGuidePrice",self.m_data.itemId,callbacks)
    end
    local materialKey,goodsKey = 21,22
    if Math_Floor(self.m_data.itemId / 100000) == materialKey then
        self:materialOrGoods(self.m_data.itemId)
        LoadSprite(Material[self.m_data.itemId].img,self.iconImg,false)
    elseif Math_Floor(self.m_data.itemId / 100000) == goodsKey then
        self:materialOrGoods(self.m_data.itemId)
        LoadSprite(Good[self.m_data.itemId].img,self.iconImg,false)
        --如果是商品，判断原料等级
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
        if not self.m_data.dataInfo.k then
            self.brandNameText.text = self.m_data.dataInfo.key.brandName
            self.popularityValue.text = self.m_data.dataInfo.key.brandScore
            self.qualityValue.text = self.m_data.dataInfo.key.qualityScore
        elseif not self.m_data.dataInfo.key then
            self.brandNameText.text = self.m_data.dataInfo.k.brandName
            self.popularityValue.text = self.m_data.dataInfo.k.brandScore
            self.qualityValue.text = self.m_data.dataInfo.k.qualityScore
        end
    end
    local function callback(warehouseNumber)
        --缓存一个值，修改数量时使用
        self.warehouseNumber = warehouseNumber
        self.warehouseNumberText.text = "×"..warehouseNumber
    end
    local function callback1(shelfNumber)
        self.shelfNumberText.text = "×"..shelfNumber
    end
    if not self.m_data.dataInfo.key then
        Event.Brocast("getItemIdCount",self.m_data.itemId,self.m_data.dataInfo.k.producerId,callback)
        Event.Brocast("getShelfItemIdCount",self.m_data.itemId,self.m_data.dataInfo.k.producerId,callback1)
    else
        Event.Brocast("getItemIdCount",self.m_data.itemId,self.m_data.dataInfo.key.producerId,callback)
        Event.Brocast("getShelfItemIdCount",self.m_data.itemId,self.m_data.dataInfo.key.producerId,callback1)
    end
    if not self.m_data.stateType then
        --货架打开时
        self.downShelfBtn.transform.localScale = Vector3.one
        self.confirmBtn.transform.localScale = Vector3.one
        self.addShelfBtn.transform.localScale = Vector3.zero
        self.automaticSwitch.isOn = self.m_data.dataInfo.autoReplenish
        self.numberSlider.maxValue = self.m_data.dataInfo.n
        self.numberSlider.minValue = 1
        self.numberSlider.value = self.m_data.dataInfo.n
        self.numberText.text = "×"..self.numberSlider.value
        self.priceInput.text = GetClientPriceString(self.m_data.dataInfo.price)
        if self.automaticSwitch.isOn == true then
            self.numberSlider.transform.localScale = Vector3.zero
            self.totalNumber.transform.localScale = Vector3.one
            self.totalNumberText.text = "×"..self.m_data.dataInfo.n
            self.warehouseNumberText.text = "×"..0
            self.shelfNumberText.text = "×"..self.m_data.dataInfo.n
        else
            self.numberSlider.transform.localScale = Vector3.one
            self.totalNumber.transform.localScale = Vector3.zero
            self.shelfNumberText.text = "×"..self.m_data.dataInfo.n
            self.numberSlider.maxValue = self.m_data.dataInfo.n + self.warehouseNumber
        end
    else
        --上架的时候打开时
        self.automaticSwitch.isOn = false
        self.numberSlider.transform.localScale = Vector3.one
        self.totalNumber.transform.localScale = Vector3.zero
        self.downShelfBtn.transform.localScale = Vector3.zero
        self.confirmBtn.transform.localScale = Vector3.zero
        self.addShelfBtn.transform.localScale = Vector3.one
        self.numberSlider.maxValue = self.m_data.dataInfo.n
        self.numberSlider.minValue = 1
        self.numberSlider.value = 1
        self.numberText.text = "×"..self.numberSlider.value
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            self.priceInput.text = ct.CalculationMaterialSuggestPrice(self.guidePrice / 10000,self.m_data.itemId) / 10000
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            local temp = ct.CalculationProcessingSuggestPrice(self.averagePrice / 10000,self.m_data.itemId,self.score,self.averageScore)
            self.priceInput.text = GetClientPriceString(temp)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            self.priceInput.text = ct.CalculationRetailSuggestPrice(self.averagePrice / 10000,self.m_data.itemId,self.playerGoodsScore,
                    self.playerBuildingScore,self.averageScore,self.averageBuildingScore) / 10000
        end
    end
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.tipBg.transform.localScale = Vector3.zero
    self.tipPriceBg.transform.localScale = Vector3.zero
end
--设置多语言
function ShelfBoxCtrl:_language()
    self.topName.text = GetLanguage(28040035)
    self.popularityText.text = GetLanguage(25020006)
    self.qualityText.text = GetLanguage(25020005)
    self.levelText.text = GetLanguage(25020007)
    self.numberTip.text = GetLanguage(28040019)
    self.totalNumber.text = GetLanguage(28040019)
    self.tipText.text = GetLanguage(25060004)
    self.tipContentText.text = GetLanguage(25020027)
    self.priceTip.text = GetLanguage(25060003)
    self.CompetitivenessText.text = GetLanguage(43010001)
    self.warehouseNumberTipText.text = GetLanguage(25020038)
    self.shelfNumberTipText.text = GetLanguage(25020037)
    self.addShelfText.text = GetLanguage(25020035)
    self.brandName.text = GetLanguage(25020040)
    --self.advicePrice.text = "参考价格:"
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
        data.price = GetServerPriceNumber(ToNumber(ins.priceInput.text))
        data.switch = ins.automaticSwitch.isOn
        Event.Brocast("addShelf",data)
    end
end
--点击下架
function ShelfBoxCtrl:_clickDownShelfBtn(ins)
    if ins.m_data.dataInfo.autoReplenish == true then
        Event.Brocast("SmallPop",GetLanguage(25030018), 300)
        return
    end
    local data = {}
    data.itemId = ins.m_data.itemId
    data.number = ins.m_data.dataInfo.n
    data.producerId = ins.m_data.dataInfo.k.producerId
    data.qty = ins.m_data.dataInfo.k.qty
    Event.Brocast("downShelf",data)
end
--点击确认(修改数量，修改价格，修改自动补货)
function ShelfBoxCtrl:_clickConfirmBtn(ins)
    local data = {}
    data.itemId = ins.m_data.itemId
    if not ins.m_data.dataInfo.k then
        data.producerId = ins.m_data.dataInfo.key.producerId
        data.qty = ins.m_data.dataInfo.key.qty
    else
        data.producerId = ins.m_data.dataInfo.k.producerId
        data.qty = ins.m_data.dataInfo.k.qty
    end
    data.number = ins.numberSlider.value
    data.price = GetServerPriceNumber(ToNumber(ins.priceInput.text))
    data.switch = ins.automaticSwitch.isOn
    if data.number == ins.m_data.dataInfo.n and data.price == ins.m_data.dataInfo.price and data.switch == ins.m_data.dataInfo.autoReplenish then
        UIPanel.ClosePage()
        return
    end
    --当前自动补货是否为true
    if data.switch == true then
        data.number = ins.numberSlider.maxValue
    end
    Event.Brocast("modifyShelfInfo",data)
end
--点击打开竞争力提示
function ShelfBoxCtrl:_clickTipPriceBtn(ins)
    ins:openTipPriceText(not isShowPrice)
end
--点击竞争力提示bg
function ShelfBoxCtrl:_clickTipPriceBgBtn(ins)
    ins:openTipPriceText(not isShowPrice)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
--初始化UI显示,原料还是商品
function ShelfBoxCtrl:materialOrGoods(itemId)
    local materialKey,goodsKey = 21,22
    if Math_Floor(itemId / 100000) == materialKey then
        self.scoreBg.transform.localScale = Vector3.zero
        self.levelBg.transform.localScale = Vector3.zero
        self.number.sizeDelta = Vector2.New(470,356)
        self.warehouse.transform.localPosition = Vector3.New(-150,50,0)
        self.shelf.transform.localPosition = Vector3.New(-150,-60,0)
        self.number.transform.localPosition = Vector3.New(180,0,0)
        self.iconbg.transform.localPosition = Vector3.New(-243,0,0)
    elseif Math_Floor(itemId / 100000) == goodsKey then
        self.scoreBg.transform.localScale = Vector3.one
        self.levelBg.transform.localScale = Vector3.one
        self.number.sizeDelta = Vector2.New(585,86)
        self.number.transform.localPosition = Vector3.New(180,-135,0)
        self.warehouse.transform.localPosition = Vector3.New(-240,0,0)
        self.shelf.transform.localPosition = Vector3.New(45,0,0)
        self.iconbg.transform.localPosition = Vector3.New(-298,0,0)
    end
end
--设置提示开关
function ShelfBoxCtrl:openTipText(isBool)
    if isBool then
        self.tipBg.transform.localScale = Vector3.one
    else
        self.tipBg.transform.localScale = Vector3.zero
    end
    isShow = isBool
end
--设置竞争力提示开关
function ShelfBoxCtrl:openTipPriceText(isBool)
    if isBool then
        self.tipPriceBg.transform.localScale = Vector3.one
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            self.tipPriceText.text = GetLanguage(43020001)..GetLanguage(43020002)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            self.tipPriceText.text = GetLanguage(43030001)..GetLanguage(43030002)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            self.tipPriceText.text = GetLanguage(43040001)..GetLanguage(43040002)
        end
    else
        self.tipPriceBg.transform.localScale = Vector3.zero
        self.tipPriceText.text = ""
    end
    isShowPrice = isBool
end
--自动补货按钮
function ShelfBoxCtrl:ToggleUndateText()
    if self.automaticSwitch.isOn == true then
        self.btnImage.localPosition = Vector2.New(45,0)
        self.numberSlider.value = self.numberSlider.maxValue
        self.numberSlider.transform.localScale = Vector3.zero
        self.totalNumber.transform.localScale = Vector3.one
        self.totalNumberText.text = "×"..self.numberSlider.maxValue
    else
        self.numberSlider.transform.localScale = Vector3.one
        self.totalNumber.transform.localScale = Vector3.zero
        if self.m_data.dataInfo.n == 0 then
            self.numberSlider.minValue = 0
            self.numberSlider.value = 0
        else
            self.numberSlider.minValue = 1
            self.numberSlider.value = 1
        end
        self.btnImage.localPosition = Vector2.New(-45,0)
    end
end
--滑动条更新文本
function ShelfBoxCtrl:SlidingUpdateText()
    self.numberText.text = "×"..self.numberSlider.value
end
--输入框
function ShelfBoxCtrl:InputUpdateText()
    if self.priceInput.text == nil or self.priceInput.text == "" or tonumber(self.priceInput.text) == nil then
        return
    else
        if self.m_data.buildingType == BuildingType.MaterialFactory then
            self.advicePriceText.text = ct.CalculationMaterialCompetitivePower(self.guidePrice,tonumber(self.priceInput.text) * 10000,self.m_data.itemId)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            self.advicePriceText.text = ct.CalculationFactoryCompetitivePower(self.averagePrice,tonumber(self.priceInput.text) * 10000,self.m_data.itemId,self.score,self.averageScore)
        elseif self.m_data.buildingType == BuildingType.RetailShop then
            self.advicePriceText.text = ct.CalculationSupermarketCompetitivePower(self.averagePrice,tonumber(self.priceInput.text) * 10000,self.m_data.itemId,
                    self.playerGoodsScore,self.playerBuildingScore,self.averageScore,self.averageBuildingScore)
        end
    end
end
--上架时检查操作是否成功
function ShelfBoxCtrl:WhetherValidShelfOp(ins)
    if GetServerPriceNumber(ins.priceInput.text) == 0 or ins.priceInput.text == "" then
        Event.Brocast("SmallPop", GetLanguage(25030023), 300)
        return false
    end
    if ins.numberSlider.value == 0 then
        Event.Brocast("SmallPop", GetLanguage(25030024), 300)
        return false
    end
    return true
end