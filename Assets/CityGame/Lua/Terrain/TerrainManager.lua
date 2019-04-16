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

--创建系统建筑的GameObject
function TerrainManager.CreateSystemBuildingGameObjects(CollectionID)
    local systemMapTemp = SystemMapConfig[CollectionID]
    if systemMapTemp ~= nil then
        for blockId, PlayerDataID in pairs(systemMapTemp) do
            local go = MapObjectsManager.GetGameObjectByPool(PlayerBuildingBaseData[PlayerDataID].poolName)
            local BuildPosition = TerrainManager.BlockIDTurnPosition(blockId)
            BuildPosition.y =  BuildPosition.y + 0.02
            go.transform.position = BuildPosition
            --go.transform:SetParent(TerrainManager.TerrainRoot)
            DataManager.AddSystemBuild(CollectionID,blockId,PlayerBuildingBaseData[PlayerDataID].poolName,go)
        end
    end
end

local function BuildCreateSuccess( value , buildingID , BuildPosition)
    local go  = MapObjectsManager.GetGameObjectByPool(PlayerBuildingBaseData[value.buildingID].poolName)
    --add height
    BuildPosition.y =  BuildPosition.y + 0.02
    go.transform.position = BuildPosition
    if TerrainManager.TerrainRoot == nil  then
        TerrainManager.TerrainRoot = UnityEngine.GameObject.Find("Terrain").transform
    end
    go.transform:SetParent(TerrainManager.TerrainRoot)
    --[[无用
    if PlayerBuildingBaseData[buildingID]["LuaRoute"] ~= nil then
        ArchitectureStack[buildingID] = CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingID]["LuaRoute"])
    end
    --]]
    --将建筑GameObject保存到对应Model中
    local  tempBaseBuildModel = DataManager.GetBaseBuildDataByID(TerrainManager.PositionTurnBlockID(BuildPosition))
    if TerrainManager.BuildObjQueue ~= nil then
        TerrainManager.BuildObjQueue = TerrainManager.BuildObjQueue - 1
    end
    if tempBaseBuildModel ~= nil and tempBaseBuildModel.go == nil then
        tempBaseBuildModel.go = go
        return
    end
    MapObjectsManager.RecyclingGameObjectToPool(PlayerBuildingBaseData[value.buildingID].poolName,go)
end

--根据建筑数据生成GameObject
--参数：
--  datas：数据table集合( 一定包含数据有：坐标==》  x,y  ,建筑类型id==》 buildId)
function  TerrainManager.ReceiveArchitectureDatas(datas)
    if not datas then
        return
    end
    local RefreshCollectionList = {}
    for key, value in pairs(datas) do
        local isCreate = DataManager.RefreshBaseBuildData(value)
        --判断是否需要创建建筑
        if isCreate then
            BuildCreateSuccess(value,value.buildingID, Vector3.New(value.x,0,value.y))
        end
    end
    --[[
    for key, value in pairs(TerrainManager.GetCameraCollectionIDAOIList()) do
        TerrainManager.IsIncludeCentralBuilding(value)
    end--]]
    --刷新AOI内的数据
    if CameraCollectionID ~= nil and CameraCollectionID ~= -1 then
        local AOIList = TerrainManager.GetCameraCollectionIDAOIList()
        for key, value in pairs(AOIList) do
            DataManager.RefreshWaysByCollectionID( value)
        end
        PathFindManager.CreateAOIListPalyer(AOIList)
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

--计算AOI范围内的地块ID
local function CalculationAOICollectionIDList(centerCollectionID)
    local tempList = {}
    local rowNum = Math_Ceil(TerrainRange.x /blockRange.x) --一行总个数
    local columnNum = Math_Ceil(TerrainRange.y /blockRange.y) --一列总个数
    local remain = centerCollectionID % rowNum
    --是否靠近边缘
    local IsNearTopEdge = centerCollectionID <= rowNum
    local IsNearBottomEdge = centerCollectionID > (columnNum -1) * rowNum
    local IsNearLeftEdge = remain == 1
    local IsNearRightEdge = remain == 0
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

--计算AOI移动时，哪些地块内数据需要增加，哪些地块内数据需要删除
local function CalculateAOI(oldCollectionID,newCollectionID)
    --1.计算C新旧
    local oldCollectionList =  CalculationAOICollectionIDList(oldCollectionID)
    local newCollectionList =  CalculationAOICollectionIDList(newCollectionID)
    local willRemoveList = ComputingTheComplementSetOfBinA(oldCollectionList,newCollectionList)
    --删除旧有的AOI地块
    for i, tempDeteleCollectionID in pairs(willRemoveList) do
        DataManager.RemoveCollectionDatasByCollectionID(tempDeteleCollectionID)
    end
    PathFindManager.RemoveAOIListPalyer(willRemoveList)
    --初始化新newCollectionList
    local willInitList = ComputingTheComplementSetOfBinA(newCollectionList,oldCollectionList)
    for i, tempInitCollectionID in pairs(willInitList) do
        DataManager.InitBuildDatas(tempInitCollectionID)
    end
    --TODO:通知地块数据更新
end

--外部获取移动时，需要删除的地块
function TerrainManager.GetAOIWillRemoveCollectionIDs(oldCollectionID)
    local oldCollectionList =  CalculationAOICollectionIDList(oldCollectionID)
    local newCollectionList =  CalculationAOICollectionIDList(CameraCollectionID)
    local willRemoveList = ComputingTheComplementSetOfBinA(oldCollectionList,newCollectionList)
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

--向服务器发送新的所在地块ID
function TerrainManager.SendMoveToServer(tempBlockID)
    local msgId = pbl.enum("gscode.OpCode", "move")
    local lMsg = TerrainManager.BlockIDTurnCollectionGridIndex(tempBlockID)
    local pMsg = assert(pbl.encode("gs.GridIndex", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end

--应该每帧调用传camera的位置
function TerrainManager.Refresh(pos)
    local tempBlockID = TerrainManager.PositionTurnBlockID(pos)
    local tempCollectionID = TerrainManager.BlockIDTurnCollectionID(tempBlockID)
    if CameraCollectionID ~= tempCollectionID then
        --设置map的旧中心地块
        MapBubbleManager.setOldAOICenterID(tempCollectionID)

        --CalculateAOI,删除无用信息
        CalculateAOI(CameraCollectionID,tempCollectionID)
        CameraCollectionID = tempCollectionID
        --向服务器发送新的所在地块ID
        TerrainManager.SendMoveToServer(tempBlockID)
        Event.Brocast("c_MapReqMarketDetail", tempBlockID)  --发送请求搜索的详细信息

        UnitTest.Exec_now("Allen_w9_SendPosToServer", "c_SendPosToServer_self",self)
        UnitTest.Exec_now("abel_w13_SceneOpt", "c_abel_w13_SceneOpt",self)
    end
end

--通过位置坐标转化为位置ID
--pos:Vector3
--注：z为列，x为行（y = 0）
function TerrainManager.PositionTurnBlockID(pos)
    local tempX = Math_Floor(Math_Abs(pos.x))
    local tempZ = Math_Floor(Math_Abs(pos.z))
    return tempZ + tempX * TerrainRange.x + 1
end

--通过服务器坐标转化为位置ID
--tempGridIndex ： x，y
--注：z为列，x为行（y = 0）
function TerrainManager.GridIndexTurnBlockID(tempGridIndex)
    local tempX = Math_Floor(Math_Abs(tempGridIndex.x))
    local tempZ = Math_Floor( Math_Abs(tempGridIndex.y))
    return tempZ + tempX * TerrainRange.x + 1
end

--通过位置ID转化为位置坐标
--注：z为列，x为行（y = 0）
function TerrainManager.BlockIDTurnPosition(id)
    local idPos = Vector3.New(-100,0,-100) --初始到视线外
    if id >= 1 and id<= (TerrainRange.x * TerrainRange.y) then
        idPos.z = id % TerrainRange.x - 1
        idPos.x =  Math_Floor(id / TerrainRange.x)
    end
    return idPos
end

--通过BlcokID转化为BlockCollectionID
function TerrainManager.BlockIDTurnCollectionID(blockID)
    if blockID == nil then
        return -1
    end
    local rowNum = Math_Ceil(TerrainRange.x /blockRange.x)
    local Y = Math_Floor((blockID / TerrainRange.x) / blockRange.y) * rowNum    --行
    local Remainder = (blockID %  TerrainRange.x)
    if Remainder ~= 0 then
        Remainder = Remainder - 1
    end
    local X = Math_Floor(Remainder / blockRange.x ) + 1            --列
    return X +  Y
end

--通过BlcokID转化为BlockCollection坐标
function TerrainManager.BlockIDTurnCollectionGridIndex(blockID)
    if blockID == nil then
        return{ x = -1,y = -1}
    end
    local Remainder = (blockID %  TerrainRange.x)
    if Remainder ~= 0 then
        Remainder = Remainder - 1
    end
    local X = Math_Floor((blockID / TerrainRange.x) / blockRange.y)
    local Y = Math_Floor(Remainder/ blockRange.x)
    return{ x = X,y = Y}
end

--通过BlockCollectionID转化为BlcokID
function TerrainManager.CollectionIDTurnBlockID(collectionID)
    local X = Math_Floor( collectionID / Math_Ceil(TerrainRange.x /blockRange.x) ) * blockRange.y * TerrainRange.x
    local Y = ((collectionID % Math_Ceil(TerrainRange.x /blockRange.x)) -1 ) * blockRange.x + 1
    return X +  Y
end

function TerrainManager.CollectionIDTurnCollectionGridIndex(collectionID)

end

function TerrainManager.AOIGridIndexTurnCollectionID(tempGridIndex)
    local tempX = Math_Floor(Math_Abs(tempGridIndex.x))
    local tempZ = Math_Floor(Math_Abs(tempGridIndex.y))
    return tempZ + tempX * Math_Ceil(TerrainRange.x /blockRange.x) + 1
end

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
    local Vec3 = table[2]
    --add height
    Vec3.y =  Vec3.y + 0.03
    DataManager.TempDatas.constructObj.transform.position = Vec3
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

--点击3D场景【旧的，被CameraMove:TouchBuild取代】
--若点击到3D建筑所占地块
function TerrainManager.TouchBuild(MousePos)
    local tempPos = rayMgr:GetCoordinateByVector3(MousePos)
    local blockID = TerrainManager.PositionTurnBlockID(tempPos)
    local tempNodeID  = DataManager.GetBlockDataByID(blockID)
    if tempNodeID ~= nil and tempNodeID ~= -1 then
        local tempModel = DataManager.GetBaseBuildDataByID(tempNodeID)
        if nil ~= tempModel then
            tempModel:OpenPanel()
        end
    end
end

--移动到中心建筑位置
function TerrainManager.MoveToCentralBuidingPosition()
    if TerrainConfig ~= nil and TerrainConfig.CentralBuilding ~= nil and TerrainConfig.CentralBuilding.CenterNodePos ~= nil then
        local centerPos = Vector3.New(TerrainConfig.CentralBuilding.CenterNodePos.x , TerrainConfig.CentralBuilding.CenterNodePos.y ,TerrainConfig.CentralBuilding.CenterNodePos.z)
        centerPos.x = centerPos.x + PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].x / 2
        centerPos.z = centerPos.z + PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].y / 2
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