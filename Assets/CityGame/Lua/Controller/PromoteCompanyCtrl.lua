---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/29 10:28
---推广公司ctrl
PromoteCompanyCtrl = class('PromoteCompanyCtrl',UIPanel)
UIPanel:ResgisterOpen(PromoteCompanyCtrl)

local promoteBehaviour
local myOwnerID
function PromoteCompanyCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PromoteCompanyPanel.prefab"
end

function PromoteCompanyCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function PromoteCompanyCtrl:Awake()
    promoteBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    --promoteBehaviour:AddClick(PromoteCompanyPanel.back,self.OnBack,self)
    promoteBehaviour:AddClick(PromoteCompanyPanel.queue,self.OnQueue,self)
    promoteBehaviour:AddClick(PromoteCompanyPanel.open,self.OnOpen,self)
    self:initData()
    myOwnerID = DataManager.GetMyOwnerID()      --自己的唯一id
end

function PromoteCompanyCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_Revenue",self.c_Revenue,self)

    PromoteCompanyPanel.queneText.text = GetLanguage(27010008)
end

function PromoteCompanyCtrl:Refresh()
    DataManager.OpenDetailModel(PromoteCompanyModel,self.m_data.insId)
    RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_detailPublicFacility',self.m_data.insId)
end

function PromoteCompanyCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_Revenue",self.c_Revenue,self)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    RevenueDetailsMsg.close()
end

function PromoteCompanyCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function PromoteCompanyCtrl:initData()

end

--返回
function PromoteCompanyCtrl:OnBack()
    UIPanel.ClosePage()
end

--建筑个性签名
function PromoteCompanyCtrl:OnOpen(go)
    PlayMusEff(1002)
    ct.OpenCtrl("BubbleMessageCtrl",go.m_data.insId)
end

--点击队列
function PromoteCompanyCtrl:OnQueue(go)
    PlayMusEff(1002)
        if go.m_data.info.ownerId == myOwnerID then
           DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_QueryPromote',go.m_data.insId,true)
        else
           DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_QueryPromote',go.m_data.insId,false)
        end

end

--建筑详情回调
function PromoteCompanyCtrl:_receivePromoteCompanyDetailInfo(detailData)
    detailData.info.buildingType = BuildingType.Municipal
    if PromoteCompanyPanel.topItem ~= nil then
        PromoteCompanyPanel.topItem:refreshData(detailData.info, function ()
            self:OnBack(self)
        end)
    end
    local insId = self.m_data.insId
    self.m_data = detailData
    self.m_data.insId = insId  --temp
    PromoteCompanyPanel.queneValue.text = self.m_data.selledPromCount
    if self.groupMgr == nil then
        if detailData.info.state == "OPERATE" then -- 营业中
            self.groupMgr = BuildingInfoMainGroupMgr:new(PromoteCompanyPanel.groupTrans, promoteBehaviour)
            if self.m_data.info.ownerId == myOwnerID then
                self.groupMgr:AddParts(AdvertisementPart, 0.374)
                self.groupMgr:AddParts(TurnoverPart, 0.313)
                self.groupMgr:AddParts(BuildingSalaryPart, 0.313)
                --self.groupMgr:AddParts(AdBuildingSignPart, 0.24)
                PromoteCompanyPanel.open.transform.localScale = Vector3.one
            else
                self.groupMgr:AddParts(AdvertisementPart, 1)
                self.groupMgr:AddParts(TurnoverPart, 0)
                self.groupMgr:AddParts(BuildingSalaryPart, 0)
                --self.groupMgr:AddParts(AdBuildingSignPart, 0)
                PromoteCompanyPanel.open.transform.localScale = Vector3.zero
            end
            PromoteCompanyPanel.groupTrans.localScale = Vector3.one
            PromoteCompanyPanel.queue.transform.localScale = Vector3.one
            PromoteCompanyPanel.open.transform.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else -- 未营业
            PromoteCompanyPanel.groupTrans.localScale = Vector3.zero
            PromoteCompanyPanel.queue.transform.localScale = Vector3.zero
            PromoteCompanyPanel.open.transform.localScale = Vector3.zero
        end
    else

        self.groupMgr:RefreshData(self.m_data)
    end
    PromoteCompanyPanel.openBusinessItem:initData(detailData.info,BuildingType.Municipal)      --开业
    --历史记录测试
    UnitTest.Exec_now("abel_0426_AbilityHistory", "e_AbilityHistory",self.m_data.insId)
    --人流量签约列表测试
    UnitTest.Exec_now("abel_0428_queryflowList", "e_queryflowList",self.m_data.insId)
end

--推广能力回调
function PromoteCompanyCtrl:_queryPromoCurAbilitys(info)
    if info.CurAbilitys == nil then
        return
    end
    for i, v in pairs(info.CurAbilitys) do
        GoodsTypeConfig[i].capacity = v
    end
    if info.typeIds[1] == 1300 or info.typeIds[1] == 1400 then
        Event.Brocast("c_PromoteBuildingCapacity",info.CurAbilitys)
        return
    else
      Event.Brocast("c_PromoteCapacity")
    end
end

--员工工资改变
function PromoteCompanyCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", GetLanguage(26020007), 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts

        if self.groupMgr == nil then
            self.groupMgr = BuildingInfoMainGroupMgr:new(PromoteCompanyPanel.groupTrans, promoteBehaviour)
            self.groupMgr:AddParts(AdvertisementPart, 0.374)
            self.groupMgr:AddParts(TurnoverPart, 0.313)
            self.groupMgr:AddParts(BuildingSalaryPart, 0.313)
            --self.groupMgr:AddParts(AdBuildingSignPart, 0.23)
            PromoteCompanyPanel.groupTrans.localScale = Vector3.one
            PromoteCompanyPanel.queue.transform.localScale = Vector3.one
            PromoteCompanyPanel.open.transform.localScale = Vector3.one
            self.groupMgr:TurnOffAllOptions()
        end
        self.groupMgr:RefreshData(self.m_data)
    end
end

--今日营业额
function PromoteCompanyCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end
