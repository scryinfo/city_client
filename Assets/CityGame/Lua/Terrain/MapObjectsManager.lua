MapObjectsManager = {}
local AllMaterial = {}
local AllObjectPools = {}
local RendererType = nil
local PoolsRoot = nil
local AllCount = 0

--After the creation of Prefab is successful, the initial corresponding Pool
local function CreateBasePrefabSuccess(tempPrefab,item)
    if tempPrefab ~= nil then
        --Initialize the object pool
        AllObjectPools[item.Name] = LuaGameObjectPool:new(item.Name,tempPrefab,item.InitCount,MapGameObjectsConfig.HidePosition,PoolsRoot)
        AllCount = AllCount - 1
    end
end

function MapObjectsManager.GetLoadingAssetsCount()
    return AllCount
end


function MapObjectsManager.AddMaterial(ParentObj)
    --collectgarbage("collect")
    --local c1 = collectgarbage("count")
    if RendererType ~= nil then
        local allrender = ParentObj:GetComponentsInChildren(RendererType):ToTable()
        if allrender ~= nil then
            for i, tempRender in pairs(allrender) do
                for i, tempMaterial in pairs(tempRender.sharedMaterials:ToTable()) do
                    local tempInsId = tempMaterial:GetInstanceID()
                    if  AllMaterial[tempInsId] == nil then
                        AllMaterial[tempInsId] = tempMaterial
                    end
                end
            end
        end
    end
    --local c2 = collectgarbage("count")
    --ct.log("system",   c2 -c1)
    --collectgarbage("collect")
end


--Initialize all building object pools
function MapObjectsManager.Init()
    AllMaterial = {}
    AllObjectPools = {}
    PoolsRoot = UnityEngine.GameObject.New("PoolsRoot").transform
    RendererType = typeof(UnityEngine.Renderer)
    --Initialize the basic building Prefeb (asynchronous)
    local PoolInstantiates = MapGameObjectsConfig.PoolInstantiate
    for i, item in pairs(PoolInstantiates) do
        AllCount = AllCount + 1
        if item.PlayerBuildingBaseDataID ~= nil then
            buildMgr:CreateBuild(PlayerBuildingBaseData[item.PlayerBuildingBaseDataID]["prefabRoute"] ,CreateBasePrefabSuccess,item)
        elseif item.RoadPrefabConfigID ~= nil then
            buildMgr:CreateBuild(RoadPrefabConfig[item.RoadPrefabConfigID]["prefabRoute"] ,CreateBasePrefabSuccess,item)
        elseif item.PathFindingConfigID ~= nil then
            buildMgr:CreateBuild(PathFindingConfig[item.PathFindingConfigID]["prefabRoute"] ,CreateBasePrefabSuccess,item)
        end
    end
    --Initialize the central building
    --TerrainManager.CreateCenterBuilding()
end
local starttime ,endtime
local go_GetGameObjectByPool
local tempPool_GetGameObjectByPool
--Request an available GameObject from an object pool
function MapObjectsManager.GetGameObjectByPool(poolName)
    if poolName ~= nil and AllObjectPools[poolName] ~= nil then
        --starttime = os.clock()
        tempPool_GetGameObjectByPool = AllObjectPools[poolName]
        go_GetGameObjectByPool  = tempPool_GetGameObjectByPool:GetAvailableGameObject()
        --endtime = os.clock()
        --ct.log("system","从众多池里取一个耗时"..endtime - starttime)
        return go_GetGameObjectByPool
        --return UnityEngine.GameObject.New()
    end
    return nil
end

--Return a GameObject that is no longer in use to an object pool
function MapObjectsManager.RecyclingGameObjectToPool(poolName,go)
    if poolName ~= nil and AllObjectPools[poolName] ~= nil and go ~= nil then
        AllObjectPools[poolName]:RecyclingGameObjectToPool(go)
    end
end

function MapObjectsManager.ChangeShader(ShaderSetting)
    local temp_DiffuseColor = ShaderSetting._DiffuseColor
    local temp_DayLightColor = ShaderSetting._DayLightColor
    local temp_DayLightStrength = ShaderSetting._DayLightStrength
    local temp_LightStrengh = ShaderSetting._LightStrengh
    for i, tempMaterial in pairs(AllMaterial) do
        if temp_DiffuseColor ~= nil then
            tempMaterial:SetColor("_DiffuseColor",temp_DiffuseColor)
        end
        if temp_DayLightColor ~= nil then
            tempMaterial:SetColor("_DayLightColor",temp_DayLightColor)
        end
        if temp_DayLightStrength ~= nil then
            tempMaterial:SetFloat("_DayLightStrength",temp_DayLightStrength)
        end
        if temp_LightStrengh ~= nil then
            tempMaterial:SetFloat("_LightStrengh",temp_LightStrengh)
        end
    end
end
