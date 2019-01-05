WarehouseItem = class('WarehouseItem')

--初始化方法   数据（接受服务器）
function WarehouseItem:initialize(goodsDataInfo,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.itemId = goodsDataInfo.key.id;

    self.n = goodsDataInfo.n
    self.bgBtn = self.prefab.transform:Find("bgBtn");  --物品btn，点击勾选物品，默认为false
    self.icon = self.prefab.transform:Find("icon"):GetComponent("Image");  --物品Icon
    self.circleGreayImg = self.prefab.transform:Find("circleGreayImg"):GetComponent("RectTransform");  --圆
    self.circleTickImg = self.prefab.transform:Find("circleGreayImg/circleTickImg"):GetComponent("RectTransform");  --勾选
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");  --名字
    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");  --数量
    self.closeBtn = self.prefab.transform:Find("closeBtn"):GetComponent("RectTransform");  --删除btn  默认true

    self.numberText.text = self.n

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        self.nameText.text = Material[self.itemId].name;
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.icon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = Good[self.itemId].name;
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.icon.sprite = texture
            end
        end)
    end
    --赋值
    --self.nameText.text = self.name

    --self.itemId = goodsDataInfo.itemId
    --初始化ItemUI状态
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false;
    self.circleGreayImg.transform.localScale = Vector3.zero;
    self.circleTickImg.transform.localScale = Vector3.zero;
    --本地消息注册
    Event.AddListener("c_GoodsItemChoose",self.c_GoodsItemChoose,self);
    Event.AddListener("c_GoodsItemDelete",self.c_GoodsItemDelete,self);
    --点击事件
    self._luabehaviour:AddClick(self.closeBtn.gameObject, self.OnClick_closeBtn,self);
    self._luabehaviour:AddClick(self.bgBtn.gameObject,self.OnClick_bgBtn,self);
end
--Item状态 选择
function WarehouseItem:c_GoodsItemChoose()
    self.circleGreayImg.transform.localScale = Vector3.one;
    self.closeBtn.transform.localScale = Vector3.zero
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = true;
end
----Item状态 选中
--function WarehouseItem:c_GoodsItemSelected()
--    self.circleTickImg.transform.localScale = Vector3.zero;
--end
--Item状态 删除
function WarehouseItem:c_GoodsItemDelete()
    self.circleGreayImg.transform.localScale = Vector3.zero;
    self.closeBtn.transform.localScale = Vector3.one
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false;
end
--勾选物品
function WarehouseItem:OnClick_bgBtn(ins)
    Event.Brocast("c_warehouseClick", ins)
end
--删除事件
function WarehouseItem:closeEvent()
    Event.RemoveListener("c_GoodsItemChoose",self.c_GoodsItemChoose,self);
    Event.RemoveListener("c_GoodsItemDelete",self.c_GoodsItemDelete,self);
end
--删除
function WarehouseItem:OnClick_closeBtn(go)
    go.manager:_WarehousedeleteGoods(go.id);
end
--删除后刷新ID及显示
function WarehouseItem:RefreshID(id)
    self.id = id;
end
function WarehouseItem:RefreshData(data,id)
    self.id = id
    self.n = data.num
    self.name = data.name
    self.itemId = data.itemId
    --self.producerId = data.producerId
    --self.qty = data.qty
end