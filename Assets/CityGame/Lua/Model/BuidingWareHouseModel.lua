---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/4/15 15:38
---


BuidingWareHouseModel = class('BuidingWareHouseModel',ModelBase)
local pbl = pbl


function BuidingWareHouseModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

--启动事件--gs
function BuidingWareHouseModel:OnCreate()


    --本地事件
    Event.AddListener("m_WareHourseTransport",self.m_ReqBuildingTransport,self)        --运输
    Event.AddListener("m_ReqMaterialModifyShelf",self.m_ReqModifyShelf,self)
    Event.AddListener("m_ReqMaterialShelfAdd",self.m_ReqShelfAdd,self)                 --上架
    Event.AddListener("m_ReqMaterialShelfDel",self.m_ReqShelfDel,self)                 --下架
    Event.AddListener("m_ReqMaterialSetAutoReplenish",self.m_ReqSetAutoReplenish,self) --自动补货
    Event.AddListener("m_ShutRent",self.m_ReqShutSentHouseDetailInfo,self)             --取消出租
    Event.AddListener("m_ReqMaterialBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.AddListener("m_ReqrentInfo",self.m_ReqrentInfo,self)

    --网络回调注册
    --仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailWareHouse","gs.WareHouse",self.n_OnReceiveHouseDetailInfo)   --请求建筑详情
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setSalary","gs.SetSalary",self.n_OnHouseDetailInfo)                --设置工资
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","startBusiness","gs.Id",self.n_OnReceiveOpenBusiness)               --开业
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setWareHouseRent","gs.setWareHouseRent",self.n_OnReceiveSentWareHouseInfo)  --设置出租仓库
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setWareHouseRent","gs.closeWareHouseRent",self.n_OnReceiveSentWareHouseInfo)  --取消仓库出租
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","transferItem","gs.TransferItem",self.n_OnBuildingTransportInfo)         --运输
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","rentWareHouse","gs.detailWareHouseRenter",self.n_OnRenthouseInfo)         --请求租户信息

    --货架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfAdd","gs.ShelfAdd",self.n_OnShelfAddInfo)                     --上架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","shelfDel","gs.ShelfDel",self.n_OnShelfDelInfo)                     --下架
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","buyInShelf","gs.BuyInShelf",self.n_OnBuyShelfGoodsInfo)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","setAutoReplenish","gs.setAutoReplenish",self.n_OnSetAutoReplenish) --自动补货





    --本地的回调注册
    Event.AddListener("m_ReqHouseChangeRent", self.m_ReqHouseChangeRent, self)
    Event.AddListener("m_ReqHouseSetSalary", self.m_ReqHouseSetSalary, self)
end

function BuidingWareHouseModel:Close()
    Event.RemoveListener("m_WareHourseTransport",self.m_ReqBuildingTransport,self)
    Event.RemoveListener("m_ReqMaterialShelfAdd",self.m_ReqShelfAdd,self)
    Event.RemoveListener("m_ReqMaterialModifyShelf",self.m_ReqModifyShelf,self)
    Event.RemoveListener("m_ReqMaterialShelfDel",self.m_ReqShelfDel,self)
    Event.RemoveListener("m_ReqMaterialSetAutoReplenish",self.m_ReqSetAutoReplenish,self)
    Event.RemoveListener("m_ShutRent",self.m_ReqShutSentHouseDetailInfo,self)
    Event.RemoveListener("m_ReqMaterialBuyShelfGoods",self.m_ReqBuyShelfGoods,self)
    Event.RemoveListener("m_ReqrentInfo",self.m_ReqrentInfo,self)


    DataManager.ModelRemoveNetMsg(self.insId,"gscode.OpCode","setWareHouseRent","gs.setWareHouseRent",self.n_OnReceiveSentWareHouseInfo)  --租仓库

end


--- 客户端请求 ---
---
function BuidingWareHouseModel:m_ReqHouseDetailInfo(buildingId)
    DataManager.ModelSendNetMes("gscode.OpCode", "detailWareHouse","gs.Id",{id = buildingId})
end
--改变建筑名字
function BuidingWareHouseModel:m_ReqChangeHouseName(id, name)
    DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingInfo","gs.SetBuildingInfo",{ id = id, name = name})
end
--更改出租信息
function BuidingWareHouseModel:m_ReqSentHouseDetailInfo(data)
    DataManager.ModelSendNetMes("gscode.OpCode", "setWareHouseRent","gs.SetWareHouseRent",data)
end
--出租取消
function BuidingWareHouseModel:m_ReqShutSentHouseDetailInfo(data)
    DataManager.ModelSendNetMes("gscode.OpCode", "closeWareHouseRent","gs.SetWareHouseRent",data)
end
--运输
function BuidingWareHouseModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
    self.funModel:m_ReqBuildingTransport(src,dst, itemId, n,producerId,qty)
end
--下架
function BuidingWareHouseModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
    self.funModel:m_ReqShelfDel(buildingId,itemId,num,producerId,qty)
end
--上架
function BuidingWareHouseModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
    self.funModel:m_ReqShelfAdd(buildingId,Id,num,price,producerId,qty,autoRepOn)
end
--货架购买
function BuidingWareHouseModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
    self.funModel:m_ReqBuyShelfGoods(buildingId,itemId,number,price,wareHouseId,producerId,qty)
end
--租客租用仓库
function BuidingWareHouseModel:m_ReqrentSpace(data)
    DataManager.ModelSendNetMes("gscode.OpCode", "rentWareHouse","gs.rentWareHouse",data)
end
--请求租户信息
function BuidingWareHouseModel:m_ReqrentInfo(data)
    DataManager.ModelSendNetMes("gscode.OpCode", "rentWareHouse","gs.detailWareHouseRenter",data)
end
----- 回调 ---
--集散中心详情
function BuidingWareHouseModel:n_OnReceiveHouseDetailInfo(stream)
    DataManager.ControllerRpcNoRet(self.insId,"BuidingWareHouseCtrl", '_initData',stream)
    if stream ~= nil then
        if not self.funModel then
            self.funModel = BuildingBaseModel:new(self.insId)
        end
    end
end

--员工工资改变
function BuidingWareHouseModel:n_OnHouseDetailInfo(houseDetailInfo)
    DataManager.ControllerRpcNoRet(self.insId,"BuidingWareHouseCtrl", '_refreshlary',houseDetailInfo)
end

--开业成功，再次请求建筑详情
function BuidingWareHouseModel:n_OnReceiveOpenBusiness(data)
    if data ~= nil and data.id == self.insId then
        self:m_ReqHouseDetailInfo(self.insId)
        Event.Brocast("SmallPop", GetLanguage(40010020), 300)  --开业成功提示
    end
end

--更改出租信息回调
function BuidingWareHouseModel:n_OnReceiveSentWareHouseInfo(SentWareHouseInfo)
    DataManager.ControllerRpcNoRet(self.insId,"BuidingWareHouseCtrl", '_refreshRentInfo',SentWareHouseInfo)
end

--运输
function BuidingWareHouseModel:n_OnBuildingTransportInfo(data)
    Event.Brocast("transportSucceed",data)
    Event.Brocast("refreshWarehousePartCount")
end
--上架
function BuidingWareHouseModel:n_OnShelfAddInfo(data)
    DataManager.ControllerRpcNoRet(self.insId,"WarehouseDetailBoxCtrl",'RefreshWarehouseData',data)
    Event.Brocast("refreshShelfPartCount")
end
--下架
function BuidingWareHouseModel:n_OnShelfDelInfo(data)
    Event.Brocast("downShelfSucceed",data)
    Event.Brocast("refreshShelfPartCount")
end
--货架购买
function BuidingWareHouseModel:n_OnBuyShelfGoodsInfo(data)
    Event.Brocast("buySucceed",data)
    Event.Brocast("refreshShelfPartCount")
end
--租户详情回调
function BuidingWareHouseModel:n_OnRenthouseInfo(stream)
    --DataManager.ControllerRpcNoRet(self.insId,"MainRenTableWarehouseCtrl", '_setsFunc',stream)
end
--自动补货
function BuidingWareHouseModel:n_OnSetAutoReplenish(data)
    local aaa = data
    local bbb = ""
end