---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/5/21 15:01
---建筑信息商品分类Item
GoodsTypeItem = class('GoodsTypeItem')

function GoodsTypeItem:initialize(dataInfo,prefab,luaBehaviour)
    self.prefab = prefab
    self.dataInfo = dataInfo

    self.iconImg = prefab.transform:Find("iconImg"):GetComponent("Image")
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
end

function convert()
    local myString = [[ 1.000000000000000E+00,2.000000000000000E+02,  -1.000000000000000E+05 ]]
    local function convert(csv)
        local list = {}
        for value in (csv .. ","):gmatch("(%S+)%W*,") do table.insert(list,tonumber(value)) end
        return unpack(list)
    end
    print(convert(myString))
end
--初始化
function GoodsTypeItem:initializeUiInfoData()
    self.nameText.text = GetLanguage(self.dataInfo.itemId)
    convert()
end



---建筑信息button分类Item
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
--初始化
function ButtonTypeItem:initializeUiInfoData()
    self.nomalText.text = self.dataInfo.name
    self.chooseText.text = self.dataInfo.name
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