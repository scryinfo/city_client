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
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end

function MunicipalCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MunicipalPanel.prefab";
end

local BuildMgr
local this
function MunicipalCtrl:Awake(go)
    this=self
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.materialBehaviour:AddClick(MunicipalPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    --self.materialBehaviour:AddClick(MunicipalPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    self.materialBehaviour:AddClick(MunicipalPanel.changeNameBtn.gameObject,self.OnClick_changeName,self);
    self.materialBehaviour:AddClick(MunicipalPanel.buildInfoBtn.gameObject,self.OnClick_buildInfo,self);
    self.materialBehaviour:AddClick(MunicipalPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);
        local data={}
        data.middleRootTran=MunicipalPanel.middleRootTran
        data.buildingType = BuildingType.Municipal
    BuildMgr=BuildingInfoToggleGroupMgr:new(MunicipalPanel.leftRootTran, MunicipalPanel.rightRootTran, self.materialBehaviour, data)
    MunicipalPanel.scrollCon=go.transform:Find("rightRoot/Advertisement/contentRoot/Scroll View/Viewport/Content")



end

function MunicipalCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end

function MunicipalCtrl:OnClick_buildInfo()

    Event.Brocast("c_openBuildingInfo",MunicipalPanel.lMsg.info)
end

function MunicipalCtrl:OnClick_prepareOpen(ins)

    Event.Brocast("c_beginBuildingInfo",MunicipalPanel.lMsg.info,ins.Refresh)
end

--更改名字
function MunicipalCtrl:OnClick_changeName(ins)
    local data = {}
    data.titleInfo = "RENAME"
    data.tipInfo = "Modified every seven days"
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    data.btnCallBack = function(name)
        ---临时代码，直接改变名字
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
---更改名字成功
function MunicipalCtrl:_updateName(name)
    MunicipalPanel.nameText.text = name
end
--返回
function MunicipalCtrl:OnClick_backBtn()
    UIPage.ClosePage();

    if DataManager.GetMyOwnerID()==DataManager.GetDetailModelByID(MunicipalPanel.buildingId).buildingOwnerId then
        DataManager.DetailModelRpcNoRet(MunicipalPanel.buildingId, 'm_detailPublicFacility',MunicipalPanel.buildingId)
    end

end



function MunicipalCtrl:Refresh()
    this:changeData()
end


function MunicipalCtrl:changeData()
    if self.m_data then
        DataManager.OpenDetailModel(MunicipalModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_detailPublicFacility',self.m_data.insId)
    else
        DataManager.OpenDetailModel(MunicipalModel,MunicipalPanel.buildingId)
        DataManager.DetailModelRpcNoRet(MunicipalPanel.buildingId, 'm_detailPublicFacility',MunicipalPanel.buildingId)
    end
end

function MunicipalCtrl:c_receiveParkData(parkData)

    local model =DataManager.GetDetailModelByID(parkData.info.id)
    local lMsg=parkData
    MunicipalPanel.lMsg=lMsg

    Event.Brocast("c_GetBuildingInfo",MunicipalPanel.lMsg.info)

    if lMsg.info.state=="OPERATE" then
        MunicipalPanel.stopIconRoot.localScale=Vector3.zero
    else
        MunicipalPanel.stopIconRoot.localScale=Vector3.one
    end

    ---是否可以改名
    if DataManager.GetMyOwnerID()~=model.buildingOwnerId then--他人
    MunicipalPanel.changeNameBtn.localScale=Vector3.zero
    else--自已
    MunicipalPanel.changeNameBtn.localScale=Vector3.one
    end
    ---效验
    if MunicipalPanel.buildingId~=self.currentBuildingId then
    ---清空数据
    if self.pastManger then
    self:ClearData(self.pastManger)
    end
        ---创建外部广告
        local creatData={model=model,buildingType=BuildingType.ProcessingFactory,lMsg=lMsg}
        model.manger:creat(ServerListCtrl.serverListBehaviour,creatData)
        ---标记管理器
        self.pastManger=model.manger
    end
    ---标记buildingId
    self.currentBuildingId=parkData.info.id
    --跟新左右
    lMsg.buildingType=BuildingType.Municipal
    BuildMgr:updateInfo(lMsg)
    ---刷新门票
    Event.Brocast("c_TicketValueChange", model.buildingOwnerId,parkData.visitorCount)
    ---刷新showItem
    if #model.SlotList>0 then
        Event.Brocast("c_ShowItemValueChange", model.SlotList[1].rentPreDay,#model.SlotList,model.SlotList[1].maxDayToRent)
    else
        Event.Brocast("c_ShowItemValueChange", 0,0,0)
    end
end

function MunicipalCtrl:ClearData(manger)
    DestroyListItem(manger.outAdvertisementItemList)
    DestroyListItem(manger.AdvertisementItemList)
    DestroyListItem(manger.serverMapAdvertisementItemList)
    DestroyListItem(manger.buildItemList)
    DestroyListItem(manger.goodsItemList)
    DestroyListItem(manger.addItemList)
    DestroyListItem(manger.addItemList)
    for i, v in pairs(manger.addItemInSList) do
        v=nil
    end
    manger.addItemInSList={}

    manger.AddItemID=0
end

function DestroyListItem(List)
    for i, item in pairs(List) do
       destroy(item)
    end
end