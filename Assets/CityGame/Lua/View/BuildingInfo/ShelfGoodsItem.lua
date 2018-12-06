ShelfGoodsItem = class('ShelfGoodsItem')

--初始化方法   数据（接受服务器）
function ShelfGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.itemId = goodsDataInfo.itemId
    self.num = goodsDataInfo.number
    self.name = goodsDataInfo.name
    self.price = goodsDataInfo.price
    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject;  --架子
    self.goodsicon = self.prefab.transform:Find("details/goodsicon");  --物品Icon
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text");  --物品名字
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text");  --物品数量
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text");  --物品价格
    self.XBtn = self.prefab.transform:Find("XBtn");  --删除按钮
    self.detailsBtn = self.prefab.transform:Find("detailsBtn");  --点击商品查看详情
    self.nameText.text = goodsDataInfo.name
    self.numberText.text = goodsDataInfo.number
    self.moneyText.text = goodsDataInfo.money

    self._luabehaviour:AddClick(self.XBtn.gameObject, self.OnClicl_XBtn, self);
    self._luabehaviour:AddClick(self.detailsBtn.gameObject,self.OnClick_detailsBtn,self);

end
--点击删除
function ShelfGoodsItem:OnClicl_XBtn(go)
    Event.Brocast("m_ReqShelfDel",MaterialModel.buildingId,go.itemId,go.numberText.text)
    Event.Brocast("SmallPop","下架成功",300)
    go.manager:_deleteGoods(go)
end
function ShelfGoodsItem:OnClick_detailsBtn(ins)
    UIPage:ShowPage(DETAILSBoxCtrl,ins);
end
--删除后刷新ID及刷新架子显示
function ShelfGoodsItem:RefreshID(id)
    self.id = id
    if id % 5 == 0 then
        self.shelfImg:SetActive(true);
    else
        self.shelfImg:SetActive(false);
    end
end
function ShelfGoodsItem:RefreshData(data,id)
    self.id = id
    self.num = data.num
    self.name = data.name
    self.itemId = data.itemId
    self.price = data.price
    --self.producerId = data.producerId
    --self.qty = data.qty
end