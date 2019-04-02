MaterialCtrl = class('MaterialCtrl',UIPanel)
UIPanel:ResgisterOpen(MaterialCtrl) --注册打开的方法

local this
--构建函数
function MaterialCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function MaterialCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MaterialPanel.prefab";
end

function MaterialCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function MaterialCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    --self.materialBehaviour:AddClick(MaterialPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    --self.materialBehaviour:AddClick(MaterialPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    --self.materialBehaviour:AddClick(MaterialPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.materialBehaviour:AddClick(MaterialPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.materialBehaviour:AddClick(MaterialPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);

end
function MaterialCtrl:Active()
    UIPanel.Active(self)
    MaterialPanel.Text.text = GetLanguage(25010001)
    Event.AddListener("c_BuildingTopChangeData",self._changeItemData,self)
end
function MaterialCtrl:Refresh()
    this:initializeData()
end

function MaterialCtrl:initializeData()
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
function MaterialCtrl:refreshMaterialDataInfo(DataInfo)
    --MaterialPanel.nameText.text = DataInfo.info.name or "SRCY CITY"
    --MaterialPanel.buildingTypeNameText.text = GetLanguage(DataInfo.info.mId)
    local insId = self.m_data.insId
    self.m_data = DataInfo
    self.m_data.insId = insId
    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
        --MaterialPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        --MaterialPanel.changeNameBtn.localScale = Vector3.one
    end

    if self.m_data.info.state=="OPERATE" then
        MaterialPanel.stopIconRoot.localScale=Vector3.zero
    else
        MaterialPanel.stopIconRoot.localScale=Vector3.one
    end

    Event.Brocast("c_GetBuildingInfo",DataInfo.info)

    if MaterialPanel.topItem ~= nil then
        MaterialPanel.topItem:refreshData(DataInfo.info,function()
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
        self.materialToggleGroup = BuildingInfoToggleGroupMgr:new(MaterialPanel.leftRootTran, MaterialPanel.rightRootTran, self.materialBehaviour, self.m_data)
    else
        self.materialToggleGroup:updateInfo(self.m_data)
    end
end

function MaterialCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function MaterialCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end
--更改名字
function MaterialCtrl:OnClick_changeName(ins)
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
function MaterialCtrl:_updateName(name)
    MaterialPanel.nameText.text = name
end
----返回
--function MaterialCtrl:OnClick_backBtn(ins)
--    PlayMusEff(1002)
--    Event.Brocast("m_ReqCloseMaterial",ins.m_data.insId)
--    if ins.materialToggleGroup then
--        ins.materialToggleGroup:cleanItems()
--    end
--    UIPanel.ClosePage()
--end
function MaterialCtrl:Hide()
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
function MaterialCtrl:_changeItemData(data)
    if data ~= nil and MaterialPanel.topItem ~= nil then
        MaterialPanel.topItem:changeItemData(data)
    end
end
--清空生产线
function MaterialCtrl:deleteProductionObj()
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
function MaterialCtrl:deleteShelfObj()
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
function MaterialCtrl:deleteOtherShelf()
    if next(HomeOtherPlayerShelfItem.SmallShelfRateItemTab) == nil then
        return
    end
    for key,value in pairs(HomeOtherPlayerShelfItem.SmallShelfRateItemTab) do
        destroy(value.prefab.gameObject)
        HomeOtherPlayerShelfItem.SmallShelfRateItemTab[key] = nil
    end
end
--打开信息界面
function MaterialCtrl:OnClick_infoBtn()
end
UnitTest.TestBlockStart()---------------------------------------------------------
UnitTest.Exec("fisher_w8_RemoveClick", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w8_RemoveClick","[test_RemoveClick_self]  测试开始")
    Event.AddListener("c_MaterialModel_ShowPage", function (obj)
        --UIPanel:ShowPage(MaterialCtrl);
        ct.OpenCtrl("MaterialCtrl")
    end)
end)

UnitTest.Exec("fisher_w11_OpenMaterialCtrl", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w11_OpenMaterialCtrl","[test_RemoveClick_self]  测试开始")
    ct.OpenCtrl('MaterialCtrl',Vector2.New(0, -300)) --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------
