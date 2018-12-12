MaterialCtrl = class('MaterialCtrl',UIPage)
UIPage:ResgisterOpen(MaterialCtrl) --注册打开的方法

--构建函数
function MaterialCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function MaterialCtrl:bundleName()
    return "MaterialPanel";
end

function MaterialCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function MaterialCtrl:Awake(go)

    self.gameObject = go;
    local materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviour:AddClick(MaterialPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(MaterialPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    materialBehaviour:AddClick(MaterialPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);

    self.data = {}
    self.data.buildingType = BuildingType.MaterialFactory
    local materialToggleGroup = BuildingInfoToggleGroupMgr:new(MaterialPanel.leftRootTran, MaterialPanel.rightRootTran, materialBehaviour, self.data)
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
function MaterialCtrl:OnClick_backBtn()
    UIPage.ClosePage();
    --关闭原料厂的监听
    --Event.RemoveListener("c_temporaryifNotGoods",WarehouseCtrl.c_temporaryifNotGoods)
end

--打开信息界面
function MaterialCtrl:OnClick_infoBtn()

end
function MaterialCtrl:Refresh()

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
