---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/2#MunicipalModel.SlotList/02#MunicipalModel.SlotList 16:24
---


require "Common/define"
require "View/BuildingInfo/BuildingInfoToggleGroupMgr";
require('Framework/UI/UIPage')
require "View/BuildingInfo/ItemCreatDeleteMgr"


local class = require 'Framework/class'
AdvertisementPosCtrl = class('AdvertisementPosCtrl',UIPage)
UIPage:ResgisterOpen(AdvertisementPosCtrl) --注册打开的方法

local panel=AdvertisementPosPanel
--构建函数
function AdvertisementPosCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function AdvertisementPosCtrl:bundleName()
    return "AdvertisementPosPanel";
end

function AdvertisementPosCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end
local materialBehaviours
function AdvertisementPosCtrl:Awake(go)
    self.gameObject = go;

    local materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviours=materialBehaviour
    materialBehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);


    materialBehaviour:AddClick(panel.manageBtn.gameObject,self.OnClick_manageBtn,self)
    materialBehaviour:AddClick(panel.confirmBtn.gameObject,self.OnClick_masterConfirm,self)
    materialBehaviour:AddClick(panel.confirmBtn1.gameObject,self.OnClick_otherConfirm,self)
    ----------------------------------------------------------------------------------------------------------------

    panel.qunayityInp.onValueChanged:AddListener(self.Set)
    panel.leaseInp.onValueChanged:AddListener(self.Set)
    panel.rentInp.onValueChanged:AddListener(self.Set)
    -------------------------------------------------------------------------------------------------------------------------
    panel.numInp.onValueChanged:AddListener(function (arg)
        if panel.numInp.text==""then
            return
        end
        if( panel.numInp.text/#MunicipalModel.SlotList>=1)then
            panel.numInp.text=#MunicipalModel.SlotList
        end
        panel.numSlider.value=arg/#MunicipalModel.SlotList ;
         panel.totalText.text=getPriceString((3*MunicipalModel.SlotList[1].rentPreDay)..".0000",30,24)
    end)

    panel.numSlider.onValueChanged:AddListener(function (arg)
        panel.numInp.text=math.floor(#MunicipalModel.SlotList*arg)
    end)

    panel.maxInp.onValueChanged:AddListener(function (arg)
        if panel.maxInp.text==""then
            return
        end
        if(panel.maxInp.text/MunicipalModel.SlotList[1].maxDayToRent>=1)then
            panel.maxInp.text=MunicipalModel.SlotList[1].maxDayToRent
        end
        panel.maxSlider.value=arg/MunicipalModel.SlotList[1].maxDayToRent;
    end)

    panel.maxSlider.onValueChanged:AddListener(function (arg)
        panel.maxInp.text=math.floor(MunicipalModel.SlotList[1].maxDayToRent*arg)
    end)

    -----创建广告
    local creatData={buildingType=BuildingType.Municipal,lMsg=MunicipalModel.lMsg}
    self.ItemCreatDeleteMgr=MunicipalModel.manger
    self.ItemCreatDeleteMgr:creat(materialBehaviours,creatData)
end

--更改名字
function AdvertisementPosCtrl:OnClick_changeName()
    local data = {}
    data.titleInfo = "RENAME";
    data.tipInfo = "Modified every seven days";
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    UIPage:ShowPage(InputDialogPageCtrl, data)
end

--返回
function AdvertisementPosCtrl:OnClick_backBtn()
    UIPage.ClosePage();
end

--打开信息界面
function AdvertisementPosCtrl:OnClick_infoBtn()

end

function AdvertisementPosCtrl:Refresh()
    --if MunicipalModel.owenerId==MunicipalModel.buildingOwnerId then--自已进入
    --    if #MunicipalModel.SlotList>0 then
    --        panel.qunayityInp.text=#MunicipalModel.SlotList
    --        panel.leaseInp.text=MunicipalModel.SlotList[1].maxDayToRent
    --        panel.rentInp.text=MunicipalModel.SlotList[1].rentPreDay
    --        panel.adAllday=panel.qunayityInp.text
    --        panel.grey.gameObject:SetActive(true);
    --    end
    --    panel.buyGo.gameObject:SetActive(false)
    --else--他人进入
    --    --panel.buyGo.gameObject:SetActive(true)
    --    --panel.rentText.text=getPriceString(MunicipalModel.SlotList[1].rentPreDay..".0000",30,24)
    --    --panel.dotText.text=getPriceString((3*MunicipalModel.SlotList[1].rentPreDay)..".0000",30,24)
    --    --panel.manageBtn.gameObject:SetActive(false)
    --
    --end
end


---管理广告按钮
function AdvertisementPosCtrl:OnClick_manageBtn()

    ct.OpenCtrl("ManageAdvertisementPosCtrl")

end


function AdvertisementPosCtrl:OnClick_masterConfirm(ins)
    local buildingID=MunicipalModel.lMsg.info.id
    --主人点击确认按钮
    Event.Brocast("SmallPop","Successful adjustment",47)
    panel.grey.gameObject:SetActive(true);
    -----发送网络消息
    if panel.qunayityInp.text>panel.adAllday then---添加槽位
        for i = 1, panel.qunayityInp.text-panel.adAllday do
            Event.Brocast("m_addSlot",buildingID,1,tonumber(panel.leaseInp.text), tonumber(panel.rentInp.text))
        end
        panel.adAllday=panel.qunayityInp.text

    elseif  panel.qunayityInp.text<panel.adAllday  then---删除槽位
    for i = 1, panel.adAllday-panel.qunayityInp.text do
        Event.Brocast("m_deleteSlot",buildingID,MunicipalModel.SlotList[1].id)
        table.remove(MunicipalModel.SlotList,1)
    end
        panel.adAllday=panel.qunayityInp.text

    else---设置租金和最大天数
        for i, v in pairs(MunicipalModel.SlotList) do
            Event.Brocast("m_SetSlot",buildingID,v.id,tonumber(panel.rentInp.text),1,tonumber(panel.leaseInp.text))
        end
    end
end

function AdvertisementPosCtrl:OnClick_otherConfirm()
    --他人点击
    ct.OpenCtrl("SignOnCtrl");
end



function AdvertisementPosCtrl:Set(toggle)
    panel.grey.gameObject:SetActive(false);
end







