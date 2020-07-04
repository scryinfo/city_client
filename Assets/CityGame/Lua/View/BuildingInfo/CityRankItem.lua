---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/17 15:55
--- City Ranking
CityRankItem = class('CityRankItem')

--Initialization method data (read configuration table)
function CityRankItem:initialize(inluabehaviour, prefab, goodsDataInfo,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.id = id

    self.rankImage = self.prefab.transform:Find("rankImage"):GetComponent("Image")
    self.rank = self.prefab.transform:Find("rank"):GetComponent("Text")
    self.icon = self.prefab.transform:Find("head/icon")
    self.name = self.prefab.transform:Find("head/name"):GetComponent("Text");
    self.income = self.prefab.transform:Find("income"):GetComponent("Text");
    self.staff = self.prefab.transform:Find("staff"):GetComponent("Text");
    self.technology = self.prefab.transform:Find("technology"):GetComponent("Text");
    self.market = self.prefab.transform:Find("market"):GetComponent("Text");

    self.my_avatarData = AvatarManger.GetSmallAvatar(goodsDataInfo.faceId,self.icon,0.15)

    if id == 1 or id == 2 or id == 3 then
        LoadSprite("Assets/CityGame/Resources/Atlas/CityInfo/" .. id ..".png", self.rankImage, true)
        self.rankImage.transform.localScale = Vector3.one
        self.rank.transform.localScale = Vector3.zero
    else
        self.rankImage.transform.localScale = Vector3.zero
        self.rank.transform.localScale = Vector3.one
        self.rank.text = id
    end
    self.name.text = goodsDataInfo.name
    self.income.text = goodsDataInfo.income
    self.staff.text = goodsDataInfo.woker
    self.technology.text = goodsDataInfo.science
    self.market.text = goodsDataInfo.promotion
end