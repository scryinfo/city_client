---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/12 15:23
---历史曲线图ctrl
HistoryCurveCtrl = class('HistoryCurveCtrl',UIPanel)
UIPanel:ResgisterOpen(HistoryCurveCtrl)

local curveBehaviour
local maxValue = 0
local value
local scaleValue

function  HistoryCurveCtrl:bundleName()
    return "Assets/CityGame/Resources/View/HistoryCurvePanel.prefab"
end

function HistoryCurveCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function HistoryCurveCtrl:Awake()
    curveBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    curveBehaviour:AddClick(HistoryCurvePanel.xBtn,self.OnBack,self)
    self.insId = OpenModelInsID.HistoryCurveCtrl
    self:initData()
end

function HistoryCurveCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_GoodsNpcNumCurve",self.c_GoodsNpcNumCurve,self) --每种商品购买的npc数量曲线图（供应）
    Event.AddListener("c_GoodsNpcTypeNum",self.c_GoodsNpcTypeNum,self) --每种商品购买的npc数量曲线图(需求)
    LoadSprite(SupplyDemandGood[self.m_data], HistoryCurvePanel.goods, true)
    HistoryCurvePanel.goodsText.text = GetLanguage(self.m_data)
end

function HistoryCurveCtrl:Refresh()
    DataManager.OpenDetailModel(HistoryCurveModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcTypeNum')
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GoodsNpcNumCurve',self.m_data)
end

function HistoryCurveCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_GoodsNpcNumCurve",self.c_GoodsNpcNumCurve,self) --每种商品购买的npc数量曲线图(供应)
    Event.RemoveListener("c_GoodsNpcTypeNum",self.c_GoodsNpcTypeNum,self) --每种商品购买的npc数量曲线图（需求）

    maxValue = 0
    value = nil
    scaleValue = nil
    HistoryCurvePanel.graph:Close()
end

function HistoryCurveCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function HistoryCurveCtrl:initData()
    HistoryCurvePanel.curve.anchoredPosition = Vector3.New(-18524, 56,0)
    HistoryCurvePanel.curve.sizeDelta = Vector2.New(19530, 450)
end

function HistoryCurveCtrl:OnBack()
    HistoryCurvePanel.curve.anchoredPosition = Vector3.New(-18524, 56,0)
    HistoryCurvePanel.curve.sizeDelta = Vector2.New(19530, 450)
    UIPanel.ClosePage()
end

--需求
function HistoryCurveCtrl:c_GoodsNpcTypeNum(info)
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime -second
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
                if math.floor(v.t/1000) == sevenDaysAgo then
                    demandNumTab[i].num = math.floor(npcConsumption[tonumber(getFormatUnixTime(sevenDaysAgo).year..getFormatUnixTime(sevenDaysAgo)
                            .month..getFormatUnixTime(sevenDaysAgo).day)][v.npcTypeNumMap.tp][self.m_data] / 10000 * v.npcTypeNumMap.n)
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
    local scale = 0
    if max > maxValue then
        maxValue = max
        scale = SetYScale(maxValue,6,HistoryCurvePanel.yScale)
    end
    scaleValue = scale
    value = demandNumValue

    HistoryCurvePanel.slide:SetXScaleValue(time,116)
    HistoryCurvePanel.graph:BoundaryLine(boundaryLine)

    HistoryCurvePanel.curve.localPosition = HistoryCurvePanel.curve.localPosition + Vector3.New(0.01, 0,0)
    HistoryCurvePanel.curve.sizeDelta = HistoryCurvePanel.curve.sizeDelta + Vector2.New(0.01, 0)
end
--每种商品购买的npc数量曲线图  (供应)
function HistoryCurveCtrl:c_GoodsNpcNumCurve(info)
    if info == nil then
        info = {}
    end
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime -second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    if hour ~= 0 then
        currentTime = currentTime - hour * 3600 - 3600       --当天0点在提前一小时
    end
    currentTime = math.floor(currentTime)
    local sevenDaysAgoTime = currentTime - 604800
    local sevenDaysAgo = sevenDaysAgoTime
    local supplyNum = {}
    local supplyNumValue = {}
    for i = 1, 168 do
        sevenDaysAgo = sevenDaysAgo + 3600
        supplyNum[i] = {}
        supplyNum[i].ts = sevenDaysAgo
        supplyNum[i].num = 0
    end
    if next(info) ~= nil then
        local temp = {}
        for i, v in ipairs(supplyNum) do
            temp[i] = {}
            for k, z in ipairs(info) do
                if v.ts == z.key then
                    temp[i].num = z.value
                else
                    temp[i].num = 0
                end
            end
        end
        for i, v in ipairs(temp) do
            supplyNum[i].num = v.num
        end
        for i, v in ipairs(supplyNum) do
            supplyNumValue[i] = Vector2.New((v.ts-sevenDaysAgoTime) /3600 *116,v.num)
        end
    else
        for i, v in ipairs(supplyNum) do
            supplyNumValue[i] = Vector2.New((v.ts-sevenDaysAgoTime) /3600 *116,v.num)
        end
    end
    table.insert(supplyNumValue,1,Vector2.New(0,0))
    local max = 0
    for i, v in ipairs(supplyNumValue) do
        if v.y > max then
            max = v.y
        end
    end
    local scale = scaleValue
    if max > maxValue then
       maxValue = max
        scale =  SetYScale(HistoryCurvePanel.yScale,maxValue)
    end
    local supplyNumVet = {}
    for i, v in ipairs(supplyNumValue) do
        if scale == 0 then
            supplyNumVet[i] = v
        else
            supplyNumVet[i] = Vector2.New(v.x,v.y / scale * 60)
        end
    end

    local demandNumVet = {}
    for i, v in ipairs(value) do
        if scale == 0 then
            demandNumVet[i] = v
        else
            demandNumVet[i] = Vector2.New(v.x,v.y / scale * 60)
        end
    end


    --需求线
    HistoryCurvePanel.graph:DrawLine(demandNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)
    HistoryCurvePanel.slide:SetCoordinate(demandNumVet,value,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)

    --供应线
    HistoryCurvePanel.graph:DrawLine(supplyNumVet,Color.New(13 / 255, 179 / 255, 169 / 255, 255 / 255),2)
    HistoryCurvePanel.slide:SetCoordinate(supplyNumVet,supplyNumValue,Color.New(13 / 255, 79 / 255, 169 / 255, 255 / 255),2)
end

