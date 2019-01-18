--Model基类

local class = require 'Framework/class'
BaseGroundModel = class('BaseGroundModel')

--初始化
--将protobuf内数据拷贝出来
function BaseGroundModel:initialize(data)
    self.Data = {}
    self:Refresh(data)

    Event.AddListener("c_GroundBuildingCheck", self.CheckBubbleState, self)
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
    --self:CheckGroundTransSuccess(data)
    UIBubbleManager.startBubble()
    self:CheckBubbleState(data)
    self.Data = data
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
            Event.Brocast("SmallPop", "购买成功", 300)
        end
    end
    if self.groundState == GroundTransState.Renting and groundState == GroundTransState.Rent then
        if groundInfo.rent.renterId == DataManager.GetMyOwnerID() then
            Event.Brocast("SmallPop", "租赁成功", 300)
        end
    end

    self.groundState = groundState
end

--判断是否应该有气泡
function BaseGroundModel:CheckBubbleState()
    local data = self.Data
    if data.rent ~= nil and data.rent.renterId == nil then
        self.groundState = GroundTransState.Rent
        if self.bubbleItem == nil then
            self.bubbleItem = UIBubbleManager.getBubbleByType(UIBubbleType.GroundTrans, GroundTransState.Rent, {x = data.x, y = data.y})
            return
        end
        self.bubbleItem:_setBubbleState(GroundTransState.Rent)
        return
    end
    if data.sell ~= nil then
        self.groundState = GroundTransState.Sell
        if self.bubbleItem == nil then
            self.bubbleItem = UIBubbleManager.getBubbleByType(UIBubbleType.GroundTrans, GroundTransState.Sell, {x = data.x, y = data.y})
            return
        end
        self.bubbleItem:_setBubbleState(GroundTransState.Sell)
        return
    end
    --如果之前有气泡则直接干掉实例
    self.groundState = GroundTransState.None
    if self.bubbleItem ~= nil then
        self.bubbleItem:Close()
        self.bubbleItem = nil
    end
end

function BaseGroundModel:Close()
    for key, value in pairs(self.Data) do
        value = nil
    end
    if self.bubbleItem ~= nil then
        self.bubbleItem:Close()
    end
    self = nil
end