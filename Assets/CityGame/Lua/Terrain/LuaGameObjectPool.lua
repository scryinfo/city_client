LuaGameObjectPool = class('LuaGameObjectPool')

local tableRemove =table.remove
local tableInsert =table.insert
--local starttime ,endtime
local go_GetAvailableGameObject
local  UnityGameObject
-----Initialization function
---poolname: object pool name (recycle based on name)
---poolPrefab: basic copy object of object pool
---poolInitSize: object pool initialization size (number)
---hidePosition: the position of the object when it is hidden
---PoolsRoot: the root node of all Pools
function LuaGameObjectPool:initialize(poolname,poolPrefab,poolInitSize,hidePosition,PoolsRoot)
    self.m_poolName = poolname                      --Object pool name
    self.poolRoot = UnityEngine.GameObject.New("Pool_"..tostring(poolname)).transform   --Available GameObject object pool object node (actually unnecessary)
    --Hang under the root node of the object pool
    if PoolsRoot ~= nil then
        self.poolRoot:SetParent(PoolsRoot)
    end
    UnityGameObject = UnityEngine.GameObject
    poolPrefab.transform:SetParent(self.poolRoot)
    poolPrefab.transform.position = hidePosition
    poolPrefab.name = poolname
    self.m_poolInitSize = poolInitSize              --Number of object pool initialization instances
    self.m_availableObjPool = {}                    --Available GameObject object pool
    self.m_hideGameObjectPosition = hidePosition    --The hidden coordinate point (extreme value) of the game object
    self.m_poolPrefab = poolPrefab                  --Prefab based on the object pool, the remaining objects are copied from m_poolPrefab
    self:InitGameObjectPool()
end

function LuaGameObjectPool:InitGameObjectPool()
    MapObjectsManager.AddMaterial(self.m_poolPrefab )
    for i = 1, self.m_poolInitSize do
        self:AddGameObjectToPool(self:NewObjectInstance())
    end
end

local tempObj_NewObjectInstance
function LuaGameObjectPool:NewObjectInstance()
    if self.m_poolPrefab ~= nil then
        tempObj_NewObjectInstance = UnityGameObject.Instantiate(self.m_poolPrefab)
        return tempObj_NewObjectInstance
    end
    return nil
end

function LuaGameObjectPool:AddGameObjectToPool(go)
    if go ~= nil then
        go.transform:SetParent(self.poolRoot)
        go.transform.position = self.m_hideGameObjectPosition
        tableInsert(self.m_availableObjPool,go)
    end
end

local tempObj_GetAvailableGameObject
--Get objects from the pool of available objects
function LuaGameObjectPool:GetAvailableGameObject()
    if #self.m_availableObjPool <= 0 then
        tempObj_GetAvailableGameObject = self:NewObjectInstance()
        self:AddGameObjectToPool(tempObj_GetAvailableGameObject)
    end
    go_GetAvailableGameObject = self.m_availableObjPool[#self.m_availableObjPool]
    tableRemove(self.m_availableObjPool,#self.m_availableObjPool)
    return go_GetAvailableGameObject
end

--Recycle objects into the available object pool
function LuaGameObjectPool:RecyclingGameObjectToPool(go)
    if go ~= nil then
        self:AddGameObjectToPool(go)
    end
end

