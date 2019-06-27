---
---
---
AddLineMgrNew = class('AddLineMgrNew')

AddLineMgrNew.static.togglePrefab = "View/items/AddLineChooseItems/AddLineToggleItem"  --左侧需要加载的预制
AddLineMgrNew.static.detailPrefab = "View/items/AddLineChooseItems/AddLineDetailItem"  --右侧滑动需要加载的预制

--位于哪边，左右两边具有不同意义
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
            local tempData = {languageId = typeItem[1].name, typeId = i, createDetail = function (typeId)  --创建方法
                self:_createDetail(typeId)
            end,
            selectFunc = function (item)  --选中
                self:_selectTypeItem(item)
            end}
            local item = AddLineTypeItemNew:new(go.transform, tempData, self.typeToggleGroup)
            self.toggleItems[#self.toggleItems + 1] = item
            self.keyToggleItems[i] = item  --创建以typeId为key的表
        end
    end
    --UpdateBeat:Add(self._update, self)
    FixedUpdateBeat:Add(self._update, self)
end
--
function AddLineMgrNew:_cleanAll()
    self.selectTypeItem = nil
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
--初始化
function AddLineMgrNew:initData(chooseTypeId)
    self:_language()
    self.detailContent.anchoredPosition = Vector2.zero

    --设置默认打开的类别
    for i, item in pairs(self.toggleItems) do
        self.toggleItems[i]:setToggleIsOn(false)
    end

    --根据特定值去设置toggle  --暂时没找到用的地方
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

    self.toggleItems[1]:setToggleIsOn(true)
    self.selectTypeItem = self.toggleItems[1]
    self.tempTypeId = self.toggleItems[1]:getTypeId()
end
--获取当前选择的typeId
function AddLineMgrNew:getCurrentTypeId()
    return self.tempTypeId
end

--根据typeId 和 itemId 获取对应的item，并显示选中状态
function AddLineMgrNew:setToggleIsOnByType(itemId)
    local typeId = tonumber(string.sub(itemId, 1, 4))
    if self.tempDetailItemId ~= nil and itemId == self.tempDetailItemId then
        return
    end
    self.tempDetailItemId = itemId

    if self.keyToggleItems[typeId] then
        for i, toggleItem in pairs(self.keyToggleItems) do
            toggleItem.setToggleIsOn(toggleItem, false)
        end
        self.keyToggleItems[typeId].setToggleIsOn(self.keyToggleItems[typeId], true)
    end

    if self.keyContentItems[itemId] then
        for i, detailItem in pairs(self.keyContentItems) do
            detailItem.setToggleIsOn(detailItem, false)
        end
        self.keyContentItems[itemId].setToggleIsOn(self.keyContentItems[itemId], true)
    end
end
---------
function AddLineMgrNew:_selectTypeItem(selectTypeItem)
    --清空之前的item状态
    if self.selectTypeItem ~= nil then
        self.selectTypeItem:setToggleIsOn(false)
    end
    self.selectTypeItem = selectTypeItem
    selectTypeItem:setToggleIsOn(true)  --显示现在的item

    local typeId = selectTypeItem:getTypeId()
    self:_createDetail(typeId)

    for i, item in ipairs(self.contentItems) do
        self.contentItems[i]:setToggleIsOn(false)
    end
    self.contentItems[1]:setToggleIsOn(true)
    self.tempDetailItemId = self.contentItems[1]:getItemId()
end
--
function AddLineMgrNew:_createDetail(typeId)
    self:_resetDetails()
    self.contentItems = {}

    --暂时是直接使用content下的子物体，多了的就移出content
    local data = CompoundTypeConfig[typeId]
    local count = #self.detailPrefabList - #data
    if count > 0 then
        for i = 1, count do
            self:_releaseObj(self.detailPrefabList[i - 1])
        end
    end  --将多余的预制回收隐藏

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

        local tempData = {itemId = itemData.itemId,itemType = itemData.itemType, backFunc = function (itemId, rectPosition, enableShow)
            self:_setLineShow(itemId, rectPosition, enableShow)
        end}
        local item = AddLineDetailItemNew:new(go.transform, tempData, self.detailToggleGroup)
        self.contentItems[#self.contentItems + 1] = item
        self.keyContentItems[itemData.itemId] = item  --创建以itemId为key的详情表
    end
end

--选择了某个item，显示线路
function AddLineMgrNew:_setLineShow(itemId, rectPosition, enableShow)
    self.tempDetailItemId = itemId

    if self.sideValue == AddLineSideValue.Left then
        Event.Brocast("leftSetCenter", itemId, rectPosition, enableShow)
    elseif self.sideValue == AddLineSideValue.Right then
        Event.Brocast("rightSetCenter", itemId, rectPosition, enableShow)
    end
end
--回收预制
function AddLineMgrNew:_releaseObj(obj)
    obj.transform:SetParent(self.detailToggleGroup.transform)
    obj.transform.localScale = Vector3.zero
    obj.transform.localPosition = Vector3.zero
end
--清空选中状态
function AddLineMgrNew:_resetDetails()
    if self.contentItems then
        for i, item in ipairs(self.contentItems) do
            item:cleanState()
        end
        self.tempDetailItemId = nil
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
--------------------------------------------------------------------------------------------------------------------------------
local m_MatGoodIconSpriteList = {}

--添加BuildingIcon的sprite列表
local function AddBuildingIcon(name,sprite)
    if m_MatGoodIconSpriteList == nil or type(m_MatGoodIconSpriteList) ~= 'table' then
        m_MatGoodIconSpriteList = {}
    end
    if name ~= nil and sprite ~= nil then
        m_MatGoodIconSpriteList[name] = sprite
    end
end
--
local function JudgeHasBuildingIcon(name)
    if m_MatGoodIconSpriteList == nil or m_MatGoodIconSpriteList[name] == nil  then
        return false
    else
        return true
    end
end
--
local function GetBuildingIcon(name)
    if m_MatGoodIconSpriteList == nil or m_MatGoodIconSpriteList[name] == nil  then
        return nil
    else
        return m_MatGoodIconSpriteList[name]
    end
end
--
local SpriteType = nil
local function LoadBuildingIcon(name,iIcon)
    if SpriteType == nil then
        SpriteType = ct.getType(UnityEngine.Sprite)
    end
    panelMgr:LoadPrefab_A(name, SpriteType, iIcon, function(Icon, obj )
        if Icon == nil then
            return
        end
        if obj ~= nil  then
            local texture = ct.InstantiatePrefab(obj)
            AddBuildingIcon(name,texture)
            if Icon then
                Icon.sprite = texture
                --Icon:SetNativeSize()
            end
        end
    end)
end

--设置ICon的Sprite
function AddLineMgrNew.SetBuildingIconSpite(name , tempImage)
    if JudgeHasBuildingIcon() == true then
        tempImage.sprite = GetBuildingIcon(name)
        --tempImage:SetNativeSize()
    else
        LoadBuildingIcon(name , tempImage)
    end
end