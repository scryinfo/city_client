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
    self.materBg = self.prefab.transform:Find("materBg")
    self.goodsBg = self.prefab.transform:Find("goodsBg")
    self.brandName = self.prefab.transform:Find("goodsBg/brandbg/brandName"):GetComponent("Text")
    self.iconImg = self.prefab.transform:Find("iconImg"):GetComponent("Image")
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text")
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text")
    self.moneyText = self.prefab.transform:Find("pricetag/MoneyText"):GetComponent("Text")

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(homePageShelfInfo.k.id / 100000) == materialKey then
        self.materBg.transform.localScale = Vector3.one
        self.goodsBg.transform.localScale = Vector3.zero
        --self.nameText.text = GetLanguage(homePageShelfInfo.k.id)
        panelMgr:LoadPrefab_A(Material[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    elseif math.floor(homePageShelfInfo.k.id / 100000) == goodsKey then
        self.materBg.transform.localScale = Vector3.zero
        self.goodsBg.transform.localScale = Vector3.one
        panelMgr:LoadPrefab_A(Good[homePageShelfInfo.k.id].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.iconImg.sprite = texture
            end
        end)
    end
    self.nameText.text = GetLanguage(homePageShelfInfo.k.id)
    self.numberText.text = homePageShelfInfo.n
    self.moneyText.text = "E"..getPriceString(GetClientPriceString(homePageShelfInfo.price),15,13)
end