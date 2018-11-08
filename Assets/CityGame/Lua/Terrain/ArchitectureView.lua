local class = require 'Framework/class'
ArchitectureView = class('ArchitectureView')

--初始化
--将protobuf内数据拷贝出来
function ArchitectureView:initialize()

end

function ArchitectureView:Awake(gameObject)
    self.gameobject  = gameObject
end

function ArchitectureView:Start(gameObject )

end
function ArchitectureView:Update(gameObject)

end
function ArchitectureView:OnDestroy(gameObject )

end

function ArchitectureView:Destory()
    Destory(self.gameobject)
end

return ArchitectureView:new()
