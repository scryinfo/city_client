--小地图点击建筑之后右侧展示的信息配置
MapBuildingInfoConfig={
    ["Revenue"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-turnover.png",
        ["languageId"] = 20060001,
    },
    ["Salary"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Feestandard.png",
        ["languageId"] = 12345678,
    },
    ["Warehouse"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-warehouse-s.png",
        ["languageId"] = 20060002,
    },
    ["OrderCenter"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Ordercenter.png",
        ["languageId"] = 20060003,
    },
    ["Production"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/iocn-productionline-s.png",
        ["languageId"] = 20060004,
    },
    ["Sign"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-signing.png",
        ["languageId"] = 12345678,
    },
    ["HouseOccupancy"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Occupancyrate.png",
        ["languageId"] = 20090002,
    },
    ["HouseRent"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Dailyrent.png",
        ["languageId"] = 20090003,
    },
    ["WarehouseRent"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-rent.png",
        ["languageId"] = 12345678,
    },
    ["ADSign"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-signing.png",
        ["languageId"] = 12345678,
    },
    ["Queued"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-queue.png",
        ["languageId"] = 20100002,
    },
    --点击其他人建筑显示的信息
    ["Price"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = 20130001,
    },
    ["PromotionTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 20130002,
    },
    ["ResearchTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 20140004,
    },
    ["WarehouseTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 12345678,
    },
    ["SignTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 12345678,
    },
    ["SignPromotion"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Currentpromotion.png",
        ["languageId"] = 12345678,
    },
    --土地交易
    ["GroundRentTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 20150002,
    },
    ["GroundRental"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = 20150003,
    },
    --土地拍卖
    ["GAucPrice"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = 20160007,
    },
    ["GAucTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 20160010,
    },
    --建筑
    ["Shelf"] = --货架
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/button-shelf.png",
        ["languageId"] = 20170001,
    },
    ["Capacity"] = --入住情况
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Occupancyrate.png",
        ["languageId"] = 20090002,
    },
    ["DayRent"] = --日租金
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Dailyrent.png",
        ["languageId"] = 20090003,
    },
    ["CompetitivePower"] = --竞争力
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/button-competitive-s.png",
        ["languageId"] = 43010001,
    },
    ["DataSale"] = --推广公司
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Datasale-s.png",
        ["languageId"] = 20170002,
    },
    ["ResearchSale"] = --研究所
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-shelf-s.png",
        ["languageId"] = 20170003,
    },
}
------------------------------------------------------
--小地图点开推广搜索之后展示的信息
--这两个表需要一一对应
MapPromotionInfoConfig={
    [1] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-food-w.png",
        ["languageId"] = 20050001,
        ["colorV3"] = Vector3.New(75, 101, 161),  --右侧显示详情的颜色
        ["leftColorV3"] = Vector3.New(49, 49, 49),  --左侧搜索部分的颜色
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-clothes-w.png",
        ["languageId"] = 20050002,
        ["colorV3"] = Vector3.New(65, 168, 138),
        ["leftColorV3"] = Vector3.New(49, 49, 49),
    },
    [3] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/SuperMarket_3x3.png",
        ["languageId"] = 20050003,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
    },
    [4] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/HomeHouse_3X3.png",
        ["languageId"] = 20050004,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
    },
}
--建筑二级菜单Items
MapBuildInfoConfig={
    [1] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/MaterialFactory.png",
        ["languageId"] = 23010001,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 11,
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Factory.png",
        ["languageId"] = 23010002,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 12,
    },
    [3] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Supermarket.png",
        ["languageId"] = 23010003,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 13,
    },
    [4] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Homehouse.png",
        ["languageId"] = 23010004,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 14,
    },
    [5] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Advertising.png",
        ["languageId"] = 23010005,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 15,
    },
    [6] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Technology.png",
        ["languageId"] = 23010006,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 16,
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
        ["languageId"] = 20040001,
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eva.png",
        ["languageId"] = 20040002,
    },
}