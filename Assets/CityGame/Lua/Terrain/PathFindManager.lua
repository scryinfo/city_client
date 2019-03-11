PathFindManager = {}

local m_AllPlayer = {}

local Math_Random = math.random
local Math_Floor = math.floor
local my_CreatedCollectionID = {}

function PathFindManager.Init()
    --初始化随机种子
    math.randomseed(os.time())
    m_AllPlayer = {}
end

--创建角色
local function CreateRangePalyer(tempCollectionID,PlayerCount)
    if tempCollectionID == nil or PlayerCount == nil or  PlayerCount <= 0  then
        return
    end
    --获取路径表
    local tempPathTable = DataManager.GetPathDatas(tempCollectionID)
    if tempPathTable == nil then
        return
    end
    --初始化一张可用初始化位置的ID表（数组）
    local CanUsedIDPath = {}
    for id, value in pairs(tempPathTable) do
        if value ~= 0 then
            CanUsedIDPath[#CanUsedIDPath+1] = id
        end
    end
    --判断是否有多于一个的位置
    --TODO：此处应该做可生成位置和生成个数的比例关系判断（or根据可生成位置来生成个数）
    if #CanUsedIDPath <= 0 then
        return
    end
    local tempPlayerSet,targerBlockID,tempStartPos,tempPalyer
    for i = 1, PlayerCount do
        tempPlayerSet = PathFindingConfig[Math_Random(1,#PathFindingConfig)]
        targerBlockID = CanUsedIDPath[Math_Random(1,#CanUsedIDPath)]
        --tempStartPos = TerrainManager.BlockIDTurnPosition(targerBlockID)
        tempPalyer = PathFindItem:new(tempPlayerSet.poolName,targerBlockID,tempPlayerSet.playerEdgeDistance)
        ct.log("system","生成一个角色")
        table.insert(m_AllPlayer,tempPalyer)
    end
    my_CreatedCollectionID[tempCollectionID] = 1
end

--删除在地块上的角色
local function RemoveRangePlayers(tempCollectionID)
    --向所有角色遍历询问位置，在范围内的删除
    local playerPos,playerBlockID,playerCollectionID
    for i,player in pairs(m_AllPlayer) do
        playerPos = player:ReportPosition()
        if playerPos~= nil then
            playerBlockID = TerrainManager.PositionTurnBlockID(playerPos)
            playerCollectionID = TerrainManager.BlockIDTurnCollectionID(playerBlockID)
            if tempCollectionID == playerCollectionID then
                player:Destory()
                table.remove(m_AllPlayer,i)
            end
        end
    end
    my_CreatedCollectionID[tempCollectionID] = nil
end

--AOI时生成新的
function PathFindManager.CreateAOIListPalyer(tempCollectionIDList)
    if tempCollectionIDList == nil or type(tempCollectionIDList) ~= 'table' then
        return
    end
    if  my_CreatedCollectionID[tempCollectionID] ~= nil then
        return
    end
    local count = 0
    for i, tempCollectionID in pairs(tempCollectionIDList) do
        --TODO:随机个数范围应该从配置表中读取
        count =  Math_Random(10,20)
        CreateRangePalyer(tempCollectionID,count)
    end
end

--AOI时计算是否删除
function PathFindManager.RemoveAOIListPalyer(tempCollectionIDList)
    if tempCollectionIDList == nil or type(tempCollectionIDList) ~= 'table' then
        return
    end
    for i, tempCollectionID in pairs(tempCollectionIDList) do
        RemoveRangePlayers(tempCollectionID)
    end
end

--计算路径值，返回路径值的拆分点的
function PathFindManager.CalculatePathValues(tempNum)
    tempNum = tempNum % 100
    if tempNum <= 0 or tempNum >15 then
        return nil
    end
    local returnValue = 0
    local tempTable = {}
    local tempSize = 8
    for i = 1, 4  do
        returnValue = Math_Floor(tempNum / tempSize)
        if returnValue ~= 0 then
            tempTable[tempSize] = tempSize
        end
        tempNum = tempNum % tempSize
        tempSize = tempSize / 2
    end
    return tempTable
end

--计算内部不能移动的路径
function PathFindManager.CalculatePathCanNotMove(tempNum)
    local tempTable = {}
    if tempNum < 100  then
        return tempTable
    end
    local returnValue = 0
    local tempSize = 800
    for i = 1, 4  do
        returnValue = Math_Floor(tempNum / tempSize)
        if returnValue ~= 0 then
            tempTable[tempSize] = tempSize
        end
        tempNum = tempNum % tempSize
        tempSize = tempSize / 2
    end
    return tempTable
end