---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/31 19:12
---临时记录玩家信息
PlayerTempModel = {}
local this = PlayerTempModel
local pbl = pbl

--构建函数--
function PlayerTempModel.New()
    return this
end

function PlayerTempModel.Awake()
    UpdateBeat:Add(this.Update, this)
    this:OnCreate()
end

function PlayerTempModel.Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.Space) then
        PlayerTempModel.tempTestReqAddGroung(0,0,100,100)
    end
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.A) then
        PlayerTempModel.tempTestReqAddMoney(9999999)
    end
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.D) then
        PlayerTempModel.tempTestReqAddItem(2151001, 9999)
    end

    --if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.W) then
    --    ct.OpenCtrl("HouseCtrl", this.tempHouseData)
    --end
end

--启动事件--
function PlayerTempModel.OnCreate()
    --网络回调注册 网络回调用n开头
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitCreate"), PlayerTempModel.n_OnReceiveUnitCreate)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","unitChange"), PlayerTempModel.n_OnReceiveUnitChange)

    --本地的回调注册
    Event.AddListener("m_RoleLoginInExchangeModel", this.n_OnReceiveRoleLogin)
end

--关闭事件--
function PlayerTempModel.Close()
    --Event.RemoveListener("m_PlayerBidGround", this.m_BidGround)
end

---temp 记录role信息
function PlayerTempModel.n_OnReceiveRoleLogin(stream)
    local roleData = assert(pbl.decode("gs.Role", stream), "PlayerTempModel.n_OnReceiveExchangeDeal: stream == nil")
    PlayerTempModel.roleData = roleData
    PlayerTempModel.buildingData = this._getBuildingInfo(roleData)
    PlayerTempModel.storeList = this._getStore(roleData)
    PlayerTempModel.collectList = roleData.exchangeCollectedItem
    if not PlayerTempModel.collectList then
        PlayerTempModel.collectList = {}
    end
end
--创建建筑时的同步
function PlayerTempModel.n_OnReceiveUnitCreate(stream)
    local buildingInfo = assert(pbl.decode("gs.UnitCreate", stream), "PlayerTempModel.n_OnReceiveUnitCreate: stream == nil")
    if not PlayerTempModel.buildingsInfo then
        PlayerTempModel.buildingsInfo = {}
    end
    PlayerTempModel.buildingsInfo[#PlayerTempModel.buildingsInfo + 1] = buildingInfo
end
--建筑信息更改时同步
function PlayerTempModel.n_OnReceiveUnitChange(stream)
    local buildingInfo = assert(pbl.decode("gs.UnitChange", stream), "PlayerTempModel.n_OnReceiveUnitChange: stream == nil")
    if not PlayerTempModel.buildingsInfo then
        PlayerTempModel.buildingsInfo = {}
    end
    PlayerTempModel.buildingsInfo[#PlayerTempModel.buildingsInfo + 1] = buildingInfo
end
---
--add building
function PlayerTempModel.m_ReqAddBuilding(id, posx, posy)
    local msgId = pbl.enum("gscode.OpCode", "addBuilding")
    local lMsg = {id = id, pos = {x = posx, y = posy}}
    local pMsg = assert(pbl.encode("gs.AddBuilding", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--add money
function PlayerTempModel.tempTestReqAddMoney(money)
    local msgId = pbl.enum("gscode.OpCode", "cheat")
    local lMsg = {str = string.format("addmoney %s", money)}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--add item
function PlayerTempModel.tempTestReqAddItem(itemId, num)
    local msgId = pbl.enum("gscode.OpCode", "cheat")
    local lMsg = {str = string.format("additem %s %s", itemId, num)}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--add ground
function PlayerTempModel.tempTestReqAddGroung(x1, y1, x2, y2)
    local msgId = pbl.enum("gscode.OpCode", "cheat")
    local lMsg = {str = string.format("addground %s %s %s %s", x1, y1, x2, y2)}
    local pMsg = assert(pbl.encode("gs.Str", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end

---
function PlayerTempModel._getStore(roleData)
    local buyStore = {}
    if roleData.buys then
        buyStore = this._getCollectStore(roleData.buys)
    else
        ---测试
        --PlayerTempModel.m_ReqAddBuilding(1400001, 1, 1)
        --PlayerTempModel.m_ReqAddBuilding(1100001, 5, 5)
        --PlayerTempModel.m_ReqAddBuilding(1200001, 10, 10)
    end

    local rentStore = {}
    if roleData.rents then
        rentStore = this._getCollectStore(roleData.rents)
    end

    for i, data in ipairs(rentStore) do
        table.insert(buyStore, data)
    end
    return buyStore
end
--获取所有带仓库的建筑的building id
function PlayerTempModel._getCollectStore(datas)
    local storeList = {}
    local materialFactory = datas.materialFactory
    local produceDepartment = datas.produceDepartment

    if materialFactory then
        for i, value in ipairs(materialFactory) do
            --正式代码
            --storeList[i] = value.store
            --storeList[i].buildingId = value.info.id
            --storeList[i].buildingTypeId = value.info.mId

            --测试
            local inHand = {
                {id = 2151001, num = 10},
                {id = 2151002, num = 30},
                {id = 2151003, num = 33},
                {id = 2151004, num = 45},
                {id = 2152001, num =  9}
            }
            value.store = {}
            value.store.inHand = inHand
            storeList[i] = value.store
            storeList[i].buildingId = value.info.id
            storeList[i].buildingTypeId = value.info.mId
        end
    end
    if produceDepartment then
        for i, value in ipairs(produceDepartment) do
            local listCount = #storeList + i
            storeList[listCount] = value
            storeList[listCount].buildingId = value.info.id
            storeList[listCount].buildingTypeId = value.info.mId
        end
    end
    return storeList
end
--获取所有建筑，根据buildingId
function PlayerTempModel._getBuildingInfo(roleData)
    local buyBuilding = {}
    if roleData.buys then
        buyBuilding = this._getBuildingInfoInType(roleData.buys)
    end

    local rentBuilding = {}
    if roleData.rents then
        rentBuilding = this._getBuildingInfoInType(roleData.rents)
    end

    for i, data in ipairs(rentBuilding) do
        table.insert(buyBuilding, data)
    end
    return buyBuilding
end
function PlayerTempModel._getBuildingInfoInType(buildingSet)
    local buildingList = {}
    local apartment = buildingSet.apartment
    local materialFactory = buildingSet.materialFactory
    local produceDepartment = buildingSet.produceDepartment

    if apartment then
        for i, value in ipairs(apartment) do
            buildingList[value.info.id] = value
            this.tempHouseData = value  ---测试
        end
    end
    if materialFactory then
        for i, value in ipairs(materialFactory) do
            buildingList[value.info.id] = value
        end
    end
    if produceDepartment then
        for i, value in ipairs(produceDepartment) do
            buildingList[value.info.id] = value
        end
    end
    return buildingList
end