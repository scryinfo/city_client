MaterialFactoryCtrl = class('MaterialFactoryCtrl',UIPanel)
UIPanel:ResgisterOpen(MaterialFactoryCtrl) --注册打开的方法

local this
--构建函数
function MaterialFactoryCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function MaterialFactoryCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MaterialFactoryPanel.prefab";
end

function MaterialFactoryCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function MaterialFactoryCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    --self.materialBehaviour:AddClick(MaterialFactoryPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    --self.materialBehaviour:AddClick(MaterialFactoryPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    --self.materialBehaviour:AddClick(MaterialFactoryPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.materialBehaviour:AddClick(MaterialFactoryPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.materialBehaviour:AddClick(MaterialFactoryPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);

end
function MaterialFactoryCtrl:Active()
    UIPanel.Active(self)
    MaterialFactoryPanel.Text.text = GetLanguage(25010001)
    Event.AddListener("c_BuildingTopChangeData",self._changeItemData,self)
end
function MaterialFactoryCtrl:Refresh()
    this:initializeData()
end

function MaterialFactoryCtrl:initializeData()
    if self.m_data.insId then
        self.insId=self.m_data.insId
        DataManager.OpenDetailModel(MaterialModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenMaterial',self.m_data.insId)
    else
        self.m_data.insId=self.insId
        DataManager.OpenDetailModel(MaterialModel,self.insId)
        DataManager.DetailModelRpcNoRet(self.insId, 'm_ReqOpenMaterial',self.insId)
    end
end

--刷新原料厂信息
function MaterialFactoryCtrl:refreshMaterialDataInfo(DataInfo)
    --MaterialFactoryPanel.nameText.text = DataInfo.info.name or "SRCY CITY"
    --MaterialFactoryPanel.buildingTypeNameText.text = GetLanguage(DataInfo.info.mId)
    local insId = self.m_data.insId
    self.m_data = DataInfo
    self.m_data.insId = insId
    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
        --MaterialFactoryPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        --MaterialFactoryPanel.changeNameBtn.localScale = Vector3.one
    end

    if self.m_data.info.state=="OPERATE" then
        MaterialFactoryPanel.stopIconRoot.localScale=Vector3.zero
    else
        MaterialFactoryPanel.stopIconRoot.localScale=Vector3.one
    end

    Event.Brocast("c_GetBuildingInfo",DataInfo.info)

    if MaterialFactoryPanel.topItem ~= nil then
        MaterialFactoryPanel.topItem:refreshData(DataInfo.info,function()
            PlayMusEff(1002)
            Event.Brocast("m_ReqCloseMaterial",self.m_data.insId)
            if self.materialToggleGroup then
                self.materialToggleGroup:cleanItems()
            end
            UIPanel.ClosePage()
            DataManager.CloseDetailModel(self.m_data.insId)
        end)
    end
    self.m_data.buildingType = BuildingType.MaterialFactory
    if not self.materialToggleGroup then
        self.materialToggleGroup = BuildingInfoToggleGroupMgr:new(MaterialFactoryPanel.leftRootTran, MaterialFactoryPanel.rightRootTran, self.materialBehaviour, self.m_data)
    else
        self.materialToggleGroup:updateInfo(self.m_data)
    end
end

function MaterialFactoryCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function MaterialFactoryCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end
--更改名字
function MaterialFactoryCtrl:OnClick_changeName(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = "RENAME"
    data.tipInfo = "Modified every seven days"
    data.btnCallBack = function(name)
        DataManager.DetailModelRpcNoRet(ins.m_data.info.id, 'm_ReqChangeMaterialName', ins.m_data.info.id, name)
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
--更改名字成功
function MaterialFactoryCtrl:_updateName(name)
    MaterialFactoryPanel.nameText.text = name
end
----返回
--function MaterialFactoryCtrl:OnClick_backBtn(ins)
--    PlayMusEff(1002)
--    Event.Brocast("m_ReqCloseMaterial",ins.m_data.insId)
--    if ins.materialToggleGroup then
--        ins.materialToggleGroup:cleanItems()
--    end
--    UIPanel.ClosePage()
--end
function MaterialFactoryCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_BuildingTopChangeData",self._changeItemData,self)
    if self.m_data.isOther == true then
        self:deleteOtherShelf()
    else
        self:deleteProductionObj()
        self:deleteShelfObj()
    end
end
--更改基础建筑信息
function MaterialFactoryCtrl:_changeItemData(data)
    if data ~= nil and MaterialFactoryPanel.topItem ~= nil then
        MaterialFactoryPanel.topItem:changeItemData(data)
    end
end
--清空生产线
function MaterialFactoryCtrl:deleteProductionObj()
    if next(HomeProductionLineItem.lineItemTable) == nil then
        return
    else
        for key,value in pairs(HomeProductionLineItem.lineItemTable) do
            value:closeEvent()
            destroy(value.prefab.gameObject);
            HomeProductionLineItem.lineItemTable[key] = nil
        end
    end
end
--清空货架
function MaterialFactoryCtrl:deleteShelfObj()
    if next(ShelfRateItem.SmallShelfRateItemTab) == nil then
        return
    else
        for key,value in pairs(ShelfRateItem.SmallShelfRateItemTab) do
            destroy(value.prefab.gameObject)
            ShelfRateItem.SmallShelfRateItemTab[key] = nil
        end
    end
end
--清空货架（其他玩家）
function MaterialFactoryCtrl:deleteOtherShelf()
    if next(HomeOtherPlayerShelfItem.SmallShelfRateItemTab) == nil then
        return
    end
    for key,value in pairs(HomeOtherPlayerShelfItem.SmallShelfRateItemTab) do
        destroy(value.prefab.gameObject)
        HomeOtherPlayerShelfItem.SmallShelfRateItemTab[key] = nil
    end
end
--打开信息界面
function MaterialFactoryCtrl:OnClick_infoBtn()
end
UnitTest.TestBlockStart()---------------------------------------------------------
UnitTest.Exec("fisher_w8_RemoveClick", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w8_RemoveClick","[test_RemoveClick_self]  测试开始")
    Event.AddListener("c_MaterialModel_ShowPage", function (obj)
        --UIPanel:ShowPage(MaterialFactoryCtrl);
        ct.OpenCtrl("MaterialFactoryCtrl")
    end)
end)

UnitTest.Exec("fisher_w11_OpenMaterialFactoryCtrl", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w11_OpenMaterialFactoryCtrl","[test_RemoveClick_self]  测试开始")
    ct.OpenCtrl('MaterialFactoryCtrl',Vector2.New(0, -300)) --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------
