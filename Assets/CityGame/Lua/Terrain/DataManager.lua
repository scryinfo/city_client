DataManager = {}
--数据管理器
--1.BuildDataStack 建筑信息（根据相机位置刷新）
--  a.TerrainDatas 地形数据（key = BlockID , value = typeID） 与服务器做地形版本校验
--          ==>> 本地存储为分地块集合的Table数据文件，登录时与服务器校验版本（分包更新）
--  b.BlockDatas 原子地块的基本信息（key = BlockID ，value = nodeID）没有建筑覆盖为 -1  有建筑覆盖则记录节点ID
--          ==>> 与c的地块一致，当新BlockCollectionDatas创建时被创建，当新BlockCollectionDatas刷新时改写内部数据，当BlockCollectionDatas消亡时数据清除
--  c.BaseBuildDatas 商业建筑的基础数据（key = NodeID ，value = Model） 具体Model可根据建筑类型重写BaseBuildModel
--          ==>> 根据相机位置刷新，从服务器同步一整个BlockCollectionDatas，实时接收服务器数据刷新内部数据，当相机移走时数据清除
--  d.DetailBuildDatas 商业建筑的详细数据（key = NodeID ，value = Model ）具体Model可根据建筑类型作为参数传入
--          ==>> 打开建筑UI时，判断是否自己建筑，是->转到2c读取信息，否->从服务器读取数据并存储，退出界面时数据清除（后期可改为一定大小内存缓存机制）
--        BuildDataStack 包含：BlockDatas(地块建筑覆盖信息)/GroundDatas（地块所属人信息）/RoteDatas（道路信息）/BaseBuildDatas（商业建筑基础信息）
--

--2.用户信息（登录时同步服务器，实时同步）
--  a.用户基础数据（table={ userID , Name ， Sex ，Avatar ， CompanyID ，CompanyName }）
--  b.用户自己所拥有的地块集合（key = BlockID ，value = nodeID）可修建为 -1  有建筑覆盖则记录节点ID
--  c.用户自己所拥有的商业建筑集合（key = NodeID， value = model ）
--  d.用户公司歌物品发明情况/研究等级
--3.临时数据
--  a.修建建筑时的临时数据（包括展示用GameObject集合，修建状态IsConstructing）
--          ==>> 打开修建界面时初始化，关闭时清空
--4.系统数据
--  a.当前操作状态（Enum TouchState{ NormalState = 0，//正常状态（可拖拽点击状态）   ConstructState = 1，//修建状态   UIState = 2，//UI查看状态   }）
--          ==》登录时初始化，用于触摸操作的控制判断
--  b.服务器时间戳
--          ==>> 登录时同步，断线重连刷新一次
--  c.地形大小，地块大小
--          ==>> 登录时初始化（考虑与服务器同步的需求）
--  c.设置中数据
--          ==>> 游戏开始时读取playerprefs，改变时写入playerprefs
--  e.拍卖地块信息


-- 数据集合
local BuildDataStack = {}      --建筑信息堆栈
local PersonDataStack = {}      --个人信息堆栈
local SystemDatas = {}          --系统信息集合
local ModelNetMsgStack = {}

local TerrainRangeSize = 1000
local CollectionRangeSize = 20
local RoadRootObj
--local HeadId                  --头像的ID
local pbl = pbl


local Math_Floor = math.floor


DataManager.TempDatas ={ constructObj = nil, constructID = nil, constructPosID = nil}

---------------------------------------------------------------------------------- 建筑信息--------------------------------------------------------------------------------
-------------------------------系统建筑数据--------------------------------
function DataManager.AddSystemBuild(collectionID,blockID,poolName,go)
    if BuildDataStack[collectionID].SystemBuildDatas == nil then
        BuildDataStack[collectionID].SystemBuildDatas = {}
    end
    BuildDataStack[collectionID].SystemBuildDatas[blockID] = {
        ["poolName"] = poolName,
        ["gameObject"] = go,
    }
end

function DataManager.RemoveSystemBuild(collectionID)
    local tempSystemBuild =  BuildDataStack[collectionID].SystemBuildDatas
    if tempSystemBuild == nil then
        return
    end
    for blockID,tempTable in pairs(tempSystemBuild) do
        MapObjectsManager.RecyclingGameObjectToPool(tempTable.poolName,tempTable.gameObject)
    end
    BuildDataStack[collectionID].SystemBuildDatas = nil
end
-------------------------------基础地块生成--------------------------------
--添加系统土地到数据管理
function DataManager.AddSystemTerrain(collectionID,blockID,poolName,go)
    if BuildDataStack[collectionID].SystemTerrainDatas == nil then
        BuildDataStack[collectionID].SystemTerrainDatas = {}
    end
    BuildDataStack[collectionID].SystemTerrainDatas[blockID] = {
        ["poolName"] = poolName,
        ["gameObject"] = go,
    }
end

--删除一整块系统土地
function DataManager.RemoveSystemTerrainAllCollection(collectionID)
    local tempSystemBuild =  BuildDataStack[collectionID].SystemTerrainDatas
    if tempSystemBuild == nil then
        return
    end
    for blockID,tempTable in pairs(tempSystemBuild) do
        MapObjectsManager.RecyclingGameObjectToPool(tempTable.poolName,tempTable.gameObject)
    end
    BuildDataStack[collectionID].SystemTerrainDatas = nil
end

--删除某一个系统土地
function DataManager.RemoveSystemTerrainByBlock(blockID)
    local collectionID = TerrainManager.BlockIDTurnCollectionID(blockID)
    if BuildDataStack ~= nil and BuildDataStack[collectionID] ~= nil and BuildDataStack[collectionID].SystemTerrainDatas~=nil then
        local tempTable = BuildDataStack[collectionID].SystemTerrainDatas[blockID]
        if tempTable ~= nil and tempTable.gameObject ~= nil and  tempTable.poolName ~= nil then
            MapObjectsManager.RecyclingGameObjectToPool(tempTable.poolName,tempTable.gameObject)
            BuildDataStack[collectionID].SystemTerrainDatas[blockID] = nil
        end
    end
end

-------------------------------系统河流数据--------------------------------

function DataManager.AddSystemRiver(collectionID,blockID,poolName,go)
    if BuildDataStack[collectionID].SystemRiverDatas == nil then
        BuildDataStack[collectionID].SystemRiverDatas = {}
    end
    BuildDataStack[collectionID].SystemRiverDatas[blockID] = {
        ["poolName"] = poolName,
        ["gameObject"] = go,
    }
end

function DataManager.RemoveSystemRiver(collectionID)
    local tempSystemBuild =  BuildDataStack[collectionID].SystemRiverDatas
    if tempSystemBuild == nil then
        return
    end
    for blockID,tempTable in pairs(tempSystemBuild) do
        MapObjectsManager.RecyclingGameObjectToPool(tempTable.poolName,tempTable.gameObject)
    end
    BuildDataStack[collectionID].SystemRiverDatas = nil
end

--------------------------------------------------------------------------

--生成系统土地
local function InitCollectionSystemTerrain(tempCollectionID)
    local tempBlockData =  BuildDataStack[tempCollectionID].BlockDatas
    for blockId, value in pairs(tempBlockData) do
        if value == -1 then
            local go = MapObjectsManager.GetGameObjectByPool(PlayerBuildingBaseData[4000000].poolName)
            go.transform.position = TerrainManager.BlockIDTurnPosition(blockId)
            DataManager.AddSystemTerrain(tempCollectionID,blockId,PlayerBuildingBaseData[4000000].poolName,go)
        end
    end
end

--生成系统河流
local function InitSystemRiverGameObject(tempCollectionID)
    local systemMapTemp = RiversConfig[tempCollectionID]
    if systemMapTemp ~= nil then
        for blockId, PlayerDataID in pairs(systemMapTemp) do
            local go = MapObjectsManager.GetGameObjectByPool(PlayerBuildingBaseData[PlayerDataID].poolName)
            go.transform.position = TerrainManager.BlockIDTurnPosition(blockId)
            DataManager.AddSystemRiver(tempCollectionID,blockId,PlayerBuildingBaseData[PlayerDataID].poolName,go)
        end
    end
end

-------------------------------原子地块数据--------------------------------

--初始化寻路基础数据
--基础均为0
--系统道路额外处理一波
--系统建筑/建筑为自身数据
--道路为道路值
--寻路基础数据左上1 右上2 左下4 右下8
local function CreatePathfindingBaseData(tempCollectionID)
    local TempTable =  {}
    local startBlockID = TerrainManager.CollectionIDTurnBlockID(tempCollectionID)
    local idList =  DataManager.CaculationTerrainRangeBlock(startBlockID,CollectionRangeSize )
    for key, value in pairs(idList) do
        if TempTable[value] == nil then
            TempTable[value] = 0
        end
    end
    BuildDataStack[tempCollectionID].PathDatas = TempTable
    collectgarbage("collect")
end

--赋值
local function AddPathValue(tempBlockID,Value)
    local tempCollectionID = TerrainManager.BlockIDTurnCollectionID(tempBlockID)
    if BuildDataStack[tempCollectionID] == nil then
        BuildDataStack[tempCollectionID] = {}
    end
    if BuildDataStack[tempCollectionID].PathDatas == nil then
        CreatePathfindingBaseData(tempCollectionID)
    end
    BuildDataStack[tempCollectionID].PathDatas[tempBlockID] = Value
end

function DataManager.GetPathDatas(tempCollectionID)
    if BuildDataStack[tempCollectionID] ~= nil and BuildDataStack[tempCollectionID].PathDatas ~= nil  then
        return BuildDataStack[tempCollectionID].PathDatas
    end
    return nil
end

function DataManager.GetPathDataByBlockID(tempBlockID)
    local tempCollectionID = TerrainManager.BlockIDTurnCollectionID(tempBlockID)
    local tempData = DataManager.GetPathDatas(tempCollectionID)
    if tempData ~= nil then
        return tempData[tempBlockID]
    end
    return nil
end

--计算范围内建筑的路径值
function DataManager.RefreshPathRangeBlock(startBlockID,size)
    if size <= 0 then
        return
    elseif size == 1 then
        AddPathValue(startBlockID,15)
    elseif size >= 2 then
        local tempSize = (size - 1)
        AddPathValue(startBlockID,7)
        AddPathValue(startBlockID + tempSize,11)
        AddPathValue(startBlockID + TerrainRangeSize * tempSize,13)
        AddPathValue(startBlockID + TerrainRangeSize * tempSize + tempSize,14)
        if size >= 3 then
            for i = 1, tempSize - 1, 1  do
                AddPathValue(startBlockID + i,3)
                AddPathValue(startBlockID + tempSize + TerrainRangeSize * i,10)
                AddPathValue(startBlockID + TerrainRangeSize * i,5)
                AddPathValue(startBlockID + TerrainRangeSize * tempSize + i,12)
            end
        end
    end
end

--删除建筑的路径值
function DataManager.RemovePathRangeBlock(startBlockID,size)
    local idList =  DataManager.CaculationTerrainRangeBlock(startBlockID,size)
    for key, value in pairs(idList) do
        AddPathValue(value,0)
    end
end

local function RefreshAllMapBuild(tempCollectionID)
    ---生成寻路数据------------
    CreatePathfindingBaseData(tempCollectionID)
    ---生成系统土地------------
    InitCollectionSystemTerrain(tempCollectionID)
    ---生成系统建筑------------
    TerrainManager.CreateSystemBuildingGameObjects(tempCollectionID)
    ---生成河流
    InitSystemRiverGameObject(tempCollectionID)
    ---刷新一遍道路
    DataManager.RefreshWaysByCollectionID( tempCollectionID)
end


--功能
--  创建一个新的原子地块集合，并将内部非系统建筑值置为 -1
--参数
--  tempCollectionID: 所属地块集合ID
local function CreateBlockDataTable(tempCollectionID)
    --创建一个新的原子地块集合
    local TempTable =  {}
    --将系统建筑写入其中
    local systemMapTemp = SystemMapConfig[tempCollectionID]
    if systemMapTemp~= nil then
        for id, value in pairs(systemMapTemp) do
            local buildList =  DataManager.CaculationTerrainRangeBlock(id,PlayerBuildingBaseData[value].x)
            for key, value in pairs(buildList) do
                TempTable[value] = id
            end
        end
    end
    --将河流建筑写入其中（写0是为了不生成土地，但是可以生成道路）
    local systemRiverTemp = RiversConfig[tempCollectionID]
    if systemRiverTemp ~= nil then
        for id, value in pairs(systemRiverTemp) do
            local buildList =  DataManager.CaculationTerrainRangeBlock(id,PlayerBuildingBaseData[value].x)
            for key, blockid in pairs(buildList) do
                TempTable[blockid] = PlayerBuildingBaseData[value].BlockDatasValue
            end
        end
    end
    local startBlockID = TerrainManager.CollectionIDTurnBlockID(tempCollectionID)
    --将内部所有数据置为 -1
    local idList =  DataManager.CaculationTerrainRangeBlock(startBlockID,CollectionRangeSize )
    for key, value in pairs(idList) do
        if TempTable[value] == nil then
            TempTable[value] = -1
        end
    end
    BuildDataStack[tempCollectionID].BlockDatas = TempTable
    RefreshAllMapBuild(tempCollectionID)
    --创建路径基础数据
    CreatePathfindingBaseData(tempCollectionID)
    collectgarbage("collect")
end

function DataManager.InitBuildDatas(tempCollectionID)
    if BuildDataStack[tempCollectionID] == nil then
        BuildDataStack[tempCollectionID] = {}
    end
    if BuildDataStack[tempCollectionID].BlockDatas == nil then
        CreateBlockDataTable(tempCollectionID)
    else
        if BuildDataStack[tempCollectionID].SystemTerrainDatas == nil then
            RefreshAllMapBuild(tempCollectionID)
        end
    end
end

--功能
--  刷新某个原子地块的基本信息
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RefreshBlockData(blockID,nodeID)
    if blockID == nil then
        return
    end
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if nodeID == nil then
        nodeID = -1
    end
    DataManager.InitBuildDatas(collectionID)
    BuildDataStack[collectionID].BlockDatas[blockID] = nodeID
end

--刷新原子地块集合的基本信息
--nodeID： 根节点ID
--nodeSize： 根节点范围
--nodeSize： 根节点值
function DataManager.RefreshBlockDataWhenNodeChange(nodeID,nodeSize,nodeValue)
    local idList =  DataManager.CaculationTerrainRangeBlock(nodeID,nodeSize)
    for key, value in pairs(idList) do
        DataManager.RefreshBlockData(value,nodeValue)
    end
end


--功能
--  返回一块范围内的blockID集合
--参数
--  startBlockID: 起始节点blockID（左上角）
--  rangeSize：范围大小
--返回
--  范围内的blockID集合（table数组）
function DataManager.CaculationTerrainRangeBlock(startBlockID,rangeSize)
    local idList= {}
    for i = startBlockID, (startBlockID + TerrainRangeSize * (rangeSize - 1)),TerrainRangeSize  do
        for tempkey = i, (i + rangeSize - 1) do
            table.insert(idList, tempkey)
        end
    end
    return idList
end

--获取block地块所属建筑的根节点ID
--如果没有建筑覆盖，值为-1
function DataManager.GetBlockDataByID(blockID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if BuildDataStack[collectionID] ~= nil and BuildDataStack[collectionID].BlockDatas ~= nil  then
        return BuildDataStack[collectionID].BlockDatas[blockID]
    else
        return nil
    end
end

--返回 GroundInfo数据
--如果没有GroundInfo数据，返回nil
function DataManager.GetGroundDataByID(blockID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if BuildDataStack[collectionID] ~= nil and BuildDataStack[collectionID].GroundDatas ~= nil then
        return BuildDataStack[collectionID].GroundDatas[blockID]
    else
        return nil
    end
end

--根据大地块获取建筑基础信息
--如果没有BaseBuildDatas，返回nil
function DataManager.GetBuildingBaseByCollectionID(collectionID)
    if BuildDataStack ~= nil and collectionID ~= nil and BuildDataStack[collectionID] ~= nil and BuildDataStack[collectionID].BaseBuildDatas ~= nil then
        return BuildDataStack[collectionID].BaseBuildDatas
    else
        return nil
    end
end

--通过建筑唯一ID获取详情
--没有则返回nil
function DataManager.GetSelfBuildingDetailByBlockId(buildingId)
    if PersonDataStack.m_buysBuilding ~= nil then
        for type, value in pairs(PersonDataStack.m_buysBuilding) do
            for key, data in pairs(value) do
                if data ~= nil and data.info ~= nil and data.info.id ~= nil and buildingId == data.info.id then
                    return PersonDataStack.m_buysBuilding[type][key]
                end
            end
        end
    end
    return nil
end

-------------------------------------------------------------------------------------道路数据集合--------------------------------
--功能
--  依据BlockDatas创建道路的基础数据，管理GameObject
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RefreshWaysByCollectionID(tempCollectionID)
    if BuildDataStack[tempCollectionID] == nil then
        BuildDataStack[tempCollectionID] = {}
    end
    if BuildDataStack[tempCollectionID].BlockDatas == nil then
        CreateBlockDataTable(tempCollectionID)
    end
    if BuildDataStack[tempCollectionID].RoteDatas == nil then
        BuildDataStack[tempCollectionID].RoteDatas = {}
    end
    for itemBlockID, itemNodeID in pairs(BuildDataStack[tempCollectionID].BlockDatas) do
        local ThisRoteDatas = BuildDataStack[tempCollectionID].RoteDatas
        local ThisPathNums = BuildDataStack[tempCollectionID].PathDatas
        while true do
            if itemNodeID <= 0 then
                local roadNum = DataManager.CalculateRoadNum(tempCollectionID,itemBlockID)
                --如果有道路数据
                if roadNum > 0 and roadNum < #RoadNumConfig  then
                    if not ThisRoteDatas[itemBlockID] then
                        ThisRoteDatas[itemBlockID] ={}
                    else
                        if ThisRoteDatas[itemBlockID].roadNum ==  roadNum then
                            break
                        else
                            --删除之前的道路Obj
                            MapObjectsManager.RecyclingGameObjectToPool(RoadPrefabConfig[RoadNumConfig[ThisRoteDatas[itemBlockID].roadNum]].poolName,ThisRoteDatas[itemBlockID].roadObj)
                            ThisRoteDatas[itemBlockID].roadObj = nil
                        end
                    end
                    ThisRoteDatas[itemBlockID].roadNum = roadNum
                    --TODO:
                    ThisPathNums[itemBlockID] = RoadPrefabConfig[RoadNumConfig[roadNum]].pathNum
                    local go = MapObjectsManager.GetGameObjectByPool(RoadPrefabConfig[RoadNumConfig[roadNum]].poolName)
                    if nil ~= RoadRootObj then
                        go.transform:SetParent(RoadRootObj.transform)
                    end
                    --add height
                    local Vec = TerrainManager.BlockIDTurnPosition(itemBlockID)
                    Vec.y = Vec.y + 0.02
                    go.transform.position = Vec
                    ThisRoteDatas[itemBlockID].roadObj = go
                    --如果没有道路数据，但原先有道路记录，则清除
                elseif  roadNum == 0 and ThisRoteDatas[itemBlockID] ~= nil and ThisRoteDatas[itemBlockID].roadObj ~= nil and ThisRoteDatas[itemBlockID].roadNum ~= nil then
                    MapObjectsManager.RecyclingGameObjectToPool(RoadPrefabConfig[RoadNumConfig[ThisRoteDatas[itemBlockID].roadNum]].poolName,ThisRoteDatas[itemBlockID].roadObj)
                    ThisRoteDatas[itemBlockID] = nil
                    --TODO:
                    ThisPathNums[itemBlockID] = 0
                end
            else
                if nil ~= ThisRoteDatas[itemBlockID] and ThisRoteDatas[itemBlockID].roadObj ~= nil and ThisRoteDatas[itemBlockID].roadNum ~= nil  then
                    --删除之前的道路Obj
                    MapObjectsManager.RecyclingGameObjectToPool(RoadPrefabConfig[RoadNumConfig[ThisRoteDatas[itemBlockID].roadNum]].poolName,ThisRoteDatas[itemBlockID].roadObj)
                    ThisRoteDatas[itemBlockID] = nil
                    --TODO:
                    ThisPathNums[itemBlockID] = 0
                end
            end
            break
        end
    end
end

--功能
-- 移除道路的基础数据，管理GameObject
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RemoveWaysByCollectionID(tempCollectionID)
    if BuildDataStack[tempCollectionID] == nil or BuildDataStack[tempCollectionID].RoteDatas == nil then
        return
    end
    for key, value in pairs(BuildDataStack[tempCollectionID].RoteDatas) do
        MapObjectsManager.RecyclingGameObjectToPool(RoadPrefabConfig[RoadNumConfig[BuildDataStack[tempCollectionID].RoteDatas[key].roadNum]].poolName,BuildDataStack[tempCollectionID].RoteDatas[key].roadObj)
        BuildDataStack[tempCollectionID].RoteDatas[key] = nil
    end
end

local RoadAroundNumber = {
    FrontUpperItem = { Num = 1 },   --正上方
    FrontBelowItem = { Num = 4 },   --正下方
    LeftUpperItem = { Num = 128 },    --左上方
    LeftMiddleItem = { Num = 8 },   --正左方
    LeftBelowItem = { Num = 64 },    --左下方
    RightUpperItem ={ Num = 16 },    --右上方
    RightMiddleItem = { Num = 2 },  --正右方
    RightBelowItem = { Num = 32 },   --右下方
}
--功能
-- 计算道路number
function DataManager.CalculateRoadNum(tempCollectionID,roadBlockID)
    local roadNum = 0
    for key, value in pairs(RoadAroundNumber) do
        value.ID = nil
    end
    --边缘判定（上下不判定的原因是因为计算值的时候会被排除）
    if  roadBlockID % TerrainRangeSize ~= 0 then    --不靠地图右边边界--->右边一列
        RoadAroundNumber.RightUpperItem.ID = roadBlockID - TerrainRangeSize + 1
        RoadAroundNumber.RightMiddleItem.ID = roadBlockID + 1
        RoadAroundNumber.RightBelowItem.ID = roadBlockID + TerrainRangeSize + 1
    end
    if roadBlockID % TerrainRangeSize ~= 1 then     --不靠地图左边边界--->计算左边一列
        RoadAroundNumber.LeftUpperItem.ID = roadBlockID - TerrainRangeSize - 1
        RoadAroundNumber.LeftMiddleItem.ID = roadBlockID - 1
        RoadAroundNumber.LeftBelowItem.ID = roadBlockID + TerrainRangeSize - 1
    end
    RoadAroundNumber.FrontUpperItem.ID = roadBlockID - TerrainRangeSize
    RoadAroundNumber.FrontBelowItem.ID = roadBlockID + TerrainRangeSize
    --计算中间一列
    local topItemID = roadBlockID - TerrainRangeSize
    --如果存在  那么计算这个值
    for key, value in pairs(RoadAroundNumber) do
        if value.ID and value.ID > 0 and value.ID < TerrainRangeSize*TerrainRangeSize then
            if BuildDataStack[tempCollectionID].BlockDatas[value.ID] then
                if BuildDataStack[tempCollectionID].BlockDatas[value.ID] > 0 then
                    roadNum  = roadNum + value.Num
                end
            else
                local ItemCollectionID =  TerrainManager.BlockIDTurnCollectionID(value.ID)
                if BuildDataStack[ItemCollectionID] ~= nil and BuildDataStack[ItemCollectionID].BlockDatas ~= nil and BuildDataStack[ItemCollectionID].BlockDatas[value.ID] and BuildDataStack[ItemCollectionID].BlockDatas[value.ID] > 0  then
                    roadNum  = roadNum + value.Num
                end
            end
        end
    end
    return roadNum
end

-------------------------------商业建筑基础数据集合--------------------------------
--功能
--  刷新商业建筑集合的基础数据--
--参数
--  data:某个建筑基础数据（protobuf）
function DataManager.RefreshBaseBuildData(data)
    --数据判空处理
    local blockID
   --[[ if data.id ~= nil then
        blockID = data.id
    else--]]
    if data.x ~= nil and data.y ~= nil then
        blockID = TerrainManager.GridIndexTurnBlockID(data)
        data.posID = blockID
    else
        return
    end
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    --判断地块是否已经初始化
    DataManager.InitBuildDatas(collectionID)
    --检查数据初始化
    if BuildDataStack[collectionID].BaseBuildDatas == nil then
        BuildDataStack[collectionID].BaseBuildDatas = {}
    end
    if BuildDataStack[collectionID].BaseBuildDatas[blockID] then
        BuildDataStack[collectionID].BaseBuildDatas[blockID]:Refresh(data)
        BuildDataStack[collectionID].BaseBuildDatas[blockID]:CheckBubbleState()
        return false
    else
        --具体Model可根据建筑类型typeID重写BaseBuildModel
        BuildDataStack[collectionID].BaseBuildDatas[blockID] = BaseBuildModel:new(data)
        --判断是否自己地块，地块是否是自己挂出的租售信息
        if PersonDataStack.m_groundInfos ~= nil then
            local tempInfos = DataManager.CaculationTerrainRangeBlock(data.posID, PlayerBuildingBaseData[data.mId].x)
            for key, blockID in pairs(tempInfos) do
                local value = PersonDataStack.m_groundInfos[blockID]
                if value ~= nil then
                    if value.sell ~= nil then
                        --todo:向服务器发送取消出售的信息
                        DataManager.m_ReqCancelSellGround({[1] = {x = value.x, y = value.y}})
                        break
                    elseif value.rent ~= nil  and value.rent.renterId == nil then
                        --TODO:向服务器发送取消出租的信息
                        DataManager.m_ReqCancelRentGround({[1] = {x = value.x, y = value.y}})
                        break
                    end
                end
            end
        end
        return true
    end
end

--功能
--  删除某个地块集合数据BuildDataStack
--  相机移动时触发
--BuildDataStack 包含：BlockDatas(地块建筑覆盖信息)/GroundDatas（地块所属人信息）/RoteDatas（道路信息）/BaseBuildDatas（商业建筑基础信息）
--参数
--  tempCollectionID：删除地块的ID
function DataManager.RemoveCollectionDatasByCollectionID(tempCollectionID)
    --判断是否不需要执行数据清理
    if tempCollectionID == nil or BuildDataStack[tempCollectionID] == nil then
        return
    end
    --删除所有地块建筑覆盖信息（BlockDatas）
    if BuildDataStack[tempCollectionID].BlockDatas ~= nil then
        local isClearBlock = true
        --计算需要删除的地块里面有没有跨地块的建筑，如果有-->BaseBlockData不删除
        for key, value in pairs(BuildDataStack[tempCollectionID].BlockDatas) do
            --判断是否有建筑跨地块
            if value > 0 and BuildDataStack[tempCollectionID].BlockDatas[value] == nil then
                --需要判断该建筑是否在AOI范围内
                local attributeCollectionID = TerrainManager.BlockIDTurnCollectionID(value)
                if TerrainManager.IsBelongToCameraCollectionIDAOIList(attributeCollectionID)  then
                    isClearBlock = false
                    break
                end
            end
        end
        if isClearBlock then
            BuildDataStack[tempCollectionID].BlockDatas = nil
        end
    end
    --删除所有道路信息数据（RoteDatas）
    DataManager.RemoveWaysByCollectionID(tempCollectionID)
    --删除所有系统建筑数据
    DataManager.RemoveSystemBuild(tempCollectionID)
    --删除所有系统道路数据
    DataManager.RemoveSystemTerrainAllCollection(tempCollectionID)
    --删除所有系统河流数据
    DataManager.RemoveSystemRiver(tempCollectionID)
    --删除所有地块信息BaseGroundModel（GroundDatas）
    if BuildDataStack[tempCollectionID].GroundDatas ~= nil  then
        for key, value in pairs(BuildDataStack[tempCollectionID].GroundDatas) do
            value:Close()
        end
        BuildDataStack[tempCollectionID].GroundDatas = nil
    end
    --删除所有基础数据BaseBuildModel（BaseBuildDatas）
    if BuildDataStack[tempCollectionID].BaseBuildDatas ~= nil  then
        for key, value in pairs(BuildDataStack[tempCollectionID].BaseBuildDatas) do
            value:Close()
        end
        BuildDataStack[tempCollectionID].BaseBuildDatas = nil
    end
    collectgarbage("collect")
end

--获取建筑基础数据
--建筑根节点的唯一ID
function DataManager.GetBaseBuildDataByID(blockID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if BuildDataStack[collectionID] ~= nil and BuildDataStack[collectionID].BaseBuildDatas ~= nil then
        return BuildDataStack[collectionID].BaseBuildDatas[blockID]
    else
        return nil
    end
end

---------------------------------------------------------------------------------- 建筑详情数据---------------------------------------------------------------------------------
ModelBase = class('ModelBase')

function ModelBase:initialize(insId)
    self.insId = insId
end

--功能，确认在本地有对应DetailModel打开
--参数：
--modelclass：详情数据类
--insId: 详情数据唯一ID
function DataManager.OpenDetailModel(modelclass,insId,...)
    --如果已有详情建筑信息
    if not DataManager.GetDetailModelByID(insId) then
        DataManager.AddNewDetailModel(modelclass:new(insId,...),insId)
    end
end

--添加新DetailModel到管理器中
function DataManager.AddNewDetailModel(model,insId)
    if not BuildDataStack.DetailModelStack then
        BuildDataStack.DetailModelStack = {}
    end
    --如果数据冲突
    if BuildDataStack.DetailModelStack[insId] then
        BuildDataStack.DetailModelStack[insId] = nil
    end
    BuildDataStack.DetailModelStack[insId] = model
end

--删除DetailModel通过实例ID
function DataManager.CloseDetailModel(insId)
    if nil ~= BuildDataStack.DetailModelStack and nil ~= BuildDataStack.DetailModelStack[insId]  then
        BuildDataStack.DetailModelStack[insId]:Close()
        BuildDataStack.DetailModelStack[insId] = nil
    end
end

--删除所有DetailModels
function DataManager.ClearAllDetailModels()
    if nil ~= BuildDataStack.DetailModelStack then
        for key, value in pairs(BuildDataStack.DetailModelStack) do
            value:Close()
        end
    end
end

--获取DetailModel到管理器中
function DataManager.GetDetailModelByID(insId)
    if BuildDataStack ~=nil and  BuildDataStack.DetailModelStack ~= nil then
        return BuildDataStack.DetailModelStack[insId]
    end
    return nil
end

--远程调用DetailModel的无返回值方法
--参数：
--1：实例ID
--2：model中self方法名
function DataManager.DetailModelRpcNoRet(insId,modelMethord,...)
    --参数验证
    if BuildDataStack.DetailModelStack == nil or insId == nil or modelMethord == nil then
        return
    end
    local tempDetailModel = BuildDataStack.DetailModelStack[insId]
    if tempDetailModel ~= nil and tempDetailModel[modelMethord] ~= nil then
        tempDetailModel[modelMethord](tempDetailModel,...)
    end
end


--远程调用DetailModel的有返回值方法
--参数：
--1：实例ID
--2：model中self方法名
--3：回调函数，参数为2中方法的返回值
--4：... model中方法参数
function DataManager.DetailModelRpc(insId,modelMethord,callBackMethord,...)
    --参数验证
    if BuildDataStack.DetailModelStack == nil or insId == nil or modelMethord == nil or callBackMethord == nil then
        return
    end
    local tempDetailModel = BuildDataStack.DetailModelStack[insId]
    if tempDetailModel ~= nil and tempDetailModel[modelMethord] ~= nil then
        callBackMethord(tempDetailModel[modelMethord](tempDetailModel,...))
    end
end

--远程调用Control的无返回值方法
--参数：
--0:insId  与当前打开界面对比
--1：Controller名字
--2：ontroller中self方法名
function DataManager.ControllerRpcNoRet(insId, ctrlName, modelMethord, ...)
    --参数验证
    local m_allPages = UIPanel.GetAllPages()
    if  m_allPages == nil or insId == nil or modelMethord == nil then
        return
    end
    local tempController = m_allPages[ctrlName]
    if (tempController ~= nil and tempController[modelMethord] ~= nil ) and tempController.m_data and tempController.m_data.insId == insId then
        tempController[modelMethord](tempController,...)
    end
end

--远程调用Control的有返回值方法
--参数：
--0:insId  与当前打开界面对比
--1：Controller名字
--2：Controller中self方法名
--3：回调函数，参数为2中方法的返回值
--4：... Controller中方法参数
function DataManager.ControllerRpc(insId, ctrlName, modelMethord, callBackMethord, ...)
    --参数验证
    local m_allPages = UIPanel.GetAllPages()
    if m_allPages == nil or insId == nil or ctrlName == nil or modelMethord == nil or callBackMethord == nil then
        return
    end
    local tempController = m_allPages[ctrlName]
    if (tempController ~= nil and tempController[modelMethord] ~= nil ) and tempController.insId == insId then
        callBackMethord(tempController[modelMethord](tempController,...))
    end
end

----------------------------------------------------------------------------------DetailModel的网络消息管理

--DetailModel 向服务器发送数据
--参数：
--protoNameStr：protobuf表名
--protoNumStr:  protobuf协议号
--protoEncodeStr:  protobuf装箱数据结构名
--Msgtable： 向服务器发送数据Table集合
function DataManager.ModelSendNetMes(protoNameStr,protoNumStr,protoEncodeStr,Msgtable)
    --TODO:发送数据判空检验
    if Msgtable ~= nil then
        local msgId = pbl.enum(protoNameStr, protoNumStr)
        local pMsg = assert(pbl.encode(protoEncodeStr, Msgtable))
        CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
    end
end

function DataManager.UnAllModelRegisterNetMsg()
    ModelNetMsgStack = {}
    CityEngineLua.Message.clear()
end

--DetailModel 注册消息回调
--参数：
--insId：Model唯一ID
--protoNameStr：protobuf表名
--protoNumStr:  protobuf协议号
--protoAnaStr:  0
--callBackMethord： 具体回调函数(参数为已解析)
--InstantiateSelf: 仅针对非建筑详情Model使用，传入对应的ID值
--errorfun: error处理方法
function DataManager.ModelRegisterNetMsg(insId,protoNameStr,protoNumStr,protoAnaStr,callBackMethord,InstantiateSelf)
    local newMsgId = pbl.enum(protoNameStr,protoNumStr)
    if not ModelNetMsgStack[newMsgId] or type(ModelNetMsgStack[newMsgId]) ~= "table" then
        ModelNetMsgStack[newMsgId] = {}
        --注册分发函数
        CityEngineLua.Message:registerNetMsg(newMsgId,function (stream, msgId)
            local protoData = assert(pbl.decode(protoAnaStr, stream), "")
            local protoID = nil
            if protoData ~= nil then
                if (protoData.info and protoData.info.id )then
                    protoID = protoData.info.id
                elseif protoData.buildingId then
                    protoID = protoData.buildingId
                elseif protoData.src then
                    protoID = protoData.src
                elseif protoData.id then
                    protoID = protoData.id
                end
            end
            if protoID ~= nil then--服务器返回的数据有唯一ID
                for key, call in pairs(ModelNetMsgStack[newMsgId]) do
                    if key == protoID then
                        for i, func in pairs(ModelNetMsgStack[newMsgId][key]) do
                            if BuildDataStack.DetailModelStack[protoID] then
                                func(BuildDataStack.DetailModelStack[protoID],protoData)
                            else
                                func(protoData)
                            end
                        end
                        return
                    end
                end
            end

            --该消息监听的无参回调如果有
            if  ModelNetMsgStack[newMsgId]["NoParameters"] ~= nil then  --ModelNetMsgStack[newMsgId]~=nil and
            for i, funcTable in pairs(ModelNetMsgStack[newMsgId]["NoParameters"]) do
                    if funcTable.self ~= nil then
                        funcTable.func(funcTable.self,protoData,newMsgId)
                    else
                        funcTable.func(protoData,newMsgId)
                    end
                end
            end
            ct.log("System","没有找到对应的建筑详情Model类的回调函数")
        end)
    end
    --依据有无唯一ID，存储回调方法
    if  insId ~= nil then --若有唯一ID，则将方法写到唯一ID对应的table中
        if ModelNetMsgStack[newMsgId][insId] == nil then
            ModelNetMsgStack[newMsgId][insId] = {}
        end
        table.insert(ModelNetMsgStack[newMsgId][insId],callBackMethord)
    else--若无唯一ID，则将方法写到"NoParameters"对应的table中
        if  ModelNetMsgStack[newMsgId]["NoParameters"] == nil then
            ModelNetMsgStack[newMsgId]["NoParameters"] = {}
        end
        local funcTable = {}
        funcTable.func = callBackMethord
        if InstantiateSelf ~= nil then
            funcTable.self = InstantiateSelf
        end
        table.insert(ModelNetMsgStack[newMsgId]["NoParameters"],funcTable)
    end
end



function DataManager.RegisterErrorNetMsg()
    DataManager.ModelRegisterNetMsg(nil,"common.OpCode","error","common.Fail",function (protoData, msgId)
        --该消息监听的无参回调如果有
        local msgErrId = pbl.enum('common.OpCode','error')
        if ModelNetMsgStack[protoData.opcode] ~= nil then
            if ModelNetMsgStack[protoData.opcode]["NoParameters"] ~= nil  then
                local tb = ModelNetMsgStack[protoData.opcode]["NoParameters"]
                for i, funcTable in pairs(tb) do
                    if funcTable.self ~= nil then
                        funcTable.func(funcTable.self,protoData,msgErrId)
                    else
                        funcTable.func(protoData,msgErrId)
                    end
                end
            end
        else
            local info = {}
            info.titleInfo = "未注册处理方法的网络错误"
            --替換為多語言
            info.contentInfo = "网络错误Opcode：" ..  tostring(protoData.opcode)
            info.tipInfo = ""
            ct.OpenCtrl("ErrorBtnDialogPageCtrl", info)
        end

    end ,nil)

    --CityEngineLua.Message:registerNetMsg(pbl.enum("common.OpCode","error"),function (stream)
    --    local protoData = assert(pbl.decode("common.Fail", stream), "")
    --    --该消息监听的无参回调如果有
    --    if ModelNetMsgStack['common.OpCode']['error']["NoParameters"] ~= nil  then
    --        for i, funcTable in pairs(ModelNetMsgStack['common'][protoData.opcode]["NoParameters"]) do
    --            if funcTable.self ~= nil then
    --                funcTable.func(funcTable.self,protoData,pbl.enum('common.OpCode','error'))
    --            else
    --                funcTable.func(protoData,pbl.enum('common.OpCode','error'))
    --            end
    --        end
    --    end
    --
    --    --之前的临时处理
    --    if protoData ~= nil then
    --        local info = {}
    --        info.titleInfo = "网络错误"
    --        --替換為多語言
    --        info.contentInfo = "网络错误Opcode：" ..  tostring(protoData.opcode)
    --        info.tipInfo = ""
    --        ct.OpenCtrl("ErrorBtnDialogPageCtrl", info)
    --    end
    --end)
end


--移除 消息回调
function DataManager.ModelRemoveNetMsg(insId,protoNameStr,protoNumStr,protoAnaStr)
     if ModelNetMsgStack[protoNameStr] and ModelNetMsgStack[protoNameStr][protoNumStr] and ModelNetMsgStack[protoNameStr][protoNumStr][insId] then
        ModelNetMsgStack[protoNameStr][protoNumStr][insId] = nil
        --[[
        if #ModelNetMsgStack[protoNameStr][protoNumStr] == 0 then
            ModelNetMsgStack[protoNameStr][protoNumStr] = nil
        end
        --]]
    end
end
--
--移除 无实例Id的消息回调
function DataManager.ModelNoneInsIdRemoveNetMsg(protoNameStr,protoNumStr,ins)
    local newMsgId = pbl.enum(protoNameStr,protoNumStr)

    local noParameters = ModelNetMsgStack[newMsgId]["NoParameters"]
    if noParameters ~= nil then
        for i, value in pairs(noParameters) do
            if noParameters.self ~= nil and noParameters.self == ins then
                table.remove(ModelNetMsgStack[newMsgId]["NoParameters"],value)
                return
            end
        end
    end
end

---------------------------------------------------------------------------------- 用户信息---------------------------------------------------------------------------------
local updataTimer = 0

--计算自己租的地中有没有到期
local function CalculateTheExpirationDateOfMyRentGroundInfo()
    if PersonDataStack.m_rentGroundInfos ~= nil then
        local currentTime = TimeSynchronized.GetTheCurrentServerTime()
        if currentTime ~= nil then
            for key, value in pairs(PersonDataStack.m_rentGroundInfos) do
                if value.rent.rentDueTime == nil  or value.rent.rentDueTime <= currentTime  then
                    PersonDataStack.m_rentGroundInfos[key] = nil
                end
            end
        end
    end
end

local function DataManager_Update()
    updataTimer = updataTimer + UnityEngine.Time.deltaTime
    if updataTimer > 1 then
        CalculateTheExpirationDateOfMyRentGroundInfo()
        updataTimer = 0
    end
end

--登录成功，游戏开始
local function LoginSuccessAndGameStart()
    --初始化相机位置为中心建筑在视野正中央
    TerrainManager.MoveToCentralBuidingPosition()
    --打开循环判断自己的租地是否到期
    UpdateBeat:Add(DataManager_Update, this)
    ------------------------------------打开我自己可用的地块
    MyGround.CreateMyGrounds()
    --请求自己的信息
    --GAucModel.m_ReqPlayersInfo({[1] = PersonDataStack.m_owner})
    PlayerInfoManger.GetInfos({[1] = PersonDataStack.m_owner}, DataManager.SetMyPersonalHomepageInfo, DataManager)
end

--土地集合
--参数： tempData  ===》    gs.Role
function  DataManager.InitPersonDatas(tempData)
    if not DataManager.PersonDataStack then
        DataManager.PersonDataStack = {}
    end
    if not tempData then
        ct.log("System","登录成功RoleLogin返回信息为空")
        return
    end
    --初始化建筑评分
    if tempData.buildingBrands then
        PersonDataStack.m_buildingBrands=tempData.buildingBrands
    else
        PersonDataStack.m_buildingBrands=0
    end
    --初始化个人唯一ID
    PersonDataStack.m_owner = tempData.id
    --初始化自己所拥有地块集合

    if tempData.ground ~= nil then
        if PersonDataStack.m_groundInfos == nil then
            PersonDataStack.m_groundInfos = {}
        end
        for key, value in pairs(tempData.ground) do
            PersonDataStack.m_groundInfos[TerrainManager.GridIndexTurnBlockID(value)] = value
        end
    end
    --[[过时
    PersonDataStack.m_groundInfos = tempData.ground
    if PersonDataStack.m_groundInfos ~= nil then
        for i, v in pairs(PersonDataStack.m_groundInfos) do
            if v.sell ~= nil then
                ct.log()
            end
        end
    end
    --]]
    --初始化自己所租赁地块集合
    --PersonDataStack.m_rentGroundInfos = tempData.rentGround
    if tempData.rentGround ~= nil then
        for i, groundInfoData in pairs(tempData.rentGround) do
            DataManager.AddMyRentGroundInfo(groundInfoData)
        end
    end

    --获取自己所有的建筑详情
    PersonDataStack.m_buysBuilding = tempData.buys or {}
    --初始化自己中心仓库的建筑ID
    PersonDataStack.m_bagId = tempData.bagId
    --初始化自己中心仓库的数据
    if tempData.bag ~= nil then
        local inHand = tempData.bag.inHand
        PersonDataStack.m_inHand = ct.deepCopy( inHand )
    end
    PersonDataStack.m_bag = tempData.bag
    --初始化自己的moneys
    PersonDataStack.m_money = tempData.money --GetClientPriceString(tempData.money)
    --初始化中心仓库容量
    PersonDataStack.m_bagCapacity = tempData.bagCapacity
    --初始化自己的name
    PersonDataStack.m_name = tempData.name
    --初始化自己的公司名字
    PersonDataStack.m_companyName = tempData.companyName
    --初始化自己的头像ID
    PersonDataStack.m_faceId = tempData.faceId
    --初始化自己的公会ID
    PersonDataStack.m_societyId = tempData.societyId

    --初始化自己的基本信息
    PersonDataStack.m_roleInfo =
    {
        id = tempData.id,
        name = tempData.name,
        companyName = tempData.companyName,
        male = tempData.male,
        des = tempData.des,
        faceId = tempData.faceId,
        createTs = tempData.createTs
    }

    --初始化自己所拥有建筑品牌值
    if  PersonDataStack.m_buildingBrands == nil then
        PersonDataStack.m_buildingBrands = {}
    end
    if tempData.buildingBrands then
        for key, value in pairs(tempData.buildingBrands) do
            if value.id and value.num then
                PersonDataStack.m_buildingBrands[value.id] = value.num
            end
        end
    end
    --初始化自己所拥有商品科技等级
    if  PersonDataStack.m_goodBrands == nil then
        PersonDataStack.m_goodBrands = {}
    end
    if tempData.goodBrands then
        for key, value in pairs(tempData.goodBrands) do
            if value.id and value.num then
                PersonDataStack.m_goodBrands[value.id] = value.num
            end
        end
    end
    --初始化自己所拥有商品科技等级
    if  PersonDataStack.m_goodLv == nil then
        PersonDataStack.m_goodLv = {}
    end
    if tempData.goodLv then
        for key, value in pairs(tempData.goodLv) do
            if value.id and value.num then
                PersonDataStack.m_goodLv[value.id] = value.num
            end
        end
    end
    --初始化好友信息
    if  PersonDataStack.m_friends == nil then
        PersonDataStack.m_friends = {}
    end
    if tempData.friends then
        for key, value in pairs(tempData.friends) do
            if value.id and value.b ~= nil then
                PersonDataStack.m_friends[value.id] = value.b
            end
        end
    end
    PersonDataStack.socialityManager = SocialityManager:new()
    if tempData.friends then
        for _, value in pairs(tempData.friends) do
            if value.id and value.b ~= nil then
                DataManager.SetMyFriends(value)
            end
        end
    end

    -- 初始化公会信息
    PersonDataStack.guildManager = GuildManager:new()
    DataManager.InitGuildInfo()

    --初始化相机位置
    if tempData.position ~= nil then
        local LastCollectionID = TerrainManager.AOIGridIndexTurnCollectionID(tempData.position)
        local LastBlockID= TerrainManager.CollectionIDTurnBlockID(LastCollectionID)
        local LastPos = TerrainManager.BlockIDTurnPosition(LastBlockID)
        CameraMove.MoveCameraToPos(LastPos)
    end
    LoginSuccessAndGameStart()
end

--添加/修改自己所拥有土地
function DataManager.AddMyGroundInfo(groundInfoData)
    --检查自己所拥有地块集合有没有该地块
    if PersonDataStack.m_groundInfos then
        for key, value in pairs(PersonDataStack.m_groundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y then
                PersonDataStack.m_groundInfos[key] = groundInfoData
                if groundInfoData.rent ~= nil and groundInfoData.rent.renterId ~= nil then
                    MyGround.RemoveMyGround(Vector3.New(groundInfoData.x,0,groundInfoData.y))
                end
                return
            end
        end
    else
        PersonDataStack.m_groundInfos = {}
    end
    table.insert(PersonDataStack.m_groundInfos,groundInfoData)
    MyGround.AddMyGround(Vector3.New(groundInfoData.x,0,groundInfoData.y))
end

--添加/修改自己所租赁土地
function DataManager.AddMyRentGroundInfo(groundInfoData)
    --检查自己所租赁地块集合有没有该地块
    if PersonDataStack.m_rentGroundInfos ~= nil then
        for key, value in pairs(PersonDataStack.m_rentGroundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y and groundInfoData.rent ~= nil then
                PersonDataStack.m_rentGroundInfos[key] = nil
                break
            end
        end
    else
        PersonDataStack.m_rentGroundInfos = {}
    end
    if groundInfoData.rent ~= nil and groundInfoData.rent.rentBeginTs ~= nil and groundInfoData.rent.rentDays ~= nil then
        groundInfoData.rent.rentDueTime = groundInfoData.rent.rentBeginTs + groundInfoData.rent.rentDays * 24 * 60 * 60 * 1000
    end
    table.insert(PersonDataStack.m_rentGroundInfos,groundInfoData)
    MyGround.AddMyGround(Vector3.New(groundInfoData.x,0,groundInfoData.y))
end

--删除自己所拥有土地
function DataManager.RemoveMyGroundInfo(groundInfoData)
    if PersonDataStack.m_groundInfos ~= nil then
        for key, value in pairs(PersonDataStack.m_groundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y then
                PersonDataStack.m_groundInfos[key] = nil
                MyGround.RemoveMyGround(Vector3.New(groundInfoData.x,0,groundInfoData.y))
            end
        end
    end
end

--删除自己所租赁土地
--暂时没有用到
function DataManager.RemoveMyRentGroundInfo(groundInfoData)
    if PersonDataStack.m_rentGroundInfos ~= nil then
        for key, value in pairs(PersonDataStack.m_rentGroundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y then
                PersonDataStack.m_rentGroundInfos[key] = nil
                MyGround.RemoveMyGround(Vector3.New(groundInfoData.x,0,groundInfoData.y))
            end
        end
    end
end

--获取行业标准工资
function DataManager.GetBuildingStandardWage(buildingTypeId)
    if DataManager.BuildingStandardWage == nil or DataManager.BuildingStandardWage[buildingTypeId] == nil then
        return nil
    end
    return DataManager.BuildingStandardWage[buildingTypeId]
end

--更新行业标准工资
function DataManager.SetBuildingStandardWage(buildingType, wage)
    if DataManager.BuildingStandardWage == nil then
        DataManager.BuildingStandardWage = {}
    end
    DataManager.BuildingStandardWage[buildingType] = wage
end

--获取自已的所有的建筑评分
function DataManager.GetMyBuildingBrands()
    return PersonDataStack.m_buildingBrands
end

--获取自已的Id
function DataManager.GetMyOwnerID()
    return PersonDataStack.m_owner
end

--获取中心仓库Id
function DataManager.GetBagId()
    return PersonDataStack.m_bagId
end

--获取中心仓库信息
function DataManager.GetBagInfo()
    return PersonDataStack.m_inHand
end

--获取中心仓库容量
function DataManager.GetBagCapacity()
    return PersonDataStack.m_bagCapacity
end

--获取自己的money
function DataManager.GetMoney()
    return PersonDataStack.m_money
end

function DataManager.GetMoneyByString()
    return GetClientPriceString(PersonDataStack.m_money)
end

--刷新自己的money
function DataManager.SetMoney(money)
    PersonDataStack.m_money = money
end

--获取自己的名字
function DataManager.GetName()
    return PersonDataStack.m_name
end

--获取自己的公司名字
function DataManager.GetCompanyName()
    return PersonDataStack.m_companyName
end

--获取头像ID
function DataManager.GetFaceId()
    return  PersonDataStack.m_faceId
end

function DataManager.GetMyPersonData()
    return PersonDataStack
end

--刷新自己所拥有建筑品牌值
function DataManager.GetMyBuildingBrands()
    return PersonDataStack.m_buildingBrands
end

--刷新自己所拥有建筑品牌值
--参数： tempData==>  IntNum
function DataManager.SetMyBuildingBrands(tempData)
    if tempData.id and tempData.num then
        PersonDataStack.m_buildingBrands[tempData.id] = tempData.num
    end
end

--刷新自己所拥有商品品牌值
function DataManager.GetMyGoodBrands()
    return PersonDataStack.m_goodBrands
end

--刷新自己所拥有商品品牌值
--参数： tempData==>  IntNum
function DataManager.SetMyGoodBrands(tempData)
    if tempData.id and tempData.num then
        PersonDataStack.m_goodBrands[tempData.id] = tempData.num
    end
end

--刷新自己所拥有商品科技等级
function DataManager.GetMyGoodLv()
    return PersonDataStack.m_goodLv
end

--根据id查询等级
function DataManager.GetMyGoodLvByItemId(itemId)
    return PersonDataStack.m_goodLv[itemId] or 0
end

--获取主页需要的显示信息
function DataManager.GetMyPersonalHomepageInfo()
    return PersonDataStack.m_roleInfo
end

--刷新自己的信息
function DataManager.SetMyPersonalHomepageInfo(this,info)
    local data = info[1]
    PersonDataStack.m_roleInfo.name = data.name
    PersonDataStack.m_roleInfo.companyName = data.companyName
    PersonDataStack.m_roleInfo.des = data.des
    PersonDataStack.m_roleInfo.faceId = data.faceId
    PersonDataStack.m_roleInfo.male = data.male
    PersonDataStack.m_roleInfo.createTs = data.createTs
end

--设置主页需要的显示信息--个人描述
function DataManager.SetMyPersonalHomepageDesInfo(des)
    PersonDataStack.m_roleInfo.des = des
end

--刷新自己所拥有商品科技等级
--参数： tempData==>  IntNum
function DataManager.SetMyGoodLv(tempData)
    if tempData.id and tempData.num then
        PersonDataStack.m_goodLv[tempData.id] = tempData.num
    end
end

--获取自己好友信息
function DataManager.GetMyFriends()
    --return PersonDataStack.m_friends
    return PersonDataStack.socialityManager:GetMyFriends()
end

--刷新自己好友信息
--参数： tempData==>  ByteBool
--如果需要删除好友，ByteBool={ id = "XXXXXXXX",b = nil }
function DataManager.SetMyFriends(tempData)
    PersonDataStack.socialityManager:SetMyFriends(tempData)
end

--获取自己好友申请信息
function DataManager.GetMyFriendsApply()
    --return PersonDataStack.m_friendsApply
    return PersonDataStack.socialityManager:GetMyFriendsApply()
end

--刷新自己好友申请信息
--参数： tempData==>  RequestFriend
--如果需要删除好友申请，ByteBool={ id = "XXXXXXXX",name = nil }
function DataManager.SetMyFriendsApply(tempData)
    --if tempData.id and tempData.name then
    --    table.insert(PersonDataStack.m_friendsApply, tempData)
    --elseif tempData.itemId and not tempData.id then
    --    table.remove(PersonDataStack.m_friendsApply, tempData.itemId)
    --end
    PersonDataStack.socialityManager:SetMyFriendsApply(tempData)
end

--获取自己黑名单
function DataManager.GetMyBlacklist()
    return PersonDataStack.socialityManager:GetMyBlacklist()
end

--刷新自己黑名单
--参数： tempData==>  Bytes
--如果需要删除黑名单，tempData={ id = "XXXXXXXX",name = nil }
function DataManager.SetMyBlacklist(tempData)
    --if tempData.id and tempData.name then
    --    table.insert(PersonDataStack.m_blacklist, tempData)
    --elseif tempData.id and not tempData.name then
    --    for i, v in ipairs(PersonDataStack.m_blacklist) do
    --        if v.id == tempData.id then
    --            table.remove(PersonDataStack.m_blacklist, i)
    --            break
    --        end
    --    end
    --end
    PersonDataStack.socialityManager:SetMyBlacklist(tempData)
end

-- 获取聊天消息
function DataManager.GetMyChatInfo(index)
    return PersonDataStack.socialityManager:GetMyChatInfo(index)
end

-- 刷新聊天消息
function DataManager.SetMyChatInfo(tempData)
    PersonDataStack.socialityManager:SetMyChatInfo(tempData)
end

-- 已读聊天消息
function DataManager.SetMyReadChatInfo(index, id)
    PersonDataStack.socialityManager:SetMyReadChatInfo(index, id)
end

-- 本地保存聊天消息
function DataManager.SaveFriendsChat()
    PersonDataStack.socialityManager:SaveFriendsChat()
end

-- 读取保存聊天消息
function DataManager.ReadFriendsChat()
    PersonDataStack.socialityManager:ReadFriendsChat()
end

-- 读取保存聊天消息
function DataManager.GetUnread()
    return PersonDataStack.socialityManager:GetUnread()
end

-- 清空聊天消息
function DataManager.SetStrangersInfo(id)
    return PersonDataStack.socialityManager:SetStrangersInfo(id)
end

-- 获得好友所有聊天纪录
function DataManager.GetChatRecords()
    return PersonDataStack.socialityManager:GetChatRecords()
end

-- 删除好友所有聊天纪录
function DataManager.SetChatRecords(index)
    return PersonDataStack.socialityManager:SetChatRecords(index)
end

-- 清空公会的聊天消息
function DataManager.SetGuildChatInfo()
    return PersonDataStack.socialityManager:SetGuildChatInfo()
end

-- 获得公会ID
function DataManager.GetGuildID()
    return PersonDataStack.m_societyId
end

-- 设置公会ID
function DataManager.SetGuildID(id)
    PersonDataStack.m_societyId = id
end

-- 查询公会全部信息
function DataManager.InitGuildInfo()
    if PersonDataStack.m_societyId then
        PersonDataStack.guildManager:InitGuildInfo(PersonDataStack.m_societyId)
    end
end

-- 设置公会全部信息
function DataManager.SetGuildInfo(societyInfo)
    PersonDataStack.guildManager:SetGuildInfo(societyInfo)
end

-- 获取公会全部信息
function DataManager.GetGuildInfo()
    return PersonDataStack.guildManager:GetGuildInfo()
end

-- 删除已处理的入会请求
function DataManager.DeleteGuildJoinReq(joinReq)
    PersonDataStack.guildManager:DeleteGuildJoinReq(joinReq)
end

-- 设置公会信息
function DataManager.SetGuildMember(memberChanges)
    PersonDataStack.guildManager:SetGuildMember(memberChanges)
end

-- 设置公会通知
function DataManager.SetGuildNotice(societyNotice)
    PersonDataStack.guildManager:SetGuildNotice(societyNotice)
end

-- 新增入会请求
function DataManager.SetGuildJoinReq(joinReq)
    PersonDataStack.guildManager:SetGuildJoinReq(joinReq)
end

-- 获得自己公会的职位
function DataManager.GetOwnGuildIdentity()
    return PersonDataStack.guildManager:GetOwnGuildIdentity(PersonDataStack.m_owner)
end

-- 刪除公会成员
function DataManager.DeleteGuildMember(playerId)
    PersonDataStack.guildManager:DeleteGuildMember(playerId)
end

-- 成员上下线
function DataManager.SetGuildMemberOnline(playerId, online)
    PersonDataStack.guildManager:SetGuildMemberOnline(playerId, online)
end

-- 成员权限变更
function DataManager.SetGuildMemberIdentity(playerId, identity)
    PersonDataStack.guildManager:SetGuildMemberIdentity(playerId, identity)
end

-- 设置名字
function DataManager.SetGuildSocietyName(bytesStrings)
    PersonDataStack.guildManager:SetGuildSocietyName(bytesStrings)
end

-- 设置介绍
function DataManager.SetGuildIntroduction(bytesStrings)
    PersonDataStack.guildManager:SetGuildIntroduction(bytesStrings)
end

-- 设置宣言
function DataManager.SetGuildDeclaration(bytesStrings)
    PersonDataStack.guildManager:SetGuildDeclaration(bytesStrings)
end

-- 获得公会成员
function DataManager.GetGuildMembers()
    return PersonDataStack.guildManager:GetGuildMembers()
end
---------------------------------
--获取自己所有的建筑详情
function DataManager.GetMyAllBuildingDetail()
    return PersonDataStack.m_buysBuilding
end

--刷新自己所有的建筑详情
function DataManager.SetMyAllBuildingDetail(tempData)
    PersonDataStack.m_buysBuilding = tempData
end

--删除自己所拥有的某一个建筑
-- tempbuildID: 建筑唯一ID
function DataManager.RemoveMyBuildingDetailByBuildID(tempbuildID)
    if PersonDataStack.m_buysBuilding ~= nil then
        for type, value in pairs(PersonDataStack.m_buysBuilding) do
            for key, data in pairs(value) do
                if data ~= nil and data.info ~= nil and data.info.id ~= nil and  tempbuildID == data.info.id then
                    PersonDataStack.m_buysBuilding[type][key] = nil
                    return true
                end
            end
        end
    end
    return false
end

--判断该地块是不是自己可以用的（包含自己拥有和租的）
function DataManager.IsOwnerGround(tempPos)
    local tempGridIndex =  { x = Math_Floor(tempPos.x) , y = Math_Floor(tempPos.z) }
    --在自己拥有的的地中判断
    if PersonDataStack.m_groundInfos ~= nil then
        for key, value in pairs(PersonDataStack.m_groundInfos) do
            --一定要判断自己的地没有租出去
            if value.x == tempGridIndex.x and value.y == tempGridIndex.y and value.rent == nil  then
                return true
            end
        end
    end
    --在自己租的地中判断
    if PersonDataStack.m_rentGroundInfos ~= nil then
        for key, value in pairs(PersonDataStack.m_rentGroundInfos) do
            if value.x == tempGridIndex.x and value.y == tempGridIndex.y then
                return true
            end
        end
    end
    return false
end

function DataManager.IsAllOwnerGround(startBlockID,tempsize)
    local idList = DataManager.CaculationTerrainRangeBlock(startBlockID,tempsize)
    for key, value in pairs(idList) do
        if not DataManager.IsOwnerGround(TerrainManager.BlockIDTurnPosition(value)) then
            return false
        end
    end
    return true
end

--判断该地块允不允许改变
function DataManager.IsEnableChangeGround(blockID)
    local blockdata = DataManager.GetBlockDataByID(blockID)
    if nil ~= blockdata and  0 <= blockdata  then
        return false
    else
        return true
    end
end

--判断所有范围内地块允不允许改变
function DataManager.IsALlEnableChangeGround(startBlockID,tempsize)
    local idList = DataManager.CaculationTerrainRangeBlock(startBlockID,tempsize)
    for key, value in pairs(idList) do
        if not DataManager.IsEnableChangeGround(value) then
            return false
        end
    end
    return true
end

--判断是否在覆盖范围内
--startBlockID 根节点
--rangeSize 范围大小
--tempID   判断点
function DataManager.IsInTheRange(startBlockID,rangeSize,tempID)
    for i = startBlockID, (startBlockID + TerrainRangeSize * (rangeSize - 1)),TerrainRangeSize  do
        for tempkey = i, (i + rangeSize - 1) do
            if  tempkey == tempID then
                return true
            end
        end
    end
    return false
end

---------------------------------------------------------------------------------- 临时数据---------------------------------------------------------------------------------
--客户端请求
--取消出租
function DataManager.m_ReqCancelRentGround(coord)
    local msgId = pbl.enum("gscode.OpCode","cancelRentGround")
    local pMsg = assert(pbl.encode("gs.MiniIndexCollection", {coord = coord}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--取消售卖
function DataManager.m_ReqCancelSellGround(coord)
    local msgId = pbl.enum("gscode.OpCode","cancelSellGround")
    local pMsg = assert(pbl.encode("gs.MiniIndexCollection", {coord = coord}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--获取行业标准工资
function DataManager.m_ReqStandardWage(buildingType)
    if buildingType == nil then
        return
    end
    local msgId = pbl.enum("gscode.OpCode","queryIndustryWages")
    local pMsg = assert(pbl.encode("gs.QueryIndustryWages", {type = buildingType}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end


--注册所有消息回调
local function InitialEvents()
    Event.AddListener("c_RoleLoginDataInit", DataManager.InitPersonDatas)
    --Event.AddListener("c_GroundInfoChange", DataManager.InitPersonDatas)
   -- Event.AddListener("m_QueryPlayerInfo", this.m_QueryPlayerInfo)
   -- Event.AddListener("m_SetHeadId",DataManager.m_SetHeadId)
    Event.AddListener("c_AddBagInfo",DataManager.c_AddBagInfo)
    Event.AddListener("c_DelBagInfo",DataManager.c_DelBagInfo)
    Event.AddListener("c_DelBagItem",DataManager.c_DelBagItem)
end

--注册所有网络消息回调
function DataManager.InitialNetMessages()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","addBuilding","gs.BuildingInfo",DataManager.n_OnReceiveAddBuilding)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","unitCreate","gs.UnitCreate",DataManager.n_OnReceiveUnitCreate)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","unitRemove","gs.UnitRemove",DataManager.n_OnReceiveUnitRemove)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","unitChange","gs.BuildingInfo",DataManager.n_OnReceiveUnitChange)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","groundChange","gs.GroundChange",DataManager.n_OnReceiveGroundChange)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","addFriendReq","gs.RequestFriend",DataManager.n_OnReceiveAddFriendReq)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","addFriendSucess","gs.RoleInfo",DataManager.n_OnReceiveAddFriendSucess)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getBlacklist","gs.RoleInfos",DataManager.n_OnReceiveGetBlacklist)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","queryPlayerInfo","gs.RoleInfos",DataManager.n_OnReceivePlayerInfo)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","labRoll","gs.IntNum",DataManager.n_OnReceiveLabRoll)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","newItem","gs.IntNum",DataManager.n_OnReceiveNewItem)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","roleCommunication","gs.CommunicationProces",DataManager.n_OnReceiveRoleCommunication)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","roleStatusChange","gs.ByteBool",DataManager.n_OnReceiveRoleStatusChange)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","deleteFriend","gs.Id",DataManager.n_OnReceiveDeleteFriend)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","deleteBlacklist","gs.Id",DataManager.n_DeleteBlacklist)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getSocietyInfo", "gs.SocietyInfo", DataManager.n_GetSocietyInfo)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","delJoinReq", "gs.JoinReq", DataManager.n_JoinReq)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","memberChange", "gs.MemberChanges", DataManager.n_MemberChanges)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","noticeAdd", "gs.SocietyNotice", DataManager.n_NoticeAdd)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","newJoinReq", "gs.JoinReq", DataManager.n_NewJoinReq)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","joinHandle", "gs.SocietyInfo", DataManager.n_JoinHandle)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","exitSociety","gs.ByteBool", DataManager.n_ExitSociety)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","modifySocietyName","gs.BytesStrings", DataManager.n_ModifySocietyName)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","modifyIntroduction","gs.BytesStrings", DataManager.n_ModifyIntroduction)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","modifyDeclaration","gs.BytesStrings", DataManager.n_ModifyDeclaration)
end

--DataManager初始化
function DataManager.Init()
    RoadRootObj = find("Road")
    InitialEvents()
    DataManager.InitialNetMessages()
    --土地拍卖Model
    SystemDatas.GroundAuctionModel  = GAucModel.New()
    if SystemDatas.GroundAuctionModel ~= nil then
        SystemDatas.GroundAuctionModel:Awake()
    end
    DataManager.RegisterErrorNetMsg()
    --初始化自己的地块初始信息
    MyGround.Init()
    --建筑气泡对象池
    DataManager.buildingBubblePool= LuaGameObjectPool:new("BuildingBubble",creatGoods("View/Items/BuildingBubbleItems/UIBubbleBuildingSignItem"),5,Vector3.New(0,0,0) )
    ------------------------------------打开相机
    local cameraCenter = UnityEngine.GameObject.New("CameraTool")
    local luaCom = CityLuaUtil.AddLuaComponent(cameraCenter,'Terrain/CameraMove')
end

--清除所有消息回调
local function ClearEvents()
    Event.RemoveListener("c_RoleLoginDataInit", DataManager.InitPersonDatas)
    Event.RemoveListener("c_AddBagInfo",DataManager.c_AddBagInfo)
    Event.RemoveListener("c_DelBagInfo",DataManager.c_DelBagInfo)
    Event.RemoveListener("c_DelBagItem",DataManager.c_DelBagItem)
end

--清除所有Model
local function ClearAllModel()
    DataManager.ClearAllDetailModels()
    if BuildDataStack ~= nil then
        for tempCollectionID, value in pairs(BuildDataStack) do
            DataManager.RemoveCollectionDatasByCollectionID(tempCollectionID)
            BuildDataStack[tempCollectionID] = nil
        end
    end
    BuildDataStack = {}
    PersonDataStack = {}
    SystemDatas = {}
    ModelNetMsgStack = {}
    InitialEvents()
    DataManager.InitialNetMessages()
    --干掉我的地块
    MyGround.ClearMyGrounds()
    TerrainManager.ReMove()
end

function DataManager.Close()
    ClearEvents()
    ClearAllModel()
end

----------------------------------------------------网络回调函数---------------------------------

function DataManager.n_OnReceiveAddBuilding(stream)
    local buildingInfo = stream
    --buildingInfo  ==》BuildingInfo
    --此处因命名和层级问题，临时处理
    if not buildingInfo or not buildingInfo.mId then
        return
    end
    buildingInfo.buildingID = buildingInfo.mId
    buildingInfo.x = buildingInfo.pos.x
    buildingInfo.y = buildingInfo.pos.y
    TerrainManager.ReceiveArchitectureDatas({buildingInfo})
end

function DataManager.n_OnReceiveUnitCreate(stream)
    local UnitCreate = stream
    --此处因命名和层级问题，临时处理
    if not UnitCreate or not UnitCreate.info or 0 == #UnitCreate.info then
        return
    end
    for key, value in pairs(UnitCreate.info) do
        value.buildingID = value.mId
        value.x = value.pos.x
        value.y = value.pos.y
    end
    TerrainManager.ReceiveArchitectureDatas(UnitCreate.info)
end

function DataManager.n_OnReceiveUnitChange(stream)
    local buildingInfo = stream
    --buildingInfo  ==》BuildingInfo
    --此处因命名和层级问题，临时处理
    if not buildingInfo or not buildingInfo.mId then
        return
    end
    buildingInfo.buildingID = buildingInfo.mId
    buildingInfo.x = buildingInfo.pos.x
    buildingInfo.y = buildingInfo.pos.y
    TerrainManager.ReceiveArchitectureDatas({buildingInfo})
end

function DataManager.n_OnReceiveUnitRemove(stream)
    --完成删除(注：删除自己的建筑回调，需做本地自己拥有建筑的删除)
    local removeInfo = stream
    if removeInfo ~= nil and removeInfo.id ~= nil and removeInfo.x ~= nil and removeInfo.y ~= nil then
        local tempBlockID = TerrainManager.GridIndexTurnBlockID(removeInfo)
        local tempCollectionID =  TerrainManager.BlockIDTurnCollectionID(tempBlockID)
        if BuildDataStack[tempCollectionID] ~= nil and BuildDataStack[tempCollectionID].BlockDatas and BuildDataStack[tempCollectionID].BlockDatas[tempBlockID] ~= nil then
            BuildDataStack[tempCollectionID].BaseBuildDatas[tempBlockID]:Close()
            BuildDataStack[tempCollectionID].BaseBuildDatas[tempBlockID] = nil
            --TODO：计算在当前AOI所有地块中 需要刷新的地块
            --刷新需要刷新的地块
            for key, value in pairs(TerrainManager.GetCameraCollectionIDAOIList()) do
                DataManager.RefreshWaysByCollectionID(value)
            end
        end
    end
end

--接收服务器地块信息数据
function DataManager.n_OnReceiveGroundChange(stream)
    local GroundChange = stream
    if GroundChange ~= nil and GroundChange.info ~= nil then
        for key, value in pairs(GroundChange.info) do
            --如果地块所有人是自己的话，写进自己所拥有地块集合
            if nil ~= PersonDataStack.m_owner and value.ownerId  == PersonDataStack.m_owner then
                DataManager.AddMyGroundInfo(value)
            end
            --如果地块足令人是自己的话  写进自己所租赁地块集合
            if nil ~= PersonDataStack.m_owner and nil ~= value.Rent and value.Rent.renterId  == PersonDataStack.m_owner then
                DataManager.AddMyRentGroundInfo(value)
            end
            local tempGroundBlockID  = TerrainManager.GridIndexTurnBlockID(value)
            local tempGroundCollectionID  = TerrainManager.BlockIDTurnCollectionID(tempGroundBlockID)
            --判空处理
            if BuildDataStack[tempGroundCollectionID] == nil then
                BuildDataStack[tempGroundCollectionID] = {}
            end
            if BuildDataStack[tempGroundCollectionID].GroundDatas == nil then
                BuildDataStack[tempGroundCollectionID].GroundDatas = {}
            end
            --刷新/创建地块信息Model
            if BuildDataStack[tempGroundCollectionID].GroundDatas[tempGroundBlockID] ~= nil then
                BuildDataStack[tempGroundCollectionID].GroundDatas[tempGroundBlockID]:Refresh(value)
                BuildDataStack[tempGroundCollectionID].GroundDatas[tempGroundBlockID]:CheckBubbleState()
            else
                BuildDataStack[tempGroundCollectionID].GroundDatas[tempGroundBlockID]  = BaseGroundModel:new(value)
            end
        end
    end
end

-- 接收好友申请
function DataManager.n_OnReceiveAddFriendReq(stream)
    local requestFriend = stream
    if not requestFriend or not requestFriend.id then
        return
    end
    DataManager.SetMyFriendsApply(requestFriend)
    Event.Brocast("c_OnReceiveAddFriendReq", requestFriend)
end

-- 接收好友添加成功申请
function DataManager.n_OnReceiveAddFriendSucess(stream)
    local friend = stream
    if not friend or not friend.id then
        return
    end
    friend.b = true
    DataManager.SetMyFriends(friend)
    DataManager.SetMyFriendsApply({id = friend.id})
    DataManager.SetStrangersInfo(friend.id)
    Event.Brocast("c_OnReceiveAddFriendSucess", friend)
end

-- 接收黑名单
function DataManager.n_OnReceiveGetBlacklist(stream)
    local roleInfos = stream
    if not roleInfos.info then
        return
    end
    for _, v in pairs(roleInfos.info) do
        if v then
            DataManager.SetMyBlacklist(v)
        end
    end
end

--查询玩家信息返回
function DataManager.n_OnReceivePlayerInfo(stream)
   PlayerInfoManger.n_OnReceivePlayerInfo(stream)
end

--研究所Roll回复信息
function DataManager.n_OnReceiveLabRoll(stream)
    Event.Brocast("c_LabRollSuccess")
end

--发明研究成功  --用来更新玩家数据
function DataManager.n_OnReceiveNewItem(stream)
    local data = stream
    if data then
        DataManager.SetMyGoodLv(data)
    end
end

--处理错误信息
--研究所Roll回复信息
--不启用
function DataManager.n_OnReceiveErrorCode(data, msgId)
    if data then
        ct.log("cycle_w15_laboratory03", "---- error opcode："..data.opcode)
        if data.opcode == 1157 then  --研究所roll失败
            local info = {}
            info.titleInfo = "FAIL"
            info.contentInfo = "Roll Fail"
            info.tipInfo = ""
            ct.OpenCtrl("ErrorBtnDialogPageCtrl", info)
        elseif data.opcode == 5015 then  --世界发言失败
            if data.reason == "highFrequency" then
                Event.Brocast("SmallPop","Speeches are frequent. Please wait a moment.",80)
            elseif data.reason == "notAllow" then
                Event.Brocast("SmallPop","Has been shielded.",60)
            end
        elseif data.opcode == 10000 then  -- 获取交易信息失败
            Event.Brocast("c_OnReceivePlayerEconomy")
        end
    end
end


----------

-- 收到服务器的聊天消息
function DataManager.n_OnReceiveRoleCommunication(netData,msgId)
    --异常处理
    if msgId == 0 then
        if netData.reason == 'highFrequency' then
            Event.Brocast("SmallPop",GetLanguage(15010021),70)
        elseif netData.reason == 'notAllow' then
            Event.Brocast("SmallPop",GetLanguage(15010022),70)
        end
        return
    end
    --非异常的处理流程
    DataManager.SetMyChatInfo(netData)
    Event.Brocast("c_OnReceiveRoleCommunication", netData)
end

-- 好友在线状态刷新
function DataManager.n_OnReceiveRoleStatusChange(stream)
    local roleData = stream
    DataManager.SetMyFriends(roleData)
    Event.Brocast("c_OnReceiveRoleStatusChange", roleData)
end

-- 收到删除好友信息
function DataManager.n_OnReceiveDeleteFriend(stream)
    local friendsId = stream
    DataManager.SetMyFriends({ id = friendsId.id, b = nil })
    Event.Brocast("c_OnReceiveDeleteFriend", friendsId)
end

-- 解除屏蔽返回
function DataManager.n_DeleteBlacklist(stream)
    local friendsId = stream
    DataManager.SetMyBlacklist({ id = friendsId.id })
    Event.Brocast("c_DeleteBlacklist", friendsId)
end

-- 查询公会消息返回
function DataManager.n_GetSocietyInfo(societyInfo)
    DataManager.SetGuildInfo(societyInfo)
end

-- 删除已处理的入会请求
function DataManager.n_JoinReq(joinReq)
    DataManager.DeleteGuildJoinReq(joinReq)
end

-- 成员变更
function DataManager.n_MemberChanges(memberChanges)
    for i, v in ipairs(memberChanges.changeLists) do
        if v.type == "JOIN" then
            -- 有玩家加入
            DataManager.SetGuildMember(v.info)
        elseif v.type == "EXIT" then
            -- 有玩家退出
            DataManager.DeleteGuildMember(v.playerId)
        elseif v.type == "ONLINE" then
            -- 有玩家上线
            DataManager.SetGuildMemberOnline(v.playerId, true)
        elseif v.type == "OFFLINE" then
            -- 有玩家下线
            DataManager.SetGuildMemberOnline(v.playerId, false)
        elseif v.type == "IDENTITY" then
            -- 有玩家的权限变更
            DataManager.SetGuildMemberIdentity(v.playerId, v.identity)
        end
    end
end

-- 新增公会通知
function DataManager.n_NoticeAdd(societyNotice)
    DataManager.SetGuildNotice(societyNotice)
end

-- 新增入会请求
function DataManager.n_NewJoinReq(joinReq)
    DataManager.SetGuildJoinReq(joinReq)
end

-- 申请加入公会通过
function DataManager.n_JoinHandle(societyInfo)
    DataManager.SetGuildID(societyInfo.id)
    DataManager.SetGuildInfo(societyInfo)
end

-- 退出公会
function DataManager.n_ExitSociety(ByteBool)
    DataManager.SetGuildID()
    DataManager.SetGuildInfo()
end

-- 改名字返回
function DataManager.n_ModifySocietyName(bytesStrings, msgId)
    --异常处理
    if msgId == 0 then
        return
    end
    DataManager.SetGuildSocietyName(bytesStrings)
end

-- 改介绍返回
function DataManager.n_ModifyIntroduction(bytesStrings)
    DataManager.SetGuildIntroduction(bytesStrings)
end

-- 改宣言返回
function DataManager.n_ModifyDeclaration(bytesStrings)
    DataManager.SetGuildDeclaration(bytesStrings)
end
----------

--增加中心仓库物品
function DataManager.c_AddBagInfo(itemId,producerId,qty,n)
    if  #PersonDataStack.m_inHand == 0 then
        PersonDataStack.m_inHand = {}
        PersonDataStack.m_inHand[1] = {}
        PersonDataStack.m_inHand[1].key = {}
        PersonDataStack.m_inHand[1].key.id = itemId
        PersonDataStack.m_inHand[1].key.producerId = producerId
        PersonDataStack.m_inHand[1].key.qty = qty
        PersonDataStack.m_inHand[1].n = n
        return
    end
    local newInHand = false
    for i, v in pairs(PersonDataStack.m_inHand) do
        if v.key.id == itemId then
            v.n = v.n + n
            newInHand = false
            break
        else
            newInHand = true
        end
    end
    if newInHand then
        PersonDataStack.m_inHand[#PersonDataStack.m_inHand + 1]  = {key = {id = itemId,producerId = producerId,qty = qty},n = n}
    end
end

--减少中心仓库物品
function DataManager.c_DelBagInfo(itemId,n)
    if not PersonDataStack.m_inHand then
        return
    end
    local newInHand = false
        for i, v in pairs(PersonDataStack.m_inHand) do
            if v.key.id == itemId then
                if v.n > n then
                    v.n = v.n - n
                    newInHand = false
                elseif v.n == n then
                    table.remove(PersonDataStack.m_inHand,i)
                    newInHand = true
                end
            end
        end
end

--删除中心仓库物品
function DataManager.c_DelBagItem(itemId)
    if not PersonDataStack.m_inHand then
        return
    end
    for i, v in pairs(PersonDataStack.m_inHand) do
        if v.key.id == itemId then
            table.remove(PersonDataStack.m_inHand,i)
        end
    end
end

--获取中心仓库物品数量
function DataManager.GetBagNum()
    local n = 0
    if PersonDataStack.m_inHand == nil then
        return n
    end
    for i, v in pairs(PersonDataStack.m_inHand) do
        n = n + v.n
    end
    return n
end

--根据大地块获取建筑基础信息
--如果没有BaseBuildDatas，返回nil
function DataManager.GetBuildingBaseByCollectionID(collectionID)
    if BuildDataStack ~= nil and collectionID ~= nil and BuildDataStack[collectionID] ~= nil and BuildDataStack[collectionID].BaseBuildDatas ~= nil then
        return BuildDataStack[collectionID].BaseBuildDatas
    else
        return nil
    end
end