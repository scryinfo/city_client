---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/3/5 15:26
---
MapModel = {}
local pbl = pbl

--启动事件--
function MapModel.registerNetMsg()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryMarketSummary"), MapModel.n_OnReceiveQueryMarketSummary)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundSummary"), MapModel.n_OnReceiveGroundTransSummary)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryMarketDetail"), MapModel.n_OnReceiveQueryMarketDetail)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryLabSummary"), MapModel.n_OnReceiveLabSummary)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryContractSummary"), MapModel.n_OnReceiveSigningSummary)
end


--- 客户端请求 ---
--请求原料商品搜索摘要
function MapModel.m_ReqQueryMarketSummary(itemId)
    if itemId ~= nil then
        DataManager.ModelSendNetMes("gscode.OpCode", "queryMarketSummary","gs.Num",{ num = itemId})
    end
end
--请求土地交易搜索摘要
function MapModel.m_ReqGroundTransSummary()
    local msgId = pbl.enum("gscode.OpCode", "queryGroundSummary")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--请求科研搜索摘要
function MapModel.m_ReqLabSummary()
    local msgId = pbl.enum("gscode.OpCode", "queryLabSummary")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--请求推广搜索摘要
function MapModel.m_ReqPromotionSummary()
    --local msgId = pbl.enum("gscode.OpCode", "queryGroundSummary")
    --CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--仓库摘要
function MapModel.m_ReqWarehouseSummary()
    --local msgId = pbl.enum("gscode.OpCode", "queryGroundSummary")
    --CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end
--签约摘要
function MapModel.m_ReqSigningSummary()
    local msgId = pbl.enum("gscode.OpCode", "queryContractSummary")
    CityEngineLua.Bundle:newAndSendMsg(msgId, nil)
end

--请求原料商品搜索详情
function MapModel.m_ReqMarketDetail(gridIndexPos, itemId)
    local data = { centerIdx = {x = gridIndexPos.x, y = gridIndexPos.y}, itemId = itemId}
    DataManager.ModelSendNetMes("gscode.OpCode", "queryMarketDetail","gs.QueryMarketDetail", data)
end
--请求仓库详情
function MapModel.m_ReqWarehouseDetail(gridIndexPos)
    --local data = { centerIdx = {x = gridIndexPos.x, y = gridIndexPos.y}}
    --DataManager.ModelSendNetMes("gscode.OpCode", "queryMarketDetail","gs.QueryMarketDetail", data)
end
--请求签约详情
function MapModel.m_ReqSigningDetail(gridIndexPos)
    --local data = { centerIdx = {x = gridIndexPos.x, y = gridIndexPos.y}}
    --DataManager.ModelSendNetMes("gscode.OpCode", "queryMarketDetail","gs.QueryMarketDetail", data)
end
--请求推广详情
function MapModel.m_ReqPromotionDetail(gridIndexPos)
    --local data = { centerIdx = {x = gridIndexPos.x, y = gridIndexPos.y}}
    --DataManager.ModelSendNetMes("gscode.OpCode", "queryMarketDetail","gs.QueryMarketDetail", data)
end
--请求科研详情
function MapModel.m_ReqTechnologyDetail(gridIndexPos)
    --local data = { centerIdx = {x = gridIndexPos.x, y = gridIndexPos.y}}
    --DataManager.ModelSendNetMes("gscode.OpCode", "queryMarketDetail","gs.QueryMarketDetail", data)
end

--- 摘要回调 ---
--原料商品搜索摘要
function MapModel.n_OnReceiveQueryMarketSummary(stream)
    if stream == nil or stream == "" then
        return
    end
    local data = assert(pbl.decode("gs.MarketSummary", stream), "MapModel.n_OnReceiveQueryMarketSummary: stream == nil")
    MapCtrl._receiveMarketSummary(MapCtrl, data)
end
--土地交易搜索摘要
function MapModel.n_OnReceiveGroundTransSummary(stream)
    if stream == nil or stream == "" then
        return
    end
    local data = assert(pbl.decode("gs.GroundSummary", stream), "MapModel.n_OnReceiveGroundTransSummary: stream == nil")
    MapCtrl._receiveGroundTransSummary(MapCtrl, data)
end
--科研摘要
function MapModel.n_OnReceiveLabSummary(stream)
    if stream == nil or stream == "" then
        return
    end
    local data = assert(pbl.decode("gs.LabSummary", stream), "MapModel.n_OnReceiveLabSummary: stream == nil")
    MapCtrl._receiveLabSummary(MapCtrl, data)
end
--推广摘要
function MapModel.n_OnReceiveLabSummary(stream)
    if stream == nil or stream == "" then
        return
    end
    --local data = assert(pbl.decode("gs.MarketDetail", stream), "MapModel.n_OnReceiveLabSummary: stream == nil")
    --MapCtrl._receivePromotionSummary(MapCtrl, data)
end
--仓库摘要
function MapModel.n_OnReceiveWarehouseSummary(stream)
    if stream == nil or stream == "" then
        return
    end
    --local data = assert(pbl.decode("gs.MarketDetail", stream), "MapModel.n_OnReceiveLabSummary: stream == nil")
    --MapCtrl._receivePromotionSummary(MapCtrl, data)
end
--签约摘要
function MapModel.n_OnReceiveSigningSummary(stream)
    if stream == nil or stream == "" then
        return
    end
    local data = assert(pbl.decode("gs.ContractSummary", stream), "MapModel.n_OnReceiveSigningSummary: stream == nil")
    MapCtrl._receiveSigningSummary(MapCtrl, data)
end

--- 详情回调 ---
--原料商品搜索详情
function MapModel.n_OnReceiveQueryMarketDetail(stream)
    if stream == nil or stream == "" then
        return
    end
    local data = assert(pbl.decode("gs.MarketDetail", stream), "MapModel.n_OnReceiveQueryMarketDetail: stream == nil")
    MapCtrl._receiveMarketDetail(MapCtrl, data)
end
--原料商品搜索详情
function MapModel.n_OnReceiveSignDetail(stream)
    if stream == nil or stream == "" then
        return
    end
    local data = assert(pbl.decode("gs.ContractGridDetail", stream), "MapModel.n_OnReceiveSignDetail: stream == nil")
    MapCtrl._receiveSignDetail(MapCtrl, data)
end
