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

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(homePageShelfInfo.k.id / 100000) == materialKey then
        self.nameText.text = Material[homePageShelfInfo.k.id].name
        panelMgr:LoadPrefab_A(Material[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    elseif math.floor(homePageShelfInfo.k.id / 100000) == goodsKey then
        self.nameText.text = Good[homePageShelfInfo.k.id].name
        panelMgr:LoadPrefab_A(Good[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.icon.sprite = texture
            end
        end)
    end
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

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(homePageProductionLineInfo.itemId / 100000) == materialKey then
        self.nameText.text = Material[homePageProductionLineInfo.itemId].name
        panelMgr:LoadPrefab_A(Material[homePageProductionLineInfo.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    elseif math.floor(homePageProductionLineInfo.itemId / 100000) == goodsKey then
        self.nameText.text = Good[homePageProductionLineInfo.itemId].name
        panelMgr:LoadPrefab_A(Good[homePageProductionLineInfo.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    end
    --self.nameText.text = Material[homePageProductionLineInfo.itemId].name
    --self.timeText =
    --self.productionText =
    self.productionSlider.maxValue = homePageProductionLineInfo.targetCount
    self.productionSlider.value = homePageProductionLineInfo.nowCount
    self.numberText.text = self.productionSlider.value.."/"..self.productionSlider.maxValue
end
