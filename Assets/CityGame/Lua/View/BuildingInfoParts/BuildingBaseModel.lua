---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by fisher.
--- DateTime: 2019/2/16 11:40
---
BuildingBaseModel = class("BuildingBaseModel",ModelBase)

function BuildingBaseModel:initialize(insId)
    self.insId = insId
end
---客户端请求---
---仓库---
--上架
function BuildingBaseModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = tonumber(price),autoRepOn = autoRepOn}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfAdd","gs.ShelfAdd",lMsg)
end
--运输
function BuildingBaseModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    local lMsg = {src = src,dst = dst,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(n)}}
    DataManager.ModelSendNetMes("gscode.OpCode","transferItem","gs.TransferItem",lMsg)
end
--修改货架设置
function BuildingBaseModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty,autoRepOn)
    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = tonumber(price),autoRepOn = autoRepOn}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfSet","gs.ShelfSet",lMsg)
end
--销毁原料或商品
function BuildingBaseModel:m_ReqDelItem(buildingId,itemId,num,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(num)}}
    DataManager.ModelSendNetMes("gscode.OpCode","delItem","gs.DelItem",lMsg)
end
---货架---
--下架
function BuildingBaseModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = num}}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfDel","gs.ShelfDel",lMsg)
end
--购买
function BuildingBaseModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(number)},price = tonumber(price),wareHouseId = wareHouseId}
    DataManager.ModelSendNetMes("gscode.OpCode","buyInShelf","gs.BuyInShelf",lMsg)
end
---生产线---
--添加生产线
function BuildingBaseModel:m_ReqAddLine(buildingId,number,steffNumber,itemId)
    local lMsg = {id = buildingId, itemId = itemId, targetNum = number, workerNum = tonumber(steffNumber)}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyAddLine","gs.AddLine",lMsg)
end
--修改生产线
--function BuildingBaseModel:m_ResModifyKLine(buildingId,targetNum,steffNumber,lineId)
--    local lMsg = {buildingId = buildingId,targetNum = targetNum,workerNum = tonumber(steffNumber),lineId = lineId}
--    DataManager.ModelSendNetMes("gscode.OpCode","ftyChangeLine","gs.ChangeLine",lMsg)
--end
--删除生产线
function BuildingBaseModel:m_ReqDeleteLine(buildingId,lineId)
    local lMsg = {buildingId = buildingId, lineId = lineId}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyDelLine","gs.DelLine",lMsg)
end
--生产线置顶
function BuildingBaseModel:m_ReqSetLineOrder(buildingId,lineId,pos)
    local lMsg = {buildingId = buildingId,lineId = lineId,lineOrder = pos}
    DataManager.ModelSendNetMes("gscode.OpCode","ftySetLineOrder","gs.SetLineOrder",lMsg)
end
--自动补货
function BuildingBaseModel:m_ReqSetAutoReplenish(buildingId,itemId,producerId,qty,autoRepOn)
    local lMsg = {buildingId = buildingId,iKey = {id = itemId,producerId = producerId,qty = qty},autoRepOn = autoRepOn}
    DataManager.ModelSendNetMes("gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",lMsg)
end
--添加购物车
function BuildingBaseModel:m_ReqAddShoppingCart(buildingId,itemId,number,price,producerId,qty)
    local lMsg = {buildingId = buildingId,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(number)},price = tonumber(price)}
    DataManager.ModelSendNetMes("gscode.OpCode","addShopCart","gs.GoodInfo",lMsg)
end
----获取特定品牌 TODO:协议修改，这个没有用到
--function BuildingBaseModel:m_ReqGetBrandName(playerId,itemId)
--    local lMsg = {pId = playerId,typeId = itemId}
--    DataManager.ModelSendNetMes("gscode.OpCode","queryBrand","gs.queryBrand",lMsg)
--end
--查询原料信息
function BuildingBaseModel:m_ReqBuildingMaterialInfo(buildingId)
    local lMsg = {id = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode","queryBuildingMaterialInfo","gs.Id",lMsg)
end
--查询商品信息
function BuildingBaseModel:m_ReqBuildingGoodsInfo(buildingId)
    local lMsg = {id = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode","queryBuildingGoodInfo","gs.Id",lMsg)
end
--获取仓库数据
function BuildingBaseModel:m_GetWarehouseData(buildingId)
    local lMsg = {id = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode","getStorageData","gs.Id",lMsg)
end
--获取货架数据
function BuildingBaseModel:m_GetShelfData(buildingId)
    local lMsg = {id = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode","getShelfData","gs.Id",lMsg)
end
--获取生产线
function BuildingBaseModel:m_GetLineData(buildingId)
    local lMsg = {id = buildingId}
    DataManager.ModelSendNetMes("gscode.OpCode","getLineData","gs.Id",lMsg)
end
--获取原料参考价格
function BuildingBaseModel:m_GetMaterialGuidePrice(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode","queryMaterialRecommendPrice","gs.QueryBuildingInfo",lMsg)
end
--获取商品参考价格
function BuildingBaseModel:m_GetProcessingGuidePrice(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode","queryProduceDepRecommendPrice","gs.QueryBuildingInfo",lMsg)
end
--获取零售店参考价格
function BuildingBaseModel:m_GetRetailGiodePrice(buildingId,playerId)
    local lMsg = {buildingId = buildingId,playerId = playerId}
    DataManager.ModelSendNetMes("gscode.OpCode","queryRetailShopRecommendPrice","gs.QueryBuildingInfo",lMsg)
end