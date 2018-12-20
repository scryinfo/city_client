RetailStoresCtrl = class('MaterialCtrl',UIPage)
UIPage:ResgisterOpen(RetailStoresCtrl) --注册打开的方法

--构建函数
function RetailStoresCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailStoresCtrl:bundleName()
    return "MaterialPanel";
end

function RetailStoresCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function RetailStoresCtrl:Awake(go)
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.materialBehaviour:AddClick(RetailStoresPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.materialBehaviour:AddClick(RetailStoresPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    self.materialBehaviour:AddClick(RetailStoresPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);

end

function RetailStoresCtrl:Refresh()
    self:initializeData()
end

function RetailStoresCtrl:initializeData()
    if self.m_data then
        DataManager.OpenDetailModel(MaterialModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenMaterial',self.m_data.insId)
    end
end

--刷新原料厂信息
function RetailStoresCtrl:refreshMaterialDataInfo(DataInfo)
    RetailStoresPanel.nameText.text = PlayerBuildingBaseData[DataInfo.info.mId].sizeName..PlayerBuildingBaseData[DataInfo.info.mId].typeName

    self.m_data = DataInfo
    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
        RetailStoresPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        RetailStoresPanel.changeNameBtn.localScale = Vector3.one
    end
    self.m_data.buildingType = BuildingType.MaterialFactory
    if not self.materialToggleGroup then
        self.materialToggleGroup = BuildingInfoToggleGroupMgr:new(RetailStoresPanel.leftRootTran, RetailStoresPanel.rightRootTran, self.materialBehaviour, self.m_data)
    else
        --self.materialToggleGroup:updataInfo(self.m_data)
    end
end

--更改名字
function RetailStoresCtrl:OnClick_changeName()
    local data = {}
    data.titleInfo = "RENAME";
    data.tipInfo = "Modified every seven days";
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    UIPage:ShowPage(InputDialogPageCtrl, data)
end

--返回
function RetailStoresCtrl:OnClick_backBtn(ins)
    if ins.materialToggleGroup then
        ins.materialToggleGroup:cleanItems()
    end
    UIPage.ClosePage();
end

--打开信息界面
function RetailStoresCtrl:OnClick_infoBtn()

end

UnitTest.TestBlockStart()---------------------------------------------------------

UnitTest.Exec("fisher_w8_RemoveClick", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w8_RemoveClick","[test_RemoveClick_self]  测试开始")
    Event.AddListener("c_MaterialModel_ShowPage", function (obj)
        --UIPage:ShowPage(MaterialCtrl);
        ct.OpenCtrl("MaterialCtrl")
    end)
end)

UnitTest.Exec("fisher_w11_OpenMaterialCtrl", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w11_OpenMaterialCtrl","[test_RemoveClick_self]  测试开始")
    ct.OpenCtrl('MaterialCtrl',Vector2.New(0, -300)) --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------
