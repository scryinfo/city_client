--Allen
--地图管理器
--功能：
--      1、商业建筑实例类 堆栈
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


local function CreateSuccess(go,table)
    local buildId = table[1]
    local Vec3 = table[2]
    CityLuaUtil.AddLuaComponent(go,BuildingConfig[buildId].LuaRoute)
    go.transform.position = Vec3
    ArchitectureStack[buildId] = CityLuaUtil.AddLuaComponent(go,BuildingConfig[buildId].LuaRoute)
end

--接受基础地块数据
local function ReceiveArchitectureDatas(datas)
    for key, value in pairs(datas) do
        DataManager.RefreshBaseBuildData(value)
        buildMgr:CreateBuild(BuildingConfig[value.buildId].prefabRoute,CreateSuccess,{value.buildId,TerrainManager.BlockIDTurnPosition(value.id)})
    end
end

--应该每帧调用传camera的位置
function TerrainManager.Refresh(pos)
    local tempCollectionID = TerrainManager.BlockIDTurnCollectionID(TerrainManager.PositionTurnBlockID(pos))
    ct.log("Allen_w9","tempCollectionID===============>"..tempCollectionID)
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



UnitTest.TestBlockStart()

UnitTest.Exec("Allen_w9_SendPosToServer", "test_TerrainManager_self",  function ()
    ct.log("Allen_w9_SendPosToServer","[test_TerrainManager_self] ...............")
    Event.AddListener("c_SendPosToServer_self", function (obj)
        local tempDatas = {
            [1] = {
                id = 2,
                buildId =2
            },
            [2] = {
                id = 3007,
                buildId =4
            },
            [3] = {
                id = 8004,
                buildId = 3
            }
        }
        ReceiveArchitectureDatas(tempDatas)
    end)
end)

UnitTest.Exec("Allen_w9", "test_TerrainManagerRefresh",  function ()
    Event.AddListener("c_CameraMove", function (obj)
        TerrainManager.Refresh(Vector3.New(0,0,0))
    end)
end)

UnitTest.TestBlockEnd()