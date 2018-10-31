---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 11:23
---
-----

HouseModel = {};
local this = HouseModel;
local pbl = pbl

--构建函数--
function HouseModel.New()
    return this;
end

function HouseModel.Awake()
    UpdateBeat:Add(this.Update, this);
    this:OnCreate();
end

function HouseModel.Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.Z) then
        HouseCtrl.OpenPanel({})
        --ct.log("cycle_w5","[test_houseModel_openPanel]  测试完毕")
    end

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.X) then
        local occValue = {renter = 30, totalCount = 80}
        Event.Brocast("c_onOccupancyValueChange", occValue);
    end
end

--启动事件--
function HouseModel.OnCreate()
    --网络回调注册
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","queryGroundAuction"), GroundAuctionModel.n_OnReceiveQueryGroundAuctionInfo);

    --本地的回调注册
    --Event.AddListener("m_PlayerBidGround", this.m_BidGround);
end

--关闭事件--
function HouseModel.Close()
    --Event.RemoveListener("m_PlayerBidGround", this.m_BidGround);
end

--- 客户端请求 ---
--请求即将拍卖的土地信息
function HouseModel.m_ReqQueryGroundAuction()
    local msgId = pbl.enum("gscode.OpCode","queryGroundAuction")
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil);
end

--出价
function HouseModel.m_BidGround(id, price)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","bidGround")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { id = id, num = price}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.IdNum", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

--- 回调 ---

--收到拍卖中的土地信息
function HouseModel.n_OnReceiveQueryGroundAuctionInfo(stream)
    local msgGroundAuc = assert(pbl.decode("gs.GroundAuction", stream), "GroundAuctionModel.n_OnReceiveQueryGroundAuctionInfo: stream == nil")
    if #msgGroundAuc.auction == 0 then
        return
    end

end


--TestGroup.active_TestGroup("cycle_w5")
UnitTest.TestBlockStart()---------------------------------------------------------
UnitTest.Exec("cycle_w5", "test_loginctrl_tempTest",  function ()
    local HouseModel = CtrlManager.GetModel(ModelNames.House);
    if HouseModel ~= nil then
        HouseModel:Awake();
    end
    ct.log("cycle_w5","[test_loginctrl_tempTest]  测试完毕")
end)
UnitTest.TestBlockEnd()-----------------------------------------------------------
