TerrainConfig = {
    ["TerrainAttribute"]= {
        ["FOWCenterPos"] =  Vector3.New(500,0,500), --战争迷雾中心位置点
        ["FOWRange"] = 500,                     --战争迷雾范围
        ["CameraRootXMin"] = 0,                 --相机位置X轴的最小值
        ["CameraRootXMax"] = 1000,              --相机位置X轴的最大值
        ["CameraRootZMin"] = 0,                 --相机位置Z轴的最小值
        ["CameraRootZMax"] = 1000,              --相机位置Z轴的最大值
        ["CameraIntoDurationtime"] = 0.4,       --打开建筑时镜头拉近耗时
        ["CameraOutDurationtime"] = 0.6,        --打开建筑时镜头拉远耗时
        ["CameraScaleValueMin"] = 5,            --相机缩放y轴高度最近距离
        ["CameraScaleValueMax"] = 10,           --相机缩放y轴高度最远距离
    },
    ["CentralBuilding"] ={
        ["CenterNodePos"] = Vector3.New(49,0,49),
        ["BuildingType"]  = 2000000,
    },
}