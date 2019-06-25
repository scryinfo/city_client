---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/11 16:36
---推广公司建筑扩展
PromoteBuildingExtensionCtrl = class('PromoteBuildingExtensionCtrl',UIPanel)
UIPanel:ResgisterOpen(PromoteBuildingExtensionCtrl)

local buildingExtensionBehaviour
local myOwnerID = nil

function PromoteBuildingExtensionCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PromoteBuildingExtensionPanel.prefab"
end

function PromoteBuildingExtensionCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function PromoteBuildingExtensionCtrl:Awake()
    if self.m_data == nil then
       return
    end
    buildingExtensionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    buildingExtensionBehaviour:AddClick(PromoteBuildingExtensionPanel.xBtn,self.OnXBtn,self);
    --buildingExtensionBehaviour:AddClick(PromoteBuildingExtensionPanel.curve,self.OnCurve,self);
    buildingExtensionBehaviour:AddClick(PromoteBuildingExtensionPanel.queue,self.OnQueue,self);
    buildingExtensionBehaviour:AddClick(PromoteBuildingExtensionPanel.otherQueue,self.OnOtherQueue,self);
    self:initData()

    PromoteBuildingExtensionPanel.slider.onValueChanged:AddListener(function()
        self:onSlider(self)
    end)
    --建筑主人
    PromoteBuildingExtensionPanel.time.onValueChanged:AddListener(function()
        self:onMyInputField(self)
    end)
    --别人
    PromoteBuildingExtensionPanel.otherTime.onValueChanged:AddListener(function()
        self:onInputField(self)
    end)

    myOwnerID = DataManager.GetMyOwnerID()      --自己的唯一ids

    PromoteBuildingExtensionPanel.time.text = 0
end

function PromoteBuildingExtensionCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_ClosePromoteBuildingExtension",self.c_ClosePromoteBuildingExtension,self)

    PromoteBuildingExtensionPanel.name.text = GetLanguage(27010005)
    PromoteBuildingExtensionPanel.popularityText.text = GetLanguage(27040013)
    PromoteBuildingExtensionPanel.queueText.text = GetLanguage(27050003)
    PromoteBuildingExtensionPanel.myTime:GetComponent("Text").text = GetLanguage(27040022)
    PromoteBuildingExtensionPanel.titleText.text = GetLanguage(27040014)
    PromoteBuildingExtensionPanel.otherTimeText.text = GetLanguage(27040022)
    PromoteBuildingExtensionPanel.otherQueueText.text = GetLanguage(27050003)
    PromoteBuildingExtensionPanel.supermarketText.text = GetLanguage(42020003)
    PromoteBuildingExtensionPanel.houseText.text = GetLanguage(42020004)
end

function PromoteBuildingExtensionCtrl:Refresh()
    PromoteBuildingExtensionPanel.slider.maxValue = self.m_data.promRemainTime/3600000
    --判断是自己还是别人打开了界面
    if self.m_data.info.ownerId == myOwnerID then
        PromoteBuildingExtensionPanel.myTime.localScale = Vector3.one
        PromoteBuildingExtensionPanel.queue.transform.localScale = Vector3.one
        PromoteBuildingExtensionPanel.otherTimeBg.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.moneyBg.localScale = Vector3.zero
    else
        PromoteBuildingExtensionPanel.myTime.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.queue.transform.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.otherTimeBg.localScale = Vector3.one
        PromoteBuildingExtensionPanel.moneyBg.localScale = Vector3.one
    end
    if self.m_data.type == 1 then
        PromoteBuildingExtensionPanel.house.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.supermarket.localScale = Vector3.one
        PromoteBuildingExtensionPanel.popularity.text = "+".. self.m_data.supermarketSpeed .. "/h"
    elseif self.m_data.type == 2 then
        PromoteBuildingExtensionPanel.house.localScale = Vector3.one
        PromoteBuildingExtensionPanel.supermarket.localScale = Vector3.zero
        PromoteBuildingExtensionPanel.popularity.text = "+".. self.m_data.houseSpeed .. "/h"
    end
end

function PromoteBuildingExtensionCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_ClosePromoteBuildingExtension",self.c_ClosePromoteBuildingExtension,self)
    PromoteBuildingExtensionPanel.title.text = ""
end

function PromoteBuildingExtensionCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function PromoteBuildingExtensionCtrl:initData()

end

--返回
function PromoteBuildingExtensionCtrl:OnXBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

--打开曲线图
function PromoteBuildingExtensionCtrl:OnCurve(go)
    local Data = {}
    Data.typeId = go.m_data.buildingId
    if go.m_data.buildingId == 1300 then
        Data.name = GetLanguage(42020003)
    elseif go.m_data.buildingId == 1400 then
        Data.name = GetLanguage(42020004)
    end
    ct.OpenCtrl("PromoteCurveCtrl",{insId = go.m_data.insId,Data = Data})
end

--点击确定(自己)
function PromoteBuildingExtensionCtrl:OnQueue(go)
    PlayMusEff(1002)
    if PromoteBuildingExtensionPanel.time.text == "" then
        Event.Brocast("SmallPop",GetLanguage(27040026))
    elseif tonumber(PromoteBuildingExtensionPanel.time.text) == 0 then
        Event.Brocast("SmallPop",GetLanguage(27040027))
    else
        DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_AddPromote',go.m_data.insId,tonumber(PromoteBuildingExtensionPanel.time.text),go.m_data.buildingId)
    end
end

--点击确定(别人)
function PromoteBuildingExtensionCtrl:OnOtherQueue(go)
    PlayMusEff(1002)
    if PromoteBuildingExtensionPanel.otherTime.text == "" then
        Event.Brocast("SmallPop",GetLanguage(27040026))
    elseif tonumber(PromoteBuildingExtensionPanel.otherTime.text) == 0 then
        Event.Brocast("SmallPop",GetLanguage(27040027))
    else
        DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_AddPromote',go.m_data.insId,tonumber(PromoteBuildingExtensionPanel.otherTime.text),go.m_data.buildingId)
    end
end

--滑动slider
function PromoteBuildingExtensionCtrl:onSlider(go)
    PromoteBuildingExtensionPanel.otherTime.text = PromoteBuildingExtensionPanel.slider.value
    PromoteBuildingExtensionPanel.money.text = GetClientPriceString(tonumber(PromoteBuildingExtensionPanel.otherTime.text) * go.m_data.curPromPricePerHour)
end

--输入框(自己)
function PromoteBuildingExtensionCtrl:onMyInputField(go)
    if PromoteBuildingExtensionPanel.time.text == "" then
        PromoteBuildingExtensionPanel.time.text = 0
    end
    PromoteBuildingExtensionPanel.time.text = tonumber(PromoteBuildingExtensionPanel.time.text)
    if go.m_data.type == 1 then
        PromoteBuildingExtensionPanel.title.text = go.m_data.supermarketSpeed * tonumber(PromoteBuildingExtensionPanel.time.text)
    elseif go.m_data.type == 2 then
        PromoteBuildingExtensionPanel.title.text = go.m_data.houseSpeed * tonumber(PromoteBuildingExtensionPanel.time.text)
    end

end
--输入框(别人)
function PromoteBuildingExtensionCtrl:onInputField(go)
    if PromoteBuildingExtensionPanel.otherTime.text == "" then
        PromoteBuildingExtensionPanel.otherTime.text = 0
    end
    PromoteBuildingExtensionPanel.otherTime.text = tonumber(PromoteBuildingExtensionPanel.otherTime.text)
    if tonumber(PromoteBuildingExtensionPanel.otherTime.text) > go.m_data.promRemainTime/3600000 then
        PromoteBuildingExtensionPanel.otherTime.text = go.m_data.promRemainTime/3600000
    end
    PromoteBuildingExtensionPanel.slider.value = PromoteBuildingExtensionPanel.otherTime.text
    PromoteBuildingExtensionPanel.money.text = GetClientPriceString(tonumber(PromoteBuildingExtensionPanel.otherTime.text) * go.m_data.curPromPricePerHour)
    if go.m_data.type == 1 then
        PromoteBuildingExtensionPanel.title.text = go.m_data.supermarketSpeed * tonumber(PromoteBuildingExtensionPanel.otherTime.text)
    elseif go.m_data.type == 2 then
        PromoteBuildingExtensionPanel.title.text = go.m_data.houseSpeed * tonumber(PromoteBuildingExtensionPanel.otherTime.text)
    end
end

--关闭界面
function PromoteBuildingExtensionCtrl:c_ClosePromoteBuildingExtension()
    UIPanel.ClosePage()
    if self.m_data.info.ownerId == myOwnerID then
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_QueryPromote',self.m_data.insId,true)
    else
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_QueryPromote',self.m_data.insId,false)
    end
end
