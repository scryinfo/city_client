LuaGameObjectPool = class('LuaGameObjectPool')

local tableRemove =table.remove
local tableInsert =table.insert
--local starttime ,endtime
local go_GetAvailableGameObject
local  UnityGameObject
-----初始化函数
---poolname：对象池名字（根据名字进行回收）
---poolPrefab：对象池的基础拷贝物体
---poolInitSize：对象池初始化大小（个数）
---hidePosition：对象隐藏时的位置
---PoolsRoot：所有Pool的根节点
function LuaGameObjectPool:initialize(poolname,poolPrefab,poolInitSize,hidePosition,PoolsRoot)
    self.m_poolName = poolname                      --对象池名字
    self.poolRoot = UnityEngine.GameObject.New("Pool_"..tostring(poolname)).transform   --可用GameObject对象池物体节点（其实不必要）
    --挂在对象池根节点下
    if PoolsRoot ~= nil then
        self.poolRoot:SetParent(PoolsRoot)
    end
    UnityGameObject = UnityEngine.GameObject
    poolPrefab.transform:SetParent(self.poolRoot)
    poolPrefab.transform.position = hidePosition
    poolPrefab.name = poolname
    self.m_poolInitSize = poolInitSize              --对象池初始化实例个数
    self.m_availableObjPool = {}                    --可用GameObject对象池
    self.m_hideGameObjectPosition = hidePosition    --游戏对象隐藏的坐标点（极远值）
    self.m_poolPrefab = poolPrefab                  --对象池基础的Prefab，其余对象均拷贝自m_poolPrefab
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
--从可用对象池中获取对象
function LuaGameObjectPool:GetAvailableGameObject()
    if #self.m_availableObjPool <= 0 then
        tempObj_GetAvailableGameObject = self:NewObjectInstance()
        self:AddGameObjectToPool(tempObj_GetAvailableGameObject)
    end
    go_GetAvailableGameObject = self.m_availableObjPool[#self.m_availableObjPool]
    tableRemove(self.m_availableObjPool,#self.m_availableObjPool)
    return go_GetAvailableGameObject
end

--回收对象到可用对象池中
function LuaGameObjectPool:RecyclingGameObjectToPool(go)
    if go ~= nil then
        self:AddGameObjectToPool(go)
    end
end

