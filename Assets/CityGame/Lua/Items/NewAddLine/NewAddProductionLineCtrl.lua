---
---Synthesis interface
---
NewAddProductionLineCtrl = class('NewAddProductionLineCtrl',UIPanel)
UIPanel:ResgisterOpen(NewAddProductionLineCtrl)

function NewAddProductionLineCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end

function NewAddProductionLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/NewAddProductionLinePanel.prefab"
end

function NewAddProductionLineCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function NewAddProductionLineCtrl:Awake(go)
    self.gameObject = go
    self.luabehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.luabehaviour:AddClick(NewAddProductionLinePanel.returnBtn.gameObject,function()
        UIPanel.ClosePage()
    end,self)
    self:_addListener()
    --NewAddProductionLineCtrl.GetAllImg()
end
--
function NewAddProductionLineCtrl:Active()
    UIPanel.Active(self)
    NewAddProductionLinePanel.nameText.text = GetLanguage(25030002)
end
--
function NewAddProductionLineCtrl:Refresh()
    self:_initData()
    --NewAddProductionLineCtrl.CheckLoad()
end
--
function NewAddProductionLineCtrl:_addListener()
    Event.AddListener("leftSetCenter", self.leftSetCenter, self)
    Event.AddListener("rightSetCenter", self.rightSetCenter, self)
    Event.AddListener("c_NewAddLineLoadFinish", self._initData, self)
end
--
function NewAddProductionLineCtrl:_initData()
    NewAddProductionLineCtrl.goodLv = DataManager.GetMyGoodLv()
    local data = {}
    NewAddProductionLineCtrl.static.buildingType = self.m_data.buildingType
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        NewAddProductionLinePanel.leftBtnParent.transform.localScale = Vector3.one
        NewAddProductionLinePanel.rightBtnParent.transform.localScale = Vector3.zero

        NewAddProductionLinePanel.leftBtn.onClick:RemoveAllListeners()
        NewAddProductionLinePanel.leftBtn.onClick:AddListener(function ()
            data.itemId = self.leftItemId
            data.mId = self.m_data.mId
            data.insId = self.m_data.buildingId
            data.buildingType = self.m_data.buildingType
            data.numOneSec = self:getPresentSpeed(data.itemId)
            ct.OpenCtrl("AddProductionLineBoxCtrl",data)
        end)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        NewAddProductionLinePanel.leftBtnParent.transform.localScale = Vector3.zero
        NewAddProductionLinePanel.rightBtnParent.transform.localScale = Vector3.one

        NewAddProductionLinePanel.rightBtn.onClick:RemoveAllListeners()
        NewAddProductionLinePanel.rightBtn.onClick:AddListener(function ()
            data.itemId = self.rightItemId
            data.mId = self.m_data.mId
            data.insId = self.m_data.buildingId
            data.buildingType = self.m_data.buildingType
            data.info = self:getPresentSpeed(data.itemId)
            ct.OpenCtrl("AddProductionLineBoxCtrl",data)
        end)
    end
    self:_changeAddLineData(AddLineSideValue.Left)
end

function NewAddProductionLineCtrl:_changeAddLineData(posValue, itemId)
    --Create all the left and right toggle information at the beginning, and then only need to set the default value each time you initialize
    if posValue == AddLineSideValue.Left then
        NewAddProductionLinePanel.leftToggleMgr:initData(itemId)
        local matTypeId = NewAddProductionLinePanel.leftToggleMgr:getCurrentTypeId()
        local goodTypeId = TempCompoundTypeConnectConfig[matTypeId]
        NewAddProductionLinePanel.rightToggleMgr:initData(goodTypeId)
    else
        NewAddProductionLinePanel.rightToggleMgr:initData(itemId)
        local matTypeId = NewAddProductionLinePanel.rightToggleMgr:getCurrentTypeId()
        local goodTypeId = TempCompoundTypeConnectConfig[matTypeId]
        NewAddProductionLinePanel.leftToggleMgr:initData(goodTypeId)
    end
end

----


--Get the status that should be displayed according to itemId
function NewAddProductionLineCtrl.GetItemState(itemId)
    local data = {}
    data.enableShow = true
    if NewAddProductionLineCtrl.static.buildingType == BuildingType.MaterialFactory then

    elseif NewAddProductionLineCtrl.static.buildingType == BuildingType.ProcessingFactory then
        if not NewAddProductionLineCtrl.goodLv[itemId] then
            data.enableShow = false
        else
            data.enableShow = true
        end
    end
    return data
end

--The detail on the left is clicked and the centerline needs to be changed
function NewAddProductionLineCtrl:leftSetCenter(itemId, rectPosition, enableShow)
    --NewAddProductionLinePanel.leftBtnParent.transform.position = rectPosition
    --NewAddProductionLinePanel.leftBtnParent.anchoredPosition = NewAddProductionLinePanel.leftBtnParent.anchoredPosition + Vector2.New(174, 0)

    --ct.log("system", "-----------选中 left: "..itemId)

    self.selectItemMatToGoodIds = CompoundDetailConfig[itemId].matCompoundGoods
    local lineDatas = {}  --Get line data
    for i, matData in ipairs(CompoundDetailConfig[self.selectItemMatToGoodIds[1]].goodsNeedMatData) do
        lineDatas[#lineDatas + 1] = matData
    end
    self:_setLineDetailInfo(lineDatas)
    NewAddProductionLinePanel.productionItem:initData(Good[self.selectItemMatToGoodIds[1]])
    NewAddProductionLinePanel.rightToggleMgr:setToggleIsOnByType(self.selectItemMatToGoodIds[1])

    if enableShow then
        NewAddProductionLinePanel.leftDisableImg.localScale = Vector3.zero
        self.leftItemId = itemId
    else
        NewAddProductionLinePanel.leftDisableImg.localScale = Vector3.one
    end
end
--The detail on the right is clicked to change the centerline
function NewAddProductionLineCtrl:rightSetCenter(itemId, rectPosition, enableShow)
    --NewAddProductionLinePanel.rightBtnParent.transform.position = rectPosition
    --NewAddProductionLinePanel.rightBtnParent.anchoredPosition = NewAddProductionLinePanel.rightBtnParent.anchoredPosition - Vector2.New(174, 0)

    --ct.log("system", "-----------选中 right: "..itemId)

    local selectItemMatToGoodIds = CompoundDetailConfig[itemId].goodsNeedMatData
    self:_setLineDetailInfo(selectItemMatToGoodIds)
    NewAddProductionLinePanel.productionItem:initData(Good[itemId])
    --NewAddProductionLinePanel.leftToggleMgr:setToggleIsOnByType(selectItemMatToGoodIds[1].itemId)

    if enableShow then
        NewAddProductionLinePanel.rightDisableImg.localScale = Vector3.zero
        self.rightItemId = itemId
    else
        NewAddProductionLinePanel.rightDisableImg.localScale = Vector3.one
    end
end
--Set the information of the raw material line to display the position according to the number
function NewAddProductionLineCtrl:_setLineDetailInfo(datas)
    local lineCount = #datas
    if lineCount == 1 then
        NewAddProductionLinePanel.centerItems[1]:setObjState(false)
        NewAddProductionLinePanel.centerItems[2]:setObjState(true)
        NewAddProductionLinePanel.centerItems[3]:setObjState(false)
        NewAddProductionLinePanel.hLine.localScale = Vector3.one
        NewAddProductionLinePanel.vLine.localScale = Vector3.zero

        NewAddProductionLinePanel.centerItems[2]:initData(datas[1])
    elseif lineCount == 2 then
        NewAddProductionLinePanel.centerItems[1]:setObjState(true)
        NewAddProductionLinePanel.centerItems[2]:setObjState(false)
        NewAddProductionLinePanel.centerItems[3]:setObjState(true)
        NewAddProductionLinePanel.hLine.localScale = Vector3.zero
        NewAddProductionLinePanel.vLine.localScale = Vector3.one

        NewAddProductionLinePanel.centerItems[1]:initData(datas[1])
        NewAddProductionLinePanel.centerItems[3]:initData(datas[2])
    elseif lineCount == 3 then
        NewAddProductionLinePanel.centerItems[1]:setObjState(true)
        NewAddProductionLinePanel.centerItems[2]:setObjState(true)
        NewAddProductionLinePanel.centerItems[3]:setObjState(true)
        NewAddProductionLinePanel.hLine.localScale = Vector3.one
        NewAddProductionLinePanel.vLine.localScale = Vector3.one

        NewAddProductionLinePanel.centerItems[1]:initData(datas[1])
        NewAddProductionLinePanel.centerItems[2]:initData(datas[2])
        NewAddProductionLinePanel.centerItems[3]:initData(datas[3])
    end
end
--Get the current production speed of selected raw materials or commodities (including Eva bonus value)
function NewAddProductionLineCtrl:getPresentSpeed(itemId)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        for key,value in pairs(self.m_data.items) do
            if value.key == itemId then
                return value.numOneSec
            end
        end
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        for key,value in pairs(self.m_data.items) do
            if value.key == itemId then
                return value
            end
        end
    end
end
--
function NewAddProductionLineCtrl:Hide()
    UIPanel.Hide(self)
    self:_cleanData()
end
--
function NewAddProductionLineCtrl:_cleanData()
    NewAddProductionLinePanel.leftToggleMgr:_cleanAll()
    NewAddProductionLinePanel.rightToggleMgr:_cleanAll()
end

--------------------------------------------------------------------------------------------------------------------------------
local m_MatGoodIconSpriteList = {}

--Add BuildingIcon's sprite list
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
        if obj ~= nil  then
            local texture = ct.InstantiatePrefab(obj)
            AddBuildingIcon(name,texture)
            NewAddProductionLineCtrl.CheckLoad()
        end
    end)
end
--
function NewAddProductionLineCtrl.CheckLoad()
    --for i, img in ipairs(NewAddProductionLineCtrl.tempList) do
    --    if JudgeHasBuildingIcon(img) == false then
    --        LoadBuildingIcon(img)
    --        return
    --    end
    --end
    ----Start initialization
    --Event.Brocast("c_NewAddLineLoadFinish")
end

--Load all pictures before initializing
function NewAddProductionLineCtrl.GetAllImg()
    NewAddProductionLineCtrl.tempList = {}
    for i, mat in pairs(Material) do
        NewAddProductionLineCtrl.tempList[#NewAddProductionLineCtrl.tempList + 1] = mat.img
    end
    for i, good in pairs(Good) do
        NewAddProductionLineCtrl.tempList[#NewAddProductionLineCtrl.tempList + 1] = good.img
    end
    NewAddProductionLineCtrl.CheckLoad()
end

--Set up ICon Sprite
function NewAddProductionLineCtrl.SetBuildingIconSpite(itemId , tempImage)
    tempImage.sprite = SpriteManager.GetSpriteByPool(itemId)
    --if JudgeHasBuildingIcon(name) == true then
    --    tempImage.sprite = GetBuildingIcon(name)
    --end
end