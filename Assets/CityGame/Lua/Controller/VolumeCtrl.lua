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
local second
local defaultPos_Y= -74
local pool={}
local optionOneScript ={}
local state
local istype = true
local optionTwosScript = {}
local isone = true
local firstshow
local  function InsAndObjectPool(config,class,prefabPath,parent,LuaBehaviour,this)
    if not pool[class] then
        pool[class]={}
    end
    --对象池创建物体
    local tempList={}
    for i, value in ipairs(config) do
        local ins =pool[class][1]
        if ins then  --有实例
            ins:updateData(value)
            value.id=i
            ins.prefab:SetActive(true)
            table.insert(tempList,ins)
            table.remove(pool[class],1)
        else--无实例
            local prefab=creatGoods(prefabPath,parent)
            value.id=i
            local ins=class:new(prefab,LuaBehaviour,value,this)
            table.insert(tempList,ins)
        end
    end
    --多余实例隐藏
    if #pool[class]>0 then
        for key, ins in ipairs(pool[class]) do
            ins.prefab:SetActive(false)
            table.insert(tempList,ins)
            pool[class][key]=nil
        end
    end
    --所有实例归还对象池
    for i, ins in ipairs(tempList) do
        table.insert(pool[class],ins)
    end
end
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
    --volumeBehaviour:AddClick(VolumePanel.cityBg,self.OnCityBg,self)
    volumeBehaviour:AddClick(VolumePanel.volume,self.OnVolume,self)
    volumeBehaviour:AddClick(VolumePanel.titleBg,self.OnTitleBg,self)

    volumeBehaviour:AddClick(VolumePanel.citzenRect.gameObject,self.OncitzenRect,self)
    volumeBehaviour:AddClick(VolumePanel.playerRect.gameObject,self.OnplayerRect,self)


    self.insId = OpenModelInsID.VolumeCtrl

    DataManager.OpenDetailModel(VolumeModel,self.insId )
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    if second % 10 == 0 then
        currentTime = math.floor(currentTime - 10)
    else
        currentTime = math.floor(currentTime - (second % 10 + 10 ))
    end

    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000) --每种商品购买的npc数量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_NpcExchangeAmount') --所有npc交易量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_ExchangeAmount') --所有交易量

    self.initData()
    --滑动互用
    self.supplyDemand = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.supplyDemand.mProvideData = VolumeCtrl.static.SupplyDemandProvideData
    self.supplyDemand.mClearData = VolumeCtrl.static.SupplyDemandClearData


    -- 第一层信息展示
    self.playerOneInfo = UnityEngine.UI.LoopScrollDataSource.New()  --交易信息
    self.playerOneInfo.mProvideData = VolumeCtrl.static.OptionOneData
    self.playerOneInfo.mClearData = VolumeCtrl.static.OptionOneClearData

    -- 第二层信息展示
    self.playerTwosInfo = UnityEngine.UI.LoopScrollDataSource.New()  --交易信息
    self.playerTwosInfo.mProvideData = VolumeCtrl.static.OptionTwosData
    self.playerTwosInfo.mClearData = VolumeCtrl.static.OptionTwosClearData

    --初始化循环参数
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self.Update, self), 1, -1, true)


end

function VolumeCtrl:Active()
    UIPanel.Active(self)
    VolumeCtrl:language()
    self.m_Timer:Start()
    Event.AddListener("c_NpcNum",self.c_NpcNum,self)
    Event.AddListener("c_OnGoodsNpcNum",self.c_OnGoodsNpcNum,self)
    Event.AddListener("c_NpcExchangeAmount",self.c_NpcExchangeAmount,self)   --所有npc交易量
    Event.AddListener("c_ExchangeAmount",self.c_ExchangeAmount,self)         --所有交易量
    Event.AddListener("c_allbuyAmount",self.c_allbuyAmount,self)             --玩家所有交易量
    Event.AddListener("c_currebPlayerNum",self.c_allPlayerAmount,self)       --玩家数量
    Event.AddListener("c_ToggleBtnTwoItem",self.c_GoodsplayerTypeNum,self)       --点击玩家按钮后初始化土地
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
    Event.RemoveListener("c_NpcExchangeAmount",self.c_NpcExchangeAmount,self)  --所有npc交易量
    Event.RemoveListener("c_ExchangeAmount",self.c_ExchangeAmount,self)        --所有交易量
    Event.RemoveListener("c_allbuyAmount",self.c_allbuyAmount,self)          --玩家所有交易量
    Event.RemoveListener("c_currebPlayerNum",self.c_allPlayerAmount,self)          --玩家数量
    Event.RemoveListener("c_ToggleBtnTwoItem",self.c_GoodsplayerTypeNum,self)

end

function VolumeCtrl:initInsData()
    DataManager.OpenDetailModel(VolumeModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetNpcNum')
end
function VolumeCtrl:language()

   VolumePanel.name.text = GetLanguage(11010006)
   VolumePanel.citzen.text = GetLanguage(19020001)
   VolumePanel.turnover.text = GetLanguage(19020002)
   VolumePanel.city.text = GetLanguage(19020003)
   VolumePanel.player.text = GetLanguage(28040010)
   VolumePanel.Tradingname.text = GetLanguage(19030001)
   VolumePanel.Tradingnumname.text = GetLanguage(19030002)
   VolumePanel.clotherBtnText.text = GetLanguage(20030002)
   VolumePanel.clothes.text = GetLanguage(20030002)
   VolumePanel.foodBtnText.text = GetLanguage(20030001)
   VolumePanel.foodText.text = GetLanguage(20030001)


end
--更新时间
function VolumeCtrl:Update()

    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)

    if tonumber(ts.second) % 10 == 0 then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_NpcExchangeAmount') --所有npc交易量
        DataManager.DetailModelRpcNoRet(self.insId , 'm_ExchangeAmount') --所有交易量
        currentTime = math.floor(currentTime - 10)
        DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000) --每种商品购买的npc数量
    end
    second = 10 - tonumber(ts.second) % 10
    if second < 10 then
        second = "0"..second
    end
    if tonumber(second) <= 0 then
        second = 10
    end
    if second  then
        VolumePanel.undateTime.text = second
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

--玩家所有交易量
function VolumeCtrl:c_allbuyAmount(info)
    VolumePanel.TradingCount.text = "E"..getMoneyString(GetClientPriceString(info))
end

--玩家数量
function VolumeCtrl:c_allPlayerAmount(info)
    VolumePanel.Tradingnum.text = info
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
    VolumePanel.curve.anchoredPosition = Vector3.New(-18524, 56,0)
    VolumePanel.curve.sizeDelta = Vector2.New(19530, 450)
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

    volumeBehaviour:AddClick(transform:Find("bg").gameObject,VolumeCtrl.OnBg,item)
end

VolumeCtrl.static.SupplyDemandClearData = function(transform)
    volumeBehaviour:RemoveClick( transform:Find("bg/headImage/head").gameObject, VolumeCtrl._OnHeadBtn)
end

--点击背景
function VolumeCtrl:OnBg(ins)
    ct.OpenCtrl("HistoryCurveCtrl",ins.itemId)
    --DataManager.DetailModelRpcNoRet(OpenModelInsID.VolumeCtrl , 'm_GoodsNpcNumCurve',ins.itemId)
    --DataManager.DetailModelRpcNoRet(OpenModelInsID.VolumeCtrl , 'm_GoodsNpcTypeNum')
end

--倒计时
function VolumeCtrl:Countdown()

end

--给表赋值
function VolumeCtrl:AssignmentDemand(table , countNpc , time)
    if countNpc == nil then
        countNpc = {}
    end
    if table == nil then
        return
    end
    local tempTable = {}
    for i, v in pairs(table) do
        local temp = 0
        tempTable[i] = {}
        for k, z in pairs(npcConsumption[time]) do
            if next(countNpc )== nil or countNpc[k % 9] == nil then
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

--打开npc交易
function VolumeCtrl:OncitzenRect(ins)
    local pos_Y=defaultPos_Y
    --VolumePanel.turnoverRect:DOSizeDelta(
    --    Vector2.New(0, 460),
    --       0.5):SetEase(DG.Tweening.Ease.OutCubic);
    VolumePanel.turnoverRect.localScale= Vector3.one

    pos_Y= pos_Y- (102 + 460)

    VolumePanel.playerRect:DOAnchorPos(Vector2.New(-2.5, pos_Y),
           0.5):SetEase(DG.Tweening.Ease.OutCubic);

    VolumePanel.infoBgrRect.localScale= Vector3.zero
    VolumePanel.playercurrRoot.gameObject:SetActive(false)
    VolumePanel.trade.localScale = Vector3.zero
    VolumePanel.strade.localScale = Vector3.zero
    VolumePanel.curve.anchoredPosition = Vector3.New(-18524, 56,0)
    VolumePanel.curve.sizeDelta = Vector2.New(19530, 450)
    --VolumePanel.infoBgrRect:DOSizeDelta(
    --        Vector2.New(0, 0),
    --        0.5):SetEase(DG.Tweening.Ease.OutCubic);
end

--打开玩家交易
function VolumeCtrl:OnplayerRect(ins)
    local pos_Y=defaultPos_Y
    --VolumePanel.turnoverRect:DOSizeDelta(
    --        Vector2.New( 0,0 ),
    --        0.5):SetEase(DG.Tweening.Ease.OutCubic);
    VolumePanel.turnoverRect.localScale= Vector3.zero

    pos_Y= pos_Y - 102

    VolumePanel.playerRect:DOAnchorPos(Vector2.New(-2.5, -115),
            0.5):SetEase(DG.Tweening.Ease.OutCubic);

    DataManager.DetailModelRpcNoRet(ins.insId , 'm_PlayerTypeNum')
    DataManager.DetailModelRpcNoRet(ins.insId , 'm_PlayerNum')
    VolumePanel.infoBgrRect.localScale= Vector3.one
    VolumePanel.playercurrRoot.gameObject:SetActive(true)

    --点击之后初始化显示
    local info = {}
    info.id = 888
    info.exchangeType = 3
    info.type = type
    DataManager.DetailModelRpcNoRet(ins.insId , 'm_PlayerNumCurve',info)

    --VolumePanel.infoBgrRect:DOSizeDelta(
    --        Vector2.New(0, 336),
    --        0.5):SetEase(DG.Tweening.Ease.OutCubic);
    VolumePanel.firstScroll:ActiveLoopScroll(ins.playerOneInfo, #DealConfig, "View/Laboratory/ToggleBtnItem")

    VolumePanel.trade.localScale = Vector3.one
    --self:initPayerVolume()

end

function VolumeCtrl:initPayerVolume(go)
    local temps ={}
    InsAndObjectPool(DealConfig,ToggleBtnItem,"View/Laboratory/ToggleBtnItem",VolumePanel.firstScroll,volumeBehaviour,self)
end

-- 第一层信息显示
VolumeCtrl.static.OptionOneData = function(transform, idx)
    idx = idx + 1
    optionOneScript[idx] = ToggleBtnItem:new(transform, volumeBehaviour, DealConfig[idx], idx)
    if idx == 1 then
        optionOneScript[idx].highlight.localScale = Vector3.one
    end
    volumeBehaviour:AddClick(transform.transform:Find("bgBtn").gameObject,VolumeCtrl.c_OnClick_Delete,optionOneScript[idx])
    if isone then
        VolumeCtrl:initPayer( optionOneScript[idx] )
        isone = false
    end
end

function VolumeCtrl:initPayer(go)
    VolumePanel.secondScroll:ActiveLoopScroll(go.playerTwoInfo, #DealConfig[1].childs,"View/Laboratory/ToggleBtnTwoItem")
end

VolumeCtrl.static.OptionOneClearData = function(transform)
end

--第二层信息显示
VolumeCtrl.static.OptionTwosData = function(transform, idx)
    --ToggleBtnItem.city = {}
    idx = idx + 1
    optionTwosScript[idx] = ToggleBtnTwoItem:new(transform, volumeBehaviour, DealConfig[1].childs[idx], idx)
    --ToggleBtnItem.city = optionTwosScript[idx]
end

VolumeCtrl.static.OptionTwosClearData = function(transform)
end

function VolumeCtrl:c_OnClick_Delete(ins)
    local item = {}
    local type = ins.data.childs
    optionOneScript[ins.ctrl]:Aaa(DealConfig[ins.ctrl])
    VolumePanel.strade.localScale = Vector3.zero
    VolumePanel.trade.localScale = Vector3.zero
    if state ~= nil then
        state.localScale = Vector3.zero
    end
    state = ins.highlight
    ins.highlight.localScale = Vector3.one
    if firstshow == nil then                                                 ---第一次进入第一层关闭高亮
        optionOneScript[1].highlight.localScale = Vector3.zero
        firstshow = 1
    end
    if optionOneScript[ins.ctrl].city  then                                 ---点击第一层item清空二三层item
        VolumePanel.threeScroll:ActiveLoopScroll(optionOneScript[ins.ctrl].city.ToggleBtnTwoItem, 0,"View/Laboratory/ToggleBtnThreeItem")
    end
    if ins.data.childs.childs ~= nil then
        VolumePanel.threeScroll:ActiveLoopScroll(ins.playerTwoInfo, #ins.data.childs,"View/Laboratory/ToggleBtnThreeItem")
    else
        VolumePanel.secondScroll:ActiveLoopScroll(ins.playerTwoInfo, #ins.data.childs,"View/Laboratory/ToggleBtnTwoItem")
    end
    prints("ToggleBtnItem")
end


--玩家交易信息（金额）
function VolumeCtrl:c_GoodsplayerTypeNum(info)
    VolumePanel.slide:Close()
    VolumePanel.graph:Close()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime - second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    if hour ~= 0 then
        currentTime = currentTime - hour * 3600 - 3600       --当天0点在提前一小时
    end
    currentTime = math.floor(currentTime)
    local demandNumTab = {}
    local sevenDaysAgo = currentTime - 604800
    local sevenDaysAgoTime = sevenDaysAgo
    local time = {}
    local boundaryLine = {}
    for i = 1, 168 do
        sevenDaysAgo = sevenDaysAgo + 3600
        time[i] = sevenDaysAgo
        demandNumTab[i] = {}
        demandNumTab[i] .ts = (sevenDaysAgo - sevenDaysAgoTime)/3600 * 116
        if tonumber(getFormatUnixTime(sevenDaysAgo).hour) == 0 then
            time[i] = getFormatUnixTime(sevenDaysAgo).month .. "/" .. getFormatUnixTime(sevenDaysAgo).day
            table.insert(boundaryLine,(sevenDaysAgo - sevenDaysAgoTime )/3600 * 116)
        else
            time[i] = tostring(getFormatUnixTime(sevenDaysAgo).hour)
        end
        if info == nil then
            demandNumTab[i].num = 0
        else
            for k, v in ipairs(info) do
                if math.floor(v.time/1000) == sevenDaysAgo then
                    demandNumTab[i].num = tonumber(GetClientPriceString(v.money))
                end
            end
        end
    end

    table.insert(time,1,"0")
    table.insert(boundaryLine,1,0)

    local demandNumValue = {}
    for i, v in ipairs(demandNumTab) do
        demandNumValue[i] = Vector2.New(v.ts,v.num)
    end
    table.insert(demandNumValue,1,Vector2.New(0,0))

    local max = 0
    for i, v in ipairs(demandNumValue) do
        if v.y > max then
            max = v.y
        end
    end
    local demandNumVet = {}
    local scale = SetYScale(max,6,VolumePanel.yScale)
    for i, v in ipairs(demandNumValue) do
        if scale == 0 then
            demandNumVet[i] = v
        else
            demandNumVet[i] = Vector2.New(v.x,v.y / scale * 60)
        end
    end

    VolumePanel.slide:SetXScaleValue(time,116)
    VolumePanel.graph:BoundaryLine(boundaryLine)
    VolumePanel.graph:DrawLine(demandNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)
    VolumePanel.slide:SetCoordinate(demandNumVet,demandNumValue,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)

    VolumePanel.curve.localPosition = VolumePanel.curve.localPosition + Vector3.New(0.01, 0,0)
    VolumePanel.curve.sizeDelta = VolumePanel.curve.sizeDelta + Vector2.New(0.01, 0)
end