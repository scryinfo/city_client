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
local MunicipalModel
local text
function AdvertisementPosCtrl:Awake(go)
    self.gameObject = go;
    MunicipalModel=DataManager.GetDetailModelByID(MunicipalPanel.buildingId)

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
    --panel.numInp.onValueChanged:AddListener(function (arg)
    --    if panel.numInp.text==""then
    --        return
    --    end
    --    if( panel.numInp.text/#MunicipalModel.SlotList>=1)then
    --        panel.numInp.text=#MunicipalModel.SlotList
    --    end
    --    panel.numSlider.value=arg/#MunicipalModel.SlotList ;
    --     panel.totalText.text=getPriceString((3*MunicipalModel.SlotList[1].rentPreDay)..".0000",30,24)
    --end)

    panel.numSlider.onValueChanged:AddListener(function (arg)
        if #MunicipalModel.SlotList<=0 then
            return
        end
        panel.numInp.text=math.floor(#MunicipalModel.SlotList*arg)
        self.acount=panel.numInp.text
        if panel.maxInp.text~="" and  panel.maxInp.text~=0 then
            self.totalPrice=3*MunicipalModel.SlotList[1].rentPreDay+(panel.numInp.text*panel.maxInp.text*MunicipalModel.SlotList[1].rentPreDay)
            panel.totalText.text=getPriceString(self.totalPrice..".0000",30,24)
        end
    end)

    --panel.maxInp.onValueChanged:AddListener(function (arg)
    --    if panel.maxInp.text==""then
    --        return
    --    end
    --    if(panel.maxInp.text/MunicipalModel.SlotList[1].maxDayToRent>=1)then
    --        panel.maxInp.text=MunicipalModel.SlotList[1].maxDayToRent
    --    end
    --    panel.maxSlider.value=arg/MunicipalModel.SlotList[1].maxDayToRent;
    --end)

    panel.maxSlider.onValueChanged:AddListener(function (arg)
        if #MunicipalModel.SlotList<=0 then
            return
        end
        panel.maxInp.text=math.floor(MunicipalModel.SlotList[1].maxDayToRent*arg)
        self.dayAcount=panel.maxInp.text
        if panel.numInp.text~="" and  panel.numInp.text~=0 then
            self.totalPrice=3*MunicipalModel.SlotList[1].rentPreDay+(panel.numInp.text*panel.maxInp.text*MunicipalModel.SlotList[1].rentPreDay)
            panel.totalText.text=getPriceString(self.totalPrice..".0000",30,24)
        end
    end)

    --
    -------创建广告
    --local creatData={model=MunicipalModel,buildingType=BuildingType.Municipal,lMsg=MunicipalModel.lMsg}
    --self.ItemCreatDeleteMgr=MunicipalModel.manger
    --self.ItemCreatDeleteMgr:creat(materialBehaviours,creatData)

    text=panel.manageText.text
end


--返回
function AdvertisementPosCtrl:OnClick_backBtn()
    UIPage.ClosePage();
end

local num=0
function AdvertisementPosCtrl:Refresh()
    MunicipalModel=DataManager.GetDetailModelByID(MunicipalPanel.buildingId)

    ---创建外部广告
    if MunicipalPanel.buildingId~=AdvertisementPosPanel.currentBuildingId then
        local temp=MunicipalPanel.buildingId
        local creatData={model=MunicipalModel,buildingType=BuildingType.Municipal,lMsg=MunicipalPanel.lMsg}
        MunicipalModel.manger:creat(materialBehaviours,creatData)
        AdvertisementPosPanel.currentBuildingId=temp
    end

    if DataManager.GetMyOwnerID()==MunicipalModel.buildingOwnerId then---自已进入
       if #MunicipalModel.SlotList>0 then
        panel.qunayityInp.text=#MunicipalModel.SlotList
        panel.leaseInp.text=MunicipalModel.SlotList[1].maxDayToRent
        panel.rentInp.text=MunicipalModel.SlotList[1].rentPreDay
        panel.adAllday=panel.qunayityInp.text
        panel.grey.gameObject:SetActive(true);
       else
        panel.qunayityInp.text= 0
        panel.leaseInp.text=0
        panel.rentInp.text= 0
        panel.adAllday= 0
        panel.grey.gameObject:SetActive(true);
       end
    panel.buyGo.localScale=Vector3.zero

        else---他人进入
    panel.buyGo.localScale=Vector3.one
        if MunicipalModel.SlotList[1] then
            panel.rentText.text=getPriceString(MunicipalModel.SlotList[1].rentPreDay..".0000",30,24)
            panel.dotText.text=getPriceString((3*MunicipalModel.SlotList[1].rentPreDay)..".0000",30,24)
        else
            panel.rentText.text=getPriceString("0"..".0000",30,24)
            panel.dotText.text=getPriceString("0"..".0000",30,24)
        end
    panel.manageBtn.gameObject:SetActive(false)--管理我的广告位
    panel.manageBtn.parent:GetComponent("RectTransform").anchoredPosition=panel.noPos
        self.myBuySlots={}
        if MunicipalModel.lMsg.ad.soldSlot then

            for i, v in pairs(MunicipalModel.lMsg.ad.soldSlot) do
                if v.renterId==DataManager.GetMyOwnerID() then--有槽位
                    ---筛选
                    table.insert(self.myBuySlots,v)
                else --无槽位
                    panel.manageBtn.gameObject:SetActive(false)--管理我的广告位
                    panel.manageBtn.parent:GetComponent("RectTransform").anchoredPosition=panel.noPos
                end
            end
        else
            panel.manageBtn.gameObject:SetActive(false)--管理我的广告位
            panel.manageBtn.parent:GetComponent("RectTransform").anchoredPosition=panel.noPos
        end
        if self.myBuySlots  then--给（/）赋值
            if #self.myBuySlots>0 then panel.manageBtn.gameObject:SetActive(true)--管理我的广告位
            panel.manageBtn.gameObject:SetActive(true)--管理我的广告位
            panel.manageBtn.parent:GetComponent("RectTransform").anchoredPosition=panel.hasPos
            end

                local num=0
            for metaId, ads in pairs(MunicipalModel.manger.adList) do
                for i, v in pairs(ads) do
                    num=num+1
                end
            end
                panel.manageText.text=text.."(" ..tostring(num).."/"..#self.myBuySlots..")"
        end
    end
end


---管理广告按钮
function AdvertisementPosCtrl:OnClick_manageBtn(ins)
    ct.OpenCtrl("ManageAdvertisementPosCtrl",ins)
end


function AdvertisementPosCtrl:OnClick_masterConfirm(ins)
    local buildingID=MunicipalPanel.buildingId
    --主人点击确认按钮
    Event.Brocast("SmallPop","Successful adjustment",47)
    panel.grey.gameObject:SetActive(true);
    -----发送网络消息
    if tonumber(panel.qunayityInp.text)>tonumber(panel.adAllday) then---添加槽位
        for i = 1, panel.qunayityInp.text-panel.adAllday do
        DataManager.DetailModelRpcNoRet(buildingID, 'm_addSlot',buildingID,1,tonumber(panel.leaseInp.text),tonumber(panel.rentInp.text))
        --Event.Brocast("m_addSlot",buildingID,1,tonumber(panel.leaseInp.text), tonumber(panel.rentInp.text))
        end
        panel.adAllday=panel.qunayityInp.text

    elseif  tonumber(panel.qunayityInp.text)<tonumber(panel.adAllday)  then---删除槽位
    for i = 1, panel.adAllday-panel.qunayityInp.text do
        DataManager.DetailModelRpcNoRet(buildingID, 'm_deleteSlot',buildingID,DataManager.GetDetailModelByID(buildingID).SlotList[1].id)
        --Event.Brocast("m_deleteSlot",buildingID,MunicipalModel.SlotList[1].id)
        table.remove(DataManager.GetDetailModelByID(buildingID).SlotList,1)
    end
        panel.adAllday=panel.qunayityInp.text

    else---设置租金和最大天数
        for i, v in pairs(DataManager.GetDetailModelByID(buildingID).SlotList) do
        DataManager.DetailModelRpcNoRet(buildingID, 'm_SetSlot',buildingID,v.id,tonumber(panel.rentInp.text),1,tonumber(panel.leaseInp.text))
        --Event.Brocast("m_SetSlot",buildingID,v.id,tonumber(panel.rentInp.text),1,tonumber(panel.leaseInp.text))
        end
    end
end

function AdvertisementPosCtrl:OnClick_otherConfirm(ins)
    --他人点击
    if ins.acount==""or ins.acount==0 or ins.dayAcount==""or ins.dayAcount==0 or not ins.acount or not ins.dayAcount then
       return
    end
    ct.OpenCtrl("SignOnCtrl",ins);
end



function AdvertisementPosCtrl:Set(toggle)
    panel.grey.gameObject:SetActive(false);
end







