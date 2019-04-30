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
local nameSize
local goodsName
local num
--初始化方法   数据（读配置表）
function NoticeItem:initialize(goodsDataInfo,prefab,inluabehaviour, mgr, id,typeId)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.state = goodsDataInfo.state
    self.manager = mgr
    self.id = id
    self.typeId = typeId
    self.content = goodsDataInfo.contents
    self.uuidParas = goodsDataInfo.uuidParas
    self.hide = true

    self:_addListener()

    self.itemHedaer = self.prefab.transform:Find("bg/hedaer").gameObject:GetComponent("Text");
    self.from = self.prefab.transform:Find("bg/from").gameObject:GetComponent("Text");
    self.itemTime = self.prefab.transform:Find("bg/time").gameObject:GetComponent("Text");
    self.hint = self.prefab.transform:Find("hint")
    self.onBg = self.prefab.transform:Find("bg").gameObject;
    self.newBg = self.prefab.transform:Find("newBg").gameObject;
    self.newHedaer = self.prefab.transform:Find("newBg/newHedaer").gameObject:GetComponent("Text");
    self.newFrom = self.prefab.transform:Find("newBg/newFrom").gameObject:GetComponent("Text");
    self.newTime = self.prefab.transform:Find("newBg/newTime").gameObject:GetComponent("Text");

    self.itemHedaer.text = goodsDataInfo.header
    self.from.text = goodsDataInfo.from
    local ts = getFormatUnixTime( goodsDataInfo.time/1000)
    local time =ts.year.."-"..ts.month.."-"..ts.day.." "..ts.hour..":"..ts.minute..":"..ts.second
    self.itemTime.text = time
    --到期时间(毫秒)
   -- local expore = goodsDataInfo.time + 604800000
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

    self.newBg:SetActive(false)
    GameNoticePanel.GoodsScrollView:SetActive(false)

    self._luabehaviour:AddClick(self.onBg, self.OnBg, self);

end

function NoticeItem:OnBg(go)
    PlayMusEff(1002)
    if go.typeId == 12 then
        type = go.typeId
        PlayerInfoManger.GetInfos({go.uuidParas[1]}, NoticeItem.c_OnReceivePlayerInfo, NoticeItem)
    elseif go.typeId == 13 then
        type = go.typeId
        pos.x = go.goodsDataInfo.intParasArr[1]
        pos.y = go.goodsDataInfo.intParasArr[2]
        PlayerInfoManger.GetInfos({go.uuidParas[1]}, NoticeItem.c_OnReceivePlayerInfo, NoticeItem)
    elseif go.typeId == 14 then
        type = go.typeId
        pos.x = go.goodsDataInfo.intParasArr[1]
        pos.y = go.goodsDataInfo.intParasArr[2]
        PlayerInfoManger.GetInfos({go.uuidParas[1]}, NoticeItem.c_OnReceivePlayerInfo, NoticeItem)
    elseif go.typeId == 9 then
        go.content = GetLanguage(13010043,"(".. go.goodsDataInfo.intParasArr[1]..","..go.goodsDataInfo.intParasArr[2] .. ")")
        GameNoticePanel.rightContent.text = go.content
    elseif go.typeId == 11 then
        go.content = GetLanguage(13010047,"(".. go.goodsDataInfo.intParasArr[1]..","..go.goodsDataInfo.intParasArr[2] .. ")")
        GameNoticePanel.rightContent.text = go.content
    elseif go.typeId == 3 then
        type = go.typeId
        nameSize =  GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].sizeName)..GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].typeName)
        goodsName = GetLanguage(go.goodsDataInfo.intParasArr[1])
        num = go.goodsDataInfo.intParasArr[2]
        if go.goodsDataInfo.paras[1] == 1100001 or go.goodsDataInfo.paras[1] == 1100002 or go.goodsDataInfo.paras[1] == 1100003 then
            go:GetMateralDetailInfo(go.uuidParas[1])
        else
            go:GetProduceDepartment(go.uuidParas[1])
        end
    elseif go.typeId == 2 then
        type = go.typeId
        nameSize =  GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].sizeName)..GetLanguage(PlayerBuildingBaseData[go.goodsDataInfo.paras[1]].typeName)
        if go.goodsDataInfo.paras[1] == 1100001 or go.goodsDataInfo.paras[1] == 1100002 or go.goodsDataInfo.paras[1] == 1100003 then
            go:GetMateralDetailInfo(go.uuidParas[1])
        elseif go.goodsDataInfo.paras[1] == 1200001 or go.goodsDataInfo.paras[1] == 1200002 or go.goodsDataInfo.paras[1] == 1200003 then
            go:GetProduceDepartment(go.uuidParas[1])
        end
    elseif go.typeId == 18 then
        type = go.typeId
        go:GetSocietyInfo(go.uuidParas[1])
    elseif go.typeId == 4 then
        GameNoticePanel.rightContent.text = Notice[go.typeId].content
    elseif go.typeId == 5 then
        GameNoticePanel.rightContent.text = Notice[go.typeId].content
    elseif go.typeId == 15 then
        GameNoticePanel.rightContent.text = Notice[go.typeId].content
    elseif go.typeId == 16 then
        GameNoticePanel.rightContent.text = Notice[go.typeId].content
    elseif go.typeId == 17 then
        type = go.typeId
        go:GetSocietyInfo(go.uuidParas[1])
    elseif go.typeId == 19 then
        type = go.typeId
        go:GetSocietyInfo(go.uuidParas[1])
    end
    Event.Brocast("c_onBg",go)
end

function NoticeItem:RefreshID(id)
    self.id = id
end

--获取玩家信息
function NoticeItem:GetPlayerId(playerid)
    --DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_GetMyFriendsInfo',{playerid})--获取好友信息
end

--获取原料厂建筑详情
function NoticeItem:GetMateralDetailInfo(buildingId)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_GetMateralDetailInfo',buildingId)
end

--获取加工厂建筑详情
function NoticeItem:GetProduceDepartment(buildingId)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_GetProduceDepartment',buildingId)
end

--获取零售店建筑详情
function NoticeItem:GetRetailShop(buildingId)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_GetRetailShop',buildingId)
end

--获取公会信息
function NoticeItem:GetSocietyInfo(id)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameNoticeCtrl , 'm_GetSocietyInfo',id)
end

-- 监听Model层网络回调
function NoticeItem:_addListener()
    Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self) --玩家信息网络回调
    Event.AddListener("c_MaterialInfo", self.c_MaterialInfo, self) --原料厂建筑详情回调
    Event.AddListener("c_ProduceInfo", self.c_ProduceInfo, self) --加工厂建筑详情回调
    Event.AddListener("c_RetailShopInfo", self.c_RetailShopInfo, self) --零售店建筑详情回调
    Event.AddListener("c_SocietyInfo", self.c_SocietyInfo, self) --公会详情回调
end

--注销model层网络回调
function NoticeItem:_removeListener()
    Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)--玩家信息网络回调
    Event.RemoveListener("c_MaterialInfo", self.c_MaterialInfo, self)--原料厂建筑详情回调
    Event.RemoveListener("c_ProduceInfo", self.c_ProduceInfo, self)--加工厂建筑详情回调
    Event.RemoveListener("c_RetailShopInfo", self.c_RetailShopInfo, self)--零售店建筑详情回调
    Event.RemoveListener("c_SocietyInfo", self.c_SocietyInfo, self)--公会详情回调
end

function NoticeItem:c_OnReceivePlayerInfo(playerData)
    self.name = playerData[1].name
    if type == 12 then
        self.content = GetLanguage(13010051,self.name)
        GameNoticePanel.rightContent.text = self.content
    elseif type == 13 then
        self.content = GetLanguage(13010053,"(".. pos.x..","..pos.y .. ")",self.name)
        GameNoticePanel.rightContent.text = self.content
    elseif type == 14 then
        self.content = GetLanguage(13010054,"(".. pos.x..","..pos.y .. ")",self.name)
        GameNoticePanel.rightContent.text = self.content
    end
    --NoticeMgr:_createNotice(GameNoticeBehaviour,read,content,typeId,noticeId)
end

function NoticeItem:c_MaterialInfo(name)
    if type == 3 then
        self.content = GetLanguage(13010019,name,nameSize,goodsName,num)
        GameNoticePanel.rightContent.text = self.content
    elseif  type == 2 then
        self.content = GetLanguage(13010017,name,nameSize)
        GameNoticePanel.rightContent.text = self.content
    end
end

function NoticeItem:c_ProduceInfo(name)
    if type == 3 then
        self.content = GetLanguage(13010019,name,nameSize,goodsName,num)
        GameNoticePanel.rightContent.text = self.content
    elseif  type == 2 then
        self.content = GetLanguage(13010017,name,nameSize)
        GameNoticePanel.rightContent.text = self.content
    end
end

function NoticeItem:c_RetailShopInfo(name)
    self.content = GetLanguage(13010017,name,nameSize)
    GameNoticePanel.rightContent.text = self.content
end

function NoticeItem:c_SocietyInfo(name)
    if type == 17 then
        self.content = GetLanguage(13010068,name)
    elseif type == 18 then
        self.content = GetLanguage(13010066,name)
    elseif type == 19 then
        self.content = GetLanguage(13010070,name)
    end
    GameNoticePanel.rightContent.text = self.content
end

