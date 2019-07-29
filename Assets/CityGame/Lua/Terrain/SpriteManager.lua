SpriteManager = {}
local SpritePools = {}          --所有Sprite的对象池  key：id   value：Sprite

local SpriteType = nil
local function LoadSpriteToPool(path, spriteID)
    --此处做重复加载判断
    if SpritePools[spriteID] ~= nil then
        return
    end
    --初始化加载类型
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

---初始化SpriteManager
--初始化所有spite
function SpriteManager.Init()
    SpritePools = {}
    --初始化原料图片
    for key, value in pairs(Material) do
        LoadSpriteToPool(value.img, key)
    end
    --初始化商品图片
    for key, value in pairs(Good) do
        LoadSpriteToPool(value.img, key)
    end
    --初始化赚钱图片
    for key, value in pairs(MakeMoney) do
        LoadSpriteToPool(value.img, key)
    end
end

--从对象池中拿到对应的Sprite
function SpriteManager.GetSpriteByPool(spriteID)
    if SpritePools ~= nil and SpritePools[spriteID] ~= nil then
        return SpritePools[spriteID]
    else
        return nil
    end
end

MakeMoney = {
    --住宅图片
    [0]={
        ["img"]="Assets/CityGame/Resources/View/iconImg/homehouse.png",
    },
}
