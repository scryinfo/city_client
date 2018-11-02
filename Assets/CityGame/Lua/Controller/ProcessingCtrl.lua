ProcessingCtrl = class('ProcessingCtrl',UIPage)
UIPage:ResgisterOpen(ProcessingCtrl) --注册打开的方法

--构建函数
function ProcessingCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ProcessingCtrl:bundleName()
    return "Processing";
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
    --关闭原料厂的监听
    --Event.RemoveListener("c_temporaryifNotGoods",WarehouseCtrl.c_temporaryifNotGoods)
end

--打开信息界面
function ProcessingCtrl:OnClick_infoBtn()

end
function ProcessingCtrl:Refresh()

end

UnitTest.Exec("fisher_w8_RemoveClick", "test_MaterialModel_ShowPage",  function ()
    log("fisher_w8_RemoveClick","[test_RemoveClick_self]  测试开始")
    Event.AddListener("c_MaterialModel_ShowPage", function (obj)
        UIPage:ShowPage(ProcessingCtrl);
    end)
end)