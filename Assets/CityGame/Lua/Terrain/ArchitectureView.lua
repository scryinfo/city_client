local class = require 'Framework/class'
ArchitectureView = class('ArchitectureView')

--Initialization
--Copy the data in protobuf
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
