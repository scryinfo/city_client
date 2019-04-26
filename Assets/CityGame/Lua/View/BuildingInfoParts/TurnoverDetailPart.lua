---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/2 17:19
---建筑主界面今日营收曲线图
TurnoverDetailPart = class('TurnoverDetailPart', BasePartDetail)
local insId = nil
--
function TurnoverDetailPart:PrefabName()
    return "TurnoverPartDetail"
end
--
function  TurnoverDetailPart:_InitEvent()
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryBuildingIncomeMap","ss.BuildingIncome",self.n_OnBuildingIncome,self)
end
--
function TurnoverDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.luaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.xBtn.gameObject, self.OnXBtn, self)
end
--
function TurnoverDetailPart:_ResetTransform()
    self.curve.anchoredPosition = Vector3.New(-2957, 40,0)
    self.curve.sizeDelta = Vector2.New(4477, 402)
    insId = nil
end
--
function TurnoverDetailPart:_RemoveEvent()
    DataManager.ModelNoneInsIdRemoveNetMsg("sscode.OpCode", "queryBuildingIncomeMap", self)
end
--
function TurnoverDetailPart:_RemoveClick()
    self.luaBehaviour:RemoveClick(self.xBtn.gameObject, self.OnXBtn, self)
end
--
function TurnoverDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
--
function TurnoverDetailPart:_InitTransform()
    self:_getComponent(self.transform)

    self.curve.anchoredPosition = Vector3.New(-2957, 40,0)
    self.curve.sizeDelta = Vector2.New(4477, 402)
end
--
function TurnoverDetailPart:_getComponent(transform)
    self.xBtn = transform:Find("down/xBtn").gameObject --返回
    self.yScale = transform:Find("down/bg/yScale"):GetComponent("RectTransform");  --Y轴
    self.curve = transform:Find("down/bg/curveBg/curve"):GetComponent("RectTransform");
    self.slide = transform:Find("down/bg/curveBg/curve"):GetComponent("Slide");  --滑动
    self.graph = transform:Find("down/bg/curveBg/curve"):GetComponent("FunctionalGraph");  --绘制曲线
end
--
function TurnoverDetailPart:_initFunc()
    --获取营收曲线图 发包
    if insId == nil then
        local msgId = pbl.enum("sscode.OpCode","queryBuildingIncomeMap")
        local lMsg = { id = self.m_data.insId }
        local pMsg = assert(pbl.encode("ss.Id", lMsg))
        CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
    end
    insId = self.m_data.insId
end


function TurnoverDetailPart:OnXBtn(go)
    go.groupClass.TurnOffAllOptions(go.groupClass)
end

--建筑收益曲线图回调
function TurnoverDetailPart:n_OnBuildingIncome(info)
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
        currentTime = currentTime - hour * 3600      
    end
    currentTime = math.floor(currentTime)        --当天0点的时间
    local monthAgo = currentTime - 2592000       --30天前的0点
    local updataTime = monthAgo
    local time = {}
    local boundaryLine = {}
    for i = 1, 30 do
        if tonumber(getFormatUnixTime(updataTime).day) == 1 then
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            table.insert(boundaryLine,(updataTime - monthAgo + 86400) / 86400 * 148)
        else
            time[i] = tostring(getFormatUnixTime(updataTime).day)
        end
        updataTime = updataTime + 86400
    end
    local buildingTs = self.m_data.info.constructCompleteTs
    buildingTs = math.floor(buildingTs/1000)
    if tonumber(getFormatUnixTime(buildingTs).second) ~= 0 then
        buildingTs = buildingTs - tonumber(getFormatUnixTime(buildingTs).second)
    end
    if tonumber(getFormatUnixTime(buildingTs).minute) ~= 0 then
        buildingTs = buildingTs - tonumber(getFormatUnixTime(buildingTs).minute) * 60
    end
    if tonumber(getFormatUnixTime(buildingTs).hour) ~= 0 then
        buildingTs = buildingTs - tonumber(getFormatUnixTime(buildingTs).hour) * 3600
    end
    local turnoverTab = {}
    local index = 1
    updataTime = monthAgo
    if buildingTs >= monthAgo then
        while(buildingTs <= currentTime)
        do
            turnoverTab[index] = {}
            turnoverTab[index].coordinate = (buildingTs - monthAgo + 86400) / 86400 * 148
            turnoverTab[index].money = 0
            if info.nodes ~= nil then
                for i, v in pairs(info.nodes) do
                    if buildingTs == v.time /1000 then
                        turnoverTab[index].money = tonumber(GetClientPriceString(v.income))
                    end
                end
            end
            buildingTs = buildingTs + 86400
            index = index + 1
        end
    else
        for i = 1, 30 do
            turnoverTab[i].coordinate = (updataTime - monthAgo + 86400) / 86400 * 148
            turnoverTab[i].money = 0
            if info.nodes ~= nil then
                for k, v in pairs(info.nodes) do
                    if buildingTs == v.time then
                        turnoverTab[i].money = tonumber(GetClientPriceString(v.income))
                    end
                end
            end
            updataTime = updataTime + 86400
        end
    end
    local turnover = {}
    for i, v in ipairs(turnoverTab) do
        turnover[i] = Vector2.New(v.coordinate,v.money)
    end
    table.insert(time,1,"0")
    table.insert(boundaryLine,1,0)
    table.insert(turnover,1,Vector2.New(0,0))
    local max = 0
    for i, v in ipairs(turnover) do
        if v.y > max then
            max = v.y
        end
    end
    local scale = SetYScale(max,5,self.yScale)
    local turnoverVet = {}
    for i, v in ipairs(turnover) do
        if scale == 0 then
            turnoverVet[i] = v
        else
            turnoverVet[i] = Vector2.New(v.x,v.y / scale * 70)
        end
    end
    self.slide:SetXScaleValue(time,148)
    self.graph:BoundaryLine(boundaryLine)

    self.graph:DrawLine(turnoverVet,Color.New(41 / 255, 61 / 255, 108 / 255, 255 / 255))
    self.slide:SetCoordinate(turnoverVet,turnover,Color.New(41 / 255, 61 / 255, 108 / 255, 255 / 255))

    self.curve.localPosition = self.curve.localPosition + Vector3.New(0.01, 0,0)
    self.curve.sizeDelta = self.curve.sizeDelta + Vector2.New(0.01, 0)
end

