PathFindManager = {}

local m_AllPlayer = {}
local idCount = 1
local Math_Random = math.random
local Math_Floor = math.floor
local my_CreatedCollectionID = {}

function PathFindManager.Init()
    --Initialize random seed
    math.randomseed(os.time())
    m_AllPlayer = {}
    idCount = 1
end

--Creating a Role
local function CreateRangePalyer(tempCollectionID,PlayerCount)
    if tempCollectionID == nil or PlayerCount == nil or  PlayerCount <= 0  then
        return
    end
    --Get route table
    local tempPathTable = DataManager.GetPathDatas(tempCollectionID)
    if tempPathTable == nil then
        return
    end
    --Initialize a table (array) of available initialization positions
    local CanUsedIDPath = {}
    for id, value in pairs(tempPathTable) do
        if value ~= 0 then
            CanUsedIDPath[#CanUsedIDPath+1] = id
        end
    end
    -- judge whether there is more than one location
    --The ratio between the position and the number of generations should be judged here (the number is generated according to the position that can be generated)
    if #CanUsedIDPath <= 0 then
        return
    end
    local tempPlayerSet,targerBlockID,tempStartPos,tempPalyer
    for i = 1, PlayerCount do
        tempPlayerSet = PathFindingConfig[Math_Random(1,#PathFindingConfig)]
        targerBlockID = CanUsedIDPath[Math_Random(1,#CanUsedIDPath)]
        tempPalyer = PathFindItem:new(tempPlayerSet.poolName,targerBlockID,tempPlayerSet.playerEdgeDistance,idCount,tempPlayerSet.poolType)
        m_AllPlayer[idCount] = tempPalyer
        idCount = idCount + 1
    end
    my_CreatedCollectionID[tempCollectionID] = 1
end




--Delete the character on the plot
local function RemoveRangePlayers(tempCollectionID)
    --Ask all the characters to traverse to ask the location, delete within the range
    local playerPos,playerBlockID,playerCollectionID
    for i,player in pairs(m_AllPlayer) do
        playerPos = player:ReportPosition()
        if playerPos~= nil then
            playerBlockID = TerrainManager.PositionTurnBlockID(playerPos)
            playerCollectionID = TerrainManager.BlockIDTurnCollectionID(playerBlockID)
            if tempCollectionID == playerCollectionID then
                player:Destory()
                m_AllPlayer[i] = nil
            end
        end
    end
    my_CreatedCollectionID[tempCollectionID] = nil
end

--When AOI generating new
function PathFindManager.CreateAOIListPalyer(tempCollectionIDList)
    if tempCollectionIDList == nil or type(tempCollectionIDList) ~= 'table' then
        return
    end
    local count = 0
    for i, tempCollectionID in pairs(tempCollectionIDList) do
        --TODO:Random number range should be read from the configuration 
        if my_CreatedCollectionID[tempCollectionID] == nil then
            count =  Math_Random(70,80)
            CreateRangePalyer(tempCollectionID,count)
        end
    end
end

--When aoi calculating whether to delete
function PathFindManager.RemoveAOIListPalyer(tempCollectionIDList)
    if tempCollectionIDList == nil or type(tempCollectionIDList) ~= 'table' then
        return
    end
    for i, tempCollectionID in pairs(tempCollectionIDList) do
        RemoveRangePlayers(tempCollectionID)
    end
end

--Delete a specific role
function PathFindManager.RemoveThePalyerByInsID(InsID)
    if m_AllPlayer[InsID] ~= nil then
        m_AllPlayer[InsID]:Destory()
        m_AllPlayer[InsID] = nil
    end
end

--Calculate the path value and return the split point of the path value
function PathFindManager.CalculatePathValues(tempNum)
    local tempTable = {}
    if tempNum == nil then
        return tempTable
    end
    tempNum = tempNum % 100
    if tempNum <= 0 or tempNum >15 then
        return nil
    end
    local returnValue = 0
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

--Calculate internal immovable paths
function PathFindManager.CalculatePathCanNotMove(tempNum)
    local tempTable = {}
    if tempNum == nil or tempNum < 100  then
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