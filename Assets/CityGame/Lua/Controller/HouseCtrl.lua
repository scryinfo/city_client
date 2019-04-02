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
end

function HouseCtrl:Refresh()
    this:_initData()
end

function HouseCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_BuildingTopChangeData", self._changeItemData, self)
end

function HouseCtrl:Hide()
    Event.RemoveListener("c_BuildingTopChangeData", self._changeItemData, self)
    UIPanel.Hide(self)
end

--更改基础建筑信息
function HouseCtrl:_changeItemData(data)
    if data ~= nil and HousePanel.topItem ~= nil then
        HousePanel.topItem:changeItemData(data)
    end
end

--创建好建筑之后，每个建筑会存基本数据，比如id
function HouseCtrl:_initData()
    if self.m_data then
        --向服务器请求建筑详情
        DataManager.OpenDetailModel(HouseModel,self.m_data.insId)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqHouseDetailInfo',self.m_data.insId)
    end
end

function HouseCtrl:_receiveHouseDetailInfo(houseDetailData)
    if HousePanel.topItem ~= nil then
        HousePanel.topItem:refreshData(houseDetailData.info, function ()
            self:_clickCloseBtn(self)
        end)
    end

    if houseDetailData.info.state == "OPERATE" then
        HousePanel.openBusinessItem:toggleState(false)  --如果已经开业则不能显示按钮
    else
        HousePanel.openBusinessItem:toggleState(true)
        HousePanel.openBusinessItem:initData(houseDetailData.info, BuildingType.House)
    end

    local insId = self.m_data.insId
    self.m_data = houseDetailData
    self.m_data.insId = insId  --temp

    if houseDetailData.info.ownerId ~= DataManager.GetMyOwnerID() then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
    else
        self.m_data.isOther = false
    end
    if self.groupMgr == nil then
        self.groupMgr = BuildingInfoMainGroupMgr:new(HousePanel.groupTrans, self.houseBehaviour)
        self.groupMgr:AddParts(BuildingSalaryPart, 1)
        self.groupMgr:RefreshData(self.m_data)
        self.groupMgr:TurnOffAllOptions()
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
--
function HouseCtrl:_refreshSalary(data)
    if self.m_data ~= nil then
        if self.m_data.info.state == "OPERATE" then
            Event.Brocast("SmallPop", "设置工资成功", 300)
        end
        self.m_data.info.salary = data.Salary
        self.m_data.info.setSalaryTs = data.ts
        self.groupMgr:RefreshData(self.m_data)
    end
end
--
function HouseCtrl:_refreshRent(data)
    if self.m_data ~= nil then
        self.m_data.rent = data.rent
        self.groupMgr:RefreshData(self.m_data)
    end
end
