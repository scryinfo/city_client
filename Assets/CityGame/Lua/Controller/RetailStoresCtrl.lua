RetailStoresCtrl = class('MaterialCtrl',UIPage)
UIPage:ResgisterOpen(RetailStoresCtrl) --注册打开的方法

--构建函数
function RetailStoresCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailStoresCtrl:bundleName()
    return "RetailStoresPanel";
end

function RetailStoresCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function RetailStoresCtrl:Awake(go)
    self.gameObject = go;
    self.retailBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.retailBehaviour:AddClick(RetailStoresPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.retailBehaviour:AddClick(RetailStoresPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    self.retailBehaviour:AddClick(RetailStoresPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);

end

function RetailStoresCtrl:Refresh()

end

function RetailStoresCtrl:initializeData()

end

--刷新原料厂信息
function RetailStoresCtrl:refreshMaterialDataInfo(DataInfo)

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
