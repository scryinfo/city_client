CameraMove = class('CameraMove')
local transform = nil
local mainCameraTransform = nil
local mainCameraCenterTransforms = nil
local inputTools = nil
local mCameraState = nil
local oldPos = nil

function CameraMove:Start(gameObject)
    transform = gameObject
    mainCameraTransform = UnityEngine.Camera.main.transform
    mainCameraCenterTransforms = mainCameraTransform.parent
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

function CameraMove:FixedUpdate(gameObject)
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
        self.touchBeginBlockID = TerrainManager.PositionTurnBlockID(self.touchBeginPosition)
        self.touchBeginCameraPos = mainCameraCenterTransforms.position
    end
    --如果为UI状态，则直接返回不做点击/拖拽判断
    if mCameraState == TouchStateType.NormalState then
        if inputTools:GetIsZoom() then           --如果是缩放状态
            self:ScaleCamera()
        elseif inputTools:GetIsDragging() then  --如果是拖拽状态
            self:UpdateMove()
            inputTools.m_oldMousePos = inputTools:GetClickFocusPoint()
        elseif inputTools:GetIsPoint() then     --如果是点击状态
            self:TouchBuild()
        elseif not inputTools:AnyPress() then
            self:SmoothCameraView()
        end
    elseif mCameraState == TouchStateType.ConstructState then
        if inputTools:GetIsZoom() then           --如果是缩放状态
            self:ScaleCamera()
        elseif inputTools:GetIsDragging() then  --如果是拖拽状态
            if nil ~= DataManager.TempDatas.constructPosID and  DataManager.IsInTheRange(DataManager.TempDatas.constructPosID,PlayerBuildingBaseData[DataManager.TempDatas.constructID]["x"],self.touchBeginBlockID) then
                self:MoveConstructObj()
            else
                self:UpdateMove()
            end
            TerrainManager.MoveTempConstructObj()
            inputTools.m_oldMousePos = inputTools:GetClickFocusPoint()
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
function CameraMove:ScaleCamera()

end


--点击到建筑[over]
function CameraMove:TouchBuild()
    local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos  then
        local blockID = TerrainManager.PositionTurnBlockID(tempPos)
        local tempNodeID  = DataManager.GetBlockDataByID(blockID)
        if tempNodeID ~= nil and tempNodeID ~= -1 then
            local tempModel = DataManager.GetBaseBuildDataByID(tempNodeID)
            if nil ~= tempModel then
                tempModel:OpenPanel()
                CameraMove.MoveIntoUILayer(tempNodeID)
            end
        end
    end
end

--拖动临时建筑
function CameraMove:MoveConstructObj()
    local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos  then
        local blockID = TerrainManager.PositionTurnBlockID(tempPos)
        if blockID ~= self.touchBeginBlockID then
            local targetID= DataManager.TempDatas.constructPosID + blockID - self.touchBeginBlockID
            DataManager.TempDatas.constructObj.transform.position = TerrainManager.BlockIDTurnPosition(targetID)
            DataManager.TempDatas.constructPosID = targetID
            self.touchBeginBlockID = blockID
        end
    end
end

--拖动时更新相机位置
function CameraMove:UpdateMove()
    if not inputTools:IsMove() then
        return
    end
    local touchPos = inputTools:GetClickFocusPoint()
    if touchPos == nil then
        return
    end
    local tempPos = CameraMove.GetTouchTerrianPosition(touchPos)
    if tempPos  then
       local OffsetVec  = tempPos - self.touchBeginPosition
        local tempPosition = self.touchBeginCameraPos - OffsetVec
        if tempPosition.y ~= 0 then
            tempPosition.y = 0
        end
        self.touchBeginCameraPos = tempPosition
        mainCameraCenterTransforms.position = tempPosition

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
    if nil == screenPoint then
        return
    end
    local ray = UnityEngine.Camera.main:ScreenPointToRay(screenPoint)
    local isHit, hit = UnityEngine.Physics.Raycast(ray, nil,Mathf.Infinity)
    if isHit then
        return hit.point
    else
        ct.log("system","无碰撞物体")
        return nil
    end
end

--切换相机状态
function CameraMove.ChangeCameraState(changeState)
    if changeState == TouchStateType.NormalState or changeState == TouchStateType.ConstructState or changeState == TouchStateType.UIState then
        if mCameraState == TouchStateType.UIState and changeState == changeState == TouchStateType.NormalState then
            CameraMove.MoveOutUILayer()
        end
        mCameraState = changeState
    else
        ct.log("system","意图修改相机状态失败，目标状态为无效状态")
    end
end

--判断是否点击到UI上
function CameraMove.IsClickDownOverUI()
    if UnityEngine.Application.isEditor then
        if UnityEngine.Input.GetMouseButtonDown(0) and UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject() then
            return true
        end
    else
        if UnityEngine.Input.touchCount == 1 and UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Began and UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject(UnityEngine.Input.GetTouch(0).fingerId) then
            return true
        end
    end
    return false
end

local NormalStateCameraPos      --记录正常状态相机的位置
local NormalStateCameraScalePos    --记录正常状态相机的远近(即相机真正的坐标位置)
local m_IntoDurationtime = 0.3
local m_OutDurationtime = 0.2

--移动放大到某个指定建筑
function CameraMove.MoveIntoUILayer(targetID)
    --相机状态切换至UIState
    CameraMove.ChangeCameraState(TouchStateType.UIState)
    --记录位置状态
    NormalStateCameraPos = mainCameraCenterTransforms.position
    NormalStateCameraScalePos = mainCameraTransform.localPosition
    --相机移动到目标点
    local tempPos = TerrainManager.BlockIDTurnPosition(targetID)--TODO:加上配置表偏移量
    mainCameraCenterTransforms:DOMove(tempPos,m_IntoDurationtime)
    --相机移动到目标位置--TODO:读取配置表距离远近
    local tempScalePos = Vector3.New(7,7,-7)
    mainCameraTransform:DOLocalMove(tempScalePos,m_IntoDurationtime)
    --TODO:战争迷雾缩小到目标大小
end

--还原到正常状态
function CameraMove.MoveOutUILayer()
    --相机状态切换至NormalState
    CameraMove.ChangeCameraState(TouchStateType.NormalState)
    --相机还原到目标点
    mainCameraCenterTransforms:DOMove(NormalStateCameraPos,m_OutDurationtime)
    --相机还原到目标大小
    mainCameraTransform:DOLocalMove(NormalStateCameraScalePos,m_OutDurationtime)
    --TODO:战争迷雾换到到正常大小
end

return CameraMove



