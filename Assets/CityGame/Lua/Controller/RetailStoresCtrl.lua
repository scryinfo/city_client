RetailStoresCtrl = class('RetailStoresCtrl',UIPanel)
UIPanel:ResgisterOpen(RetailStoresCtrl) --注册打开的方法
local this
--构建函数
function RetailStoresCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailStoresCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RetailStoresPanel.prefab";
end

function RetailStoresCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function RetailStoresCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.retailShopBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.retailShopBehaviour:AddClick(RetailStoresPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    --self.retailShopBehaviour:AddClick(RetailStoresPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);

end
function RetailStoresCtrl:Active()
    UIPanel.Active(self)
    RetailStoresPanel.Text.text = GetLanguage(33010001)
end
function RetailStoresCtrl:Refresh()
    this:initializeData()
end

function RetailStoresCtrl:initializeData()
    if self.m_data.insId then
        self.insId=self.m_data.insId
        DataManager.OpenDetailModel(RetailStoresModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenRetailShop',self.m_data.insId)
    else
        self.m_data.insId=self.insId
        DataManager.OpenDetailModel(RetailStoresModel,self.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqOpenRetailShop',self.insId)
    end
    --if self.m_data then
    --    DataManager.OpenDetailModel(RetailStoresModel,self.m_data.insId)
    --    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenRetailShop',self.m_data.insId)
    --end
end

--刷新零售店信息
function RetailStoresCtrl:refreshRetailShopDataInfo(DataInfo)
    --local companyName = DataManager.GetMyPersonalHomepageInfo()
    RetailStoresPanel.nameText.text = DataInfo.info.name or "SRCY CITY"
    --RetailStoresPanel.buildingTypeNameText.text = PlayerBuildingBaseData[DataInfo.info.mId].sizeName..PlayerBuildingBaseData[DataInfo.info.mId].typeName
    RetailStoresPanel.buildingTypeNameText.text = GetLanguage(DataInfo.info.mId)

    local insId = self.m_data.insId
    self.m_data = DataInfo
    self.m_data.insId = insId

    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
        RetailStoresPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        RetailStoresPanel.changeNameBtn.localScale = Vector3.one
    end

    if self.m_data.info.state=="OPERATE" then
        RetailStoresPanel.stopIconRoot.localScale=Vector3.zero
    else
        RetailStoresPanel.stopIconRoot.localScale=Vector3.one
    end

    Event.Brocast("c_GetBuildingInfo",DataInfo.info)

    self.m_data.buildingType = BuildingType.RetailShop
    if not self.retailShopToggleGroup then
        self.retailShopToggleGroup = BuildingInfoToggleGroupMgr:new(RetailStoresPanel.leftRootTran, RetailStoresPanel.rightRootTran, self.retailShopBehaviour, self.m_data)
    else
        self.retailShopToggleGroup:updateInfo(self.m_data)
    end
end
function RetailStoresCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function RetailStoresCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end
--更改名字
function RetailStoresCtrl:OnClick_changeName(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = "RENAME";
    data.tipInfo = "Modified every seven days";
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    data.btnCallBack = function(name)
        DataManager.DetailModelRpcNoRet(ins.m_data.info.id, 'm_ReqChangeRetailName', ins.m_data.info.id, name)
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
--更改名字成功
function RetailStoresCtrl:_updateName(name)
    RetailStoresPanel.nameText.text = name
end
--返回
function RetailStoresCtrl:OnClick_backBtn(ins)
    PlayMusEff(1002)
    if ins.materialToggleGroup then
        ins.materialToggleGroup:cleanItems()
    end
    UIPanel.ClosePage()
end
--function RetailStoresCtrl:Hide()
--    UIPanel.Hide(self)
--    return {insId = self.m_data.info.id,self.m_data}
--end
--打开信息界面
function RetailStoresCtrl:OnClick_infoBtn()

end

UnitTest.TestBlockStart()---------------------------------------------------------

UnitTest.Exec("fisher_w8_RemoveClick", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w8_RemoveClick","[test_RemoveClick_self]  测试开始")
    Event.AddListener("c_MaterialModel_ShowPage", function (obj)
        --UIPanel:ShowPage(RetailStoresCtrl);
        ct.OpenCtrl("RetailStoresCtrl")
    end)
end)

UnitTest.Exec("fisher_w11_OpenRetailStoresCtrl", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w11_OpenRetailStoresCtrl","[test_RemoveClick_self]  测试开始")
    ct.OpenCtrl('RetailStoresCtrl',Vector2.New(0, -300)) --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------
