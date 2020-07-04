--Allen
--Map manager
--1.
--      1、commercial building example class stack ArchitectureStack[]
--      2、
UnitTest = require ('test/testFrameWork/UnitTest')
TerrainManager = {}

local Math_Floor = math.floor
local Math_Ceil =  math.ceil
local Math_Abs =  math.abs

local ArchitectureStack = {}
--The following data should be synchronized with the server
local TerrainRange = Vector2.New(1000 , 1000)    --地图大小范围
local blockRange = Vector2.New(20, 20)
--The following data should be initialized
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
--Create GameObject for system architecture
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
    --It doesn't make much sense
    --[[
    if TerrainManager.TerrainRoot == nil  then
        TerrainManager.TerrainRoot = UnityEngine.GameObject.Find("Terrain").transform
    end
    go_BuildCreateSuccess.transform:SetParent(TerrainManager.TerrainRoot)
    --]]
    --[[Useless
    if PlayerBuildingBaseData[buildingID]["LuaRoute"] ~= nil then
        ArchitectureStack[buildingID] = CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingID]["LuaRoute"])
    end
    --]]
    --Save the building GameObject to the corresponding Model
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
--Generate GameObject from building data
--parameter：
--  datas：Data table collection (must contain data: coordinates==》  x,y  ,building type id==》 buildId)
function  TerrainManager.ReceiveArchitectureDatas(datas)
    if not datas then
        return
    end
    for key, value in pairs(datas) do
        --Determine if you need to create a building
        if DataManager.RefreshBaseBuildData(value) then
            BuildCreateSuccess(value,value.buildingID, Vector3.New(value.x,0,value.y))
        end
    end
    --Refresh the data in AOI
    if CameraCollectionID ~= nil and CameraCollectionID ~= -1 then
        AOIList_ReceiveArchitectureDatas = TerrainManager.GetCameraCollectionIDAOIList()
        for key, value in pairs(AOIList_ReceiveArchitectureDatas) do
            DataManager.RefreshWaysByCollectionID(value)
        end
        PathFindManager.CreateAOIListPalyer(AOIList_ReceiveArchitectureDatas)
    end
end

--Calculate the complement of B in A (that is, there is in A, but not in B)
--A: Table (value is a collection)
--B: Table (value is a collection)
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


--Calculate all values in set A near set B (including B)
--Temporarily abandoned
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
--Calculate plot ID within AOI
local function CalculationAOICollectionIDList(centerCollectionID)
    local tempList = {}
    if rowNum == nil then
        rowNum = Math_Ceil(TerrainRange.x /blockRange.x) --the total number of one line
    end
    if columnNum == nil then
        columnNum = Math_Ceil(TerrainRange.y /blockRange.y) --the total number of a column
    end
    remain_CalculationAOICollectionIDList = centerCollectionID % rowNum
    --whether it is close to the edge
    IsNearTopEdge = centerCollectionID <= rowNum
    IsNearBottomEdge = centerCollectionID > (columnNum -1) * rowNum
    IsNearLeftEdge = remain_CalculationAOICollectionIDList == 1
    IsNearRightEdge = remain_CalculationAOICollectionIDList == 0
    if  1 <= centerCollectionID and  rowNum*columnNum >= centerCollectionID then
        table.insert(tempList,centerCollectionID)
    else
        return tempList
    end
    if not IsNearTopEdge then --Not on top (write directly above)
        table.insert(tempList,centerCollectionID - rowNum)
    end
    if not IsNearBottomEdge then --Not lower (write directly below)
        table.insert(tempList,centerCollectionID + rowNum)
    end
    if not IsNearLeftEdge then --Not on top (write to the left)
        table.insert(tempList,centerCollectionID - 1)
    end
    if not IsNearRightEdge then --Not on top (write to the right)
        table.insert(tempList,centerCollectionID + 1)
    end
    if not IsNearTopEdge and not IsNearLeftEdge then --Not on the top and not on the left (written in the upper left corner)
        table.insert(tempList,centerCollectionID - rowNum - 1)
    end
    if not IsNearTopEdge and not IsNearRightEdge then --Not on the right and not on the right (written in the upper right corner)
        table.insert(tempList,centerCollectionID - rowNum + 1)
    end
    if not IsNearBottomEdge and not IsNearLeftEdge then --No lower and no left (written in the upper left corner)
        table.insert(tempList,centerCollectionID + rowNum - 1)
    end
    if not IsNearBottomEdge and not IsNearRightEdge then --Not lower and not right (written in the lower right corner)
        table.insert(tempList,centerCollectionID + rowNum + 1)
    end
    return tempList
end

local oldCollectionList_CalculateAOI
local newCollectionList_CalculateAOI
local willRemoveList_CalculateAOI
local willInitList_CalculateAOI
--When calculating AOI movement, which parcels of data need to be added and which parcels of data need to be deleted
local function CalculateAOI(oldCollectionID,newCollectionID)
    --1.Calculate C new and old
    oldCollectionList_CalculateAOI =  CalculationAOICollectionIDList(oldCollectionID)
    newCollectionList_CalculateAOI =  CalculationAOICollectionIDList(newCollectionID)
    willRemoveList_CalculateAOI = ComputingTheComplementSetOfBinA(oldCollectionList_CalculateAOI,newCollectionList_CalculateAOI)
    --Delete old AOI plots
    for i, tempDeteleCollectionID in pairs(willRemoveList_CalculateAOI) do
        DataManager.RemoveCollectionDatasByCollectionID(tempDeteleCollectionID)
    end
    PathFindManager.RemoveAOIListPalyer(willRemoveList_CalculateAOI)
    --Initialize new newCollectionList
    willInitList_CalculateAOI = ComputingTheComplementSetOfBinA(newCollectionList_CalculateAOI,oldCollectionList_CalculateAOI)
    for i, tempInitCollectionID in pairs(willInitList_CalculateAOI) do
        DataManager.InitBuildDatas(tempInitCollectionID)
    end
    --TODO: notify land parcel data update
end

local oldCollectionList_GetAOIWillRemoveCollectionIDs
local newCollectionList_GetAOIWillRemoveCollectionIDs
--Plots that need to be deleted when moving externally
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

--Get the current AOI plots
function TerrainManager.GetCameraCollectionIDAOIList()
    return CalculationAOICollectionIDList(CameraCollectionID)
end

--Get the current central plot Id
function TerrainManager.GetCameraCollectionID()
    return CameraCollectionID
end

local msgId_SendMoveToServer = nil
local lMsg_SendMoveToServer
local pMsg_SendMoveToServer
--Send a new location block to the server ID
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
--The location of the transfer camera should be called every frame
function TerrainManager.Refresh(pos)
    tempBlockID_Refresh = TerrainManager.PositionTurnBlockID(pos)
    tempCollectionID_Refresh = TerrainManager.BlockIDTurnCollectionID(tempBlockID_Refresh)
    if CameraCollectionID ~= tempCollectionID_Refresh then
        --Set the old center plot of the map
        MapBubbleManager.setOldAOICenterID(tempCollectionID_Refresh)

        --CalculateAOI, delete useless information
        CalculateAOI(CameraCollectionID,tempCollectionID_Refresh)
        CameraCollectionID = tempCollectionID_Refresh
        --Send new location block ID to server
        TerrainManager.SendMoveToServer(tempBlockID_Refresh)
        Event.Brocast("c_MapReqMarketDetail", tempBlockID_Refresh)  --Send request search details
        --UnitTest.Exec_now("Allen_w9_SendPosToServer", "c_SendPosToServer_self",self)
        --UnitTest.Exec_now("abel_w13_SceneOpt", "c_abel_w13_SceneOpt",self)
    end
end


local tempX_PositionTurnBlockID
local tempZ_PositionTurnBlockID
--Convert to coordinates by position coordinates
--pos:Vector3
--Note: z is the column and x is the row (y = 0)
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
--Convert to location ID through server coordinates
--tempGridIndex: x, y
--Note: z is the column and x is the row (y = 0)
function TerrainManager.GridIndexTurnBlockID(tempGridIndex)
    if tempGridIndex == nil or tempGridIndex.x == nil or tempGridIndex.y == nil then
        return nil
    end
    tempX_GridIndexTurnBlockID = Math_Floor(Math_Abs(tempGridIndex.x))
    tempZ_GridIndexTurnBlockID = Math_Floor( Math_Abs(tempGridIndex.y))
    return tempZ_GridIndexTurnBlockID + tempX_GridIndexTurnBlockID * TerrainRange.x + 1
end


local idPos_BlockIDTurnPosition
--Convert to position coordinates by position ID
--Note: z is the column and x is the row (y = 0)
function TerrainManager.BlockIDTurnPosition(id)
    idPos_BlockIDTurnPosition = Vector3.New(-100,0,-100) --Initially out of sight
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
--Convert to BlockCollectionID by BlcokID
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
--Convert to BlockCollectionID by BlcokID
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
--Convert to BlockCollectionID by BlcokID
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
--Create temporary building
local function CreateConstructBuildSuccess(go,table)
    --Judge empty
    if #table <2 then
        return;
    end
    DataManager.TempDatas.constructID  = table[1]
    --Prevent loading too slow
    if DataManager.TempDatas.constructObj ~= nil then
        destroy(DataManager.TempDatas.constructObj)
    end
    DataManager.TempDatas.constructObj = go
    Vec3_CreateConstructBuildSuccess = table[2]
    --add height
    Vec3_CreateConstructBuildSuccess.y =  Vec3_CreateConstructBuildSuccess.y + 0.03
    DataManager.TempDatas.constructObj.transform.position = Vec3_CreateConstructBuildSuccess
    DataManager.TempDatas.constructPosID = TerrainManager.PositionTurnBlockID(table[2])
    --Be sure to open it after the data is refreshed
    ct.OpenCtrl('ConstructSwitchCtrl')
end

--Cancel the construction of the building
function TerrainManager.AbolishConstructBuild()
    --Kill the temporary
    if DataManager.TempDatas.constructObj ~= nil then
        destroy(DataManager.TempDatas.constructObj)
        DataManager.TempDatas.constructObj = nil
        DataManager.TempDatas.constructPosID = nil
        DataManager.TempDatas.constructID = nil
        DataManager.TempDatas.constructBlockList = nil
    end
end

--Moved ConstructObj
function TerrainManager.MoveTempConstructObj()
    if DataManager.TempDatas.constructObj ~= nil then
        Event.Brocast("m_constructBuildGameObjectMove")
    end
end

--Construction of buildings (temporary)
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
--Click on the 3D scene [old, replaced by CameraMove: TouchBuild]
--If you click on the land occupied by 3 buildings
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
--Move to the central building location
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