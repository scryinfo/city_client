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
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryGoodsNpcNum","ss.GoodsNpcNum",self.n_OnGoodsNpcNum,self) --每种商品购买的npc数量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryNpcExchangeAmount","ss.NpcExchangeAmount",self.n_OnNpcExchangeAmount,self) --所有npc交易量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryExchangeAmount","ss.ExchangeAmount",self.n_OnExchangeAmount,self) --所有交易量
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryGoodsNpcNumCurve","ss.GoodsNpcNumCurve",self.n_OnGoodsNpcNumCurve,self) --供应曲线
    DataManager.ModelRegisterNetMsg(nil,"sscode.OpCode","queryNpcTypeNum","ss.NpcTypeNum",self.n_OnGoodsNpcNumCurve,self) --需求曲线

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
function VolumeModel:m_GoodsNpcNum(time)
    local msgId = pbl.enum("sscode.OpCode","queryGoodsNpcNum")
    local lMsg = { time = time }
    local pMsg = assert(pbl.encode("ss.GoodNpcNumInfo", lMsg))
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

-------------------服务器回调---------------------
function VolumeModel:n_OnGetNpcNum(lMsg)
    Event.Brocast("c_NpcNum",lMsg.countNpcMap)
end

function VolumeModel:n_OnGoodsNpcNum(lMsg)
    Event.Brocast("c_OnGoodsNpcNum",lMsg.goodNpcNumInfo)
end

function VolumeModel:n_OnNpcExchangeAmount(lMsg)
    Event.Brocast("c_NpcExchangeAmount",lMsg.npcExchangeAmount)
end

function VolumeModel:n_OnExchangeAmount(lMsg)
    Event.Brocast("c_ExchangeAmount",lMsg.exchangeAmount)
end

function VolumeModel:n_OnGoodsNpcNumCurve(lMsg)
   --Event.Brocast("c_GoodsNpcNumCurve",lMsg.goodsNpcNumCurveMap)
   Event.Brocast("c_GoodsNpcNumCurve",lMsg)
end