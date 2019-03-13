---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/1 9:51
---交易量ctrl
VolumeCtrl = class('VolumeCtrl',UIPanel)
UIPanel:ResgisterOpen(VolumeCtrl)
--VolumeCtrl.static.Head_PATH = "View/GoodsItem/RoleHeadItem"

local volumeBehaviour;
local isClother = true
local clothes
local food
local minute
local second

function  VolumeCtrl:bundleName()
    return "Assets/CityGame/Resources/View/VolumePanel.prefab"
end

function VolumeCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function VolumeCtrl:Awake()
    volumeBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    volumeBehaviour:AddClick(VolumePanel.back,self.OnBack,self)
    volumeBehaviour:AddClick(VolumePanel.clotherBtn,self.OnClotherBtn,self)
    volumeBehaviour:AddClick(VolumePanel.foodBtn,self.OnFoodBtn,self)
    volumeBehaviour:AddClick(VolumePanel.cityBg,self.OnCityBg,self)
    volumeBehaviour:AddClick(VolumePanel.volume,self.OnVolume,self)
    volumeBehaviour:AddClick(VolumePanel.titleBg,self.OnTitleBg,self)
    self.insId = OpenModelInsID.VolumeCtrl

    DataManager.OpenDetailModel(VolumeModel,self.insId )
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local minute = tonumber(ts.minute)
    local second = tonumber(ts.second)
    if second ~= 0 then
        currentTime = currentTime - second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000) --每种商品购买的npc数量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_NpcExchangeAmount') --所有npc交易量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_ExchangeAmount') --所有交易量

    self.initData()

    --滑动互用
    self.supplyDemand = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.supplyDemand.mProvideData = VolumeCtrl.static.SupplyDemandProvideData
    self.supplyDemand.mClearData = VolumeCtrl.static.SupplyDemandClearData


    --初始化循环参数
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self.Update, self), 1, -1, true)


end

function VolumeCtrl:Active()
    UIPanel.Active(self)
    self.m_Timer:Start()
    Event.AddListener("c_NpcNum",self.c_NpcNum,self)
    Event.AddListener("c_OnGoodsNpcNum",self.c_OnGoodsNpcNum,self)
    Event.AddListener("c_NpcExchangeAmount",self.c_NpcExchangeAmount,self) --所有npc交易量
    Event.AddListener("c_ExchangeAmount",self.c_ExchangeAmount,self) --所有交易量
end

function VolumeCtrl:Refresh()
    --打开Model
    VolumeCtrl:Countdown()
    self:initInsData()
end

function VolumeCtrl:Hide()
    UIPanel.Hide(self)
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
    Event.RemoveListener("c_NpcNum",self.c_NpcNum,self)
    Event.RemoveListener("c_OnGoodsNpcNum",self.c_OnGoodsNpcNum,self)
    Event.RemoveListener("c_NpcExchangeAmount",self.c_NpcExchangeAmount,self) --所有npc交易量
    Event.AddListener("c_ExchangeAmount",self.c_ExchangeAmount,self) --所有交易量
end

function VolumeCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function VolumeCtrl:initInsData()
    DataManager.OpenDetailModel(VolumeModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetNpcNum')
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNumCurve')
end

--更新时间
function VolumeCtrl:Update()
    VolumeCtrl:Countdown()
    if tonumber(minute) == 0 and tonumber(second) == 0 then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum') --每种商品购买的npc数量
    end
end

--NPC数量
function VolumeCtrl:c_NpcNum(countNpc)
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local time = tonumber(ts.year..ts.month..ts.day)

   local adult = 0
   local old = 0
   local youth = 0
    if countNpc ~= nil then
        for i, v in pairs(countNpc) do
            if v.key == 10 then
                old = old + v.value
            elseif v.key == 11 then
                youth = youth + v.value
            else
                adult = adult + v.value
            end
        end
    end
    VolumePanel.adult.text = adult
    VolumePanel.old.text = old
    VolumePanel.youth.text = youth
    VolumeCtrl:AssignmentDemand(clothes , countNpc , time)
    VolumeCtrl:AssignmentDemand(food , countNpc , time)

end

--每种商品购买的npc数量
function VolumeCtrl:c_OnGoodsNpcNum(info)
    VolumeCtrl:AssignmentDemandSupply(clothes , info )
    VolumeCtrl:AssignmentDemandSupply(food , info )
    VolumePanel.scroll:ActiveLoopScroll(self.supplyDemand, #clothes)
end

--所有npc交易量
function VolumeCtrl:c_NpcExchangeAmount(info)
    VolumePanel.money.text = "E"..getMoneyString(GetClientPriceString(info))
end

--所有交易量
function VolumeCtrl:c_ExchangeAmount(info)
    VolumePanel.volumeText.text = "E"..getMoneyString(GetClientPriceString(info))
end

--初始化
function VolumeCtrl:initData()
    clothes = {}
    food = {}
    local clothesIndex = 1
    local foodIndex = 1
    for i, v in pairs(Good) do
        if math.floor(v.itemId / 1000) == 2251 then
            food[foodIndex] = {}
            food[foodIndex].itemId = v.itemId
            foodIndex = foodIndex +1
        else
            clothes[clothesIndex] = {}
            clothes[clothesIndex].itemId = v.itemId
            clothesIndex = clothesIndex +1
        end
    end
end

--返回
function VolumeCtrl:OnBack()
    UIPanel.ClosePage()
end

--市民提示
function VolumeCtrl:OnCityBg()
    VolumePanel.cityTitle.localScale = Vector3.one
    VolumePanel.titleBg.transform.localScale = Vector3.one
end

--交易量提示
function VolumeCtrl:OnVolume()
    VolumePanel.volumetitle.localScale = Vector3.one
    VolumePanel.titleBg.transform.localScale = Vector3.one
end

--提示框Bg
function VolumeCtrl:OnTitleBg()
    VolumePanel.volumetitle.localScale = Vector3.zero
    VolumePanel.cityTitle.localScale = Vector3.zero
    VolumePanel.titleBg.transform.localScale = Vector3.zero
end

--ClotherBtn
function VolumeCtrl:OnClotherBtn(go)
    isClother = true
    --VolumePanel.clotherBtn.transform.localScale = Vector3.zero
    VolumePanel.clotherBtn:SetActive(false)
    VolumePanel.foodBtn:SetActive(true)

    VolumePanel.scroll:ActiveLoopScroll(go.supplyDemand, #clothes)

end

--FoodBtn
function VolumeCtrl:OnFoodBtn(go)
    isClother = false
    VolumePanel.foodBtn:SetActive(false)
    VolumePanel.clotherBtn:SetActive(true)
    VolumePanel.scroll:ActiveLoopScroll(go.supplyDemand, #food)
end

--滑动互用
VolumeCtrl.static.SupplyDemandProvideData = function(transform, idx)

    idx = idx + 1
    local item
    if isClother then
        item = SupplyDemandItem:new(clothes[idx],transform)
    else
        item = SupplyDemandItem:new(food[idx],transform)
    end

    local supplyDemand = {}
    supplyDemand[idx] = item

    volumeBehaviour:AddClick(transform:Find("bg").gameObject,VolumeCtrl.OnBg,VolumeCtrl)
end

VolumeCtrl.static.SupplyDemandClearData = function(transform)
    volumeBehaviour:RemoveClick( transform:Find("bg/headImage/head").gameObject, VolumeCtrl._OnHeadBtn)
end

--点击背景
function VolumeCtrl:OnBg()
    ct.OpenCtrl("HistoryCurveCtrl")
end

--倒计时
function VolumeCtrl:Countdown()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)

    if tonumber(ts.second) % 10 == 0 then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_NpcExchangeAmount') --所有npc交易量
        DataManager.DetailModelRpcNoRet(self.insId , 'm_ExchangeAmount') --所有交易量
    end

    minute = 59-tonumber(ts.minute)
    second = 59-tonumber(ts.second)
    if minute < 10 then
        minute = "0"..minute
    end
    if second < 10 then
        second = "0"..second
    end
    VolumePanel.undateTime.text = minute .. ":" .. second
end

--给表赋值
function VolumeCtrl:AssignmentDemand(table , countNpc , time)
    if table == nil then
        return
    end
    local temp = 0
    local tempTable = {}
    for i, v in pairs(table) do
        tempTable[i] = {}
        for k, z in pairs(npcConsumption[time]) do
            if countNpc[k % 9] == nil then
                temp = temp + 0
            else
                temp = temp + math.floor(countNpc[k % 9].value * z[v.itemId]/10000)
            end
        end
        tempTable[i] = temp
    end
    for i, v in pairs(tempTable) do
        table[i].demand = v
    end
end
--给表赋值
function VolumeCtrl:AssignmentDemandSupply(table , info )
    if info == nil then
        return
    end
    local temp = {}
    for i, v in pairs(table) do
        temp[i] = {}
        for k, z in pairs(info) do
            if v.itemId == z.id then
                temp[i] = z.total
            end
        end
    end
    for i, v in pairs(temp) do
        if type(v) == "number" then
            table[i].supply = v
        else
            table[i].supply = 0
        end

    end
end
