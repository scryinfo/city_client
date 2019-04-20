--Allen
--地图管理器
--1.
--      1、商业建筑实例类堆栈 ArchitectureStack[]
--      2、
UnitTest = require ('test/testFrameWork/UnitTest')
TerrainManager = {}

local Math_Floor = math.floor
local Math_Ceil =  math.ceil
local Math_Abs =  math.abs

local ArchitectureStack = {}
--以下数据应与服务器同步
local TerrainRange = Vector2.New(1000 , 1000)    --地图大小范围
local blockRange = Vector2.New(20, 20)
--以下数据应当初始化
local CameraCollectionID = -1

function TerrainManager.Init()
    Event.AddListener("CameraMoveTo",TerrainManager.Refresh)
end

function TerrainManager.ReMove()
    Event.RemoveListener("CameraMoveTo",TerrainManager.Refresh)
end

local systemMapTemp_CreateSystemBuildingGameObjects
local go_CreateSystemBuildingGameObjects
local BuildPosition_CreateSystemBuildingGameObjects
--创建系统建筑的GameObject
function TerrainManager.CreateSystemBuildingGameObjects(CollectionID)
    systemMapTemp_CreateSystemBuildingGameObjects = SystemMapConfig[CollectionID]
    if systemMapTemp_CreateSystemBuildingGameObjects ~= nil then
        for blockId, PlayerDataID in pairs(systemMapTemp_CreateSystemBuildingGameObjects) do
            go_CreateSystemBuildingGameObjects = MapObjectsManager.GetGameObjectByPool(PlayerBuildingBaseData[PlayerDataID].poolName)
            BuildPosition_CreateSystemBuildingGameObjects = TerrainManager.BlockIDTurnPosition(blockId)
            BuildPosition_CreateSystemBuildingGameObjects.y =  BuildPosition_CreateSystemBuildingGameObjects.y + 0.02
            go_CreateSystemBuildingGameObjects.transform.position = BuildPosition_CreateSystemBuildingGameObjects
            DataManager.AddSystemBuild(CollectionID,blockId,PlayerBuildingBaseData[PlayerDataID].poolName,go_CreateSystemBuildingGameObjects)
        end
    end
end

local go_BuildCreateSuccess
local tempBaseBuildModel_BuildCreateSuccess
local function BuildCreateSuccess( value , buildingID , BuildPosition)
    go_BuildCreateSuccess  = MapObjectsManager.GetGameObjectByPool(PlayerBuildingBaseData[value.buildingID].poolName)
    --add height
    BuildPosition.y =  BuildPosition.y + 0.02
    go_BuildCreateSuccess.transform.position = BuildPosition
    --意义不大 额外开销
    --[[
    if TerrainManager.TerrainRoot == nil  then
        TerrainManager.TerrainRoot = UnityEngine.GameObject.Find("Terrain").transform
    end
    go_BuildCreateSuccess.transform:SetParent(TerrainManager.TerrainRoot)
    --]]
    --[[无用
    if PlayerBuildingBaseData[buildingID]["LuaRoute"] ~= nil then
        ArchitectureStack[buildingID] = CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingID]["LuaRoute"])
    end
    --]]
    --将建筑GameObject保存到对应Model中
    tempBaseBuildModel_BuildCreateSuccess = DataManager.GetBaseBuildDataByID(TerrainManager.PositionTurnBlockID(BuildPosition))
    if TerrainManager.BuildObjQueue ~= nil then
        TerrainManager.BuildObjQueue = TerrainManager.BuildObjQueue - 1
    end
    if tempBaseBuildModel_BuildCreateSuccess ~= nil and tempBaseBuildModel_BuildCreateSuccess.go == nil then
        tempBaseBuildModel_BuildCreateSuccess.go = go_BuildCreateSuccess
        return
    end
    MapObjectsManager.RecyclingGameObjectToPool(PlayerBuildingBaseData[value.buildingID].poolName,go)
end


local AOIList_ReceiveArchitectureDatas
--根据建筑数据生成GameObject
--参数：
--  datas：数据table集合( 一定包含数据有：坐标==》  x,y  ,建筑类型id==》 buildId)
function  TerrainManager.ReceiveArchitectureDatas(datas)
    if not datas then
        return
    end
    for key, value in pairs(datas) do
        --判断是否需要创建建筑
        if DataManager.RefreshBaseBuildData(value) then
            BuildCreateSuccess(value,value.buildingID, Vector3.New(value.x,0,value.y))
        end
    end
    --刷新AOI内的数据
    if CameraCollectionID ~= nil and CameraCollectionID ~= -1 then
        AOIList_ReceiveArchitectureDatas = TerrainManager.GetCameraCollectionIDAOIList()
        for key, value in pairs(AOIList_ReceiveArchitectureDatas) do
            DataManager.RefreshWaysByCollectionID(value)
        end
        PathFindManager.CreateAOIListPalyer(AOIList_ReceiveArchitectureDatas)
    end
end

--计算B在A中的补集（即A中有，而B中没有的）
--A:Table(value为集合)
--B:Table(value为集合)
--return  Cab
local function ComputingTheComplementSetOfBinA(ListA,ListB)
    local ComplementSetList = ct.deepCopy(ListA)
    for keyA, valueA in pairs(ComplementSetList) do
        for keyB, valueB in pairs(ListB) do
            if valueA == valueB then
                ComplementSetList[keyA] = nil
                break
            end
        end
    end
    return ComplementSetList
end


--计算计算A集合中在B集合附近的所有值（包括B）
--暂时废弃
function TerrainManager.CalculateAllValuesInANearB(ListA,ListB)
    local nearList = {}
    local tempBlist
    for keyB, valueB in pairs(ListB) do
        tempBlist = CalculationAOICollectionIDList(valueB)
        for keyTemp, valueTemp in pairs(tempBlist) do
            if #ListA == 0 then
                return nearList
            end
            for keyA, valueA in pairs(ListA) do
                if valueTemp == valueA then
                    table.insert(nearList,valueTemp)
                    table.remove(ListA,keyA)
                    break
                end
            end
        end
    end
    return nearList
end

local rowNum = nil
local columnNum = nil
local remain_CalculationAOICollectionIDList
local IsNearTopEdge
local IsNearBottomEdge
local IsNearLeftEdge
local IsNearRightEdge
--计算AOI范围内的地块ID
local function CalculationAOICollectionIDList(centerCollectionID)
    local tempList = {}
    if rowNum == nil then
        rowNum = Math_Ceil(TerrainRange.x /blockRange.x) --一行总个数
    end
    if columnNum == nil then
        columnNum = Math_Ceil(TerrainRange.y /blockRange.y) --一列总个数
    end
    remain_CalculationAOICollectionIDList = centerCollectionID % rowNum
    --是否靠近边缘
    IsNearTopEdge = centerCollectionID <= rowNum
    IsNearBottomEdge = centerCollectionID > (columnNum -1) * rowNum
    IsNearLeftEdge = remain_CalculationAOICollectionIDList == 1
    IsNearRightEdge = remain_CalculationAOICollectionIDList == 0
    if  1 <= centerCollectionID and  rowNum*columnNum >= centerCollectionID then
        table.insert(tempList,centerCollectionID)
    else
        return tempList
    end
    if not IsNearTopEdge then --不靠上（写入正上方）
        table.insert(tempList,centerCollectionID - rowNum)
    end
    if not IsNearBottomEdge then --不靠下（写入正下方）
        table.insert(tempList,centerCollectionID + rowNum)
    end
    if not IsNearLeftEdge then --不靠上（写入正左方）
        table.insert(tempList,centerCollectionID - 1)
    end
    if not IsNearRightEdge then --不靠上（写入正右方）
        table.insert(tempList,centerCollectionID + 1)
    end
    if not IsNearTopEdge and not IsNearLeftEdge then --不靠上且不靠左（写入左上角）
        table.insert(tempList,centerCollectionID - rowNum - 1)
    end
    if not IsNearTopEdge and not IsNearRightEdge then --不靠上且不靠右（写入右上角）
        table.insert(tempList,centerCollectionID - rowNum + 1)
    end
    if not IsNearBottomEdge and not IsNearLeftEdge then --不靠下且不靠左（写入左上角）
        table.insert(tempList,centerCollectionID + rowNum - 1)
    end
    if not IsNearBottomEdge and not IsNearRightEdge then --不靠下且不靠右（写入右下角）
        table.insert(tempList,centerCollectionID + rowNum + 1)
    end
    return tempList
end

local oldCollectionList_CalculateAOI
local newCollectionList_CalculateAOI
local willRemoveList_CalculateAOI
local willInitList_CalculateAOI
--计算AOI移动时，哪些地块内数据需要增加，哪些地块内数据需要删除
local function CalculateAOI(oldCollectionID,newCollectionID)
    --1.计算C新旧
    oldCollectionList_CalculateAOI =  CalculationAOICollectionIDList(oldCollectionID)
    newCollectionList_CalculateAOI =  CalculationAOICollectionIDList(newCollectionID)
    willRemoveList_CalculateAOI = ComputingTheComplementSetOfBinA(oldCollectionList_CalculateAOI,newCollectionList_CalculateAOI)
    --删除旧有的AOI地块
    for i, tempDeteleCollectionID in pairs(willRemoveList_CalculateAOI) do
        DataManager.RemoveCollectionDatasByCollectionID(tempDeteleCollectionID)
    end
    PathFindManager.RemoveAOIListPalyer(willRemoveList_CalculateAOI)
    --初始化新newCollectionList
    willInitList_CalculateAOI = ComputingTheComplementSetOfBinA(newCollectionList_CalculateAOI,oldCollectionList_CalculateAOI)
    for i, tempInitCollectionID in pairs(willInitList_CalculateAOI) do
        DataManager.InitBuildDatas(tempInitCollectionID)
    end
    --TODO:通知地块数据更新
end

local oldCollectionList_GetAOIWillRemoveCollectionIDs
local newCollectionList_GetAOIWillRemoveCollectionIDs
--外部获取移动时，需要删除的地块
function TerrainManager.GetAOIWillRemoveCollectionIDs(oldCollectionID)
    oldCollectionList_GetAOIWillRemoveCollectionIDs =  CalculationAOICollectionIDList(oldCollectionID)
    newCollectionList_GetAOIWillRemoveCollectionIDs =  CalculationAOICollectionIDList(CameraCollectionID)
    local willRemoveList = ComputingTheComplementSetOfBinA(oldCollectionList_GetAOIWillRemoveCollectionIDs,newCollectionList_GetAOIWillRemoveCollectionIDs)
    return willRemoveList
end

function TerrainManager.IsBelongToCameraCollectionIDAOIList(tempCollectionID)
    for i, value in pairs(CalculationAOICollectionIDList(CameraCollectionID)) do
        if value == tempCollectionID then
            return true
        end
    end
    return false
end

--获取当前AOI的地块们
function TerrainManager.GetCameraCollectionIDAOIList()
    return CalculationAOICollectionIDList(CameraCollectionID)
end

--获取当前的中心地块Id
function TerrainManager.GetCameraCollectionID()
    return CameraCollectionID
end

local msgId_SendMoveToServer = nil
local lMsg_SendMoveToServer
local pMsg_SendMoveToServer
--向服务器发送新的所在地块ID
function TerrainManager.SendMoveToServer(tempBlockID)
    if tempBlockID ~= nil then
        if msgId_SendMoveToServer == nil  then
            msgId_SendMoveToServer = pbl.enum("gscode.OpCode", "move")
        end
        lMsg_SendMoveToServer = TerrainManager.BlockIDTurnCollectionGridIndex(tempBlockID)
        pMsg_SendMoveToServer = assert(pbl.encode("gs.GridIndex", lMsg_SendMoveToServer))
        CityEngineLua.Bundle:newAndSendMsg(msgId_SendMoveToServer, pMsg_SendMoveToServer)
    end
end

local tempBlockID_Refresh
local tempCollectionID_Refresh
--应该每帧调用传camera的位置
function TerrainManager.Refresh(pos)
    tempBlockID_Refresh = TerrainManager.PositionTurnBlockID(pos)
    tempCollectionID_Refresh = TerrainManager.BlockIDTurnCollectionID(tempBlockID_Refresh)
    if CameraCollectionID ~= tempCollectionID_Refresh then
        --设置map的旧中心地块
        MapBubbleManager.setOldAOICenterID(tempCollectionID_Refresh)

        --CalculateAOI,删除无用信息
        CalculateAOI(CameraCollectionID,tempCollectionID_Refresh)
        CameraCollectionID = tempCollectionID_Refresh
        --向服务器发送新的所在地块ID
        TerrainManager.SendMoveToServer(tempBlockID_Refresh)
        Event.Brocast("c_MapReqMarketDetail", tempBlockID_Refresh)  --发送请求搜索的详细信息

        --UnitTest.Exec_now("Allen_w9_SendPosToServer", "c_SendPosToServer_self",self)
        --UnitTest.Exec_now("abel_w13_SceneOpt", "c_abel_w13_SceneOpt",self)
    end
end


local tempX_PositionTurnBlockID
local tempZ_PositionTurnBlockID
--通过位置坐标转化为位置ID
--pos:Vector3
--注：z为列，x为行（y = 0）
function TerrainManager.PositionTurnBlockID(pos)
    if pos == nil or pos.x ==nil or pos.y == nil then
        return nil
    end
    tempX_PositionTurnBlockID = Math_Floor(Math_Abs(pos.x))
    tempZ_PositionTurnBlockID = Math_Floor(Math_Abs(pos.z))
    return tempZ_PositionTurnBlockID + tempX_PositionTurnBlockID * TerrainRange.x + 1
end

local tempX_GridIndexTurnBlockID
local tempZ_GridIndexTurnBlockID
--通过服务器坐标转化为位置ID
--tempGridIndex ： x，y
--注：z为列，x为行（y = 0）
function TerrainManager.GridIndexTurnBlockID(tempGridIndex)
    if tempGridIndex == nil or tempGridIndex.x == nil or tempGridIndex.y == nil then
        return nil
    end
    tempX_GridIndexTurnBlockID = Math_Floor(Math_Abs(tempGridIndex.x))
    tempZ_GridIndexTurnBlockID = Math_Floor( Math_Abs(tempGridIndex.y))
    return tempZ_GridIndexTurnBlockID + tempX_GridIndexTurnBlockID * TerrainRange.x + 1
end


local idPos_BlockIDTurnPosition
--通过位置ID转化为位置坐标
--注：z为列，x为行（y = 0）
function TerrainManager.BlockIDTurnPosition(id)
    idPos_BlockIDTurnPosition = Vector3.New(-100,0,-100) --初始到视线外
    if id >= 1 and id<= (TerrainRange.x * TerrainRange.y) then
        idPos_BlockIDTurnPosition.z = id % TerrainRange.x - 1
        idPos_BlockIDTurnPosition.x =  Math_Floor(id / TerrainRange.x)
    end
    return idPos_BlockIDTurnPosition
end

local rowNum_BlockIDTurnCollectionID
local Remainder_BlockIDTurnCollectionID
local Y_BlockIDTurnCollectionID
local X_BlockIDTurnCollectionID
--通过BlcokID转化为BlockCollectionID
function TerrainManager.BlockIDTurnCollectionID(blockID)
    if blockID == nil then
        return -1
    end
    rowNum_BlockIDTurnCollectionID = Math_Ceil(TerrainRange.x /blockRange.x)
    Y_BlockIDTurnCollectionID = Math_Floor((blockID / TerrainRange.x) / blockRange.y) * rowNum_BlockIDTurnCollectionID    --行
    Remainder_BlockIDTurnCollectionID = (blockID %  TerrainRange.x)
    if Remainder_BlockIDTurnCollectionID ~= 0 then
        Remainder_BlockIDTurnCollectionID = Remainder_BlockIDTurnCollectionID - 1
    end
    X_BlockIDTurnCollectionID = Math_Floor(Remainder_BlockIDTurnCollectionID / blockRange.x ) + 1            --列
    return X_BlockIDTurnCollectionID +  Y_BlockIDTurnCollectionID
end

local Remainder_BlockIDTurnCollectionGridIndex
local X_BlockIDTurnCollectionGridIndex
local Y_BlockIDTurnCollectionGridIndex
--通过BlcokID转化为BlockCollection坐标
function TerrainManager.BlockIDTurnCollectionGridIndex(blockID)
    if blockID == nil then
        return{ x = -1,y = -1}
    end
    Remainder_BlockIDTurnCollectionGridIndex = (blockID %  TerrainRange.x)
    if Remainder_BlockIDTurnCollectionGridIndex ~= 0 then
        Remainder_BlockIDTurnCollectionGridIndex = Remainder_BlockIDTurnCollectionGridIndex - 1
    end
    X_BlockIDTurnCollectionGridIndex = Math_Floor((blockID / TerrainRange.x) / blockRange.y)
    Y_BlockIDTurnCollectionGridIndex = Math_Floor(Remainder_BlockIDTurnCollectionGridIndex/ blockRange.x)
    return{ x = X_BlockIDTurnCollectionGridIndex,y = Y_BlockIDTurnCollectionGridIndex}
end

local X_CollectionIDTurnBlockID
local Y_CollectionIDTurnBlockID
--通过BlockCollectionID转化为BlcokID
function TerrainManager.CollectionIDTurnBlockID(collectionID)
    X_CollectionIDTurnBlockID = Math_Floor( collectionID / Math_Ceil(TerrainRange.x /blockRange.x) ) * blockRange.y * TerrainRange.x
    Y_CollectionIDTurnBlockID = ((collectionID % Math_Ceil(TerrainRange.x /blockRange.x)) -1 ) * blockRange.x + 1
    return X_CollectionIDTurnBlockID +  Y_CollectionIDTurnBlockID
end

function TerrainManager.CollectionIDTurnCollectionGridIndex(collectionID)

end

local tempX_AOIGridIndexTurnCollectionID
local tempZ_AOIGridIndexTurnCollectionID
function TerrainManager.AOIGridIndexTurnCollectionID(tempGridIndex)
    tempX_AOIGridIndexTurnCollectionID = Math_Floor(Math_Abs(tempGridIndex.x))
    tempZ_AOIGridIndexTurnCollectionID = Math_Floor(Math_Abs(tempGridIndex.y))
    return tempZ_AOIGridIndexTurnCollectionID + tempX_AOIGridIndexTurnCollectionID * Math_Ceil(TerrainRange.x /blockRange.x) + 1
end


local Vec3_CreateConstructBuildSuccess
--创建临时修建建筑物
local function CreateConstructBuildSuccess(go,table)
    --判空
    if #table <2 then
        return;
    end
    DataManager.TempDatas.constructID  = table[1]
    --防止加载太慢
    if DataManager.TempDatas.constructObj ~= nil then
        destroy(DataManager.TempDatas.constructObj)
    end
    DataManager.TempDatas.constructObj = go
    Vec3_CreateConstructBuildSuccess = table[2]
    --add height
    Vec3_CreateConstructBuildSuccess.y =  Vec3_CreateConstructBuildSuccess.y + 0.03
    DataManager.TempDatas.constructObj.transform.position = Vec3_CreateConstructBuildSuccess
    DataManager.TempDatas.constructPosID = TerrainManager.PositionTurnBlockID(table[2])
    --一定要放在数据刷新完后打开
    ct.OpenCtrl('ConstructSwitchCtrl')
end

--取消建筑的修建
function TerrainManager.AbolishConstructBuild()
    --干掉临时GameObject
    if DataManager.TempDatas.constructObj ~= nil then
        destroy(DataManager.TempDatas.constructObj)
        DataManager.TempDatas.constructObj = nil
        DataManager.TempDatas.constructPosID = nil
        DataManager.TempDatas.constructID = nil
        DataManager.TempDatas.constructBlockList = nil
    end
end

--移动了ConstructObj
function TerrainManager.MoveTempConstructObj()
    if DataManager.TempDatas.constructObj ~= nil then
        Event.Brocast("m_constructBuildGameObjectMove")
    end
end

--修建建筑（临时）
function TerrainManager.ConstructBuild(buildId,buildPos)
    if DataManager.TempDatas.constructObj ~= nil then
        Event.Brocast("m_abolishConstructBuild")
    end
    buildMgr:CreateBuild(PlayerBuildingBaseData[buildId]["prefabRoute"],CreateConstructBuildSuccess,{buildId, buildPos})
end

local tempPos_TouchBuild
local blockID_TouchBuild
local tempNodeID_TouchBuild
local tempModel_TouchBuild
--点击3D场景【旧的，被CameraMove:TouchBuild取代】
--若点击到3D建筑所占地块
function TerrainManager.TouchBuild(MousePos)
    tempPos_TouchBuild = rayMgr:GetCoordinateByVector3(MousePos)
    blockID_TouchBuild = TerrainManager.PositionTurnBlockID(tempPos_TouchBuild)
    tempNodeID_TouchBuild  = DataManager.GetBlockDataByID(blockID_TouchBuild)
    if tempNodeID_TouchBuild ~= nil and tempNodeID_TouchBuild ~= -1 then
        tempModel_TouchBuild = DataManager.GetBaseBuildDataByID(tempNodeID_TouchBuild)
        if nil ~= tempModel_TouchBuild then
            tempModel_TouchBuild:OpenPanel()
        end
    end
end

local centerPos = nil
--移动到中心建筑位置
function TerrainManager.MoveToCentralBuidingPosition()
    if TerrainConfig ~= nil and TerrainConfig.CentralBuilding ~= nil and TerrainConfig.CentralBuilding.CenterNodePos ~= nil then
        if centerPos == nil then
            centerPos = Vector3.New(TerrainConfig.CentralBuilding.CenterNodePos.x , TerrainConfig.CentralBuilding.CenterNodePos.y ,TerrainConfig.CentralBuilding.CenterNodePos.z)
            centerPos.x = centerPos.x + PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].x / 2
            centerPos.z = centerPos.z + PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].y / 2
        end
        CameraMove.MoveCameraToPos(centerPos)
    end
end

UnitTest.TestBlockStart()

UnitTest.Exec("Allen_w9_SendPosToServer", "test_TerrainManager_self",  function ()
    ct.log("Allen_w9_SendPosToServer","[test_TerrainManager_self] ...............")
    Event.AddListener("c_SendPosToServer_self", function (obj)
        TerrainManager.ReceiveArchitectureDatas(tempBuilds)
    end)
end)

UnitTest.Exec("abel_w13_SceneOpt", "test_abel_w13_SceneOpt",  function ()
    ct.log("abel_w13_SceneOpt","[test_abel_w13_SceneOpt] ...............")
    Event.AddListener("c_abel_w13_SceneOpt", function (obj)
        TerrainManager.ReceiveArchitectureDatas(big)
    end)
end)

UnitTest.Exec("Allen_w9", "test_TerrainManagerRefresh",  function ()
    Event.AddListener("c_CameraMove", function (obj)
        TerrainManager.Refresh(Vector3.New(0,0,0))
    end)
end)

UnitTest.TestBlockEnd()