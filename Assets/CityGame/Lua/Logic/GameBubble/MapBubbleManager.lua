---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/3/5 15:50
---小地图气泡管理
MapBubbleManager= {}
local this = MapBubbleManager
local prefabPools = {}

local MapBuildingItemName = "MapBuildingItem"
local MapSearchResultItemName = "MapSearchResultItem"
local MapAllSearchItemName = "MapAllSearchItem"

MapBubbleManager.TempBuildingIconPath =
{
    House = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    MaterialFactory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-Material.png",
    Municipal = "",
    MunicipalManage = "",
    ProcessingFactory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-Fatory.png",
    Laboratory = "",
    RetailShop = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-SuperMarket.png",
    TalentCenter = "",
}

function MapBubbleManager.initMapSetting(itemWidth, mapCtrl)
    this.itemWidth = itemWidth
    this.itemDelta = Vector2.New(itemWidth, itemWidth)
    this.selfBuildings = {}
    this.mapCtrl = mapCtrl

    --TODO:实例化改成从池里拿
    prefabPools[MapBuildingItemName] = LuaGameObjectPool:new(MapBuildingItemName, MapPanel.mapBuildingItem, 5, Vector3.New(-999,-999,-999))
    prefabPools[MapSearchResultItemName] = LuaGameObjectPool:new(MapSearchResultItemName, MapPanel.mapSearchResultItem, 5, Vector3.New(-999,-999,-999))
    prefabPools[MapAllSearchItemName] = LuaGameObjectPool:new(MapAllSearchItemName, MapPanel.mapAllSearchItem, 5, Vector3.New(-999,-999,-999))
end
--设置地块移动改变时，旧的id
function MapBubbleManager.setOldAOICenterID(id)
    this.oldCollectionID = id
end
--打开小地图之前的中心位置  --用于关闭小地图后的归位
function MapBubbleManager.setBackCollectionID()
    this.backCollectionId = TerrainManager.GetCameraCollectionID()
end
--关闭小地图，复原位置
function MapBubbleManager.setCameraToBackID()
    local tempId = TerrainManager.GetCameraCollectionID()
    if tempId ~= this.backCollectionId then
        local blockId = TerrainManager.CollectionIDTurnBlockID(this.backCollectionId)
        local pos = TerrainManager.BlockIDTurnPosition(blockId)
        Event.Brocast("CameraMoveTo", pos)
    end
end

--创建系统建筑，暂时只有中心建筑
function MapBubbleManager.createSystemItem()
    local obj = UnityEngine.GameObject.Instantiate(MapPanel.mapSystemItem, MapPanel.alwaysShowRoot)
    obj.transform:SetParent(MapPanel.alwaysShowRoot.transform)
    local item = MapSystemItem:new({tempPath = ""}, obj.transform)
    local pos = Vector2.New(TerrainConfig.CentralBuilding.CenterNodePos.z ,- TerrainConfig.CentralBuilding.CenterNodePos.x ) * this.itemWidth
    local delta = this.itemDelta * PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].x
    item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, delta)
    this.centerItem = item

    --local objRect = obj:GetComponent("RectTransform")
    --local rectPos =
    --objRect.anchoredPosition = rectPos * this.itemWidth
    ----objRect.sizeDelta = this.itemDelta *  PlayerBuildingBaseData[TerrainConfig.CentralBuilding.BuildingType].x
    --rectPos.y = - rectPos.y
end
--
function MapBubbleManager.initItemData()
    --根据配置表生成建筑Items
    local MyBuild = DataManager.GetMyAllBuildingDetail()
    --生成住宅
    if MyBuild.apartment ~= nil then
        this._createBuildingItems(MyBuild.apartment, BuildingType.House)
    end
    --生成原料厂
    if MyBuild.materialFactory ~= nil then
        this._createBuildingItems(MyBuild.materialFactory, BuildingType.MaterialFactory)
    end
    --生成加工厂
    if MyBuild.produceDepartment ~= nil then
        this._createBuildingItems(MyBuild.produceDepartment, BuildingType.ProcessingFactory)
    end
    --生成零售店
    if MyBuild.retailShop ~= nil then
        this._createBuildingItems(MyBuild.retailShop, BuildingType.RetailShop)
    end
end
--
function MapBubbleManager._createBuildingItems(itemDatas, buildingType)
    for key, value in pairs(itemDatas) do
        if value.info ~= nil and value.info.pos ~= nil and value.info.pos.x ~= nil and value.info.pos.y ~= nil and value.info.mId ~= nil and PlayerBuildingBaseData[value.info.mId] ~= nil and PlayerBuildingBaseData[value.info.mId].x ~= nil  then
            --local obj = UnityEngine.GameObject.Instantiate(MapPanel.mapBuildingItem)
            local obj = prefabPools[MapBuildingItemName]:GetAvailableGameObject()
            obj.transform:SetParent(MapPanel.alwaysShowRoot.transform)
            obj.transform.localPosition = Vector3.zero
            local item = MapBuildingItem:new({tempPath = this._getBuildingIconPath(buildingType), poolName = MapBuildingItemName}, obj.transform)
            this.selfBuildings[value.info.id] = item
            local pos = Vector2.New( value.info.pos.y, - value.info.pos.x) * this.itemWidth
            local delta = this.itemDelta *  PlayerBuildingBaseData[value.info.mId].x
            item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, delta)
        end
    end
end
--生成摘要item
function MapBubbleManager._createSummaryItems(data)
    local obj = UnityEngine.GameObject.Instantiate(MapPanel.mapAllSearchItem)
    --local obj = prefabPools[MapBuildingItemName]:GetAvailableGameObject()
    obj.transform:SetParent(MapPanel.allSearchRoot.transform)
    obj.transform.localPosition = Vector3.zero
    local item = MapAllSearchItem:new({num = data.num, poolName = MapAllSearchItemName}, obj.transform)

    local collectionId = TerrainManager.AOIGridIndexTurnCollectionID(data.idx)
    local blockId = TerrainManager.CollectionIDTurnBlockID(collectionId)
    local tempPos = TerrainManager.BlockIDTurnPosition(blockId)
    this.summaryItems[collectionId] = item
    local pos = Vector2.New(tempPos.x, -tempPos.z) * this.itemWidth
    item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, 0)
end
--生成详情Item
function MapBubbleManager._createDetailItems(data)
    --local obj = UnityEngine.GameObject.Instantiate(MapPanel.mapSearchResultItem)
    local obj = prefabPools[MapSearchResultItemName]:GetAvailableGameObject()
    obj.transform:SetParent(MapPanel.detailSearchRoot.transform)
    obj.transform.localPosition = Vector3.zero
    local item = MapSearchResultItem:new({detailData = data, itemWidth = this.itemWidth, poolName = MapSearchResultItemName}, obj.transform)
    return item
end
--获取正确的icon路径
function MapBubbleManager._getBuildingIconPath(buildingType)
    local path
    if buildingType == BuildingType.House then
        path = this.TempBuildingIconPath.House
    elseif buildingType == BuildingType.MaterialFactory then
        path = this.TempBuildingIconPath.MaterialFactory
    elseif buildingType == BuildingType.Municipal then
        path = this.TempBuildingIconPath.Municipal
    elseif buildingType == BuildingType.MunicipalManage then
        path = this.TempBuildingIconPath.MunicipalManage
    elseif buildingType == BuildingType.TalentCenter then
        path = this.TempBuildingIconPath.TalentCenter
    elseif buildingType == BuildingType.ProcessingFactory then
        path = this.TempBuildingIconPath.ProcessingFactory
    elseif buildingType == BuildingType.RetailShop then
        path = this.TempBuildingIconPath.RetailShop
    elseif buildingType == BuildingType.Laboratory then
        path = this.TempBuildingIconPath.Laboratory
    end
    return path
end
--
function MapBubbleManager.createSummaryItems(data, summaryType)
    if summaryType == EMapSearchType.Material or summaryType == EMapSearchType.Goods then

    elseif summaryType == EMapSearchType.Deal then

    end

    this.cleanSummaryItems()
    for i, value in pairs(data.info) do
        if value.num > 0 then
            this._createSummaryItems(value)
        end
    end
end
--点击缩略item，进入详情
function MapBubbleManager.summaryToDetail(pos)

end
--搜索详情  --是否是全新的搜索数据
function MapBubbleManager.createDetailItems(data, isNew)
    if isNew then
        this.cleanAllCollectionDetails()
    else
        this.cleanAOIWillRemoveDatas()
    end

    if this.collectionDetails == nil then
        this.collectionDetails = {}
    end
    if data ~= nil then
        for i, value in pairs(data.info) do
            local collectionId = TerrainManager.AOIGridIndexTurnCollectionID(value.idx)
            if value.b ~= nil then
                for i, building in pairs(value.b) do
                    if building.sale ~= nil then
                        local detailData = {buildingId = building.id, sale = building.sale, pos = building.pos}
                        this.collectionDetails[collectionId] = {}
                        this.collectionDetails[collectionId].detailItems = {}
                        this.collectionDetails[collectionId].detailItems[building.id] = {}
                        this.collectionDetails[collectionId].detailItems[building.id] = this._createDetailItems(detailData)
                    end
                end
            end
        end
    end
end
--清除所有搜索数据
function MapBubbleManager.cleanAllCollectionDetails()
    if this.collectionDetails ~= nil then
        for i, value in pairs(this.collectionDetails) do
            if value.detailItems ~= nil then
                for i, item in pairs(value.detailItems) do
                    item:close()
                    item = nil
                end
                value.detailItems = nil
            end
            value = nil
        end
    end
    this.collectionDetails = {}
end
--清除多余的地块
function MapBubbleManager.cleanAOIWillRemoveDatas()
    if this.oldCollectionID ~= nil then
        local list = TerrainManager.GetAOIWillRemoveCollectionIDs(this.oldCollectionID)
        if list ~= nil then
            for i, value in pairs(list) do
                local tempValue = this.collectionDetails[value]
                if tempValue ~= nil then
                    if tempValue.detailItems ~= nil then
                        for i, item in pairs(tempValue.detailItems) do
                            item:close()
                            item = nil
                        end
                        tempValue.detailItems = nil
                    end
                    tempValue = nil
                end
            end
        end
    end
end

--镜头低时显示建筑详细大小
function MapBubbleManager.toggleShowDetailBuilding(show)
    if show == nil then
        return
    end
    if this.centerItem ~= nil then
        this.centerItem:toggleShowDetailImg(show)
    end
    if this.selfBuildings ~= nil then
        for i, value in pairs(this.selfBuildings) do
            value:toggleShowDetailImg(show)
        end
    end
end

--显示缩略或者详情
function MapBubbleManager.showSummaryOrDetail(showDetail)
    if showDetail == true then
        --清除缩略
        this.cleanSummaryItems()
    else
        --清除详情item
        this.cleanAllCollectionDetails()
    end
end
--
function MapBubbleManager.cleanSummaryItems()
    if this.summaryItems ~= nil then
        for i, value in pairs(this.summaryItems) do
            value:close()
            value = nil
        end
    end
    this.summaryItems = {}
end

--回收
function MapBubbleManager.recyclingObjToPool(poolName, go)
    if prefabPools[poolName] ~= nil and go ~= nil then
        prefabPools[poolName]:RecyclingGameObjectToPool(go.gameObject)
    end
end
--清除item
function MapBubbleManager.cleanBuildingItems()
    if this.selfBuildings ~= nil then
        for i, value in pairs(this.selfBuildings) do
            value:close()
            value = nil
        end
    end
end
--小地图移动
function MapBubbleManager.MapMoveFunc()
    if this.mapCtrl ~= nil then
        this.mapCtrl:_mapAOIMove()
    end
end
--关闭界面时的操作
function MapBubbleManager.cleanAllBubbleItems()
    this.cleanBuildingItems()
    this.cleanSummaryItems()
    this.cleanAllCollectionDetails()
    this.centerItem:resetState()
end