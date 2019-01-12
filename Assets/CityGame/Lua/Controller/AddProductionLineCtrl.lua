AddProductionLineCtrl = class('AddProductionLineCtrl',UIPage)
UIPage:ResgisterOpen(AddProductionLineCtrl)

function AddProductionLineCtrl:initialize()
    --UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function AddProductionLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AddProductionLinePanel.prefab"
end

function AddProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
end

function AddProductionLineCtrl:Awake(go)
    self.gameObject = go
    self.luabehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.luabehaviour:AddClick(AddProductionLinePanel.returnBtn.gameObject,function()
        self:Hide();
        --UIPage.ClosePage();
    end,self)
    self.luabehaviour:AddClick(AddProductionLinePanel.leftBtn.gameObject,function()
        --ct.OpenCtrl("AdjustProductionLineCtrl",{itemId = self.chooseInventItemId})
        GoodsUnifyMgr:_creatProductionLine(self.luabehaviour,self.chooseInventItemId,self.m_data.info.id)
        self:Hide();
        --UIPage.ClosePage();
    end,self)

    self:_addListener()
end

function AddProductionLineCtrl:Refresh()
    self:_initData()
end
function AddProductionLineCtrl:_addListener()
    Event.AddListener("leftSetCenter", self.leftSetCenter, self)
    Event.AddListener("rightSetCenter", self.rightSetCenter, self)
end

function AddProductionLineCtrl:_initData()
    --这里要区分是生产左边还是右边，然后把确定按钮打开
    AddProductionLineCtrl.goodLv = DataManager.GetMyGoodLv()
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        AddProductionLinePanel.leftBtnParent.transform.localScale = Vector3.one
        AddProductionLinePanel.rightBtnParent.transform.localScale = Vector3.zero

        AddProductionLinePanel.rightBtn.onClick:RemoveAllListeners()
        AddProductionLinePanel.rightBtn.onClick:AddListener(function ()
            self:Hide();
            --ct.OpenCtrl("AdjustProductionLineCtrl", {itemId = self.chooseInventItemId})
            GoodsUnifyMgr:_creatProductionLine(self.luabehaviour,self.chooseInventItemId,self.m_data.info.id)

        end)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        AddProductionLinePanel.leftBtnParent.transform.localScale = Vector3.zero
        AddProductionLinePanel.rightBtnParent.transform.localScale = Vector3.one

        --加工厂确定生产按钮
        AddProductionLinePanel.rightBtn.onClick:RemoveAllListeners()
        AddProductionLinePanel.rightBtn.onClick:AddListener(function ()
            self:Hide();
            --ct.OpenCtrl("AdjustProductionLineCtrl", {itemId = self.chooseInventItemId})
            GoodsUnifyMgr:_creatProductionLine(self.luabehaviour,self.chooseInventItemId,self.m_data.info.id)
        end)
    end

    --在最开始的时候创建所有左右toggle信息，然后每次初始化的时候只需要设置默认值就行了
    AddProductionLinePanel.leftToggleMgr:initData()
    AddProductionLinePanel.rightToggleMgr:initData()
end

--根据itemId获得当前应该显示的状态
function AddProductionLineCtrl.GetItemState(itemId)
    local data = {}
    data.enableShow = true

    if not AddProductionLineCtrl.goodLv[itemId] then
        data.enableShow = false
    else
        data.enableShow = true
    end
    return data
end

--左边的detail被点击，需要改变中心线
function AddProductionLineCtrl:leftSetCenter(itemId, rectPosition, enableShow)
    AddProductionLinePanel.leftBtnParent.transform.position = rectPosition
    AddProductionLinePanel.leftBtnParent.anchoredPosition = AddProductionLinePanel.leftBtnParent.anchoredPosition + Vector2.New(174, 0)

    --tempData = Material[itemId]
    self.selectItemMatToGoodIds = CompoundDetailConfig[itemId].matCompoundGoods
    local lineDatas = {}  --获取线的数据
    for i, matData in ipairs(CompoundDetailConfig[self.selectItemMatToGoodIds[1]].goodsNeedMatData) do
        lineDatas[#lineDatas + 1] = matData
    end
    self:_setLineDetailInfo(lineDatas)
    AddProductionLinePanel.productionItem:initData(Good[self.selectItemMatToGoodIds[1]])
    AddProductionLinePanel.rightToggleMgr:setToggleIsOnByType(self.selectItemMatToGoodIds[1])

    if enableShow then
        AddProductionLinePanel.leftDisableImg.localScale = Vector3.zero
        self.chooseInventItemId = itemId
    else
        AddProductionLinePanel.leftDisableImg.localScale = Vector3.one
    end
end
--右侧的detail被点击，改变中心线
function AddProductionLineCtrl:rightSetCenter(itemId, rectPosition, enableShow)
    AddProductionLinePanel.rightBtnParent.transform.position = rectPosition
    AddProductionLinePanel.rightBtnParent.anchoredPosition = AddProductionLinePanel.rightBtnParent.anchoredPosition - Vector2.New(174, 0)

    local selectItemMatToGoodIds = CompoundDetailConfig[itemId].goodsNeedMatData
    self:_setLineDetailInfo(selectItemMatToGoodIds)
    AddProductionLinePanel.productionItem:initData(Good[itemId])

    if enableShow then
        AddProductionLinePanel.rightDisableImg.localScale = Vector3.zero
        if LabScientificLineCtrl.static.type == 0 then
            if itemId >= 2200000 then
                self.chooseResearchItemId = itemId
            end
        else
            self.chooseInventItemId = itemId
        end
    else
        AddProductionLinePanel.rightDisableImg.localScale = Vector3.one
    end
end
--设置原料线的信息  根据个数显示位置
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

--[[
AddProductionLineCtrl = class('AddProductionLineCtrl',UIPage);
UIPage:ResgisterOpen(AddProductionLineCtrl)

--UI信息
AddProductionLineCtrl.productionItemTab = {};
--用来判断这个物体是否选中
AddProductionLineCtrl.temporaryIdTable = {}

function AddProductionLineCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AddProductionLineCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AddProductionLinePanel.prefab"
end

function AddProductionLineCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local addLine = self.gameObject:GetComponent('LuaBehaviour');

    self.luabehaviour = addLine
    self.m_data = {}
    self.m_data.buildingType = BuildingInType.ProductionLine;
    self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour,self.m_data);


    addLine:AddClick(AddProductionLinePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    addLine:AddClick(AddProductionLinePanel.determineBtn.gameObject,self.OnClick_determineBtn,self);


    --本地事件注册
    Event.AddListener("_selectedProductionLine",self._selectedProductionLine,self);


    AddProductionLinePanel.foodBtn.onValueChanged:AddListener(function()
        self:OnClick_foodBtn();
    end)

    AddProductionLinePanel.viceFoodBtn.onValueChanged:AddListener(function()
        self:OnClick_viceFoodBtn();
    end)

    AddProductionLinePanel.dressBtn.onValueChanged:AddListener(function()
        self:OnClick_dressBtn();
    end)

    AddProductionLinePanel.foodMaterBtn.onValueChanged:AddListener(function()
        self:OnClick_foodMaterBtn();
    end)

    AddProductionLinePanel.baseMaterBtn.onValueChanged:AddListener(function()
        self:OnClick_baseMaterBtn();
    end)

    AddProductionLinePanel.advancedMaterBtn.onValueChanged:AddListener(function()
        self:OnClick_advancedMaterBtn();
    end)

    AddProductionLinePanel.otherBtn.onValueChanged:AddListener(function()
        self:OnClick_otherBtn();
    end)
end

function AddProductionLineCtrl:Awake(go)
    self.gameObject = go;
end

function AddProductionLineCtrl:Refesh()

end

--选中生产的原料或商品
function AddProductionLineCtrl:_selectedProductionLine(id,itemId,name)
    if self.temporaryIdTable[id] == nil then
        self.temporaryIdTable[id] = id;
        self.itemId = itemId;
        self.name = name;
        self.GoodsUnifyMgr.productionItems[id].selectedImg.transform.localScale = Vector3.one
    else
        self.temporaryIdTable[id] = nil;
        self.GoodsUnifyMgr.productionItems[id].selectedImg.transform.localScale = Vector3.zero
    end
end

function AddProductionLineCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--确定
function AddProductionLineCtrl:OnClick_determineBtn(go)
    --if  then
    --
    --end
    go.GoodsUnifyMgr:_creatProductionLine(go.name,go.itemId);
    UIPage.ClosePage();
end

function AddProductionLineCtrl:OnClick_foodBtn()
    if AddProductionLinePanel.foodBtn.isOn == true then
        logWarn("foodBtn")
    end
end

function AddProductionLineCtrl:OnClick_viceFoodBtn()
    if AddProductionLinePanel.viceFoodBtn.isOn == true then
        logWarn("viceFoodBtn")
    end
end

function AddProductionLineCtrl:OnClick_dressBtn()
    if AddProductionLinePanel.dressBtn.isOn == true then
        logWarn("dressBtn")
    end
end

function AddProductionLineCtrl:OnClick_foodMaterBtn()
    if AddProductionLinePanel.foodMaterBtn.isOn == true then
        logWarn("foodMaterBtn")
    end
end

function AddProductionLineCtrl:OnClick_baseMaterBtn()
    if AddProductionLinePanel.baseMaterBtn.isOn == true then
        logWarn("baseMaterBtn")
    end
end

function AddProductionLineCtrl:OnClick_advancedMaterBtn()
    if AddProductionLinePanel.advancedMaterBtn.isOn == true then
        logWarn("advancedMaterBtn")
    end
end

function AddProductionLineCtrl:OnClick_otherBtn()
    if AddProductionLinePanel.otherBtn.isOn == true then
        logWarn("otherBtn")
    end
end]]
