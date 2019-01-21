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
    self.houseBehaviour:AddClick(HousePanel.backBtn.gameObject, self._backBtn, self)
    self.houseBehaviour:AddClick(HousePanel.changeNameBtn.gameObject, self._changeName, self)
    self.houseBehaviour:AddClick(HousePanel.centerBtn.gameObject, self._centerBtnFunc, self)
    self.houseBehaviour:AddClick(HousePanel.stopIconBtn.gameObject, self._openBuildingBtnFunc, self)
end

function HouseCtrl:Refresh()
    --self:_initData()
    this:_initData()
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
    Event.Brocast("c_GetBuildingInfo", houseDetailData.info)
    if houseDetailData.info.state == "OPERATE" then
        HousePanel.stopRootTran.localScale = Vector3.zero
    else
        HousePanel.stopRootTran.localScale = Vector3.one
    end

    HousePanel.nameText.text = houseDetailData.info.name or "SRCY CITY"
    HousePanel.buildingNameText.text = PlayerBuildingBaseData[houseDetailData.info.mId].sizeName..PlayerBuildingBaseData[houseDetailData.info.mId].typeName
    local insId = self.m_data.insId
    self.m_data = houseDetailData
    self.m_data.insId = insId  --temp

    if houseDetailData.info.ownerId ~= DataManager.GetMyOwnerID() then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
        HousePanel.changeNameBtn.localScale = Vector3.zero
        HousePanel.stopIconBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        HousePanel.changeNameBtn.localScale = Vector3.one
    end
    self.m_data.buildingType = BuildingType.House
    if not self.houseToggleGroup then
        self.houseToggleGroup = BuildingInfoToggleGroupMgr:new(HousePanel.leftRootTran, HousePanel.rightRootTran, self.houseBehaviour, self.m_data, HousePanel.brandRootTran)
    else
        self.houseToggleGroup:updateInfo(self.m_data)
    end
end
---更改名字
function HouseCtrl:_changeName(ins)
    local data = {}
    data.titleInfo = "RENAME"
    data.tipInfo = "Modified every seven days"
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    data.btnCallBack = function(name)
        DataManager.DetailModelRpcNoRet(ins.m_data.insId, 'm_ReqChangeHouseName', ins.m_data.insId, name)
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
---返回
function HouseCtrl:_backBtn(ins)
    if ins.houseToggleGroup then
        ins.houseToggleGroup:cleanItems()
    end
    UIPanel.ClosePage()
end
---更改名字成功
function HouseCtrl:_updateName(name)
    HousePanel.nameText.text = name
end

--点击中间按钮的方法
function HouseCtrl:_centerBtnFunc(ins)
    if ins.m_data then
        Event.Brocast("c_openBuildingInfo", ins.m_data.info)
    end
end
--点击开业按钮方法
function HouseCtrl:_openBuildingBtnFunc(ins)
    if ins.m_data then
        Event.Brocast("c_beginBuildingInfo", ins.m_data.info, ins.Refresh)
    end
end
