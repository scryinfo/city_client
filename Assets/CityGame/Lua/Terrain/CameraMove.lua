CameraMove = class('CameraMove')
local mObj = nil
local mainCamera = nil                       --相机
local mainCameraTransform = nil         --相机TransForm
local mainCameraCenterTransforms = nil  --相机Root点的TransForm
local UnityEngineInput = nil            --输入
local EventSystemsCurrent = nil
local TouchPhaseBegan = nil
local UnityEngine_Time

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

local Math_Sqrt = math.sqrt

function CameraMove:Start(gameObject)
    if nil ~= mObj then
        ct.log("System","警告:不允许场景中同时挂有两个CameraMove脚本")
        self:Close()
    end
    mObj = gameObject
    mainCamera = UnityEngine.Camera.main
    mainCameraTransform = mainCamera.transform
    mainCameraCenterTransforms = mainCameraTransform.parent
    UnityEngineInput = UnityEngine.Input
    EventSystemsCurrent = UnityEngine.EventSystems.EventSystem.current
    TouchPhaseBegan = UnityEngine.TouchPhase.Began
    UnityEngine_Time = UnityEngine.Time
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
    ScaleRadius = Math_Sqrt(2)
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

local tempXZ_GetCameraScalePosByHeight
--将距离远近值转化为相机Scale的Pos位置
--通过高度获取相机远近的位置
--tempHeight：Y值高度
local function GetCameraScalePosByHeight(tempHeight)
    if ScaleRadius == nil then
        ScaleRadius = Math_Sqrt(2)
    end
    tempXZ_GetCameraScalePosByHeight = tempHeight / ScaleRadius
    return Vector3.New(tempXZ_GetCameraScalePosByHeight , tempHeight ,-tempXZ_GetCameraScalePosByHeight)
end

local tempValue_ScaleCamera
local nowScaleValue_ScaleCamera
local targetScalePos_ScaleCamera
--缩放相机距离远近
function CameraMove:ScaleCamera()
    tempValue_ScaleCamera =  inputTools:GetZoomValue() * UnityEngine_Time.deltaTime
    nowScaleValue_ScaleCamera = mainCameraTransform.localPosition.y - tempValue_ScaleCamera
    targetScalePos_ScaleCamera = nil
    if nowScaleValue_ScaleCamera < m_CameraScaleValueMin then
        targetScalePos_ScaleCamera  = GetCameraScalePosByHeight(m_CameraScaleValueMin)
    elseif nowScaleValue_ScaleCamera > m_CameraScaleValueMax then
        targetScalePos_ScaleCamera  = GetCameraScalePosByHeight(m_CameraScaleValueMax)
    else
        targetScalePos_ScaleCamera  = GetCameraScalePosByHeight(nowScaleValue_ScaleCamera)
    end
    if  targetScalePos_ScaleCamera ~= nil then
        mainCameraTransform.localPosition = targetScalePos_ScaleCamera
    end
end


local tempPos_TouchBuild
local blockID_TouchBuild
local tempNodeID_TouchBuild
local tempCollectionID_TouchBuild
local tempSystem_TouchBuild
local tempBuildModel_TouchBuild
--点击到建筑[over]
function CameraMove:TouchBuild()
    tempPos_TouchBuild = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos_TouchBuild  then
        blockID_TouchBuild = TerrainManager.PositionTurnBlockID(tempPos_TouchBuild)
        --判断是否是建筑 --->是则打开
        tempNodeID_TouchBuild  = DataManager.GetBlockDataByID(blockID_TouchBuild)
        if tempNodeID_TouchBuild ~= nil and tempNodeID_TouchBuild ~= -1 then
            --先行判断是否为系统建筑
            tempCollectionID_TouchBuild = TerrainManager.BlockIDTurnCollectionID(blockID_TouchBuild)
            tempSystem_TouchBuild = SystemMapConfig[tempCollectionID_TouchBuild]
            --打开系统建筑详情
            if tempSystem_TouchBuild ~= nil and tempSystem_TouchBuild[tempNodeID_TouchBuild] ~= nil then
                --判断是否是中心建筑 --->是则打开
                if tempSystem_TouchBuild[tempNodeID_TouchBuild] == 2000500 then
                    ct.OpenCtrl("CenterBuildingCtrl")
                end
                --TODO:其他BUFF建筑
                return
            end
            --如果不是则判断是否建筑Model
            tempBuildModel_TouchBuild = DataManager.GetBaseBuildDataByID(tempNodeID_TouchBuild)
            if nil ~= tempBuildModel_TouchBuild then
                tempBuildModel_TouchBuild:OpenPanel()
                CameraMove.MoveIntoUILayer(tempNodeID_TouchBuild)
                return
            end
        end
        --判断是否点击在拍卖中的地块上
        if UIBubbleManager.getIsClickAucGround(blockID_TouchBuild) then
            return
        end

        --判断是否是地块 --->是则打开
        if DataManager.GetGroundDataByID(blockID_TouchBuild) ~= nil then
            ct.OpenCtrl("GroundTransDetailCtrl", {blockId = blockID_TouchBuild})
        end
    end
end


local tempPos_MoveConstructObj
local blockID_MoveConstructObj
local targetID_MoveConstructObj
local targetPos_MoveConstructObj
--拖动临时建筑
function CameraMove:MoveConstructObj()
    tempPos_MoveConstructObj = CameraMove.GetTouchTerrianPosition(inputTools:GetClickFocusPoint())
    if tempPos_MoveConstructObj  then
        blockID_MoveConstructObj = TerrainManager.PositionTurnBlockID(tempPos_MoveConstructObj)
        if blockID_MoveConstructObj ~= self.touchBeginBlockID then
            targetID_MoveConstructObj = DataManager.TempDatas.constructPosID + blockID_MoveConstructObj - self.touchBeginBlockID
            targetPos_MoveConstructObj = TerrainManager.BlockIDTurnPosition(targetID_MoveConstructObj)
            targetPos_MoveConstructObj.y = targetPos_MoveConstructObj.y + 0.03
            DataManager.TempDatas.constructObj.transform.position = targetPos_MoveConstructObj
            DataManager.TempDatas.constructPosID = targetID_MoveConstructObj
            self.touchBeginBlockID = blockID_MoveConstructObj
        end
    end
end


local touchPos_UpdateMove
local tempPos_UpdateMove
local OffsetVec_UpdateMove
local tempPosition_UpdateMove
local tempX_UpdateMove
local tempZ_UpdateMove
--拖动时更新相机位置
function CameraMove:UpdateMove()
    if not inputTools:IsMove() then
        return
    end
    touchPos_UpdateMove = inputTools:GetClickFocusPoint()
    if touchPos_UpdateMove == nil then
        return
    end
    tempPos_UpdateMove = CameraMove.GetTouchTerrianPosition(touchPos_UpdateMove)
    if tempPos_UpdateMove ~= nil then
        OffsetVec_UpdateMove  = tempPos_UpdateMove - self.touchBeginPosition
        tempPosition_UpdateMove = self.touchBeginCameraPos - OffsetVec_UpdateMove
        --范围限制
        if tempPosition_UpdateMove.y ~= 0 then
            tempPosition_UpdateMove.y = 0
        end
        tempX_UpdateMove = tempPosition_UpdateMove.x
        tempZ_UpdateMove = tempPosition_UpdateMove.z
        if tempX_UpdateMove < m_CameraRootXMin then
            tempX_UpdateMove = m_CameraRootXMin
        elseif tempX_UpdateMove > m_CameraRootXMax then
            tempX_UpdateMove = m_CameraRootXMax
        end
        if tempZ_UpdateMove < m_CameraRootZMin then
            tempZ_UpdateMove = m_CameraRootZMin
        elseif tempZ_UpdateMove > m_CameraRootZMax then
            tempZ_UpdateMove = m_CameraRootZMax
        end
        tempPosition_UpdateMove.x = tempX_UpdateMove
        tempPosition_UpdateMove.z = tempZ_UpdateMove
        --
        self.touchBeginCameraPos = tempPosition_UpdateMove
        mainCameraCenterTransforms.position = tempPosition_UpdateMove
        --调用地块刷新
        Event.Brocast("CameraMoveTo", tempPosition_UpdateMove)
    end
end

--TODO：拖动结束后平滑移动N
function CameraMove:SmoothCameraView()

end

--TODO:清除实例
function CameraMove:Close()

end

--------------------------------------------------------------外部可调用方法-----------------------------------------------


local ray_GetTouchTerrianPosition
local isHit_GetTouchTerrianPosition
local hit_GetTouchTerrianPosition
local Mathf_Infinity = Mathf.Infinity
local UnityEngineRaycast = UnityEngine.Physics.Raycast

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
    ray_GetTouchTerrianPosition = mainCamera:ScreenPointToRay(screenPoint)
    isHit_GetTouchTerrianPosition, hit_GetTouchTerrianPosition = UnityEngineRaycast(ray_GetTouchTerrianPosition, nil,Mathf_Infinity)
    if isHit_GetTouchTerrianPosition then
        return hit_GetTouchTerrianPosition.point
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
        if UnityEngineInput.GetMouseButtonDown(0) and EventSystemsCurrent:IsPointerOverGameObject() then
            return true
        end
    else
        if UnityEngineInput.touchCount == 1 and UnityEngineInput.GetTouch(0).phase == TouchPhaseBegan and EventSystemsCurrent:IsPointerOverGameObject(UnityEngineInput.GetTouch(0).fingerId) then
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



