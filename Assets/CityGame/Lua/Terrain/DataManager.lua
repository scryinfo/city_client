DataManager = {}

local BuildDataStack = {}     --建筑信息堆栈
local PersonDataStack = {}    --个人信息堆栈



--刷新基础地形数据
--data:某个建筑基础数据（protobuf）
function  DataManager.RefreshBaseBuildData(data)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(data.id)
    if nil == BuildDataStack[collectionID] then
        BuildDataStack[collectionID] = {}
    end
    if BuildDataStack[collectionID][data.id] then
        BuildDataStack[collectionID][data.id].BaseData:Refresh(data)
    else
        BuildDataStack[collectionID][data.id] ={ BaseData = BaseBuildModel:new(data) }
    end
end

--刷新详细地形数据
--data:某个建筑详细数据（protobuf）
--buildTypeClass:建筑类型
function DataManager.RefreshDetailBuildData(data,buildTypeClass)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(data.id)
    if not BuildDataStack[collectionID] then
        BuildDataStack[collectionID] = {}
    end
    if BuildDataStack[collectionID][data.id] then
        BuildDataStack[collectionID][data.id].DetailData:Refresh(data)
    else
        BuildDataStack[collectionID][data.id] ={ DetailData = buildTypeClass:new(data) }
    end
end

--清除某个地块集合信息
function DataManager.CloseBuildCollectionDataByID(collectionID)
    if  BuildDataStack[collectionID] then
        for key, value in pairs(BuildDataStack[collectionID]) do
            if value.BaseData then
                value.BaseData:Clear()
            end
            if value.DetailData then
                value.DetailData:Clear()
            end
            value = nil
        end
        BuildDataStack[collectionID] = nil
    end
end

--清除某个建筑基础信息
function DataManager.CloseBaseBuildDataByID(id)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(id)
    if  BuildDataStack[collectionID] and BuildDataStack[collectionID][id] and BuildDataStackp[collectionID][id].BaseData then
        BuildDataStack[collectionID][id].BaseData:Clear()
        BuildDataStack[collectionID][id].BaseData = nil
    end
end

--清除某个建筑详细信息
function DataManager.CloseDetailBuildDataByID(id)
    local collectionID =  TerrainManager.BlockIDTurnCollectionID(id)
    if BuildDataStack[collectionID] and BuildDataStack[collectionID][id] and BuildDataStack[collectionID][id].DetailData then
        BuildDataStack[collectionID][id].DetailData:Clear()
        BuildDataStack[collectionID][id].DetailData = nil
    end
end

--清除所有数据
function  DataManager.ClearAllDatas(dataTable)
    for key, value in pairs(dataTable) do
        value = nil
    end
end
