---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/16 10:29
---
LaboratoryCtrl = class('LaboratoryCtrl',UIPage)
UIPage:ResgisterOpen(LaboratoryCtrl)

function LaboratoryCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end
function LaboratoryCtrl:bundleName()
    return "LaboratoryPanel"
end
function LaboratoryCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end
local this
function LaboratoryCtrl:Awake(go)
    this = self
    self.gameObject = go
    self.laboratoryBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.laboratoryBehaviour:AddClick(LaboratoryPanel.backBtn.gameObject, self._backBtn, self)

    self.laboratoryBehaviour:AddClick(LaboratoryPanel.centerBtn.gameObject, self._centerBtnFunc, self)
    self.laboratoryBehaviour:AddClick(LaboratoryPanel.stopIconBtn.gameObject, self._openBuildingBtnFunc, self)
end
function LaboratoryCtrl:Refresh()
    --self:_initData()
    this:_initData()
end
function LaboratoryCtrl:Hide()
    self.gameObject:SetActive(false)
    self.isActived = false
end

--创建好建筑之后，每个建筑会存基本数据，比如id
function LaboratoryCtrl:_initData()
    if self.hasOpened then
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqLaboratoryCurrentInfo')
    else
        if self.m_data then
            DataManager.OpenDetailModel(LaboratoryModel, self.m_data.insId)
            DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_ReqLaboratoryDetailInfo', false)
        end
    end
end

function LaboratoryCtrl:_receiveLaboratoryDetailInfo(orderLineData, info, store)
    Event.Brocast("c_GetBuildingInfo", info)
    if info.state == "OPERATE" then
        LaboratoryPanel.stopIconBtn.localScale = Vector3.zero
    else
        LaboratoryPanel.stopIconBtn.localScale = Vector3.one
    end

    self.hasOpened = true
    LaboratoryPanel.buildingNameText.text = PlayerBuildingBaseData[info.mId].sizeName..PlayerBuildingBaseData[info.mId].typeName
    LaboratoryCtrl.static.buildingBaseData = PlayerBuildingBaseData[info.mId]
    self.m_data.ownerId = info.ownerId
    self.m_data.mId = info.mId
    self.m_data.orderLineData = orderLineData
    self.m_data.info = info
    self.m_data.store = store
    if info.ownerId ~= DataManager.GetMyOwnerID() then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
        LaboratoryPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        LaboratoryPanel.changeNameBtn.localScale = Vector3.one
    end
    self.m_data.buildingType = BuildingType.Laboratory
    if self.laboratoryToggleGroup == nil then
        self.laboratoryToggleGroup = BuildingInfoToggleGroupMgr:new(LaboratoryPanel.leftRootTran, LaboratoryPanel.rightRootTran, self.laboratoryBehaviour, self.m_data)
    else
        self.laboratoryToggleGroup:updateInfo(self.m_data)
    end
end

---更改名字
function LaboratoryCtrl:_changeName(ins)
    local data = {}
    data.titleInfo = "RENAME"
    data.tipInfo = "Modified every seven days"
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    data.btnCallBack = function(name)
        --ct.log("cycle_w12_hosueServer", "向服务器发送请求更改名字的协议")

        ---临时代码，直接改变名字
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
---返回
function LaboratoryCtrl:_backBtn(ins)
    if ins.laboratoryToggleGroup ~= nil then
        ins.laboratoryToggleGroup:cleanItems()
    end
    ins.hasOpened = false
    --关闭界面时再发一遍详情
    DataManager.DetailModelRpcNoRet(ins.m_data.insId, 'm_ReqLaboratoryDetailInfo', true)
    UIPage.ClosePage()
end
---更改名字成功
function LaboratoryCtrl:_updateName(name)
    LaboratoryPanel.nameText.text = name
end

--点击中间按钮的方法
function LaboratoryCtrl:_centerBtnFunc(ins)
    if ins.m_data then
        Event.Brocast("c_openBuildingInfo", ins.m_data.info)
    end
end
--点击开业按钮方法
function LaboratoryCtrl:_openBuildingBtnFunc(ins)
    if ins.m_data then
        Event.Brocast("c_beginBuildingInfo", ins.m_data.info, ins.Refresh)
    end
end