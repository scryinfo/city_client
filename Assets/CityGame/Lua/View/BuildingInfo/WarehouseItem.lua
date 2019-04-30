---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/15 17:24
---
WarehouseItem = class('WarehouseItem')
local ToNumber = tonumber
local StringSun = string.sub
function WarehouseItem:initialize(dataInfo,prefab,luaBehaviour,keyId,buildingType,stateType)
    self.keyId = keyId
    self.prefab = prefab
    self.dataInfo = ct.deepCopy(dataInfo)
    self.stateType = stateType[1]
    self.buildingId = stateType[2]
    self.buildingType = buildingType
    self.itemId = dataInfo.key.id

    self.iconImg = prefab.transform:Find("iconImg"):GetComponent("Image")
    self.numberText = prefab.transform:Find("numberBg/numberText"):GetComponent("Text")
    self.nameBg = prefab.transform:Find("nameBg")
    self.nameText = prefab.transform:Find("nameBg/nameText"):GetComponent("Text")

    --需要隐藏的商品信息
    self.goods = prefab.transform:Find("goods")
    self.levelImg = prefab.transform:Find("goods/levelImg"):GetComponent("Image")
    self.brandNameText = prefab.transform:Find("goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = prefab.transform:Find("goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = prefab.transform:Find("goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")
    self.detailsBtn = prefab.transform:Find("detailsBtn")

    luaBehaviour:AddClick(self.detailsBtn.gameObject,self._clickDetailsBtn,self)
    self:InitializeData()
end

function WarehouseItem:InitializeData()
    self.nameText.text = GetLanguage(self.itemId)
    self.numberText.text = "×"..self.dataInfo.n
    local materialKey,goodsKey = 21,22
    if ToNumber(StringSun(self.itemId,1,2)) == materialKey then
        self.goods.transform.localScale = Vector3.zero
        self.nameBg.transform.localPosition = Vector3(-140,-100,0)
        LoadSprite(Material[self.itemId].img,self.iconImg,false)
    elseif ToNumber(StringSun(self.itemId,1,2)) == goodsKey then
        self.goods.transform.localScale = Vector3.one
        LoadSprite(Good[self.itemId].img,self.iconImg,false)
        --self.levelImg
        --self.brandNameText
        --self.brandValue
        --self.qualityValue
    end
end
--打开详情
function WarehouseItem:_clickDetailsBtn(ins)
    PlayMusEff(1002)
    if ins.stateType == GoodsItemStateType.addShelf then
        --上架
        ct.OpenCtrl("ShelfBoxCtrl",ins)
    elseif ins.stateType == GoodsItemStateType.transport then
        --运输
        ct.OpenCtrl("WarehouseBoxCtrl",ins)
    end
end
--刷新数量
function WarehouseItem:updateNumber(data)
    self.dataInfo.n = data.n
    self.numberText.text = "×"..self.dataInfo.n
end
--删除后刷新ID
function WarehouseItem:RefreshID(id)
    self.keyId = id;
end


--WarehouseItem = class('WarehouseItem')
--
--local Math_Floor = math.floor
----初始化方法   数据（接受服务器）
--function WarehouseItem:initialize(goodsDataInfo,prefab,inluabehaviour,id)
--    self.prefab = prefab;
--    self.goodsDataInfo = goodsDataInfo;
--    self._luabehaviour = inluabehaviour;
--    self.id = id;
--    self.itemId = goodsDataInfo.key.id;
--    self.n = goodsDataInfo.n
--    self.producerId = goodsDataInfo.key.producerId
--    self.qty = goodsDataInfo.key.qty
--    --商品
--    self.brandBg = self.prefab.transform:Find("brandBg");
--    self.brandName = self.prefab.transform:Find("brandBg/brandName"):GetComponent("Text");
--
--    ----------------------------------------------------暂时隐藏
--    self.brand = self.prefab.transform:Find("brandBg/brand")
--    self.quality = self.prefab.transform:Find("brandBg/quality")
--    ----------------------------------------------------暂时隐藏
--
--    self.brandScore = self.prefab.transform:Find("brandBg/brand/brandScore"):GetComponent("Text");
--    self.qualityScore = self.prefab.transform:Find("brandBg/quality/qualityScore"):GetComponent("Text");
--    --原料
--    self.bgBtn = self.prefab.transform:Find("bgBtn"):GetComponent("Image");  --物品btn，点击勾选物品，默认为false
--    self.icon = self.prefab.transform:Find("icon"):GetComponent("Image");  --物品Icon
--    self.circleGreayImg = self.prefab.transform:Find("circleGreayImg"):GetComponent("RectTransform");  --圆
--    self.circleTickImg = self.prefab.transform:Find("circleTickImg"):GetComponent("RectTransform");  --勾选
--    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");  --名字
--    self.numberText = self.prefab.transform:Find("numberText"):GetComponent("Text");  --数量
--    self.closeBtn = self.prefab.transform:Find("closeBtn"):GetComponent("RectTransform");  --删除btn  默认true
--
--
--    ----------------------------------------------------暂时隐藏
--    self.brand.transform.localScale = Vector3.zero
--    self.quality.transform.localScale = Vector3.zero
--    ----------------------------------------------------暂时隐藏
--    self.numberText.text = self.n
--    local materialKey,goodsKey = 21,22
--    self.nameText.text = GetLanguage(self.itemId);
--    if Math_Floor(self.itemId / 100000) == materialKey then
--        self:materialRoot()
--        LoadSprite(Material[self.itemId].img,self.icon,false)
--    elseif Math_Floor(self.itemId / 100000) == goodsKey then
--        self:goodsRoot()
--        self.qualityScore.text = self.goodsDataInfo.key.qty
--        LoadSprite(Good[self.itemId].img,self.icon,false)
--    end
--
--    --初始化ItemUI状态
--    self:InitializeUi()
--    --点击事件
--    self._luabehaviour:AddClick(self.closeBtn.gameObject, self.OnClick_closeBtn,self);
--    self._luabehaviour:AddClick(self.bgBtn.gameObject,self.OnClick_bgBtn,self);
--end
----初始化ItemUI状态
--function WarehouseItem:InitializeUi()
--    self.closeBtn.transform.localScale = Vector3.one
--    self.circleGreayImg.transform.localScale = Vector3.zero
--    self.circleTickImg.transform.localScale = Vector3.zero
--    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = false
--end
----Item状态 选择
--function WarehouseItem:c_GoodsItemChoose()
--    self.closeBtn.transform.localScale = Vector3.zero
--    self.circleGreayImg.transform.localScale = Vector3.one
--    self.circleTickImg.transform.localScale = Vector3.zero
--    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = true
--end
----Item状态 选中
--function WarehouseItem:c_GoodsItemSelected()
--    self.closeBtn.transform.localScale = Vector3.zero
--    self.circleGreayImg.transform.localScale = Vector3.zero
--    self.circleTickImg.transform.localScale = Vector3.one
--    self.bgBtn.gameObject:GetComponent("Image").raycastTarget = true
--end
--
----勾选物品
--function WarehouseItem:OnClick_bgBtn(ins)
--    PlayMusEff(1002)
--    Event.Brocast("SelectedGoodsItem", ins)
--end
----删除
--function WarehouseItem:OnClick_closeBtn(go)
--    PlayMusEff(1002)
--    Event.Brocast("DestroyWarehouseItem",go)
--end
----删除后刷新ID及显示
--function WarehouseItem:RefreshID(id)
--    self.id = id;
--end
----原料
--function WarehouseItem:materialRoot()
--    self.brandBg.localScale = Vector3.zero
--    self.icon:GetComponent("RectTransform").localPosition = Vector3.New(0,40, 0)
--    LoadSprite("Assets/CityGame/Resources/Atlas/Warehouse/bg-goods-white-s .png",self.bgBtn,false)
--
--end
----商品
--function WarehouseItem:goodsRoot()
--    self.brandBg.localScale = Vector3.one
--    self.icon:GetComponent("RectTransform").localPosition = Vector3.New(0,0, 0)
--    LoadSprite("Assets/CityGame/Resources/Atlas/Warehouse/bg-goods 1.png",self.bgBtn,false)
--end
--function WarehouseItem:RefreshData(data,id)
--    self.id = id
--    self.n = data.num
--    self.name = data.name
--    self.itemId = data.itemId
--    --self.producerId = data.producerId
--    --self.qty = data.qty
--end