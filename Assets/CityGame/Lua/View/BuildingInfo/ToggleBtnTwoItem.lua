---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/5/13 17:34
---

ToggleBtnTwoItem = class('ToggleBtnTwoItem')

local optionTwoScript = {}
local volumeBehaviour
local insId
local playerdata = {}
local optionOneScript = {}
local maxValue = 0
local state
local type = true
---初始化方法   数据（读配置表）
function ToggleBtnTwoItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab = prefab
    volumeBehaviour = luaBehaviour
    self.data = data
    self.ctrl = ctrl

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    --self.deleteBtn=prefab.transform:Find("Button")
    self.foodtext = prefab.transform:Find("food/foodText"):GetComponent("Text")
    self.bgBtn = prefab.transform:Find("bgBtn")
    self.highlight = prefab.transform:Find("highlight")

    self.ToggleBtnTwoItem = UnityEngine.UI.LoopScrollDataSource.New()
    self.ToggleBtnTwoItem.mProvideData = ToggleBtnTwoItem.static.OptionThreeData
    self.ToggleBtnTwoItem.mClearData = ToggleBtnTwoItem.static.OptionThreeClearData

    VolumePanel.curve.anchoredPosition = Vector3.New(-18524, 56,0)
    VolumePanel.curve.sizeDelta = Vector2.New(19530, 450)
    insId = OpenModelInsID.VolumeCtrl
    self:Refresh(data)
    Event.AddListener("c_ToggleBtnTwoItem",self.c_GoodsplayerTypeNum,self)
    luaBehaviour:AddClick(self.bgBtn.gameObject,self._tradingOpenFunc,self)
end

---==========================================================================================点击函数=============================================================================
--打开交易折线图
function ToggleBtnTwoItem:_tradingOpenFunc(ins)
    VolumePanel.curve.anchoredPosition = Vector3.New(-18524, 56,0)
    VolumePanel.curve.sizeDelta = Vector2.New(19530, 450)
    if state ~= nil then
        state.localScale = Vector3.zero
    end
    state = ins.highlight
    ins.highlight.localScale = Vector3.one
    --optionTwoScript[ins.ctrl] = ToggleBtnThreeItem:new(transform, volumeBehaviour, DealConfig[idx].childs, idx)
    if ins.data.childs ~= nil then
        ins:Abb(ins.data)
        VolumePanel.threeScroll:ActiveLoopScroll(ins.ToggleBtnTwoItem, #ins.data.childs,"View/Laboratory/ToggleBtnThreeItem")
    else
        VolumePanel.threeScroll:ActiveLoopScroll(ins.ToggleBtnTwoItem, 0,"View/Laboratory/ToggleBtnThreeItem")

        local info = {}
        info.id = ins.data.typeId
        info.exchangeType = ins.data.EX
        info.type = type
        DataManager.DetailModelRpcNoRet(insId , 'm_PlayerNumCurve',info)
        VolumePanel.trade.localScale = Vector3.one
    end
end

--删除2
function ToggleBtnTwoItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
    Event.RemoveListener("c_ToggleBtnTwoItem",self.c_GoodsplayerTypeNum,self)
end

---==========================================================================================业务逻辑=============================================================================

function ToggleBtnTwoItem:updateData( data )
    self.data = data
    self.foodtext.text = self.data.name
end

function ToggleBtnTwoItem:updateUI( data )
    --LoadSprite()
    if data.beginProcessTs > 0 then
        local curTime = TimeSynchronized.GetTheCurrentServerTime()
        local hasRunTime = curTime - data.beginProcessTs
    end
end

function ToggleBtnTwoItem:Refresh(data)
    self:updateData(data)
    DataManager.DetailModelRpcNoRet(data.insId , 'm_GoodsplayerTypeNum')
    --self:updateUI(data)
end

-- 第三层信息显示
ToggleBtnTwoItem.static.OptionThreeData = function(transform, idx)
    idx = idx + 1
    optionTwoScript[idx] = ToggleBtnThreeItem:new(transform, volumeBehaviour, playerdata.childs[idx], idx)
end

ToggleBtnTwoItem.static.OptionThreeClearData = function(transform)
end
function ToggleBtnTwoItem:Abb(data)
    playerdata = data
end

function ToggleBtnTwoItem:_close()
    VolumePanel.threeScroll:ActiveLoopScroll(self.ToggleBtnTwoItem, 0,"View/Laboratory/ToggleBtnThreeItem")
end


function ToggleBtnTwoItem:c_GoodsplayerTypeNum(info)
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

















