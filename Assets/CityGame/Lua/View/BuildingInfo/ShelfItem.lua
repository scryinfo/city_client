---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/19 16:40
---
ShelfItem = class('ShelfItem')
local ToNumber = tonumber
local StringSun = string.sub
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function ShelfItem:initialize(dataInfo,prefab,luaBehaviour,keyId,buildingType,stateType)
    self.keyId = keyId
    self.prefab = prefab
    self.dataInfo = ct.deepCopy(dataInfo)
    self.buildingId = stateType[1]
    self.isOther = stateType[2]
    self.buildingType = buildingType
    self.itemId = dataInfo.k.id

    self.iconImg = prefab.transform:Find("iconImg"):GetComponent("Image")

    self.numberBg = prefab.transform:Find("numberBg")
    self.numberText = prefab.transform:Find("numberBg/numberText"):GetComponent("Text")
    self.noHaveBg = prefab.transform:Find("noHaveBg")
    self.automaticBg = prefab.transform:Find("automaticBg")
    self.automaticNumberText = prefab.transform:Find("automaticBg/automaticNumberText"):GetComponent("Text")

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
    if self.dataInfo.autoReplenish == true then
        self.numberBg.transform.localScale = Vector3.zero
        if self.dataInfo.n == 0 then
            self.automaticBg.transform.localScale = Vector3.zero
            self.noHaveBg.transform.localScale = Vector3.one
        else
            self.automaticBg.transform.localScale = Vector3.one
            self.automaticNumberText.text = "×"..self.dataInfo.n
            self.noHaveBg.transform.localScale = Vector3.zero
        end
    else
        self.numberBg.transform.localScale = Vector3.one
        self.automaticBg.transform.localScale = Vector3.zero
        self.noHaveBg.transform.localScale = Vector3.zero
    end
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
        --如果是商品，判断原料等级
        if Good[self.itemId].luxury == 1 then
            self.levelImg.color = getColorByVector3(oneLevel)
        elseif Good[self.itemId].luxury == 2 then
            self.levelImg.color = getColorByVector3(twoLevel)
        elseif Good[self.itemId].luxury == 3 then
            self.levelImg.color = getColorByVector3(threeLevel)
        end
        self.brandNameText.text = self.dataInfo.k.brandName
        self.brandValue.text = self.dataInfo.k.brandScore
        self.qualityValue.text = self.dataInfo.k.qualityScore
    end
end
--点击详情购买
function ShelfItem:_clickDetailsBtn(ins)
    --如果是零售店
    if ins.buildingType == BuildingType.RetailShop then
        if ins.isOther == true then
            Event.Brocast("SmallPop",GetLanguage(25060011), ReminderType.Common)
            return
        end
    end
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