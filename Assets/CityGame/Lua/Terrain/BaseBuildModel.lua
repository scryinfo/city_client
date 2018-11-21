--Model基类

local class = require 'Framework/class'
BaseBuildModel = class('BaseBuildModel')

--初始化
--将protobuf内数据拷贝出来
function BaseBuildModel:initialize(data)
    self.Data = {}
    self:Refresh(data)
end

--刷新数据
function BaseBuildModel:Refresh(data)
    --ct.log("Allen_w9","请使用BaseModel派生类自己的Refresh方法，尽量不要调用基类的 Refresh 方法")
    for key, value in pairs(data) do
        self.Data[key] = value
    end
    DataManager.RefreshBlockDataWhenNodeChange(data.id,PlayerBuildingBaseData[data.buildId].x)
end

function BaseBuildModel:Close()
    for  key, value in pairs(self.Data) do
        value = nil
    end
    --清除建筑GameObject
    if self.go ~= nil then
        Destory(self.go)
    end
    self = nil
end