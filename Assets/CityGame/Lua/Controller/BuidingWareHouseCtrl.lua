---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/4/12 16:37
---

--local this

BuidingWareHouseCtrl = class('BuidingWareHouseCtrl',UIPanel)
UIPanel:ResgisterOpen(BuidingWareHouseCtrl)

--
function BuidingWareHouseCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

--
function BuidingWareHouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/BuidingWareHousePanel.prefab"
end

--
function BuidingWareHouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

--
function BuidingWareHouseCtrl:Awake(go)
    self.gameObject = go
    self.houseBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.houseBehaviour:AddClick(BuidingWareHousePanel.closeBtn.gameObject, self._backFunc, self)
    self.houseBehaviour:AddClick(BuidingWareHousePanel.sentspaceBtn.gameObject, self._openFunc, self)
end

--
function BuidingWareHouseCtrl:Refresh()
    if self.m_data.insId then
        self.insId=self.m_data.insId
        DataManager.OpenDetailModel(BuidingWareHouseModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqHouseDetailInfo',self.m_data.insId)
    end
end

--
function BuidingWareHouseCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_BuildingTopChangeData",self._changeItemData,self)
end


--集散中心通用部件
function BuidingWareHouseCtrl:_initData(houseDetailInfo)
    BuidingWareHouseCtrl.static.insId = houseDetailInfo.insId
    if BuidingWareHousePanel.topItem ~= nil then
        BuidingWareHousePanel.topItem:refreshData(houseDetailInfo.info, function ()
            self:_clickCloseBtn(self)
        end)
    end

    local insId = self.m_data.insId
    self.m_data = houseDetailInfo
    self.m_data.insId = insId  --temp
    self.m_data.buildingType = BuildingType.WareHouse

    BuidingWareHousePanel.openBusinessItem:initData(houseDetailInfo.info, BuildingType.WareHouse)  --初始化
    BuidingWareHousePanel.spaceText.text = houseDetailInfo.rentCapacity
    BuidingWareHousePanel.priceText.text = houseDetailInfo.rent
    BuidingWareHousePanel.timeText.text  = houseDetailInfo.maxHourToRent

    if houseDetailInfo.info.ownerId ~= DataManager.GetMyOwnerID() then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
        if self.groupMgr == nil then                                    --非本人打开
            self.groupMgr = BuildingInfoMainGroupMgr:new(BuidingWareHousePanel.groupTrans, self.houseBehaviour)
            self.groupMgr:AddParts(BuildingSalaryPart,0)
            self.groupMgr:AddParts(BuildingShelfPart, 0.33)
            self.groupMgr:AddParts(TurnoverPart, 0.33)
            self.groupMgr:AddParts(BuildingWarehousePart, 0.34)
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else
            self.groupMgr:RefreshData(self.m_data)
        end
    else
        self.m_data.isOther = false
        if self.groupMgr == nil then                                   --本人打开
            self.groupMgr = BuildingInfoMainGroupMgr:new(BuidingWareHousePanel.groupTrans, self.houseBehaviour)
            self.groupMgr:AddParts(BuildingShelfPart, 0.25)
            self.groupMgr:AddParts(TurnoverPart, 0.25)
            self.groupMgr:AddParts(BuildingSalaryPart, 0.25)
            self.groupMgr:AddParts(BuildingWarehousePart, 0.25)
            self.groupMgr:RefreshData(self.m_data)
            self.groupMgr:TurnOffAllOptions()
        else
            self.groupMgr:RefreshData(self.m_data)
        end
    end
end

--
function BuidingWareHouseCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_BuildingTopChangeData",self._changeItemData,self)
    if self.groupMgr ~= nil then
        self.groupMgr:Destroy()
        self.groupMgr = nil
    end
end

--关闭界面
function BuidingWareHouseCtrl:_backFunc()
    UIPanel.ClosePage()
end

--更改基础建筑信息
function BuidingWareHouseCtrl:_changeItemData(data)
    if data ~= nil and BuidingWareHousePanel.topItem ~= nil then
        BuidingWareHousePanel.topItem:changeItemData(data)
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

function BuidingWareHouseCtrl:_refreshlary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts
        self.groupMgr:RefreshData(self.m_data)
    end
end

function BuidingWareHouseCtrl: _openFunc(data)
    if data.m_data.availableCapacity ~= nil then
        ct.OpenCtrl("MainRenTableWarehouseCtrl",data.m_data)
    else
        ct.OpenCtrl("SetRenTableWareHouseCtrl",data.m_data)
        BuidingWareHousePanel.spaceText.Text = "Not rentable"
    end
end

--更新UI显示数据
function BuidingWareHouseCtrl:_refreshRentInfo (rentWareHouseInfo)
    BuidingWareHousePanel.spaceText.text = rentWareHouseInfo.rentCapacity
    BuidingWareHousePanel.priceText.text = rentWareHouseInfo.rent
    BuidingWareHousePanel.timeText.text  = rentWareHouseInfo.maxHourToRent

    MainRenTableWarehousePanel.spaceText.text = rentWareHouseInfo.rentCapacity
    MainRenTableWarehousePanel.priceText.text = rentWareHouseInfo.rent
    MainRenTableWarehousePanel.timeText.text  = rentWareHouseInfo.maxHourToRent
end




























