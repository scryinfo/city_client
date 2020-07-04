--Model基类

local class = require 'Framework/class'
BaseBuildModel = class('BaseBuildModel')

--initialization
--将protobuf内数据拷贝出来
function BaseBuildModel:initialize(data)
    self.Data = {}
    self:Refresh(data)
    Event.AddListener("c_GroundBuildingCheck", self.CheckBubbleState, self)
end

--刷新数据
function BaseBuildModel:Refresh(data)
    --ct.log("Allen_w9","请使用BaseModel派生类自己的Refresh方法，尽量不要调用基类的 Refresh 方法")
    for key, value in pairs(data) do
        self.Data[key] = value
    end
    DataManager.RefreshBlockDataWhenNodeChange(data.posID,PlayerBuildingBaseData[data.buildingID].x,data.posID)
    DataManager.RefreshPathRangeBlock(data.posID,PlayerBuildingBaseData[data.buildingID].x)
    UIBubbleManager.startBubble()
    self:CheckBubbleState()
    --建筑气泡
    if self.bubbleIns then
        self.bubbleIns:updateData(data)
        --[[
        if data.bubble then
            self.bubbleIns:updateData(data)
        else
            DataManager.buildingBubblePool:RecyclingGameObjectToPool(self.bubbleIns.prefab)
            AvatarManger.CollectAvatar(self.bubbleIns.avatarData)
        end
        --]]
    else
        if data.bubble then
            self.bubble = DataManager.buildingBubblePool:GetAvailableGameObject()
            self.bubbleIns= UIBubbleBuildingSignItem:new(self.bubble,data,BuilldingBubbleInsManger)
            prints(data.name.."生成气泡")
        end
    end
end

--打开界面
function BaseBuildModel:OpenPanel()
    --ct.log("Allen_w9","请使用BaseModel派生类自己的OpenPanel方法，尽量不要调用基类的OpenPanel方法")
    --TODO:在具体子类中做打开操作
    local typeID = self.Data.buildingID
    local instanceID = self.Data.id
    if typeID == 1100001 or typeID == 1100002 or typeID == 1100003 then         --Raw material factory
        ct.OpenCtrl("MaterialFactoryCtrl", {insId = instanceID})
    elseif typeID == 1200001 or typeID == 1200002 or typeID == 1200003 then    --Processing plant
        ct.OpenCtrl('ProcessingFactoryCtrl',{insId = instanceID})
    elseif typeID == 1300001 or typeID == 1300002 or typeID == 1300003 then    --Retail store
        ct.OpenCtrl("RetailStoresCtrl",{insId = instanceID})
    elseif typeID == 1400001 or typeID == 1400002 or typeID == 1400003 then    --Residential
        ct.OpenCtrl("HouseCtrl", {insId = instanceID})
    elseif typeID == 1500001 or typeID == 1500002 or typeID == 1500003 then    --graduate School
        ct.OpenCtrl("ResearchInstituteCtrl", {insId = instanceID})
    elseif typeID == 1600001 or typeID == 1600002 or typeID == 1600003 then    --park
        --Event.Brocast("m_detailPublicFacility",instanceID)
        ct.OpenCtrl("DataCompanyCtrl",{insId=instanceID})
    elseif typeID == 1700001 or typeID == 1700002 or typeID == 1700003 then    --Distribution center
        --Event.Brocast("m_detailPublicFacility",instanceID)
        ct.OpenCtrl("BuidingWareHouseCtrl",{insId=instanceID})
    end
end

function BaseBuildModel:CheckBubbleState()
    local data = self.Data
    if data.ownerId == DataManager.GetMyOwnerID() then
        if self.bubbleItem == nil then
            local deviationPos = PlayerBuildingBaseData[data.buildingID].deviationPos
            self.bubbleItem = UIBubbleManager.getBubbleByType(UIBubbleType.BuildingSelf, GroundTransState.None, {x = data.x, y = data.y}, deviationPos)
            return
        end
    end
end

function BaseBuildModel:Close()
    if self.bubbleIns then
        AvatarManger.CollectAvatar(self.bubbleIns.avatarData)
        self.bubbleIns:Close()
        self.bubble = nil
        self.bubbleIns = nil
    end
    --删除节点
    DataManager.RefreshBlockDataWhenNodeChange(self.Data.posID,PlayerBuildingBaseData[self.Data.buildingID].x,-1)
    --删除路径数据
    DataManager.RemovePathRangeBlock(self.Data.posID,PlayerBuildingBaseData[self.Data.buildingID].x)
    --清除建筑GameObject
    if self.go ~= nil then
        MapObjectsManager.RecyclingGameObjectToPool(PlayerBuildingBaseData[self.Data.buildingID].poolName,self.go)
    end
    if self.bubbleItem ~= nil then
        self.bubbleItem:Close()
        self.bubbleItem = nil
    end
    self = nil
end