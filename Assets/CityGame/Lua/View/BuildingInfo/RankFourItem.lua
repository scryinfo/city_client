---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/15 15:13
---城市信息4列排行榜
RankFourItem = class('RankFourItem')

--初始化方法   数据（读配置表）
function RankFourItem:initialize(inluabehaviour, prefab, goodsDataInfo,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.id = id

    self.rank = self.prefab.transform:Find("rank"):GetComponent("Text")
    self.icon = self.prefab.transform:Find("head/icon")
    self.name = self.prefab.transform:Find("head/name"):GetComponent("Text");
    self.income = self.prefab.transform:Find("income"):GetComponent("Text");
    self.volume = self.prefab.transform:Find("volume"):GetComponent("Text");

    self.my_avatarData = AvatarManger.GetSmallAvatar(goodsDataInfo.faceId,self.icon,0.15)
    self.rank.text = id
    self.name.text = goodsDataInfo.name
    self.income.text = goodsDataInfo.income
    self.volume.text = goodsDataInfo.count
end