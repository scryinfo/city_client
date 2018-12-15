CameraMove = class('CameraMove')
local transform = nil
local mainCameraTransform = nil
local inputTools = nil
local mCameraState = nil

function CameraMove:Start(gameObject)
    transform = gameObject
    mainCameraTransform = UnityEngine.Camera.main.transform
    --依据平台，初始化输入工具
    if inputTools then
        inputTools:Close()
    end
    if UnityEngine.Application.isEditor then
        inputTools = WindowsInput:new()
    else
        inputTools = MobileInput:new()
    end
    --初始化相机状态（默认为正常状态）
    mCameraState = TouchStateType.NormalState
    --初始化是否点击到UI上
    self.IsTouchUI = false
    --初始化点击位置
    self.touchBeginPosition = nil
    self.touchBeginBlockID = nil
end

function CameraMove:Update(gameObject)
    --点击时判断是否点击到UI
    if CameraMove.IsClickDownOverUI() then
        self.IsTouchUI = true
    end
    --点击结束时
    if  inputTools:GetIsClickUp() then
        self.touchBeginPosition = nil
        self.touchBeginBlockID = nil
        --点击在UI上
        if self.IsTouchUI then
            self.IsTouchUI = false
        end
    end
    --如果是点击到UI状态，则不做接下来的判定
    if self.IsTouchUI then
        return
    end
    --如果检测到按下
    if inputTools:GetIsClickDown() then
        self.touchBeginPosition = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
        self.touchBeginBlockID = TerrainManager.PositionTurnBlockID(tempPos)
        self.touchBeginCameraPos = mainCameraTransform.position
    end
    --如果为UI状态，则直接返回不做点击/拖拽判断
    if mCameraState == TouchStateType.NormalState then
        local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
        if inputTools:GetIsZoom() then           --如果是缩放状态
            self:ScaleCamera()
        elseif inputTools:GetIsDragging() then  --如果是拖拽状态
            self:UpdateMove()
        elseif inputTools:GetIsPoint() then     --如果是点击状态
            self:TouchBuild()
        elseif not inputTools:AnyPress() then
            self:SmoothCameraView()
        end
    elseif mCameraState == TouchStateType.ConstructState then
        local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
        if inputTools:GetIsZoom() then           --如果是缩放状态
            self:ScaleCamera()
        elseif inputTools:GetIsDragging() then  --如果是拖拽状态
            if self.touchBeginBlockID and DataManager.TempDatas.constructID == self.touchBeginBlockID then
                self:MoveConstructObj()
            else
                self:UpdateMove()
            end
        elseif not inputTools:AnyPress() then
            self:SmoothCameraView()
        end
    elseif mCameraState == TouchStateType.UIState then
        return
    end

    if inputTools:GetIsPoint() then
        CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    end


end


--缩放相机距离远近
function DataManager:ScaleCamera()

end


--点击到建筑
function DataManager:TouchBuild()
    local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos  then
        local blockID = TerrainManager.PositionTurnBlockID(tempPos)
        local tempNodeID  = DataManager.GetBlockDataByID(blockID)
        if tempNodeID ~= nil and tempNodeID ~= -1 then
            local tempModel = DataManager.GetBaseBuildDataByID(tempNodeID)
            if nil ~= tempModel then
                tempModel:OpenPanel()
            end
        end
    end
end

--拖动临时建筑
function DataManager:MoveConstructObj()
    --[[
    if nil == self.touchBeginPosition and nil == self.touchBeginBlockID then
        return
    end
    --]]
    local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos  then
        local blockID = TerrainManager.PositionTurnBlockID(tempPos)
        if blockID ~= self.touchBeginBlockID then
            DataManager.TempDatas.constructObj.transform.position = TerrainManager.BlockIDTurnPosition(blockID)
            self.touchBeginBlockID = blockID
        end
    end
end

--拖动时更新相机位置
function DataManager:UpdateMove()
    --[[
    if nil == self.touchBeginPosition and nil == self.touchBeginBlockID then
        return
    end
    --]]
    local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos  then
        local OffsetVec  = tempPos - self.touchBeginPosition
        mainCameraTransform.position = self.touchBeginCameraPos - OffsetVec
    end
end

--拖动结束后平滑移动
function CameraMove:SmoothCameraView()

end

--------------------------------------------------------------外部可调用方法-----------------------------------------------

--获取与地面的碰撞位置
--注:场景中只有地面有碰撞检测
--参数：
--  screenPoint：射线向屏幕上位置screenPoint发射
--返回：
--  与地面的碰撞点，若无碰撞则返回nil
function CameraMove.GetTouchTerrianPosition(screenPoint)
    local ray = UnityEngine.Camera.main:ScreenPointToRay(screenPoint)
    local isHit, hit = UnityEngine.Physics.Raycast(ray, nil,Mathf.Infinity)
    if isHit then
        return hit.point
    else
        ct.log("system","CameraMove.GetTouchTerrianPosition  ===>  射线与地面无碰撞")
        return nil
    end
end

--切换相机状态
function CameraMove.ChangeCameraState(changeState)
    if changeState == TouchStateType.NormalState or changeState == TouchStateType.ConstructState or changeState == TouchStateType.UIState then
        mCameraState = changeState
    else
        ct.log("system","意图修改相机状态失败，目标状态为无效状态")
    end
end

--判断是否点击到UI上
function CameraMove.IsClickDownOverUI()
    if UnityEngine.Application.isEditor then
        if UnityEngine.Input.GetMouseButtonDown(0) and UnityEngine.EventSystem.current.IsPointerOverGameObject() then
            return true
        end
    else
        if UnityEngine.Input.touchCount == 1 and UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Began and UnityEngine.EventSystem.current.IsPointerOverGameObject(UnityEngine.Input.GetTouch(0).fingerId) then
            return true
        end
    end
    return false
end

return CameraMove



