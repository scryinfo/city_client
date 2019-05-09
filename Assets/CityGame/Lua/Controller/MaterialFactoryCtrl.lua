---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/11 14:57
---
-----

MaterialFactoryCtrl = class('MaterialFactoryCtrl',UIPanel)
UIPanel:ResgisterOpen(MaterialFactoryCtrl) --注册打开的方法

local this
--构建函数
function MaterialFactoryCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function MaterialFactoryCtrl:bundleName()
    return "Assets/CityGame/Resources/View/MaterialFactoryPanel.prefab";
end

function MaterialFactoryCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function MaterialFactoryCtrl:Awake(go)
    this = self
    self.gameObject = go;
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    --self.materialBehaviour:AddClick(MaterialFactoryPanel.buildInfo.gameObject,self.OnClick_buildInfo,self);
    --self.materialBehaviour:AddClick(MaterialFactoryPanel.stopIconRoot.gameObject,self.OnClick_prepareOpen,self);
    self.materialBehaviour:AddClick(MaterialFactoryPanel.bubbleMessageBtn, self._openBubbleMessage, self)

end
function MaterialFactoryCtrl:Active()
    UIPanel.Active(self)
    --Event.AddListener("c_BuildingTopChangeData",self._changeItemData,self)
    Event.AddListener("c_Revenue",self.c_Revenue,self)
end
function MaterialFactoryCtrl:Refresh()
    RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
    this:initializeData()
end

function MaterialFactoryCtrl:initializeData()
    if self.m_data then
        --向服务器请求建筑详情
        DataManager.OpenDetailModel(MaterialFactoryModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqOpenMaterial',self.m_data.insId)
    end
end

--刷新原料厂信息
function MaterialFactoryCtrl:refreshMaterialDataInfo(materialDataInfo)
    if MaterialFactoryPanel.topItem ~= nil then
        MaterialFactoryPanel.topItem:refreshData(materialDataInfo.info,function()
            self:_clickCloseBtn(self)
        end)
    end
    --初始化
    --MaterialFactoryPanel.openBusinessItem:initData(materialDataInfo.info, BuildingType.MaterialFactory)
    MaterialFactoryPanel.openBusinessItem:initData(materialDataInfo.info, BuildingType.MaterialFactory)  --初始化
    local insId = self.m_data.insId
    self.m_data = materialDataInfo
    self.m_data.insId = insId
    self.m_data.buildingType = BuildingType.MaterialFactory

    --判断是自己还是别人打开了界面
    if materialDataInfo.info.ownerId ~= DataManager.GetMyOwnerID() then
        self.m_data.isOther = true
    else
        self.m_data.isOther = false
    end
    if self.groupMgr == nil then
        if materialDataInfo.info.state == "OPERATE" then
            MaterialFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            self.groupMgr = BuildingInfoMainGroupMgr:new(MaterialFactoryPanel.groupTrans, self.materialBehaviour)
            if self.m_data.isOther then
                self.groupMgr:AddParts(BuildingShelfPart,1)
                self.groupMgr:AddParts(TurnoverPart,0)
                self.groupMgr:AddParts(BuildingSalaryPart,0)
                self.groupMgr:AddParts(BuildingProductionPart,0)
                self.groupMgr:AddParts(BuildingWarehousePart,0)
                MaterialFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.zero
            else

                self.groupMgr:AddParts(BuildingShelfPart,0.2)
                self.groupMgr:AddParts(TurnoverPart,0.2)
                self.groupMgr:AddParts(BuildingSalaryPart,0.2)
                self.groupMgr:AddParts(BuildingProductionPart,0.2)
                self.groupMgr:AddParts(BuildingWarehousePart,0.2)
                MaterialFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.one

            end
            MaterialFactoryPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else
            MaterialFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.zero
            MaterialFactoryPanel.groupTrans.localScale = Vector3.zero
            if self.groupMgr ~= nil then
                self.groupMgr:TurnOffAllOptions()
            end
        end
    else
        if materialDataInfo.info.state == "OPERATE" then
            MaterialFactoryPanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
        else
            MaterialFactoryPanel.groupTrans.localScale = Vector3.zero
            self.groupMgr:TurnOffAllOptions()
        end
    end
end
function MaterialFactoryCtrl:_openBubbleMessage(go)
    PlayMusEff(1002)
    if go.m_data.info.id then
        ct.OpenCtrl("BubbleMessageCtrl", go.m_data.info.id)
    end
end
function MaterialFactoryCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts

        if self.groupMgr == nil then
            self.groupMgr = BuildingInfoMainGroupMgr:new(MaterialFactoryPanel.groupTrans, self.materialBehaviour)
            self.groupMgr:AddParts(BuildingShelfPart,0.2)
            self.groupMgr:AddParts(TurnoverPart,0.2)
            self.groupMgr:AddParts(BuildingSalaryPart,0.2)
            self.groupMgr:AddParts(BuildingProductionPart,0.2)
            self.groupMgr:AddParts(BuildingWarehousePart,0.2)
            MaterialFactoryPanel.groupTrans.localScale = Vector3.one
            MaterialFactoryPanel.bubbleMessageBtn.transform.localScale = Vector3.one
            self.groupMgr:TurnOffAllOptions()
        end
        self.groupMgr:RefreshData(self.m_data)
    end
end

function MaterialFactoryCtrl:OnClick_buildInfo(ins)
    PlayMusEff(1002)
    Event.Brocast("c_openBuildingInfo",ins.m_data.info)
end
function MaterialFactoryCtrl:OnClick_prepareOpen(ins)
    PlayMusEff(1002)
    Event.Brocast("c_beginBuildingInfo",ins.m_data.info,ins.Refresh)
end
--更改名字
function MaterialFactoryCtrl:OnClick_changeName(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = "RENAME"
    data.tipInfo = "Modified every seven days"
    data.btnCallBack = function(name)
        DataManager.DetailModelRpcNoRet(ins.m_data.info.id, 'm_ReqChangeMaterialName', ins.m_data.info.id, name)
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
--更改名字成功
function MaterialFactoryCtrl:_updateName(name)
    MaterialFactoryPanel.nameText.text = name
end

function MaterialFactoryCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end

function MaterialFactoryCtrl:Hide()
    UIPanel.Hide(self)
    --Event.RemoveListener("c_BuildingTopChangeData",self._changeItemData,self)
    Event.RemoveListener("c_Revenue",self.c_Revenue,self)
end
--更改基础建筑信息
--function MaterialFactoryCtrl:_changeItemData(data)
--    if data ~= nil and MaterialFactoryPanel.topItem ~= nil then
--        MaterialFactoryPanel.topItem:changeItemData(data)
--    end
--end
--
function MaterialFactoryCtrl:_clickCloseBtn()
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
