---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/24 16:32
---
GroundTransModel = {}
local this = GroundTransModel

--构建函数--
function GroundTransModel.New()
    return this
end
--设置地块ID
function GroundTransModel.SetGroundBlockId(blockId)
    GroundTransModel.blockId = blockId
    local pos = TerrainManager.BlockIDTurnPosition(GroundTransModel.blockId)
    GroundTransModel.blockPos = {x = pos.x, y = pos.z}  --存一个位置信息
end

--- 客户端请求 ---
--出租
function GroundTransModel.m_ReqRentOutGround(rentDaysMin, rentDaysMax, rentPreDay)
    local data = {}
    data.coord = {[1] = GroundTransModel.blockPos}
    data.rentPreDay = rentPreDay
    data.rentDaysMin = rentDaysMin
    data.rentDaysMax = rentDaysMax
    local msgId = pbl.enum("gscode.OpCode","rentOutGround")
    local pMsg = assert(pbl.encode("gs.GroundRent", data))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--租别人的房子 --参数为groundInfo.rent
function GroundTransModel.m_ReqRentGround(data, days)
    local tempData = {}
    local info = {}
    info.rentPreDay = data.rentPreDay
    info.rentDaysMin = data.rentDaysMin
    info.rentDaysMax = data.rentDaysMax
    info.coord = {[1] = GroundTransModel.blockPos}
    tempData.info = info
    tempData.days = days

    local msgId = pbl.enum("gscode.OpCode","rentGround")
    local pMsg = assert(pbl.encode("gs.RentGround", tempData))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--出售土地
function GroundTransModel.m_ReqSellGround(price)
    local msgId = pbl.enum("gscode.OpCode","sellGround")
    local pMsg = assert(pbl.encode("gs.GroundSale", { price = price, coord = {[1] = GroundTransModel.blockPos}}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--购买土地
function GroundTransModel.m_ReqBuyGround(price)
    local msgId = pbl.enum("gscode.OpCode","buyGround")
    local pMsg = assert(pbl.encode("gs.GroundSale", { price = price, coord = {[1] = GroundTransModel.blockPos}}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--取消出租
function GroundTransModel.m_ReqCancelRentGround()
    local msgId = pbl.enum("gscode.OpCode","cancelRentGround")
    local pMsg = assert(pbl.encode("gs.MiniIndexCollection", { coord = {[1] = GroundTransModel.blockPos}}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--取消售卖
function GroundTransModel.m_ReqCancelSellGround()
    local msgId = pbl.enum("gscode.OpCode","cancelSellGround")
    local pMsg = assert(pbl.encode("gs.MiniIndexCollection", { coord = {[1] = GroundTransModel.blockPos}}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end
--请求玩家信息
function GroundTransModel.m_ReqPlayersInfo(ids)
    local msgId = pbl.enum("gscode.OpCode","queryPlayerInfo")
    local pMsg = assert(pbl.encode("gs.Bytes", { ids = ids}))
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg)
end