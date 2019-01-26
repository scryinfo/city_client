FOWManager = {}

local function BlockPosTurnFowPos(tempPos)
    return tempPos - TerrainConfig.TerrainAttribute.FOWCenterPos
end

--刷新迷雾范围
--tempPos 迷雾中心位置
--tempRadius 半径大小
function FOWManager.RefreshFOWRangeByBlockPos(tempPos,tempRadius)
    Battle.FOWLogic.instance:ChangeFogOfWarRange(BlockPosTurnFowPos(tempPos), tempRadius)
    FOWSystem.instance.enableSystem = true
end

--还原最大迷雾范围
function FOWManager.BackToMaxFowRange()
    Battle.FOWLogic.instance:ChangeFogOfWarRange(Vector3.zero ,TerrainConfig.TerrainAttribute.FOWRange)
    FOWSystem.instance.enableSystem = true
end