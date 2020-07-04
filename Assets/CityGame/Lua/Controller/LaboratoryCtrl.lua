---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/16 10:29
---Research Institute ctrl
LaboratoryCtrl = class('LaboratoryCtrl',UIPanel)
UIPanel:ResgisterOpen(LaboratoryCtrl)

---====================================================================================Frame function==============================================================================================
function LaboratoryCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

--Start event--
function LaboratoryCtrl:OnCreate(go)
    UIPanel.OnCreate(self,go)
end
function LaboratoryCtrl:bundleName()
    return "Assets/CityGame/Resources/View/LaboratoryPanel.prefab"
end
local this,panel
function LaboratoryCtrl:Refresh()
    this:_initData()
end
panel=LaboratoryPanel
function LaboratoryCtrl:Awake(go)
    this = self
    self.luaBehaviour= self.gameObject:GetComponent('LuaBehaviour')
    --self.luaBehaviour:AddClick(panel.changeNameBtn.gameObject, self._changeName, self)

    self.luaBehaviour:AddClick(panel.centerBtn.gameObject, self._centerBtnFunc, self)
    --    self.luaBehaviour:AddClick(panel.stopIconBtn.gameObject, self._openBuildingBtnFunc, self)

    Event.AddListener("c_Revenue",self.c_Revenue,self)
end

function LaboratoryCtrl:Hide()
    UIPanel.Hide(self)
    if self.groupMgr ~= nil then
        self.groupMgr:TurnOffAllOptions()
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    RevenueDetailsMsg.close()
end
---===================================================================================Click function==============================================================================================

--Click the middle button
function LaboratoryCtrl:_centerBtnFunc(ins)
    if DataManager.GetMyOwnerID() ~= ins.m_data.info.ownerId then
        return
    end
    ct.OpenCtrl("BubbleMessageCtrl",ins.m_data.info)
end
--Click the Open button method
function LaboratoryCtrl:_openBuildingBtnFunc(ins)
    if ins.m_data then
        Event.Brocast("c_beginBuildingInfo", ins.m_data.info, function()
            DataManager.DetailModelRpcNoRet(ins.m_data.insId, 'm_ReqLaboratoryDetailInfo', false)
        end)
    end
end
---return
function LaboratoryCtrl:_backBtn(ins)
    if ins.laboratoryToggleGroup ~= nil then
        ins.laboratoryToggleGroup:cleanItems()
    end
    ins.hasOpened = false
    --Send the details again when closing the interface
    DataManager.DetailModelRpcNoRet(ins.m_data.insId, 'mReqCloseRetailStores')
    UIPanel.ClosePage()
end
---===================================================================================Business logic==============================================================================================

--After creating a building, each building will store basic data, such as id
function LaboratoryCtrl:_initData()
    --Request building details
    DataManager.OpenDetailModel(LaboratoryModel, self.m_data.insId)
    RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
    LaboratoryCtrl.static.insId= self.m_data.insId
    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqLaboratoryDetailInfo')
end

function LaboratoryCtrl:_receiveLaboratoryDetailInfo(buildingInfo)
    if panel.topItem ~= nil then
        panel.topItem:refreshData(buildingInfo.info, function ()
            self:_clickCloseBtn(self)
        end)
    end
    buildingInfo.info.buildingType = BuildingType.Laboratory
    LaboratoryCtrl.static.buildingOwnerId = buildingInfo.info.ownerId
    self.m_data=buildingInfo
    buildingInfo.insId=buildingInfo.info.id
    local info=buildingInfo.info
    panel.openBusinessItem:initData(info,BuildingType.Laboratory)
    --Opening and closing information
    Event.Brocast("c_GetBuildingInfo", info)
    if info.state == "OPERATE" then
        LaboratoryPanel.mainGroup.localScale = Vector3.one
        --Determine if you or someone else has opened the interface
        if info.ownerId ~= DataManager.GetMyOwnerID() then
            self:other(buildingInfo)
        else
            self:owner(buildingInfo)
        end
    else
        panel.groupTrans.localScale = Vector3.zero
        LaboratoryPanel.centerBtn.localScale = Vector3.zero
    end

end

--Set up for business
function LaboratoryCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        panel.groupTrans.localScale = Vector3.one
        self:owner(self.m_data)
    end
end

--Yourself (add the bottom three components)
function LaboratoryCtrl:owner(buildingInfo)
    --Refresh the bottom component
    LaboratoryPanel.centerBtn.localScale = Vector3.one
    if self.groupMgr == nil then
        self.groupMgr = BuildingInfoMainGroupMgr:new(panel.mainGroup, self.luaBehaviour)
        self.groupMgr:AddParts(ResearchPart,1/3)
        self.groupMgr:AddParts(TurnoverPart,1/3)
        self.groupMgr:AddParts(BuildingSalaryPart, 1/3)

        self.groupMgr:TurnOffAllOptions()
        self.groupMgr:RefreshData(buildingInfo)
    else
        self.groupMgr:RefreshData(buildingInfo)
    end
end

--Others (add a component at the bottom)
function LaboratoryCtrl:other(buildingInfo)
    --Refresh the bottom component
    LaboratoryPanel.centerBtn.localScale = Vector3.zero
    if self.groupMgr == nil then
        self.groupMgr = BuildingInfoMainGroupMgr:new(panel.mainGroup, self.luaBehaviour)
        self.groupMgr:AddParts(ResearchPart,1)
        self.groupMgr:AddParts(TurnoverPart,0)
        self.groupMgr:AddParts(BuildingSalaryPart,0)
        self.groupMgr:RefreshData(buildingInfo)
        self.groupMgr:TurnOffAllOptions()
    else
        self.groupMgr:RefreshData(buildingInfo)
    end
end

--Close button
function LaboratoryCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    if self.groupMgr ~= nil then
        self.groupMgr:TurnOffAllOptions()
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    self.m_data = nil
    UIPanel.ClosePage()
end

function LaboratoryCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end