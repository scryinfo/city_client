---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/19 16:40
---
ShelfItem = class('ShelfItem')
local ToNumber = tonumber
local StringSun = string.sub
function ShelfItem:initialize(dataInfo,prefab,luaBehaviour,keyId,buildingType,stateType)
    self.keyId = keyId
    self.prefab = prefab
    self.dataInfo = dataInfo
    self.buildingId = stateType[1]
    self.isOther = stateType[2]
    self.buildingType = buildingType
    self.itemId = dataInfo.k.id

    self.iconImg = prefab.transform:Find("iconImg"):GetComponent("Image")
    self.numberText = prefab.transform:Find("numberBg/numberText"):GetComponent("Text")
    self.nameBg = prefab.transform:Find("nameBg")
    self.nameText = prefab.transform:Find("nameBg/nameText"):GetComponent("Text")

    --需要隐藏的商品信息
    self.goods = prefab.transform:Find("goods")
    self.levelImg = prefab.transform:Find("goods/levelImg"):GetComponent("Image")
    self.brandNameText = prefab.transform:Find("goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = prefab.transform:Find("goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = prefab.transform:Find("goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")
    self.priceText = prefab.transform:Find("priceBg/priceText"):GetComponent("Text")
    self.detailsBtn = prefab.transform:Find("detailsBtn")

    luaBehaviour:AddClick(self.detailsBtn.gameObject,self._clickDetailsBtn,self)

    self:InitializeData()
end
function ShelfItem:InitializeData()
    self.nameText.text = GetLanguage(self.itemId)
    self.numberText.text = "×"..self.dataInfo.n
    self.priceText.text = GetClientPriceString(self.dataInfo.price)
    local materialKey,goodsKey = 21,22
    if ToNumber(StringSun(self.itemId,1,2)) == materialKey then
        self.goods.transform.localScale = Vector3.zero
        self.nameBg.transform.localPosition = Vector3(-140,-100,0)
        LoadSprite(Material[self.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.itemId,1,2)) == goodsKey then
        self.goods.transform.localScale = Vector3.one
        LoadSprite(Good[self.itemId].img,self.iconImg,false)
        --self.levelImg
        --self.brandNameText
        --self.brandValue
        --self.qualityValue
    end
end
--点击详情购买
function ShelfItem:_clickDetailsBtn(ins)
    --货架上如果是自己点击
    if ins.isOther == false then
        ct.OpenCtrl("ShelfBoxCtrl",ins)
    else
        --别人点击
        ct.OpenCtrl("BuyBoxCtrl",ins)
    end
end
--删除后刷新ID
function ShelfItem:RefreshID(id)
    self.keyId = id;
end