--Allen
--地图管理器
--1.
--      1、商业建筑实例类堆栈 ArchitectureStack[]
--      2、
UnitTest = require ('test/testFrameWork/UnitTest')
--Framework/pbl/luaunit
TerrainManager = {}
local ArchitectureStack = {}
--以下数据应与服务器同步
local TerrainRange = Vector2.New(1000 , 1000)    --地图大小范围
local blockRange = Vector2.New(20, 20)
--以下数据应当初始化
local CameraPosition
local CameraCollectionID = -1

--创建建筑GameObject成功回调
local function CreateSuccess(go,table)
    local buildingID = table[1]
    local Vec3 = table[2]
    --add height
    Vec3.y =  Vec3.y + 0.01
    go.transform.position = Vec3
    --CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingID]["LuaRoute"])
    if TerrainManager.TerrainRoot == nil  then
        TerrainManager.TerrainRoot = UnityEngine.GameObject.Find("Terrain").transform
    end
    go.transform:SetParent(TerrainManager.TerrainRoot)
    if PlayerBuildingBaseData[buildingID]["LuaRoute"] ~= nil then
        ArchitectureStack[buildingID] = CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingID]["LuaRoute"])
    end
    --将建筑GameObject保存到对应Model中
    local  tempBaseBuildModel=DataManager.GetBaseBuildDataByID(TerrainManager.PositionTurnBlockID(Vec3))
    if tempBaseBuildModel ~= nil then
        tempBaseBuildModel.go = go
    end
end

function TerrainManager.Init()
    Event.AddListener("CameraMoveTo",TerrainManager.Refresh)
end

function TerrainManager.ReMove()
    Event.RemoveListener("CameraMoveTo",TerrainManager.Refresh)
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
            buildMgr:CreateBuild(PlayerBuildingBaseData[value.buildingID]["prefabRoute"],CreateSuccess,{value.buildingID, Vector3.New(value.x,0,value.y)})
        end
    end
    --刷新AOI内的数据
    if CameraCollectionID ~= nil and CameraCollectionID == -1 then
        for key, value in pairs(TerrainManager.GetCameraCollectionIDAOIList()) do
            DataManager.RefreshWaysByCollectionID( value)
        end
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
    local rowNum = math.ceil(TerrainRange.x /blockRange.x) --一行总个数
    local columnNum = math.ceil(TerrainRange.y /blockRange.y) --一列总个数
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
    for i, tempDeteleCollectionID in pairs(willRemoveList) do
        DataManager.RemoveCollectionDatasByCollectionID(tempDeteleCollectionID)
    end
end

--获取当前AOI的地块们
function TerrainManager.GetCameraCollectionIDAOIList()
    return CalculationAOICollectionIDList(CameraCollectionID)
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
        --CalculateAOI,删除无用信息
        CalculateAOI(CameraCollectionID,tempCollectionID)
        CameraCollectionID = tempCollectionID
        --向服务器发送新的所在地块ID
        TerrainManager.SendMoveToServer(tempBlockID)
        UnitTest.Exec_now("Allen_w9_SendPosToServer", "c_SendPosToServer_self",self)
        UnitTest.Exec_now("abel_w13_SceneOpt", "c_abel_w13_SceneOpt",self)
    end
end

--通过位置坐标转化为位置ID
--pos:Vector3
--注：z为列，x为行（y = 0）
function TerrainManager.PositionTurnBlockID(pos)
    local tempX = math.floor(math.abs(pos.x))
    local tempZ = math.floor(math.abs(pos.z))
    return tempZ + tempX * TerrainRange.x + 1
end

--通过服务器坐标转化为位置ID
--tempGridIndex ： x，y
--注：z为列，x为行（y = 0）
function TerrainManager.GridIndexTurnBlockID(tempGridIndex)
    local tempX = math.floor(math.abs(tempGridIndex.x))
    local tempZ = math.floor( math.abs(tempGridIndex.y))
    return tempZ + tempX * TerrainRange.x + 1
end

--通过位置ID转化为位置坐标
--注：z为列，x为行（y = 0）
function TerrainManager.BlockIDTurnPosition(id)
    local idPos = Vector3.New(-100,0,-100) --初始到视线外
    if id >= 1 and id<= (TerrainRange.x * TerrainRange.y) then
        idPos.z = id % TerrainRange.x - 1
        idPos.x =  math.floor(id / TerrainRange.x)
    end
    return idPos
end

--通过BlcokID转化为BlockCollectionID
function TerrainManager.BlockIDTurnCollectionID(blockID)
    if blockID == nil then
        return -1
    end
    local rowNum = math.ceil(TerrainRange.x /blockRange.x)
    local Y = math.floor((blockID / TerrainRange.x) / blockRange.y) * rowNum    --行
    local X = math.floor((blockID %  TerrainRange.x) / blockRange.x ) + 1            --列
    return X +  Y
end

--通过BlcokID转化为BlockCollection坐标
function TerrainManager.BlockIDTurnCollectionGridIndex(blockID)
    if blockID == nil then
        return{ x = -1,y = -1}
    end
    local X = math.floor((blockID % TerrainRange.x )/ blockRange.x)
    local Y = math.floor((blockID / TerrainRange.x) / blockRange.y)
    return{ x = X,y = Y}
end

--通过BlockCollectionID转化为BlcokID
function TerrainManager.CollectionIDTurnBlockID(collectionID)
    local X = math.floor( collectionID / math.ceil(TerrainRange.x /blockRange.x) ) * blockRange.y * TerrainRange.x
    local Y = ((collectionID % math.ceil(TerrainRange.x /blockRange.x)) -1 ) * blockRange.x
    return X +  Y
end

function TerrainManager.CollectionIDTurnCollectionGridIndex(collectionID)

end

--创建临时修建建筑物
local function CreateConstructBuildSuccess(go,table)
    --判空
    if #table <2 then
        return;
    end
    DataManager.TempDatas.constructID  = table[1]
    DataManager.TempDatas.constructObj = go
    DataManager.TempDatas.constructObj.transform.position = table[2]
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

--点击3D场景
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