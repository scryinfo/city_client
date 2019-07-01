---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/20 11:35
---购买弹窗
BuyBoxCtrl = class('BuyBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(BuyBoxCtrl)

local ToNumber = tonumber
local StringSun = string.sub
--奢侈等级
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
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.buyBtn.gameObject,self._clickBuyBtn,self)
    self.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
end

function BuyBoxCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
end

function BuyBoxCtrl:Hide()
    UIPanel.Hide(self)

end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function BuyBoxCtrl:_getComponent(go)
    --top
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content
    self.iconImg = go.transform:Find("contentRoot/content/goodsInfo/iconbg/iconImg"):GetComponent("Image")
    self.nameText = go.transform:Find("contentRoot/content/goodsInfo/iconbg/name/nameText"):GetComponent("Text")
    --如果是原料关闭商品属性展示,否则打开
    self.brandNameText = go.transform:Find("contentRoot/content/goodsInfo/scoreBg/brandBg/brandNameText"):GetComponent("Text")
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
    self.shelfNumberText = go.transform:Find("contentRoot/content/goodsInfo/number/shelfNumber/shelfNumberText"):GetComponent("Text")
    self.tipText = go.transform:Find("contentRoot/content/tipText"):GetComponent("Text")
    self.numberSlider = go.transform:Find("contentRoot/content/numberSlider"):GetComponent("Slider")
    self.numberText = go.transform:Find("contentRoot/content/numberSlider/HandleSlideArea/Handle/numberBg/numberText"):GetComponent("Text")
    --bottom
    self.buyBtn = go.transform:Find("contentRoot/bottom/buyBtn")
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--初始化UI数据
function BuyBoxCtrl:initializeUiInfoData()
    local materialKey,goodsKey = 21,22
    if ToNumber(StringSun(self.m_data.itemId,1,2)) == materialKey then
        self.popularity.transform.localScale = Vector3.zero
        self.quality.transform.localScale = Vector3.zero
        self.levelBg.transform.localScale = Vector3.zero
        self.number.transform.localPosition = Vector3.New(183,-50,0)
        LoadSprite(Material[self.m_data.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.m_data.itemId,1,2)) == goodsKey then
        self.popularity.transform.localScale = Vector3.one
        self.quality.transform.localScale = Vector3.one
        self.levelBg.transform.localScale = Vector3.one
        self.number.transform.localPosition = Vector3.New(183,-135,0)
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
        self.brandNameText.text = self.m_data.dataInfo.k.brandName
        self.popularityValue.text = self.m_data.dataInfo.k.brandScore
        self.qualityValue.text = self.m_data.dataInfo.k.qualityScore
    end
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.numberSlider.maxValue = self.m_data.dataInfo.n
    self.numberSlider.value = 1
    self.numberText.text = "×"..self.numberSlider.value
    local function callback1(b)
        self.shelfNumberText.text = "×"..b
    end
    Event.Brocast("getShelfItemIdCount",self.m_data.itemId,self.m_data.dataInfo.k.producerId,callback1)
end
--设置多语言
function BuyBoxCtrl:_language()
    self.topName.text = GetLanguage(28040035)
    self.tipText.text = GetLanguage(25070001)
end
--滑动更新文本
function BuyBoxCtrl:SlidingUpdateText()
    self.numberText.text = "×"..self.numberSlider.value
end
---------------------------------------------------------------点击函数-------------------------------------------------------------------------------------
--关闭
function BuyBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--添加购物车
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
        return
    else
        goods.number = ins.numberSlider.value
    end
    Event.Brocast("addBuyList",goods)
    UIPanel.ClosePage()
    --添加购物车
    --if ins.m_data.buildingType == BuildingType.MaterialFactory then
    --    --原料厂
    --    --Event.Brocast("m_ReqMaterialAddShoppingCart",ins.m_data.buildingId,ins.m_data.itemId,ins.numberSlider.value,ins.m_data.dataInfo.price,ins.m_data.dataInfo.k.producerId,ins.m_data.dataInfo.k.qty)
    --elseif ins.m_data.buildingType == BuildingType.ProcessingFactory then
    --    --加工厂
    --end
end