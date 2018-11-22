---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---
-----

HouseCtrl = class('HouseCtrl',UIPage)
UIPage:ResgisterOpen(HouseCtrl)

function HouseCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function HouseCtrl:bundleName()
    return "HousePanel"
end

function HouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
end

function HouseCtrl:Awake(go)
    self.gameObject = go
    self.houseBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.houseBehaviour:AddClick(HousePanel.backBtn.gameObject, self._backBtn, self)
    self.houseBehaviour:AddClick(HousePanel.infoBtn.gameObject, self._openInfo, self)
    self.houseBehaviour:AddClick(HousePanel.changeNameBtn.gameObject, self._changeName, self)

    self:_addListener()
end

function HouseCtrl:Refresh()
    self:_initData()
end
function HouseCtrl:_addListener()
    ---需要监听改变建筑名字的协议
    ---等待中
    Event.AddListener("c_onReceiveHouseDetailInfo", self._receiveHouseDetailInfo, self)
end
function HouseCtrl:_removeListener()
    Event.RemoveListener("c_onReceiveHouseDetailInfo", self._receiveHouseDetailInfo, self)
end

--创建好建筑之后，每个建筑会存基本数据，比如id
function HouseCtrl:_initData()
    if self.m_data then
        --向服务器请求建筑详情
        Event.Brocast("m_ReqHouseDetailInfo", self.m_data)
    end
end

function HouseCtrl:_receiveHouseDetailInfo(houseDetailData)
    HousePanel.buildingNameText.text = PlayerBuildingBaseData[houseDetailData.info.mId].sizeName..PlayerBuildingBaseData[houseDetailData.info.mId].typeName
    self.m_data = houseDetailData
    if houseDetailData.info.ownerId ~= PlayerTempModel.roleData.id then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
        HousePanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        HousePanel.changeNameBtn.localScale = Vector3.one
    end
    self.m_data.buildingType = BuildingType.House
    if not self.houseToggleGroup then
        self.houseToggleGroup = BuildingInfoToggleGroupMgr:new(HousePanel.leftRootTran, HousePanel.rightRootTran, self.houseBehaviour, self.m_data)
    else
        self.houseToggleGroup:updateData(HousePanel.leftRootTran, HousePanel.rightRootTran, self.houseBehaviour, self.m_data)
    end
end
---更改名字
function HouseCtrl:_changeName(ins)
    local data = {}
    data.titleInfo = "RENAME"
    data.tipInfo = "Modified every seven days"
    data.inputDialogPageServerType = InputDialogPageServerType.UpdateBuildingName
    data.btnCallBack = function(name)
        ct.log("cycle_w12_hosueServer", "向服务器发送请求更改名字的协议")

        ---临时代码，直接改变名字
        ins:_updateName(name)
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
---返回
function HouseCtrl:_backBtn(ins)
    if ins.houseToggleGroup then
        ins.houseToggleGroup:cleanItems()
    end
    UIPage.ClosePage()
end
---更改名字成功
function HouseCtrl:_updateName(name)
    HousePanel.nameText.text = name
end
