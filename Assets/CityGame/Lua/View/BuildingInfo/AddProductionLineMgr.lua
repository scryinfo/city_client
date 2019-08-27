AddProductionLineMgr = class('AddProductionLineMgr')
--AddProductionLineMgr.static.ChooseColor = Vector3.New(78, 111, 189)  --选中时显示的颜色
--AddProductionLineMgr.static.NomalColor = Vector3.New(230, 226, 205)  --未选中时显示的颜色

AddProductionLineMgr.static.ButtonItemPath = "View/GoodsItem/AddLineBtnItem"  --左侧需要加载的预制
AddProductionLineMgr.static.GoodDetailItemPath = "View/GoodsItem/AddGoodDetailItem"  --右侧滑动需要加载的预制

--位于哪边，左右两边具有不同意义
AddLineButtonPosValue =
{
    Left = 0,
    Right = 1,
}
function AddProductionLineMgr:initialize(viewRect, sideValue)
    self.viewRect = viewRect
    self.sideValue = sideValue

    self.typeToggleGroup = viewRect:Find("typeRoot"):GetComponent("ToggleGroup")
    self.typeContent = viewRect:Find("typeRoot/typeScroll/content")
    self.detailToggleGroup = viewRect:Find("detailRoot"):GetComponent("ToggleGroup")
    self.detailContent = viewRect:Find("detailRoot/detailScroll/content"):GetComponent("RectTransform")

    self.togglePrefab = UnityEngine.Resources.Load(AddProductionLineMgr.static.ButtonItemPath)
    self.detailPrefab = UnityEngine.Resources.Load(AddProductionLineMgr.static.GoodDetailItemPath)

    self.detailPrefabList = {}
    self.toggleItems = {}
    self.keyToggleItems = {}
    self.keyContentItems = {}

    for i, typeItem in pairs(BuildingProductionPart.test) do
        if (sideValue == AddLineButtonPosValue.Left) and i < 2200 or (sideValue == AddLineButtonPosValue.Right and i > 2200) then
            local go = UnityEngine.GameObject.Instantiate(self.togglePrefab)
            go.transform:SetParent(self.typeContent.transform)
            go.transform.localScale = Vector3.one
            local tempData = {languageId = typeItem[1].name, typeId = i, backFunc = function (typeId)
                self:_showDetails(typeId)
            end}
            local item = AddLineBtnItem:new(go.transform, tempData, self.typeToggleGroup)
            self.toggleItems[#self.toggleItems + 1] = item
            self.keyToggleItems[i] = item  --创建以typeId为key的表
        end
    end
    --UpdateBeat:Add(self._update, self)
    FixedUpdateBeat:Add(self._update, self)
end
--
function AddProductionLineMgr:_language()
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
function AddProductionLineMgr:initData(chooseTypeId)
    self:_language()
    self.detailContent.anchoredPosition = Vector2.zero

    --设置默认打开的类别
    for i, item in pairs(self.toggleItems) do
        self.toggleItems[i]:setToggleIsOn(false)
    end

    --根据特定值去设置toggle
    if chooseTypeId ~= nil then
        for i, item in pairs(self.toggleItems) do
            if self.toggleItems[i]:getTypeId() == chooseTypeId then
                self.toggleItems[i]:setToggleIsOn(true)
                self.tempTypeId = self.toggleItems[i]:getTypeId()
                return
            end
        end
    end

    self.toggleItems[1]:setToggleIsOn(true)
    self.tempTypeId = self.toggleItems[1]:getTypeId()
end
--获取当前选择的typeId
function AddProductionLineMgr:getCurrentTypeId()
    return self.tempTypeId
end

--根据typeId 和 itemId 获取对应的item，并显示选中状态
function AddProductionLineMgr:setToggleIsOnByType(itemId)
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
function AddProductionLineMgr:_showDetails(typeId)
    ct.log("system", "+++++++++++++++++++++showDetail: "..typeId)
    self:_resetDetails()
    self.contentItems = {}

    --暂时是直接使用content下的子物体，多了的就移出content
    local data = BuildingProductionPart.test[typeId]
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
        local item = AddGoodDetailItem:new(go.transform, tempData, self.detailToggleGroup)
        self.contentItems[#self.contentItems + 1] = item
        self.keyContentItems[itemData.itemId] = item  --创建以itemId为key的详情表
    end

    for i, item in ipairs(self.contentItems) do
        self.contentItems[i]:setToggleIsOn(false)
    end
    self.contentItems[1]:setToggleIsOn(true)
    self.tempDetailItemId = self.contentItems[1]:getItemId()
end
--选择了某个item，显示线路
function AddProductionLineMgr:_setLineShow(itemId, rectPosition, enableShow)
    self.tempDetailItemId = itemId

    if self.sideValue == AddLineButtonPosValue.Left then
        Event.Brocast("leftSetCenter", itemId, rectPosition, enableShow)
    elseif self.sideValue == AddLineButtonPosValue.Right then
        Event.Brocast("rightSetCenter", itemId, rectPosition, enableShow)
    end
end
--回收预制
function AddProductionLineMgr:_releaseObj(obj)
    obj.transform:SetParent(self.detailToggleGroup.transform)
    obj.transform.localScale = Vector3.zero
    obj.transform.localPosition = Vector3.zero
end
--清空选中状态
function AddProductionLineMgr:_resetDetails()
    if self.contentItems then
        for i, item in ipairs(self.contentItems) do
            item:cleanState()
        end
        self.tempDetailItemId = nil
    end
end
--
function AddProductionLineMgr:_update()
    if self.sideValue == AddLineButtonPosValue.Left then
        if self.keyContentItems[self.tempDetailItemId] ~= nil then
            local pos = self.keyContentItems[self.tempDetailItemId]:getItemPos()
            AddProductionLinePanel.leftBtnParent.transform.position = pos
        end
        return
    end

    if self.sideValue == AddLineButtonPosValue.Right then
        if self.keyContentItems[self.tempDetailItemId] ~= nil then
            local pos = self.keyContentItems[self.tempDetailItemId]:getItemPos()
            AddProductionLinePanel.rightBtnParent.transform.position = pos
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
function AddProductionLineMgr.SetBuildingIconSpite(name , tempImage)
    if JudgeHasBuildingIcon() == true then
        tempImage.sprite = GetBuildingIcon(name)
        --tempImage:SetNativeSize()
    else
        LoadBuildingIcon(name , tempImage)
    end
end