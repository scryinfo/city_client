---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/1 9:51
---交易量ctrl
VolumeCtrl = class('VolumeCtrl',UIPanel)
UIPanel:ResgisterOpen(VolumeCtrl)
--VolumeCtrl.static.Head_PATH = "View/GoodsItem/RoleHeadItem"

local volumeBehaviour;
local isClother
local clothes
local food
local house
local second
local defaultPos_Y= -74
local pool={}
local optionOneScript ={}
local state
local types = true
local optionTwosScript = {}
local isone = true
local firstshow
local createTs --开服时间

NpcShopType = {
    clothes = 1,
    food = 2,
    house = 3,
}
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
    volumeBehaviour:AddClick(VolumePanel.houseBtn,self.OnHouseBtn,self)
    --volumeBehaviour:AddClick(VolumePanel.cityBg,self.OnCityBg,self)
    volumeBehaviour:AddClick(VolumePanel.volume,self.OnVolume,self)
    volumeBehaviour:AddClick(VolumePanel.titleBg,self.OnTitleBg,self)

    volumeBehaviour:AddClick(VolumePanel.citzenRect.gameObject,self.OncitzenRect,self)
    volumeBehaviour:AddClick(VolumePanel.playerRect.gameObject,self.OnplayerRect,self)


    self.insId = OpenModelInsID.VolumeCtrl

    isClother = NpcShopType.food
    DataManager.OpenDetailModel(VolumeModel,self.insId )
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    if second % 10 == 0 then
        currentTime = math.floor(currentTime - 10)
    else
        currentTime = math.floor(currentTime - (second % 10 + 10 ))
    end

    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000,1) --每种商品购买的npc数量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000,2) --每种商品购买的npc数量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_NpcExchangeAmount') --所有npc交易量
    DataManager.DetailModelRpcNoRet(self.insId , 'm_ExchangeAmount') --所有交易量

    self.buildingTs = DataManager.GetServerCreateTs()
    createTs = self.buildingTs
    createTs = math.floor(createTs)
    if tonumber(getFormatUnixTime(createTs).second) ~= 0 then
        createTs = createTs - tonumber(getFormatUnixTime(createTs).second)
    end
    if tonumber(getFormatUnixTime(createTs).minute) ~= 0 then
        createTs = createTs - tonumber(getFormatUnixTime(createTs).minute) * 60
    end

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
    --self.playerTwosInfo = UnityEngine.UI.LoopScrollDataSource.New()  --交易信息
    --self.playerTwosInfo.mProvideData = VolumeCtrl.static.OptionTwosData
    --self.playerTwosInfo.mClearData = VolumeCtrl.static.OptionTwosClearData

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
    Event.AddListener("c_ToggleBtnThreeItem",self.c_GoodsplayerTypeThreeNum,self)
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
    Event.RemoveListener("c_ToggleBtnThreeItem",self.c_GoodsplayerTypeThreeNum,self)

end

function VolumeCtrl:Close()
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
end

function VolumeCtrl:initInsData()
    DataManager.OpenDetailModel(VolumeModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetNpcNum')
end

--多语言
function VolumeCtrl:language()

    VolumePanel.name.text = GetLanguage(11010006)
    VolumePanel.citzen.text = GetLanguage(19020001)
    VolumePanel.turnover.text = GetLanguage(19020002)
    VolumePanel.city.text = GetLanguage(19020003)
    VolumePanel.player.text = GetLanguage(28040010)
    VolumePanel.Tradingname.text = GetLanguage(19030001)
    VolumePanel.Tradingnumname.text = GetLanguage(19030002)
    VolumePanel.clotherBtnText.text = GetLanguage(20030001)
    VolumePanel.clotheText.text = GetLanguage(20030001)
    VolumePanel.foodBtnText.text = GetLanguage(20030002)
    VolumePanel.foodText.text = GetLanguage(20030002)
    VolumePanel.houseBtnText.text = GetLanguage(20050004)  --住宅
    VolumePanel.houseText.text = GetLanguage(20050004)
    VolumePanel.undateTimeText.text = GetLanguage(19020019)  --秒后刷新
    VolumePanel.requirement.text = GetLanguage(19020020)

    VolumePanel.employed.text = GetLanguage(19020021)  --就业人口
    VolumePanel.unemployed.text = GetLanguage(19020022)  --失业人口
    VolumePanel.ssum.text = GetLanguage(28030003)
    VolumePanel.stime.text = GetLanguage(28030002)
    VolumePanel.sbussiness.text = GetLanguage(19030003)
    VolumePanel.stip.text = GetLanguage(19030023)
    VolumePanel.tip.text = GetLanguage(19030023)
    VolumePanel.bussiness.text = GetLanguage(19030003)
    VolumePanel.sum.text = GetLanguage(28030003)
    VolumePanel.time.text = GetLanguage(28030002)

    VolumePanel.employed.text = GetLanguage(19020004)  --就业人口
    VolumePanel.unemployed.text = GetLanguage(19020005)  --失业人口
    VolumePanel.total.text = GetLanguage(19020012)
    VolumePanel.totalContent.text = GetLanguage(19020013)

    VolumePanel.grossVolume.text = GetLanguage(11010006)



end
--更新时间
function VolumeCtrl:Update()

    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)

    if tonumber(ts.second) % 10 == 0 then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_NpcExchangeAmount') --所有npc交易量
        DataManager.DetailModelRpcNoRet(self.insId , 'm_ExchangeAmount') --所有交易量
        currentTime = math.floor(currentTime - 10)
        DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000,1) --每种商品购买的npc数量
        DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNum',currentTime * 1000,2) --每种商品购买的npc数量
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
function VolumeCtrl:c_NpcNum(countNpc,workNpcNum,unEmployeeNpcNum)
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local time = tonumber(ts.year..ts.month..ts.day)

    VolumePanel.employedText.text = getMoneyString(workNpcNum)
    VolumePanel.unemployedText.text = getMoneyString(unEmployeeNpcNum)
    VolumeCtrl:AssignmentDemand(clothes , countNpc , time)
    VolumeCtrl:AssignmentDemand(food , countNpc , time)
    house[1].demand = workNpcNum + unEmployeeNpcNum
end

--每种商品购买的npc数量
function VolumeCtrl:c_OnGoodsNpcNum(info,type)
    if type == 1 then
        VolumeCtrl:AssignmentDemandSupply(clothes , info )
        VolumeCtrl:AssignmentDemandSupply(food , info )
        if isClother == NpcShopType.clothes then
            VolumePanel.scroll:ActiveLoopScroll(self.supplyDemand, #clothes)
        elseif isClother == NpcShopType.food then
            VolumePanel.scroll:ActiveLoopScroll(self.supplyDemand, #food)
        elseif isClother == NpcShopType.house then
            VolumePanel.scroll:ActiveLoopScroll(self.supplyDemand, #house)
        end
    elseif type == 2 then
        if info == nil then
            house[1].supply = 0
        else
            house[1].supply = info[1].total
        end
    end
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
    house = {}
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
    house[1] = {}
    house[1].itemId = 20050004
    VolumePanel.curve.anchoredPosition = Vector3.New(-18208, 56,0)
    VolumePanel.curve.sizeDelta = Vector2.New(19530, 450)
end

--返回
function VolumeCtrl:OnBack()
    PlayMusEff(1002)
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
    PlayMusEff(1002)
    isClother = NpcShopType.clothes
    VolumePanel.clothes.localScale = Vector3.one
    VolumePanel.food.localScale = Vector3.zero
    VolumePanel.house.localScale = Vector3.zero

    VolumePanel.scroll:ActiveLoopScroll(go.supplyDemand, #clothes)

end

--FoodBtn
function VolumeCtrl:OnFoodBtn(go)
    PlayMusEff(1002)
    isClother = NpcShopType.food
    VolumePanel.clothes.localScale = Vector3.zero
    VolumePanel.food.localScale = Vector3.one
    VolumePanel.house.localScale = Vector3.zero
    VolumePanel.scroll:ActiveLoopScroll(go.supplyDemand, #food)
end
--houseBtn
function VolumeCtrl:OnHouseBtn(go)
    PlayMusEff(1002)
    isClother = NpcShopType.house
    VolumePanel.clothes.localScale = Vector3.zero
    VolumePanel.food.localScale = Vector3.zero
    VolumePanel.house.localScale = Vector3.one
    VolumePanel.scroll:ActiveLoopScroll(go.supplyDemand, #house)
end

--滑动互用
VolumeCtrl.static.SupplyDemandProvideData = function(transform, idx)

    idx = idx + 1
    local item
    if isClother == NpcShopType.clothes then
        item = SupplyDemandItem:new(clothes[idx],transform)
    elseif isClother == NpcShopType.food then
        item = SupplyDemandItem:new(food[idx],transform)
    elseif isClother == NpcShopType.house then
        item = SupplyDemandItem:new(house[idx],transform)
    end
    local supplyDemand = {}
    supplyDemand[idx] = item

    volumeBehaviour:AddClick(transform:Find("bg").gameObject,VolumeCtrl.OnBg,item)
end

VolumeCtrl.static.SupplyDemandClearData = function(transform)
    volumeBehaviour:RemoveClick( transform:Find("bg").gameObject, VolumeCtrl.OnBg)
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
            if next(countNpc )== nil or countNpc[k] == nil then
                temp = temp + 0
            else
                temp = temp + math.floor(countNpc[k].value * z[v.itemId]/10000)
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
        temp[i] = 0
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
    local pos_Y= defaultPos_Y
    --VolumePanel.turnoverRect:DOSizeDelta(
    --    Vector2.New(0, 460),
    --       0.5):SetEase(DG.Tweening.Ease.OutCubic);
    VolumePanel.turnoverRect.localScale= Vector3.one

    pos_Y= pos_Y - 500

    VolumePanel.playerRect:DOAnchorPos(Vector2.New(159, pos_Y),
            0.5):SetEase(DG.Tweening.Ease.OutCubic);

    VolumePanel.infoBgrRect.localScale= Vector3.zero
    VolumePanel.playercurrRoot.gameObject:SetActive(false)
    VolumePanel.trade.localScale = Vector3.zero
    VolumePanel.strade.localScale = Vector3.zero
    VolumePanel.curve.anchoredPosition = Vector3.New(-18208, 56,0)
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

    VolumePanel.playerRect:DOAnchorPos(Vector2.New(159, -150),
            0.5):SetEase(DG.Tweening.Ease.OutCubic);

    DataManager.DetailModelRpcNoRet(ins.insId , 'm_PlayerTypeNum')              --获取玩家交易量
    DataManager.DetailModelRpcNoRet(ins.insId , 'm_PlayerNum')                  --获取玩家数量
    VolumePanel.infoBgrRect.localScale= Vector3.one
    VolumePanel.playercurrRoot.gameObject:SetActive(true)                                       --将玩家交易量节点设置为可见
    if  VolumePanel.threeScrollcontent.transform.childCount == 0 then
        VolumePanel.trade.localScale = Vector3.one
    else
        VolumePanel.strade.localScale = Vector3.one
    end
    --点击之后初始化显示

    --VolumePanel.infoBgrRect:DOSizeDelta(
    --        Vector2.New(0, 336),
    --        0.5):SetEase(DG.Tweening.Ease.OutCubic);

    --第一次进入初始化显示土地租赁
    if isone then
        local info = {}
        info.id = 888
        info.exchangeType = 3
        info.type = types
        DataManager.DetailModelRpcNoRet(ins.insId , 'm_PlayerNumCurve',info)
        VolumePanel.firstScroll:ActiveLoopScroll(ins.playerOneInfo, #DealConfig, "View/Laboratory/ToggleBtnItem")
        VolumePanel.secondScroll:ActiveLoopScroll(ins.playerTwosInfo, #DealConfig[1].childs, "View/Laboratory/ToggleBtnTwoItem")
        VolumePanel.trade.localScale = Vector3.one
    end
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
    optionOneScript[1].highlight.localScale = Vector3.one

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
--VolumeCtrl.static.OptionTwosData = function(transform, idx)
--    --ToggleBtnItem.city = {}
--    idx = idx + 1
--    optionTwosScript[idx] = ToggleBtnTwoItem:new(transform, volumeBehaviour, DealConfig[1].childs[idx], idx)
--    --ToggleBtnItem.city = optionTwosScript[idx]
--end

--VolumeCtrl.static.OptionTwosClearData = function(transform)
--end
--初始化显示
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


--玩家交易信息（金额）曲线
function VolumeCtrl:c_GoodsplayerTypeNum(info)
    VolumePanel.slide:Close()
    VolumePanel.graph:Close()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    if second ~= 0 then
        currentTime = currentTime - second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    currentTime = math.floor(currentTime)
    local demandNumTab = {}
    local sevenDaysAgo = currentTime - 604800
    local updataTime = sevenDaysAgo
    local time = {}
    local boundaryLine = {}
    if createTs >= sevenDaysAgo then
        updataTime = createTs
        for i = 1, 168 do
            if tonumber(getFormatUnixTime(updataTime).hour) == 0 then
                time[i] = getFormatUnixTime(updataTime).month .. "/" ..getFormatUnixTime(updataTime).day
                table.insert(boundaryLine,(updataTime - createTs +3600)/3600 * 116)
            else
                time[i] = getFormatUnixTime(updataTime).hour ..":00"
            end
            if updataTime <= currentTime then
                demandNumTab[i] = {}
                demandNumTab[i] .ts = (updataTime - createTs +3600)/3600 * 116
                if info == nil then
                    demandNumTab[i].num = 0
                else
                    for k, v in ipairs(info) do
                        if math.floor(v.time/1000) == updataTime then
                            demandNumTab[i].num = tonumber(GetClientPriceString(v.money))
                        end
                    end
                end
            end
            updataTime = updataTime + 3600
        end
    else
        for i = 1, 168 do
            demandNumTab[i] = {}
            demandNumTab[i] .ts = (updataTime - sevenDaysAgo +3600)/3600 * 116
            if tonumber(getFormatUnixTime(updataTime).hour) == 0 then
                time[i] = getFormatUnixTime(updataTime).month .. "/" ..getFormatUnixTime(updataTime).day
                table.insert(boundaryLine,(updataTime - sevenDaysAgo +3600)/3600 * 116)
            else
                time[i] = getFormatUnixTime(updataTime).hour ..":00"
            end
            if info == nil then
                demandNumTab[i].num = 0
            else
                for k, v in ipairs(info) do
                    if math.floor(v.time/1000) == updataTime then
                        demandNumTab[i].num = tonumber(GetClientPriceString(v.money))
                    end
                end
            end
            updataTime = updataTime + 3600
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
    local scale = SetYScale(max,4,VolumePanel.yScale)
    for i, v in ipairs(demandNumValue) do
        if scale == 0 then
            demandNumVet[i] = v
        else
            demandNumVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end

    local difference = (currentTime - createTs) / 3600  --距离开业的天数
    if difference < 11 then
        VolumePanel.curve.anchoredPosition = Vector3.New(0, 54,0)
        VolumePanel.curve.sizeDelta = Vector2.New(1305, 443)
    elseif difference < 168 then
        VolumePanel.curve.anchoredPosition = Vector3.New(0, 54,0)
        VolumePanel.curve.sizeDelta = Vector2.New(1305, 443)
        VolumePanel.curve.anchoredPosition = Vector3.New(VolumePanel.curve.anchoredPosition.x - (difference - 11) * 116, 54,0)
        VolumePanel.curve.sizeDelta = Vector2.New(VolumePanel.curve.sizeDelta.x + (difference - 11) * 116, 443)
    else
        VolumePanel.curve.anchoredPosition = Vector3.New(-18223, 54,0)
        VolumePanel.curve.sizeDelta = Vector2.New(19229, 443)
    end

    VolumePanel.slide:SetXScaleValue(time,116)
    VolumePanel.graph:BoundaryLine(boundaryLine)
    VolumePanel.graph:DrawLine(demandNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)
    VolumePanel.slide:SetCoordinate(demandNumVet,demandNumValue,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)

    VolumePanel.curve.localPosition = VolumePanel.curve.localPosition + Vector3.New(0.01, 0,0)
    VolumePanel.curve.sizeDelta = VolumePanel.curve.sizeDelta + Vector2.New(0.01, 0)
end

--玩家交易信息（金额）曲线
function VolumeCtrl:c_GoodsplayerTypeThreeNum(info)
    VolumePanel.sslide:Close()
    VolumePanel.sgraph:Close()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    if second ~= 0 then
        currentTime = currentTime - second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    currentTime = math.floor(currentTime)
    local demandNumTab = {}
    local sevenDaysAgo = currentTime - 604800
    local updataTime = sevenDaysAgo
    local time = {}
    local boundaryLine = {}

    if createTs >= sevenDaysAgo then
        updataTime = createTs
        for i = 1, 168 do
            if tonumber(getFormatUnixTime(updataTime).hour) == 0 then
                time[i] = getFormatUnixTime(updataTime).month .. "/" ..getFormatUnixTime(updataTime).day
                table.insert(boundaryLine,(updataTime - createTs + 3600)/3600 * 116)
            else
                time[i] = getFormatUnixTime(updataTime).hour ..":00"
            end
            if updataTime <= currentTime then
                demandNumTab[i] = {}
                demandNumTab[i] .ts = (updataTime - createTs +3600)/3600 * 116
                if info == nil then
                    demandNumTab[i].num = 0
                else
                    for k, v in ipairs(info) do
                        if math.floor(v.time/1000) == updataTime then
                            demandNumTab[i].num = tonumber(GetClientPriceString(v.money))
                        end
                    end
                end
            end
            updataTime = updataTime + 3600
        end
    else
        for i = 1, 168 do
            demandNumTab[i] = {}
            demandNumTab[i] .ts = (updataTime - sevenDaysAgo +3600)/3600 * 116
            if tonumber(getFormatUnixTime(updataTime).hour) == 0 then
                time[i] = getFormatUnixTime(updataTime).month .. "/" ..getFormatUnixTime(updataTime).day
                table.insert(boundaryLine,(updataTime - sevenDaysAgo +3600)/3600 * 116)
            else
                time[i] = getFormatUnixTime(updataTime).hour ..":00"
            end
            if info == nil then
                demandNumTab[i].num = 0
            else
                for k, v in ipairs(info) do
                    if math.floor(v.time/1000) == updataTime then
                        demandNumTab[i].num = tonumber(GetClientPriceString(v.money))
                    end
                end
            end
            updataTime = updataTime + 3600
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
    local scale = SetYScale(max,4,VolumePanel.syScale)
    for i, v in ipairs(demandNumValue) do
        if scale == 0 then
            demandNumVet[i] = v
        else
            demandNumVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end

    local difference = (currentTime - createTs) / 3600  --距离开业的天数
    if difference < 11 then
        VolumePanel.scurve.anchoredPosition = Vector3.New(0, 70,0)
        VolumePanel.scurve.sizeDelta = Vector2.New(1306, 420)
    elseif difference < 168 then
        VolumePanel.scurve.anchoredPosition = Vector3.New(0, 70,0)
        VolumePanel.scurve.sizeDelta = Vector2.New(1306, 420)
        VolumePanel.scurve.anchoredPosition = Vector3.New(VolumePanel.scurve.anchoredPosition.x - (difference - 11) * 116, 70,0)
        VolumePanel.scurve.sizeDelta = Vector2.New(VolumePanel.scurve.sizeDelta.x + (difference - 11) * 116, 420)
    else
        VolumePanel.scurve.anchoredPosition = Vector3.New(-18223, 70,0)
        VolumePanel.scurve.sizeDelta = Vector2.New(19229, 420)
    end

    VolumePanel.sslide:SetXScaleValue(time,116)
    VolumePanel.sgraph:BoundaryLine(boundaryLine)
    VolumePanel.sgraph:DrawLine(demandNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)
    VolumePanel.sslide:SetCoordinate(demandNumVet,demandNumValue,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)

    VolumePanel.scurve.localPosition = VolumePanel.scurve.localPosition + Vector3.New(0.01, 0,0)
    VolumePanel.scurve.sizeDelta = VolumePanel.scurve.sizeDelta + Vector2.New(0.01, 0)
end