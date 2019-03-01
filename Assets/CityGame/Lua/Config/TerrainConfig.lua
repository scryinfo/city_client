TerrainConfig = {
    ["TerrainAttribute"]= {
        ["FOWCenterPos"] =  Vector3.New(50.5,0,50.5), --战争迷雾中心位置点
        ["FOWRange"] = 50.5,                     --战争迷雾范围
        ["CameraRootXMin"] = 0,                 --相机位置X轴的最小值
        ["CameraRootXMax"] = 101,              --相机位置X轴的最大值
        ["CameraRootZMin"] = 0,                 --相机位置Z轴的最小值
        ["CameraRootZMax"] = 101,              --相机位置Z轴的最大值
        ["CameraIntoDurationtime"] = 0.4,       --打开建筑时镜头拉近耗时
        ["CameraOutDurationtime"] = 0.6,        --打开建筑时镜头拉远耗时
        ["CameraScaleValueMin"] = 5,            --相机缩放y轴高度最近距离
        ["CameraScaleValueMax"] = 15,           --相机缩放y轴高度最远距离
    },
    ["CentralBuilding"] ={
        ["CenterNodePos"] = Vector3.New(49 ,0,49),
        ["BuildingType"]  = 2000000,
    },
    ["MiniMap"] = {
        ["ScaleMin"] = 1,
        ["ScaleMax"] = 4,
        ["ScaleOffset"] = 1,
        ["ScaleStart"] = 1,
        ["ScaleDuringTime"] = 0.1,
        ["MapSize"] = 101,
    },
    ["LoadingConfig"] = {
        ["MinDurationTime"] = 3,
        ["RotateSpeed"] = 200,
        ["RotateDirection"] = Vector3.back,
    }

}