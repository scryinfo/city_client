--require "Common/define"
require "Common/MaterialTab";
require "View/BuildingInfo/BuildingInfoToggleGroupMgr";
require('Framework/UI/UIPage')

local class = require 'Framework/class'
MaterialCtrl = class('MaterialCtrl',UIPage)

--构建函数
function MaterialCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function MaterialCtrl:bundleName()
    return "Material";
end

function MaterialCtrl:Awake(go)
    self.gameObject = go;
end

--启动事件
function MaterialCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local ctrl = obj:GetComponent('LuaBehaviour');
    self.materialData = {}
    self.materialData.buildingType = BuildingType.MaterialFactory;
    local materialToggleGroup = BuildingInfoToggleGroupMgr:new(MaterialPanel.leftRootTran,MaterialPanel.rightRootTran,ctrl,self.materialData);
end

UnitTest.Exec("fisher_w8_RemoveClick", "test_MaterialModel_ShowPage",  function ()
    log("fisher_w8_RemoveClick","[test_RemoveClick_self]  测试开始")
    Event.AddListener("c_MaterialModel_ShowPage", function (obj)
        UIPage:ShowPage(MaterialCtrl);
    end)
end)