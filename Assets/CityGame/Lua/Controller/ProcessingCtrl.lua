ProcessingCtrl = class('ProcessingCtrl',UIPage)
UIPage:ResgisterOpen(ProcessingCtrl) --注册打开的方法
local this
--构建函数
function ProcessingCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ProcessingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ProcessingPanel.prefab";
end

function ProcessingCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function ProcessingCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.processingBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.processingBehaviour:AddClick(ProcessingPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.processingBehaviour:AddClick(ProcessingPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    self.processingBehaviour:AddClick(ProcessingPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.processingBehaviour:AddClick(ProcessingPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.processingBehaviour:AddClick(ProcessingPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);
end
function ProcessingCtrl:Refresh()
    this:initializeData()
end

function ProcessingCtrl:initializeData()
    if self.m_data.insId then
        DataManager.OpenDetailModel(ProcessingModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenProcessing',self.m_data.insId)
    else
        DataManager.OpenDetailModel(ProcessingModel,self.m_data.info.id)
        DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqOpenProcessing',self.m_data.info.id)
    end
end
--刷新加工厂信息
function ProcessingCtrl:refreshProcessingDataInfo(DataInfo)
    ProcessingPanel.nameText.text = PlayerBuildingBaseData[DataInfo.info.mId].sizeName..PlayerBuildingBaseData[DataInfo.info.mId].typeName
    self.m_data = DataInfo
    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
        ProcessingPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        ProcessingPanel.changeNameBtn.localScale = Vector3.one
    end

    if self.m_data.info.state=="OPERATE" then
        ProcessingPanel.stopIconRoot.localScale=Vector3.zero
    else
        ProcessingPanel.stopIconRoot.localScale=Vector3.one
    end

    self.m_data.buildingType = BuildingType.ProcessingFactory
    if not self.processingToggleGroup then
        self.processingToggleGroup = BuildingInfoToggleGroupMgr:new(ProcessingPanel.leftRootTran, ProcessingPanel.rightRootTran, self.processingBehaviour, self.m_data)
    else
        --self.processingToggleGroup:updateInfo(self.m_data)
    end
end
function ProcessingCtrl:OnClick_buildInfo(ins)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function ProcessingCtrl:OnClick_prepareOpen(ins)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end

--更改名字
function ProcessingCtrl:OnClick_changeName()
    local data = {}
    data.titleInfo = "RENAME";
    data.tipInfo = "Modified every seven days";
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    UIPage:ShowPage(InputDialogPageCtrl, data)
end

--返回
function ProcessingCtrl:OnClick_backBtn(ins)
    if ins.processingToggleGroup then
        ins.processingToggleGroup:cleanItems()
    end
    UIPage.ClosePage();
end

--打开信息界面
function ProcessingCtrl:OnClick_infoBtn()

end
UnitTest.TestBlockStart()---------------------------------------------------------

UnitTest.Exec("fisher_w11_ProcessingCtrl", "test_ProcessingCtrl_ShowPage",  function ()
    ct.log("fisher_w11_ProcessingCtrl","[test_ProcessingCtrl_ShowPage]  测试开始")
    ct.OpenCtrl('ProcessingCtrl') --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------