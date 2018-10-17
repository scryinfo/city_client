local class = require 'Framework/class'

ShelfGoodsItem = class('ShelfGoodsItem')

--初始化方法   数据（读配置表）
function ShelfGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject;  --架子
    self.goodsicon = self.prefab.transform:Find("details/goodsicon");  --物品Icon
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text");  --物品名字
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text");  --物品数量
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text");  --物品价格
    self.XBtn = self.prefab.transform:Find("XBtn");  --删除按钮
    self.nameText.text = goodsDataInfo.name
    self.numberText.text = goodsDataInfo.number
    self.moneyText.text = goodsDataInfo.money
    self._luabehaviour:AddClick(self.XBtn.gameObject, self.OnXBtnClick, self);

end
--删除
function ShelfGoodsItem:OnXBtnClick(go)
    log('fisher_week9_ShelfGoodsItem','[ShelfGoodsItem:OnXBtnClick] my id = ', go.id)
    go.manager:_deleteGoods(go)
end
--删除后刷新ID及刷新显示
function ShelfGoodsItem:RefreshID(id)
    self.id = id
    if id % 5 == 0 then
        self.shelfImg:SetActive(true);
    else
        self.shelfImg:SetActive(false);
    end
end
