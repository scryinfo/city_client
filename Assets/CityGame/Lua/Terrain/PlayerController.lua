PlayerController = class('PlayerController')

function PlayerController:Awake(gameObject)

end

function PlayerController:Start(gameObject )
    TerrainManager.Refresh(CameraTool.GetCameraPosition())
end

function PlayerController:Update(gameObject)
    --TODO:响应点击拖动，点击物体

end

function PlayerController:OnDestroy(gameObject )

end

return PlayerController