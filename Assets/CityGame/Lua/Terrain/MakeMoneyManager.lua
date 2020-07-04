--Allen  2019/7/5
--Earning effect display manager
MakeMoneyManager = {}

--local data
local UIPool



---Func: Coordinate according to camera position
--TargetPos: the location of the target Vector3
--return: Camera Distance
local function CalculationPositionDistanceToCamera(TargetPos)

end

---Func: UI size performance conversion relationship caused by the distance from the camera
--CameraDis: camera distance number >= 0
--return: UI Scale
local function UICameraDistanceTurnScale(CameraDis)

end

---Func: Check if the UI is on the screen
--tempUIPos: UI coordinates Vector2
--tempWidthRange: Redundant range of UI width
--tempHeightRange: Redundant range of UI height
--return: true: in range false: not in range
local function CheckWhetherTheUIPositionIsOnTheScreen(tempUIPos,tempWidthRange,tempHeightRange)
    --Initialize tempWidthRange, and take the absolute value
    if tempWidthRange == nil then
        tempWidthRange = 0
    elseif tempWidthRange < 0 then
        tempWidthRange = - tempWidthRange
    end
    --Initialize tempHeightRange, and take the absolute value
    if tempHeightRange == nil then
        tempHeightRange = 0
    elseif tempHeightRange < 0 then
        tempHeightRange = - tempHeightRange
    end
    --Determine if UI coordinates are on the screen
    if tempUIPos.x < - tempWidthRange or tempUIPos.x > UnityEngine.Screen.width + tempWidthRange then
        return false
    elseif tempUIPos.y < - tempHeightRange or tempUIPos.y > UnityEngine.Screen.height + tempHeightRange  then
        return false
    else
        return true
    end
end

local tempBuildData
local tempBuildBlockID
local tempBuildPosition
local tempUIPos
--Received the money-making message callback returned by the server
local function ReceiveMakeMoneyMessage(data)
    if data ~= nil and data.pos ~= nil and data.money ~= nil and data.buildingId ~= nil then
        --initialization
        tempBuildBlockID = nil
        --Determine if the server location coordinates are wrong
        tempBuildBlockID =  TerrainManager.GridIndexTurnBlockID(data.pos)
        if tempBuildBlockID ~= nil then
            --initialization
            tempUIPos = nil
            --Get building 3D coordinates
            tempBuildPosition =  TerrainManager.BlockIDTurnPosition(tempBuildBlockID)
            --3D coordinates to 2D coordinates
            tempUIPos = ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint(tempBuildPosition))
            --Determine whether the UI coordinates are on the screen --> not displayed on the screen
            if  CheckWhetherTheUIPositionIsOnTheScreen(tempUIPos) then
                --Show money making UI
                MakeMoneyItem:new(UIPool:GetAvailableGameObject(),data)
            else
                return
            end
        else
            ct.log("system","位置ID为空")
        end
    end
end

--Initialization manager
function MakeMoneyManager.Init()
    --Pay attention to news monitoring
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","makeMoneyInform","gs.MakeMoney",ReceiveMakeMoneyMessage)
    --UIPool = LuaGameObjectPool:new(item.Name,tempPrefab,item.InitCount,MapGameObjectsConfig.HidePosition,MapObjectsManager.GetPoolsRoot())
    UIPool = LuaGameObjectPool:new("MakeMoneyItem",creatGoods("View/Items/MakeMoneyItems/MakeMoneyItem"),5,Vector3.New(0,0,0) )
end

--Recycle GameObject
function MakeMoneyManager.RecyclingGameObject(go)
    if go ~= nil then
        UIPool:RecyclingGameObjectToPool(go)
    end
end