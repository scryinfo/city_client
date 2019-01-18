---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/1/17 17:34
---

CompanyModel = class("CompanyModel",ModelBase)
--local pbl = pbl
function CompanyModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function CompanyModel:OnCreate()
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryPlayerEconomy","ss.EconomyInfos",self.n_OnReceivePlayerEconomy,self)
    --CityEngineLua.Message:registerNetMsg(pbl.enum("sscode.OpCode","queryPlayerEconomy"),CompanyModel.n_OnReceivePlayerEconomy)
end

-- 查询玩家的交易消息返回
function CompanyModel:m_QueryPlayerEconomy(id)
    --gs 登录
    --1、 获取协议id
    local msgId = pbl.enum("sscode.OpCode","queryPlayerEconomy")
    --2、 填充 protobuf 内部协议数据
    local lMsg = { id = id}
    local pMsg = assert(pbl.encode("ss.Id", lMsg))
    --3、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end

-- 服务器返回的消息信息
function CompanyModel:n_OnReceivePlayerEconomy(economyInfos)
    --local economyInfos = assert(pbl.decode("ss.EconomyInfos", stream), "DataManager.n_DeleteBlacklist: stream == nil")
    Event.Brocast("c_OnReceivePlayerEconomy", economyInfos)
end