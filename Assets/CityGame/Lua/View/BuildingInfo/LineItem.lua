---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/15 10:33
---Production line to be produced
LineItem = class("LineItem")

local ToNumber = tonumber
local StringSun = string.sub
--Luxury class
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function LineItem:initialize(lineDataInfo,prefab,luaBehaviour,buildingType)
    self.prefab = prefab
    self.buildingType = buildingType
    self.lineDataInfo = lineDataInfo
    self.lineId = lineDataInfo.id
    self.itemId = lineDataInfo.itemId

    self.iconImg = prefab.transform:Find("goodsInfo/iconImg"):GetComponent("Image")
    self.nameBg = prefab.transform:Find("goodsInfo/nameBg")
    self.nameText = prefab.transform:Find("goodsInfo/nameBg/nameText"):GetComponent("Text")
    self.levelImg = prefab.transform:Find("goodsInfo/goods/levelImg"):GetComponent("Image")
    self.brandNameText = prefab.transform:Find("goodsInfo/goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = prefab.transform:Find("goodsInfo/goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = prefab.transform:Find("goodsInfo/goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")

    self.stateText = prefab.transform:Find("stateBg/stateText"):GetComponent("Text")
    self.numberText = prefab.transform:Find("number/numberText"):GetComponent("Text")
    self.deleBtn = prefab.transform:Find("deleBtn")
    self.placedTopBtn = prefab.transform:Find("placedTopBtn")
    --Need to hide product information
    self.goods = prefab.transform:Find("goodsInfo/goods")

    luaBehaviour:AddClick(self.placedTopBtn.gameObject,self.clickPlacedTopBtn,self)
    luaBehaviour:AddClick(self.deleBtn.gameObject,self.deleLine,self)
    self:InitializeData()
end
function LineItem:InitializeData()
    self.nameText.text = GetLanguage(self.itemId)
    self.stateText.text = GetLanguage(25030017)
    self.numberText.text = self.lineDataInfo.nowCount.."/"..self.lineDataInfo.targetCount
    self.iconImg.sprite = SpriteManager.GetSpriteByPool(self.itemId)
    local materialKey,goodsKey = 21,22
    if ToNumber(StringSun(self.itemId,1,2)) == materialKey then
        self.goods.transform.localScale = Vector3.zero
        self.nameBg.transform.localPosition = Vector3(-140,-100,0)
        --LoadSprite(Material[self.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.itemId,1,2)) == goodsKey then
        self.goods.transform.localScale = Vector3.one
        --LoadSprite(Good[self.itemId].img,self.iconImg,false)
        --If it is a commodity, determine the raw material grade
        if Good[self.itemId].luxury == 1 then
            self.levelImg.color = getColorByVector3(oneLevel)
        elseif Good[self.itemId].luxury == 2 then
            self.levelImg.color = getColorByVector3(twoLevel)
        elseif Good[self.itemId].luxury == 3 then
            self.levelImg.color = getColorByVector3(threeLevel)
        end
        self.brandNameText.text = self.lineDataInfo.brandName
        self.brandValue.text = self.lineDataInfo.brandScore
        self.qualityValue.text = self.lineDataInfo.qtyScore
    end
end
--Top
function LineItem:clickPlacedTopBtn(ins)
    PlayMusEff(1002)
    --ct.log("fisher_w31_time","Clicked the top button!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    Event.Brocast("ProductionLineSettop",ins)
end
--delete
function LineItem:deleLine(ins)
    PlayMusEff(1002)
    --ct.log("fisher_w31_time","Clicked the delete button!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    Event.Brocast("deleListLine",ins)
end