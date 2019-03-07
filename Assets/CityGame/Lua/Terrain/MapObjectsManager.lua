MapObjectsManager = {}
local AllMaterial = {}
local AllObjectPools = {}
local RendererType = nil

--创建Prefab成功后初始对应Pool
local function CreateBasePrefabSuccess(tempPrefab,item)
    if tempPrefab ~= nil then
        --初始化对象池
        AllObjectPools[item.Name] = LuaGameObjectPool:new(item.Name,tempPrefab,item.InitCount,MapGameObjectsConfig.HidePosition)
    end
end

function MapObjectsManager.AddMaterial(ParentObj)
    collectgarbage("collect")
    local c1 = collectgarbage("count")
    if RendererType ~= nil then
        local allrender = ParentObj:GetComponentsInChildren(RendererType):ToTable()
        if allrender ~= nil then
            for i, tempRender in pairs(allrender) do
                for i, tempMaterial in pairs(tempRender.materials:ToTable()) do
                    local tempInsId = tempMaterial:GetInstanceID()
                    if  AllMaterial[tempInsId] == nil then
                        AllMaterial[tempInsId] = tempMaterial
                    end
                end
            end
        end
    end
    local c2 = collectgarbage("count")
    ct.log("system",   c2 -c1)
    collectgarbage("collect")
end


--初始化所有的建筑对象池
function MapObjectsManager.Init()
    AllMaterial = {}
    AllObjectPools = {}
    RendererType = typeof(UnityEngine.Renderer)
    --初始化基础建筑Prefeb（异步）
    local PoolInstantiates = MapGameObjectsConfig.PoolInstantiate
    for i, item in pairs(PoolInstantiates) do
        if item.PlayerBuildingBaseDataID ~= nil then
            buildMgr:CreateBuild(PlayerBuildingBaseData[item.PlayerBuildingBaseDataID]["prefabRoute"] ,CreateBasePrefabSuccess,item)
        elseif item.RoadPrefabConfig ~= nil then
            buildMgr:CreateBuild(RoadPrefabConfig[item.RoadPrefabConfig]["prefabRoute"] ,CreateBasePrefabSuccess,item)
        end
    end
    --初始化中心建筑
    --TerrainManager.CreateCenterBuilding()
end

--向某个对象池请求获取一个可用的GameObject
function MapObjectsManager.GetGameObjectByPool(poolName)
    if AllObjectPools[poolName] ~= nil then
        return AllObjectPools[poolName]:GetAvailableGameObject()
    end
    return nil
end

--向某个对象池还回不再使用的GameObject
function MapObjectsManager.RecyclingGameObjectToPool(poolName,go)
    if AllObjectPools[poolName] ~= nil and go ~= nil then
        AllObjectPools[poolName]:RecyclingGameObjectToPool(go)
    end
end


function MapObjectsManager.ChangeShader()
    local tempColor = getColorByInt(math.random(0, 255),math.random(0, 255),math.random(0, 255),1)
    for i, tempMaterial in pairs(AllMaterial) do
        tempMaterial:SetColor("_DiffuseColor",tempColor)
        tempMaterial:SetColor("_DayLightColor",tempColor)
        tempMaterial:SetFloat("_DayLightStrength",1)
        tempMaterial:SetFloat("_LightStrengh",1)
    end
end
