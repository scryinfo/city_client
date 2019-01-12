---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/26/026 17:44
---



require "Common/define"
require('Framework/UI/UIPage')

local isShowList;
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)

local class = require 'Framework/class'
ManageAdvertisementPosCtrl = class('ManageAdvertisementPosCtrl',UIPage)

UIPage:ResgisterOpen(ManageAdvertisementPosCtrl) --注册打开的方法

--构建函数
function ManageAdvertisementPosCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ManageAdvertisementPosCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ManageAdvertisementPosPanel.prefab";
end

function ManageAdvertisementPosCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    isShowList = false;
end
local materialBehaviours
local MunicipalModel
local manger
local AllGoods={}
function ManageAdvertisementPosCtrl:Awake(go)
    self.gameObject = go;
    local materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    MunicipalModel=DataManager.GetDetailModelByID(MunicipalPanel.buildingId)


    materialBehaviours=materialBehaviour
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.backBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.infoBtn.gameObject,self.OnClick_infoBtn,self);
    materialBehaviour:AddClick( ManageAdvertisementPosPanel.confirmBtn.gameObject,self.OnClick_confirm,self)
    --排序
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.nameBtn.gameObject,self.OnClick_OnName,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.quantityBtn.gameObject,self.OnClick_OnNumber,self);

    materialBehaviour:AddClick(ManageAdvertisementPosPanel.goodsBtn1.gameObject,self.OnClick_OnGoods,self);
    materialBehaviour:AddClick(ManageAdvertisementPosPanel.buildingBtn.gameObject,self.OnClick_OnBuild,self);
    -- self:OnClick_OnGoods();
    -----创建广告管理
    self.ItemCreatDeleteMgr=MunicipalModel.manger

    self.loopScrollDataSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.loopScrollDataSource.mProvideData =self.ReleaseData
    self.loopScrollDataSource.mClearData = self.CollectClearData
    local temp=DataManager.GetMyGoodLv()

    for i, v in pairs(temp) do
         local data={}
        data.mId=i
        table.insert(AllGoods,data)
    end
    ManageAdvertisementPosPanel.loopScroll:ActiveLoopScroll(self.loopScrollDataSource, #AllGoods)

    Event.AddListener("c_FirstCreate",ManageAdvertisementPosCtrl.c_FirstCreate,self)
end

function ManageAdvertisementPosCtrl.ReleaseData(transform, idx)
    idx = idx + 1
    local data=Material[AllGoods[idx].mId] or  Good[AllGoods[idx].mId]
    if not data then
        destroy(transform.gameObject)
        return
    end
    local collectItem = GoodsItem:new(data, transform,materialBehaviours,MunicipalModel.manger,idx)
    MunicipalModel.manger.insList[AllGoods[idx].mId] = collectItem
end

function ManageAdvertisementPosCtrl.CollectClearData(transform)

end


--返回
function ManageAdvertisementPosCtrl:OnClick_backBtn(ins)


    if DataManager.GetMyOwnerID()==MunicipalModel.buildingOwnerId then--自已进入
        for i, v in pairs(ins.ItemCreatDeleteMgr.addedItemList) do
            destroy(v)
        end
        for i, v in pairs(ins.ItemCreatDeleteMgr.selectItemList) do
            v:GetComponent("Image").raycastTarget=true;
        end
        ------------------------------------------------------
        if ins.ItemCreatDeleteMgr.serverMapAdvertisementINSList then
            ---服务器数据还原
            for i, v in pairs(ins.ItemCreatDeleteMgr.serverMapAdvertisementINSList) do
                v.prefab:SetActive(true)
                v.numtext.text=v.selfcount
            end
        end
        ins.ItemCreatDeleteMgr.AdvertisementDataList={}
    else---他人进入
    for i, v in pairs(ins.ItemCreatDeleteMgr.addedItemList) do
        destroy(v)
    end
        for i, v in pairs(ins.ItemCreatDeleteMgr.selectItemList) do
            v:GetComponent("Image").raycastTarget=true;
        end
        ins.ItemCreatDeleteMgr.AdvertisementDataList={}
        -----------------------------------------------------------------------------
        if ins.ItemCreatDeleteMgr.serverMapAdvertisementINSList then
            ---服务器数据还原
            for i, v in pairs(ins.ItemCreatDeleteMgr.serverMapAdvertisementINSList) do
                v.numtext.text=v.selfcount
            end
        end
        --if ins.ItemCreatDeleteMgr.newaddIndex then
        --    destroy(ins.ItemCreatDeleteMgr.addItemInSList[ins.ItemCreatDeleteMgr.newaddIndex].prefab)
        --    ins.ItemCreatDeleteMgr.addItemInSList[ins.ItemCreatDeleteMgr.newaddIndex]=nil
        --    ins.ItemCreatDeleteMgr.current=nil
        --end
        if ins.manger then
            ins.manger.current=nil
        end

    end
    ins.ItemCreatDeleteMgr:Remove()
    ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(true);
    UIPage.ClosePage();
end


--打开信息界面
function ManageAdvertisementPosCtrl:OnClick_infoBtn()

end
--是否打开第一个槽位
function ManageAdvertisementPosCtrl:isFirstSlot()

    if DataManager.GetMyOwnerID()==MunicipalModel.buildingOwnerId then--自已进入
        MunicipalModel.manger.addItemList[0]:SetActive(true)
        MunicipalModel.manger.addItemList[0].transform:SetAsFirstSibling()
        MunicipalModel.manger.addItemInSList[0].numText.transform.parent.localScale=Vector3.zero
        MunicipalModel.manger.addItemInSList[0].timeText.transform.parent.localScale=Vector3.zero
    else--他人进入
        MunicipalModel.manger.addItemList[0]:SetActive(false)
    end
end

--刷新数据
function ManageAdvertisementPosCtrl:Refresh()
    MunicipalModel=DataManager.GetDetailModelByID(MunicipalPanel.buildingId)
    self.ItemCreatDeleteMgr=MunicipalModel.manger
    manger=MunicipalModel.manger
    if MunicipalPanel.buildingId~=ManageAdvertisementPosPanel.currentBuildingId then
        local temp=MunicipalPanel.buildingId
        local creatData={model=MunicipalModel,buildingType=BuildingType.MunicipalManage,lMsg=MunicipalPanel.lMsg}
        self.ItemCreatDeleteMgr:creat(materialBehaviours,creatData)
        ManageAdvertisementPosPanel.currentBuildingId=temp
        self.ItemCreatDeleteMgr:_creataddItem();
        local buildBtnList , goodsBtnList=self:c_ScreenOutAd()

       -- self.ItemCreatDeleteMgr:_creatgoodsItem();

        for name, data in pairs(buildBtnList) do
            data.name=name
            self.ItemCreatDeleteMgr:_creatbuildingItem(data);
        end

    end

    --是否打开第一个槽位
    self:isFirstSlot()
    if DataManager.GetMyOwnerID()==MunicipalModel.buildingOwnerId then--自已进入

    else--他人进入
        self:c_ScreenOut(self.m_data.myBuySlots)
        if self.ItemCreatDeleteMgr.serverMapAdvertisementINSList then
            for i, v in pairs(self.ItemCreatDeleteMgr.serverMapAdvertisementINSList) do
                v.prefab.transform:SetAsLastSibling();
            end
        end
    end


    --全部复原
    for mId, buildIns in pairs(manger.insList) do
            buildIns.prefab.transform:GetComponent("Image").raycastTarget=true;
    end


    --todo:处理已经打的广告的按钮
    for metaId, ins in pairs(manger.serverMapAdvertisementINSList) do
        for mId, buildIns in pairs(manger.insList) do
            if metaId ==mId then
                buildIns.prefab.transform:GetComponent("Image").raycastTarget=false;
                break
            end
        end
    end


end

function ManageAdvertisementPosCtrl:c_ScreenOutAd()
    local AllBuildingDetail=DataManager.GetMyAllBuildingDetail()
    --TODO:甩选出建筑广告
    local buildBtn={}
    local goodsBtn={}

    for i, buildingDetails in pairs(AllBuildingDetail) do

        for k, tempInfo in ipairs(buildingDetails) do
            --可以广告
            local configData=PlayerBuildingBaseData[tempInfo.info.mId]
            local typeName=configData.typeName
            if configData.isAd then
                local table=buildBtn[typeName]
                if not table then
                    buildBtn[typeName]={}
                    buildBtn[typeName].small=0
                    buildBtn[typeName].medium=0
                    buildBtn[typeName].large=0
                    buildBtn[typeName].mId=configData.AdmId
                end

                if configData.sizeName=="大型" then
                    buildBtn[typeName].large=buildBtn[typeName].large+1
                elseif configData.sizeName=="中型" then
                    buildBtn[typeName].medium=buildBtn[typeName].medium+1
                else
                    buildBtn[typeName].small=buildBtn[typeName].small+1
                end
            end

        end
    end

    return buildBtn ,goodsBtn
end

function ManageAdvertisementPosCtrl:c_ScreenOut(slotList)
    self.slotList={}
    local tempList={}

    for i, slot in pairs(slotList) do
        if not tempList[slot.days] then
            tempList[slot.days]={}
            table.insert(tempList[slot.days],slot)
        else
            table.insert(tempList[slot.days],slot)
        end
    end

    for i, v in pairs(tempList) do
        table.insert(self.slotList,v)
    end

    ---刷新数据
    if #self.ItemCreatDeleteMgr.addItemInSList-1>#self.slotList then--实例数量大于数据数量
        for i = 1, #self.ItemCreatDeleteMgr.addItemInSList-1 do
            local ins=self.ItemCreatDeleteMgr.addItemInSList[i]
            if self.slotList[i] then
                ins.prefab:SetActive(true)
                ins.numText.text=#self.slotList[i]--刷新数量
                --刷新时间
                ins.angleRoot.localScale=Vector3.zero--关闭四角
                ins.selfAcount=#self.slotList[i]
                ins.updateAcount=#self.slotList[i]
                ins.slots=self.slotList[i]
                ins.days=self.slotList[i][1].days
                ---结束点时间
                local begTs=getFormatUnixTime( tonumber(string.sub(tostring(self.slotList[i][1].beginTs),1,10)))
                begTs.day= begTs.day+self.slotList[i][1].days
                local endTs=os.time(begTs)
                ---剩余时间
                local temp=os.date(endTs-os.time())
                local remainTime= convertTimeForm(temp)
                ins.timeText.text=remainTime.hour+24*remainTime.day.. ":"..remainTime.min..":"..remainTime.sec --"h"
                ins.remainTime=temp
            else
                ins.prefab:SetActive(false)
                ins.remainTime=nil
            end
        end
    else--实例数量小于数据数量
        for i = 1, #self.slotList do
            local ins=self.ItemCreatDeleteMgr.addItemInSList[i]
            if ins then
                ins.numText.text=#self.slotList[i]--刷新数量
                --刷新时间
                ins.angleRoot.localScale=Vector3.zero--关闭四角
                ins.selfAcount=#self.slotList[i]
                ins.updateAcount=#self.slotList[i]
                ins.slots=self.slotList[i]
                ins.days=self.slotList[i][1].days
                ---结束点时间
                local begTs=getFormatUnixTime( tonumber(string.sub(tostring(self.slotList[i][1].beginTs),1,10)))
                begTs.day= begTs.day+self.slotList[i][1].days
                local endTs=os.time(begTs)
                ---剩余时间
                local temp=os.date(endTs-os.time())
                local remainTime= convertTimeForm(temp)
                ins.timeText.text=remainTime.hour+24*remainTime.day.. ":"..remainTime.min..":"..remainTime.sec --"h"
                ins.remainTime=temp
            else
                self.ItemCreatDeleteMgr:_creataddItem({})
                self.ItemCreatDeleteMgr.addItemInSList[i].numText.text=#self.slotList[i]--刷新数量
                --刷新时间
                self.ItemCreatDeleteMgr.addItemInSList[i].angleRoot.localScale=Vector3.zero--关闭四角
                self.ItemCreatDeleteMgr.addItemInSList[i].selfAcount=#self.slotList[i]
                self.ItemCreatDeleteMgr.addItemInSList[i].updateAcount=#self.slotList[i]
                self.ItemCreatDeleteMgr.addItemInSList[i].slots=self.slotList[i]
                self.ItemCreatDeleteMgr.addItemInSList[i].days=self.slotList[i][1].days
                ---结束点时间
                local begTs=getFormatUnixTime(tonumber(string.sub(tostring(self.slotList[i][1].beginTs),1,10)))
                begTs.day= begTs.day+self.slotList[i][1].days
                local endTs=os.time(begTs)
                ---剩余时间
                local temp=os.date(endTs-os.time())
                local remainTime= convertTimeForm(temp)
                self.ItemCreatDeleteMgr.addItemInSList[i].timeText.text=remainTime.hour+24*(remainTime.day).. ":"..remainTime.min..":"..remainTime.sec --"h"
                self.ItemCreatDeleteMgr.addItemInSList[i].remainTime=temp
            end
        end
    end

---除去已用的槽位
if self.ItemCreatDeleteMgr.adList then
    for metaId, metaIdAds in pairs(self.ItemCreatDeleteMgr.adList) do
        for i, ad in pairs(metaIdAds) do
            for k, slots in pairs(tempList) do
                for v, slot in pairs(slots) do
                    if slot.s.id==ad.slot.s.id then
                        table.remove(tempList[k],v)
                    end
                end
            end
        end
    end
end


    for i, v in pairs(self.slotList) do
        self.ItemCreatDeleteMgr.addItemInSList[i].numText.text=#v
        if #v==0 then
            self.ItemCreatDeleteMgr.addItemInSList[i].prefab:SetActive(false)
        end
    end
    self.ItemCreatDeleteMgr:begin()

    ---默认开启一个四角
    for i = 1, #self.ItemCreatDeleteMgr.addItemInSList do
        local tempIns=self.ItemCreatDeleteMgr.addItemInSList[i]
        if tempIns.prefab.activeInHierarchy then
            tempIns.angleRoot.localScale=Vector3.one
            self.ItemCreatDeleteMgr.current=tempIns
            break
        end
    end
end


--根据名字排序
function ManageAdvertisementPosCtrl:OnClick_OnName()
    ManageAdvertisementPosPanel.nowText.text = "By brand";
    ManageAdvertisementPosCtrl:OnClick_OpenList(not isShowList);
end
--根据数量排序
function ManageAdvertisementPosCtrl:OnClick_OnNumber()
    ManageAdvertisementPosPanel.nowText.text = "By quantity";
    ManageAdvertisementPosCtrl:OnClick_OpenList(not isShowList);
end

--展开排序列表
function ManageAdvertisementPosCtrl:OnClick_OnSorting(ins)
    ManageAdvertisementPosCtrl:OnClick_OpenList(not isShowList);
end
--排序列表动画
function ManageAdvertisementPosCtrl:OnClick_OpenList(isShow)
    if isShow then
        --WarehousePanel.list:SetActive(true);
        ManageAdvertisementPosPanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ManageAdvertisementPosPanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        --WarehousePanel.list:SetActive(false);
        ManageAdvertisementPosPanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ManageAdvertisementPosPanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

--设置显隐
function ManageAdvertisementPosCtrl:OnClick_OnGoods()
    ManageAdvertisementPosPanel.goodsScroll.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.buildingScroll.gameObject:SetActive(false);

    self:SetActive(false);
    ManageAdvertisementPosPanel.goodsBtn.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.buildingBtn.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.buildingBtn1.gameObject:SetActive(false);
end

function ManageAdvertisementPosCtrl:OnClick_OnBuild()
    ManageAdvertisementPosPanel.buildingScroll.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.goodsScroll.gameObject:SetActive(false);

    self:SetActive(false);
    ManageAdvertisementPosPanel.buildingBtn1.gameObject:SetActive(true);
    ManageAdvertisementPosPanel.goodsBtn.gameObject:SetActive(false);
    ManageAdvertisementPosPanel.goodsBtn1.gameObject:SetActive(true);
end

function ManageAdvertisementPosCtrl:OnClick_confirm(ins)

    if DataManager.GetMyOwnerID()==MunicipalModel.buildingOwnerId then --自已进入
        ins.callback=ins.Mastercallback
    else
        ins.callback=ins.OtherCallback
    end
    ct.OpenCtrl("ConfirmPopCtrl",ins)
end

function ManageAdvertisementPosCtrl:Mastercallback()
    UIPage:ClosePage()
    ct.OpenCtrl("AdvertisementPosCtrl")
    for i, v in pairs(self.ItemCreatDeleteMgr.addedItemList) do
        destroy(v);
    end

    local buildingId=MunicipalPanel.buildingId
    ---从无到有的打广告
    for i, v in pairs(self.ItemCreatDeleteMgr.AdvertisementDataList) do
        v.personId=DataManager.GetMyOwnerID()
        self.ItemCreatDeleteMgr:_creatAdvertisementItem(v)
        self.ItemCreatDeleteMgr:_creatoutItem(v)
        ---发送打广告请求
        for k = 1, v.count do
            DataManager.DetailModelRpcNoRet(buildingId, 'm_adPutAdToSlot',nil,v.metaId,v.type,buildingId)
        end
        --------------------------------------------
        for u, p in pairs(self.ItemCreatDeleteMgr.adList) do
            if u==v.metaId then
                return
            end
        end
        --local data={metaId=v.metaId,count=v.count}
        self.ItemCreatDeleteMgr:_creatserverMapAdvertisementItem(v)
    end

    self.ItemCreatDeleteMgr.AdvertisementDataList={}

    ---修改广告
    if self.ItemCreatDeleteMgr.serverMapAdvertisementINSList then
        for i, v in pairs(self.ItemCreatDeleteMgr.serverMapAdvertisementINSList) do
            if  tonumber(v.selfcount) < tonumber(v.updatecount) then---添加广告
            for i = 1, (v.updatecount-v.selfcount) do
                DataManager.DetailModelRpcNoRet(buildingId, 'm_adPutAdToSlot',nil,v.metaId,v.type,buildingId)
                self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text+1
                v.selfcount=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text
            end

            else---删广告
            for k = 1, (v.selfcount-v.updatecount)  do
                DataManager.DetailModelRpcNoRet(buildingId, 'm_DelAdFromSlot',buildingId,self.ItemCreatDeleteMgr.adList[v.metaId][1].id)
                table.remove(self.ItemCreatDeleteMgr.adList[v.metaId],1)
                self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text-1
                v.selfcount=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text

                if tonumber(v.selfcount)==0 then
                    destroy(self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].prefab)
                    self.ItemCreatDeleteMgr.adList[v.metaId]=nil
                    destroy(self.ItemCreatDeleteMgr.outAdvertisementINSList[v.metaId].prefab)
                    self.ItemCreatDeleteMgr.outAdvertisementINSList[v.metaId]=nil
                    self.ItemCreatDeleteMgr.serverMapAdvertisementINSList[v.metaId]=nil
                end
            end
            end
        end
    end

   -- DataManager.DetailModelRpcNoRet(buildingId, 'm_detailPublicFacility',buildingId)

    ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(true);
end

function ManageAdvertisementPosCtrl:c_FirstCreate()
    local creatData={model=MunicipalModel,buildingType=BuildingType.MunicipalManage,lMsg=MunicipalModel.lMsg}
    self.ItemCreatDeleteMgr:creat(materialBehaviours,creatData)
end

function ManageAdvertisementPosCtrl:OtherCallback()
    UIPage:ClosePage()
    ct.OpenCtrl("AdvertisementPosCtrl")
    local buildingId=MunicipalPanel.buildingId

    ----从无到有的打广告
    for i, v in pairs(self.ItemCreatDeleteMgr.addedItemList) do
        destroy(v);
    end
    for i, v in pairs(self.ItemCreatDeleteMgr.selectItemList) do
        v:GetComponent("Image").raycastTarget=true;
    end
    ----发送请求
    for i, data in pairs(self.ItemCreatDeleteMgr.AdvertisementDataList) do
        data.personId=DataManager.GetMyOwnerID()
        self.ItemCreatDeleteMgr:_creatAdvertisementItem(data)
        self.ItemCreatDeleteMgr:_creatoutItem(data)
        for i = 1, data.count do
            DataManager.DetailModelRpcNoRet(buildingId, 'm_adPutAdToSlot',data.slots[1].s.id,data.metaId,data.type,buildingId)
            table.remove(data.slots,1)
        end
        for u, p in pairs(self.ItemCreatDeleteMgr.adList) do
            if u==data.metaId then
                return
            end
        end
        self.ItemCreatDeleteMgr.isFirst=true
    end

    self.ItemCreatDeleteMgr.AdvertisementDataList={}

    ---修改广告
    if self.ItemCreatDeleteMgr.serverMapAdvertisementINSList then
        for i, v in pairs(self.ItemCreatDeleteMgr.serverMapAdvertisementINSList) do
            if  tonumber(v.selfcount) < tonumber(v.updatecount) then---添加广告
                --找出slotid
                local slots={}
                for i, addItemInS in pairs(self.ItemCreatDeleteMgr.addItemInSList) do
                    if addItemInS.days==v.days then
                        slots=addItemInS.slots
                    end
                end
                for i = 1, (v.updatecount-v.selfcount) do

                    DataManager.DetailModelRpcNoRet(buildingId, 'm_adPutAdToSlot',slots[1].s.id,v.metaId,v.type,buildingId)
                    table.remove(slots,1)
                    self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text+1
                    v.selfcount=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text
                end

            else---删广告
            for k = 1, (v.selfcount-v.updatecount)  do
                DataManager.DetailModelRpcNoRet(buildingId, 'm_DelAdFromSlot',buildingId,v.ads[1].id)
                table.insert(v.slots,v.ads[1].slot)
                table.remove(v.ads,1)
                self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text-1
                v.selfcount=self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].countText.text

                ---删数据和预制
                if tonumber(v.selfcount) ==0 then
                    destroy(self.ItemCreatDeleteMgr.AdvertisementINSList[v.metaId].prefab)
                    self.ItemCreatDeleteMgr.AdvertisementItemList[v.metaId]=nil
                    self.ItemCreatDeleteMgr.adList[v.metaId]=nil
                    destroy(self.ItemCreatDeleteMgr.serverMapAdvertisementINSList[v.metaId].prefab)
                    self.ItemCreatDeleteMgr.serverMapAdvertisementINSList[v.metaId]=nil
                    destroy(self.ItemCreatDeleteMgr.outAdvertisementINSList[v.metaId].prefab)
                    self.ItemCreatDeleteMgr.outAdvertisementINSList[v.metaId]=nil
                end
            end
            end
        end
    end


    DataManager.DetailModelRpcNoRet(buildingId, 'm_detailPublicFacility',buildingId)

    ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(true);

end




















