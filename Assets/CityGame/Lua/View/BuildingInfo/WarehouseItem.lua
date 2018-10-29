WarehouseItem = class('WarehouseItem')

--初始化方法   数据（接受服务器）
function WarehouseItem:initialize(goodsDataInfo,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.bgBtn = self.prefab.transform:Find("bgBtn");  --物品btn，点击勾选物品，默认为false
    self.icon = self.prefab.transform:Find("icon");  --物品Icon
    self.circleGreayImg = self.prefab.transform:Find("circleGreayImg").gameObject;  --圆
    self.circleTickImg = self.prefab.transform:Find("circleGreayImg/circleTickImg").gameObject;  --勾选
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");  --名字
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");  --数量
    self.closeBtn = self.prefab.transform:Find("closeBtn");  --删除btn  默认true
    self.nameText.text = goodsDataInfo.name
    self.numberText.text = goodsDataInfo.number

    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false;
    --普通消息注册
    Event.AddListener("c_GoodsItemChoose",self.c_GoodsItemChoose,self);
    Event.AddListener("c_GoodsItemDelete",self.c_GoodsItemDelete,self);

    self._luabehaviour:AddClick(self.closeBtn.gameObject, self.OnClick_closeBtn,self);
    self._luabehaviour:AddClick(self.bgBtn.gameObject,self.OnClick_bgBtn,self);
end

--Item 状态 可以选择
function WarehouseItem:c_GoodsItemChoose()
    self.circleGreayImg:SetActive(true);
    self.closeBtn.gameObject:SetActive(false);
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = true;
end
--Item 状态 选择
function WarehouseItem:c_GoodsItemSelected()
    self.circleTickImg:SetActive(true);
end
--Item 状态 可以删除
function WarehouseItem:c_GoodsItemDelete()
    self.circleGreayImg:SetActive(false);
    self.closeBtn.gameObject:SetActive(true);
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false;
end
--勾选物品
function WarehouseItem:OnClick_bgBtn(ins)
    --go.manager:_selectedGoods(go);
    --WarehouseCtrl:_selectedGoods(go)

    Event.Brocast("c_warehouseClick", ins.id)
end
--删除
function WarehouseItem:OnClick_closeBtn(go)
    --关闭消息事件
    Event.RemoveListener("c_GoodsItemChoose",go.c_GoodsItemChoose, go);
    Event.RemoveListener("c_GoodsItemDelete",go.c_GoodsItemDelete, go);
    go.manager:_WarehousedeleteGoods(go);

end
--删除后刷新ID及显示
function WarehouseItem:RefreshID(id)
    self.id = id;
end
