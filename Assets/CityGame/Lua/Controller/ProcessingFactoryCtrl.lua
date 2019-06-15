---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/4/11 14:57
---
-----

ProcessingFactoryCtrl = class('ProcessingFactoryCtrl',UIPanel)
UIPanel:ResgisterOpen(ProcessingFactoryCtrl) --注册打开的方法

local this
--构建函数
function ProcessingFactoryCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ProcessingFactoryCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ProcessingFactoryPanel.prefab";
end

function ProcessingFactoryCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function ProcessingFactoryCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.processingBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    --self.processingBehaviour:AddClick(ProcessingFactoryPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    --self.processingBehaviour:AddClick(ProcessingFactoryPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);
    self.processingBehaviour:AddClick(ProcessingFactoryPanel.bubbleMessageBtn, self._openBubbleMessage, self)


end
function ProcessingFactoryCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_Revenue",self.c_Revenue,self)
end
function ProcessingFactoryCtrl:Refresh()
    RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
    this:initializeData()
end

function ProcessingFactoryCtrl:initializeData()
    if self.m_data then
        --向服务器请求建筑详情
        DataManager.OpenDetailModel(ProcessingFactoryModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenprocessing',self.m_data.insId)
    end
end

--刷新原料厂信息
function ProcessingFactoryCtrl:refreshprocessingDataInfo(processingDataInfo)
    --初始化
    ProcessingFactoryPanel.openBusinessItem:initData(processingDataInfo.info, BuildingType.ProcessingFactory)
    local insId = self.m_data.insId
    self.m_data = processingDataInfo
    self.m_data.insId = insId
    self.m_data.buildingType = BuildingType.ProcessingFactory
    processingDataInfo.info.buildingType = BuildingType.ProcessingFactory

    if ProcessingFactoryPanel.topItem ~= nil then
        ProcessingFactoryPanel.topItem:refreshData(processingDataInfo.info,function()
            self:_clickCloseBtn(self)
        end)
    end

    --判断是自己还是别人打开了界面
    if processingDataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
    else
        self.m_data.isOther = false
    end
    if self.groupMgr == nil then
        if processingDataInfo.info.state == "OPERATE" then
            ProcessingFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            self.groupMgr = BuildingInfoMainGroupMgr:new(ProcessingFactoryPanel.groupTrans, self.processingBehaviour)
            if self.m_data.isOther then
                self.groupMgr:AddParts(BuildingShelfPart,1)
                self.groupMgr:AddParts(TurnoverPart,0)
                self.groupMgr:AddParts(BuildingSalaryPart,0)
                self.groupMgr:AddParts(BuildingProductionPart,0)
                self.groupMgr:AddParts(BuildingWarehousePart,0)
                ProcessingFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.zero
            else
                self.groupMgr:AddParts(BuildingShelfPart,0.2)
                self.groupMgr:AddParts(TurnoverPart,0.2)
                self.groupMgr:AddParts(BuildingSalaryPart,0.2)
                self.groupMgr:AddParts(BuildingProductionPart,0.2)
                self.groupMgr:AddParts(BuildingWarehousePart,0.2)
                ProcessingFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            end
            ProcessingFactoryPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else
            ProcessingFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.zero
            ProcessingFactoryPanel.groupTrans.localScale = Vector3.zero
            if self.groupMgr ~= nil then
                self.groupMgr:TurnOffAllOptions()
            end
        end
    else
        if processingDataInfo.info.state == "OPERATE" then
            ProcessingFactoryPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
        else
            ProcessingFactoryPanel.groupTrans.localScale = Vector3.zero
            self.groupMgr:TurnOffAllOptions()
        end
    end
end
function ProcessingFactoryCtrl:_openBubbleMessage(go)
    PlayMusEff(1002)
    if go.m_data.info.id then
        ct.OpenCtrl("BubbleMessageCtrl", go.m_data.info)
    end
end
function ProcessingFactoryCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", ReminderType.Succeed)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts

        if self.groupMgr == nil then
            self.groupMgr = BuildingInfoMainGroupMgr:new(ProcessingFactoryPanel.groupTrans, self.processingBehaviour)
            self.groupMgr:AddParts(BuildingShelfPart,0.2)
            self.groupMgr:AddParts(TurnoverPart,0.2)
            self.groupMgr:AddParts(BuildingSalaryPart,0.2)
            self.groupMgr:AddParts(BuildingProductionPart,0.2)
            self.groupMgr:AddParts(BuildingWarehousePart,0.2)
            ProcessingFactoryPanel.groupTrans.localScale = Vector3.one
            ProcessingFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            self.groupMgr:TurnOffAllOptions()
        end
        self.groupMgr:RefreshData(self.m_data)
    end
end

function ProcessingFactoryCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function ProcessingFactoryCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end

function ProcessingFactoryCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end

function ProcessingFactoryCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_Revenue",self.c_Revenue,self)
end

function ProcessingFactoryCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    --关闭加工厂推送
    Event.Brocast("m_ReqCloseprocessing",self.m_data.insId)
    --关闭当前建筑Model
    DataManager.CloseDetailModel(self.m_data.insId)
    self.m_data = nil
    RevenueDetailsMsg.close()
    UIPanel.ClosePage()
end
