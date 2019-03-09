ShelfGoodsItem = class('ShelfGoodsItem')

--初始化方法   数据（接受服务器）
function ShelfGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour,id,info)
    self.id = id
    self.state = info[1]
    self.prefab = prefab
    self.buildingId = info[2]
    self.goodsDataInfo = goodsDataInfo
    self._luabehaviour = inluabehaviour
    self.num = goodsDataInfo.n
    self.itemId = goodsDataInfo.k.id
    self.price = goodsDataInfo.price
    self.bgBtn = self.prefab.transform:Find("bgBtn")  --物品btn，点击勾选物品，默认为false
    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject  --架子
    self.goodsicon = self.prefab.transform:Find("details/goodsicon"):GetComponent("Image")  --物品Icon
    self.circleGreayImg = self.prefab.transform:Find("circleGreayImg"):GetComponent("RectTransform")  --圆
    self.circleTickImg = self.prefab.transform:Find("circleTickImg"):GetComponent("RectTransform")  --勾选
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text")  --物品名字
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text")  --物品数量
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text")  --物品价格
    self.XBtn = self.prefab.transform:Find("XBtn"):GetComponent("RectTransform")  --删除按钮
    self.detailsBtn = self.prefab.transform:Find("detailsBtn")  --点击商品查看详情
    self.materialbg = self.prefab.transform:Find("materialbg")  --原料bg
    self.goodsbg = self.prefab.transform:Find("goodsbg")  --商品bg

    local materialKey,goodsKey = 21,22
    local type = ct.getType(UnityEngine.Sprite)
    if math.floor(self.itemId / 100000) == materialKey then
        --self.nameText.text = Material[self.itemId].name;
        self.materialbg.transform.localScale = Vector3.one
        self.goodsbg.transform.localScale = Vector3.zero
        self.nameText.text = GetLanguage(self.itemId);
        panelMgr:LoadPrefab_A(Material[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsicon.sprite = texture
            end
        end)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        self.materialbg.transform.localScale = Vector3.zero
        self.goodsbg.transform.localScale = Vector3.one
        self.nameText.text = GetLanguage(self.itemId);
        panelMgr:LoadPrefab_A(Good[self.itemId].img,type,nil,function(goodData,obj)
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                self.goodsicon.sprite = texture
            end
        end)
    end
    --赋值
    self.numberText.text = self.num
    self.moneyText.text = GetClientPriceString(self.price)
    --点击事件
    self._luabehaviour:AddClick(self.bgBtn.gameObject,self.OnClick_bgBtn,self);
    self._luabehaviour:AddClick(self.XBtn.gameObject, self.OnClicl_XBtn, self);
    self._luabehaviour:AddClick(self.detailsBtn.gameObject,self.OnClick_detailsBtn,self);

    self:InitializeUi()
end
--初始化ItemUI状态
function ShelfGoodsItem:InitializeUi()
    if self.state then
        self.XBtn.transform.localScale = Vector3.zero
        self.circleGreayImg.transform.localScale = Vector3.zero
        self.circleTickImg.transform.localScale = Vector3.zero
        self.detailsBtn.transform.localScale = Vector3.one
        self.bgBtn.transform.localScale = Vector3.zero
    else
        self.XBtn.transform.localScale = Vector3.one
        self.circleGreayImg.transform.localScale = Vector3.zero
        self.circleTickImg.transform.localScale = Vector3.zero
        self.detailsBtn.transform.localScale = Vector3.one
        self.bgBtn.transform.localScale = Vector3.zero
    end
end
--Item状态 选择
function ShelfGoodsItem:c_GoodsItemChoose()
    self.XBtn.transform.localScale = Vector3.zero
    self.circleGreayImg.localScale = Vector3.one
    self.circleTickImg.localScale = Vector3.zero
    self.detailsBtn.transform.localScale = Vector3.zero
    self.bgBtn.transform.localScale = Vector3.one
end
--Item状态 选中
function ShelfGoodsItem:c_GoodsItemSelected()
    self.XBtn.transform.localScale = Vector3.zero
    self.circleGreayImg.localScale = Vector3.zero
    self.circleTickImg.localScale = Vector3.one
    self.detailsBtn.transform.localScale = Vector3.zero
    self.bgBtn.transform.localScale = Vector3.one
end
--勾选物品
function ShelfGoodsItem:OnClick_bgBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("SelectedGoodsItem",ins);
end
--点击删除
function ShelfGoodsItem:OnClicl_XBtn(go)
    PlayMusEff(1002)
    if math.floor(go.itemId / 100000) == 21 then
        Event.Brocast("m_ReqMaterialShelfDel",go.buildingId,go.itemId,go.numberText.text,go.producerId,go.qty)
    elseif math.floor(go.itemId / 100000) == 22 then
        Event.Brocast("m_ReqProcessShelfDel",go.buildingId,go.itemId,go.numberText.text,go.goodsDataInfo.k.producerId,go.goodsDataInfo.k.qty)
    end
    --Event.Brocast("SmallPop",GetLanguage(27010003),300)
end
function ShelfGoodsItem:OnClick_detailsBtn(ins)
    PlayMusEff(1002)
    ct.OpenCtrl("DETAILSBoxCtrl",ins);
end
--删除后刷新ID及刷新架子显示
function ShelfGoodsItem:RefreshID(id)
    self.id = id
    --if id % 5 == 0 then
    --    self.shelfImg:SetActive(true);
    --else
    --    self.shelfImg:SetActive(false);
    --end
end
--function ShelfGoodsItem:RefreshData(data,id)
--    self.id = id
--    self.num = data.num
--    self.name = data.name
--    self.price = data.price
--    self.itemId = data.itemId
--    --self.producerId = data.producerId
--    --self.qty = data.qty
--end