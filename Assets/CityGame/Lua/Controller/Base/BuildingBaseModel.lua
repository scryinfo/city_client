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
function BuildingBaseModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = tonumber(price)}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfAdd","gs.ShelfAdd",lMsg)
end
--运输
function BuildingBaseModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    local lMsg = {src = src,dst = dst,item = {key = {id = itemId,producerId = producerId,qty = qty},n = tonumber(n)}}
    DataManager.ModelSendNetMes("gscode.OpCode","transferItem","gs.TransferItem",lMsg)
end
--修改数量或价格
function BuildingBaseModel:m_ReqModifyShelf(buildingId,Id,num,price,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {key = {id = Id,producerId = producerId,qty = qty},n = tonumber(num)}, price = price}
    DataManager.ModelSendNetMes("gscode.OpCode","shelfSet","gs.ShelfSet",lMsg)
end
--销毁原料或商品
function BuildingBaseModel:m_ReqDelItem(buildingId,id,producerId,qty)
    local lMsg = {buildingId = buildingId, item = {id = id,producerId = producerId,qty = qty}}
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
function BuildingBaseModel:m_ResModifyKLine(buildingId,targetNum,steffNumber,lineId)
    local lMsg = {buildingId = buildingId,targetNum = targetNum,workerNum = tonumber(steffNumber),lineId = lineId}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyChangeLine","gs.ChangeLine",lMsg)
end
--删除生产线
function BuildingBaseModel:m_ReqDeleteLine(buildingId,lineId)
    local lMsg = {buildingId = buildingId, lineId = lineId}
    DataManager.ModelSendNetMes("gscode.OpCode","ftyDelLine","gs.DelLine",lMsg)
end
---服务器回调---
---仓库---
--上架
function BuildingBaseModel:n_OnShelfAddInfo(data)
    Event.Brocast("n_shelfAdd",data)
    Event.Brocast("SmallPop",GetLanguage(27020002),300)
end
--运输
function BuildingBaseModel:n_OnBuildingTransportInfo(data)
    local bagId = DataManager.GetBagId()
    local n = data.item.n
    local qty = data.item.key.qty
    local itemId = data.item.key.id
    local producerId = data.item.key.producerId
    if data.dst == bagId then
        Event.Brocast("c_AddBagInfo",itemId,producerId,qty,n)
    end
    Event.Brocast("n_transports",data)
end
--修改数量或价格
function BuildingBaseModel:n_OnModifyShelfInfo(data)
    --Event.Brocast("shelfRefreshUiInfo",data)
end
--销毁原料或商品
function BuildingBaseModel:n_OnDelItemInfo(data)
    Event.Brocast("deleteObjeCallback",data)
end
---货架---
--下架
function BuildingBaseModel:n_OnShelfDelInfo(data)
    Event.Brocast("delGoodRefreshInfo",data)
end
--购买
function BuildingBaseModel:n_OnBuyShelfGoods(data)
    Event.Brocast("receiveBuyRefreshInfo",data)
end
---生产线---
--添加生产线
function BuildingBaseModel:n_OnAddLineInfo(data)
    Event.Brocast("calculateTime",data)
    Event.Brocast("refreshSubtractWorkerNum",data)
    Event.Brocast("SmallPop",GetLanguage(28010007),300)
end
--修改生产线
function BuildingBaseModel:n_OnModifyKLineInfo(data)
    Event.Brocast("callbackDataInfo",data)
    Event.Brocast("SmallPop",GetLanguage(27010005),300)
end
--删除生产线
function BuildingBaseModel:n_OnDeleteLineInfo(data)
    Event.Brocast("SmallPop",GetLanguage(28010006),300)
    Event.Brocast("_deleteProductionLine",data)
end
--生产线变化推送
function BuildingBaseModel:n_OnLineChangeInform(data)
    Event.Brocast("refreshNowConte",data)
    Event.Brocast("c_refreshNowConte",data)
end