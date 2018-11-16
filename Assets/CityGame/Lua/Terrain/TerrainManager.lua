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

--创建建筑成功回调
local function CreateSuccess(go,table)
    local buildId = table[1]
    local Vec3 = table[2]
    go.transform.position = Vec3
    --CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildId]["LuaRoute"])
    if TerrainManager.TerrainRoot == nil  then
        TerrainManager.TerrainRoot = UnityEngine.GameObject.Find("Terrain").transform
    end
    go.transform:SetParent(TerrainManager.TerrainRoot)

    ArchitectureStack[buildId] = CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildId]["LuaRoute"])
end

--接受基础地块数据
local function ReceiveArchitectureDatas(datas)
    for key, value in pairs(datas) do
        local isCreate = DataManager.RefreshBaseBuildData(value)
        --判断是否需要创建建筑
        if isCreate then
            buildMgr:CreateBuild(PlayerBuildingBaseData[value.buildId]["prefabRoute"],CreateSuccess,{value.buildId, Vector3.New(value.x,0,value.y)})
        end
    end
end

--应该每帧调用传camera的位置
function TerrainManager.Refresh(pos)
    local tempCollectionID = TerrainManager.BlockIDTurnCollectionID(TerrainManager.PositionTurnBlockID(pos))
    --ct.log("Allen_w9","tempCollectionID===============>"..tempCollectionID)
    if CameraCollectionID ~= tempCollectionID then
        CameraCollectionID = tempCollectionID
        --TODO:向服务器发送新的所在地块ID，刷新数据model
        UnitTest.Exec_now("Allen_w9_SendPosToServer", "c_SendPosToServer_self",self)
    end
end

--通过位置坐标转化为位置ID
--注：z为列，x为行（y = 0）
function TerrainManager.PositionTurnBlockID(pos)
    local tempX = math.floor(math.abs(pos.x))
    local tempZ = math.ceil( math.abs(pos.z))
    if tempX >= 1 then
        return tempZ + (tempX- 1) * TerrainRange.x
    else
        return tempZ
    end
end

--通过位置ID转化为位置坐标
--注：z为列，x为行（y = 0）
function TerrainManager.BlockIDTurnPosition(id)
    local idPos = Vector3.New(-100,0,-100) --初始到视线外
    if id >= 1 and id<= (TerrainRange.x * TerrainRange.y) then
        idPos.z = id % TerrainRange.x - 1
        idPos.x = id / TerrainRange.x
    end
    return idPos
end
--[[过时
--通过位置ID转化为地块区域坐标
--注：z为列，x为行
function TerrainManager.PositionTurnBlockCollectionID(pos)
    local tempPosition = Vector2.New( 0, 0)
    tempPosition.x = math.ceil(pos.z / blockRange.x)
    tempPosition.y = math.ceil(pos.x / blockRange.y)
    return tempPosition
end
--]]
--通过BlcokID转化为BlockCollectionID
function TerrainManager.BlockIDTurnCollectionID(blockID)
    local X = math.floor((blockID %  blockRange.x)  / math.ceil(TerrainRange.x /blockRange.x) )
    local Y = math.ceil((blockID / TerrainRange.x) / blockRange.y)
    return X +  Y
end

--通过BlockCollectionID转化为BlcokID
function TerrainManager.CollectionIDTurnBlockID(collectionID)
    local X = math.floor( collectionID / math.ceil(TerrainRange.x /blockRange.x) ) * blockRange.y * TerrainRange.x
    local Y = (collectionID % math.ceil(TerrainRange.x /blockRange.x)) * blockRange.x
    return X +  Y
end

--创建临时修建建筑物
local function CreateConstructBuildSuccess(go,table)
    --判空
    if #table <2 then
        return;
    end
    DataManager.TempDatas.constructID  = table[1]
    ct.OpenCtrl('ConstructSwitchCtrl')
    DataManager.TempDatas.constructObj = go
    DataManager.TempDatas.constructObj.transform.position = table[2]
    TerrainManager.MoveTempConstructObj()
end

--取消建筑的修建
function TerrainManager.AbolishConstructBuild()
    --干掉临时GameObject
    if DataManager.TempDatas.constructObj ~= nil then
        destroy(DataManager.TempDatas.constructObj)
        DataManager.TempDatas.constructObj = nil
        DataManager.TempDatas.constructID = nil
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
    local tempData = nil-- DataManager.QueryBaseBuildData(TerrainManager.PositionTurnBlockID(tempPos))
    if nil ~= tempData then
        local a  = tempData.Data
    end
end


UnitTest.TestBlockStart()

UnitTest.Exec("Allen_w9_SendPosToServer", "test_TerrainManager_self",  function ()
    ct.log("Allen_w9_SendPosToServer","[test_TerrainManager_self] ...............")
    Event.AddListener("c_SendPosToServer_self", function (obj)
        ReceiveArchitectureDatas(tempBuilds)
    end)
end)

UnitTest.Exec("Allen_w9", "test_TerrainManagerRefresh",  function ()
    Event.AddListener("c_CameraMove", function (obj)
        TerrainManager.Refresh(Vector3.New(0,0,0))
    end)
end)

UnitTest.TestBlockEnd()