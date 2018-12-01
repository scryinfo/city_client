SmallShelfRateItem = class('SmallShelfRateItem')

--初始化
function SmallShelfRateItem:initialize(type,goodsDataInfo,prefab)

end

--主页货架
function SmallShelfRateItem:homePageShelf(goodsDataInfo,prefab)
    self.prefab = prefab;
    self.iconImg = self.prefab.transform:Find("iconImg"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("pricetag/MoneyText"):GetComponent("Text");

    self.nameText.text = goodsDataInfo.name
    self.numberText.text = goodsDataInfo.number
    self.moneyText.text = goodsDataInfo.price
end
--主页生产线
--function SmallShelfRateItem:homePageProductionLine()
--
--end
