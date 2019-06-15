---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/12 9:24
---推广公司商品扩展
PromoteGoodsExtensionCtrl = class('PromoteGoodsExtensionCtrl',UIPanel)
UIPanel:ResgisterOpen(PromoteGoodsExtensionCtrl)
local myOwnerID = nil

local goodsExtensionBehaviour

function PromoteGoodsExtensionCtrl:bundleName()
    return "Assets/CityGame/Resources/View/PromoteGoodsExtensionPanel.prefab"
end

function PromoteGoodsExtensionCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function PromoteGoodsExtensionCtrl:Awake()
    if self.m_data == nil then
        return
    end
    goodsExtensionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    goodsExtensionBehaviour:AddClick(PromoteGoodsExtensionPanel.xBtn,self.OnXBtn,self);
    --goodsExtensionBehaviour:AddClick(PromoteGoodsExtensionPanel.curve,self.OnCurve,self);
    goodsExtensionBehaviour:AddClick(PromoteGoodsExtensionPanel.queue,self.OnQueue,self);      --确定(自己)
    goodsExtensionBehaviour:AddClick(PromoteGoodsExtensionPanel.otherQueue,self.OnOtherQueue,self);      --确定(别人)

    PromoteGoodsExtensionPanel.slider.onValueChanged:AddListener(function()
        self:onSlider(self)
    end)
    --建筑主人
    PromoteGoodsExtensionPanel.time.onValueChanged:AddListener(function()
        self:onMyInputField(self)
    end)
    --别人
    PromoteGoodsExtensionPanel.otherTime.onValueChanged:AddListener(function()
        self:onInputField(self)
    end)

    myOwnerID = DataManager.GetMyOwnerID()      --自己的唯一id
    PromoteGoodsExtensionPanel.time.text = 0
end

function PromoteGoodsExtensionCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_PromoteGoodsId",self.c_PromoteGoodsId,self)
    Event.AddListener("c_ClosePromoteGoodsExtension",self.c_ClosePromoteGoodsExtension,self)

    PromoteGoodsExtensionPanel.name.text = GetLanguage(27010005)
    PromoteGoodsExtensionPanel.popularityText.text = GetLanguage(27040013)
    PromoteGoodsExtensionPanel.myTime:GetComponent("Text").text = GetLanguage(27040022)
    PromoteGoodsExtensionPanel.titleText.text = GetLanguage(27040014)
    PromoteGoodsExtensionPanel.otherTimeText.text = GetLanguage(27040022)
    PromoteGoodsExtensionPanel.queueText.text = GetLanguage(27050003)
    PromoteGoodsExtensionPanel.otherQueueText.text = GetLanguage(27050003)
    PromoteGoodsExtensionPanel.select.text = GetLanguage(27040023)
end

function PromoteGoodsExtensionCtrl:Refresh()
    PromoteGoodsExtensionPanel.slider.maxValue = self.m_data.DataInfo.promRemainTime/3600000
    if self.m_data.Data.typeId == 2251 then
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-food.png", PromoteGoodsExtensionPanel.icon)
    elseif self.m_data.Data.typeId == 2252 then
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-clothes.png", PromoteGoodsExtensionPanel.icon)
    end
    PromoteGoodsExtensionPanel.iconText.text = GetLanguage(self.m_data.Data.name)
    self:initData()
    --判断是自己还是别人打开了界面
    if self.m_data.DataInfo.info.ownerId == myOwnerID then
        PromoteGoodsExtensionPanel.myTime.localScale = Vector3.one
        PromoteGoodsExtensionPanel.queue.transform.localScale = Vector3.one
        PromoteGoodsExtensionPanel.otherTimeBg.localScale = Vector3.zero
        PromoteGoodsExtensionPanel.moneyBg.localScale = Vector3.zero
    else
        PromoteGoodsExtensionPanel.myTime.localScale = Vector3.zero
        PromoteGoodsExtensionPanel.queue.transform.localScale = Vector3.zero
        PromoteGoodsExtensionPanel.otherTimeBg.localScale = Vector3.one
        PromoteGoodsExtensionPanel.moneyBg.localScale = Vector3.one
    end
end

function PromoteGoodsExtensionCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_PromoteGoodsId",self.c_PromoteGoodsId,self)
    Event.RemoveListener("c_ClosePromoteGoodsExtension",self.c_ClosePromoteGoodsExtension,self)
    for i, v in pairs(self.PromoteGoods) do
        v:Close()
        destroy(v.prefab.gameObject)
    end
    self.PromoteGoods = {}
    self.goodId = nil
end

function PromoteGoodsExtensionCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function PromoteGoodsExtensionCtrl:initData()
    if self.m_data.Data.subclass == nil then
        return
    end
    PromoteGoodsExtensionPanel.popularity.text = "+".. self.m_data.Data.capacity .. "/h"
    self.PromoteGoods = {}
    for i, v in ipairs(self.m_data.Data.subclass) do
        local function callback(prefab)
           self.PromoteGoods[i] = PromoteGoodsItem:new(prefab,v,goodsExtensionBehaviour)
        end
        createPrefab("Assets/CityGame/Resources/View/GoodsItem/PromoteGoodsItem.prefab",PromoteGoodsExtensionPanel.content, callback)
    end
end

--滑动slider
function PromoteGoodsExtensionCtrl:onSlider(go)
    PromoteGoodsExtensionPanel.otherTime.text = PromoteGoodsExtensionPanel.slider.value
    PromoteGoodsExtensionPanel.money.text = GetClientPriceString(tonumber(PromoteGoodsExtensionPanel.otherTime.text) * go.m_data.DataInfo.curPromPricePerHour)
end

--输入框(自己)
function PromoteGoodsExtensionCtrl:onMyInputField(go)
    if PromoteGoodsExtensionPanel.time.text == "" then
    PromoteGoodsExtensionPanel.time.text = 0
    end
    PromoteGoodsExtensionPanel.title.text = go.m_data.Data.capacity * tonumber(PromoteGoodsExtensionPanel.time.text)
end
--输入框(别人)
function PromoteGoodsExtensionCtrl:onInputField(go)
    if PromoteGoodsExtensionPanel.otherTime.text == "" then
        PromoteGoodsExtensionPanel.otherTime.text = 0
    end
    if tonumber(PromoteGoodsExtensionPanel.otherTime.text) > go.m_data.DataInfo.promRemainTime/3600000 then
        PromoteGoodsExtensionPanel.otherTime.text = go.m_data.DataInfo.promRemainTime/3600000
    end
    PromoteGoodsExtensionPanel.slider.value = PromoteGoodsExtensionPanel.otherTime.text
    PromoteGoodsExtensionPanel.money.text = GetClientPriceString(tonumber(PromoteGoodsExtensionPanel.otherTime.text) * go.m_data.DataInfo.curPromPricePerHour)
    PromoteGoodsExtensionPanel.title.text = go.m_data.Data.capacity * tonumber(PromoteGoodsExtensionPanel.otherTime.text)
end

--返回
function PromoteGoodsExtensionCtrl:OnXBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

--打开曲线图
function PromoteGoodsExtensionCtrl:OnCurve(go)
    ct.OpenCtrl("PromoteCurveCtrl",{insId = go.m_data.DataInfo.insId,Data = go.m_data.Data})
end

--选择的商品
function PromoteGoodsExtensionCtrl:c_PromoteGoodsId(goodId)
    self.goodId = goodId
end

--确定(自己)
function PromoteGoodsExtensionCtrl:OnQueue(go)
    PlayMusEff(1002)
    if not go.goodId then
        Event.Brocast("SmallPop",GetLanguage(27040025))
        return
    end
    if PromoteGoodsExtensionPanel.time.text == "" then
        Event.Brocast("SmallPop",GetLanguage(27040026))
    elseif tonumber(PromoteGoodsExtensionPanel.time.text) == 0 then
        Event.Brocast("SmallPop",GetLanguage(27040027))
    else
        DataManager.DetailModelRpcNoRet(go.m_data.DataInfo.insId, 'm_AddPromote',go.m_data.DataInfo.insId,tonumber(PromoteGoodsExtensionPanel.time.text),go.goodId)
    end
end

--确定(别人)
function PromoteGoodsExtensionCtrl:OnOtherQueue(go)
    PlayMusEff(1002)
    if not go.goodId then
        Event.Brocast("SmallPop",GetLanguage(27040025))
        return
    end
    if go.m_data.DataInfo.promRemainTime == 0 then
        Event.Brocast("SmallPop",GetLanguage(27040028))
        return
    end
    if PromoteGoodsExtensionPanel.otherTime.text == "" then
        Event.Brocast("SmallPop",GetLanguage(27040026))
    elseif tonumber(PromoteGoodsExtensionPanel.otherTime.text) == 0 then
        Event.Brocast("SmallPop",GetLanguage(27040027))
    else
        DataManager.DetailModelRpcNoRet(go.m_data.DataInfo.insId, 'm_AddPromote',go.m_data.DataInfo.insId,tonumber(PromoteGoodsExtensionPanel.otherTime.text),go.goodId)
    end
end

--关闭界面
function PromoteGoodsExtensionCtrl:c_ClosePromoteGoodsExtension()
    UIPanel.ClosePage()
    if self.m_data.DataInfo.info.ownerId == myOwnerID then
        DataManager.DetailModelRpcNoRet(self.m_data.DataInfo.insId, 'm_QueryPromote',self.m_data.DataInfo.insId,true)
    else
        DataManager.DetailModelRpcNoRet(self.m_data.DataInfo.insId, 'm_QueryPromote',self.m_data.DataInfo.insId,false)
    end
end