---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/5/14 17:43
---

ToggleBtnThreeItem = class('ToggleBtnThreeItem')

local optionThreeScript = {}
local volumeBehaviour
local insId
local playerdata = {}
local state
local type = true
---初始化方法   数据（读配置表）
function ToggleBtnThreeItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab = prefab
    volumeBehaviour = luaBehaviour
    self.data = data
    self.ctrl = ctrl

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    --self.deleteBtn=prefab.transform:Find("Button")
    self.foodtext = prefab.transform:Find("food/foodText"):GetComponent("Text")
    self.bgBtn = prefab.transform:Find("bgBtn")
    self.highlight = prefab.transform:Find("highlight")

    self.ToggleBtnThreeItem = UnityEngine.UI.LoopScrollDataSource.New()
    self.ToggleBtnThreeItem.mProvideData = ToggleBtnThreeItem.static.OptionTwoData
    self.ToggleBtnThreeItem.mClearData = ToggleBtnThreeItem.static.OptionTwoClearData

    VolumePanel.scurve.anchoredPosition = Vector3.New(-18208, 65,0)
    VolumePanel.scurve.sizeDelta = Vector2.New(19530, 450)
    insId = OpenModelInsID.VolumeCtrl
    self:Refresh(data)
    Event.AddListener("c_ToggleBtnThreeItem",self.c_GoodsplayerTypeThreeNum,self)
    luaBehaviour:AddClick(self.bgBtn.gameObject,self._tradingOpenFunc,self)
end

---==========================================================================================点击函数=============================================================================
--打开交易折线图
function ToggleBtnThreeItem:_tradingOpenFunc(ins)
    VolumePanel.strade.localScale = Vector3.one
    VolumePanel.scurve.anchoredPosition = Vector3.New(-18208, 80,0)
    VolumePanel.scurve.sizeDelta = Vector2.New(19530, 450)
    if state ~= nil then
        state.localScale = Vector3.zero
    end
    state = ins.highlight
    ins.highlight.localScale = Vector3.one
    local info = {}
    info.id = ins.data.typeId
    info.exchangeType = ins.data.EX
    info.type = type
    DataManager.DetailModelRpcNoRet(insId , 'm_PlayerNumCurve',info)
    --DataManager.OpenDetailModel(VolumeModel,ins.insId )
    --DataManager.DetailModelRpcNoRet(insId , 'm_PlayerTypeNum')
    --DataManager.DetailModelRpcNoRet(insId , 'm_PlayerNumCurve',ins.data.typeId)
end

--删除2
function ToggleBtnThreeItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
    Event.RemoveListener("c_ToggleBtnThreeItem",self.c_GoodsplayerTypeThreeNum,self)
end


---==========================================================================================业务逻辑=============================================================================



-- 第二层信息展示
function ToggleBtnThreeItem:updateData( data )
    self.data = data
    self.foodtext.text = GetLanguage(self.data.name)
end

function ToggleBtnThreeItem:updateUI( data )
    --LoadSprite()
    if data.beginProcessTs > 0 then
        local curTime = TimeSynchronized.GetTheCurrentServerTime()
        local hasRunTime = curTime - data.beginProcessTs
    end
end

function ToggleBtnThreeItem:Refresh(data)
    self:updateData(data)
    --self:updateUI(data)
end

-- 第二层信息显示
ToggleBtnThreeItem.static.OptionTwoData = function(transform, idx)
    idx = idx + 1
    optionThreeScript[idx] = ToggleBtnThreeItem:new(transform, volumeBehaviour, DealConfig[idx].childs, idx)
end

ToggleBtnThreeItem.static.OptionTwoClearData = function(transform)
end

function ToggleBtnThreeItem:Aaa(data)
    playerdata = data
end

function ToggleBtnThreeItem:c_GoodsplayerTypeThreeNum(info)
    VolumePanel.sslide:Close()
    VolumePanel.sgraph:Close()
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
    --if hour ~= 0 then
    --    currentTime = currentTime - hour * 3600 - 3600       --当天0点在提前一小时
    --end
    currentTime = math.floor(currentTime)
    local demandNumTab = {}
    local sevenDaysAgo = currentTime - 604800
    local sevenDaysAgoTime = sevenDaysAgo
    local time = {}
    local boundaryLine = {}
    for i = 1, 168 do
        sevenDaysAgo = sevenDaysAgo + 3600
        demandNumTab[i] = {}
        demandNumTab[i] .ts = (sevenDaysAgo - sevenDaysAgoTime)/3600 * 116
        if tonumber(getFormatUnixTime(sevenDaysAgo).hour) == 0 then
            time[i] = getFormatUnixTime(sevenDaysAgo).month .. "/" ..getFormatUnixTime(sevenDaysAgo).day
            table.insert(boundaryLine,(sevenDaysAgo - sevenDaysAgoTime )/3600 * 116)
        else
            time[i] = getFormatUnixTime(sevenDaysAgo).hour ..":00"
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
    local scale = SetYScale(max,4,VolumePanel.syScale)
    for i, v in ipairs(demandNumValue) do
        if scale == 0 then
            demandNumVet[i] = v
        else
            demandNumVet[i] = Vector2.New(v.x,v.y / scale * 60)
        end
    end

    VolumePanel.sslide:SetXScaleValue(time,116)
    VolumePanel.sgraph:BoundaryLine(boundaryLine)
    VolumePanel.sgraph:DrawLine(demandNumVet,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)
    VolumePanel.sslide:SetCoordinate(demandNumVet,demandNumValue,Color.New(213 / 255, 35 / 255, 77 / 255, 255 / 255),1)

    VolumePanel.scurve.localPosition = VolumePanel.curve.localPosition + Vector3.New(0.01, 0,0)
    VolumePanel.scurve.sizeDelta = VolumePanel.curve.sizeDelta + Vector2.New(0.01, 0)
end