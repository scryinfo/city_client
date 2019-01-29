CameraMove = class('CameraMove')
local mObj = nil
local mainCameraTransform = nil         --相机TransForm
local mainCameraCenterTransforms = nil  --相机Root点的TransForm
local inputTools = nil                  --接受输入脚本实例
local mCameraState = nil                --相机脚本

local m_CameraScaleValueMin = 5     --缩放最近距离
local m_CameraScaleValueMax = 10    --缩放最远距离

local m_CameraRootXMin = 0      --相机root节点X轴移动范围最小值
local m_CameraRootXMax = 101   --相机root节点X轴移动范围最大值
local m_CameraRootZMin = 0      --相机root节点Z轴移动范围最小值
local m_CameraRootZMax = 101   --相机root节点Z轴移动范围最大值

local m_IntoDurationtime = 0.4          --相机切到UI层所需时间
local m_OutDurationtime = 0.6           --相机切出UI层所需时间

local NormalStateCameraPos = nil       --记录正常状态相机的位置
local NormalStateCameraScalePos = nil  --记录正常状态相机的远近(即相机真正的坐标位置)

local ScaleRadius = nil  --相机缩放的宽高比（ScaleRadius * x = y ）

function CameraMove:Start(gameObject)
    if nil ~= mObj then
        ct.log("System","警告:不允许场景中同时挂有两个CameraMove脚本")
        self:Close()
    end
    mObj = gameObject
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
    self:InitParameters()
    --初始化相机位置
    --CameraMove.MoveCameraToPos(Vector3.New(10,0,10))
end

--初始化相机参数
function CameraMove:InitParameters()
    local cameraAttribute =  TerrainConfig.TerrainAttribute
    if cameraAttribute ~= nil then
        if cameraAttribute.CameraScaleValueMin ~= nil then
            m_CameraScaleValueMin = cameraAttribute.CameraScaleValueMin
        end
        if cameraAttribute.CameraScaleValueMax ~= nil then
            m_CameraScaleValueMax = cameraAttribute.CameraScaleValueMax
        end
        if cameraAttribute.CameraRootXMin ~= nil then
            m_CameraRootXMin = cameraAttribute.CameraRootXMin
        end
        if cameraAttribute.CameraRootXMax ~= nil then
            m_CameraRootXMax = cameraAttribute.CameraRootXMax
        end
        if cameraAttribute.CameraRootZMin ~= nil then
            m_CameraRootZMin = cameraAttribute.CameraRootZMin
        end
        if cameraAttribute.CameraRootZMax ~= nil then
            m_CameraRootZMax = cameraAttribute.CameraRootZMax
        end
        if cameraAttribute.CameraIntoDurationtime ~= nil then
            m_IntoDurationtime = cameraAttribute.CameraIntoDurationtime
        end
        if cameraAttribute.CameraOutDurationtime ~= nil then
            m_OutDurationtime = cameraAttribute.CameraOutDurationtime
        end
    end
    --根号2
    ScaleRadius = math.sqrt(2)
    NormalStateCameraPos = nil
    NormalStateCameraScalePos = nil
end

function CameraMove:LateUpdate(gameObject)
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
            --cycle需要的每帧调用接口
            Event.Brocast("c_UIBubbleLateUpdate")
            return
        end
    end
    --如果是点击到UI状态，则不做接下来的判定
    if self.IsTouchUI then
        --cycle需要的每帧调用接口
        Event.Brocast("c_UIBubbleLateUpdate")
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
            inputTools:SetOldPosition(inputTools:GetClickFocusPoint())
        elseif inputTools:GetIsPoint() then     --如果是点击状态
            self:TouchBuild()
        elseif not inputTools:AnyPress() then
            self:SmoothCameraView()
        end
    elseif mCameraState == TouchStateType.ConstructState then
        if inputTools:GetIsZoom() then           --如果是缩放状态
            self:ScaleCamera()
            TerrainManager.MoveTempConstructObj()
        elseif inputTools:GetIsDragging() then  --如果是拖拽状态
            if nil ~= DataManager.TempDatas.constructPosID and  DataManager.IsInTheRange(DataManager.TempDatas.constructPosID,PlayerBuildingBaseData[DataManager.TempDatas.constructID]["x"],self.touchBeginBlockID) then
                self:MoveConstructObj()
            else
                self:UpdateMove()
            end
            TerrainManager.MoveTempConstructObj()
            inputTools:SetOldPosition(inputTools:GetClickFocusPoint())
        elseif not inputTools:AnyPress() then
            self:SmoothCameraView()
        end
    elseif mCameraState == TouchStateType.UIState then
        --cycle需要的每帧调用接口
        Event.Brocast("c_UIBubbleLateUpdate")
        return
    end
    --cycle需要的每帧调用接口
    Event.Brocast("c_UIBubbleLateUpdate")
end

--将距离远近值转化为相机Scale的Pos位置【过时】
local function ValueTurnCameraScalePos(value)
    if value ~= nil then
        return Vector3.New(value,value,-value)
    end
    return nil
end

--将距离远近值转化为相机Scale的Pos位置
--通过高度获取相机远近的位置
--tempHeight：Y值高度
local function GetCameraScalePosByHeight(tempHeight)
    if ScaleRadius == nil then
        ScaleRadius = math.sqrt(2)
    end
    local tempXZ = tempHeight / ScaleRadius
    return Vector3.New(tempXZ , tempHeight ,-tempXZ)
end

--缩放相机距离远近
function CameraMove:ScaleCamera()
    local tempValue =  inputTools:GetZoomValue() * UnityEngine.Time.deltaTime
    local nowScaleValue = mainCameraTransform.localPosition.y - tempValue
    local targetScalePos = nil
    if nowScaleValue < m_CameraScaleValueMin then
        targetScalePos  = GetCameraScalePosByHeight(m_CameraScaleValueMin)
    elseif nowScaleValue > m_CameraScaleValueMax then
        targetScalePos  = GetCameraScalePosByHeight(m_CameraScaleValueMax)
    else
        targetScalePos  = GetCameraScalePosByHeight(nowScaleValue)
    end
    if  targetScalePos ~= nil then
        mainCameraTransform.localPosition = targetScalePos
    end
end

--点击到建筑[over]
function CameraMove:TouchBuild()
    local tempPos = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos  then
        local blockID = TerrainManager.PositionTurnBlockID(tempPos)
        --判断是否是中心建筑 --->是则打开
        if TerrainManager.IsTouchCentralBuilding(blockID) then
            ct.OpenCtrl("CenterBuildingCtrl")
            return
        end
        --判断是否是建筑 --->是则打开
        local tempNodeID  = DataManager.GetBlockDataByID(blockID)
        if tempNodeID ~= nil and tempNodeID ~= -1 then
            local tempBuildModel = DataManager.GetBaseBuildDataByID(tempNodeID)
            if nil ~= tempBuildModel then
                tempBuildModel:OpenPanel()
                CameraMove.MoveIntoUILayer(tempNodeID)
                return
            end
        end
        --判断是否点击在拍卖中的地块上
        local click = UIBubbleManager.getIsClickAucGround(blockID)
        if click then
            return
        end

        --判断是否是地块 --->是则打开
        if DataManager.GetGroundDataByID(blockID) ~= nil then
            ct.OpenCtrl("GroundTransDetailCtrl", {blockId = blockID})
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
            local targetPos = TerrainManager.BlockIDTurnPosition(targetID)
            targetPos.y = targetPos.y + 0.03
            DataManager.TempDatas.constructObj.transform.position = targetPos
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
    if tempPos ~= nil then
        local OffsetVec  = tempPos - self.touchBeginPosition
        local tempPosition = self.touchBeginCameraPos - OffsetVec
        --范围限制
        if tempPosition.y ~= 0 then
            tempPosition.y = 0
        end
        local tempX = tempPosition.x
        local tempZ = tempPosition.z
        if tempX < m_CameraRootXMin then
            tempX = m_CameraRootXMin
        elseif tempX > m_CameraRootXMax then
            tempX = m_CameraRootXMax
        end
        if tempZ < m_CameraRootZMin then
            tempZ = m_CameraRootZMin
        elseif tempZ > m_CameraRootZMax then
            tempZ = m_CameraRootZMax
        end
        tempPosition.x = tempX
        tempPosition.z = tempZ
        --
        self.touchBeginCameraPos = tempPosition
        mainCameraCenterTransforms.position = tempPosition
        --调用地块刷新
        Event.Brocast("CameraMoveTo", tempPosition)
    end
end

--TODO：拖动结束后平滑移动
function CameraMove:SmoothCameraView()

end

--TODO:清除实例
function CameraMove:Close()

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
        local tempI  =UnityEngine.Input.GetMouseButtonDown(0)
        local tempBool =  UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject()
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

--移动放大到某个指定建筑
function CameraMove.MoveIntoUILayer(targetID)
    --相机状态切换至UIState
    CameraMove.ChangeCameraState(TouchStateType.UIState)
    --记录位置状态
    NormalStateCameraPos = mainCameraCenterTransforms.position
    NormalStateCameraScalePos = mainCameraTransform.localPosition
    --相机移动到目标点
    --TODO:改为策划配置偏移量和距离远近
    local tempBuildModel =  DataManager.GetBaseBuildDataByID(DataManager.GetBlockDataByID(targetID))
    local OffsetPos = Vector3.zero
    local buildSize = 2
    local tempBuildScalePos = Vector3.New(5,7.07,-5)
    if tempBuildModel and tempBuildModel.Data and tempBuildModel.Data.buildingID then
        local tempBuildType = tempBuildModel.Data.buildingID
        if PlayerBuildingBaseData[tempBuildType].UICenterPos ~= nil then
            OffsetPos =  Vector3.New( PlayerBuildingBaseData[tempBuildType]["UICenterPos"][1],PlayerBuildingBaseData[tempBuildType]["UICenterPos"][2],PlayerBuildingBaseData[tempBuildType]["UICenterPos"][3])
        end
        if PlayerBuildingBaseData[tempBuildType].x ~= nil then
            buildSize = PlayerBuildingBaseData[tempBuildType].x + 1
        end
        if PlayerBuildingBaseData[tempBuildType].ScalePos ~= nil then
            tempBuildScalePos =GetCameraScalePosByHeight(PlayerBuildingBaseData[tempBuildType]["ScalePos"][1])
        end
    end
    --
    local tempPos = TerrainManager.BlockIDTurnPosition(targetID) + OffsetPos --偏移量
    mainCameraCenterTransforms:DOMove(tempPos,m_IntoDurationtime)
    --相机移动到目标位置
    local tempScalePos = tempBuildScalePos  --相机远近
    mainCameraTransform:DOLocalMove(tempScalePos,m_IntoDurationtime)
    --战争迷雾缩小到目标大小
    FOWManager.RefreshFOWRangeByBlockPos(tempPos,buildSize)
end

--还原到正常状态
function CameraMove.MoveOutUILayer()
    if not NormalStateCameraPos or not NormalStateCameraScalePos then
        return
    end
    --相机状态切换至NormalState
    CameraMove.ChangeCameraState(TouchStateType.NormalState)
    --相机还原到目标点
    mainCameraCenterTransforms:DOMove(NormalStateCameraPos,m_OutDurationtime)
    --相机还原到目标大小
    mainCameraTransform:DOLocalMove(NormalStateCameraScalePos,m_OutDurationtime)
    --战争迷雾换到到正常大小
    FOWManager.BackToMaxFowRange()
    NormalStateCameraPos = nil
    NormalStateCameraScalePos = nil
end

function CameraMove.MoveCameraToPos(targetPos)
    mainCameraCenterTransforms.position = targetPos
    --调用地块刷新
    Event.Brocast("CameraMoveTo", targetPos)
end

function CameraMove.MoveCameraToPosSmooth(targetPos,smoothTime)
    mainCameraCenterTransforms:DOMove(targetPos,smoothTime)
    Event.Brocast("CameraMoveTo", targetPos)
end

return CameraMove



