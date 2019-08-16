---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/29 15:29
--- 货架上的数据卡片
DataSaleCardItem = class('DataSaleCardItem')

--初始化方法   数据（读配置表）
function DataSaleCardItem:initialize(inluabehaviour, prefab, goodsDataInfo,building,myOwnerID,ownerId)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.building = building
    self.type = goodsDataInfo.k.id
    self.n = goodsDataInfo.n
    self.autoReplenish = goodsDataInfo.autoReplenish
    self.storeNum = goodsDataInfo.storeNum
    self.prices = goodsDataInfo.price
    self.myOwnerID = myOwnerID
    self.ownerId = ownerId

    self.bg = self.prefab.transform:Find("bg").gameObject
    self.auto = self.prefab.transform:Find("auto")
    self.vacant = self.prefab.transform:Find("vacant")
    self.vacantText = self.prefab.transform:Find("vacant/Text"):GetComponent("Text")
    self.num = self.prefab.transform:Find("num"):GetComponent("Text")
    self.name = self.prefab.transform:Find("down/name"):GetComponent("Text")
    self.icon = self.prefab.transform:Find("icon/Image"):GetComponent("Image")
    self.price = self.prefab.transform:Find("down/priceBg/price"):GetComponent("Text")

    LoadSprite(ResearchConfig[goodsDataInfo.k.id].iconPath, self.icon, true)
    self.vacantText.text = GetLanguage(25060016)
    if myOwnerID then
        if goodsDataInfo.autoReplenish then
            if goodsDataInfo.n == 0 then
                self.vacant.localScale = Vector3.one
                self.auto.localScale = Vector3.zero
            else
                self.auto.localScale = Vector3.one
                self.vacant.localScale = Vector3.zero
            end
        else
            self.auto.localScale = Vector3.zero
            self.vacant.localScale = Vector3.zero
        end
    else
        self.auto.localScale = Vector3.zero
        self.vacant.localScale = Vector3.zero
    end
    self.num.text = "x" .. goodsDataInfo.n
    self.name.text = GetLanguage(ResearchConfig[goodsDataInfo.k.id].name)
    self.price.text = GetClientPriceString(goodsDataInfo.price)

    self._luabehaviour:AddClick(self.bg, self.OnBg, self);

end

function DataSaleCardItem:OnBg(go)
    PlayMusEff(1002)
    if go.myOwnerID then
        local data = {}
        data.wareHouse = go.storeNum
        data.sale = go.n
        data.itemId = go.type
        data.building = go.building
        data.autoReplenish = go.autoReplenish
        data.price =  go.prices
        data.shelf = Shelf.SetShelf
        ct.OpenCtrl("DataShelfCtrl",data)
    else
        local data = {}
        data.sale = go.n
        data.itemId = go.type
        data.myOwner = go.myOwnerID
        data.price = go.prices
        data.buyFunc = function(num,price)
            DataManager.DetailModelRpcNoRet(go.building, 'm_buyData',go.building,go.type,num,go.prices,go.ownerId)
        end
        ct.OpenCtrl("UserDataCtrl",data)
    end
end