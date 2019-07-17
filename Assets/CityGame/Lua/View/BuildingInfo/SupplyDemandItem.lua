---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/1 10:18
---供应需求item
SupplyDemandItem = class('SupplyDemandItem')
--初始化方法
function SupplyDemandItem:initialize(dataInfo, viewRect)
    self.dataInfo = dataInfo
    self.viewRect = viewRect
    self.itemId = dataInfo.itemId
    local viewTrans = self.viewRect

    self.bg = viewTrans:Find("bg").gameObject  --背景
    self.goods = viewTrans:Find("goodsbg/goods"):GetComponent("Image")  --物品图片
    self.name = viewTrans:Find("name"):GetComponent("Text")  --物品名字
    self.slider = viewTrans:Find("Slider"):GetComponent("Slider")
    self.demand = viewTrans:Find("Slider/Text"):GetComponent("Text")        --需求
    self.supply = viewTrans:Find("Slider/Fill Area/Fill/Text"):GetComponent("Text")   --供应
    self.beyond = viewTrans:Find("beyond")        --超出后的图片
    self.beyondText = viewTrans:Find("beyond/beyondText"):GetComponent("Text")   --超出后的数量

    LoadSprite(SupplyDemandGood[dataInfo.itemId], self.goods)
    self.name.text = GetLanguage(dataInfo.itemId)
    if dataInfo.demand == nil then
        dataInfo.demand = 0
    end
    if dataInfo.supply == nil then
        dataInfo.supply = 0
    end
    if dataInfo.supply > dataInfo.demand  then
        self.beyond.localScale = Vector3.one
        self.supply.transform.localScale = Vector3.zero
        self.beyondText.text = dataInfo.supply
    else
        self.beyond.localScale = Vector3.zero
        self.supply.transform.localScale = Vector3.one
        self.supply.text = dataInfo.supply
    end
    self.slider.maxValue = dataInfo.demand
    self.slider.value = dataInfo.supply
    self.demand.text = dataInfo.demand
end
