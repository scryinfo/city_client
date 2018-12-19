
WindowsInput = class('WindowsInput')

function WindowsInput:initialize( ... )
    self.m_moveV2 = nil
    self.m_zoomValue = 0
    self.m_oldMousePos = nil
    self.m_startMousePos = Vector3.zero
    UpdateBeat:Add(self.Update, self)
end

function WindowsInput:GetIsClickDown()
    return UnityEngine.Input.GetMouseButtonDown(0)
end

function WindowsInput:GetIsClickUp()
    return UnityEngine.Input.GetMouseButtonUp(0)
end
function WindowsInput:GetIsDragging()
    return UnityEngine.Input.GetMouseButton(0)
end

function WindowsInput:GetIsPoint()
    return UnityEngine.Input.GetMouseButtonUp(0) and self.m_startMousePos == UnityEngine.Input.mousePosition
end

function WindowsInput:GetIsZoom()
    return self.m_zoomValue ~= 0
end

function WindowsInput:IsMove()
    if self:GetMoveV2() ~= nil and (self:GetMoveV2().x~= 0 or self:GetMoveV2().y~= 0) then
        ct.log("system","旧的屏幕坐标  "..self.m_oldMousePos.x .."  ".. self.m_oldMousePos.y)
        ct.log("system","新的屏幕坐标差值"..self.m_moveV2.x .."  ".. self.m_moveV2.y)
        return true
    else
        return false
    end
end

function WindowsInput:AnyPress()
    return UnityEngine.Input.GetMouseButton(0) or UnityEngine.Input.GetMouseButton(1) or UnityEngine.Input.GetMouseButton(2)
end

function WindowsInput:GetMoveV2()
    if self.m_oldMousePos then
        self.m_moveV2 = UnityEngine.Input.mousePosition - self.m_oldMousePos
        return self.m_moveV2
    else
        return nil
    end
end

function WindowsInput:GetZoomValue()
    return self.m_zoomValue
end

function WindowsInput:GetClickFocusPoint()
    if  self:GetIsDragging() then
        return UnityEngine.Input.mousePosition
    else
        return nil
    end
end

function WindowsInput:Update()
    if UnityEngine.Input.GetMouseButtonDown(0) then
        self.m_startMousePos = UnityEngine.Input.mousePosition
    end
    --[[
    if  self:GetIsDragging() then
        if self.m_oldMousePos ~= nil then
            self.m_moveV2 = UnityEngine.Input.mousePosition - self.m_oldMousePos
        end
        self.m_oldMousePos = UnityEngine.Input.mousePosition
    end
   --]]
    self.m_zoomValue = UnityEngine.Input.GetAxis("Mouse ScrollWheel")
end

function WindowsInput:Close()
    UpdateBeat:Remove(self.Update, self)
end

MobileInput = class('MobileInput')
function MobileInput:initialize( ... )
    self.m_Zoomed = false;
    self.m_zoomValue = 0
    self.m_zoomCenter = Vector3.zero
    self.m_oldTouch0Pos = Vector3.zero
    self.m_oldTouch1Pos = Vector3.zero
    UpdateBeat:Add(self.Update, self)
end

function MobileInput:GetIsClickDown()
    return UnityEngine.Input.touchCount == 1 and UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Began
end

function MobileInput:GetIsClickUp()
    return UnityEngine.Input.touchCount == 1 and UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Ended
end

function MobileInput:GetIsDragging()
    return UnityEngine.Input.touchCount == 1 and UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Moved
end

function MobileInput:GetIsPoint()
    return UnityEngine.Input.touchCount == 1 and UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Stationary
end

function MobileInput:GetIsZoom()
    return UnityEngine.Input.touchCount == 2 and (UnityEngine.Input.GetTouch(0).phase == UnityEngine.TouchPhase.Moved or UnityEngine.Input.GetTouch(1).phase == UnityEngine.TouchPhase.Moved);
end

function MobileInput:AnyPress()
    return UnityEngine.Input.touchCount > 0;
end

function MobileInput:GetMoveV2()
    if (UnityEngine.Input.touchCount >= 1) then
        return UnityEngine.Input.GetTouch(0).deltaPosition
    else
        return Vector2.zero
    end
end

function MobileInput:IsMove()
    if (UnityEngine.Input.touchCount >= 1) and( UnityEngine.Input.GetTouch(0).deltaPosition.x ~= 0 or UnityEngine.Input.GetTouch(0).deltaPosition.y ~= 0 ) then
        return true
    else
        return false
    end
end

function MobileInput:GetZoomValue()
    return self.m_zoomValue
end

function MobileInput:GetClickFocusPoint()
    return UnityEngine.Input.GetTouch(0).position
end

function MobileInput:Update()
    if GetIsZoom then
        currentPosition0 = UnityEngine.Input.GetTouch(0).position;
        currentPosition1 = UnityEngine.Input.GetTouch(1).position;
        if (not self.m_Zoomed) then
            self.m_oldTouch0Pos = currentPosition0;
            self.m_oldTouch1Pos = currentPosition1;
            self.m_Zoomed = true;
        end
        local newDis = Vector3.Distance(currentPosition0, currentPosition1);
        local oldDis = Vector3.Distance(self.m_oldTouch0Pos, self.m_oldTouch1Pos);
        self.m_zoomValue = (newDis - oldDis) * Time.deltaTime;
        self.m_oldTouch0Pos = currentPosition0;
        self.m_oldTouch1Pos = currentPosition1;
        self.m_zoomCenter = (self.m_oldTouch0Pos + self.m_oldTouch1Pos) / 2;
    else
        self.m_zoomValue = 0;
        self.m_Zoomed = false;
    end
end


function MobileInput:Close()
    UpdateBeat:Remove(self.Update, self)
end