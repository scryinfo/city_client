--Allen  2019/7/5
--赚钱效果展示管理器
MakeMoneyManager = {}

--本地数据
local UIPool



---Func：坐标据相机的位置
--TargetPos：目标的位置Vector3
--return : Camera Distance
local function CalculationPositionDistanceToCamera(TargetPos)

end

---Func：与相机距离远近导致的UI大小表现换算关系
--CameraDis：相机距离 number >= 0
--return : UI Scale
local function UICameraDistanceTurnScale(CameraDis)

end

---Func：检查UI是否在屏幕内
--tempUIPos：UI坐标Vector2
--tempWidthRange：UI宽度的冗余范围
--tempHeightRange：UI高度的冗余范围
--return： true：在范围内  false：不在范围内
local function CheckWhetherTheUIPositionIsOnTheScreen(tempUIPos,tempWidthRange,tempHeightRange)
    --初始化tempWidthRange，并取绝对值
    if tempWidthRange == nil then
        tempWidthRange = 0
    elseif tempWidthRange < 0 then
        tempWidthRange = - tempWidthRange
    end
    --初始化tempHeightRange，并取绝对值
    if tempHeightRange == nil then
        tempHeightRange = 0
    elseif tempHeightRange < 0 then
        tempHeightRange = - tempHeightRange
    end
    --判断UI坐标是否在屏幕内
    if tempUIPos.x < - tempWidthRange or tempUIPos.x > UnityEngine.Screen.width + tempWidthRange then
        return false
    elseif tempUIPos.y < - tempHeightRange or tempUIPos.x > UnityEngine.Screen.height + tempHeightRange  then
        return false
    else
        return true
    end
end

local tempBuildData
local tempBuildBlockID
local tempBuildPosition
local tempUIPos
--收到服务器返回的赚钱消息回调
local function ReceiveMakeMoneyMessage(data)
    if data ~= nil and data.pos ~= nil and data.money ~= nil and data.buildingId ~= nil then
        tempBuildData = nil
        tempBuildData = DataManager.GetBaseBuildDataByID(data.buildingId)
        --范围AOI内有该建筑(理论上服务器也只推AOI范围内建筑，此处单纯做校验)
        if tempBuildData ~= nil then
            --初始化
            tempBuildBlockID = nil
            --判定服务器位置坐标是否为错误值
            tempBuildBlockID =  TerrainManager.GridIndexTurnBlockID(data.pos)
            if tempBuildBlockID ~= nil then
                --初始化
                tempUIPos = nil
                --获取建筑3D坐标
                tempBuildPosition =  TerrainManager.BlockIDTurnPosition(tempBuildBlockID)
                --3D坐标转2D坐标
                tempUIPos = ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint(tempBuildPosition))
                --判断UI坐标是否在屏幕内-->不在屏幕内可不展示
                if  CheckWhetherTheUIPositionIsOnTheScreen(tempUIPos) then
                    --显示赚钱UI
                    ct.log("system","赚钱坐标===》：  "..tempBuildPosition.x .. " , "..tempBuildPosition.z)
                else
                    ct.log("system","赚钱提示坐标不在屏幕范围内：  "..tempBuildPosition.x .. " , "..tempBuildPosition.z)
                    return
                end
            else
                ct.log("system","位置ID为空")
            end
        end
    end
end

--初始化管理器
function MakeMoneyManager.Init()
    --注测赚钱效果的消息监听
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","makeMoneyInform","gs.MakeMoney",ReceiveMakeMoneyMessage)
    UIPool = LuaGameObjectPool:new(item.Name,tempPrefab,item.InitCount,MapGameObjectsConfig.HidePosition,MapObjectsManager.GetPoolsRoot())
end


