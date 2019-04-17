---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 15:54
---
local transform
MapPanel = {}
local this = MapPanel

MapPanel.MapShowInfoPoolName = "MapShowInfo"
MapPanel.MapShowInfoHasImgPoolName = "MapShowInfoHasImg"

--启动事件--
function MapPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

--初始化面板--
function MapPanel.InitPanel()
    --按钮和滑动条
    this.scaleSlider = transform:Find("rightRoot/ScaleSlider"):GetComponent("Slider")
    this.enlargeBtn = transform:Find("rightRoot/enlargeBtn")
    this.narrowBtn = transform:Find("rightRoot/narrowBtn")
    this.backBtn = transform:Find("rightRoot/backBtn")

    --预制
    this.mapMatGoodRootItem = transform:Find("prefabRoot/MapMatGoodRootItem").gameObject  --原料商品详情根节点
    this.mapMatGoodSearchItem = transform:Find("prefabRoot/MapMatGoodSearchItem").gameObject  --原料商品详情
    this.mapSearchTypeItem = transform:Find("prefabRoot/MapSearchTypeItem").gameObject  --搜索类型
    this.mapPromotionDetailItem = transform:Find("prefabRoot/MapPromotionDetailItem").gameObject  --推广item
    this.mapTechnologyDetailItem = transform:Find("prefabRoot/MapTechnologyDetailItem").gameObject  --科研
    --
    this.mapBuildingItem = transform:Find("centerRoot/prefabRoot/MapBuildingItem")  --建筑气泡
    this.mapSystemItem = transform:Find("centerRoot/prefabRoot/MapSystemItem")  --系统建筑
    this.mapSearchResultItem = transform:Find("centerRoot/prefabRoot/MapSearchResultItem")  --搜索结果
    this.mapAllSearchItem = transform:Find("centerRoot/prefabRoot/MapAllSearchItem")  --搜索总览
    this.mapGroundAucItem = transform:Find("centerRoot/prefabRoot/MapGroundAucItem")  --土地拍卖
    this.mapGroundTransItem = transform:Find("centerRoot/prefabRoot/MapGroundTransItem")  --土地交易

    --
    this.mapRootRect = transform:Find("centerRoot/typeParent"):GetComponent("RectTransform")  --小地图
    this.groundTransformRoot = transform:Find("centerRoot/typeParent/GroundTransformRoot")  --交易气泡
    this.groundAuctionRoot = transform:Find("centerRoot/typeParent/GroundAuctionRoot")  --拍卖气泡
    this.alwaysShowRoot = transform:Find("centerRoot/typeParent/AlwaysShowRoot")  --一直显示的界面，自己的建筑&系统建筑
    this.allSearchRoot = transform:Find("centerRoot/typeParent/AllSearchRoot")  --搜索总览
    this.detailSearchRoot = transform:Find("centerRoot/typeParent/DetailSearchRoot")  --搜索详情

    --左侧搜索类型
    this.openTypeBtnRect = transform:Find("leftRoot/openTypeBtn"):GetComponent("RectTransform")  --打开左侧搜索框的按钮
    this.closeSearchBtn = transform:Find("leftRoot/typeOpen/closeSearchBtn"):GetComponent("RectTransform")  --关闭搜索主界面按钮
    this.typeOpenRect = transform:Find("leftRoot/typeOpen"):GetComponent("RectTransform")  --搜索主界面
    this.loadingImg = transform:Find("leftRoot/typeOpen/loadingRoot/loadingImg"):GetComponent("RectTransform")  --loading图
    this.typeItemParent = transform:Find("leftRoot/typeOpen/typeItemParent")  --搜索类型父物体

    --详情页面
    this.detailPagesRect = transform:Find("leftRoot/detailPages"):GetComponent("RectTransform")  --
    this.matPageToggleGroup = transform:Find("leftRoot/detailPages/matPage"):GetComponent("ToggleGroup")  --原料页面
    this.goodsPageToggleGroup = transform:Find("leftRoot/detailPages/goodsPage"):GetComponent("ToggleGroup")  --商品页面
    this.promotionPageGroup = transform:Find("leftRoot/detailPages/promotionPage"):GetComponent("ToggleGroup")  --推广
    this.technologyPageGroup = transform:Find("leftRoot/detailPages/technologyPage"):GetComponent("ToggleGroup")  --科研

    --右侧详情界面
    --this.rightMatGoodPageItem = MapRightMatGoodPage:new(transform:Find("rightPageRoot/searchMatGood"))  --old
    this.rightOtherBuildingPageItem = MapRightOtherBuildingPage:new(transform:Find("rightPageRoot/selectOtherBuilding"))
    this.rightGroundAucPageItem = MapRightGroundAucPage:new(transform:Find("rightPageRoot/searchGroundAuc"))
    this.rightGroundTransPageItem = MapRightGroundTransPage:new(transform:Find("rightPageRoot/searchGroundTrans"))
    this.selfBuildingPageItem = MapRightSelfBuildingPage:new(transform:Find("rightPageRoot/selectSelfBuilding"))
    this.systemBuildingPageItem = MapRightSystemPage:new(transform:Find("rightPageRoot/selectSystemBuilding"))

    --
    this.mapShowInfoParentTran = transform:Find("rightPageRoot/itemsRoot")
    this.mapShowInfoItemTran = transform:Find("rightPageRoot/itemsRoot/noIconShowItem")  --不带icon的数据显示
    this.mapShowInfoIconItemTran = transform:Find("rightPageRoot/itemsRoot/hasIconShowItem")  --带有icon的数据显示
    this.prefabPools = {}
    this.prefabPools[this.MapShowInfoPoolName] = LuaGameObjectPool:new(this.MapShowInfoPoolName, this.mapShowInfoItemTran, 5, Vector3.New(-999,-999,-999), this.mapShowInfoParentTran)
    this.prefabPools[this.MapShowInfoHasImgPoolName] = LuaGameObjectPool:new(this.MapShowInfoHasImgPoolName, this.mapShowInfoIconItemTran, 1, Vector3.New(-999,-999,-999), this.mapShowInfoParentTran)
end
--根据类型显示二级菜单
function MapPanel.showDetailPageByType(typeId)
    MapPanel.matPageToggleGroup.transform.localScale = Vector3.zero
    MapPanel.goodsPageToggleGroup.transform.localScale = Vector3.zero
    MapPanel.promotionPageGroup.transform.localScale = Vector3.zero
    MapPanel.technologyPageGroup.transform.localScale = Vector3.zero

    if typeId == EMapSearchType.Material then
        MapPanel.matPageToggleGroup.transform.localScale = Vector3.one
    elseif typeId == EMapSearchType.Goods then
        MapPanel.goodsPageToggleGroup.transform.localScale = Vector3.one
    elseif typeId == EMapSearchType.Promotion then
        MapPanel.promotionPageGroup.transform.localScale = Vector3.one
    elseif typeId == EMapSearchType.Technology then
        MapPanel.technologyPageGroup.transform.localScale = Vector3.one
    end
end
--返回二级菜单trans
function MapPanel.getPageByType(typeId)
    local go
    if typeId == EMapSearchType.Material then
        go = MapPanel.matPageToggleGroup.gameObject
    elseif typeId == EMapSearchType.Goods then
        go = MapPanel.goodsPageToggleGroup.gameObject
    elseif typeId == EMapSearchType.Promotion then
        go = MapPanel.promotionPageGroup.gameObject
    elseif typeId == EMapSearchType.Technology then
        go = MapPanel.technologyPageGroup.gameObject
    end
    return go
end
--
function MapPanel.showRightPageByType(type, data)
    if type == EMapSearchType.Auction then
        this.rightOtherBuildingPageItem:close()
        this.rightGroundAucPageItem:refreshData(data)
        this.rightGroundTransPageItem:close()
        this.selfBuildingPageItem:close()

    elseif type == EMapSearchType.Deal then
        this.rightOtherBuildingPageItem:close()
        this.rightGroundAucPageItem:close()
        this.rightGroundTransPageItem:refreshData(data)
        this.selfBuildingPageItem:close()

    elseif type == EMapSearchType.Material or type == EMapSearchType.Goods then
        this.rightOtherBuildingPageItem:refreshData(data)
        this.rightGroundAucPageItem:close()
        this.rightGroundTransPageItem:close()
        this.selfBuildingPageItem:close()

    elseif type == EMapSearchType.SelfBuilding then
        this.rightOtherBuildingPageItem:close()
        this.rightGroundAucPageItem:close()
        this.rightGroundTransPageItem:close()
        this.selfBuildingPageItem:refreshData(data)
    end
end
--
function MapPanel.closeAllRightPage()
    this.rightMatGoodPageItem:close()
    this.rightGroundAucPageItem:close()
    this.rightGroundTransPageItem:close()
    this.selfBuildingPageItem:close()
    this.systemBuildingPageItem:close()
end