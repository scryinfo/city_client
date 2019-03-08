HomePageDisplay = class('HomePageDisplay')

--初始化
function HomePageDisplay:initialize(type,goodsDataInfo,prefab)
    if type == ct.homePage.shelf then
        self:homePageShelf(goodsDataInfo,prefab)
    end
end

--主页货架
function HomePageDisplay:homePageShelf(homePageShelfInfo,prefab)
    self.prefab = prefab;
    self.itemId = homePageShelfInfo.k.id
    self.iconImg = self.prefab.transform:Find("iconImg"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("pricetag/MoneyText"):GetComponent("Text");

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(homePageShelfInfo.k.id / 100000) == materialKey then
        --self.nameText.text = Material[homePageShelfInfo.k.id].name
        self.nameText.text = GetLanguage(homePageShelfInfo.k.id)
        panelMgr:LoadPrefab_A(Material[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    elseif math.floor(homePageShelfInfo.k.id / 100000) == goodsKey then
        self.nameText.text = GetLanguage(homePageShelfInfo.k.id)
        panelMgr:LoadPrefab_A(Good[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    end
    self.numberText.text = homePageShelfInfo.n
    self.moneyText.text = "E"..getPriceString(GetClientPriceString(homePageShelfInfo.price),15,13)
end