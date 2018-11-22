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
    local buildingId = table[1]
    local Vec3 = table[2]
    go.transform.position = Vec3
    --CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingId]["LuaRoute"])
    if TerrainManager.TerrainRoot == nil  then
        TerrainManager.TerrainRoot = UnityEngine.GameObject.Find("Terrain").transform
    end
    go.transform:SetParent(TerrainManager.TerrainRoot)
    if PlayerBuildingBaseData[buildingId]["LuaRoute"] ~= nil then
        ArchitectureStack[buildingId] = CityLuaUtil.AddLuaComponent(go,PlayerBuildingBaseData[buildingId]["LuaRoute"])
    end
    --将建筑GameObject保存到对应Model中
    local  tempBaseBuildModel=DataManager.GetBaseBuildDataByID(TerrainManager.PositionTurnBlockID(Vec3))
    if tempBaseBuildModel ~= nil then
        tempBaseBuildModel.go = go
    end
end

--根据建筑数据生成GameObject
--参数：
--  datas：数据table集合( 一定包含数据有：坐标==》  x,y  ,建筑类型id==》 buildId)
function  TerrainManager.ReceiveArchitectureDatas(datas)
    for key, value in pairs(datas) do
        local isCreate = DataManager.RefreshBaseBuildData(value)
        --判断是否需要创建建筑
        if isCreate then
            buildMgr:CreateBuild(PlayerBuildingBaseData[value.buildingId]["prefabRoute"],CreateSuccess,{value.buildingId, Vector3.New(value.x,0,value.y)})
        end
    end
end

--应该每帧调用传camera的位置
function TerrainManager.Refresh(pos)
    local tempBlockID = TerrainManager.PositionTurnBlockID(pos)
    local tempCollectionID = TerrainManager.BlockIDTurnCollectionID(tempBlockID)
    --ct.log("Allen_w9","tempCollectionID===============>"..tempCollectionID)
    if CameraCollectionID ~= tempCollectionID then
        CameraCollectionID = tempCollectionID
        --向服务器发送新的所在地块ID
        local msgId = pbl.enum("gscode.OpCode", "move")
        local lMsg = TerrainManager.BlockIDTurnCollectionGridIndex(tempBlockID)
        local pMsg = assert(pbl.encode("gs.AddBuilding", lMsg))
        CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)

        UnitTest.Exec_now("Allen_w9_SendPosToServer", "c_SendPosToServer_self",self)
        UnitTest.Exec_now("abel_w13_SceneOpt", "c_abel_w13_SceneOpt",self)
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
    if blockID == nil then
        return -1
    end
    local X = math.floor((blockID %  blockRange.x)  / math.ceil(TerrainRange.x /blockRange.x) )
    local Y = math.ceil((blockID / TerrainRange.x) / blockRange.y)
    return X +  Y
end

--通过BlcokID转化为BlockCollection坐标
function TerrainManager.BlockIDTurnCollectionGridIndex(blockID)
    if blockID == nil then
        return{ x = -1,y = -1}
    end
    local X = math.floor((blockID %  blockRange.x))
    local Y = math.ceil((blockID / TerrainRange.x) / blockRange.y)
    return{ x = X,y = Y}
end

--通过BlockCollectionID转化为BlcokID
function TerrainManager.CollectionIDTurnBlockID(collectionID)
    local X = math.floor( collectionID / math.ceil(TerrainRange.x /blockRange.x) ) * blockRange.y * TerrainRange.x
    local Y = (collectionID % math.ceil(TerrainRange.x /blockRange.x)) * blockRange.x
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