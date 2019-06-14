--小地图点击建筑之后右侧展示的信息配置
MapBuildingInfoConfig={
    ["Revenue"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-turnover.png",
        ["languageId"] = "Revenue",
    },
    ["Salary"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Feestandard.png",
        ["languageId"] = "Fee standard",
    },
    ["Warehouse"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-warehouse-s.png",
        ["languageId"] = "Warehouse",
    },
    ["OrderCenter"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Ordercenter.png",
        ["languageId"] = "OrderCenter",
    },
    ["Production"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/iocn-productionline-s.png",
        ["languageId"] = "Production",
    },
    ["Sign"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-signing.png",
        ["languageId"] = "Sign",
    },
    ["HouseOccupancy"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Occupancyrate.png",
        ["languageId"] = "HouseOccupancy",
    },
    ["HouseRent"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Dailyrent.png",
        ["languageId"] = "HouseRent",
    },
    ["WarehouseRent"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-rent.png",
        ["languageId"] = "Warehouse",
    },
    ["ADSign"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-signing.png",
        ["languageId"] = "ADSign",
    },
    ["Queued"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-queue.png",
        ["languageId"] = "Queued",
    },
    --点击其他人建筑显示的信息
    ["Price"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = "Price:",
    },
    ["PromotionTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = "PromotionTime:",
    },
    ["ResearchTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = "ResearchTime:",
    },
    ["WarehouseTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = "RentTime:",
    },
    ["SignTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = "SignTime:",
    },
    ["SignPromotion"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Currentpromotion.png",
        ["languageId"] = "Current promotion:",
    },
    --土地交易
    ["GroundRentTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = "Tenancy:",
    },
    ["GroundRental"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = "Rental:",
    },
    --土地拍卖
    ["GAucPrice"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = "Floor price:",
    },
    ["GAucTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = "Auction time:",
    },
}
------------------------------------------------------
--小地图点开推广搜索之后展示的信息
MapPromotionInfoConfig={
    [1] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-food-w.png",
        ["languageId"] = "Food",
        ["colorV3"] = Vector3.New(75, 101, 161),  --右侧显示详情的颜色
        ["leftColorV3"] = Vector3.New(49, 49, 49),  --左侧搜索部分的颜色
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-clothes-w.png",
        ["languageId"] = "Clothes",
        ["colorV3"] = Vector3.New(65, 168, 138),
        ["leftColorV3"] = Vector3.New(49, 49, 49),
    },
    [3] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/SuperMarket_3x3.png",
        ["languageId"] = "SuperMarket",
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
    },
    [4] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/HomeHouse_3X3.png",
        ["languageId"] = "House",
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
    },
}
--在evaConfig中的推广对应ID
MapPromotionConfig={
    [1] = 1651,
    [2] = 1652,
    [3] = 1613,
    [4] = 1614,
}
------------------------------------------------------
--小地图点开科研展示的信息
MapTechnologyInfoConfig={
    [1] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-newcommodity.png",
        ["languageId"] = "发明新产品",
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eva.png",
        ["languageId"] = "Eva能力",
    },
}