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
local MapGroundAucItemName = "MapGroundAucItem"
local MapGroundTransItemName = "MapGroundTransItem"

local TempCenterOffset = Vector3.New(10, 0, 10)

MapBubbleManager.TempBuildingIconPath =
{
    House = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    MaterialFactory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-Material.png",
    Municipal = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    MunicipalManage = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    ProcessingFactory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-Fatory.png",
    Laboratory = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
    RetailShop = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-SuperMarket.png",
    TalentCenter = "Assets/CityGame/Resources/Atlas/Map/buildingIcons/icon-HomeHouse.png",
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
    prefabPools[MapGroundAucItemName] = LuaGameObjectPool:new(MapGroundAucItemName, MapPanel.mapGroundAucItem, 5, Vector3.New(-999,-999,-999))
    prefabPools[MapGroundTransItemName] = LuaGameObjectPool:new(MapGroundTransItemName, MapPanel.mapGroundTransItem, 5, Vector3.New(-999,-999,-999))
end
--
function MapBubbleManager.getMapCtrlIns()
    return this.mapCtrl
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
        local pos = TerrainManager.BlockIDTurnPosition(blockId) + TempCenterOffset
        --Event.Brocast("CameraMoveTo", pos)
        CameraMove.MoveCameraToPos(pos)
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
            local obj = prefabPools[MapBuildingItemName]:GetAvailableGameObject()
            obj.transform:SetParent(MapPanel.alwaysShowRoot.transform)
            obj.transform.localPosition = Vector3.zero
            local item = MapBuildingItem:new({buildingId = value.info.id, tempPath = this._getBuildingIconPath(buildingType), poolName = MapBuildingItemName}, obj.transform)
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
    obj.transform:SetParent(MapPanel.allSearchRoot.transform)
    obj.transform.localPosition = Vector3.zero

    local collectionId
    if data.idx ~= nil then
        collectionId = TerrainManager.AOIGridIndexTurnCollectionID(data.idx)
    else
        collectionId = data.collectionId
    end
    local blockId = TerrainManager.CollectionIDTurnBlockID(collectionId)

    local tempPos = TerrainManager.BlockIDTurnPosition(blockId)
    local item = MapAllSearchItem:new({num = data.num, pos = tempPos, poolName = MapAllSearchItemName}, obj.transform)

    this.summaryItems[collectionId] = item
    local pos = Vector2.New(tempPos.z + 10 ,-tempPos.x - 10) * this.itemWidth
    item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, 0)
end
--生成详情Item
function MapBubbleManager._createDetailItems(data)
    local obj = prefabPools[MapSearchResultItemName]:GetAvailableGameObject()
    obj.transform:SetParent(MapPanel.detailSearchRoot.transform)
    obj.transform.localPosition = Vector3.zero
    local item = MapSearchResultItem:new({detailData = data, itemWidth = this.itemWidth, poolName = MapSearchResultItemName}, obj.transform)
    return item
end
--生成土地拍卖
function MapBubbleManager._createGAucItems(data)
    local obj = prefabPools[MapGroundAucItemName]:GetAvailableGameObject()
    obj.transform:SetParent(MapPanel.groundAuctionRoot.transform)
    obj.transform.localPosition = Vector3.zero
    local item = MapGroundAucItem:new({detailData = data, itemWidth = this.itemWidth, poolName = MapGroundAucItemName}, obj.transform)
    return item
end
--生成土地交易
function MapBubbleManager._createGTransItems(data)
    local obj = prefabPools[MapGroundTransItemName]:GetAvailableGameObject()
    obj.transform:SetParent(MapPanel.groundTransformRoot.transform)
    obj.transform.localPosition = Vector3.zero
    local item = MapGroundTransItem:new({detailData = data, itemWidth = this.itemWidth, poolName = MapGroundTransItemName}, obj.transform)
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
    if summaryType == EMapSearchType.Auction then  --土地拍卖是客户端维护的，所以做特殊处理
        if data == nil then
            local tempDatas = UIBubbleManager.getCollectionAucData()
            data = {}
            for i, value in pairs(tempDatas) do
                data[#data + 1] = {num = value, collectionId = i}
            end

            this.cleanSummaryItems()
            for i, value in pairs(data) do
                this._createSummaryItems(value)
            end
        end
        return
    end

    this.cleanSummaryItems()
    if summaryType == EMapSearchType.Deal then
        for i, value in pairs(data.info) do
            local num = value.sellingN + value.rentingN
            if num > 0 then
                local temp = {num = num, idx = value.idx}
                this._createSummaryItems(temp)
            end
        end
    elseif summaryType == EMapSearchType.Technology or summaryType == EMapSearchType.Signing or summaryType == EMapSearchType.Warehouse then
        for i, value in pairs(data.info) do
            if value.count > 0 then
                local temp = {num = value.count, idx = value.idx}
                this._createSummaryItems(temp)
            end
        end
    elseif summaryType == EMapSearchType.Material or summaryType == EMapSearchType.Goods then
        for i, value in pairs(data.info) do
            if value.num > 0 then
                local temp = {num = value.num, idx = value.idx, itemId = value.itemId}
                this._createSummaryItems(temp)
            end
        end
    end

end
--搜索详情  --是否是全新的搜索数据
function MapBubbleManager.createDetailItems(data, typeId, isNew)
    if isNew then
        this.cleanAllCollectionDetails()
    else
        this.cleanAOIWillRemoveDatas()
    end

    if this.collectionDetails == nil then
        this.collectionDetails = {}
    end
    this._createDetailByType(typeId, data)
end
--因为数据结构不同，所以处理数据的方式也不同
function MapBubbleManager._createDetailByType(typeId, data)
    if typeId == EMapSearchType.Material or typeId == EMapSearchType.Goods then
        for i, value in pairs(data.info) do
            if value.b ~= nil and value.b.sale ~= nil then
                local collectionId = TerrainManager.AOIGridIndexTurnCollectionID(value.idx)
                for i, building in pairs(value.b) do
                    this._checkDetailTable(collectionId)
                    local blockId = TerrainManager.GridIndexTurnBlockID(building.pos)
                    this.collectionDetails[collectionId].detailItems[blockId] = this._createDetailItems(building)
                end
            end
        end
    elseif typeId == EMapSearchType.Technology and data.info ~= nil then
        for i, value in pairs(data.info) do
            local collectionId = TerrainManager.AOIGridIndexTurnCollectionID(value.idx)
            if value.b ~= nil then
                for i, building in pairs(value.b) do
                    this._checkDetailTable(collectionId)
                    local blockId = TerrainManager.GridIndexTurnBlockID(building.pos)
                    this.collectionDetails[collectionId].detailItems[blockId] = this._createDetailItems(building)
                end
            end
        end
    elseif typeId == EMapSearchType.Signing and data.gridInfo ~= nil then
        for i, value in pairs(data.gridInfo) do
            if value.info ~= nil then
                local collectionId = TerrainManager.AOIGridIndexTurnCollectionID(value.idx)
                for i, temp in pairs(value.info) do
                    this._checkDetailTable(collectionId)
                    local blockId = TerrainManager.GridIndexTurnBlockID(temp.pos)
                    this.collectionDetails[collectionId].detailItems[blockId] = this._createDetailItems(temp)
                end
            end
        end
    elseif typeId == EMapSearchType.Warehouse and data.info ~= nil then
        for i, value in pairs(data.info) do
            local collectionId = TerrainManager.AOIGridIndexTurnCollectionID(value.idx)
            if value.b ~= nil then
                for i, building in pairs(value.b) do
                    this._checkDetailTable(collectionId)
                    local blockId = TerrainManager.GridIndexTurnBlockID(building.pos)
                    this.collectionDetails[collectionId].detailItems[blockId] = this._createDetailItems(building)
                end
            end
        end
    end
end
--判断table是否为空
function MapBubbleManager._checkDetailTable(collectionId)
    if this.collectionDetails[collectionId] == nil then
        this.collectionDetails[collectionId] = {}
    end
    if this.collectionDetails[collectionId].detailItems == nil then
        this.collectionDetails[collectionId].detailItems = {}
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
--生成土地交易
function MapBubbleManager.createGroundTransDetailItems()
    --获取到需要生成的交易信息
    this.cleanAllGTransData()

    local tempDatas = UIBubbleManager.getTransItemsTable()
    if tempDatas ~= nil then
        for id, value in pairs(tempDatas) do
            if value ~= nil then
                local data = value:getValuableData()
                local blockId = data.blockId
                local collectionId = TerrainManager.BlockIDTurnCollectionID(blockId)
                if this.gTransData[collectionId] == nil then
                    this.gTransData[collectionId] = {}
                end
                if this.gTransData[collectionId].detailItems == nil then
                    this.gTransData[collectionId].detailItems = {}
                end
                local item = this._createGTransItems(data)

                local serverPos = TerrainManager.BlockIDTurnPosition(blockId)
                local pos = Vector2.New(serverPos.z, -serverPos.x) * this.itemWidth
                local delta = this.itemDelta *  1  --一个地块的大小
                item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, delta)
                this.gTransData[collectionId].detailItems[blockId] = item
            end
        end
    end
end
--生成土地拍卖
function MapBubbleManager.createGAucDetailItems()
    this.cleanAllGroundAucData()

    local tempDatas = UIBubbleManager.getAucItemsTable()
    if tempDatas ~= nil then
        for id, value in pairs(tempDatas) do
            if value ~= nil then
                local data = value:getValuableData()
                --local blockId = GroundAucConfig[data.id].firstBlockId
                local info = GroundAucConfig[data.id].area[2]
                local blockId = TerrainManager.GridIndexTurnBlockID(info)
                local collectionId = TerrainManager.BlockIDTurnCollectionID(blockId)
                if this.groundAucData[collectionId] == nil then
                    this.groundAucData[collectionId] = {}
                end
                if this.groundAucData[collectionId].detailItems == nil then
                    this.groundAucData[collectionId].detailItems = {}
                end
                local item = this._createGAucItems(data)

                local pos = Vector2.New(info.y, -info.x) * this.itemWidth
                local delta = this.itemDelta *  5  --一个地块的大小
                item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, delta)
                this.groundAucData[collectionId].detailItems[blockId] = item
            end
        end
    end
end
--清除所有土地拍卖信息
function MapBubbleManager.cleanAllGroundAucData()
    if this.groundAucData ~= nil then
        for i, value in pairs(this.groundAucData) do
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
    this.groundAucData = {}
end
--清除所有土地交易
function MapBubbleManager.cleanAllGTransData()
    if this.gTransData ~= nil then
        for i, value in pairs(this.gTransData) do
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
    this.gTransData = {}
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
        this.cleanAllGroundAucData()
        this.cleanAllGTransData()
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
    this.cleanSummaryItems()
    this.cleanAllCollectionDetails()
    this.cleanAllGroundAucData()
    this.cleanAllGTransData()
end
--
function MapBubbleManager.closePanelFunc()
    this.centerItem:resetState()
    this.cleanAllBubbleItems()
    this.cleanBuildingItems()
end
---传data.buildingBase
function MapBubbleManager.GoHereFunc(data)
    UIPanel.CloseAllPageExceptMain()
    local pos = Vector3.New(data.pos.x,0,data.pos.y)
    CameraMove.MoveCameraToPos(pos)
end
--土地交易查询变化  --AOI
function MapBubbleManager.groundTransChange(blockId, data)
    if this.mapCtrl ~= nil and this.mapCtrl:getNonePageSearchType() == EMapSearchType.Deal and this.mapCtrl:_getIsDetailFunc() == true then

        local collectionId = TerrainManager.BlockIDTurnCollectionID(blockId)
        if data == nil then  --清除item
            local item = this.gTransData[collectionId].detailItems[blockId]
            item:close()
            item = nil
            this.gTransData[collectionId].detailItems[blockId] = nil
            return
        end
        if this.gTransData[collectionId] == nil then
            this.gTransData[collectionId] = {}
        end
        if this.gTransData[collectionId].detailItems == nil then
            this.gTransData[collectionId].detailItems = {}
        end
        local item = this._createGTransItems(data)  --创建新的item

        local serverPos = TerrainManager.BlockIDTurnPosition(blockId)
        local pos = Vector2.New(serverPos.z, -serverPos.x) * this.itemWidth
        local delta = this.itemDelta *  1  --一个地块的大小
        item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, delta)
        this.gTransData[collectionId].detailItems[blockId] = item
    end
end
--土地拍卖查询变化  --客户端直接管理
function MapBubbleManager.groundAucChange(groundId)
    if this.mapCtrl ~= nil and this.mapCtrl:getNonePageSearchType() == EMapSearchType.Auction and this.mapCtrl:_getIsDetailFunc() == true then
        if this.groundAucData == nil then
            return
        end
        local info = GroundAucConfig[groundId].area[2]
        local blockId = TerrainManager.GridIndexTurnBlockID(info)
        local collectionId = TerrainManager.BlockIDTurnCollectionID(blockId)
        if this.groundAucData[collectionId] == nil then
            this.groundAucData[collectionId] = {}
        end
        if this.groundAucData[collectionId].detailItems == nil then
            this.groundAucData[collectionId].detailItems = {}
        end
        local item = this._createGAucItems({id = groundId, isStartAuc = false})

        local pos = Vector2.New(info.y, -info.x) * this.itemWidth
        local delta = this.itemDelta *  5  --一个地块的大小
        item:setScaleAndPos(MapCtrl.getCurrentScaleValue(), pos, delta)
        this.groundAucData[collectionId].detailItems[blockId] = item
    end
end