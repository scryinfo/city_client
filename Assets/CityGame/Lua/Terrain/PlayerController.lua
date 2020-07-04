PlayerController = class('PlayerController')

function PlayerController:Awake(gameObject)

end

function PlayerController:Start(gameObject )
    TerrainManager.Refresh(CameraTool.GetCameraPosition())
end

function PlayerController:Update(gameObject)
    --TODO:Click objects in response to click and drag

end

function PlayerController:OnDestroy(gameObject )

end

return PlayerController