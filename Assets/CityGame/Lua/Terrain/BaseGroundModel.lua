--Model基类

local class = require 'Framework/class'
BaseGroundModel = class('BaseGroundModel')

--初始化
--将protobuf内数据拷贝出来
function BaseGroundModel:initialize(data)
    self.Data = {}
    self:Refresh(data)
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
    self.Data = data

    --判断是否应该有气泡
    if data.rent ~= nil and data.rent.renterId == nil then
        if self.bubbleItem == nil then
            self.bubbleItem = UIBubbleCtrl.getBubbleByType(UIBubbleType.GroundTrans, GroundTransState.Rent, {x = data.x, y = data.y})
            return
        end
        self.bubbleItem:_setBubbleState(GroundTransState.Rent)
        return
    end
    if data.sell ~= nil then
        if self.bubbleItem == nil then
            self.bubbleItem = UIBubbleCtrl.getBubbleByType(UIBubbleType.GroundTrans, GroundTransState.Sell, {x = data.x, y = data.y})
            return
        end
        self.bubbleItem:_setBubbleState(GroundTransState.Sell)
        return
    end
    --如果之前有气泡则直接干掉实例
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