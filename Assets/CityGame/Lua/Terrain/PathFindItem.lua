--单独角色寻路脚本
PathFindItem = class('PathFindItem')

local Math_Random = math.random
local TerrainRangeSize = 1000
local Math_Abs = math.abs
local Math_Ceil = math.ceil

--playerName：角色名称（对象池名称）
--PlayerStartBlockID:角色初始化位置BlockID
--PlayerEdgeDistance:角色和边界的距离（车和行人是不一样的）
function PathFindItem:initialize(playerPoolName,PlayerStartBlockID,PlayerEdgeDistance,insID,type)
    self.insID = insID
    self.go = MapObjectsManager.GetGameObjectByPool(playerPoolName)
    self.go.name = insID
    self.transform = self.go.transform
    self.poolName = playerPoolName
    self.edgeDistance = PlayerEdgeDistance
    self.m_BlockID = PlayerStartBlockID
    self.type = type
    self.nowPos = nil
    self.oldPos = nil

    self.pathNum = DataManager.GetPathDataByBlockID(self.m_BlockID)
    --TODO:速度应为配置表中读取速度范围随机
    if self.type == MobileRolesType.cars then
        self.speed = Math_Random(30,60) / 100
    elseif self.type == MobileRolesType.pedestrians then
        self.speed = Math_Random(10,30) / 100
    end

    self.InitPlayerRandomPosition(self)

    --获取左右朝向的朝向
    self.m_OrientationRightDown = self.transform:Find("Orientation_rightdown")
    self.m_OrientationLeftUp = self.transform:Find("Orientation_leftup")
    self.m_OrientationLeftDown = self.transform:Find("Orientation_leftdown")
    self.m_OrientationRightUp = self.transform:Find("Orientation_rightup")

    self.running = true
    if not self.handle then
        self.handle = UpdateBeat:CreateListener(self.Update, self)
    end
    UpdateBeat:AddListener(self.handle)
    self.ResetmTimer(self,0)

    end

--UpOrDown : true 为UP
--LeftOrRight ： true 为Left
function PathFindItem:PlayerOrientation(UpOrDown,LeftOrRight)
    if UpOrDown == nil or LeftOrRight == nil then
        UpOrDown = true
        LeftOrRight = true
    end
    self.m_OrientationRightDown.gameObject:SetActive(false)
    self.m_OrientationLeftUp.gameObject:SetActive(false)
    self.m_OrientationLeftDown.gameObject:SetActive(false)
    self.m_OrientationRightUp.gameObject:SetActive(false)
    if type(UpOrDown) == "boolean" and type(LeftOrRight) == "boolean" then
        if UpOrDown == true and LeftOrRight == true then
            self.m_OrientationRightDown.gameObject:SetActive(true)
        elseif UpOrDown == true and LeftOrRight == false then
            self.m_OrientationLeftDown.gameObject:SetActive(true)
        elseif UpOrDown == false and LeftOrRight == true then
            self.m_OrientationLeftUp.gameObject:SetActive(true)
        elseif UpOrDown == false and LeftOrRight == false then
            self.m_OrientationRightUp.gameObject:SetActive(true)
        end
    end
end

function PathFindItem:ResetmTimer(durationTime)
    self.durationTime = durationTime
    self.running = true
end

function PathFindItem:Update()
    if false == self.running or self.running == nil then
        return
    end
    self.durationTime = self.durationTime - UnityEngine.Time.unscaledDeltaTime
    if self.durationTime <= 0 then
        self.running = false
        self.FindNectTarget(self)
    end
end

--初始化角色随机位置
function PathFindItem:InitPlayerRandomPosition()
    local PosList = PathFindManager.CalculatePathValues(self.pathNum)
    if PosList ~= nil and type(PosList) ==  'table' and PosList ~= {} then
        local tempList = {}
        for i, v in pairs(PosList) do
            tempList[#tempList + 1] = v
        end
        self.nowPathNum = tempList[Math_Random(1,#tempList)]
        local targetPosition =  self.CalculateTargetPosition(self, self.m_BlockID,self.nowPathNum)
        if targetPosition ~= nil then
            self.transform.position = targetPosition
            self.targetPos = targetPosition
        end
    else
        ct.log("system","初始化角色随机位置失败")
        self:CloseSelf()
    end
end

function PathFindItem:CloseSelf()
    if self.insID ~= nil then
        PathFindManager.RemoveThePalyerByInsID(self.insID)
    end
end

local function JudgeIsCanMove(tempBlockID,tempPosPathNum)
    local tempNum = DataManager.GetPathDataByBlockID(tempBlockID)
    local PosList = PathFindManager.CalculatePathValues(tempNum)
    if PosList ~= nil and type(PosList) ==  'table' then
        if PosList[tempPosPathNum] ~= nil then
            return true
        end
    end
    return false
end

--寻找下一个目标点
--1  2
--4  8
--新增额外规则：车辆只能顺时针走【适用在非主道路上】
--车辆：不能走走过的路
function PathFindItem:FindNectTarget()
    --分为两步->1、在自己内部找2、在别的相邻两地块内部找
    local PosList = PathFindManager.CalculatePathValues(self.pathNum)
    local CannotMoveList = PathFindManager.CalculatePathCanNotMove(self.pathNum)
    local AdjacentBlockIDList ={}
    local PointsAccessible = {}
    if self.nowPathNum == 1 then
        --内部点
        if PosList[2] ~= nil then
            if CannotMoveList ~= nil and CannotMoveList[100] == nil  then
                PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 2}
            end
        end
        if self.type ~= MobileRolesType.cars then --车辆只能顺时针走
            if PosList[4] ~= nil then
                if CannotMoveList ~= nil and CannotMoveList[800] == nil  then
                    PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 4}
                end
            end
            AdjacentBlockIDList[self.m_BlockID - 1] = 2
        end
        --外部点
        AdjacentBlockIDList[self.m_BlockID - TerrainRangeSize] = 4
    elseif self.nowPathNum == 2 then
        --内部点
        if self.type ~= MobileRolesType.cars then --车辆只能顺时针走
            if PosList[1] ~= nil then
                if CannotMoveList ~= nil and CannotMoveList[100] == nil  then
                    PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 1}
                end
            end
            AdjacentBlockIDList[self.m_BlockID - TerrainRangeSize] = 8
        end
        if PosList[8] ~= nil then
            if CannotMoveList ~= nil and CannotMoveList[200] == nil  then
                PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 8}
            end
        end
        --外部点
        AdjacentBlockIDList[self.m_BlockID + 1] = 1
    elseif self.nowPathNum == 4 then
        --内部点
        if PosList[1] ~= nil then
            if CannotMoveList ~= nil and CannotMoveList[800] == nil  then
                PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 1}
            end
        end
        if self.type ~= MobileRolesType.cars then --车辆只能顺时针走
            if PosList[8] ~= nil then
                if CannotMoveList ~= nil and CannotMoveList[400] == nil  then
                    PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 8}
                end
            end
            AdjacentBlockIDList[self.m_BlockID + TerrainRangeSize] = 1
        end
        --外部点
        AdjacentBlockIDList[self.m_BlockID - 1] = 8
    elseif self.nowPathNum == 8 then
        --内部点
        if self.type ~= MobileRolesType.cars then --车辆在内部只能顺时针走
            if PosList[2] ~= nil then
                if CannotMoveList ~= nil and CannotMoveList[200] == nil  then
                    PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 2}
                end
            end
            AdjacentBlockIDList[self.m_BlockID + 1] = 4
        end
        if PosList[4] ~= nil then
            if CannotMoveList ~= nil and CannotMoveList[400] == nil  then
                PointsAccessible[#PointsAccessible + 1] = {id = self.m_BlockID , num = 4}
            end
        end
        --外部点
        AdjacentBlockIDList[self.m_BlockID + TerrainRangeSize] = 2
    end
    for id, value in pairs(AdjacentBlockIDList) do
        if JudgeIsCanMove(id,value) == true then
            PointsAccessible[#PointsAccessible + 1] = {id = id , num = value}
        end
    end
    --剔除之前走过的位置【车辆】
    if self.oldPos ~= nil and self.type == MobileRolesType.cars and #PointsAccessible >= 2 then
        for i, value in pairs(PointsAccessible) do
            if value.id == self.oldPos.id and value.num == self.oldPos.num then
                table.remove(PointsAccessible,i)
                break
            end
        end
    end
    self.oldPos = self.nowPos
    --此时得到内外部可以去的点
    if #PointsAccessible >= 1 then
        self.nowPos = PointsAccessible[Math_Random(1,#PointsAccessible)]
    else
        ct.log("system","移动到没路可走了！！！！！" )
        self:CloseSelf()
        return
    end
    --此时得到目标点
    local targetPosition = self.CalculateTargetPosition(self,self.nowPos.id,self.nowPos.num)
    if targetPosition == nil then
        self:CloseSelf()
        return
    end
    local offsetX =  targetPosition.x - self.targetPos.x
    local offsetZ =  targetPosition.z - self.targetPos.z
    --计算人物朝向
    local IsUp ,IsLeft
    if offsetX < 0 and offsetZ == 0 then --右下
        IsLeft = true
        IsUp = false
    elseif offsetX > 0 and offsetZ == 0 then --左上
        IsLeft = true
        IsUp = true
    elseif offsetZ < 0 and offsetX == 0 then --右上
        IsLeft = false
        IsUp = true
    elseif offsetZ > 0 and offsetX == 0 then --左下
        IsLeft = false
        IsUp = false
    end
    self:PlayerOrientation(IsUp,IsLeft)
    --计算移动时间
    local MoveDistance = Math_Abs(offsetX) + Math_Abs(offsetZ)
    local MoveTime = MoveDistance / self.speed
    --赋值新的位置
    self.m_BlockID = self.nowPos.id
    self.targetPos = targetPosition
    self.pathNum = DataManager.GetPathDataByBlockID(self.m_BlockID)
    self.nowPathNum = self.nowPos.num
    --执行位置
    self.transform:DOMove(targetPosition,MoveTime):SetEase(DG.Tweening.Ease.Linear)
    self.ResetmTimer(self,MoveTime)
    --collectgarbage("collect")
end

--计算目标点
--tempBlockID:位置ID
--tempPathNum:具体的PathNUm
function PathFindItem:CalculateTargetPosition(tempBlockID,tempPosPathNum)
    local tempNum = DataManager.GetPathDataByBlockID(tempBlockID)
    if tempNum == nil then
        return
    end
    local PosList = PathFindManager.CalculatePathValues(tempNum)
    if PosList ~= nil and type(PosList) ==  'table' then
        if PosList[tempPosPathNum] ~= nil then
            local targetPos = TerrainManager.BlockIDTurnPosition(tempBlockID)
            targetPos.y = targetPos.y + 0.05
            if self.edgeDistance ~= nil then
                if tempPosPathNum == 1 then
                    targetPos.x = targetPos.x + self.edgeDistance
                    targetPos.z = targetPos.z + self.edgeDistance
                elseif tempPosPathNum == 2 then
                    targetPos.x = targetPos.x + self.edgeDistance
                    targetPos.z = targetPos.z + (1 - self.edgeDistance)
                elseif tempPosPathNum == 4 then
                    targetPos.x = targetPos.x + (1 - self.edgeDistance)
                    targetPos.z = targetPos.z + self.edgeDistance
                elseif tempPosPathNum == 8 then
                    targetPos.x = targetPos.x + (1 - self.edgeDistance)
                    targetPos.z = targetPos.z + (1 - self.edgeDistance)
                end
            end
            return targetPos
        end
    end
    return nil
end

--报告自己的位置
function PathFindItem:ReportPosition()
    if self.go ~= nil then
        return  self.go.transform.position
    end
    return nil
end

--删除角色
function PathFindItem:Destory()
    if self.handle then
        UpdateBeat:RemoveListener(self.handle)
    end
    self.transform:DOKill()
    if self.poolName ~= nil and self.go ~= nil then
        MapObjectsManager.RecyclingGameObjectToPool(self.poolName,self.go)
    end
    self = nil
end