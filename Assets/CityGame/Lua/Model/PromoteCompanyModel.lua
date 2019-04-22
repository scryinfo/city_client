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
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adjustPromoSellingSetting","gs.AdjustPromoSellingSetting",self.n_OnPromotionSetting) -- 推广设置

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
function PromoteCompanyModel:m_QueryPromote(buildingId)
    local player = DataManager.GetMyPersonalHomepageInfo()
    local lMsg = {isSeller = true , playerId = player.id , sellerBuildingId = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode", "adQueryPromotion","gs.AdQueryPromotion",lMsg)
end

--推广能力列表
function PromoteCompanyModel:m_queryPromoCurAbilitys(buildingId,typeIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "adQueryPromoCurAbilitys","gs.AdQueryPromoCurAbilitys",{sellerBuildingId = buildingId,typeIds= typeIds})
end

--服务器回调
function PromoteCompanyModel:n_OnPublicFacility(info)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_receivePromoteCompanyDetailInfo',info)
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

--推广设置回调
function PromoteCompanyModel:n_OnPromotionSetting(info)
    local a = info
    PromoteCompanyModel:m_detailPublicFacility(info.sellerBuildingId)
    Event.Brocast("c_CloseSetOpenUp")
end

--推广列表回调
function PromoteCompanyModel:n_OnQueryPromotion(info)
    local a = info
end

--推广能力回调
function PromoteCompanyModel:n_OnAdQueryPromoCurAbilitys(info)
    local a = info
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_queryPromoCurAbilitys', info)
end

--员工工资改变
function PromoteCompanyModel:n_OnReceiveHouseSalaryChange(data)
    DataManager.ControllerRpcNoRet(self.insId,"PromoteCompanyCtrl", '_refreshSalary', data)
end

--开业成功，再次请求建筑详情
function PromoteCompanyModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_detailPublicFacility(self.insId)
        Event.Brocast("SmallPop", GetLanguage(40010020), 300)  --开业成功提示
    end
end