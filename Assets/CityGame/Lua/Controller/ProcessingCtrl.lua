ProcessingCtrl = class('ProcessingCtrl',UIPanel)
UIPanel:ResgisterOpen(ProcessingCtrl) --注册打开的方法
local this
--构建函数
function ProcessingCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ProcessingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ProcessingPanel.prefab";
end

function ProcessingCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function ProcessingCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.processingBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.processingBehaviour:AddClick(ProcessingPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    --self.processingBehaviour:AddClick(ProcessingPanel.headImgBtn.gameObject,self.OnClick_infoBtn,self);
    self.processingBehaviour:AddClick(ProcessingPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.processingBehaviour:AddClick(ProcessingPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    self.processingBehaviour:AddClick(ProcessingPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);
end
function ProcessingCtrl:Active()
    UIPanel.Active(self)
    ProcessingPanel.Text.text = GetLanguage(29010001)
end
function ProcessingCtrl:Refresh()
    this:initializeData()
end

function ProcessingCtrl:initializeData()
    if self.m_data.insId then
        self.insId=self.m_data.insId
        DataManager.OpenDetailModel(ProcessingModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenProcessing',self.m_data.insId)
    else
        self.m_data.insId=self.insId
        DataManager.OpenDetailModel(ProcessingModel,self.m_data.info.id)
        DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqOpenProcessing',self.m_data.info.id)
    end
end
--刷新加工厂信息
function ProcessingCtrl:refreshProcessingDataInfo(DataInfo)
    ProcessingPanel.nameText.text = DataInfo.info.name or "SRCY CITY"
    ProcessingPanel.buildingTypeNameText.text = GetLanguage(DataInfo.info.mId)
    local insId = self.m_data.insId
    self.m_data = DataInfo
    self.m_data.insId = insId

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

    Event.Brocast("c_GetBuildingInfo",DataInfo.info)

    self.m_data.buildingType = BuildingType.ProcessingFactory
    if not self.processingToggleGroup then
        self.processingToggleGroup = BuildingInfoToggleGroupMgr:new(ProcessingPanel.leftRootTran, ProcessingPanel.rightRootTran, self.processingBehaviour, self.m_data)
    else
        self.processingToggleGroup:updateInfo(self.m_data)
    end
end
function ProcessingCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function ProcessingCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end

--更改名字
function ProcessingCtrl:OnClick_changeName(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = "RENAME";
    data.tipInfo = "Modified every seven days";
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    data.btnCallBack = function(name)
        DataManager.DetailModelRpcNoRet(ins.m_data.info.id, 'm_ReqChangeProcessingName', ins.m_data.info.id, name)
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
--更改名字成功
function ProcessingCtrl:_updateName(name)
    ProcessingPanel.nameText.text = name
end
--返回
function ProcessingCtrl:OnClick_backBtn(ins)
    PlayMusEff(1002)
    if ins.processingToggleGroup then
        ins.processingToggleGroup:cleanItems()
    end
    Event.Brocast("mReqCloseProcessing",ins.m_data.insId)
    UIPanel.ClosePage()
end
function ProcessingCtrl:Hide()
    UIPanel.Hide(self)
    if self.m_data.isOther == true then
        self:deleteOtherShelf()
    else
        self:deleteProductionObj()
        self:deleteShelfObj()
    end
end
--清空生产线
function ProcessingCtrl:deleteProductionObj()
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
function ProcessingCtrl:deleteShelfObj()
    if next(ShelfRateItem.SmallShelfRateItemTab) == nil then
        return
    else
        for key,value in pairs(ShelfRateItem.SmallShelfRateItemTab) do
            destroy(value.prefab.gameObject)
            ShelfRateItem.SmallShelfRateItemTab[key] = nil
        end
    end
end
--清空货架（其他玩家看到的）
function ProcessingCtrl:deleteOtherShelf()
    if next(HomeOtherPlayerShelfItem.SmallShelfRateItemTab) == nil then
        return
    end
    for key,value in pairs(HomeOtherPlayerShelfItem.SmallShelfRateItemTab) do
        destroy(value.prefab.gameObject)
        HomeOtherPlayerShelfItem.SmallShelfRateItemTab[key] = nil
    end
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