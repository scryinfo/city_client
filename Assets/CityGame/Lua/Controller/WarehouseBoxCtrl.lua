---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/16 14:34
---仓库详情
WarehouseBoxCtrl = class('WarehouseBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(WarehouseBoxCtrl)

local Math_Floor = math.floor
function WarehouseBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function WarehouseBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WarehouseBoxPanel.prefab"
end

function WarehouseBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function WarehouseBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_language()
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self.clickCloseBtn,self)

    self.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
end

function WarehouseBoxCtrl:Refresh()
    self:initializeUiInfoData()
end

function WarehouseBoxCtrl:Hide()
    UIPanel.Hide(self)

end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function WarehouseBoxCtrl:_getComponent(go)
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")

    --goodsInfo
    self.iconImg = go.transform:Find("contentRoot/content/goodsInfo/iconBg/iconImg"):GetComponent("Image")
    self.nameText = go.transform:Find("contentRoot/content/goodsInfo/iconBg/nameBg/nameText"):GetComponent("Text")
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
    self.tipText = go.transform:Find("contentRoot/content/tipText"):GetComponent("Text")
    self.numberSlider = go.transform:Find("contentRoot/content/numberSlider"):GetComponent("Slider")
    self.numberText = go.transform:Find("contentRoot/content/numberSlider/HandleSlideArea/Handle/numberBg/numberText"):GetComponent("Text")
    self.deleBtn = go.transform:Find("contentRoot/bottom/deleBtn")
    self.addTransportBtn = go.transform:Find("contentRoot/bottom/addTransportBtn")
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--初始化UI数据
function WarehouseBoxCtrl:initializeUiInfoData()
    local materialKey,goodsKey = 21,22
    if Math_Floor(self.m_data.itemId / 100000) == materialKey then
        self.popularity.transform.localScale = Vector3.zero
        self.quality.transform.localScale = Vector3.zero
        self.levelBg.transform.localScale = Vector3.zero
        self.number.transform.localPosition = Vector3.New(183,-45,0)
        LoadSprite(Material[self.m_data.itemId].img,self.iconImg,false)
    elseif Math_Floor(self.m_data.itemId / 100000) == materialKey then
        self.popularity.transform.localScale = Vector3.one
        self.quality.transform.localScale = Vector3.one
        self.levelBg.transform.localScale = Vector3.one
        self.number.transform.localPosition = Vector3.New(183,-135,0)
        LoadSprite(Good[self.m_data.itemId].img,self.iconImg,false)
        --self.popularityValue.text =
        --self.qualityValue.text =
        --self.levelValue.text =
    end
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.numberSlider.maxValue = self.m_data.dataInfo.n
    self.numberSlider.value = 0
    self.numberText.text = "×"..self.numberSlider.value
end
--设置多语言
function WarehouseBoxCtrl:_language()
    self.topName.text = "详情"
    self.popularityText.text = "知名度:"
    self.qualityText.text = "品质:"
    self.levelText.text = "奢侈等级:"
    self.tipText.text = "运输数量"
end
--滑动更新文本
function WarehouseBoxCtrl:SlidingUpdateText()
    self.numberText.text = "×"..self.numberSlider.value
end
---------------------------------------------------------------点击函数-------------------------------------------------------------------------------------
--关闭
function WarehouseBoxCtrl:clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

