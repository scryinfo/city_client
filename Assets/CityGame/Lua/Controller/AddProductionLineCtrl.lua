AddProductionLineCtrl = class('AddProductionLineCtrl',UIPanel)
UIPanel:ResgisterOpen(AddProductionLineCtrl)

function AddProductionLineCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
    --UIPanel.initialize(self, UIType.PopUp, UIMode.HideOther, UICollider.Normal)
end

function AddProductionLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AddProductionLinePanel.prefab"
end

function AddProductionLineCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function AddProductionLineCtrl:Awake(go)
    self.gameObject = go
    self.luabehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.luabehaviour:AddClick(AddProductionLinePanel.returnBtn.gameObject,function()
        UIPanel.ClosePage()
    end,self)
    self:_addListener()
end
--
function AddProductionLineCtrl:Active()
    UIPanel.Active(self)
    AddProductionLinePanel.nameText.text = GetLanguage(25030002)
end
--
function AddProductionLineCtrl:Refresh()
    self:_initData()
end
--
function AddProductionLineCtrl:_addListener()
    Event.AddListener("leftSetCenter", self.leftSetCenter, self)
    Event.AddListener("rightSetCenter", self.rightSetCenter, self)
    --Event.AddListener("c_new_changeAddlineData", self._changeAddLineData, self)
end
--
function AddProductionLineCtrl:_initData()
    AddProductionLineCtrl.goodLv = DataManager.GetMyGoodLv()
    local data = {}
    AddProductionLineCtrl.static.buildingType = self.m_data.buildingType
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        AddProductionLinePanel.leftBtnParent.transform.localScale = Vector3.one
        AddProductionLinePanel.rightBtnParent.transform.localScale = Vector3.zero

        AddProductionLinePanel.leftBtn.onClick:RemoveAllListeners()
        AddProductionLinePanel.leftBtn.onClick:AddListener(function ()
            data.itemId = self.leftItemId
            data.mId = self.m_data.mId
            data.insId = self.m_data.buildingId
            data.buildingType = self.m_data.buildingType
            data.numOneSec = self:getPresentSpeed(data.itemId)
            ct.OpenCtrl("AddProductionLineBoxCtrl",data)
        end)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        AddProductionLinePanel.leftBtnParent.transform.localScale = Vector3.zero
        AddProductionLinePanel.rightBtnParent.transform.localScale = Vector3.one

        AddProductionLinePanel.rightBtn.onClick:RemoveAllListeners()
        AddProductionLinePanel.rightBtn.onClick:AddListener(function ()
            data.itemId = self.rightItemId
            data.mId = self.m_data.mId
            data.insId = self.m_data.buildingId
            data.buildingType = self.m_data.buildingType
            data.info = self:getPresentSpeed(data.itemId)
            ct.OpenCtrl("AddProductionLineBoxCtrl",data)
        end)
    end
    self:_changeAddLineData(AddLineButtonPosValue.Left)
end

function AddProductionLineCtrl:_changeAddLineData(posValue, itemId)
    --Create all the left and right toggle information at the beginning, and then only need to set the default value each time you initialize
    if posValue == AddLineButtonPosValue.Left then
        AddProductionLinePanel.leftToggleMgr:initData(itemId)
        local matTypeId = AddProductionLinePanel.leftToggleMgr:getCurrentTypeId()
        local goodTypeId = TempCompoundTypeConnectConfig[matTypeId]
        AddProductionLinePanel.rightToggleMgr:initData(goodTypeId)
    else
        AddProductionLinePanel.rightToggleMgr:initData(itemId)
        local matTypeId = AddProductionLinePanel.rightToggleMgr:getCurrentTypeId()
        local goodTypeId = TempCompoundTypeConnectConfig[matTypeId]
        AddProductionLinePanel.leftToggleMgr:initData(goodTypeId)
    end
end

----


--Get the status that should be displayed according to itemId
function AddProductionLineCtrl.GetItemState(itemId)
    local data = {}
    data.enableShow = true
    if AddProductionLineCtrl.static.buildingType == BuildingType.MaterialFactory then

    elseif AddProductionLineCtrl.static.buildingType == BuildingType.ProcessingFactory then
        if not AddProductionLineCtrl.goodLv[itemId] then
            data.enableShow = false
        else
            data.enableShow = true
        end
    end
    return data
end

--The detail on the left is clicked and the centerline needs to be changed
function AddProductionLineCtrl:leftSetCenter(itemId, rectPosition, enableShow)
    --AddProductionLinePanel.leftBtnParent.transform.position = rectPosition
    --AddProductionLinePanel.leftBtnParent.anchoredPosition = AddProductionLinePanel.leftBtnParent.anchoredPosition + Vector2.New(174, 0)

    ct.log("system", "-----------Selected left: "..itemId)

    self.selectItemMatToGoodIds = CompoundDetailConfig[itemId].matCompoundGoods
    local lineDatas = {}  --Get line data
    for i, matData in ipairs(CompoundDetailConfig[self.selectItemMatToGoodIds[1]].goodsNeedMatData) do
        lineDatas[#lineDatas + 1] = matData
    end
    self:_setLineDetailInfo(lineDatas)
    AddProductionLinePanel.productionItem:initData(Good[self.selectItemMatToGoodIds[1]])
    AddProductionLinePanel.rightToggleMgr:setToggleIsOnByType(self.selectItemMatToGoodIds[1])

    if enableShow then
        AddProductionLinePanel.leftDisableImg.localScale = Vector3.zero
        self.leftItemId = itemId
    else
        AddProductionLinePanel.leftDisableImg.localScale = Vector3.one
    end
end
--The detail on the right is clicked to change the centerline
function AddProductionLineCtrl:rightSetCenter(itemId, rectPosition, enableShow)
    --AddProductionLinePanel.rightBtnParent.transform.position = rectPosition
    --AddProductionLinePanel.rightBtnParent.anchoredPosition = AddProductionLinePanel.rightBtnParent.anchoredPosition - Vector2.New(174, 0)

    ct.log("system", "-----------Selected right: "..itemId)

    local selectItemMatToGoodIds = CompoundDetailConfig[itemId].goodsNeedMatData
    self:_setLineDetailInfo(selectItemMatToGoodIds)
    AddProductionLinePanel.productionItem:initData(Good[itemId])
    --AddProductionLinePanel.leftToggleMgr:setToggleIsOnByType(selectItemMatToGoodIds[1].itemId)

    if enableShow then
        AddProductionLinePanel.rightDisableImg.localScale = Vector3.zero
        self.rightItemId = itemId
    else
        AddProductionLinePanel.rightDisableImg.localScale = Vector3.one
    end
end
--Set the information of the raw material line to display the position according to the number
function AddProductionLineCtrl:_setLineDetailInfo(datas)
    local lineCount = #datas
    if lineCount == 1 then
        AddProductionLinePanel.centerItems[1]:setObjState(false)
        AddProductionLinePanel.centerItems[2]:setObjState(true)
        AddProductionLinePanel.centerItems[3]:setObjState(false)
        AddProductionLinePanel.hLine.localScale = Vector3.one
        AddProductionLinePanel.vLine.localScale = Vector3.zero

        AddProductionLinePanel.centerItems[2]:initData(datas[1])
    elseif lineCount == 2 then
        AddProductionLinePanel.centerItems[1]:setObjState(true)
        AddProductionLinePanel.centerItems[2]:setObjState(false)
        AddProductionLinePanel.centerItems[3]:setObjState(true)
        AddProductionLinePanel.hLine.localScale = Vector3.zero
        AddProductionLinePanel.vLine.localScale = Vector3.one

        AddProductionLinePanel.centerItems[1]:initData(datas[1])
        AddProductionLinePanel.centerItems[3]:initData(datas[2])
    elseif lineCount == 3 then
        AddProductionLinePanel.centerItems[1]:setObjState(true)
        AddProductionLinePanel.centerItems[2]:setObjState(true)
        AddProductionLinePanel.centerItems[3]:setObjState(true)
        AddProductionLinePanel.hLine.localScale = Vector3.one
        AddProductionLinePanel.vLine.localScale = Vector3.one

        AddProductionLinePanel.centerItems[1]:initData(datas[1])
        AddProductionLinePanel.centerItems[2]:initData(datas[2])
        AddProductionLinePanel.centerItems[3]:initData(datas[3])
    end
end
--Get the current production speed of selected raw materials or commodities (including Eva bonus value)
function AddProductionLineCtrl:getPresentSpeed(itemId)
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
function AddProductionLineCtrl:Hide()
    UIPanel.Hide(self)
    --return {insId = self.m_data.info.id}
end
