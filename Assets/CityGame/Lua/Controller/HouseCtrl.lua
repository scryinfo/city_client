---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---
-----

HouseCtrl = class('HouseCtrl',UIPanel)
UIPanel:ResgisterOpen(HouseCtrl)

function HouseCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function HouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/HousePanel.prefab"
end

function HouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

local this
function HouseCtrl:Awake(go)
    this = self
    self.gameObject = go
    self.houseBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    --self.houseBehaviour:AddClick(HousePanel.centerBtn.gameObject, self._centerBtnFunc, self)
    --self.houseBehaviour:AddClick(HousePanel.stopIconBtn.gameObject, self._openBuildingBtnFunc, self)
    self.houseBehaviour:AddClick(HousePanel.bubbleMessageBtn, self._openBubbleMessage, self)
end

function HouseCtrl:Refresh()
    this:_initData()
end

function HouseCtrl:Active()
    UIPanel.Active(self)
    --Event.AddListener("c_BuildingTopChangeData", self._changeItemData, self)
    Event.AddListener("c_Revenue",self.c_Revenue,self)
end

function HouseCtrl:Hide()
    --Event.RemoveListener("c_BuildingTopChangeData", self._changeItemData, self)
    Event.RemoveListener("c_Revenue",self.c_Revenue,self)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    UIPanel.Hide(self)
    RevenueDetailsMsg.close()
end


--创建好建筑之后，每个建筑会存基本数据，比如id
function HouseCtrl:_initData()
    if self.m_data then
        --向服务器请求建筑详情
        DataManager.OpenDetailModel(HouseModel,self.m_data.insId)
        RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqHouseDetailInfo',self.m_data.insId)
    end
end

function HouseCtrl:_receiveHouseDetailInfo(houseDetailData)
    if HousePanel.topItem ~= nil then
        HousePanel.topItem:refreshData(houseDetailData.info, function ()
            self:_clickCloseBtn(self)
        end)
    end
    HousePanel.openBusinessItem:initData(houseDetailData.info, BuildingType.House)  --初始化

    local insId = self.m_data.insId
    self.m_data = houseDetailData
    self.m_data.insId = insId  --temp

    if houseDetailData.info.ownerId ~= DataManager.GetMyOwnerID() then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
    else
        self.m_data.isOther = false
    end
    if self.groupMgr == nil then
        if houseDetailData.info.state == "OPERATE" then -- 营业中
            self.groupMgr = BuildingInfoMainGroupMgr:new(HousePanel.groupTrans, self.houseBehaviour)
            if self.m_data.isOther then -- 别人
                self.groupMgr:AddParts(BuildingSignPart, 1)
                self.groupMgr:AddParts(BuildingRentPart, 0)
                self.groupMgr:AddParts(TurnoverPart, 0)
                self.groupMgr:AddParts(BuildingSalaryPart, 0)
            else
                self.groupMgr:AddParts(BuildingRentPart, 0.25)
                self.groupMgr:AddParts(TurnoverPart, 0.25)
                self.groupMgr:AddParts(BuildingSalaryPart, 0.25)
                self.groupMgr:AddParts(BuildingSignPart, 0.25)

            end
            HousePanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else -- 未营业
            HousePanel.groupTrans.localScale = Vector3.zero
        end
    else
        self.groupMgr:RefreshData(self.m_data)
    end
end

--点击开业按钮方法
function HouseCtrl:_openBuildingBtnFunc(ins)
    PlayMusEff(1002)
    if ins.m_data then
        Event.Brocast("c_beginBuildingInfo", ins.m_data.info, ins.Refresh)
    end
end
--
function HouseCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    self.m_data = nil
    UIPanel.ClosePage()
end

function HouseCtrl:_openBubbleMessage(go)
    PlayMusEff(1002)
    if go.m_data.info.id then
        ct.OpenCtrl("BubbleMessageCtrl", go.m_data.info.id)
    end
end

--
function HouseCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts

        if self.groupMgr == nil then
            self.groupMgr = BuildingInfoMainGroupMgr:new(HousePanel.groupTrans, self.houseBehaviour)
            self.groupMgr:AddParts(BuildingRentPart, 0.25)
            self.groupMgr:AddParts(TurnoverPart, 0.25)
            self.groupMgr:AddParts(BuildingSalaryPart, 0.25)
            self.groupMgr:AddParts(BuildingSignPart, 0.25)
            HousePanel.groupTrans.localScale = Vector3.one
            self.groupMgr:TurnOffAllOptions()
        end
        self.groupMgr:RefreshData(self.m_data)
    end
end
--
function HouseCtrl:_refreshRent(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置日租金成功", 300)
        end
        self.m_data.rent = data.rent
        self.groupMgr:RefreshData(self.m_data)
    end
end
--关闭显示
function HouseCtrl:_selfCloseSign()
    self.m_data.contractInfo.isOpen = false
    self.m_data.contractInfo.price = nil
    self.m_data.contractInfo.hours = nil
    self.groupMgr:RefreshData(self.m_data)
end
--开启/调整签约
function HouseCtrl:_changeSignInfo(data)
    self.m_data.contractInfo.isOpen = true
    self.m_data.contractInfo.price = data.price
    self.m_data.contractInfo.hours = data.hours
    self.groupMgr:RefreshData(self.m_data)
end
--自己取消自己的签约
function HouseCtrl:_selfCancelSign()
    self.m_data.contractInfo.isOpen = false
    self.m_data.contractInfo.price = nil
    self.m_data.contractInfo.hours = nil
    self.m_data.contractInfo.contract = nil
    self.groupMgr:RefreshData(self.m_data)
end
--签约成功
function HouseCtrl:_signSuccess(data)
    self.m_data.contractInfo.contract = data
    self.groupMgr:RefreshData(self.m_data)
end

function HouseCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end