---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/2 15:22
---中心仓库
local pbl = pbl
local log = log

CenterWareHouseModel= {};
local this = CenterWareHouseModel;

--构建函数--
function CenterWareHouseModel.New()
    logDebug("CenterWareHouseModel.New--->>");
    return this;
end

function CenterWareHouseModel.Awake()
    logDebug("CenterWareHouseModel.Awake--->>");
    this:OnCreate();
end

--启动事件--
function CenterWareHouseModel.OnCreate()
    --注册本地UI事件
    Event.AddListener("m_extendBag", this.m_ExtendBag,this);
    Event.AddListener("m_bagCapacity",this.m_bagCapacity,this)
    Event.AddListener("m_opCenterWareHouse",this.m_opCenterWareHouse,this)
    Event.AddListener("m_DeleteItem",this.m_DeleteItem,this)
    --as网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","extendBag"),CenterWareHouseModel.n_GsExtendBag);
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","delItem"),CenterWareHouseModel.n_GsDelItem);
end

function CenterWareHouseModel:m_bagCapacity(bagCapacity)
   this.bagCapacity = bagCapacity

end

function CenterWareHouseModel:m_opCenterWareHouse()
    ct.OpenCtrl("CenterWareHouseCtrl",this.bagCapacity)
end
--仓库扩容发包
function CenterWareHouseModel:m_ExtendBag()
    local msgId = pbl.enum("gscode.OpCode","extendBag")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil);
end

function CenterWareHouseModel:n_GsExtendBag(stream)
    Event.Brocast("c_GsExtendBag")
end

function CenterWareHouseModel:n_GsDelItem(stream)
    local pMsg =assert(pbl.decode("gs.DelItem",stream),"LoginModel.n_OnRoleLogin : pbl.decode failed")

    ct.log("rodger_w8_GameMainInterface","[test_n_GsDelItem]  测试完毕",pMsg)
end

--删除商品发包
function CenterWareHouseModel:m_DeleteItem(go)
    local bagId = "a33eab42cb754c77bd27710d299f5591";
    local bId = CityLuaUtil.stringToBytes(bagId)
    ct.log("rodger_w8_GameMainInterface","[test_n_GsDel]  测试完毕",bId)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","delItem")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId = bId, itemId = go.id }
    local pMsg = assert(pbl.encode("gs.DelItem", lMsg))
    ----3、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end
