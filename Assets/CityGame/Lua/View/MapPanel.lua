---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 15:54
---
local transform
MapPanel = {}
local this = MapPanel

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
    --
    this.mapBuildingItem = transform:Find("centerRoot/prefabRoot/MapBuildingItem")  --建筑气泡
    this.mapSystemItem = transform:Find("centerRoot/prefabRoot/MapSystemItem")  --系统建筑
    this.mapSearchResultItem = transform:Find("centerRoot/prefabRoot/MapSearchResultItem")  --搜索结果
    this.mapAllSearchItem = transform:Find("centerRoot/prefabRoot/MapAllSearchItem")  --搜索总览

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

    --右侧详情界面
    this.searchMatGoodRect = transform:Find("rightPageRoot/searchMatGood"):GetComponent("RectTransform")
    this.rightMatGoodPageItem = MapRightMatGoodPage:new(this.searchMatGoodRect.transform)

end

function MapPanel.showDetailPageByType(typeId)
    if typeId == EMapSearchType.Material then
        MapPanel.matPageToggleGroup.transform.localScale = Vector3.one
        MapPanel.goodsPageToggleGroup.transform.localScale = Vector3.zero
    elseif typeId == EMapSearchType.Goods then
        MapPanel.matPageToggleGroup.transform.localScale = Vector3.zero
        MapPanel.goodsPageToggleGroup.transform.localScale = Vector3.one
    end
end