---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/5 10:00
---
AddLineChooseItemCtrl = class('AddLineChooseItemCtrl',UIPage)
UIPage:ResgisterOpen(AddLineChooseItemCtrl)

function AddLineChooseItemCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function AddLineChooseItemCtrl:bundleName()
    return "AddLineChooseItemPanel"
end

function AddLineChooseItemCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function AddLineChooseItemCtrl:Awake(go)
    self.gameObject = go
    self.behaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.behaviour:AddClick(AddLineChooseItemPanel.backBtn.gameObject, function ()
        self:Hide()
    end, self)
    self.behaviour:AddClick(AddLineChooseItemPanel.leftBtn.gameObject, function ()
        ct.OpenCtrl("LabInventionCtrl", {itemId = self.chooseInventItemId})
        self:Hide()
    end, self)

    self:_addListener()
end

function AddLineChooseItemCtrl:Refresh()
    self:_initData()
end
function AddLineChooseItemCtrl:_addListener()
    Event.AddListener("c_leftSetCenter", self._leftSetCenter, self)
    Event.AddListener("c_rightSetCenter", self._rightSetCenter, self)
end
function AddLineChooseItemCtrl:_removeListener()
    Event.RemoveListener("c_leftSetCenter", self._leftSetCenter, self)
    Event.RemoveListener("c_rightSetCenter", self._rightSetCenter, self)
end

function AddLineChooseItemCtrl:_initData()
    AddLineChooseItemCtrl.goodLv = DataManager.GetMyGoodLv()
    local buildingId = LabScientificLineCtrl.static.buildingId
    if LabScientificLineCtrl.static.type == 0 then
        AddLineChooseItemPanel.titleText.text = "Research"
        AddLineChooseItemPanel.leftBtnParentTran.transform.localScale = Vector3.zero
        AddLineChooseItemPanel.rightBtnParentTran.transform.localScale = Vector3.one

        AddLineChooseItemPanel.rightBtn.onClick:RemoveAllListeners()
        AddLineChooseItemPanel.rightBtn.onClick:AddListener(function ()
            self:Hide()
            ct.OpenCtrl("LabResearchCtrl", {itemId = self.chooseResearchItemId})
        end)

        DataManager.DetailModelRpc(buildingId, 'm_GetResearchingItem', function (tables)
            AddLineChooseItemCtrl.researchingItems = tables
        end)
    else
        AddLineChooseItemPanel.titleText.text = "Invent"
        AddLineChooseItemPanel.leftBtnParentTran.transform.localScale = Vector3.one
        AddLineChooseItemPanel.rightBtnParentTran.transform.localScale = Vector3.one

        AddLineChooseItemPanel.rightBtn.onClick:RemoveAllListeners()
        AddLineChooseItemPanel.rightBtn.onClick:AddListener(function ()
            self:Hide()
            ct.OpenCtrl("LabInventionCtrl", {itemId = self.chooseInventItemId})
        end)

        DataManager.DetailModelRpc(buildingId, 'm_GetInventingItem', function (tables)
            AddLineChooseItemCtrl.inventingItems = tables
        end)
    end

    --在最开始的时候创建所有左右toggle信息，然后每次初始化的时候只需要设置默认值就行了
    AddLineChooseItemPanel.leftToggleMgr:initData()
    AddLineChooseItemPanel.rightToggleMgr:initData()
end
--根据itemId获得当前应该显示的状态
function AddLineChooseItemCtrl.GetItemState(itemId)
    local data = {}
    data.enableShow = true
    data.itemState = AddLineDetailItemState.Default

    if LabScientificLineCtrl.static.type == 0 then
        if AddLineChooseItemCtrl.researchingItems[itemId] then
            data.enableShow = false
            data.itemState = AddLineDetailItemState.ResearchIng
        end
        if not AddLineChooseItemCtrl.goodLv[itemId] then
            data.enableShow = false
            data.itemState = AddLineDetailItemState.ToBeInvented
        end
    else
        if AddLineChooseItemCtrl.inventingItems[itemId] then
            data.enableShow = false
            data.itemState = AddLineDetailItemState.InventIng
        end
        if AddLineChooseItemCtrl.goodLv[itemId] then
            data.enableShow = false
            data.itemState = AddLineDetailItemState.HasInvented
        end
    end

    return data
end

--左边的detail被点击，需要改变中心线
function AddLineChooseItemCtrl:_leftSetCenter(itemId, rectPosition, enableShow)
    AddLineChooseItemPanel.leftBtnParentTran.transform.position = rectPosition
    AddLineChooseItemPanel.leftBtnParentTran.anchoredPosition = AddLineChooseItemPanel.leftBtnParentTran.anchoredPosition + Vector2.New(174, 0)

    --tempData = Material[itemId]
    self.selectItemMatToGoodIds = CompoundDetailConfig[itemId].matCompoundGoods
    local lineDatas = {}  --获取线的数据
    for i, matData in ipairs(CompoundDetailConfig[self.selectItemMatToGoodIds[1]].goodsNeedMatData) do
        lineDatas[#lineDatas + 1] = matData
    end
    self:_setLineDetailInfo(lineDatas)
    AddLineChooseItemPanel.productionItem:initData(Good[self.selectItemMatToGoodIds[1]])
    AddLineChooseItemPanel.rightToggleMgr:setToggleIsOnByType(self.selectItemMatToGoodIds[1])

    if enableShow then
        AddLineChooseItemPanel.leftDisableImg.localScale = Vector3.zero
        self.chooseInventItemId = itemId
    else
        AddLineChooseItemPanel.leftDisableImg.localScale = Vector3.one
    end
end
--右侧的detail被点击，改变中心线
function AddLineChooseItemCtrl:_rightSetCenter(itemId, rectPosition, enableShow)
    AddLineChooseItemPanel.rightBtnParentTran.transform.position = rectPosition
    AddLineChooseItemPanel.rightBtnParentTran.anchoredPosition = AddLineChooseItemPanel.rightBtnParentTran.anchoredPosition - Vector2.New(174, 0)

    local selectItemMatToGoodIds = CompoundDetailConfig[itemId].goodsNeedMatData
    self:_setLineDetailInfo(selectItemMatToGoodIds)
    AddLineChooseItemPanel.productionItem:initData(Good[itemId])

    if enableShow then
        AddLineChooseItemPanel.rightDisableImg.localScale = Vector3.zero
        if LabScientificLineCtrl.static.type == 0 then
            if itemId >= 2200000 then
                self.chooseResearchItemId = itemId
            end
        else
            self.chooseInventItemId = itemId
        end
    else
        AddLineChooseItemPanel.rightDisableImg.localScale = Vector3.one
    end
end

--设置原料线的信息  根据个数显示位置
function AddLineChooseItemCtrl:_setLineDetailInfo(datas)
    local lineCount = #datas
    if lineCount == 1 then
        AddLineChooseItemPanel.centerItems[1]:setObjState(false)
        AddLineChooseItemPanel.centerItems[2]:setObjState(true)
        AddLineChooseItemPanel.centerItems[3]:setObjState(false)
        AddLineChooseItemPanel.hLine.localScale = Vector3.one
        AddLineChooseItemPanel.vLine.localScale = Vector3.zero

        AddLineChooseItemPanel.centerItems[2]:initData(datas[1])
    elseif lineCount == 2 then
        AddLineChooseItemPanel.centerItems[1]:setObjState(true)
        AddLineChooseItemPanel.centerItems[2]:setObjState(false)
        AddLineChooseItemPanel.centerItems[3]:setObjState(true)
        AddLineChooseItemPanel.hLine.localScale = Vector3.zero
        AddLineChooseItemPanel.vLine.localScale = Vector3.one

        AddLineChooseItemPanel.centerItems[1]:initData(datas[1])
        AddLineChooseItemPanel.centerItems[3]:initData(datas[2])
    elseif lineCount == 3 then
        AddLineChooseItemPanel.centerItems[1]:setObjState(true)
        AddLineChooseItemPanel.centerItems[2]:setObjState(true)
        AddLineChooseItemPanel.centerItems[3]:setObjState(true)
        AddLineChooseItemPanel.hLine.localScale = Vector3.one
        AddLineChooseItemPanel.vLine.localScale = Vector3.one

        AddLineChooseItemPanel.centerItems[1]:initData(datas[1])
        AddLineChooseItemPanel.centerItems[2]:initData(datas[2])
        AddLineChooseItemPanel.centerItems[3]:initData(datas[3])
    end
end