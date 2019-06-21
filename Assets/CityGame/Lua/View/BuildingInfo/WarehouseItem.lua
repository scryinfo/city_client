---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/15 17:24
---
WarehouseItem = class('WarehouseItem')
local ToNumber = tonumber
local StringSun = string.sub
--奢侈等级
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function WarehouseItem:initialize(dataInfo,prefab,luaBehaviour,keyId,buildingType,stateType)
    self.keyId = keyId
    self.prefab = prefab
    self.dataInfo = ct.deepCopy(dataInfo)
    self.stateType = stateType[1]
    self.buildingId = stateType[2]
    self.buildingType = buildingType
    self.itemId = dataInfo.key.id

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
    self.detailsBtn = prefab.transform:Find("detailsBtn")

    luaBehaviour:AddClick(self.detailsBtn.gameObject,self._clickDetailsBtn,self)
    self:InitializeData()
end

function WarehouseItem:InitializeData()
    self.nameText.text = GetLanguage(self.itemId)
    self.numberText.text = "×"..self.dataInfo.n
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
        self.brandNameText.text = self.dataInfo.key.brandName
        self.brandValue.text = self.dataInfo.key.brandScore
        self.qualityValue.text = self.dataInfo.key.qualityScore
    end
end
--打开详情
function WarehouseItem:_clickDetailsBtn(ins)
    PlayMusEff(1002)
    if ins.stateType == GoodsItemStateType.addShelf then
        --上架
        ct.OpenCtrl("ShelfBoxCtrl",ins)
    elseif ins.stateType == GoodsItemStateType.transport then
        --运输
        ct.OpenCtrl("WarehouseBoxCtrl",ins)
    end
end
--刷新数量
function WarehouseItem:updateNumber(data)
    self.dataInfo.n = data.n
    self.numberText.text = "×"..self.dataInfo.n
end
--删除后刷新ID
function WarehouseItem:RefreshID(id)
    self.keyId = id;
end