HomePageDisplay = class('HomePageDisplay')

--初始化
function HomePageDisplay:initialize(type,goodsDataInfo,prefab)
    if type == ct.homePage.shelf then
        self:homePageShelf(goodsDataInfo,prefab)
    elseif type == ct.homePage.productionLine then
        self:homePageProductionLine(goodsDataInfo,prefab)
    end
end

--主页货架
function HomePageDisplay:homePageShelf(homePageShelfInfo,prefab)
    self.prefab = prefab;
    self.iconImg = self.prefab.transform:Find("iconImg"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("pricetag/MoneyText"):GetComponent("Text");

    self.nameText.text = Material[homePageShelfInfo.k.id].name
    self.numberText.text = homePageShelfInfo.n
    self.moneyText.text = getPriceString("E"..homePageShelfInfo.price..".0000",15,13)
end
--主页生产线
function HomePageDisplay:homePageProductionLine(homePageProductionLineInfo,prefab)
    self.prefab = prefab;
    self.iconImg = self.prefab.transform:Find("iconImg"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.timeText = self.prefab.transform:Find("timeImg/timeText"):GetComponent("Text");
    self.productionText = self.prefab.transform:Find("productionText"):GetComponent("Text");
    self.productionSlider = self.prefab.transform:Find("productionSlider"):GetComponent("Slider");
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");

    self.nameText.text = Material[homePageProductionLineInfo.itemId].name
    --self.timeText =
    --self.productionText =
    self.productionSlider.maxValue = homePageProductionLineInfo.targetCount
    self.productionSlider.value = homePageProductionLineInfo.nowCount
    self.numberText.text = self.productionSlider.value.."/"..self.productionSlider.maxValue
end
