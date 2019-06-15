---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/3/6 11:13
---交易量model
VolumeModel = class("VolumeModel",ModelBase)

function VolumeModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function VolumeModel:OnCreate()
    DataManager.RegisterErrorNetMsg()
    --网络回调
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","eachTypeNpcNum","gs.EachTypeNpcNum",self.n_OnGetNpcNum,self) --npc类型数量
    --DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryGoodsNpcNum","ss.GoodsNpcNum",self.n_OnGoodsNpcNum,self) --每种商品购买的npc数量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryNpcNum","ss.NpcNums",self.n_OnGoodsNpcNum,self) --每种商品购买的npc数量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryNpcExchangeAmount","ss.NpcExchangeAmount",self.n_OnNpcExchangeAmount,self) --所有npc交易量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryExchangeAmount","ss.ExchangeAmount",self.n_OnExchangeAmount,self) --所有交易量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryPlayerExchangeAmount","ss.PlayExchangeAmount",self.n_OnPlayerTypeNum,self) --总量曲线
    --DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryPlayerGoodsCurve","ss.PlayerGoodsCurve",self.n_OnPlayerNumCurve,self) --购买数量
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getPlayerAmount","gs.PlayerAmount",self.n_OnPlayerCountCurve,self) --玩家数量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryPlayerGoodsCurve","ss.PlayerGoodsCurve",self.n_OngetPlayerAmount,self) --玩家交易商品数量


end

function VolumeModel:Close()
    --清空本地UI事件

end

--------------------客服端发包---------------------
--获取每种类型npc数量
function VolumeModel:m_GetNpcNum()
    local msgId = pbl.enum("gscode.OpCode","eachTypeNpcNum")
    ----2、 填充 protobuf 内部协议数据
    --local msglogion = pb.as.Login()
    --msglogion.account = this.username
    --local pb_login = msglogion:SerializeToString()  -- Parse Example
    ----3、 获取 protobuf 数据大小
    --local pb_size = #pb_login
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end

--每种商品购买的npc数量
function VolumeModel:m_GoodsNpcNum(time,type)
    local msgId = pbl.enum("sscode.OpCode","queryNpcNum")
    local lMsg = { time = time ,type = type }
    local pMsg = assert(pbl.encode("ss.QueryNpcNum", lMsg))
    --local msg = assert(pbl.decode("ss.QueryNpcNum",pMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end

--所有npc交易量
function VolumeModel:m_NpcExchangeAmount()
    local msgId = pbl.enum("sscode.OpCode","queryNpcExchangeAmount")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, nil, CityEngineLua._tradeNetworkInterface1)
end

--所有交易量
function VolumeModel:m_ExchangeAmount()
    local msgId = pbl.enum("sscode.OpCode","queryExchangeAmount")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, nil, CityEngineLua._tradeNetworkInterface1)
end

--曲线图数据 (供应)
function VolumeModel:m_GoodsNpcNumCurve(itemId)
    local msgId = pbl.enum("sscode.OpCode","queryGoodsNpcNumCurve")
    local lMsg = { id = itemId }
    local pMsg = assert(pbl.encode("ss.GoodsNpcNumCurve", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1)
end
--曲线图数据 (需求)
function VolumeModel:m_GoodsNpcTypeNum(itemId)
    local msgId = pbl.enum("sscode.OpCode","queryNpcTypeNum")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId, nil, CityEngineLua._tradeNetworkInterface1)
end
--当前玩家交易总量
function VolumeModel:m_PlayerTypeNum(itemId)
    local msgId = pbl.enum("sscode.OpCode","queryPlayerExchangeAmount")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId,nil,CityEngineLua._tradeNetworkInterface1)
end
--当前玩家交易总量曲线图
function VolumeModel:m_GoodsplayerTypeNum(itemId)
    local msgId = pbl.enum("sscode.OpCode","queryPlayerExchangeAmount")
    CityEngineLua.Bundle:newAndSendMsgExt(msgId,nil,CityEngineLua._tradeNetworkInterface1)
end
--玩家人数
function VolumeModel:m_PlayerNum(itemId)
    local msgId = pbl.enum("gscode.OpCode","getPlayerAmount")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)
end
--玩家购买数量折线图
function VolumeModel:m_PlayerNumCurve(info)
    local msgId = pbl.enum("sscode.OpCode","queryPlayerGoodsCurve")
    local lMsg = { id = info.id ,exchangeType = info.exchangeType,type = info.type}
    local pMsg = assert(pbl.encode("ss.PlayerGoodsCurve", lMsg))
    CityEngineLua.Bundle:newAndSendMsgExt(msgId,pMsg,CityEngineLua._tradeNetworkInterface1)
end
-------------------服务器回调---------------------
function VolumeModel:n_OnGetNpcNum(lMsg)
    Event.Brocast("c_NpcNum",lMsg.countNpcMap,lMsg.workNpcNum,lMsg.unEmployeeNpcNum)
end

function VolumeModel:n_OnGoodsNpcNum(lMsg)
    Event.Brocast("c_OnGoodsNpcNum",lMsg.numInfo,lMsg.type)
end

function VolumeModel:n_OnNpcExchangeAmount(lMsg)
    Event.Brocast("c_NpcExchangeAmount",lMsg.npcExchangeAmount)
end

function VolumeModel:n_OnExchangeAmount(lMsg)
    Event.Brocast("c_ExchangeAmount",lMsg.exchangeAmount)
end
--玩家总交易量
function VolumeModel:n_OnPlayerTypeNum(tradeinfo)
    Event.Brocast("c_allbuyAmount",tradeinfo.playExchangeAmount)
end
--玩家商品购买数量
--function VolumeModel:n_OnPlayerNumCurve(lMsg)
--    Event.Brocast("c_currebuyAmount",lMsg.exchangeAmount)
--end
--玩家数量
function VolumeModel:n_OnPlayerCountCurve(lMsg)
    Event.Brocast("c_currebPlayerNum",lMsg.playerAmount)
end
----玩家购买数量折线图
function VolumeModel:n_OngetPlayerAmount(lMsg)
    if  lMsg.exchangeType == 2 or lMsg.exchangeType == 4 then
        Event.Brocast("c_ToggleBtnThreeItem",lMsg.playerGoodsCurveMap)
    else
        Event.Brocast("c_ToggleBtnTwoItem",lMsg.playerGoodsCurveMap)
    end
end
