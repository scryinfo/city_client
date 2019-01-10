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
local TerrainRangeSize = 1000
local CollectionRangeSize = 20
local RoadRootObj


DataManager.TempDatas ={ constructObj = nil, constructID = nil, constructPosID = nil}

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
--  刷新某个原子地块的基本信息
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RefreshBlockData(blockID,nodeID)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(blockID)
    if nodeID == nil then
        nodeID = -1
    end
    if  BuildDataStack[collectionID] == nil then
        BuildDataStack[collectionID] = {}
    end
    if BuildDataStack[collectionID].BlockDatas == nil then
        BuildDataStack[collectionID].BlockDatas = {}
    end
    BuildDataStack[collectionID].BlockDatas[blockID] = nodeID
    --[[
    if  BuildDataStack[collectionID] ~= nil and   BuildDataStack[collectionID].BlockDatas~= nil then
        BuildDataStack[collectionID].BlockDatas[blockID] = nodeID
    end--]]
end

--刷新原子地块集合的基本信息
--nodeID： 根节点ID
--nodeSize： 根节点范围
--nodeSize： 根节点值
function DataManager.RefreshBlockDataWhenNodeChange(nodeID,nodeSize,nodeValue)
    local idList =  DataManager.CaculationTerrainRangeBlock(nodeID,nodeSize)
    for key, value in ipairs(idList) do
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


-------------------------------------------------------------------------------------道路数据集合--------------------------------
--功能
--  依据BlockDatas创建道路的基础数据，管理GameObject
--参数
--  tempCollectionID: 所属地块集合ID
function DataManager.RefreshWaysByCollectionID(tempCollectionID)
    if BuildDataStack[tempCollectionID] == nil or BuildDataStack[tempCollectionID].BlockDatas == nil then
        return
    end
    if not BuildDataStack[tempCollectionID].RoteDatas then
        BuildDataStack[tempCollectionID].RoteDatas = {}
    end
    for itemBlockID, itemNodeID in pairs(BuildDataStack[tempCollectionID].BlockDatas) do
        if itemNodeID == -1 then
            local roadNum = DataManager.CalculateRoadNum(tempCollectionID,itemBlockID)
            --如果有道路数据
            if roadNum > 0 and roadNum < #RoadNumConfig  then
                if not BuildDataStack[tempCollectionID].RoteDatas[itemBlockID] then
                    BuildDataStack[tempCollectionID].RoteDatas[itemBlockID] ={}
                else
                    if BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadNum ==  roadNum then
                        break
                    else
                        --删除之前的道路Obj
                        destroy(BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadObj)
                        BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadObj = nil
                    end
                end
                BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadNum = roadNum
                local prefab = UnityEngine.Resources.Load(RoadPrefabConfig[RoadNumConfig[roadNum]])
                local go = UnityEngine.GameObject.Instantiate(prefab)
                if nil ~= RoadRootObj then
                    go.transform:SetParent(RoadRootObj.transform)
                end
                --add height
                local Vec = TerrainManager.BlockIDTurnPosition(itemBlockID)
                Vec.y = Vec.y + 0.01
                go.transform.position = Vec
                BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadObj = go
            --如果没有道路数据，但原先有道路记录，则清除
            elseif  roadNum == 0 and BuildDataStack[tempCollectionID].RoteDatas[itemBlockID] ~= nil and BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadObj ~= nil then
                destroy(BuildDataStack[tempCollectionID].RoteDatas[itemBlockID].roadObj)
                BuildDataStack[tempCollectionID].RoteDatas[itemBlockID] = nil
            end
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
        destroy(BuildDataStack[tempCollectionID].RoteDatas[key].roadObj)
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
                if BuildDataStack[tempCollectionID].BlockDatas[value.ID] ~= -1 then
                    roadNum  = roadNum + value.Num
                end
            else
                local ItemCollectionID =  TerrainManager.BlockIDTurnCollectionID(value.ID)
                if BuildDataStack[ItemCollectionID] ~= nil and BuildDataStack[ItemCollectionID].BlockDatas ~= nil and BuildDataStack[ItemCollectionID].BlockDatas[value.ID] and BuildDataStack[ItemCollectionID].BlockDatas[value.ID] ~= -1  then
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
    if nil == BuildDataStack[collectionID] then
        BuildDataStack[collectionID] = {}
        --初始化地块集合
        BuildDataStack[collectionID].BaseBuildDatas = {}
        CreateBlockDataTable(collectionID)
    end
    --TODO:检查数据初始化
    if BuildDataStack[collectionID].BaseBuildDatas == nil then
        --初始化地块集合
        BuildDataStack[collectionID].BaseBuildDatas = {}
        CreateBlockDataTable(collectionID)
    end
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
        --其实无意义，此句可删除
        BuildDataStack[tempCollectionID].BlockDatas = nil
    end
    --删除所有道路信息数据（RoteDatas）
    DataManager.RemoveWaysByCollectionID(tempCollectionID)
    --删除所有地块信息BaseGroundModel（GroundDatas）
    if BuildDataStack[tempCollectionID].GroundDatas ~= nil  then
        for key, value in pairs(BuildDataStack[tempCollectionID].GroundDatas) do
            value:Close()
        end
        --其实无意义，此句可删除
        BuildDataStack[tempCollectionID].GroundDatas = nil
    end
    --删除所有基础数据BaseBuildModel（BaseBuildDatas）
    if BuildDataStack[tempCollectionID].BaseBuildDatas ~= nil  then
        for key, value in pairs(BuildDataStack[tempCollectionID].BaseBuildDatas) do
            value:Close()
        end
        --其实无意义，此句可删除
        BuildDataStack[tempCollectionID].BaseBuildDatas = nil
    end
    --清空这个节点（这个才有意义）
    BuildDataStack[tempCollectionID] = nil
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
    if (tempController or tempController[modelMethord]) and tempController.m_data and tempController.m_data.insId == insId  then
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
--protoAnaStr:  0
--callBackMethord： 具体回调函数(参数为已解析)
--InstantiateSelf: 仅针对非建筑详情Model使用，传入对应的ID值
function DataManager.ModelRegisterNetMsg(insId,protoNameStr,protoNumStr,protoAnaStr,callBackMethord,InstantiateSelf)
    if not ModelNetMsgStack[protoNameStr] then
        ModelNetMsgStack[protoNameStr] = {}
    end
    if not ModelNetMsgStack[protoNameStr][protoNumStr] or type(ModelNetMsgStack[protoNameStr][protoNumStr]) ~= "table" then
        ModelNetMsgStack[protoNameStr][protoNumStr] = {}
        --注册分发函数
        CityEngineLua.Message:registerNetMsg(pbl.enum(protoNameStr,protoNumStr),function (stream)
            local protoData = assert(pbl.decode(protoAnaStr, stream), "")
            if protoData then
                local protoID = nil
                if (protoData.info and protoData.info.id )then
                    protoID = protoData.info.id
                elseif protoData.buildingId then
                    protoID = protoData.buildingId
                end
                if protoID ~= nil then--服务器返回的数据有唯一ID
                    for key, call in pairs(ModelNetMsgStack[protoNameStr][protoNumStr]) do
                        if key == protoID then
                            for i, func in pairs(ModelNetMsgStack[protoNameStr][protoNumStr][key]) do
                                if BuildDataStack.DetailModelStack[protoID] then
                                    func(BuildDataStack.DetailModelStack[protoID],protoData)
                                else
                                    func(protoData)
                                end
                            end
                            return
                        end
                    end
                else--服务器返回的数据没有唯一ID
                    if ModelNetMsgStack[protoNameStr][protoNumStr]["NoParameters"] ~= nil  then
                        for i, funcTable in pairs(ModelNetMsgStack[protoNameStr][protoNumStr]["NoParameters"]) do
                            if funcTable.self ~= nil then
                                funcTable.func(funcTable.self,protoData)
                            else
                                funcTable.func(protoData)
                            end
                        end
                    end
                end
            else
                ct.log("System","解析服务器返回的建筑详情中数据失败")
            end
            ct.log("System","没有找到对应的建筑详情Model类的回调函数")
        end)
    end
    --依据有无唯一ID，存储回调方法
    if  insId ~= nil then --若有唯一ID，则将方法写到唯一ID对应的table中
        if ModelNetMsgStack[protoNameStr][protoNumStr][insId] == nil then
            ModelNetMsgStack[protoNameStr][protoNumStr][insId] = {}
        end
        table.insert(ModelNetMsgStack[protoNameStr][protoNumStr][insId],callBackMethord)
    else--若无唯一ID，则将方法写到"NoParameters"对应的table中
        if  ModelNetMsgStack[protoNameStr][protoNumStr]["NoParameters"] == nil then
            ModelNetMsgStack[protoNameStr][protoNumStr]["NoParameters"] = {}
        end
        local funcTable = {}
        funcTable.func = callBackMethord
        if InstantiateSelf ~= nil then
            funcTable.self = InstantiateSelf
        end
        table.insert(ModelNetMsgStack[protoNameStr][protoNumStr]["NoParameters"],funcTable)

    end
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
    PersonDataStack.m_groundInfos = tempData.ground
    --获取自己所有的建筑详情
    PersonDataStack.m_buysBuilding = tempData.buys or {}
    --初始化自己中心仓库的建筑ID
    PersonDataStack.m_bagId = tempData.bagIds
    --初始化自己的money
    PersonDataStack.m_money = tempData.money
    --初始化自己的name
    PersonDataStack.m_name = tempData.name
    --初始化自己所拥有建筑（购买的土地）
    PersonDataStack.m_buysBuild = tempData.buys
    --初始化自己所拥有建筑（租赁的土地）
    PersonDataStack.m_rentsBuild = tempData.rents

    --初始化自己的基本信息
    PersonDataStack.m_roleInfo =
    {
        id = tempData.id,
        name = tempData.name,
        companyName = tempData.companyName,
        male = tempData.male,
        des = tempData.des,
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
end

--添加/修改自己所拥有土地
function DataManager.AddMyGroundInfo(groundInfoData)
    --检查自己所拥有地块集合有没有该地块
    if PersonDataStack.m_groundInfos then
        for key, value in pairs(PersonDataStack.m_groundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y then
                PersonDataStack.m_groundInfos[key] = groundInfoData
                return
            end
        end
    else
        PersonDataStack.m_groundInfos = {}
    end
    table.insert(PersonDataStack.m_groundInfos,groundInfoData)
end

--删除自己所拥有土地
function DataManager.RemoveMyGroundInfo(groundInfoData)
    if PersonDataStack.m_groundInfos then
        for key, value in ipairs(PersonDataStack.m_groundInfos) do
            if value.x == groundInfoData.x and value.y == groundInfoData .y then
                table.remove(PersonDataStack.m_groundInfos,key)
            end
        end
    end
end

function DataManager.GetMyOwnerID()
    return PersonDataStack.m_owner
end

--获取中心仓库Id
function DataManager.GetBagId()
    return PersonDataStack.m_bagId
end

--获取自己的money
function DataManager.GetMoney()
    return PersonDataStack.m_money
end

--获取自己的名字
function DataManager.GetName()
    return PersonDataStack.m_name
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


--判断该地块是不是自己的
function DataManager.IsOwnerGround(tempPos)
    local tempGridIndex =  { x = math.floor(tempPos.x) , y = math.floor(tempPos.z) }
    for key, value in pairs(PersonDataStack.m_groundInfos) do
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

--判断所有范围内地块允不允许改变
function DataManager.IsALlEnableChangeGround(startBlockID,tempsize)
    local idList = DataManager.CaculationTerrainRangeBlock(startBlockID,tempsize)
    for key, value in ipairs(idList) do
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
--注册所有消息回调
local function InitialEvents()
    Event.AddListener("c_RoleLoginDataInit", DataManager.InitPersonDatas)
    --Event.AddListener("c_GroundInfoChange", DataManager.InitPersonDatas)
   -- Event.AddListener("m_QueryPlayerInfo", this.m_QueryPlayerInfo)
end

--注册所有网络消息回调
local function InitialNetMessages()
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addBuilding"), DataManager.n_OnReceiveAddBuilding)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitCreate"), DataManager.n_OnReceiveUnitCreate)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitRemove"), DataManager.n_OnReceiveUnitRemove)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitChange"), DataManager.n_OnReceiveUnitChange)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","groundChange"), DataManager.n_OnReceiveGroundChange)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addFriendReq"), DataManager.n_OnReceiveAddFriendReq)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addFriendSucess"), DataManager.n_OnReceiveAddFriendSucess)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","getBlacklist"), DataManager.n_OnReceiveGetBlacklist)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryPlayerInfo"), DataManager.n_OnReceivePlayerInfo)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","labRoll"), DataManager.n_OnReceiveLabRoll)  --研究所Roll失败消息
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","newItem"), DataManager.n_OnReceiveNewItem)  --研究所新的东西呈现
    CityEngineLua.Message:registerNetMsg(pbl.enum("common.OpCode","error"), DataManager.n_OnReceiveErrorCode)  --错误消息处理
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleCommunication"),DataManager.n_OnReceiveRoleCommunication)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleStatusChange"),DataManager.n_OnReceiveRoleStatusChange)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","deleteFriend"),DataManager.n_OnReceiveDeleteFriend)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","deleteBlacklist"),DataManager.n_DeleteBlacklist)
end

--清除所有消息回调
local function ClearEvents()
    
end

--DataManager初始化
function DataManager.Init()
    RoadRootObj = find("Road")
    InitialEvents()
    InitialNetMessages()
    --土地拍卖Model
    SystemDatas.GroundAuctionModel  = GroundAuctionModel.New()
    if SystemDatas.GroundAuctionModel ~= nil then
        SystemDatas.GroundAuctionModel:Awake()
    end
    ------------------------------------打开相机
    local cameraCenter = UnityEngine.GameObject.New("CameraTool")
    local luaCom = CityLuaUtil.AddLuaComponent(cameraCenter,'Terrain/CameraMove')
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
    --完成删除(注：删除自己的建筑回调，需做本地自己拥有建筑的删除)
    local removeInfo = assert(pbl.decode("gs.UnitRemove", stream), "DataManager.n_OnReceiveUnitRemove: stream == nil")
    if removeInfo ~= nil and removeInfo.id ~= nil and removeInfo.x ~= nil and removeInfo.y ~= nil then
        local tempBlockID = TerrainManager.GridIndexTurnBlockID(removeInfo)
        local tempCollectionID =  TerrainManager.BlockIDTurnCollectionID(tempBlockID)
        if BuildDataStack[tempCollectionID] ~= nil and BuildDataStack[tempCollectionID].BlockDatas and BuildDataStack[tempCollectionID].BlockDatas[tempBlockID] ~= nil then
            BuildDataStack[tempCollectionID].BaseBuildDatas[tempBlockID]:Close()
            --TODO：计算在当前AOI所有地块中 需要刷新的地块
            --刷新需要刷新的地块
            for key, value in pairs(TerrainManager.GetCameraCollectionIDAOIList()) do
                DataManager.RefreshWaysByCollectionID( value)
            end
        end
    end
end

--接收服务器地块信息数据
function DataManager.n_OnReceiveGroundChange(stream)
    local GroundChange = assert(pbl.decode("gs.GroundChange", stream), "DataManager.n_OnReceiveUnitRemove: stream == nil")
    if GroundChange ~= nil and GroundChange.info ~= nil then
        for key, value in pairs(GroundChange.info) do
            --如果地块所有人是自己的话，写进自己所拥有地块集合
            if nil ~= PersonDataStack.m_owner and value.ownerId  == PersonDataStack.m_owner then
                DataManager.AddMyGroundInfo(value)
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
            else
                BuildDataStack[tempGroundCollectionID].GroundDatas[tempGroundBlockID]  = BaseGroundModel:new(value)
            end
        end
    end
end

-- 接收好友申请
function DataManager.n_OnReceiveAddFriendReq(stream)
    local requestFriend = assert(pbl.decode("gs.RequestFriend", stream), "DataManager.n_OnReceiveAddFriendReq: stream == nil")
    if not requestFriend or not requestFriend.id then
        return
    end
    DataManager.SetMyFriendsApply(requestFriend)
    Event.Brocast("c_OnReceiveAddFriendReq", requestFriend)
end

-- 接收好友添加成功申请
function DataManager.n_OnReceiveAddFriendSucess(stream)
    local friend = assert(pbl.decode("gs.RoleInfo", stream), "DataManager.n_OnReceiveAddFriendSucess: stream == nil")
    if not friend or not friend.id then
        return
    end
    friend.b = true
    DataManager.SetMyFriends(friend)
    DataManager.SetMyFriendsApply({id = friend.id})
    Event.Brocast("c_OnReceiveAddFriendSucess", friend)
end

-- 接收黑名单
function DataManager.n_OnReceiveGetBlacklist(stream)
    local roleInfos = assert(pbl.decode("gs.RoleInfos", stream), "DataManager.n_OnReceiveGetBlacklist: stream == nil")
    if not roleInfos.info then
        return
    end
    for _, v in ipairs(roleInfos.info) do
        if v then
            DataManager.SetMyBlacklist(v)
        end
    end
end

--查询玩家信息返回
function DataManager.n_OnReceivePlayerInfo(stream)
    local playerData = assert(pbl.decode("gs.RoleInfos", stream), "DataManager.n_OnReceivePlayerInfo: stream == nil")
    --for _, v in ipairs(playerData.info) do
    --    DataManager.SetMyFriendsInfo(v)
    --end
    Event.Brocast("c_OnReceivePlayerInfo", playerData)
    Event.Brocast("c_receiveOwnerDatas",playerData.info[1])

    Event.Brocast("c_GroundTranReqPlayerInfo", playerData)  --土地交易部分请求玩家数据

end

--研究所Roll回复信息
function DataManager.n_OnReceiveLabRoll(stream)
    Event.Brocast("c_LabRollSuccess")
end

--发明研究成功  --用来更新玩家数据
function DataManager.n_OnReceiveNewItem(stream)
    local data = assert(pbl.decode("gs.IntNum", stream), "DataManager.n_OnReceiveNewItem: stream == nil")
    if data then
        DataManager.SetMyGoodLv(data)
    end
end

--处理错误信息
--研究所Roll回复信息
function DataManager.n_OnReceiveErrorCode(stream)
    local data = assert(pbl.decode("common.Fail", stream), "DataManager.n_OnReceiveNewItem: stream == nil")
    if data then
        ct.log("cycle_w15_laboratory03", "---- error opcode："..data.opcode)
        if data.opcode == 1157 then  --研究所roll失败
            local info = {}
            info.titleInfo = "FAIL"
            info.contentInfo = "Roll Fail"
            info.tipInfo = ""
            ct.OpenCtrl("BtnDialogPageCtrl", info)
        elseif data.opcode == 5015 then  --世界发言失败
            if data.reason == "highFrequency" then
                Event.Brocast("SmallPop","Speeches are frequent. Please wait a moment.",80)
            elseif data.reason == "notAllow" then
                Event.Brocast("SmallPop","Has been shielded.",60)
            end
        end
    end
end


----------

-- 收到服务器的聊天消息
function DataManager.n_OnReceiveRoleCommunication(stream)
    local chatData = assert(pbl.decode("gs.CommunicationProces", stream), "ChatModel.n_OnReceiveRoleCommunication: stream == nil")
    DataManager.SetMyChatInfo(chatData)
    Event.Brocast("c_OnReceiveRoleCommunication", chatData)
end

-- 好友在线状态刷新
function DataManager.n_OnReceiveRoleStatusChange(stream)
    local roleData = assert(pbl.decode("gs.ByteBool", stream), "ChatModel.n_OnReceiveRoleStatusChange: stream == nil")
    DataManager.SetMyFriends(roleData)
    Event.Brocast("c_OnReceiveRoleStatusChange", roleData)
end

-- 收到删除好友信息
function DataManager.n_OnReceiveDeleteFriend(stream)
    local friendsId = assert(pbl.decode("gs.Id", stream), "DataManager.n_OnReceiveDeleteFriend: stream == nil")
    DataManager.SetMyFriends({ id = friendsId.id, b = nil })
    Event.Brocast("c_OnReceiveDeleteFriend", friendsId)
end

-- 解除屏蔽返回
function DataManager.n_DeleteBlacklist(stream)
    local friendsId = assert(pbl.decode("gs.Id", stream), "DataManager.n_DeleteBlacklist: stream == nil")
    DataManager.SetMyBlacklist({ id = friendsId.id })
    Event.Brocast("c_DeleteBlacklist", friendsId)
end
----------