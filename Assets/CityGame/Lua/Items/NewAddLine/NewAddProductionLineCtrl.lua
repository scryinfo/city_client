---
---合成界面
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
    --在最开始的时候创建所有左右toggle信息，然后每次初始化的时候只需要设置默认值就行了
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


--根据itemId获得当前应该显示的状态
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

--左边的detail被点击，需要改变中心线
function NewAddProductionLineCtrl:leftSetCenter(itemId, rectPosition, enableShow)
    --NewAddProductionLinePanel.leftBtnParent.transform.position = rectPosition
    --NewAddProductionLinePanel.leftBtnParent.anchoredPosition = NewAddProductionLinePanel.leftBtnParent.anchoredPosition + Vector2.New(174, 0)

    --ct.log("system", "-----------选中 left: "..itemId)

    self.selectItemMatToGoodIds = CompoundDetailConfig[itemId].matCompoundGoods
    local lineDatas = {}  --获取线的数据
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
--右侧的detail被点击，改变中心线
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
--设置原料线的信息  根据个数显示位置
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
--获取选中原料或商品当前的生产速度(含Eva加成值)
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
    ----开始初始化
    --Event.Brocast("c_NewAddLineLoadFinish")
end

--先加载完所有图片再初始化
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

--设置ICon的Sprite
function NewAddProductionLineCtrl.SetBuildingIconSpite(itemId , tempImage)
    tempImage.sprite = SpriteManager.GetSpriteByPool(itemId)
    --if JudgeHasBuildingIcon(name) == true then
    --    tempImage.sprite = GetBuildingIcon(name)
    --end
end