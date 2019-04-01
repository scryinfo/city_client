BuildingInfoMainGroupMgr = class('BuildingInfoMainGroupMgr')

--初始化基础数据
--alignType ： 对齐方式 （左对齐/右对齐/中心对齐）
function BuildingInfoMainGroupMgr:initialize(mainGroupGO,mainPanelLuaBehaviour,alignType)
    self.myParts ={}
    self.totalWidthPercentage = 0
    self.mainGroupGo = mainGroupGO
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    if mainGroupGO ~= nil then
        self.mainGroupTrans = mainGroupGO.transform
    end
    self.m_data = nil
end

-------------------------------------------------------------------私有函数--------------------------------------------

--计算初始化的时候的X位置
function BuildingInfoMainGroupMgr:_CaculationPartPositionX()
    local posX = - (self.totalWidthPercentage * 1920) * Game.ScreenRatio
    return posX
end

--计算初始化的时候的Part宽度
function BuildingInfoMainGroupMgr:_CaculationPartWidthByWidthPercentage(widthPercentage)
    local sizeWidth = (widthPercentage * 1920) * Game.ScreenRatio
    return sizeWidth
end

--计算初始化的时候的Part宽度
function BuildingInfoMainGroupMgr:_CaculationPartWidthByPixel(widthPixel)
    local sizeWidth = (widthPixel) * Game.ScreenRatio
    return sizeWidth
end

------------------------------------------------------------------公共函数---------------------------------------------
--初始化某个Part
--partClass : part对应的脚本
--widthPercentage : part宽度所占百分比
function BuildingInfoMainGroupMgr:AddParts(partClass,widthPercentage)
    --Part初始函数因传值:Self,posX,sizeWidth，Index
    local partIndex = #self.myParts + 1
    local partGo = self:GetPartGameObject(partClass.PrefabName())
    local tmepPart = partClass:new(partGo,self,self:_CaculationPartPositionX(),self:_CaculationPartWidthByWidthPercentage(widthPercentage),partIndex,self.mainPanelLuaBehaviour)
    self.myParts[partIndex] = tmepPart
    self.totalWidthPercentage = self.totalWidthPercentage + widthPercentage
end

--切换到某个选项
--partIndex: part索引
function BuildingInfoMainGroupMgr:SwitchingOptions(partIndex)
    if self.myParts ~= nil and self.myParts[partIndex]  ~= nil then
        for key, value in ipairs(self.myParts) do
            if  key == partIndex then
                value:ShowDetail(self.m_data) --打开详情进行显示
            else
                value:HideDetail() --隐藏详情进行显示
            end
        end
    end
end

--关闭所有选项
function BuildingInfoMainGroupMgr:TurnOffAllOptions()
    if self.myParts ~= nil then
        for key, value in ipairs(self.myParts) do
            value:HideDetail() --隐藏详情进行显示
        end
    end
end

--刷新整体数据
function BuildingInfoMainGroupMgr:RefreshData(data)
    if data ~= nil and self.m_data == nil then
        self.m_data = data
    end
    if self.myParts ~= nil then
        for key, value in ipairs(self.myParts) do
            value:Refresh(self.m_data) --刷新数据
        end
    end
end

--TODO:调用加载
function  BuildingInfoMainGroupMgr:GetPartGameObject(partName)
    if self.mainGroupTrans ~= nil then
        local tempGo = self.mainGroupTrans:Find("Parts/".. partName)
        return tempGo
    end
end

--TODO:调用加载
function BuildingInfoMainGroupMgr:GetPartDatailGameObject(partDetailName)
    if self.mainGroupTrans ~= nil then
        local tempGo = self.mainGroupTrans:Find("PartsDetails/".. partDetailName)
        tempGo.transform.localScale = Vector3.one
        return tempGo
    end
end


--关闭页面，应清除所有实例，并将UI显示还原，注销监听事件
function BuildingInfoMainGroupMgr:Destroy()
    if self.myParts ~= nil then
        for key, value in ipairs(self.myParts) do
            value:Destroy() --注销Part
        end
    end
    self = nil
end