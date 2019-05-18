---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/11 14:57
---
-----

RetailStoresCtrl = class('RetailStoresCtrl',UIPanel)
UIPanel:ResgisterOpen(RetailStoresCtrl) --注册打开的方法

local this
--构建函数
function RetailStoresCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailStoresCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RetailStoresPanel.prefab";
end

function RetailStoresCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function RetailStoresCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.retailStoresBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.retailStoresBehaviour:AddClick(RetailStoresPanel.bubbleMessageBtn, self._openBubbleMessage, self)

end
function RetailStoresCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_Revenue",self.c_Revenue,self)

end
function RetailStoresCtrl:Refresh()
    RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
    this:initializeData()
end

function RetailStoresCtrl:initializeData()
    if self.m_data then
        --向服务器请求建筑详情
        DataManager.OpenDetailModel(RetailStoresModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenRetailShop',self.m_data.insId)
    end
end

--刷新原料厂信息
function RetailStoresCtrl:refreshmRetailShopDataInfo(retailShopDataInfo)
    --初始化
    RetailStoresPanel.openBusinessItem:initData(retailShopDataInfo.info, BuildingType.RetailShop)
    local insId = self.m_data.insId
    self.m_data = retailShopDataInfo
    self.m_data.insId = insId
    self.m_data.buildingType = BuildingType.RetailShop
    retailShopDataInfo.info.buildingType = BuildingType.RetailShop

    if RetailStoresPanel.topItem ~= nil then
        RetailStoresPanel.topItem:refreshData(retailShopDataInfo.info,function()
            self:_clickCloseBtn(self)
        end)
    end

    --判断是自己还是别人打开了界面
    if retailShopDataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
    else
        self.m_data.isOther = false
    end
    if self.groupMgr == nil then
        if retailShopDataInfo.info.state == "OPERATE" then
            RetailStoresPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            self.groupMgr = BuildingInfoMainGroupMgr:new(RetailStoresPanel.groupTrans, self.retailStoresBehaviour)
            if self.m_data.isOther then
                self.groupMgr:AddParts(BuildingShelfPart,1)
                self.groupMgr:AddParts(TurnoverPart,0)
                self.groupMgr:AddParts(BuildingSalaryPart,0)
                --self.groupMgr:AddParts(BuildingSignPart,0.5)
                self.groupMgr:AddParts(BuildingWarehousePart,0)
                RetailStoresPanel.bubbleMessageBtn.transform.localScale = Vector3.zero
            else
                self.groupMgr:AddParts(BuildingShelfPart,0.25)
                self.groupMgr:AddParts(TurnoverPart,0.25)
                self.groupMgr:AddParts(BuildingSalaryPart,0.25)
                --self.groupMgr:AddParts(BuildingSignPart,0.2)
                self.groupMgr:AddParts(BuildingWarehousePart,0.25)
                RetailStoresPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            end
            RetailStoresPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else
            RetailStoresPanel.bubbleMessageBtn.transform.localScale = Vector3.zero
            RetailStoresPanel.groupTrans.localScale = Vector3.zero
            if self.groupMgr ~= nil then
                self.groupMgr:TurnOffAllOptions()
            end
        end
    else
        if retailShopDataInfo.info.state == "OPERATE" then
            RetailStoresPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
        else
            RetailStoresPanel.groupTrans.localScale = Vector3.zero
            self.groupMgr:TurnOffAllOptions()
        end
    end
end
function RetailStoresCtrl:_openBubbleMessage(go)
    PlayMusEff(1002)
    if go.m_data.info.id then
        ct.OpenCtrl("BubbleMessageCtrl", go.m_data.info.id)
    end
end
function RetailStoresCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts

        if self.groupMgr == nil then
            self.groupMgr = BuildingInfoMainGroupMgr:new(RetailStoresPanel.groupTrans, self.retailStoresBehaviour)
            self.groupMgr:AddParts(BuildingShelfPart,0.25)
            self.groupMgr:AddParts(TurnoverPart,0.25)
            self.groupMgr:AddParts(BuildingSalaryPart,0.25)
            --self.groupMgr:AddParts(BuildingSignPart,0.2)
            self.groupMgr:AddParts(BuildingWarehousePart,0.25)
            RetailStoresPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            RetailStoresPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:TurnOffAllOptions()
        end
        self.groupMgr:RefreshData(self.m_data)
    end
end

function RetailStoresCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function RetailStoresCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end
--关闭显示
function RetailStoresCtrl:_selfCloseSign()
    self.m_data.contractInfo.isOpen = false
    self.m_data.contractInfo.price = nil
    self.m_data.contractInfo.hours = nil
    self.groupMgr:RefreshData(self.m_data)
end
--开启/调整签约
function RetailStoresCtrl:_changeSignInfo(data)
    self.m_data.contractInfo.isOpen = true
    self.m_data.contractInfo.price = data.price
    self.m_data.contractInfo.hours = data.hours
    self.groupMgr:RefreshData(self.m_data)
end
--自己取消自己的签约
function RetailStoresCtrl:_selfCancelSign()
    self.m_data.contractInfo.isOpen = false
    self.m_data.contractInfo.price = nil
    self.m_data.contractInfo.hours = nil
    self.m_data.contractInfo.contract = nil
    self.groupMgr:RefreshData(self.m_data)
end
--签约成功
function RetailStoresCtrl:_signSuccess(data)
    self.m_data.contractInfo.contract = data
    self.groupMgr:RefreshData(self.m_data)
end
--营收曲线
function RetailStoresCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end
----更改名字
--function RetailStoresCtrl:OnClick_changeName(ins)
--    PlayMusEff(1002)
--    local data = {}
--    data.titleInfo = "RENAME"
--    data.tipInfo = "Modified every seven days"
--    data.btnCallBack = function(name)
--        DataManager.DetailModelRpcNoRet(ins.m_data.info.id, 'm_ReqChangeMaterialName', ins.m_data.info.id, name)
--        ins:_updateName(name)
--    end
--    ct.OpenCtrl("InputDialogPageCtrl", data)
--end
----更改名字成功
--function RetailStoresCtrl:_updateName(name)
--    RetailStoresPanel.nameText.text = name
--end
function RetailStoresCtrl:Hide()
    UIPanel.Hide(self)
    --Event.RemoveListener("c_BuildingTopChangeData",self._changeItemData,self)
    Event.RemoveListener("c_Revenue",self.c_Revenue,self)
end

function RetailStoresCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    --关闭原料厂推送
    Event.Brocast("m_ReqCloseMaterial",self.m_data.insId)
    --关闭当前建筑Model
    DataManager.CloseDetailModel(self.m_data.insId)
    self.m_data = nil
    RevenueDetailsMsg.close()
    UIPanel.ClosePage()
end
