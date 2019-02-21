MapGameObjectsConfig = {
    ["PoolInstantiate"] = {
        {   --原料厂1
            ["Name"] = "MaterialBuilding_1",
            ["PlayerBuildingBaseDataID"] = 1100001,
            ["InitCount"] = 64,
        },
        {   --原料厂2
            ["Name"] = "MaterialBuilding_2",
            ["PlayerBuildingBaseDataID"] = 1100002,
            ["InitCount"] = 64,
        },
        {   --原料厂3
            ["Name"] = "MaterialBuilding_3",
            ["PlayerBuildingBaseDataID"] = 1100003,
            ["InitCount"] = 64,
        },
        {   --加工厂1
            ["Name"] = "Factory_1",
            ["PlayerBuildingBaseDataID"] = 1200001,
            ["InitCount"] = 64,
        },
        {   --加工厂2
            ["Name"] = "Factory_2",
            ["PlayerBuildingBaseDataID"] = 1200002,
            ["InitCount"] = 64,
        },
        {   --加工厂3
            ["Name"] = "Factory_3",
            ["PlayerBuildingBaseDataID"] = 1200003,
            ["InitCount"] = 64,
        },
        {   --零售店1
            ["Name"] = "SuperMarket_1",
            ["PlayerBuildingBaseDataID"] = 1300001,
            ["InitCount"] = 64,
        },
        {   --零售店2
            ["Name"] = "SuperMarket_2",
            ["PlayerBuildingBaseDataID"] = 1300002,
            ["InitCount"] = 64,
        },
        {   --零售店3
            ["Name"] = "SuperMarket_3",
            ["PlayerBuildingBaseDataID"] = 1300003,
            ["InitCount"] = 64,
        },
        {   --住宅1
            ["Name"] = "HomeHouse_1",
            ["PlayerBuildingBaseDataID"] = 1400001,
            ["InitCount"] = 64,
        },
        {   --住宅2
            ["Name"] = "HomeHouse_2",
            ["PlayerBuildingBaseDataID"] = 1400002,
            ["InitCount"] = 64,
        },
        {   --住宅3
            ["Name"] = "HomeHouse_3",
            ["PlayerBuildingBaseDataID"] = 1400003,
            ["InitCount"] = 64,
        },
        {   --我的地块
            ["Name"] = "my_Ground",
            ["PlayerBuildingBaseDataID"] = 4000001,
            ["InitCount"] = 0,
        },
        --TODO:道路/系统道路/河流/湖泊/装饰物
    },
    ["OnlyOne"] = {
        ["Centralbuilding"] = 2000000,      --中心建筑
    },
    ["HidePosition"] = Vector3.New(-999,-999,-999),   --隐藏物体坐标
}
