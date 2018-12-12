---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/23/023 11:29
---

require "Common/define"
require "View/BuildingInfo/BuildingInfoToggleGroupMgr";
require('Framework/UI/UIPage')

require "View/BuildingInfo/ItemCreatDeleteMgr"

local class = require 'Framework/class'
MunicipalCtrl = class('MunicipalCtrl',UIPage)
UIPage:ResgisterOpen(MunicipalCtrl) --注册打开的方法


--构建函数
function MunicipalCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
    self.prefab = nil
end

function MunicipalCtrl:bundleName()
    return "MunicipalPanel";
end

function MunicipalCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function MunicipalCtrl:Awake(go)
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self. materialBehaviour:AddClick(MunicipalPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.  materialBehaviour:AddClick(MunicipalPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
   self. materialBehaviour:AddClick(MunicipalPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);

    self.data = {}
    self.data.middleRootTran=MunicipalPanel.middleRootTran
    self.data.buildingType = BuildingType.Municipal
    BuildingInfoToggleGroupMgr:new(MunicipalPanel.leftRootTran, MunicipalPanel.rightRootTran, self.materialBehaviour, self.data)

    MunicipalPanel.scrollCon=go.transform:Find("rightRoot/Advertisement/contentRoot/Scroll View/Viewport/Content")

    -----创建外部广告
    local creatData={count=1,buildingType=BuildingType.ProcessingFactory,lMsg=MunicipalModel.lMsg}
    self.ItemCreatDeleteMgr=MunicipalModel.manger
    self.ItemCreatDeleteMgr:creat(ServerListCtrl.serverListBehaviour,creatData)

end

--更改名字
function MunicipalCtrl:OnClick_changeName()
local data = {}
data.titleInfo = "RENAME";
data.tipInfo = "Modified every seven days";
data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
UIPage:ShowPage(InputDialogPageCtrl, data)
end

--返回
function MunicipalCtrl:OnClick_backBtn()
    UIPage.ClosePage();
end

--打开信息界面
function MunicipalCtrl:OnClick_infoBtn()

end

function MunicipalCtrl:Refresh()
    local t=self
    Event.Brocast("c_TicketValueChange")
end



