TerrainConfig = {
    ["TerrainAttribute"]= {
        ["FOWCenterPos"] =  Vector3.New(50.5,0,50.5), --The center of the fog of war
        ["FOWRange"] = 50.5,                     --War Fog Range
        ["CameraRootXMin"] = 0,                 --The minimum value of the X position of the camera position
        ["CameraRootXMax"] = 101,              --The maximum value of the X position of the camera position
        ["CameraRootZMin"] = 0,                 --The minimum value of the Z position of the camera position
        ["CameraRootZMax"] = 101,              --The maximum value of the Z position of the camera position
        ["CameraIntoDurationtime"] = 0.4,       --It takes time to zoom in when opening the building
        ["CameraOutDurationtime"] = 0.6,        --It takes time to zoom out when opening the building
        ["CameraScaleValueMin"] = 15,            --Camera zoom y-axis height closest distance
        ["CameraScaleValueMax"] = 15,           --The camera zooms the y-axis height the longest distance
    },
    ["CentralBuilding"] ={
        ["CenterNodePos"] = Vector3.New(44 ,0,46),
        ["BuildingType"]  = 2000000,
    },
    ["MiniMap"] = {
        ["ScaleMin"] = 1,
        ["ScaleMax"] = 4.2,
        ["ScaleOffset"] = 0.8,
        ["DetailScale"] = 2.6,  --Show details
        ["ScaleStart"] = 1,
        ["ScaleDuringTime"] = 0.1,
        ["MapLeftPageDuringTime"] = 0.1,
        ["MapSize"] = 100,
    },
    ["LoadingConfig"] = {
        ["MinDurationTime"] = 3,
        ["RotateSpeed"] = 200,
        ["RotateDirection"] = Vector3.back,
    }
}