---
---
---
AddLineMgrNew = class('AddLineMgrNew')

AddLineMgrNew.static.togglePrefab = "View/items/AddLineChooseItems/AddLineToggleItem"  --Prefabs to be loaded on the left
AddLineMgrNew.static.detailPrefab = "View/items/AddLineChooseItems/AddLineDetailItem"  --Prefabricated on the right side to be loaded

--Which side is located, the left and right sides have different meanings
AddLineSideValue =
{
    Left = 0,
    Right = 1,
}
function AddLineMgrNew:initialize(viewRect, sideValue)
    self.viewRect = viewRect
    self.sideValue = sideValue

    self.typeToggleGroup = viewRect:Find("typeRoot"):GetComponent("ToggleGroup")
    self.typeContent = viewRect:Find("typeRoot/typeScroll/content")
    self.detailToggleGroup = viewRect:Find("detailRoot"):GetComponent("ToggleGroup")
    self.detailContent = viewRect:Find("detailRoot/detailScroll/content"):GetComponent("RectTransform")

    self.togglePrefab = UnityEngine.Resources.Load(AddLineMgrNew.static.togglePrefab)
    self.detailPrefab = UnityEngine.Resources.Load(AddLineMgrNew.static.detailPrefab)

    self.detailPrefabList = {}
    self.toggleItems = {}
    self.keyToggleItems = {}
    self.keyContentItems = {}

    for i, typeItem in pairs(CompoundTypeConfig) do
        if (sideValue == AddLineSideValue.Left) and i < 2200 or (sideValue == AddLineSideValue.Right and i > 2200) then
            local go = UnityEngine.GameObject.Instantiate(self.togglePrefab)
            go.transform:SetParent(self.typeContent.transform)
            go.transform.localScale = Vector3.one
            local tempData = {languageId = typeItem[1].name, typeId = i, createDetail = function (typeId)  --How to create
                self:_createDetail(typeId)
            end,
            selectFunc = function (item)  --Selected
                self:_selectTypeItem(item)
            end}
            local item = AddLineTypeItemNew:new(go.transform, tempData, self.typeToggleGroup)
            self.toggleItems[#self.toggleItems + 1] = item
            self.keyToggleItems[i] = item  --Create a table with typeId as the key
        end
    end
    --UpdateBeat:Add(self._update, self)
    FixedUpdateBeat:Add(self._update, self)
end
--
function AddLineMgrNew:_cleanAll()
    self.selectTypeItem = nil
    self.selectDetailItem = nil
    FixedUpdateBeat:Remove(self._update, self)
end
--
function AddLineMgrNew:_language()
    if self.keyContentItems ~= nil then
        for i, item in pairs(self.keyContentItems) do
            item:_language()
        end
    end
    if self.toggleItems ~= nil then
        for i, item in pairs(self.toggleItems) do
            item:_language()
        end
    end
end
--initialization
function AddLineMgrNew:initData(chooseTypeId)
    self.detailContent.anchoredPosition = Vector2.zero
    FixedUpdateBeat:Add(self._update, self)
    self:_language()

    --Set the default open category
    for i, item in pairs(self.toggleItems) do
        self.toggleItems[i]:setToggleIsOn(false)
    end

    --According to toggle to set a specific value  -- could not find a place to temporarily use
    if chooseTypeId ~= nil then
        for i, item in pairs(self.toggleItems) do
            if self.toggleItems[i]:getTypeId() == chooseTypeId then
                self.selectTypeItem = self.toggleItems[i]
                self.toggleItems[i]:setToggleIsOn(true)
                self.tempTypeId = self.toggleItems[i]:getTypeId()
                return
            end
        end
    end

    self.toggleItems[1]:_selectType()
    self.selectTypeItem = self.toggleItems[1]
    self.tempTypeId = self.toggleItems[1]:getTypeId()
end
--Get the currently selected typeId
function AddLineMgrNew:getCurrentTypeId()
    return self.tempTypeId
end

--Get the corresponding item according to typeId and itemId and display the selected state
function AddLineMgrNew:setToggleIsOnByType(itemId)
    local typeId = tonumber(string.sub(itemId, 1, 4))
    if self.tempDetailItemId ~= nil and itemId == self.tempDetailItemId then
        return
    end
    self.tempDetailItemId = itemId

    --if self.keyToggleItems[typeId] then
    --    for i, toggleItem in pairs(self.keyToggleItems) do
    --        toggleItem.setToggleIsOn(toggleItem, false)
    --    end
    --    self.keyToggleItems[typeId].setToggleIsOn(self.keyToggleItems[typeId], true)
    --end
    --
    --if self.keyContentItems[itemId] then
    --    for i, detailItem in pairs(self.keyContentItems) do
    --        detailItem.setToggleIsOn(detailItem, false)
    --    end
    --    self.keyContentItems[itemId].setToggleIsOn(self.keyContentItems[itemId], true)
    --end
    if self.keyToggleItems[typeId] then
        for i, toggleItem in pairs(self.keyToggleItems) do
            toggleItem.setToggleIsOn(toggleItem, false)
        end
        self.keyToggleItems[typeId]:_selectType(self.keyToggleItems[typeId], true)
    end

    if self.keyContentItems[itemId] then
        for i, detailItem in pairs(self.keyContentItems) do
            detailItem.setToggleIsOn(detailItem, false)
        end
        self.keyContentItems[itemId]._selectDetail(self.keyContentItems[itemId], true)
    end
end
---------
function AddLineMgrNew:_selectTypeItem(selectTypeItem)
    --Clear the previous item status
    if self.selectTypeItem ~= nil then
        self.selectTypeItem:setToggleIsOn(false)
    end
    self.selectTypeItem = selectTypeItem
    selectTypeItem:setToggleIsOn(true)  --Show current item

    local typeId = selectTypeItem:getTypeId()
    self:_createDetail(typeId)
    ct.log("system","-------------------选中了type："..typeId)

    for i, item in ipairs(self.contentItems) do
        self.contentItems[i]:setToggleIsOn(false)
    end
    self.contentItems[1]:_selectDetail()
    self.tempDetailItemId = self.contentItems[1]:getItemId()
end
--
function AddLineMgrNew:_createDetail(typeId)
    self:_resetDetails()
    self.contentItems = {}
    self.keyContentItems = {}

    --For the time being, directly use the sub-objects under the content, and move out the content if there are more
    local data = CompoundTypeConfig[typeId]
    local count = #self.detailPrefabList - #data
    if count > 0 then
        for i = 1, count do
            self:_releaseObj(self.detailPrefabList[i - 1])
        end
    end  --Hide excess prefabricated recycling

    for i, itemData in ipairs(data) do
        local go
        if self.detailPrefabList[i] then
            go = self.detailPrefabList[i]
        else
            go = UnityEngine.GameObject.Instantiate(self.detailPrefab)
            self.detailPrefabList[#self.detailPrefabList + 1] = go
        end
        go.transform:SetParent(self.detailContent.transform)
        go.transform.localScale = Vector3.one

        local tempData = {itemId = itemData.itemId,itemType = itemData.itemType, backFunc = function (detailItem)
            self:_setLineShow(detailItem)
        end}
        local item = AddLineDetailItemNew:new(go.transform, tempData, self.detailToggleGroup)
        self.contentItems[#self.contentItems + 1] = item
        self.keyContentItems[itemData.itemId] = item  --Create detail table with itemId as key
    end
end

--An item is selected and the line is displayed
function AddLineMgrNew:_setLineShow(selectDetailItem)
    if self.selectDetailItem ~= nil then
        self.selectDetailItem:setToggleIsOn(false)
    end
    self.selectDetailItem = selectDetailItem
    selectDetailItem:setToggleIsOn(true)  --Show selected
    local itemId = selectDetailItem:getItemId()
    local rectPosition = selectDetailItem:getItemPos()
    local enableShow = selectDetailItem:getEnableShow()
    self.tempDetailItemId = itemId

    ct.log("system","-------------------选中了detail："..itemId)


    if self.sideValue == AddLineSideValue.Left then
        Event.Brocast("leftSetCenter", itemId, rectPosition, enableShow)
    elseif self.sideValue == AddLineSideValue.Right then
        Event.Brocast("rightSetCenter", itemId, rectPosition, enableShow)
    end
end
--Recycling prefabrication
function AddLineMgrNew:_releaseObj(obj)
    obj.transform:SetParent(self.detailToggleGroup.transform)
    obj.transform.localScale = Vector3.zero
    obj.transform.localPosition = Vector3.zero
end
--Clear the selected state
function AddLineMgrNew:_resetDetails()
    if self.contentItems then
        for i, item in ipairs(self.contentItems) do
            item:cleanState()
            item = nil
        end
        self.tempDetailItemId = nil
    end
    if self.keyContentItems then
        for i, item in pairs(self.keyContentItems) do
            item:cleanState()
            item = nil
        end
    end
end
--
function AddLineMgrNew:_update()
    if self.sideValue == AddLineSideValue.Left then
        if self.keyContentItems[self.tempDetailItemId] ~= nil then
            local pos = self.keyContentItems[self.tempDetailItemId]:getItemPos()
            NewAddProductionLinePanel.leftBtnParent.transform.position = pos
        end
        return
    end

    if self.sideValue == AddLineSideValue.Right then
        if self.keyContentItems[self.tempDetailItemId] ~= nil then
            local pos = self.keyContentItems[self.tempDetailItemId]:getItemPos()
            NewAddProductionLinePanel.rightBtnParent.transform.position = pos
        end
        return
    end
end