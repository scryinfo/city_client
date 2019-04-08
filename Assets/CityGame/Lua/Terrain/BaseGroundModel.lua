--Model基类

local class = require 'Framework/class'
BaseGroundModel = class('BaseGroundModel')

--初始化
--将protobuf内数据拷贝出来
function BaseGroundModel:initialize(data)
    self.Data = {}
    self:Refresh(data)
    --Event.AddListener("c_GroundBuildingCheck", self.CheckBubbleState, self)
    --玩家土地需要先初始化
    self:CreateMyGroundMaterial()
end

--刷新数据
function BaseGroundModel:Refresh(data)
    --判断是否自己的地块被卖给了别人
    --自己ID不等于nil，本来属于自己,现在不属于自己了
    if nil ~= DataManager.GetMyOwnerID() and self.Data.ownerId == DataManager.GetMyOwnerID() and data.ownerId ~= DataManager.GetMyOwnerID() then
        DataManager.RemoveMyGroundInfo(data)
    end
    --for key, value in pairs(data) do
    --    self.Data[key] = value
    --end
    self:CheckGroundTransSuccess(data)
    self.Data = data
    UIBubbleManager.startBubble()
    self:CheckBubbleState(data)

    if data.rent ~= nil and data.rent.renterId ~= nil and data.rent.renterId == DataManager.GetMyOwnerID() then
        DataManager.AddMyRentGroundInfo(data)
    end
end

--判断地块状态
function BaseGroundModel:CheckGroundTransSuccess(groundInfo)
    local groundState = GroundTransState.None  --现在的状态
    if groundInfo.rent then
        groundState = GroundTransState.Rent
        if groundInfo.rent.renterId == nil then
            groundState = GroundTransState.Renting
        end
    end
    if groundInfo.sell then
        groundState = GroundTransState.Sell
    end

    if self.groundState == nil then
        self.groundState = groundState
        return
    end
    --已经有了状态
    --之前的id~=自己，现在==自己，则购买成功
    if nil ~= DataManager.GetMyOwnerID() and self.Data.ownerId ~= DataManager.GetMyOwnerID() and groundInfo.ownerId == DataManager.GetMyOwnerID() then
        if self.groundState == GroundTransState.Sell and groundState == GroundTransState.None then
            Event.Brocast("SmallPop", GetLanguage(24040007), 300)
        end
    end
    if self.groundState == GroundTransState.Renting and groundState == GroundTransState.Rent then
        if groundInfo.rent.renterId == DataManager.GetMyOwnerID() then
            Event.Brocast("SmallPop", GetLanguage(24050010), 300)
        end
    end

    self.groundState = groundState
end

--判断是否应该有气泡
function BaseGroundModel:CheckBubbleState()
    local data = self.Data
    if data.rent ~= nil and data.rent.renterId == nil then
        if self.bubbleItem == nil then
            self.bubbleItem = UIBubbleManager.getBubbleByType(UIBubbleType.GroundTrans, GroundTransState.Rent, {x = data.x, y = data.y})
            return
        end
        self.bubbleItem:_setBubbleState(GroundTransState.Rent)
        return
    end
    if data.sell ~= nil then
        if self.bubbleItem == nil then
            self.bubbleItem = UIBubbleManager.getBubbleByType(UIBubbleType.GroundTrans, GroundTransState.Sell, {x = data.x, y = data.y})
            return
        end
        self.bubbleItem:_setBubbleState(GroundTransState.Sell)
        return
    end
    --如果之前有气泡则直接干掉实例
    if self.bubbleItem ~= nil then
        local blockId = TerrainManager.GridIndexTurnBlockID({x = data.x, y = data.y})
        UIBubbleManager.closeGTransItem(self.bubbleItem, blockId)
        self.bubbleItem = nil
    end
end

--创建玩家土地的土地材质
function BaseGroundModel:CreateMyGroundMaterial()
    self.poolName = PlayerBuildingBaseData[4000002].poolName
    self.go =MapObjectsManager.GetGameObjectByPool(self.poolName)
    --计算地块位置
    local data = self.Data
    if data ~= nil and data.x ~= nil and data.y ~= nil  then
        local blockID = TerrainManager.GridIndexTurnBlockID({x = data.x, y = data.y})
        --赋值玩家地块位置
        self.go.transform.position = TerrainManager.BlockIDTurnPosition(blockID)
        --移除系统土地建筑
        DataManager.RemoveSystemTerrainByBlock(blockID)
    end
end

--删除玩家的土地材质
function BaseGroundModel:DestoryMyGroundMaterial()
    if self.go ~= nil and self.poolName ~= nil then
        MapObjectsManager.RecyclingGameObjectToPool(self.poolName,self.go)
    end
end


function BaseGroundModel:Close()
    --删除玩家的土地材质
    self:DestoryMyGroundMaterial()
    --
    if self.bubbleItem ~= nil then
        local blockId = TerrainManager.GridIndexTurnBlockID({x = self.Data.x, y = self.Data.y})
        UIBubbleManager.closeGTransItem(self.bubbleItem, blockId)
        self.bubbleItem = nil
    end
    for key, value in pairs(self.Data) do
        value = nil
    end
    self.groundState = nil
    self = nil
end