---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/15 17:25
---通知Model
GameNoticeModel = class("GameNoticeModel",ModelBase)
local pbl = pbl

function GameNoticeModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function GameNoticeModel:OnCreate()
    --网络回调
     DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","mailRead","gs.Id",self.n_OnMailRead,self)
     DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","delMail","gs.Id",self.n_OnDeleMails,self)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","mailRead"),GameNoticeModel.n_OnMailRead);
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","delMail"),GameNoticeModel.n_OnDeleMails);
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailMaterialFactory","gs.MaterialFactory",self.n_OnMaterialFactory,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailProduceDepartment","gs.ProduceDepartment",self.n_OnProduceDepartment,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailRetailShop","gs.RetailShop",self.n_OnDetailRetailShop,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","detailPublicFacility","gs.PublicFacility",self.n_OnPromote,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getOneSocietyInfo","gs.SocietyInfo",self.n_OnSocietyInfo,self)
end

function GameNoticeModel:Close()
    --清空本地UI事件
end
--客户端请求--

--读取邮件
function GameNoticeModel:m_mailRead(mailId)
    DataManager.ModelSendNetMes("gscode.OpCode", "mailRead","gs.Id",{id = mailId})

end

--删除邮件
function GameNoticeModel:m_delMail(mailId)
    DataManager.ModelSendNetMes("gscode.OpCode", "delMail","gs.Id",{id = mailId})

end

--获取好友信息
function GameNoticeModel:m_GetMyFriendsInfo(friendsIds)
    DataManager.ModelSendNetMes("gscode.OpCode", "queryPlayerInfo","gs.Bytes",{ ids = friendsIds})
end

--获取原料厂详情
function GameNoticeModel:m_GetMateralDetailInfo(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","detailMaterialFactory" ,"gs.Id",{id = buildingId})
end

--获取加工厂详情
function GameNoticeModel:m_GetProduceDepartment(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","detailProduceDepartment" ,"gs.Id",{id = buildingId})
end

--获取零售店详情
function GameNoticeModel:m_GetRetailShop(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","detailRetailShop" ,"gs.Id",{id = buildingId})
end

--获取推广公司详情
function GameNoticeModel:m_GetPromote(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode","detailPublicFacility" ,"gs.Id",{id = buildingId})
end

--获取公会名字
function GameNoticeModel:m_GetSocietyInfo(id)
    DataManager.ModelSendNetMes("gscode.OpCode","getOneSocietyInfo" ,"gs.Id",{id = id})
end

--服务器回调--

--查看
function GameNoticeModel:n_OnMailRead(lMsg)
    --local lMsg = assert(pbl.decode("gs.Id", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    local go = NoticeMgr.notice[lMsg.id]
    Event.Brocast("c_OnMailRead",go)
end

--删除
function GameNoticeModel:n_OnDeleMails(lMsg)
    --DataManager.ControllerRpcNoRet(self.insId,"GameMainInterfaceCtrl", '_delMails',stream)
    --local lMsg = assert(pbl.decode("gs.Id", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    local go = NoticeMgr.notice[lMsg.id]
    Event.Brocast("c_OnDeleMails",go)
end

--原料厂建筑详情回调
function GameNoticeModel:n_OnMaterialFactory(info)
    Event.Brocast("c_MaterialInfo",info.info.name)
end

--加工厂建筑详情回调
function GameNoticeModel:n_OnProduceDepartment(info)
    Event.Brocast("c_ProduceInfo",info.info.name)
end

--零售店建筑详情回调
function GameNoticeModel:n_OnDetailRetailShop(info)
    Event.Brocast("c_RetailShopInfo",info.info.name)
end

--推广公司建筑详情回调
function GameNoticeModel:n_OnPromote(info)
    Event.Brocast("c_PromoteInfo",info.info.name)
end

--公会详情回调
function GameNoticeModel:n_OnSocietyInfo(info)
    Event.Brocast("c_SocietyInfo",info.name)
end
