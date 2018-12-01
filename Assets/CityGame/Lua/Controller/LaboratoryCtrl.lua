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

function LaboratoryCtrl:Awake(go)
    self.gameObject = go
    self.laboratoryBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    --self.laboratoryBehaviour:AddClick(LaboratoryPanel.backBtn.gameObject, self._backBtn, self)
    --self.laboratoryBehaviour:AddClick(LaboratoryPanel.infoBtn.gameObject, self._openInfo, self)
    --self.laboratoryBehaviour:AddClick(LaboratoryPanel.changeNameBtn.gameObject, self._changeName, self)

    self:_addListener()
end

function LaboratoryCtrl:Refresh()
    self:_initData()
end
function LaboratoryCtrl:_addListener()
    ---需要监听改变建筑名字的协议
    ---等待中
    Event.AddListener("c_OnReceiveLaboratoryDetailInfo", self._receiveLaboratoryDetailInfo, self)
end
function LaboratoryCtrl:_removeListener()
    Event.RemoveListener("c_OnReceiveLaboratoryDetailInfo", self._receiveLaboratoryDetailInfo, self)
end

--创建好建筑之后，每个建筑会存基本数据，比如id
function LaboratoryCtrl:_initData()
    if self.m_data then
        Event.Brocast("m_ReqLaboratoryDetailInfo", self.m_data)
    end
end

function LaboratoryCtrl:_receiveLaboratoryDetailInfo(laboratoryDetailData)
    LaboratoryPanel.buildingNameText.text = PlayerBuildingBaseData[laboratoryDetailData.info.mId].sizeName..PlayerBuildingBaseData[laboratoryDetailData.info.mId].typeName
    self.m_data = laboratoryDetailData
    if laboratoryDetailData.info.ownerId ~= PlayerTempModel.roleData.id then  --判断是自己还是别人打开了界面
        self.m_data.isOther = true
        LaboratoryPanel.changeNameBtn.localScale = Vector3.zero
    else
        self.m_data.isOther = false
        LaboratoryPanel.changeNameBtn.localScale = Vector3.one
    end
    self.m_data.buildingType = BuildingType.Laboratory
    if not self.laboratoryToggleGroup then
        self.laboratoryToggleGroup = BuildingInfoToggleGroupMgr:new(LaboratoryPanel.leftRootTran, LaboratoryPanel.rightRootTran, self.laboratoryBehaviour, self.m_data)
    else
        self.laboratoryToggleGroup:updateData(LaboratoryPanel.leftRootTran, LaboratoryPanel.rightRootTran, self.laboratoryBehaviour, self.m_data)
    end
end

---更改名字
function LaboratoryCtrl:_changeName(ins)
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
function LaboratoryCtrl:_backBtn(ins)
    ins.houseToggleGroup:cleanItems()
    UIPage.ClosePage()
end
---更改名字成功
function LaboratoryCtrl:_updateName(name)
    LaboratoryPanel.nameText.text = name
end
