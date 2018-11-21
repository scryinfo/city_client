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
--2.用户信息（登录时同步服务器，实时同步）
--  a.用户基础数据（table={ userID , Name ， Sex ，Avatar ， CompanyID ，CompanyName }）
--  b.用户自己所拥有的地块集合（key = BlockID ，value = nodeID）可修建为 -1  有建筑覆盖则记录节点ID
--  c.用户自己所拥有的商业建筑集合（key = NodeID， value = model ）
--  d.用户公司歌物品发明情况/研究等级
--3.临时数据
--  a.修建建筑时的临时数据（包括展示用GameObject集合，修建状态IsConstructing）
--          ==>> 打开修建界面时初始化，关闭时清空
--4.系统数据
--  a.当前操作状态（Enum TouchState{ NormalState = 1，//正常状态（可拖拽点击状态）   ConstructState = 2，//修建状态   UIState = 3，//UI查看状态   }）
--          ==》登录时初始化，用于触摸操作的控制判断
--  b.服务器时间戳
--          ==>> 登录时同步，断线重连刷新一次
--  c.地形大小，地块大小
--          ==>> 登录时初始化（考虑与服务器同步的需求）
--  c.设置中数据
--          ==>> 游戏开始时读取playerprefs，改变时写入playerprefs
--  e.拍卖地块信息


-- 数据集合
local BuildDataStack = { }      --建筑信息堆栈
local PersonDataStack = {}      --个人信息堆栈
local SystemDatas = {}          --系统信息集合
local TerrainRangeSize = 1000
local CollectionRangeSize = 20

DataManager.TempDatas ={ constructObj = nil, constructID = nil}


---------------------------------------------------------------------------------- 建筑信息---------------------------------------------------------------------------------

--功能
--  创建一个新的原子地块集合，并将内部所有数据置为 -1
--参数
--  tempCollectionID: 所属地块集合ID
local function CreateBlockDataTable(tempCollectionID)
    --创建一个新的原子地块集合
    BuildDataStack[tempCollectionID].BlockDatas = {}
    local startBlockID = TerrainManager.CollectionIDTurnBlockID(tempCollectionID)
    --将内部所有数据置为 -1
    local idList =  DataManager.CaculationTerrainRangeBlock(startBlockID,CollectionRangeSize)
    for key, value in ipairs(idList) do
        BuildDataStack[tempCollectionID].BlockDatas[value] = -1
    end
end

--功能
--  刷新原子地块集合的基本信息
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RefreshBlockData(blockID,nodeID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if nodeID == nil then
        nodeID = -1
    end
    BuildDataStack[collectionID].BlockDatas[blockID] = nodeID
end

function DataManager.RefreshBlockDataWhenNodeChange(nodeID,nodeSize)
    local idList =  DataManager.CaculationTerrainRangeBlock(nodeID,nodeSize)
    for key, value in ipairs(idList) do
        DataManager.RefreshBlockData(value,nodeID)
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
    for i = startBlockID, (startBlockID + TerrainRangeSize * rangeSize),TerrainRangeSize  do
        for tempkey = i, (i + rangeSize) do
            table.insert(idList, tempkey)
        end
    end
    return idList
end

--功能
--  刷新商业建筑集合的基础数据--
--参数
--  data:某个建筑基础数据（protobuf）
function DataManager.RefreshBaseBuildData(data)
    --数据判空处理
    local blockID
    if data.id ~= nil then
        blockID = data.id
    elseif data.x ~= nil and data.y ~= nil then
        blockID =TerrainManager.PositionTurnBlockID(Vector3.New(data.x,0,data.y))
        data.id = blockID
    else
        return
    end
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    --判断地块是否已经初始化
    if nil == BuildDataStack[collectionID] then
        BuildDataStack[collectionID] = {}
        --初始化地块集合
        BuildDataStack[collectionID].BaseBuildDatas = {}
        CreateBlockDataTable(collectionID)
    end
    --
    if BuildDataStack[collectionID].BaseBuildDatas[blockID] then
        BuildDataStack[collectionID].BaseBuildDatas[blockID]:Refresh(data)
        return false
    else
        --具体Model可根据建筑类型typeID重写BaseBuildModel
        BuildDataStack[collectionID].BaseBuildDatas[blockID] = BaseBuildModel:new(data)
        return true
    end
end

--功能
--  刷新商业建筑集合的详细数据--
--参数
--  data:某个建筑详情数据（protobuf）
function DataManager.RefreshDetailBuildData(data,buildTypeClass)
    --数据判空处理
    local blockID
    if data.id ~= nil then
        blockID = data.id
    elseif data.x ~= nil and data.y ~= nil then
        blockID =TerrainManager.PositionTurnBlockID(Vector3.New(data.x,0,data.y))
    else
        return
    end
    --
    if nil ==  BuildDataStack.DetailDataModels  then
        BuildDataStack.DetailDataModels = {}
    end
    --
    if BuildDataStack.DetailDataModels[blockID] then
        BuildDataStack.DetailDataModels[blockID]:Refresh(data)
    else
        BuildDataStack.DetailDataModels[blockID] = buildTypeClass:new(data)
    end
end

--功能
--  删除整个地块集合数据
--      相机移动时触发
--参数
--  tempCollectionID：删除地块的ID
function DataManager.RemoveCollectionDatas(tempCollectionID)
    --删除 BlockDatas 和 BaseBuildDatas 对应的数据
    --关闭所有基础数据Model
    for key, value in pairs(BuildDataStack[tempCollectionID].BaseBuildDatas) do
        value:Close()
    end
    BuildDataStack[tempCollectionID] = nil
end

--建筑根节点的唯一ID
function DataManager.GetBaseBuildDataByID(blockID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    return BuildDataStack[collectionID].BaseBuildDatas[blockID]
end

--获取block地块所属建筑的根节点ID
--如果没有建筑覆盖，值为-1
function DataManager.GetBlockDataByID(blockID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if BuildDataStack[collectionID] ~= nil  then
        return BuildDataStack[collectionID].BlockDatas[blockID]
    else
        return nil
    end
end
---------------------------------------------------------------------------------- 用户信息---------------------------------------------------------------------------------


function  DataManager.InitPersonDatas(tempData)
    --网络回调注册 网络回调用n开头
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"), DataManager.n_OnReceivePersonMessage)
end













---------------------------------------------------------------------------------- 临时数据---------------------------------------------------------------------------------









--注册所有消息回调
local function InitialEvents()
    Event.AddListener("c_RoleLoginDataInit", DataManager.InitPersonDatas);
end

--清除所有消息回调
local function ClearEvents()
    
end


--DataManager初始化
function DataManager.Init()
    InitialEvents()
    --土地拍卖Model
    SystemDatas.GroundAuctionModel  = GroundAuctionModel.New()
    if SystemDatas.GroundAuctionModel ~= nil then
        SystemDatas.GroundAuctionModel:Awake()
    end
end

function DataManager.Close()

end






--[[
-----------------------------------------------------------------Old
--查询基础地形数据
--BlockID
function DataManager.QueryBaseBuildData(tempID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(tempID)
    if nil ~= BuildDataStack[collectionID] and nil ~= BuildDataStack[collectionID][tempID] then
        return BuildDataStack[collectionID][tempID]
    end
    return nil
end

--刷新基础地形数据
--data:某个建筑基础数据（protobuf）
function  DataManager.RefreshBaseBuildData(data)
    data.id =TerrainManager.PositionTurnBlockID(Vector3.New(data.x,0,data.y))
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(data.id)
    if nil == BuildDataStack[collectionID] then
        BuildDataStack[collectionID] = {}
    end
    if BuildDataStack[collectionID][data.id] then
        BuildDataStack[collectionID][data.id].BaseData:Refresh(data)
        return false
    else
        --具体Model可根据建筑类型typeID重写BaseBuildModel
        BuildDataStack[collectionID][data.id] ={ BaseData = BaseBuildModel:new(data) }
        return true
    end
end

--刷新详细地形数据
--data:某个建筑详细数据（protobuf）
--buildTypeClass:建筑类型
function DataManager.RefreshDetailBuildData(data,buildTypeClass)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(data.id)
    if not BuildDataStack[collectionID] then
        BuildDataStack[collectionID] = {}
    end
    if BuildDataStack[collectionID][data.id] then
        BuildDataStack[collectionID][data.id].DetailData:Refresh(data)
    else
        BuildDataStack[collectionID][data.id] ={ DetailData = buildTypeClass:new(data) }
    end
end

--清除某个地块集合信息
function DataManager.CloseBuildCollectionDataByID(collectionID)
    if  BuildDataStack[collectionID] then
        for key, value in pairs(BuildDataStack[collectionID]) do
            if value.BaseData then
                value.BaseData:Clear()
            end
            if value.DetailData then
                value.DetailData:Clear()
            end
            value = nil
        end
        BuildDataStack[collectionID] = nil
    end
end

--清除某个建筑基础信息
function DataManager.CloseBaseBuildDataByID(id)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(id)
    if  BuildDataStack[collectionID] and BuildDataStack[collectionID][id] and BuildDataStackp[collectionID][id].BaseData then
        BuildDataStack[collectionID][id].BaseData:Clear()
        BuildDataStack[collectionID][id].BaseData = nil
    end
end

--清除某个建筑详细信息
function DataManager.CloseDetailBuildDataByID(id)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(id)
    if BuildDataStack[collectionID] and BuildDataStack[collectionID][id] and BuildDataStack[collectionID][id].DetailData then
        BuildDataStack[collectionID][id].DetailData:Clear()
        BuildDataStack[collectionID][id].DetailData = nil
    end
end

--清除所有数据
function  DataManager.ClearAllDatas(dataTable)
    for key, value in pairs(dataTable) do
        value = nil
    end
end

--]]
