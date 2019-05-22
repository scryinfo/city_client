---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/16 14:34
---仓库详情弹窗
WarehouseBoxCtrl = class('WarehouseBoxCtrl',UIPanel)
UIPanel:ResgisterOpen(WarehouseBoxCtrl)

local ToNumber = tonumber
local StringSun = string.sub
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
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
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.addTransportBtn.gameObject,self._clickAddTransportBtn,self)
    self.luaBehaviour:AddClick(self.deleBtn.gameObject,self._clickDeleBtn,self)
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
------------------------------------------------------------初始化函数--------------------------------------------------------------------------------
--初始化UI数据
function WarehouseBoxCtrl:initializeUiInfoData()
    local materialKey,goodsKey = 21,22
    if ToNumber(StringSun(self.m_data.itemId,1,2)) == materialKey then
        self.popularity.transform.localScale = Vector3.zero
        self.quality.transform.localScale = Vector3.zero
        self.levelBg.transform.localScale = Vector3.zero
        self.number.transform.localPosition = Vector3.New(183,-45,0)
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
        elseif Good[self.m_data.itemId].luxury == 2 then
            self.levelImg.color = getColorByVector3(twoLevel)
        elseif Good[self.m_data.itemId].luxury == 3 then
            self.levelImg.color = getColorByVector3(threeLevel)
        end
        --self.popularityValue.text =
        --self.qualityValue.text =
        --self.levelValue.text =
    end
    local function callback(a)
        --暂时缓存仓库有的个数（后边要下架然后运输）
        self.warehouseCount = a
        self.warehouseNumberText.text = "×"..a
    end
    local function callback1(b)
        self.shelfNumberText.text = "×"..b
    end
    Event.Brocast("getItemIdCount",self.m_data.itemId,callback)
    Event.Brocast("getShelfItemIdCount",self.m_data.itemId,callback1)
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.numberSlider.maxValue = self.warehouseCount
    self.numberSlider.value = 1
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
function WarehouseBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--添加运输列表
function WarehouseBoxCtrl:_clickAddTransportBtn(ins)
    local goods = {}
    goods.state = GoodsItemStateType.transport
    goods.itemId = ins.m_data.dataInfo.key.id
    goods.producerId = ins.m_data.dataInfo.key.producerId
    goods.qty = ins.m_data.dataInfo.key.qty
    goods.level = ins.m_data.dataInfo.key.level
    if ins.numberSlider.value == 0 then
        Event.Brocast("SmallPop",GetLanguage(21020003), 300)
        return
    else
        goods.number = ins.numberSlider.value
    end
    Event.Brocast("addTransportList",goods)
    UIPanel.ClosePage()
end
--销毁商品
function WarehouseBoxCtrl:_clickDeleBtn(ins)
    local data = {}
    data.itemId = ins.m_data.itemId
    data.producerId = ins.m_data.dataInfo.key.producerId
    data.qty = ins.m_data.dataInfo.key.qty
    data.n = ins.m_data.dataInfo.n
    ct.OpenCtrl("DeleteItemBoxCtrl",data)
end