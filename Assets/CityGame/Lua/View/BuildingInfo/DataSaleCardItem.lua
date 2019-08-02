---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/29 15:29
--- 货架上的数据卡片
DataSaleCardItem = class('DataSaleCardItem')

--初始化方法   数据（读配置表）
function DataSaleCardItem:initialize(inluabehaviour, prefab, goodsDataInfo)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour

    self.bg = self.prefab.transform:Find("bg").gameObject
    self.num = self.prefab.transform:Find("num"):GetComponent("Text");
    self.name = self.prefab.transform:Find("down/name"):GetComponent("Text");
    self.price = self.prefab.transform:Find("down/priceBg/price"):GetComponent("Text");

    self._luabehaviour:AddClick(self.bg, self.OnBg, self);

end

function DataSaleCardItem:OnBg()
    PlayMusEff(1002)
end