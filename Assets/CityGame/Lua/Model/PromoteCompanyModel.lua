---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/13 15:57
---推广公司model
PromoteCompanyModel = class("PromoteCompanyModel",ModelBase)
local pbl = pbl

function PromoteCompanyModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function PromoteCompanyModel:OnCreate()
    DataManager.RegisterErrorNetMsg()
    --网络回调
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnReceiveHouseSalaryChange)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailPublicFacility","gs.PublicFacility",self.n_OnPublicFacility) --建筑详情
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adAddNewPromoOrder","gs.AdAddNewPromoOrder",self.n_OnAddPromote) --添加推广
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adQueryPromotion","gs.AdQueryPromotion",self.n_OnQueryPromotion) -- 推广列表
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adQueryPromoCurAbilitys","gs.AdQueryPromoCurAbilitys",self.n_OnAdQueryPromoCurAbilitys) -- 推广能力列表
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","queryPromotionItemInfo","gs.PromotionItemInfo",self.n_OnPromotionItemInfo) -- 获取推广能力列表
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adjustPromoSellingSetting","gs.AdjustPromoSellingSetting",self.n_OnPromotionSetting) -- 推广设置
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adRemovePromoOrder","gs.AdRemovePromoOrder",self.n_OnRemovePromo) -- 删除推广
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adGetPromoAbilityHistory","gs.AdGetPromoAbilityHistory",self.n_OnPromoAbilityHistory) -- 推广历史曲线
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adGetAllMyFlowSign","gs.GetAllMyFlowSign",self.n_OnGetAllMyFlowSign) -- 获取自己的所有签约
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryBuildingLift","ss.BuildingLift",self.n_OnGetLiftCurve,self) -- 获取自己的所有签约曲线
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","promotionGuidePrice","gs.PromotionMsg",self.n_OnGuidePrice,self) -- 推荐定价

end

function PromoteCompanyModel:Close()
    --清空本地UI事件

end
--客户端请求--

--获取建筑详情
function PromoteCompanyModel:m_detailPublicFacility(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailPublicFacility","gs.Id",{id = buildingId})
end

--添加推广
function PromoteCompanyModel:m_AddPromote(buildingId,time,goodId)
   local playerId = DataManager.GetMyPersonalHomepageInfo()
   local currentTime = TimeSynchronized.GetTheCurrentServerTime()
    local lMsg = {}
    if goodId == 1300 or goodId ==1400 then
        lMsg = {sellerBuildingId = buildingId,buyerPlayerId = playerId.id,companyName = playerId.companyName,promDuration = time*3600000,promStartTs = currentTime,buildingType = goodId}
    else
        lMsg = {sellerBuildingId = buildingId,buyerPlayerId = playerId.id,companyName = playerId.companyName,promDuration = time*3600000,promStartTs = currentTime,productionType = goodId}
    end
    DataManager.ModelSendNetMes("gscode.OpCode", "adAddNewPromoOrder","gs.AdAddNewPromoOrder",lMsg)
end

--删除推广
function PromoteCompanyModel:m_RemovePromote(buildingId,promotionId)
    DataManager.ModelSendNetMes("gscode.OpCode", "adRemovePromoOrder","gs.AdRemovePromoOrder",{buildingId = buildingId,promotionId = promotionId})
end

--推广设置
function PromoteCompanyModel:m_PromotionSetting(buildingId , takeOnNewOrder , price , time)
    if price then
        price = GetServerPriceNumber(price)
    end
    if time then
        time = time*3600*1000
    end
    local lMsg = {sellerBuildingId = buildingId,pricePerHour = price,remainTime = time,takeOnNewOrder = takeOnNewOrder}
    DataManager.ModelSendNetMes("gscode.OpCode", "adjustPromoSellingSetting","gs.AdjustPromoSellingSetting",lMsg)
end

--推广列表
function PromoteCompanyModel:m_QueryPromote(buildingId,isSeller)
    local player = DataManager.GetMyPersonalHomepageInfo()
    local lMsg = {isSeller = isSeller , playerId = player.id , sellerBuildingId = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode", "adQueryPromotion","gs.AdQueryPromotion",lMsg)
end

--推广能力列表
function PromoteCompanyModel:m_queryPromoCurAbilitys(buildingId,typeIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "adQueryPromoCurAbilitys","gs.AdQueryPromoCurAbilitys",{sellerBuildingId = buildingId,typeIds= typeIds})
end

--获取推广能力列表
function PromoteCompanyModel:m_queryPromotionItemInfo(buildingId,typeIds)
    local playerId = DataManager.GetMyOwnerID()
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPromotionItemInfo","gs.QueryPromotionItemInfo",{playerId = playerId,buildingId = buildingId,typeIds= typeIds})
end

--推广历史曲线图
function PromoteCompanyModel:m_PromoAbilityHistory(buildingId,typeIds)
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(毫秒)
    local ts = getFormatUnixTime(currentTime/1000)

    currentTime = currentTime - 24*3600000          --提前24小时
    local lMsg = {sellerBuildingId = buildingId,startTs = currentTime, typeIds = {typeIds}, recordsCount = 24 }

    DataManager.ModelSendNetMes("gscode.OpCode", "adGetPromoAbilityHistory","gs.AdGetPromoAbilityHistory",lMsg)
end

--签约曲线
function PromoteCompanyModel:_reqLiftCurve(buildingId)
    local msgId = pbl.enum("sscode.OpCode","queryBuildingLift")
    local lMsg = { id = buildingId }
    local pMsg = assert(pbl.encode("ss.Id", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end

--签约
function PromoteCompanyModel:m_GetAllMyFlowSign(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "adGetAllMyFlowSign","gs.GetAllMyFlowSign",{buildingId = buildingId})
end

--推荐价格
function PromoteCompanyModel:m_promotionGuidePrice(buildingId,playerId)
    DataManager.ModelSendNetMes("gscode.OpCode", "promotionGuidePrice","gs.PromotionMsg",{buildingId = buildingId , playerId = playerId})
end

--服务器回调
function PromoteCompanyModel:n_OnPublicFacility(info)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_receivePromoteCompanyDetailInfo',info)
    if info.promRemainTime <= 0 and info.takeOnNewOrder == true then
        PromoteCompanyModel:m_PromotionSetting(info.info.id , false , 0, 0)
    end
end

--添加推广回调
function PromoteCompanyModel:n_OnAddPromote(info)
    PromoteCompanyModel:m_detailPublicFacility(info.sellerBuildingId)
    if info.buildingType == 1300 or info.buildingType == 1400 then
        Event.Brocast("c_ClosePromoteBuildingExtension")
    else
        Event.Brocast("c_ClosePromoteGoodsExtension")
    end
end

--删除推广回调
function PromoteCompanyModel:n_OnRemovePromo(info)
    PromoteCompanyModel:m_detailPublicFacility(info.buildingId)
    local newData = {}
    --newData = ct.deepCopy(self.data)
    newData = self.data
    if true then

    end
    if self.data and info.PromoTsChanged then
        for i, v in pairs(self.data) do
            for k, z in pairs(info.PromoTsChanged) do
                if v.promotionId == z.promotionId then
                    newData[i].createTs = z.promStartTs
                    newData[i].queneTime = z.promStartTs
                    newData[i].promStartTs = z.promStartTs
                end
            end
        end
    end
    for i, v in pairs(self.data) do
        if v.promotionId == info.promotionId then
            table.remove(newData,i)
        end
    end
    if next(newData) == nil then
        newData = nil
    end
    Event.Brocast("c_updateQuque",{name = "View/GoodsItem/QueueItem",data =newData,insClass = PromoteQueueItem})
end

--推广设置回调
function PromoteCompanyModel:n_OnPromotionSetting(info)
    PromoteCompanyModel:m_detailPublicFacility(info.sellerBuildingId)
    Event.Brocast("c_CloseSetOpenUp")
end

--推广列表回调
function PromoteCompanyModel:n_OnQueryPromotion(info)
    if not info.Promotions then
       return
    end
    self.data = {}
    for i, v in pairs(info.Promotions) do
       self.data[i] = v
        self.data[i].createTs = v.promStartTs
        self.data[i].queneTime = v.promStartTs
        self.data[i].proposerId = v.buyerId
    end
    ct.OpenCtrl("QueneCtrl",{name = "View/GoodsItem/QueueItem",data = self.data,insClass = PromoteQueueItem})
end

--推广能力回调
function PromoteCompanyModel:n_OnAdQueryPromoCurAbilitys(info)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_queryPromoCurAbilitys', info)
end

--获取推广能力回调
function PromoteCompanyModel:n_OnPromotionItemInfo(info)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_queryPromoCurItemInfo', info)
end

--推广历史曲线回调
function PromoteCompanyModel:n_OnPromoAbilityHistory(info)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCurveCtrl", 'm_PromoteHistoryCurve', info.recordsList[1].list)
end

--签约回调
function PromoteCompanyModel:n_OnGetAllMyFlowSign(info)
    local a = info
    --DataManager.ControllerRpcNoRet(self.insId,"AdBuildingSignDetailPart", 'm_GetAllMyFlowSign', info.info)
    Event.Brocast("m_GetAllMyFlowSign",info.info)
end

--签约曲线回调
function PromoteCompanyModel:n_OnGetLiftCurve(info)
    --DataManager.ControllerRpcNoRet(self.insId,"PromoteSignCurveCtrl", 'c_PromoteSignCurve', info)
    Event.Brocast("c_PromoteSignCurve",info)
end

--员工工资改变
function PromoteCompanyModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_refreshSalary', data)
end
--开业成功，再次请求建筑详情
function PromoteCompanyModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_detailPublicFacility(self.insId)
        Event.Brocast("SmallPop", GetLanguage(24020018), ReminderType.Succeed)  --开业成功提示
    end
end

--推荐定价
function PromoteCompanyModel:n_OnGuidePrice(info)
    Event.Brocast("c_GuidePrice",info)
end