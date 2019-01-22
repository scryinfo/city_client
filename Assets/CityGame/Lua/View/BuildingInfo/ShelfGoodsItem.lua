ShelfGoodsItem = class('ShelfGoodsItem')

--初始化方法   数据（接受服务器）
function ShelfGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id,state,buildingId)
    self.id = id
    self.manager = mgr
    self.state = state
    self.prefab = prefab;
    self.buildingId = buildingId
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.itemId = goodsDataInfo.k.id
    self.num = goodsDataInfo.n
    self.name = Material[self.itemId].name
    self.price = goodsDataInfo.price
    self.bgBtn = self.prefab.transform:Find("bgBtn");  --物品btn，点击勾选物品，默认为false
    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject;  --架子
    self.goodsicon = self.prefab.transform:Find("details/goodsicon"):GetComponent("Image");  --物品Icon
    self.circleGreayImg = self.prefab.transform:Find("circleGreayImg"):GetComponent("RectTransform");  --圆
    self.circleTickImg = self.prefab.transform:Find("circleGreayImg/circleTickImg"):GetComponent("RectTransform");  --勾选
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text");  --物品名字
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text");  --物品数量
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text");  --物品价格
    self.XBtn = self.prefab.transform:Find("XBtn");  --删除按钮
    self.detailsBtn = self.prefab.transform:Find("detailsBtn");  --点击商品查看详情

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        --self.nameText.text = Material[self.itemId].name;
        self.nameText.text = GetLanguage(self.itemId);
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsicon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.nameText.text = GetLanguage(self.itemId);
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsicon.sprite = texture
            end
        end)
    end

    --赋值
    --self.nameText.text = self.name
    self.numberText.text = self.num
    self.moneyText.text = self.price..".0000"

    --点击事件
    self._luabehaviour:AddClick(self.bgBtn.gameObject,self.OnClick_bgBtn,self);
    self._luabehaviour:AddClick(self.XBtn.gameObject, self.OnClicl_XBtn, self);
    self._luabehaviour:AddClick(self.detailsBtn.gameObject,self.OnClick_detailsBtn,self);
    --初始化ItemUI状态
    self.circleGreayImg.transform.localScale = Vector3.zero;
    self.circleTickImg.transform.localScale = Vector3.zero;
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false;
    self:initializeUiState()
    --本地消息注册
    Event.AddListener("c_buyGoodsItemChoose",self.c_buyGoodsItemChoose,self);
    Event.AddListener("c_buyGoodsItemDelete",self.c_buyGoodsItemDelete,self);
end
--初始化UI状态
function ShelfGoodsItem:initializeUiState()
    if self.state then
        self.XBtn.transform.localScale = Vector3.New(0,0,0);
        self.detailsBtn.transform.localScale = Vector3.New(0,0,0);
    else
        self.XBtn.transform.localScale = Vector3.New(1,1,1);
        self.detailsBtn.transform.localScale = Vector3.New(1,1,1);
    end
end
--Item状态 选择
function ShelfGoodsItem:c_buyGoodsItemChoose()
    self.circleGreayImg.transform.localScale = Vector3.one;
    --self.XBtn.transform.localScale = Vector3.zero
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = true;
end
----Item状态 选中
--function ShelfGoodsItem:c_buyGoodsItemSelected()
--    self.circleTickImg.transform.localScale = Vector3.zero;
--end
--Item状态 删除
function ShelfGoodsItem:c_buyGoodsItemDelete()
    self.circleGreayImg.transform.localScale = Vector3.zero;
    --self.XBtn.transform.localScale = Vector3.one
    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false;
end
--勾选物品
function ShelfGoodsItem:OnClick_bgBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("_selectedBuyGoods",ins);
end
--点击删除
function ShelfGoodsItem:OnClicl_XBtn(go)
    PlayMusEff(1002)
    Event.Brocast("m_ReqShelfDel",go.buildingId,go.itemId,go.numberText.text)
    Event.Brocast("SmallPop","下架成功",300)
    go.manager:_deleteGoods(go)
end
--删除事件
function ShelfGoodsItem:closeEvent()
    Event.RemoveListener("c_buyGoodsItemChoose",self.c_buyGoodsItemChoose,self);
    Event.RemoveListener("c_buyGoodsItemDelete",self.c_buyGoodsItemDelete,self);
end
function ShelfGoodsItem:OnClick_detailsBtn(ins)
    PlayMusEff(1002)
    UIPanel:ShowPage(DETAILSBoxCtrl,ins);
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
    self.price = data.price
    self.itemId = data.itemId
    --self.producerId = data.producerId
    --self.qty = data.qty
end