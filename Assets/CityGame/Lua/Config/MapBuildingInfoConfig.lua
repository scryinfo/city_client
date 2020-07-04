--The information configuration displayed on the right after clicking the building on the small map
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
    --Click on the information displayed by others' buildings
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
    --Land transaction
    ["GroundRentTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 20150002,
    },
    ["GroundRental"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = 20150003,
    },
    --Land auction
    ["GAucPrice"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-eee-s.png",
        ["languageId"] = 20160007,
    },
    ["GAucTime"] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-time.png",
        ["languageId"] = 20160010,
    },
    --building
    ["Shelf"] = --Shelf
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/button-shelf.png",
        ["languageId"] = 20170001,
    },
    ["Capacity"] = --Check in
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Occupancyrate.png",
        ["languageId"] = 20090002,
    },
    ["DayRent"] = --Daily rent
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Dailyrent.png",
        ["languageId"] = 20090003,
    },
    ["CompetitivePower"] = --Competitiveness
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/button-competitive-s.png",
        ["languageId"] = 43010001,
    },
    ["DataSale"] = --Promotion company
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Datasale-s.png",
        ["languageId"] = 20170002,
    },
    ["ResearchSale"] = --graduate School
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-shelf-s.png",
        ["languageId"] = 20170003,
    },
    --Number of research by advertising companies
    ["PromoteQuantity"] =
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-Datasale-s.png",
        ["languageId"] = 20180004,
    },
    --研究所公司的研究数量
    ["TechnologyQuantity"] =
    {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/icon-shelf-s.png",
        ["languageId"] = 20190007,
    },
}
------------------------------------------------------
--The information displayed after the mini-map promotion and search
--These two tables need to correspond one to one
MapPromotionInfoConfig={
    [1] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Supermarket.png",
        ["languageId"] = 20180001,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1600013,
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Homehouse.png",
        ["languageId"] = 20180002,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1600014,
    },
    [3] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Factory.png",
        ["languageId"] = 20180003,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1600012,
    },
}
--Building secondary menuItems
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

--Promotion corresponding ID in evaConfig
MapPromotionConfig={
    [1] = 1651,
    [2] = 1652,
    [3] = 1613,
    [4] = 1614,
}
------------------------------------------------------
--Small map to open the information displayed by scientific research
MapTechnologyInfoConfig={
    [1] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/MaterialFactory.png",
        ["languageId"] = 20190001,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1500011,
    },
    [2] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Factory.png",
        ["languageId"] = 20190002,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1500012,
    },
    [3] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Supermarket.png",
        ["languageId"] = 20190003,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1500013,
    },
    [4] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Homehouse.png",
        ["languageId"] = 20190004,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1500014,
    },
    [5] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Advertising.png",
        ["languageId"] = 20190005,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1500016,
    },
    [6] = {
        ["imgPath"] = "Assets/CityGame/Resources/Atlas/Map/MapSmallIcon/Technology.png",
        ["languageId"] = 20190006,
        ["colorV3"] = Vector3.New(255, 255, 255),
        ["leftColorV3"] = Vector3.New(255, 255, 255),
        ["type"] = 1500015,
    },
}