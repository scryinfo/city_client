FOWManager = {}

local FowRadius = 500
local FowRangeCenter = Vector3.New(500,0,500) --const值


local function BlockPosTurnFowPos(tempPos)
    return tempPos - FowRangeCenter
end


--刷新迷雾范围
--tempPos 迷雾中心位置
--tempRadius 半径大小
function FOWManager.RefreshFOWRangeByBlockPos(tempPos,tempRadius)
    --Battle.FOWLogic.instance:ChangeFogOfWarRange(BlockPosTurnFowPos(tempPos), tempRadius)
    --FOWSystem.instance.enableSystem = true
end

--还原最大迷雾范围
function FOWManager.BackToMaxFowRange()
    --Battle.FOWLogic.instance:ChangeFogOfWarRange(Vector3.zero ,FowRadius)
    --FOWSystem.instance.enableSystem = true
end