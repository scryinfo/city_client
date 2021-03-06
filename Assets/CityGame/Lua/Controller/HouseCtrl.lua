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
    self.houseBehaviour:AddClick(HousePanel.bubbleMessageBtn.gameObject, self._openBubbleMessage, self)
end

function HouseCtrl:Refresh()
    HousePanel.bubbleMessageBtn.localScale = Vector3.zero
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


--After creating a building, each building will store basic data, such as id
function HouseCtrl:_initData()
    if self.m_data then
        --Request building details from the server
        DataManager.OpenDetailModel(HouseModel,self.m_data.insId)
        RevenueDetailsMsg.m_getPrivateBuildingCommonInfo(self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqHouseDetailInfo',self.m_data.insId)
    end
end

--

function HouseCtrl:_receiveHouseDetailInfo(houseDetailData)
    houseDetailData.info.buildingType = BuildingType.House
    if HousePanel.topItem ~= nil then
        HousePanel.topItem:refreshData(houseDetailData.info, function ()
            self:_clickCloseBtn(self)
        end)
    end
    HousePanel.openBusinessItem:initData(houseDetailData.info, BuildingType.House)  --initialization
    houseDetailData.info.buildingType = BuildingType.House

    local insId = self.m_data.insId
    self.m_data = houseDetailData
    self.m_data.insId = insId  --temp

    if houseDetailData.info.ownerId ~= DataManager.GetMyOwnerID() then  --Determine if you or someone else has opened the interface
        self.m_data.isOther = true
        HousePanel.bubbleMessageBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        if houseDetailData.info.state == "OPERATE" then
            HousePanel.bubbleMessageBtn.localScale = Vector3.one
        else
            HousePanel.bubbleMessageBtn.localScale = Vector3.zero
        end
    end
    if self.groupMgr == nil then
        if houseDetailData.info.state == "OPERATE" then --in operation
            self.groupMgr = BuildingInfoMainGroupMgr:new(HousePanel.groupTrans, self.houseBehaviour)
            if self.m_data.isOther then -- other people
                self.groupMgr:AddParts(BuildingRentPart, 1)
                --self.groupMgr:AddParts(BuildingSignPart, 0)
                self.groupMgr:AddParts(TurnoverPart, 0)
                self.groupMgr:AddParts(BuildingSalaryPart, 0)
            else
                self.groupMgr:AddParts(BuildingRentPart, 0.3333)
                self.groupMgr:AddParts(TurnoverPart, 0.3333)
                self.groupMgr:AddParts(BuildingSalaryPart, 0.3334)
                --self.groupMgr:AddParts(BuildingSignPart, 0.25)

            end
            HousePanel.groupTrans.localScale = Vector3.one
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else -- Closed
            HousePanel.groupTrans.localScale = Vector3.zero
        end
    else
        self.groupMgr:RefreshData(self.m_data)
    end
end

--Click the Open button method
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
        self.groupMgr:TurnOffAllOptions()
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
    self.m_data = nil
    UIPanel.ClosePage()
end

function HouseCtrl:_openBubbleMessage(go)
    PlayMusEff(1002)
    if go.m_data.info.id then
        ct.OpenCtrl("BubbleMessageCtrl", go.m_data.info)
    end
end

--
function HouseCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", GetLanguage(26020007), 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts

        if self.groupMgr == nil then
            self.groupMgr = BuildingInfoMainGroupMgr:new(HousePanel.groupTrans, self.houseBehaviour)
            self.groupMgr:AddParts(BuildingRentPart, 0.3333)
            self.groupMgr:AddParts(TurnoverPart, 0.3333)
            self.groupMgr:AddParts(BuildingSalaryPart, 0.3334)
            --self.groupMgr:AddParts(BuildingSignPart, 0.25)
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
            Event.Brocast("SmallPop", GetLanguage(26040003), 300)
        end
        self.m_data.rent = data.rent
        self.groupMgr:RefreshData(self.m_data)
    end
end
--Close display
function HouseCtrl:_selfCloseSign()
    self.m_data.contractInfo.isOpen = false
    self.m_data.contractInfo.price = nil
    self.m_data.contractInfo.hours = nil
    self.groupMgr:RefreshData(self.m_data)
end
--Open/adjust contract
function HouseCtrl:_changeSignInfo(data)
    self.m_data.contractInfo.isOpen = true
    self.m_data.contractInfo.price = data.price
    self.m_data.contractInfo.hours = data.hours
    self.groupMgr:RefreshData(self.m_data)
end
--Cancel your own contract
function HouseCtrl:_selfCancelSign()
    self.m_data.contractInfo.isOpen = false
    self.m_data.contractInfo.price = nil
    self.m_data.contractInfo.hours = nil
    self.m_data.contractInfo.contract = nil
    self.groupMgr:RefreshData(self.m_data)
end
--Signed successfully
function HouseCtrl:_signSuccess(data)
    self.m_data.contractInfo.contract = data
    self.groupMgr:RefreshData(self.m_data)
end
--
function HouseCtrl:c_Revenue(info)
    TurnoverPart:_initFunc(info)
    TurnoverDetailPart:_setValue(info)
end
--Competitiveness
function HouseCtrl:_getApartmentGuidePrice(data)
    --BuildingRentPartDetail:_getGuidePrice(data)  --rent needed
    Event.Brocast("c_getHouseGuidePrice", data)
end