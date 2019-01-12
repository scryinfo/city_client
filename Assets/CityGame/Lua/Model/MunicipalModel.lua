---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/23/023 11:28
---
MunicipalModel=class('MunicipalModel',ModelBase)
local pbl = pbl
function MunicipalModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
    self.SlotList={}
    self.manger=ItemCreatDeleteMgr:new()
end

function MunicipalModel:OnCreate()
    ----注册 AccountServer消息
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailPublicFacility","gs.PublicFacility",self.n_getdetailPublicFacility)--广告细节
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adAddSlot","gs.AddSlotACK",self.n_getaddSlot)--添加槽位
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adDelSlot","gs.AdDelSlot",self.n_deleteSlot)--删除槽位
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adPutAdToSlot","gs.AddAdACK",self.n_adPutAdToSlot)--打广告
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adSetSlot","gs.AdSetSlot",self.n_getSetSlot)--设置槽位
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adSlotTimeoutInform","gs.AdSlotTimeoutInform",self.n_getadSlotTimeoutInform)--槽位过期
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adDelAdFromSlot","gs.AdDelAdFromSlot",self.n_getdeletAd)--删广告
DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","adBuySlot","gs.AdBuySlot",self.n_getBuySlot)--买槽位
end
---广告细节发包
function MunicipalModel:m_detailPublicFacility(buildingID)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailPublicFacility","gs.Id",{ id = buildingID})
end
---广告细节收包
function MunicipalModel:n_getdetailPublicFacility(lMsg)

    MunicipalPanel.buildingId=lMsg.info.id
    local model =DataManager.GetDetailModelByID(lMsg.info.id)
    local lMsg=lMsg

    model.SlotList={}
    if  lMsg.ad.availableSlot then
        for i, v in pairs(lMsg.ad.availableSlot) do
            model.SlotList[i]=v
        end
    end
    if lMsg.ad.soldSlot then
        for i, v in pairs(lMsg.ad.soldSlot) do
            for k, s in pairs(model.SlotList) do
                if s.id==v.s.id then
                table.remove(model.SlotList,k)
                end
            end
        end
    end

    model.ticket=lMsg.ticketPrice;
     model.lMsg=lMsg
    model.buildingOwnerId=lMsg.info.ownerId

    if model.manger.isFirst then
        Event.Brocast("c_FirstCreate")
        model.manger.isFirst=false
    end
    DataManager.ControllerRpcNoRet(self.insId,"MunicipalCtrl", 'c_receiveParkData',lMsg)

end
---添加槽位发包
function MunicipalModel:m_addSlot(buildingID,minDayToRent,maxDayToRent,rentPreDay)
    DataManager.ModelSendNetMes("gscode.OpCode", "adAddSlot","gs.AddSlot",
    { buildingId=buildingID,minDayToRent=minDayToRent,maxDayToRent=maxDayToRent,rentPreDay=rentPreDay})
end
---添加槽位收包
function MunicipalModel:n_getaddSlot(stream)
    DataManager.DetailModelRpcNoRet(self.insId, 'm_detailPublicFacility',self.insId)
end
---删除槽位发包
function MunicipalModel:m_deleteSlot(buildingId,slotId)
    DataManager.ModelSendNetMes("gscode.OpCode", "adDelSlot","gs.AdDelSlot",{ buildingId=buildingId,slotId=slotId})
end
---删除槽位收包
function MunicipalModel:n_deleteSlot(stream)
    DataManager.DetailModelRpcNoRet(self.insId, 'm_detailPublicFacility',self.insId)
end
---打广告发包
function MunicipalModel:m_adPutAdToSlot(Slotid,metaId,type,buildingId)
DataManager.ModelSendNetMes("gscode.OpCode", "adPutAdToSlot","gs.AddAd",
{id=Slotid ,metaId=metaId,type=type,buildingId=buildingId})
end
---打广告收包
function MunicipalModel:n_adPutAdToSlot(lMsg)
    if not self.manger.adList[lMsg.a.metaId] then
        self.manger.adList[lMsg.a.metaId]={}
    end
    table.insert(self.manger.adList[lMsg.a.metaId],lMsg.a)

end
---设置门票发包
function MunicipalModel:m_Setticket(buildingId,price)
DataManager.ModelSendNetMes("gscode.OpCode", "adSetTicket","gs.AdSetTicket", { buildingId=buildingId,price=price})
end
---设置槽位发包
function MunicipalModel:m_SetSlot(buildingId,slotId,rent,minDayToRent,maxDayToRent)
    DataManager.ModelSendNetMes("gscode.OpCode", "adSetSlot","gs.AdSetSlot",
            { buildingId=buildingId,slotId=slotId,rentPreDay=rent,minDayToRent=minDayToRent,maxDayToRent=maxDayToRent})
end
---设置槽位收包
function MunicipalModel:n_getSetSlot(stream)
    DataManager.DetailModelRpcNoRet(self.insId, 'm_detailPublicFacility',self.insId)
end
---槽位过期收包
function MunicipalModel:n_getadSlotTimeoutInform(lMsg)
     --self.manger

end
---删广告发包
function MunicipalModel:m_DelAdFromSlot(buildingID,adid)
 DataManager.ModelSendNetMes("gscode.OpCode", "adDelAdFromSlot","gs.AdDelAdFromSlot",{ buildingId=buildingID,adId=adid})
end
---删广告收包
function MunicipalModel:n_getdeletAd(stream)

end
---购买槽位发包
function MunicipalModel:m_buySlot(buildingId,slotId,day)
DataManager.ModelSendNetMes("gscode.OpCode", "adBuySlot","gs.AdBuySlot",{ buildingId=buildingId,slotId=slotId,day=day})
end
---购买槽位收包
function MunicipalModel:n_getBuySlot(stream)
    ---购买槽位成功
    Event.Brocast("SmallPop","Successful adjustment",57)
end













