---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/27 8:56
---仓库销毁二次确认弹框

DeleteItemBoxCtrl = class("DeleteItemBoxCtrl",UIPanel)
UIPanel:ResgisterOpen(DeleteItemBoxCtrl)

local ToNumber = tonumber
local StringSun = string.sub
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function DeleteItemBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function DeleteItemBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/DeleteItemBoxPanel.prefab"
end

function DeleteItemBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function DeleteItemBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.confirmBtn.gameObject,self._clickConfirmBtn,self)
    self.numberSlider.onValueChanged:AddListener(function()
        self:SlidingUpdateText()
    end)
end
function DeleteItemBoxCtrl:Active()
    UIPanel.Active(self)
    self:_language()
end
function DeleteItemBoxCtrl:Refresh()
    self:initializeUiInfoData()
end

function DeleteItemBoxCtrl:Hide()
    UIPanel.Hide(self)

end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function DeleteItemBoxCtrl:_getComponent(go)
    --top
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content goodInfo
    self.iconImg = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/iconImg"):GetComponent("Image")
    self.nameBg = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/nameBg")
    self.nameText = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/nameBg/nameText"):GetComponent("Text")
    --如果是原料就隐藏
    self.goods = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods")
    self.levelImg = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/levelImg"):GetComponent("Image")
    self.brandNameText = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")

    self.numberSlider = go.transform:Find("contentRoot/content/goodInfoBg/numberSlider"):GetComponent("Slider")
    self.numberText = go.transform:Find("contentRoot/content/goodInfoBg/numberSlider/HandleSlideArea/Handle/numberBg/numberText"):GetComponent("Text")
    self.tipText = go.transform:Find("contentRoot/content/tipText"):GetComponent("Text")
    self.confirmBtn = go.transform:Find("contentRoot/bottom/confirmBtn")
end
-------------------------------------------------------------初始化---------------------------------------------------------------------------------
--初始化UI数据
function DeleteItemBoxCtrl:initializeUiInfoData()
    local materialKey,goodsKey = 21,22
    self.nameText.text = GetLanguage(self.m_data.itemId)
    self.numberSlider.maxValue = self.m_data.n
    self.numberSlider.minValue = 1
    self.numberSlider.value = 1
    self.numberText.text = "×"..self.numberSlider.value
    if ToNumber(StringSun(self.m_data.itemId,1,2)) == materialKey then
        self.goods.transform.localScale = Vector3.zero
        self.nameBg.transform.localPosition = Vector3.New(-140,-100,0)
        LoadSprite(Material[self.m_data.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.m_data.itemId,1,2)) == goodsKey then
        self.goods.transform.localScale = Vector3.one
        self.nameBg.transform.localPosition = Vector3.New(-140,-55,0)
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
end
--设置多语言
function DeleteItemBoxCtrl:_language()
    self.topName.text = GetLanguage(25020010)
    self.tipText.text = GetLanguage(25020011)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------

--滑动更新文本
function DeleteItemBoxCtrl:SlidingUpdateText()
    self.numberText.text = "×"..self.numberSlider.value
end
-------------------------------------------------------------点击函数---------------------------------------------------------------------------------
--关闭
function DeleteItemBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--确认销毁
function DeleteItemBoxCtrl:_clickConfirmBtn(ins)
    local data = {}
    data.itemId = ins.m_data.itemId
    data.num = ins.numberSlider.value
    data.producerId = ins.m_data.producerId
    data.qty = ins.m_data.qty
    Event.Brocast("deleteWarehouseItem",data)
    UIPanel.ClosePage()
end
