--单独角色寻路脚本
PathFindItem = class('PathFindItem')
--playerName：角色名称（对象池名称）
--PlayerStartPosition:角色初始化位置
--PlayerEdgeDistance:角色和边界的距离（车和行人是不一样的）
function PathFindItem:initialize(playerPoolName,PlayerStartPosition,PlayerEdgeDistance)
    self.go = MapObjectsManager.GetGameObjectByPool(playerPoolName)
    self.poolName = playerPoolName
end

--寻找下一个目标点
function PathFindItem:FindNectTarget()
    --分为两步->1、在自己内部找2、在别的相邻两地块内部找

end

--报告自己的位置
function PathFindItem:ReportPosition()
    if self.go ~= nil then
        return  self.go.transform.position
    end
    return nil
end

--删除角色
function PathFindItem:Destory()
    if self.playerNam ~= nil and self.go ~= nil then
        MapObjectsManager.RecyclingGameObjectToPool(self.poolName,self.go)
    end
    self = nil
end