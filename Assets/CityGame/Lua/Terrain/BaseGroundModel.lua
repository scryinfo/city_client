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
    if nil ~= DataManager.GetMyOwnerID() and self.Data[ownerId] == DataManager.GetMyOwnerID() and data.ownerId ~= DataManager.GetMyOwnerID() then
        DataManager.RemoveMyGroundInfo(data)
    end
    for key, value in pairs(data) do
        self.Data[key] = value
    end
end

function BaseGroundModel:Close()
    for key, value in pairs(self.Data) do
        value = nil
    end
    self = nil
end