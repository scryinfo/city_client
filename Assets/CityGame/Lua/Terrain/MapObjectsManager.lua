MapObjectsManager = {}
local AllObjectPools = {}

--创建Prefab成功后初始对应Pool
local function CreateBasePrefabSuccess(tempPrefab,item)
    AllObjectPools[item.Name] = LuaGameObjectPool:new(item.Name,tempPrefab,item.InitCount,MapGameObjectsConfig.HidePosition)
end

--初始化所有的建筑对象池
function MapObjectsManager.Init()
    AllObjectPools = {}
    --初始化基础建筑Prefeb（异步）
    local PoolInstantiates = MapGameObjectsConfig.PoolInstantiate
    for i, item in pairs(PoolInstantiates) do
        buildMgr:CreateBuild(PlayerBuildingBaseData[item.PlayerBuildingBaseDataID]["prefabRoute"] ,CreateBasePrefabSuccess,item)
    end
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