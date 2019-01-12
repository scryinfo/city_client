MaterialCtrl = class('MaterialCtrl',UIPage)
UIPage:ResgisterOpen(MaterialCtrl) --注册打开的方法

local this
--构建函数
function MaterialCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function MaterialCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MaterialPanel.prefab";
end

function MaterialCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function MaterialCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.materialBehaviour:AddClick(MaterialPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.materialBehaviour:AddClick(MaterialPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    self.materialBehaviour:AddClick(MaterialPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.materialBehaviour:AddClick(MaterialPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.materialBehaviour:AddClick(MaterialPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);

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
    local companyName = DataManager.GetMyPersonalHomepageInfo()
    MaterialPanel.nameText.text = companyName.companyName
    MaterialPanel.buildingTypeNameText.text = PlayerBuildingBaseData[DataInfo.info.mId].sizeName..PlayerBuildingBaseData[DataInfo.info.mId].typeName

    self.m_data = DataInfo
    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
        MaterialPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        MaterialPanel.changeNameBtn.localScale = Vector3.one
    end

    if self.m_data.info.state=="OPERATE" then
        MaterialPanel.stopIconRoot.localScale=Vector3.zero
    else
        MaterialPanel.stopIconRoot.localScale=Vector3.one
    end

    Event.Brocast("c_GetBuildingInfo",DataInfo.info)

    self.m_data.buildingType = BuildingType.MaterialFactory
    if not self.materialToggleGroup then
        self.materialToggleGroup = BuildingInfoToggleGroupMgr:new(MaterialPanel.leftRootTran, MaterialPanel.rightRootTran, self.materialBehaviour, self.m_data)
    else
        self.materialToggleGroup:updateInfo(self.m_data)
    end
end

function MaterialCtrl:OnClick_buildInfo(ins)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function MaterialCtrl:OnClick_prepareOpen(ins)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end
--更改名字
function MaterialCtrl:OnClick_changeName()
    local data = {}
    data.titleInfo = "RENAME";
    data.tipInfo = "Modified every seven days";
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    UIPage:ShowPage(InputDialogPageCtrl, data)
end

--返回
function MaterialCtrl:OnClick_backBtn(ins)
    if ins.materialToggleGroup then
        ins.materialToggleGroup:cleanItems()
    end
    UIPage.ClosePage();
end

--打开信息界面
function MaterialCtrl:OnClick_infoBtn()

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
