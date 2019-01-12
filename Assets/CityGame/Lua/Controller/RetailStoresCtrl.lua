RetailStoresCtrl = class('RetailStoresCtrl',UIPage)
UIPage:ResgisterOpen(RetailStoresCtrl) --注册打开的方法
local this
--构建函数
function RetailStoresCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailStoresCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RetailStoresPanel.prefab";
end

function RetailStoresCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function RetailStoresCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.retailShopBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.retailShopBehaviour:AddClick(RetailStoresPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.retailShopBehaviour:AddClick(RetailStoresPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);

end

function RetailStoresCtrl:Refresh()
    this:initializeData()
end

function RetailStoresCtrl:initializeData()
    if self.m_data.insId then
        DataManager.OpenDetailModel(RetailStoresModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenRetailShop',self.m_data.insId)
    else
        DataManager.OpenDetailModel(RetailStoresModel,self.m_data.info.id)
        DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqOpenRetailShop',self.m_data.info.id)
    end
end

--刷新零售店信息
function RetailStoresCtrl:refreshRetailShopDataInfo(DataInfo)
    local companyName = DataManager.GetMyPersonalHomepageInfo()
    RetailStoresPanel.nameText.text = companyName.companyName
    RetailStoresPanel.buildingTypeNameText.text = PlayerBuildingBaseData[DataInfo.info.mId].sizeName..PlayerBuildingBaseData[DataInfo.info.mId].typeName

    self.m_data = DataInfo
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

    self.m_data.buildingType = BuildingType.RetailShop
    if not self.retailShopToggleGroup then
        self.retailShopToggleGroup = BuildingInfoToggleGroupMgr:new(RetailStoresPanel.leftRootTran, RetailStoresPanel.rightRootTran, self.retailShopBehaviour, self.m_data)
    else
        --self.retailShopToggleGroup:updataInfo(self.m_data)
    end
end
function RetailStoresCtrl:OnClick_buildInfo(ins)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function RetailStoresCtrl:OnClick_prepareOpen(ins)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
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
        --UIPage:ShowPage(RetailStoresCtrl);
        ct.OpenCtrl("RetailStoresCtrl")
    end)
end)

UnitTest.Exec("fisher_w11_OpenRetailStoresCtrl", "test_MaterialModel_ShowPage",  function ()
    ct.log("fisher_w11_OpenRetailStoresCtrl","[test_RemoveClick_self]  测试开始")
    ct.OpenCtrl('RetailStoresCtrl',Vector2.New(0, -300)) --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------
