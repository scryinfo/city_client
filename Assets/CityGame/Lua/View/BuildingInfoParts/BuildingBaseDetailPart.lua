---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 17:34
---
BuildingBaseDetailPart = class('BuildingBaseDetailPart',BasePartDetail)

--生成itemPrefab(生成多个)
function BuildingBaseDetailPart:CreateGoodsItems(dataInfo,itemPrefab,itemRoot,className,behaviour,instanceTable)
    if not dataInfo then
        return
    end
    for key,value in pairs(dataInfo) do
        local obj = BuildingBaseDetailPart.loadingItemPrefab(itemPrefab,itemRoot)
        local itemGoodsIns = className:new(value,obj,behaviour,key)
        table.insert(instanceTable,itemGoodsIns)
    end
end
--生成itemPrefab(生成一个)
function BuildingBaseDetailPart:CreateGoodsItem(dataInfo,itemPrefab,itemRoot,className,behaviour,instanceTable)
    if not dataInfo then
        return
    end
    local obj = BuildingBaseDetailPart.loadingItemPrefab(itemPrefab,itemRoot)
    local itemGoodsIns = className:new(dataInfo,obj,behaviour,#instanceTable + 1)
    table.insert(instanceTable,itemGoodsIns)
end
--生成itemPrefab(点击一次生成一次)
function BuildingBaseDetailPart:CreateGoodsDetails(dataInfo,itemPrefab,itemRoot,className,behaviour,id,instanceTable)
    if not dataInfo then
        return
    end
    local obj = BuildingBaseDetailPart.loadingItemPrefab(itemPrefab,itemRoot)
    local itemGoodsIns = className:new(dataInfo,obj,behaviour,id)
    instanceTable[id] = itemGoodsIns
end
----获取仓库已用总容量
--function BuildingBaseDetailPart:GatWarehouseCapacity(dataTable)
--    --仓库占用容量
--    local warehouseCapacity = 0
--    --仓库里锁着的容量
--    local lockedCapacity = BuildingBaseDetailPart.GetLockedNum(dataTable)
--    if not dataTable.inHand then
--        warehouseCapacity = warehouseCapacity + lockedCapacity
--        return warehouseCapacity
--    else
--        for key,value in pairs(dataTable.inHand) do
--            warehouseCapacity = warehouseCapacity + value.n
--        end
--        warehouseCapacity = warehouseCapacity + lockedCapacity
--        return warehouseCapacity
--    end
--end
----获取仓库数量
--function BuildingBaseDetailPart:GetWarehouseNum(dataTable)
--    local warehouseNum = 0
--    if not dataTable.inHand then
--        return warehouseNum
--    else
--        for key,value in pairs(dataTable.inHand) do
--            warehouseNum = warehouseNum + value.n
--        end
--        return warehouseNum
--    end
--end
----改变商品的状态
--function BuildingBaseDetailPart:GoodsItemState(dataTable,itemStateBool)
--    if next(dataTable) == nil then
--        return
--    end
--    if itemStateBool == true then
--        for key,valueIns in pairs(dataTable) do
--            valueIns:c_GoodsItemChoose()
--        end
--    else
--        for key,valueIns in pairs(dataTable) do
--            valueIns:InitializeUi()
--        end
--    end
--end
----点击已经被选中商品
--function BuildingBaseDetailPart:DestoryGoodsDetailsList(instanceList,idList,id)
--    destroy(instanceList[id].prefab.gameObject)
--    instanceList[id] = nil
--    idList[id] = nil
--end
----关闭右侧上架Panel或运输Panel或购买Panel
--function BuildingBaseDetailPart:CloseGoodsDetails(instanceList,idList)
--    if next(instanceList) == nil and next(idList) == nil then
--        return
--    end
--    for key,valueObj in pairs(instanceList) do
--        self:DestoryGoodsDetailsList(instanceList,idList,key)
--    end
--end
--关闭时清空界面及数据
function BuildingBaseDetailPart:CloseDestroy(dataTable)
    if next(dataTable) == nil then
        return
    else
        for key,valueObj in pairs(dataTable) do
            destroy(valueObj.prefab.gameObject)
            dataTable[key] = nil
        end
    end
end
----删除某个商品
--function BuildingBaseDetailPart:deleteGoodsItem(dataTable,id)
--    if next(dataTable) == nil then
--        return
--    else
--        destroy(dataTable[id].prefab.gameObject)
--        table.remove(dataTable,id)
--    end
--    local id = 1
--    for key,value in pairs(dataTable) do
--        dataTable[id]:RefreshID(id)
--        id = id + 1
--    end
--end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--加载实例化Prefab
function BuildingBaseDetailPart.loadingItemPrefab(itemPrefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(itemPrefab)
    local objRect = obj.transform:GetComponent("RectTransform");
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one;
    --obj.transform:SetSiblingIndex(1)
    obj:SetActive(true)
    return obj
end
----获取仓库锁着的容量
--function BuildingBaseDetailPart.GetLockedNum(DataTable)
--    local lockedNum = 0
--    if not DataTable.inHand then
--        return lockedNum
--    end
--    if not DataTable.locked then
--        return lockedNum
--    end
--    for key,value in pairs(DataTable.locked) do
--        lockedNum = lockedNum + value.n
--    end
--    return lockedNum
--end
----架子隐藏和显示
--function BuildingBaseDetailPart.ShelfImgSetActive(table,num1,num2)
--    if next(table) == nil then
--        return
--    end
--    for key,valueObj in pairs(table) do
--        if key % num1 == num2 then
--            valueObj.shelfImg:SetActive(true)
--        else
--            valueObj.shelfImg:SetActive(false)
--        end
--    end
--end
----获取临时表购买或运输的数量
--function BuildingBaseDetailPart.GetDataTableNum(dataTable)
--    local number = 0
--    for key,value in pairs(dataTable) do
--        number = number + value.numberScrollbar.value
--    end
--    return number
--end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




