---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 10:55
---

ResearchInstituteModel = class("ResearchInstituteModel",ModelBase)

function ResearchInstituteModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

--启动事件--
function ResearchInstituteModel:OnCreate()
    --网络回调注册
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailTechnology","gs.Technology",self.n_OnReceiveDetailTechnology)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","getScienceItemSpeed","gs.ScienceItemSpeed",self.n_OnReceiveResearchGetScienceItemSpeed)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnReceiveFtyLineAddInform)
    DataManager.ModelRegisterNetMsg(self.insId, "gscode.OpCode", "ftyLineChangeInform", "gs.LineInfo", self.n_OnReceiveGetFtyLineChangeInform)
    DataManager.ModelRegisterNetMsg(self.insId, "gscode.OpCode", "openScienceBox", "gs.ScienceBoxACK", self.n_OnReceiveOpenScienceBox)
    DataManager.ModelRegisterNetMsg(self.insId, "gscode.OpCode", "getScienceStorageData", "gs.ScienceStorageData", self.n_OnReceiveGetScienceStorageData)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","useSciencePoint","gs.OpenScience",self.n_OnUserData) --使用点数
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buySciencePoint","gs.BuySciencePoint",self.n_OnBuyData) --购买点数
end
--移除事件--
function ResearchInstituteModel:Close()
    --网络回调注册
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","detailTechnology","gs.Technology",self.n_OnReceiveDetailTechnology)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","getScienceItemSpeed","gs.ScienceItemSpeed",self.n_OnReceiveResearchGetScienceItemSpeed)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","ftyLineAddInform","gs.FtyLineAddInform",self.n_OnReceiveFtyLineAddInform)
    DataManager.ModelRemoveNetMsg(self.insId, "gscode.OpCode", "ftyLineChangeInform", "gs.LineInfo", self.n_OnReceiveGetFtyLineChangeInform)
    DataManager.ModelRemoveNetMsg(self.insId, "gscode.OpCode", "openScienceBox", "gs.ScienceBoxACK", self.n_OnReceiveOpenScienceBox)
    DataManager.ModelRemoveNetMsg(self.insId, "gscode.OpCode", "getScienceStorageData", "gs.ScienceStorageData", self.n_OnReceiveGetScienceStorageData)
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","useSciencePoint","gs.OpenScience",self.n_OnUserData) --使用点数
    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","buySciencePoint","gs.BuySciencePoint",self.n_OnBuyData) --购买点数
end

-- 向服务器获取建筑详情,发起查询研究所的信息
function ResearchInstituteModel:m_ReqOpenTechnology()
    DataManager.ModelSendNetMes("gscode.OpCode", "detailTechnology","gs.Id",{ id = self.insId})
end

-- 向服务器发起查询生产线的详细信息
function ResearchInstituteModel:m_ReqGetScienceLineData()
    DataManager.ModelSendNetMes("gscode.OpCode", "getScienceLineData","gs.Id",{ id = self.insId})
end

-- 向服务器发起查询科技列表生产速度(研究所、推广公司)
function ResearchInstituteModel:m_ReqGetScienceItemSpeed()
    DataManager.ModelSendNetMes("gscode.OpCode", "getScienceItemSpeed","gs.Id",{ id = self.insId})
end

-- 向服务器发送研究消息
function ResearchInstituteModel:m_ReqAddScienceLine(addLine)
    FlightMainModel.OpenFlightLoading()
    DataManager.ModelSendNetMes("gscode.OpCode", "addScienceLine","gs.AddLine",addLine)
end

-- 向服务器发送获取货架数据(研究所、推广公司)
function ResearchInstituteModel:m_ReqGetScienceShelfData()
    DataManager.ModelSendNetMes("gscode.OpCode", "getScienceShelfData","gs.Id",{ id = self.insId})
end

-- 向服务器发送删除生产线(研究所、推广公司)
function ResearchInstituteModel:m_ReqDelScienceLine(delLineId)
    DataManager.ModelSendNetMes("gscode.OpCode", "delScienceLine","gs.DelLine",{buildingId = self.insId, lineId = delLineId})
end

-- 向服务器发送删除生产线(研究所、推广公司)
function ResearchInstituteModel:m_ReqSetScienceLineOrder(id)
    DataManager.ModelSendNetMes("gscode.OpCode", "setScienceLineOrder","gs.SetLineOrder",{buildingId = self.insId, lineId = id, lineOrder = 2})
end

-- 向服务器发送开启科技点数（开宝箱）
function ResearchInstituteModel:m_ReqOpenScienceBox(itemId, num)
    DataManager.ModelSendNetMes("gscode.OpCode", "openScienceBox","gs.OpenScience",{buildingId = self.insId, itemId = itemId, num = num})
end

-- 向服务器发送获取科技资料仓库数据(研究所、推广公司)
function ResearchInstituteModel:m_ReqGetScienceStorageData()
    DataManager.ModelSendNetMes("gscode.OpCode", "getScienceStorageData","gs.Id",{id = self.insId})
end

-- 向服务器发送上架(研究所、推广公司)
function ResearchInstituteModel:m_ReqScienceShelfAdd(shelfAdd)
    FlightMainModel.OpenFlightLoading()
    DataManager.ModelSendNetMes("gscode.OpCode", "scienceShelfAdd","gs.ShelfAdd",shelfAdd)
end

-- 向服务器发送全部下架该科技(研究所、推广公司)
function ResearchInstituteModel:m_ReqScienceShelfDel(shelfDel)
    DataManager.ModelSendNetMes("gscode.OpCode", "scienceShelfDel","gs.ShelfDel",shelfDel)
end

-- 向服务器发送修改上架信息(研究所、推广公司)
function ResearchInstituteModel:m_ReqScienceShelfSet(shelfSet)
    DataManager.ModelSendNetMes("gscode.OpCode", "scienceShelfSet","gs.ShelfSet",shelfSet)
end

--使用点数
function ResearchInstituteModel:m_userData(buildingId,typeId,num)
    DataManager.ModelSendNetMes("gscode.OpCode", "useSciencePoint","gs.OpenScience",{buildingId = buildingId,itemId = typeId,num = num})
end

--购买点数
function ResearchInstituteModel:m_buyData(buildingId,typeId,num,price,ownerId)
    DataManager.ModelSendNetMes("gscode.OpCode", "buySciencePoint","gs.BuySciencePoint",
            {buildingId = buildingId,item = {key = {id = typeId},n = num},price = price,buyerId = ownerId,})
end
-----------------------------------------------------------回调-----------------------------------------------------------
-- 查询研究所信息回调,传入ctrl层刷新数据
function ResearchInstituteModel:n_OnReceiveDetailTechnology(technology)
    DataManager.ControllerRpcNoRet(self.insId,"ResearchInstituteCtrl", '_receiveDetailTechnology', technology)
end

--开业成功，再次请求建筑详情
function ResearchInstituteModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqOpenTechnology()
        Event.Brocast("SmallPop", GetLanguage(24020018), ReminderType.Succeed)  --开业成功提示
    end
end

-- 查询研究所信息回调,传入ctrl层刷新数据
function ResearchInstituteModel:n_OnReceiveResearchGetScienceItemSpeed(scienceItemSpeed)
    Event.Brocast("c_OnReceiveResearchGetScienceItemSpeed",scienceItemSpeed)
    self:m_ReqGetScienceLineData()
end

-- 生产线增加通知
function ResearchInstituteModel:n_OnReceiveFtyLineAddInform(newLine)
    FlightMainModel.CloseFlightLoading()
    UIPanel.ClosePage()
    self:m_ReqGetScienceLineData()
    Event.Brocast("c_OnReceiveResearchFtyLineAddInform",newLine)
end

-- 生产线变化推送
function ResearchInstituteModel:n_OnReceiveGetFtyLineChangeInform(newLine)
    Event.Brocast("c_OnReceiveGetFtyLineChangeInform",newLine)
end

-- 开启科技点数（开宝箱）
function ResearchInstituteModel:n_OnReceiveOpenScienceBox(scienceBoxACK)
    Event.Brocast("c_OnReceiveOpenScienceBox",scienceBoxACK)
end

-- 获取科技资料仓库数据(研究所、推广公司)
function ResearchInstituteModel:n_OnReceiveGetScienceStorageData(scienceStorageData)
    Event.Brocast("c_OnReceiveGetScienceStorageData",scienceStorageData)
end

--使用点数回调
function ResearchInstituteModel:n_OnUserData(info)
    Event.Brocast("part_UserData",info)
    local data = {}
    data.num = info.num
    data.pointNum = info.pointNum
    ct.OpenCtrl("GetCountCtrl",data)
end

--购买点数回调
function ResearchInstituteModel:n_OnBuyData(info)
    --self:m_detailPublicFacility(info.buildingId)
    self:m_ReqGetScienceShelfData()
    local data = {}
    data.num = info.item.n
    data.pointNum = info.item.n
    ct.OpenCtrl("GetCountCtrl",data)
end