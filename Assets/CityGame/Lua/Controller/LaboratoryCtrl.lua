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
function LaboratoryCtrl:bundleName()
    return "Assets/CityGame/Resources/View/LaboratoryPanel.prefab"
end
function LaboratoryCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end
local this,panel
function LaboratoryCtrl:Refresh()
    this:_initData()
end
function LaboratoryCtrl:Awake(go)
    this = self
    panel=LaboratoryPanel
    self.luaBehaviour= self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(panel.backBtn.gameObject, self._backBtn, self)
    self.luaBehaviour:AddClick(panel.changeNameBtn.gameObject, self._changeName, self)

    self.luaBehaviour:AddClick(panel.centerBtn.gameObject, self._centerBtnFunc, self)
    self.luaBehaviour:AddClick(panel.stopIconBtn.gameObject, self._openBuildingBtnFunc, self)
end

---===================================================================================点击函数==============================================================================================

--点击中间按钮的方法
function LaboratoryCtrl:_centerBtnFunc(ins)
    --if ins.m_data then
    --    Event.Brocast("c_openBuildingInfo", ins.m_data.info)
    --end
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
    --建筑名字
    panel.nameText.text = info.name or "SRCY CITY"
    panel.buildingNameText.text = PlayerBuildingBaseData[info.mId].sizeName..PlayerBuildingBaseData[info.mId].typeName
    --判断是自己还是别人打开了界面
    if info.ownerId ~= DataManager.GetMyOwnerID() then
        panel.changeNameBtn.localScale = Vector3.zero
        panel.stopIconBtn.localScale = Vector3.zero
    else
        panel.changeNameBtn.localScale = Vector3.one
    end
    --刷新底部组件
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