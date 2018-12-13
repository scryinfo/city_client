ProcessingCtrl = class('ProcessingCtrl',UIPage)
UIPage:ResgisterOpen(ProcessingCtrl) --注册打开的方法

--构建函数
function ProcessingCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ProcessingCtrl:bundleName()
    return "ProcessingPanel";
end

function ProcessingCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function ProcessingCtrl:Awake(go)
    self.gameObject = go;
    local processingBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    processingBehaviour:AddClick(ProcessingPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    processingBehaviour:AddClick(ProcessingPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    processingBehaviour:AddClick(ProcessingPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);

    self.m_data = {}
    self.m_data.buildingType = BuildingType.ProcessingFactory
    local processingToggleGroup = BuildingInfoToggleGroupMgr:new(ProcessingPanel.leftRootTran, ProcessingPanel.rightRootTran, processingBehaviour, self.m_data)

    Event.AddListener("refreshProcessingDataInfo",self.refreshProcessingDataInfo,self)
    --暂时
    Event.Brocast("refreshProcessingDataInfo",ProcessingModel.dataDetailsInfo)
end
function ProcessingCtrl:Refresh()
    --if self.m_data then
    --    Event.Brocast('m_ReqOpenProcessing',self.m_data)
    --end
end
--刷新加工厂信息
function ProcessingCtrl:refreshProcessingDataInfo(DataInfo)
    ProcessingPanel.nameText.text = PlayerBuildingBaseData[DataInfo.info.mId].sizeName..PlayerBuildingBaseData[DataInfo.info.mId].typeName
    if DataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.isShow = true
        ProcessingPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.isShow = false
        ProcessingPanel.changeNameBtn.localScale = Vector3.one
    end
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
function ProcessingCtrl:OnClick_backBtn()
    UIPage.ClosePage();
    --关闭加工厂的监听
    --Event.RemoveListener("c_temporaryifNotGoods",WarehouseCtrl.c_temporaryifNotGoods)
end

--打开信息界面
function ProcessingCtrl:OnClick_infoBtn()

end
function ProcessingCtrl:Refresh()

end
UnitTest.TestBlockStart()---------------------------------------------------------

UnitTest.Exec("fisher_w11_ProcessingCtrl", "test_ProcessingCtrl_ShowPage",  function ()
    ct.log("fisher_w11_ProcessingCtrl","[test_ProcessingCtrl_ShowPage]  测试开始")
    ct.OpenCtrl('ProcessingCtrl') --注意传入的是类名
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------