---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/13 15:33
---通知信息
local class = require 'Framework/class'
require('Framework/UI/UIPage')
NoticeItem = class('NoticeItem')
local pos ={}
local type
--初始化方法   数据（读配置表）
function NoticeItem:initialize(goodsDataInfo,prefab,inluabehaviour,id,typeId,ins)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.state = goodsDataInfo.state
    self.id = id
    self.typeId = typeId
    self.content = goodsDataInfo.contents
    self.uuidParas = goodsDataInfo.uuidParas
    self.hide = true
    self.ins = ins

    self.itemHedaer = self.prefab.transform:Find("bg/hedaer").gameObject:GetComponent("Text");
    self.from = self.prefab.transform:Find("bg/from").gameObject:GetComponent("Text");
    self.itemTime = self.prefab.transform:Find("bg/time").gameObject:GetComponent("Text");
    self.hint = self.prefab.transform:Find("hint")
    self.onBg = self.prefab.transform:Find("bg").gameObject;
    self.newBg = self.prefab.transform:Find("newBg");
    self.newHedaer = self.prefab.transform:Find("newBg/newHedaer").gameObject:GetComponent("Text");
    self.newFrom = self.prefab.transform:Find("newBg/newFrom").gameObject:GetComponent("Text");
    self.newTime = self.prefab.transform:Find("newBg/newTime").gameObject:GetComponent("Text");

    self.itemHedaer.text = goodsDataInfo.header
    self.from.text = goodsDataInfo.from
    local ts = getFormatUnixTime( goodsDataInfo.time/1000)
    local time =ts.year.."-"..ts.month.."-"..ts.day.." "..ts.hour..":"..ts.minute..":"..ts.second
    self.itemTime.text = time
    --到期时间(毫秒)
    local expore = goodsDataInfo.time + 518400000
    --获取当前时间(毫秒)
    local current = TimeSynchronized.GetTheCurrentServerTime()
    --剩余时间(毫秒)
    local remaining = expore - current
    local remainingTs = getFormatUnixTime( remaining/1000)
    --剩余天数
    local remainingDay = remainingTs.day
    --切割字符串
    local remainingDays = split(remainingDay, 0)
    self.day = remainingDays[2]
    self.newHedaer.text = goodsDataInfo.header
    self.newFrom.text = goodsDataInfo.from
    self.newTime.text = self.itemTime.text
    self.from.text = goodsDataInfo.from

    --是否显示红点
    if goodsDataInfo.state then
        self.hint.localScale = Vector3.zero
    else
        self.hint.localScale = Vector3.one
    end

    self.newBg.localScale = Vector3.zero
    GameNoticePanel.GoodsScrollView:SetActive(false)

    self._luabehaviour:AddClick(self.onBg, self.OnBg, self);

end

function NoticeItem:OnBg(go)
    PlayMusEff(1002)
    if go.typeId == 1 then
        go.ins.nameSize =  GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].sizeName)..GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].typeName)
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 2 then
        go.ins.type = go.typeId
        go.ins.nameSize =  GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].sizeName)..GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].typeName)
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 3 then
        go.ins.type = go.typeId
        go.ins.nameSize =  GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].sizeName)..GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].typeName)
        go.ins.goodsName = GetLanguage(go.goodsDataInfo.intParasArr[1])
        go.ins.num = go.goodsDataInfo.intParasArr[2]
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 4 then
        GameNoticePanel.rightContent.text = Notice[go.typeId].content
    elseif go.typeId == 5 then
        go.ins.type = go.typeId
        go.ins.money = GetClientPriceString(go.goodsDataInfo.tparas[1])
        go.ins.time = go.goodsDataInfo.tparas[2]/3600000
        local timmer = tonumber(go.goodsDataInfo.tparas[3])
        local ts = getFormatUnixTime(timmer/1000)
        go.ins.startTime = ts.year .. "/" .. ts.month .. "/" .. ts.day .. " " .. ts.hour .. ":" .. ts.minute
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 6 then
        go.ins.type = go.typeId
        go.ins.money = GetClientPriceString(go.goodsDataInfo.tparas[1])
        go.ins.time =go.goodsDataInfo.tparas[2]
        local timmer = tonumber(go.goodsDataInfo.tparas[3])
        local ts = getFormatUnixTime(timmer/1000)
        go.ins.startTime = ts.year .. "/" .. ts.month .. "/" .. ts.day .. " " .. ts.hour .. ":" .. ts.minute
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 7 then
        go.ins.type = go.typeId
        if go.goodsDataInfo.intParasArr[1] == 1300 then
            go.ins.nameSize = GetLanguage(42020003)
        elseif go.goodsDataInfo.intParasArr[1] == 1400 then
            go.ins.nameSize = GetLanguage(42020004)
        else
            go.ins.nameSize = GetLanguage(go.goodsDataInfo.intParasArr[1])
        end
        go.ins.bonus = go.goodsDataInfo.intParasArr[2]
        go.ins.time = go.goodsDataInfo.intParasArr[3]
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 8 or go.typeId == 9 then
        go.ins.type = go.typeId
        if go.goodsDataInfo.paras[3] == 51 then
            go.ins.goodsName = GetLanguage(20030002)
        elseif go.goodsDataInfo.paras[3] == 52 then
            go.ins.goodsName = GetLanguage(20030001)
        elseif go.goodsDataInfo.paras[3] == 0 then
            go.ins.goodsName = GetLanguage(11010001)
        end
        go.ins.money = go.goodsDataInfo.paras[1]
        go.ins.num = go.goodsDataInfo.paras[2]
        go:queryBuildingName(go.uuidParas[1])
    elseif go.typeId == 10 then
        go.content = GetLanguage(16020017,"(".. go.goodsDataInfo.intParasArr[1]..","..go.goodsDataInfo.intParasArr[2] .. ")")
        GameNoticePanel.rightContent.text = go.content
    elseif go.typeId == 11 then
        type = go.typeId
        PlayerInfoManger.GetInfos({go.uuidParas[1]}, NoticeItem.c_OnReceivePlayerInfo, NoticeItem)
    elseif go.typeId == 12 then
        type = go.typeId
        pos.x = go.goodsDataInfo.intParasArr[1]
        pos.y = go.goodsDataInfo.intParasArr[2]
        PlayerInfoManger.GetInfos({go.uuidParas[1]}, NoticeItem.c_OnReceivePlayerInfo, NoticeItem)
    elseif go.typeId == 13 then
        type = go.typeId
        pos.x = go.goodsDataInfo.intParasArr[1]
        pos.y = go.goodsDataInfo.intParasArr[2]
        PlayerInfoManger.GetInfos({go.uuidParas[1]}, NoticeItem.c_OnReceivePlayerInfo, NoticeItem)
    elseif go.typeId == 14 then
        go.ins.type = go.typeId
        go:GetSocietyInfo(go.uuidParas[1])
    elseif go.typeId == 15 then
        go.ins.type = go.typeId
        go:GetSocietyInfo(go.uuidParas[1])
    elseif go.typeId == 16 then
        go.ins.type = go.typeId
        go:GetSocietyInfo(go.uuidParas[1])
    elseif go.typeId == 17 then
        go.content = GetLanguage(16010025,"(".. go.goodsDataInfo.intParasArr[1]..","..go.goodsDataInfo.intParasArr[2] .. ")")
        GameNoticePanel.rightContent.text = go.content
    elseif go.typeId == 18 then
        go.content = GetLanguage(16020025)
        GameNoticePanel.rightContent.text = go.content
    elseif go.typeId == 19 then
        go.content = GetLanguage(16020026)
        GameNoticePanel.rightContent.text = go.content
    end
        Event.Brocast("c_onBg",go)
    end

function NoticeItem:RefreshID(id)
    self.id = id
end

--获取公会信息
function NoticeItem:GetSocietyInfo(id)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_GetSocietyInfo',id)
end

--获取建筑名字
function NoticeItem:queryBuildingName(buildingId)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_queryBuildingName',buildingId)
end

function NoticeItem:c_OnReceivePlayerInfo(playerData)
    self.name = playerData[1].name
    if type == 11 then
        self.content = GetLanguage(16020019,self.name)
    elseif type == 12 then
        self.content = GetLanguage(16020020,"(".. pos.x..","..pos.y .. ")",self.name)
    elseif type == 13 then
        self.content = GetLanguage(16020021,"(".. pos.x..","..pos.y .. ")",self.name)
    end
    GameNoticePanel.rightContent.text = self.content
end


