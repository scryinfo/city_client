---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/16 10:29
---
LaboratoryCtrl = class('LaboratoryCtrl',UIPanel)
UIPanel:ResgisterOpen(LaboratoryCtrl)

---====================================================================================框架函数==============================================================================================
function LaboratoryCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

--启动事件--
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
    self.luaBehaviour:AddClick(panel.stopIconBtn.gameObject, self._openBuildingBtnFunc, self)
end

function LaboratoryCtrl:Hide()
    UIPanel.Hide(self)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
end

function LaboratoryCtrl:Close()
    UIPanel.Close(self)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
end
---===================================================================================点击函数==============================================================================================

--点击中间按钮的方法
function LaboratoryCtrl:_centerBtnFunc(ins)
    if DataManager.GetMyOwnerID() ~= ins.m_data.info.ownerId then
        return
    end
    ct.OpenCtrl("BubbleMessageCtrl",ins.m_data.insId)
end
--点击开业按钮方法
function LaboratoryCtrl:_openBuildingBtnFunc(ins)
    if ins.m_data then
        Event.Brocast("c_beginBuildingInfo", ins.m_data.info, function()
            DataManager.DetailModelRpcNoRet(ins.m_data.insId, 'm_ReqLaboratoryDetailInfo', false)
        end)
    end
end
---返回
function LaboratoryCtrl:_backBtn(ins)
    if ins.laboratoryToggleGroup ~= nil then
        ins.laboratoryToggleGroup:cleanItems()
    end
    ins.hasOpened = false
    --关闭界面时再发一遍详情
    DataManager.DetailModelRpcNoRet(ins.m_data.insId, 'mReqCloseRetailStores')
    UIPanel.ClosePage()
end
---===================================================================================业务逻辑==============================================================================================

--创建好建筑之后，每个建筑会存基本数据，比如id
function LaboratoryCtrl:_initData()
    --请求建筑详情
    DataManager.OpenDetailModel(LaboratoryModel, self.m_data.insId)
    LaboratoryCtrl.static.insId= self.m_data.insId
    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqLaboratoryDetailInfo')
end

function LaboratoryCtrl:_receiveLaboratoryDetailInfo(buildingInfo)
    if panel.topItem ~= nil then
        panel.topItem:refreshData(buildingInfo.info, function ()
            self:_clickCloseBtn(self)
        end)
    end

    LaboratoryCtrl.static.buildingOwnerId = buildingInfo.info.ownerId
    self.m_data=buildingInfo
    buildingInfo.insId=buildingInfo.info.id
    local info=buildingInfo.info
    panel.openBusinessItem:initData(info,BuildingType.Laboratory)
    --开业停业
    Event.Brocast("c_GetBuildingInfo", info)
    if info.state == "OPERATE" then
        panel.stopRootTran.localScale = Vector3.zero
    else
        panel.stopRootTran.localScale = Vector3.one
    end
    --判断是自己还是别人打开了界面
    if info.ownerId ~= DataManager.GetMyOwnerID() then
        self:other(buildingInfo)
    else
        self:owner(buildingInfo)
    end
end

function LaboratoryCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts
        self.groupMgr:RefreshData(self.m_data)
    end
end
--自已
function LaboratoryCtrl:owner(buildingInfo)
    --刷新底部组件s
    if self.groupMgr == nil then

        self.groupMgr = BuildingInfoMainGroupMgr:new(panel.mainGroup, self.luaBehaviour)

        self.groupMgr:AddParts(ResearchPart,0.33)
        self.groupMgr:AddParts(TurnoverPart,0.33)
        self.groupMgr:AddParts(BuildingSalaryPart, 0.33)

        self.groupMgr:RefreshData(buildingInfo)
        self.groupMgr:TurnOffAllOptions()
    else
        self.groupMgr:RefreshData(buildingInfo)
    end
end
--他人
function LaboratoryCtrl:other(buildingInfo)
    --刷新底部组件
    if self.groupMgr == nil then

        self.groupMgr = BuildingInfoMainGroupMgr:new(panel.mainGroup, self.luaBehaviour)
        self.groupMgr:AddParts(ResearchPart,1)
        self.groupMgr:RefreshData(buildingInfo)
        self.groupMgr:TurnOffAllOptions()
    else
        self.groupMgr:RefreshData(buildingInfo)
    end
end

function LaboratoryCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    self.m_data = nil
    UIPanel.ClosePage()
end
