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
--  a.当前操作状态（Enum TouchState{ NormalState = 0，//正常状态（可拖拽点击状态）   ConstructState = 2，//修建状态   UIState = 3，//UI查看状态   }）
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
-------------------------------原子地块数据--------------------------------
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
    for i = startBlockID, (startBlockID + TerrainRangeSize * (rangeSize - 1)),TerrainRangeSize  do
        for tempkey = i, (i + rangeSize - 1) do
            table.insert(idList, tempkey)
        end
    end
    return idList
end
-------------------------------道路数据集合--------------------------------
--功能
--  依据BlockDatas创建道路的基础数据，管理GameObject
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.CreateWaysByCollectionID(tempCollectionID)
    --TODO://
    if not BuildDataStack[tempCollectionID].RoteDatas then
        BuildDataStack[tempCollectionID].RoteDatas = {}
    end
    for itemBlockID, itemNodeID in ipairs(BuildDataStack[tempCollectionID].BlockDatas) do
        if itemNodeID == -1 then
            local roadNum = DataManager.CalculateRoadNum(tempCollectionID,itemNodeID)
            if roadNum ~= 0 then
                BuildDataStack[tempCollectionID].RoteDatas[itemNodeID].roadNum = roadNum
            end
        end
    end
end

--功能
--  依据BlockDatas刷新道路的基础数据，管理GameObject
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RefreshWaysByCollectionID(tempCollectionID)


end

--功能
-- 移除道路的基础数据，管理GameObject
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RemoveWaysByCollectionID(tempCollectionID)


end


local RoadAroundNumber = {
    FrontUpperItem = { Num = 2 },   --正上方
    FrontBelowItem = { Num = 8 },   --正下方
    LeftUpperItem = { Num = 16 },    --左上方
    LeftMiddleItem = { Num = 1 },   --正左方
    LeftBelowItem = { Num = 128 },    --左下方
    RightUpperItem ={ Num = 32 },    --右上方
    RightMiddleItem = { Num = 4 },  --正右方
    RightBelowItem = { Num = 64 },   --右下方
}
--功能
-- 移除道路的基础数据，管理GameObject
function DataManager.CalculateRoadNum(tempCollectionID,roadBlockID)
    local roadNum = 0
    for key, value in ipairs(RoadAroundNumber) do
        value.ID = nil
    end
    --边缘判定（上下不判定的原因是因为计算值的时候会被排除）
    if  roadBlockID % TerrainRangeSize ~= 0 then    --不靠地图右边边界--->右边一列
        RoadAroundNumber.RightBelowItem.ID = roadBlockID - TerrainRangeSize + 1
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
    for key, value in ipairs(RoadAroundNumber) do
        if value.ID then
            if BuildDataStack[tempCollectionID].BlockDatas[value.ID] then
                roadNum  = roadNum + value.ID
            else
                local ItemCollectionID =  TerrainManager.BlockIDTurnCollectionID(value.ID)
                if BuildDataStack[ItemCollectionID] and BuildDataStack[ItemCollectionID].BlockDatas[value.ID] then
                    roadNum  = roadNum + value.ID
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
        blockID =TerrainManager.PositionTurnBlockID(Vector3.New(data.x,0,data.y))
        data.posID = blockID
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

--[[
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
--]]
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

--获取DetailModel到管理器中
function DataManager.GetDetailModelByID(insId)
    if  BuildDataStack.DetailModelStack then
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
    if not BuildDataStack.DetailModelStack or not insId or not modelMethord  then
        return
    end
    local tempDetailModel = BuildDataStack.DetailModelStack[insId]
    if tempDetailModel or tempDetailModel[modelMethord] then
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
    if not BuildDataStack.DetailModelStack or not insId or not modelMethord or not callBackMethord then
        return
    end
    local tempDetailModel = BuildDataStack.DetailModelStack[insId]
    if tempDetailModel or tempDetailModel[modelMethord] then
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
    if not UIPage.static.m_allPages or  not insId or not modelMethord  then
        return
    end
    local tempController = UIPage.static.m_allPages[ctrlName]
    if (tempController or tempController[modelMethord]) and tempController.m_data.insId == insId  then
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
    if not UIPage.static.m_allPages or  not insId or not ctrlName or not modelMethord or not callBackMethord then
        return
    end
    local tempController = UIPage.static.m_allPages[ctrlName]
    if (tempController or tempController[modelMethord]) and tempController.insId == insId then
        callBackMethord(tempController[modelMethord](tempController,...))
    end
end

----------------------------------------------------------------------------------DetailModel的网络消息管理

local ModelNetMsgStack = {}

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

--DetailModel 注册消息回调
--参数：
--insId：Model唯一ID
--protoNameStr：protobuf表名
--protoNumStr:  protobuf协议号
--protoAnaStr:  protobuf解析数据结构名
--callBackMethord： 具体回调函数(参数为已解析)
function DataManager.ModelRegisterNetMsg(insId,protoNameStr,protoNumStr,protoAnaStr,callBackMethord)
    if not ModelNetMsgStack[protoNameStr] then
        ModelNetMsgStack[protoNameStr] = {}
    end
    if not ModelNetMsgStack[protoNameStr][protoNumStr] or type(ModelNetMsgStack[protoNameStr][protoNumStr]) ~= table then
        ModelNetMsgStack[protoNameStr][protoNumStr] = {}
        --注册分发函数
        CityEngineLua.Message:registerNetMsg(pbl.enum(protoNameStr,protoNumStr),function (stream)
            local protoData = assert(pbl.decode(protoAnaStr, stream), "")
            if protoData then
                local protoID = nil
                if (protoData.info and protoData.info.id )then
                    protoID = protoData.info.id
                elseif protoData.id then
                    protoID = protoData.id
                end
                if protoID then
                    for key, call in pairs(ModelNetMsgStack[protoNameStr][protoNumStr]) do
                        if key == protoID then
                            if BuildDataStack.DetailModelStack[protoID] then
                                call(BuildDataStack.DetailModelStack[protoID],protoData)
                            else
                                call(protoData)
                            end
                            return
                        end
                    end
                else
                    ct.log("System","服务器返回的建筑详情中数据没有唯一ID")
                end
            else
                ct.log("System","解析服务器返回的建筑详情中数据失败")
            end
            ct.log("System","没有找到对应的建筑详情Model类的回调函数")
        end)
    end
    ModelNetMsgStack[protoNameStr][protoNumStr][insId] = callBackMethord
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

---------------------------------------------------------------------------------- 用户信息---------------------------------------------------------------------------------

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
    --初始化个人唯一ID
    PersonDataStack.m_owner = tempData.id
    --初始化自己所拥有地块集合
    PersonDataStack.m_GroundInfos = tempData.ground
    --初始化自己所拥有建筑（购买的土地）
    PersonDataStack.m_buysBuild = tempData.buys
    --初始化自己所拥有建筑（租赁的土地）
    PersonDataStack.m_rentsBuild = tempData.rents
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
end

--修改自己所拥有土地集合
function DataManager.AddMyGroundInfo(groundInfoData)
    --检查自己所拥有地块集合有没有该地块
    if PersonDataStack.m_GroundInfos then
        for key, value in pairs(PersonDataStack.m_GroundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y then
                return
            end
        end
    else
        PersonDataStack.m_GroundInfos = {}
    end
    table.insert(PersonDataStack.m_GroundInfos,groundInfoData)
end

function DataManager.GetMyOwnerID()
    return PersonDataStack.m_owner
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

--刷新自己所拥有商品科技等级
--参数： tempData==>  IntNum
function DataManager.SetMyGoodLv(tempData)
    if tempData.id and tempData.num then
        PersonDataStack.m_goodLv[tempData.id] = tempData.num
    end
end

--获取自己好友信息
function DataManager.GetMyFriends()
    return PersonDataStack.m_friends
end

--刷新自己好友信息
--参数： tempData==>  ByteBool
--如果需要删除好友，ByteBool={ id = "XXXXXXXX",b = nil }
function DataManager.SetMyFriends(tempData)
    if tempData.id then
        PersonDataStack.m_friends[tempData.id] = tempData.b
    end
end

--判断该地块是不是自己的
function DataManager.IsOwnerGround(tempPos)
    local tempGridIndex =  { x = math.floor(tempPos.x) , y = math.floor(tempPos.z) }
    for key, value in pairs(PersonDataStack.m_GroundInfos) do
        if value.x == tempGridIndex.x and value.y == tempGridIndex.y then
            return true
        end
    end
    return false
end

function DataManager.IsAllOwnerGround(startBlockID,tempsize)
    local idList = DataManager.CaculationTerrainRangeBlock(startBlockID,tempsize)
    for key, value in ipairs(idList) do
        if not DataManager.IsOwnerGround(TerrainManager.BlockIDTurnPosition(value)) then
            return false
        end
    end
    return true
end

--判断该地块允不允许改变
function DataManager.IsEnableChangeGround(blockID)
    local blockdata = DataManager.GetBlockDataByID(blockID)
    if -1 ~= blockdata and nil ~= blockdata then
        return false
    else
        return true
    end
end

function DataManager.IsALlEnableChangeGround(startBlockID,tempsize)
    local idList = DataManager.CaculationTerrainRangeBlock(startBlockID,tempsize)
    for key, value in ipairs(idList) do
        if not DataManager.IsEnableChangeGround(value) then
            return false
        end
    end
    return true
end

---------------------------------------------------------------------------------- 临时数据---------------------------------------------------------------------------------

--注册所有消息回调
local function InitialEvents()
    Event.AddListener("c_RoleLoginDataInit", DataManager.InitPersonDatas)
    --Event.AddListener("c_GroundInfoChange", DataManager.InitPersonDatas)
end

--注册所有网络消息回调
local function InitialNetMessages()
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addBuilding"), DataManager.n_OnReceiveAddBuilding)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitCreate"), DataManager.n_OnReceiveUnitCreate)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitRemove"), DataManager.n_OnReceiveUnitRemove)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitChange"), DataManager.n_OnReceiveUnitChange)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","groundChange"), DataManager.n_OnReceiveGroundChange)
end
--清除所有消息回调
local function ClearEvents()
    
end


--DataManager初始化
function DataManager.Init()
    InitialEvents()
    InitialNetMessages()
    --土地拍卖Model
    SystemDatas.GroundAuctionModel  = GroundAuctionModel.New()
    if SystemDatas.GroundAuctionModel ~= nil then
        SystemDatas.GroundAuctionModel:Awake()
    end
    ----研究所Model
    --SystemDatas.LaboratoryModel  = LaboratoryModel.New()
    --if SystemDatas.LaboratoryModel ~= nil then
    --    SystemDatas.LaboratoryModel:Awake()
    --end
end

function DataManager.Close()
    ClearEvents()
end

----------------------------------------------------网络回调函数---------------------------------

function DataManager.n_OnReceiveAddBuilding(stream)
    local buildingInfo = assert(pbl.decode("gs.BuildingInfo", stream), "DataManager.n_OnReceiveAddBuilding: stream == nil")
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
    local UnitCreate = assert(pbl.decode("gs.UnitCreate", stream), "DataManager.n_OnReceiveUnitCreate: stream == nil")
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
    local buildingInfo = assert(pbl.decode("gs.BuildingInfo", stream), "DataManager.n_OnReceiveUnitChange: stream == nil")
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
    local buildingInfo = assert(pbl.decode("gs.Bytes", stream), "DataManager.n_OnReceiveUnitRemove: stream == nil")
    --buildingInfo  ==》BuildingInfo
    if not buildingInfo or not buildingInfo.mId then
        return
    end
    --此处因命名和层级问题，临时处理
    buildingInfo.buildingID = buildingInfo.mId
    buildingInfo.x = buildingInfo.pos.x
    buildingInfo.y = buildingInfo.pos.y
    TerrainManager.ReceiveArchitectureDatas({buildingInfo})
end


function DataManager.n_OnReceiveGroundChange(stream)
    local GroundChange = assert(pbl.decode("gs.GroundChange", stream), "DataManager.n_OnReceiveUnitRemove: stream == nil")
    --如果地块所有人是自己的话
    if not GroundChange or not GroundChange.info then
        return
    end
    for key, value in pairs(GroundChange.info) do
        if nil ~= PersonDataStack.m_owner and  value.ownerId  == PersonDataStack.m_owner then
            DataManager.AddMyGroundInfo(value)
        end
    end
end

----------

