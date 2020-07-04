---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/15 15:44
---City information 6-column ranking
RankSixItem = class('RankSixItem')

--Initialization method data (read configuration table)
function RankSixItem:initialize(inluabehaviour, prefab, goodsDataInfo,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.id = id

    self.rank = self.prefab.transform:Find("rank"):GetComponent("Text")
    self.icon = self.prefab.transform:Find("head/icon")
    self.name = self.prefab.transform:Find("head/name"):GetComponent("Text");
    self.income = self.prefab.transform:Find("income"):GetComponent("Text");
    self.staff = self.prefab.transform:Find("staff"):GetComponent("Text");
    self.technology = self.prefab.transform:Find("technology"):GetComponent("Text");
    self.market = self.prefab.transform:Find("market"):GetComponent("Text");

    self.my_avatarData = AvatarManger.GetSmallAvatar(goodsDataInfo.faceId,self.icon,0.15)
    self.rank.text = id
    self.name.text = goodsDataInfo.name
    self.income.text = goodsDataInfo.income
    self.staff.text = goodsDataInfo.woker
    self.technology.text = goodsDataInfo.science
    self.market.text = goodsDataInfo.promotion
end