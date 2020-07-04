SpriteManager = {}
local SpritePools = {}          --All Sprite object pools  key：id   value：Sprite

local SpriteType = nil
local function LoadSpriteToPool(path, spriteID)
    --Do repeated loading judgment here
    if SpritePools[spriteID] ~= nil then
        return
    end
    --Initial load type
    if SpriteType == nil then
        SpriteType = ct.getType(UnityEngine.Sprite)
    end
    panelMgr:LoadPrefab_A(path, SpriteType, spriteID, function(spriteID, obj, ab)
        if spriteID == nil then
            return
        end
        if SpritePools[spriteID] == nil then
            local texture = ct.InstantiatePrefab(obj)
            SpritePools[spriteID]= texture
        end
    end)
end

---initializate SpriteManager
--initialize all spite
function SpriteManager.Init()
    SpritePools = {}
    --Initialized raw material picture
    for key, value in pairs(Material) do
        LoadSpriteToPool(value.img, key)
    end
    --Initial product picture
    for key, value in pairs(Good) do
        LoadSpriteToPool(value.img, key)
    end
    --Initialize money picture
    for key, value in pairs(MakeMoney) do
        LoadSpriteToPool(value.img, key)
    end
    --Architectural pictures of the Initial Research Institute and Data Corporation
    for key, value in pairs(ResearchConfig) do
        LoadSpriteToPool(value.buildingPath, key)
    end
end

--Get the corresponding Sprite from the object pool
function SpriteManager.GetSpriteByPool(spriteID)
    if SpritePools ~= nil and SpritePools[spriteID] ~= nil then
        return SpritePools[spriteID]
    else
        return nil
    end
end

MakeMoney = {
    --Residential pictures
    [0]={
        ["img"]="Assets/CityGame/Resources/View/iconImg/homehouse.png",
    },
}
