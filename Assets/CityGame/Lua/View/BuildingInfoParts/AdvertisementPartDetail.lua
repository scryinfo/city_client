---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/30 14:54
---广告业务Ctrl
---
AdvertisementPartDetail = class('AdvertisementPartDetail', BasePartDetail)
local promoteAbility = {}
local myOwnerID = nil
--
function AdvertisementPartDetail:PrefabName()
    return "AdvertisementPartDetail"
end
--
function AdvertisementPartDetail:_InitTransform()
    self:_getComponent(self.transform)
    self:_initData()
    myOwnerID = DataManager.GetMyOwnerID()      --自己的唯一id
end
--
function  AdvertisementPartDetail:_InitEvent()
    Event.AddListener("c_PromoteCapacity",self.PromoteCapacity,self)
    Event.AddListener("c_PromoteBuildingCapacity",self.PromoteBuildingCapacity,self)
end
--
function AdvertisementPartDetail:_InitClick(mainPanelLuaBehaviour)
    mainPanelLuaBehaviour:AddClick(self.goods, self.OnGoods, self)
    mainPanelLuaBehaviour:AddClick(self.building, self.OnBuilding, self)
    mainPanelLuaBehaviour:AddClick(self.open, self.OnOpen, self)
    mainPanelLuaBehaviour:AddClick(self.quene, self.OnQuene, self)
    mainPanelLuaBehaviour:AddClick(self.supermarket, self.OnSupermarket, self)
    mainPanelLuaBehaviour:AddClick(self.house, self.OnHouse, self)
end
--
function AdvertisementPartDetail:_ResetTransform()
    for i, v in pairs(promoteAbility) do
        destroy(v.prefab.gameObject)
    end
    promoteAbility = {}
end
--
function AdvertisementPartDetail:_RemoveEvent()
    Event.RemoveListener("c_PromoteCapacity",self.PromoteCapacity,self)
    Event.RemoveListener("c_PromoteBuildingCapacity",self.PromoteBuildingCapacity,self)
end
--
function AdvertisementPartDetail:_RemoveClick()

end
--
function AdvertisementPartDetail:RefreshData(data)
    if data then
        if self.m_data then
        self.m_data.promRemainTime = data.promRemainTime
        end
        self.timeText.text = math.floor(data.promRemainTime/3600000)
        self.priceText.text = GetClientPriceString(data.curPromPricePerHour)
        self.queneValue.text = data.selledPromCount
        if data.selledPromCount == 0 then
            local ts = getFormatUnixTime(TimeSynchronized.GetTheCurrentTime())
            self.startTime.text = ts.hour .. ":" ..ts.minute .. " " .. ts.month .. "/" .. ts.day .. "/" .. ts.year
            return
        end
        if data.newPromoStartTs ~= -1 then
            local ts = getFormatUnixTime(data.newPromoStartTs/1000)
            self.startTime.text = ts.hour .. ":" ..ts.minute .. " " .. ts.month .. "/" .. ts.day .. "/" .. ts.year
        end
    end
end
--
function AdvertisementPartDetail:_getComponent(transform)
    --down
    self.goods = transform:Find("bg/down/GoodsBg/goods/goodsBg").gameObject      --商品
    self.goodsText = transform:Find("bg/down/GoodsBg/goods/goodsText"):GetComponent("Text")
    self.goodsClickText = transform:Find("bg/down/GoodsBg/goods/goodsClickText"):GetComponent("Text")
    self.building = transform:Find("bg/down/GoodsBg/building/buildingBg").gameObject      --建筑
    self.buildingClickText = transform:Find("bg/down/GoodsBg/building/buildingClickText"):GetComponent("Text")
    self.open = transform:Find("bg/down/openOther/openBg/open").gameObject      --对外开放
    self.price = transform:Find("bg/down/openOther/openBg/priceImage/price"):GetComponent("Text")    --价格
    self.priceText = transform:Find("bg/down/openOther/openBg/priceImage/price/priceImage/priceText"):GetComponent("Text")    --价格
    self.time = transform:Find("bg/down/openOther/openBg/timeImage/time"):GetComponent("Text")    --时间
    self.timeText = transform:Find("bg/down/openOther/openBg/timeImage/time/timeImage/timeText"):GetComponent("Text")    --时间
    self.quene = transform:Find("bg/down/openOther/startTimeBg/quene").gameObject;      --队列
    self.queneText = transform:Find("bg/down/openOther/startTimeBg/quene/queneImage/queneText"):GetComponent("Text");
    self.queneValue = transform:Find("bg/down/openOther/startTimeBg/quene/queneImage/queneText/queneValue"):GetComponent("Text");
    self.content = transform:Find("bg/down/Scroll View/Viewport/Content"):GetComponent("RectTransform");
    self.buildingBg = transform:Find("bg/down/buildingBg");
    self.supermarket = transform:Find("bg/down/buildingBg/supermarket").gameObject;   --零售店
    self.house = transform:Find("bg/down/buildingBg/house").gameObject;   --住宅
    self.supermarketSpeed = transform:Find("bg/down/buildingBg/supermarket/center/speed"):GetComponent("Text");   --零售店
    self.houseSpeed = transform:Find("bg/down/buildingBg/house/center/speed"):GetComponent("Text");   --住宅
    self.startTime = transform:Find("bg/down/openOther/startTimeBg/startTime/timeImage/time"):GetComponent("Text");   --新推广开始时间

end

function AdvertisementPartDetail:_initData()
    for i, v in ipairs(GoodsTypeConfig) do
        local function callback(prefab)
            promoteAbility[i] = PromoteAbilityItem:new(prefab)
        end
        createPrefab("Assets/CityGame/Resources/View/GoodsItem/PromoteAbilityItem.prefab",self.content, callback)
    end
end
--
function AdvertisementPartDetail:_initFunc()
        local typeIds = {}
        for i, v in pairs(GoodsTypeConfig) do
            typeIds[i] = v.typeId
        end
        local buildingType = {[1] = 1300, [2] = 1400}

        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_queryPromoCurAbilitys',self.m_data.insId,typeIds)
        DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_queryPromoCurAbilitys',self.m_data.insId,buildingType)
end
--

function AdvertisementPartDetail:Show(data)
    BasePartDetail.Show(self)
    if data.info.ownerId ~= myOwnerID then
        self.open.transform.localScale = Vector3.zero
    end
    self.m_data = data
    self:_initFunc()
    if data.selledPromCount == 0 then
        local ts = getFormatUnixTime(TimeSynchronized.GetTheCurrentTime())
        self.startTime.text = ts.hour .. ":" ..ts.minute .. " " .. ts.month .. "/" .. ts.day .. "/" .. ts.year
    end
end

function AdvertisementPartDetail:Hide()
    BasePartDetail.Hide(self)
end

--点击商品
function AdvertisementPartDetail:OnGoods(go)
    go.goods.transform.localScale = Vector3.zero
    go.goodsClickText.transform.localScale = Vector3.zero
    go.building.transform.localScale = Vector3.one
    go.buildingClickText.transform.localScale = Vector3.one
    go.buildingBg.localScale = Vector3.zero
    go.content.localScale = Vector3.one
    local typeIds = {}
    for i, v in pairs(GoodsTypeConfig) do
        typeIds[i] = v.typeId
    end
    DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_queryPromoCurAbilitys',go.m_data.insId,typeIds)
end

--初始化商品推广能力
function AdvertisementPartDetail:PromoteCapacity()
    for i, v in ipairs(GoodsTypeConfig) do
        promoteAbility[i]:InitData(v,self.m_data)
    end
end
--初始化建筑推广能力
function AdvertisementPartDetail:PromoteBuildingCapacity(CurAbilitys)
    self.m_data.supermarketSpeed = CurAbilitys[1]
    self.m_data.houseSpeed = CurAbilitys[2]
    self.supermarketSpeed.text = "+" .. CurAbilitys[1] .."/h"
    self.houseSpeed.text = "+" .. CurAbilitys[2] .."/h"
end

--点击建筑
function AdvertisementPartDetail:OnBuilding(go)
    go.goods.transform.localScale = Vector3.one
    go.goodsClickText.transform.localScale = Vector3.one
    go.building.transform.localScale = Vector3.zero
    go.buildingClickText.transform.localScale = Vector3.zero
    go.buildingBg.localScale = Vector3.one
    go.content.localScale = Vector3.zero

    local buildingType = {[1] = 1300, [2] = 1400}
    DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_queryPromoCurAbilitys',go.m_data.insId,buildingType)
end

--对外开放
function AdvertisementPartDetail:OnOpen(go)
   ct.OpenCtrl("SetOpenUpCtrl",go.m_data)
end

--队列
function AdvertisementPartDetail:OnQuene(go)
    if go.m_data.info.ownerId == myOwnerID then
        DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_QueryPromote',go.m_data.insId,true)
    else
        DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_QueryPromote',go.m_data.insId,false)
    end
end

--零售店
function AdvertisementPartDetail:OnSupermarket(go)
    go.m_data.type = 1
    go.m_data.buildingId = 1300
   ct.OpenCtrl("PromoteBuildingExtensionCtrl",go.m_data)
end

--住宅
function AdvertisementPartDetail:OnHouse(go)
    go.m_data.type = 2
    go.m_data.buildingId = 1400
    ct.OpenCtrl("PromoteBuildingExtensionCtrl",go.m_data)
end
