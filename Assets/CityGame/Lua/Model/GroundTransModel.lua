---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/24 16:32
---
GroundTransModel  = class('GroundTransModel',ModelBase)
local pbl = pbl

function GroundTransModel:initialize(blockID)
    self.blockID = blockID
    self:OnCreate()
end

function GroundTransModel:OnCreate()
    local pos = TerrainManager.BlockIDTurnPosition(self.blockID)
    self.blockPos = {x = pos.x, y = pos.z}  --存一个位置信息
end

--- 客户端请求 ---
--出租
function GroundTransModel:m_ReqRentOutGround(rentDaysMin, rentDaysMax, rentPreDay)
    local data = {}
    data.coord = self.blockPos
    data.rentPreDay = rentPreDay
    data.rentDaysMin = rentDaysMin
    data.rentDaysMax = rentDaysMax
    data.deposit = 0  --现在没有押金
    DataManager.ModelSendNetMes("gscode.OpCode", "rentOutGround","gs.GroundRent", data)
end
--租别人的房子 --参数为groundInfo.rent
function GroundTransModel:m_ReqRentGround(data, days)
    local tempData = {}
    local info = {}
    info.rentPreDay = data.rentPreDay
    info.deposit = data.deposit
    info.rentDaysMin = data.rentDaysMin
    info.rentDaysMax = data.rentDaysMax
    info.coord = self.blockPos
    tempData.info = info
    tempData.days = days
    DataManager.ModelSendNetMes("gscode.OpCode", "rentGround","gs.RentGround", tempData)
end
--出售土地
function GroundTransModel:m_ReqSellGround(price)
    DataManager.ModelSendNetMes("gscode.OpCode", "sellGround","gs.GroundSale",{ price = price, coord = self.blockPos})
end
--购买土地
function GroundTransModel:m_ReqBuyGround(price)
    DataManager.ModelSendNetMes("gscode.OpCode", "buyGround","gs.GroundSale",{ price = price, coord = self.blockPos})
end
--取消出租
function GroundTransModel:m_ReqCancelRentGround()
    DataManager.ModelSendNetMes("gscode.OpCode", "cancelRentGround","gs.MiniIndexCollection",{ coord = self.blockPos})
end
--取消售卖
function GroundTransModel:m_ReqCancelSellGround()
    DataManager.ModelSendNetMes("gscode.OpCode", "cancelSellGround","gs.MiniIndexCollection",{ coord = self.blockPos})
end

--- 回调 ---
--住宅详情
function GroundTransModel:n_OnReceiveHouseDetailInfo(houseDetailInfo)
    --DataManager.ControllerRpcNoRet(self.blockID,"HouseCtrl", '_receiveHouseDetailInfo',houseDetailInfo)
end