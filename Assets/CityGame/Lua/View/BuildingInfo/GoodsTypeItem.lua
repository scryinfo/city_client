---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/5/21 15:01
---Building Information Commodity Classification Item
GoodsTypeItem = class('GoodsTypeItem')

local ToNumber = tonumber
local StringSun = string.sub
--Luxury class
local oneLevel = Vector3.New(105,174,238)
local twoLevel = Vector3.New(156,136,228)
local threeLevel = Vector3.New(243,185,45)
function GoodsTypeItem:initialize(dataInfo,prefab,luaBehaviour)
    self.prefab = prefab
    self.dataInfo = dataInfo

    self.iconImg = prefab.transform:Find("iconImg"):GetComponent("Image")
    self.nameBg = prefab.transform:Find("nameBg")
    self.nameText = prefab.transform:Find("nameBg/nameText"):GetComponent("Text")
    self.goods = prefab.transform:Find("goods")
    self.levelImg = prefab.transform:Find("goods/levelImg"):GetComponent("Image")
    self.brandNameText = prefab.transform:Find("goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = prefab.transform:Find("goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = prefab.transform:Find("goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")
    self.speedText = prefab.transform:Find("speedBg/speedText"):GetComponent("Text")
    self.unitText = prefab.transform:Find("speedBg/speedText/unitText"):GetComponent("Text")
    self.detailsBtn = prefab.transform:Find("detailsBtn")

    self:initializeUiInfoData()
    luaBehaviour:AddClick(self.detailsBtn.gameObject,self._clickDetailsBtn,self)
end
--initialization
function GoodsTypeItem:initializeUiInfoData()
    self.nameText.text = GetLanguage(self.dataInfo.itemId)
    self.speedText.text = self.dataInfo.numOneSec * 400
    if ToNumber(StringSun(self.dataInfo.itemId,1,2)) == 21 then
        --raw material
        self.goods.transform.localScale = Vector3.zero
        self.nameBg.transform.localPosition = Vector3(-140,-100,0)
        LoadSprite(Material[self.dataInfo.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.dataInfo.itemId,1,2)) == 22 then
        --commodity
        self.goods.transform.localScale = Vector3.one
        LoadSprite(Good[self.dataInfo.itemId].img,self.iconImg,false)
        --Judge the grade of raw materials
        if Good[self.dataInfo.itemId].luxury == 1 then
            self.levelImg.color = getColorByVector3(oneLevel)
        elseif Good[self.dataInfo.itemId].luxury == 2 then
            self.levelImg.color = getColorByVector3(twoLevel)
        elseif Good[self.dataInfo.itemId].luxury == 3 then
            self.levelImg.color = getColorByVector3(threeLevel)
        end
    end

end
--Click to open details
function GoodsTypeItem:_clickDetailsBtn(ins)
    ct.OpenCtrl("GoodsTypeBoxCtrl",ins.dataInfo)
end


---Building Information Button Category Item
ButtonTypeItem = class('ButtonTypeItem')
function ButtonTypeItem:initialize(dataInfo,prefab,luaBehaviour)
    self.prefab = prefab
    self.dataInfo = dataInfo
    self.typeId = dataInfo.typeId

    self.nomal = prefab.transform:Find("nomal"):GetComponent("Toggle")
    self.nomalText = prefab.transform:Find("nomal/nomalText"):GetComponent("Text")
    self.choose = prefab.transform:Find("choose")
    self.chooseText = prefab.transform:Find("choose/chooseText"):GetComponent("Text")

    self:initializeUiInfoData()
    self.nomal.onValueChanged:AddListener(function()
        self:showState()
    end)
end
--initialization
function ButtonTypeItem:initializeUiInfoData()
    if self.dataInfo.typeId == 2251 then
        self.nomalText.text = GetLanguage(20030002)
        self.chooseText.text = GetLanguage(20030002)
    elseif self.dataInfo.typeId == 2252 then
        self.nomalText.text = GetLanguage(20030001)
        self.chooseText.text = GetLanguage(20030001)
    end

    if self.nomal.isOn then
        self.choose.transform.localScale = Vector3.one
    else
        self.choose.transform.localScale = Vector3.zero
    end
end
function ButtonTypeItem:showState()
    if self.nomal.isOn then
        self.choose.transform.localScale = Vector3.one
        Event.Brocast("goodsType",self.typeId)
    else
        self.choose.transform.localScale = Vector3.zero
    end
end