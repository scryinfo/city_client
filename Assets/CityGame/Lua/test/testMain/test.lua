---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/21 11:05
---
UnitTest.TestBlockStart()---------------------------------------------------------
if not ct.G_UNITTEST then return {} end
local uTime = UnityEngine.Time
local gettime = tolua.gettime
package.path = package.path .. ';./Assets/CityGame/Lua/test/?.lua'
package.path = package.path .. ';./Assets/CityGame/Lua/test/pbl/?.lua'
test = {}
require "LuaUtil"
require "Logic/CtrlManager"
require ("test/pbl/pbl_test")
require ("test/test_BaseOO")
require ("test/test_Mixins")
require("test/performance/luaPerformance")
require('test/performance/classPerformance')
require("test/examination")
require("test/metatable")
require('Controller/LineChartCtrl')

local pbl = pbl
local buffer = pbl_buffer
local serpent = require("Framework/pbl/serpent")
local protoc = require "Framework/pbl/protoc"
protoc:addpath("./Assets/CityGame/Lua/pb")

UnitTest.Exec("abel_w4", "test_pb11111",  function ()
    ct.log("abel_w4","[test_pb11111]  balabalabalabala...............")
end)

UnitTest.Exec("abel_wk27_hartbeat", "abel_wk27_hartbeat",  function ()
    Event.AddListener("e_HartBeatStart", function (serinofs)
        DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","heartBeat","gs.HeartBeat",function()
            ct.G_LAST_HARTBEAT = uTime.time
        end)
        --每x秒检查一次上次心跳是否超时，超时
        ct.G_LAST_HARTBEAT = uTime.time
        local timer0 = FrameTimer.New(function()
            local timetest = uTime.time - ct.G_LAST_HARTBEAT
            if timetest > ct.G_TIMEOUT_NET then
                --提示网络连接不稳定
                ct.MsgBox("网络连接", "网络连接不稳定")
            end
        end, 1, 1)
        timer0:Start()
        --目前GS才有心跳协议，AS没有
        local timerSendHartBeat = FrameTimer.New(function()
            --HeartBeat
            local msgId = pbl.enum("gscode.OpCode","heartBeat")
            ----2、 填充 protobuf 内部协议数据
            local lMsg = { ts = TimeSynchronized.GetTheCurrentServerTime()}
            ----3、 序列化成二进制数据
            local  pMsg = assert(pbl.encode("gs.HeartBeat", lMsg))
            CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
        end, 3, 1)
        timerSendHartBeat:Start()
    end)
end)

UnitTest.Exec("abel_w27_processNetMsgError", "processNetMsgError",  function ()
    ct.log("abel_w27_processNetMsgError","[processNetMsgError]  balabalabalabala...............")

    --定义网络回调
    local netCallBack = function(protoData,msgid)
        if msgid == 0 then --如果 msgid 为 0 ，说明是错误码，需要处理
            --替換為多語言
            local contentInfo = "错误码:" ..protoData.opcode..'     原因: '..protoData.reason..'     '..protoData.s
            ct.MsgBox("警告", contentInfo, "")
        else    --如果 msgid 不为零， 那么就是正常的网络回调
            --ct.MsgBox("提示", " abel_w27_processNetMsgError 测试 ")
        end
    end

    --注册网络回调和错误处理
    local msgId = pbl.enum("ascode.OpCode","login")
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","login","as.Login",netCallBack,nil)--新版model网络注册
    --CityEngineLua.Message:registerNetMsg(msgId,netCallBack,netErrorHandler)
    ----2、 发送错误的数据
    local msglogion = {
        account = '' --发一个空字符，应该会报错
    }
    --连接并登陆
    CityEngineLua.username = '0'    --非法账号
    --CityEngineLua.username = '1'  --合法账号
    CityEngineLua.password = ''
    CityEngineLua._clientdatas = nil
    CityEngineLua.ip = '192.168.0.192'
    CityEngineLua.login_loginapp(true);
end)

UnitTest.Exec("abel_w3", "test_pb",  function ()
    ----1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","login")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { account = "11"}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("as.Login", lMsg))

    ----反序列化，取出数据
    local msg = assert(pbl.decode("as.Login",pMsg), "pbl.decode decode failed")

    ct.log("abel_w3","[test_pb] login.account: "..msg.account)
end)

UnitTest.Exec("abel_w18_pb_save_load", "abel_w18_pb_save_load",  function ()
    ----1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","login")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { account = "11"}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("as.Login", lMsg))
    --CityLuaUtil.getAssetsPath().."/Lua/pb"
    --保存
    local path = CityLuaUtil.getAssetsPath().."/Lua/pb/mas.data"
    ct.file_saveString(path,pMsg)
    --读取
    local str = ct.file_readString(path)
    ----反序列化，取出数据
    local msg = assert(pbl.decode("as.Login", str), "pbl.decode decode failed")

    ct.log("abel_w18_pb_save_load","[abel_w18_pb_save_load] login.account: "..msg.account)
end)

--[[
message Phone {
	optional string name        = 1;
	optional int64  phonenumber = 2;
}
message Person {
	 optional string name     = 1;
	 optional int32  age      = 2;
	 optional string address  = 3;
	 repeated Phone  contacts = 4;
}
]]--

UnitTest.Exec("abel_w10_pbl_nest", "test_pb_nest",  function ()
    local lMsg = {
        name = "11",
        age = 12,
        address = '123.321.222.333',
        contacts={
            name = 'hello',
            phonenumber = 123123
        }
    }

    local  pMsg = assert(pbl.encode("as.Person", lMsg))

    ----反序列化，取出数据
    local msg = assert(pbl.decode("as.Person",pMsg), "pbl.decode decode failed")

    ct.log("abel_w10_pbl_nest","[test_pb_nest] success")
end)

UnitTest.Exec("abel_w3", "check_load",function()
    local pbdata = protoc.new():compile(chunk, name)
    local ret, offset = pb.load(pbdata)
    if not ret then
        error("load error at "..offset..
                "\nproto: "..chunk..
                "\ndata: "..buffer(pbdata):tohex())
    end
end)

UnitTest.Exec("abel_w3", "test_pbl_load",function()
    local Login = { -- 我们定义一个addressbook里的 Person 消息
        account = "Alice"
    }

    -- 序列化成二进制数据
    local data = assert(pb.encode("as.Login", Login))

    -- 从二进制数据解析出实际消息
    local msg = { -- 我们定义一个addressbook里的 Person 消息

    }
    msg = assert(pb.decode("as.Login", data))

    -- 打印消息内容（使用了serpent开源库）
    --print(serpent.block(msg))

    check_load [[
      package ascode;
      enum Color {
         Red = 0;
         Green = 1;
         Blue = 2;
      }
      message TestEnum {
         optional Color color  = 1;
      } ]]
    local test =  pb.enum("ascode.Color", "Red")

    local val = pb.enum("ascode.OpCode", "login")
end)

UnitTest.Exec("abel_w3", "test_pbl_encode_decode",function()
    assert(protoc:load [[
    message Phone {
      optional string name        = 1;
      optional int64  phonenumber = 2;
    }
    message Person {
      optional string name     = 1;
      optional int32  age      = 2;
      optional string address  = 3;
      repeated Phone  contacts = 4;
    } ]])

    local data = {
        name = "ilse",
        age  = 18,
        contacts = {
            { name = "alice", phonenumber = 12312341234 },
            { name = "bob",   phonenumber = 45645674567 }
        }
    }

    local bytes = assert(pb.encode("Person", data))
    print(pbl.tohex(bytes))

    local data2 = assert(pb.decode("Person", bytes))
    print(require "Framework/pbl/serpent".block(data2))
end)

UnitTest.Exec("abel_w3", "test_log",function()
    ct.log("abl_w5", "[test] [test_log]  abl_w5 ")
    ct.log("abl_w4", "[test] [test_log]  abl_w4 ")
    TestGroup.active_TestGroup("abel_w6_common")
    ct.log("abel_w6_common", "[test] [test_log]  开始打印分组测试")
    ct.log("abel_w6_common", "[test] [test_log]  在没有激活 abel_w6 分组的情况下，使用 abel_w6 打印.......")
    ct.log("abel_w6", "[test] [test_log]  abel_w6 ")
    ct.log("abel_w6_common", "[test] [test_log]  在激活 abel_w6 allen_w6 分组的情况下，使用 abel_w6 allen_w6 打印.......")
    TestGroup.active_TestGroup("abel_w6") --激活log分组
    TestGroup.active_TestGroup("allen_w6") --激活log分组
    ct.log("abel_w6", "[test] [test_log]  abel_w6 ")
    ct.log("allen_w6", "[test] [test_log]  allen_w6 ")
    ct.log("abel_w6_common", "[test] [test_log]  在移除 abel_w6 分组的情况下，使用 abel_w6 打印.......")
    TestGroup.remove_TestGroupId("abel_w6") --移除log分组
    ct.log("abel_w6", "[test] [test_log]  abel_w6 ")
    ct.log("allen_w6", "[test] [test_log]  allen_w6 ")
    ct.log("abel_w6_common", "[test] [test_log]  在移除 allen_w6 分组的情况下，使用 allen_w6 打印.......")
    TestGroup.remove_TestGroupId("allen_w6") --移除log分组
    ct.log("abel_w6", "[test] [test_log]  abel_w6 ")
    ct.log("allen_w6", "[test] [test_log]  allen_w6 ")
    TestGroup.remove_TestGroupId("abel_w6_common") --移除log分组
end)

UnitTest.Exec("cycle_w6_houseAndGround", "test_w6_house",  function ()
    local info = {}
    UIPage:ShowPage(HouseCtrl, info)

    ct.log("cycle_w6_houseAndGround","[cycle_w6_houseAndGround]  balabalabalabala...............")
end)

UnitTest.Exec("cycle_w6_GroundAuc", "test_w6_groundAuc",  function ()
    --local info = {}
    --info.titleInfo = "CONGRATULATION";
    --info.contentInfo = "Success!!!!";
    --info.tipInfo = "lalalalalalalalla";
    --info.btnCallBack = function ()
    --    ct.log("cycle_w6_GroundAuc","[cycle_w6_GroundAuc] 回调啊回调")
    --end;
    --UIPage:ShowPage(BtnDialogPageCtrl, info)

    --ct.log("cycle_w6_GroundAuc","[cycle_w6_GroundAuc]  balabalabalabala...............")

    ---测试拍卖
    --local groundAucModel = CtrlManager.GetModel(ModelNames.GroundAuction);
    --if groundAucModel ~= nil then
    --    groundAucModel:Awake();
    --end
end)

UnitTest.Exec("cycle_w8_exchange01_loopScroll", "test_cycle_w8_exchange01_loopScroll",  function ()
    UIPage:ShowPage(TestExchangeCtrl)
    ct.log("cycle_w8_exchange01_loopScroll","[cycle_w8_exchange01_loopScroll] ...............")
end)

UnitTest.Exec("cycle_w9_exchange01", "test_cycle_w9_exchange01",  function ()
    UIPage:ShowPage(ExchangeCtrl)

    ct.log("cycle_w9_exchange01","[cycle_w9_exchange01] ...............")
end)

--遍历是顺序的，只不过调试时显示是乱序的
UnitTest.Exec("abel_w9_tableOrder", "test_table_order",  function ()
    local tb = {}
    for i = 1, 100 do
        tb[#tb+1] = 'tb_'..tostring(i)
        ct.log("abel_w9_tableOrder", "[test_table_order]  添加table的顺序: ",tb[i])
    end
    for i = 1, 100 do
        ct.log("abel_w9_tableOrder", "[test_table_order]  访问table的顺序: ",tb[i])
    end
end)

UnitTest.Exec("abel_w9_AddComponent_MonoBehaviour", "test_abel_w9_AddComponent_MonoBehaviour",  function ()
    ct.log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour] ...............")

    require('Framework/UI/UIRoot')
    local UIRoot = UIRoot
    if UIRoot.Instance() == nil then
        ct.log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  UIRoot.Instance() == nil ")
        return
    end
    local path = 'View/TopbarPanel'
    --加载 prefab 资源
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        ct.log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
    end
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local transform = go.transform
    local rect = go.transform:GetComponent("RectTransform");

    if transform == nil then
        ct.log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
        return
    end

    if prefab == nil then
        ct.log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
        return
    end

    --绑定脚本,使用 LuaHelper.GetType
    UnityEngine.GameObject.AddComponent(go, ct.getType(LuaFramework.LuaBehaviour))
    local topBarBehaviour = go:GetComponent('LuaBehaviour')
    if topBarBehaviour == nil then
        ct.log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
        return
    end

    --显示相关[
    local anchorPos = rect.anchoredPosition
    local sizeDel= rect.sizeDelta
    local scale = rect.localScale

    go.transform:SetParent(UIRoot.getFixedRoot())

    rect.anchoredPosition = anchorPos
    rect.sizeDelta = sizeDel
    rect.localScale = scale
    --显示相关]

    --使用绑定的脚本，注册按钮回调[
    local btn_notice = transform:Find("btn_notice").gameObject;
    local btn_back = transform:Find("btn_back").gameObject;

    topBarBehaviour:AddClick(btn_notice, function()
        local aaa = 0
    end, go);
    topBarBehaviour:AddClick(btn_back, function()
        local aaa = 0
    end, go);
    --使用绑定的脚本，注册按钮回调]

end)

UnitTest.Exec("abel_w9_AddLuaComponent", "test_abel_w9_AddLuaComponent",  function ()
    ct.log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent] ...............")

    require('Framework/UI/UIRoot')
    local UIRoot = UIRoot
    if UIRoot.Instance() == nil then
        ct.log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  UIRoot.Instance() == nil ")
        return
    end
    local path = 'View/TopbarPanel'
    --加载 prefab 资源
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        ct.log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  not find resource: "..path)
    end
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local transform = go.transform
    local rect = go.transform:GetComponent("RectTransform");

    if transform == nil then
        ct.log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  not find resource: "..path)
        return
    end

    if prefab == nil then
        ct.log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  not find resource: "..path)
        return
    end

    --显示相关[
    local anchorPos = rect.anchoredPosition
    local sizeDel= rect.sizeDelta
    local scale = rect.localScale

    go.transform:SetParent(UIRoot.getFixedRoot())

    rect.anchoredPosition = anchorPos
    rect.sizeDelta = sizeDel
    rect.localScale = scale
    --显示相关]

    --绑定lua脚本,传入lua相对路径, 具体测试见 test_luaComponent
    local luaCom = CityLuaUtil.AddLuaComponent(go,'View/Logic/test_luaComponent')
end)

UnitTest.Exec("cycle_w11_exchangeModel", "test_cycle_w11_exchangeModel",  function ()
    local exchangeModel = CtrlManager.GetModel(ModelNames.Exchange);
    if exchangeModel ~= nil then
        exchangeModel:Awake()
    end
end)

UnitTest.Exec("cycle_w12_hosueServer", "test_cycle_w12_hosueServer",  function ()
    local HouseModel = CtrlManager.GetModel(ModelNames.House);
    if HouseModel ~= nil then
        HouseModel:Awake()
    end
end)

UnitTest.Exec("abel_w18_fmod_modf", "abel_w18_fmod_modf",  function ()
    local x = math.fmod( 7, 5 )
    local y,z = math.modf( 7 / 5 )
    local xx = x
end)

UnitTest.Exec("abel_w11_uuid", "test_w11_uuid",  function ()
    local pstr ='8a20a7b8c1644a59b79e030c81603ed9'

    ct.log("abel_w11_uuid","uuid() = ", pstr1)

    local check_load = function(chunk, name)
        local pbdata = protoc.new():compile(chunk, name)
        local ret, offset = pbl.load(pbdata)
        if not ret then
            error("load error at "..offset..
                    "\nproto: "..chunk..
                    "\ndata: "..buffer(pbdata):tohex())
        end
    end

    check_load [[
    package gs;
    message TestUUID {
    required bytes id = 1;
    required string name = 2;
    } ]]
    local lMsg = { id = pstr , name = "hohoh"}
    local  pMsg = assert(pbl.encode("gs.TestUUID", lMsg))
    local msg = assert(pbl.decode("gs.TestUUID",pMsg), "pbl.decode gs.TestUUID failed")
    ct.log("abel_w11_uuid","[test_w11_uuid] msg: "..msg)
end)

UnitTest.Exec("abel_w11_UUID_FromeServer", "test_UUID_FromeServer",  function ()
    ct.log("abel_w11_UUID_FromeServer","[test_UUID_FromeServer]  测试开始")
    Event.AddListener("t_UUID_FromeServer", function (serinofs)
        for i = 1, #serinofs do
            --服务器发过来的bytes测试
            if serinofs[i].briefInfo ~= nil then
                local id = serinofs[i].briefInfo[1].id
                local pstr1 = CityLuaUtil.ByteArrayToString(id)
                local pbyte1 = CityLuaUtil.StringToByteArray(pstr1)
                local pstr2 = CityLuaUtil.ByteArrayToString(pbyte1)
                local ttt= 0
            end
            --服务器发过来的bytes测试
        end
    end)
end)


UnitTest.Exec("abel_w4_proto_Role", "test_w4_proto_Role",  function ()
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","roleLogin")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = {
        id = "111231",
        name = "haha",
        lockedMoney = 123123,
        offlineTs = 123123,
        position = {x = 100,y = 2},
        buys ={
            apartment = {
                info ={
                    id = "123",
                    mId = 123,
                    pos = {
                        x = 123,
                        y = 212,
                    },
                    ownerId = "asdfas",
                    npcFlow = 12312,
                    state = 1,
                    constructCompleteTs = 1,
                    salary = 123,
                    happy = 12312,
                },
                rent = 11,
                renter = 1,
                chart = { num = 1}
            },
            materialFactory = {

            },
            produceDepartment ={

            },
            publicFacility={

            },
        },

        rents ={
            apartment = {
                info ={
                    id = "123",
                    mId = 123,
                    pos = {
                        x = 123,
                        y = 212,
                    },
                    ownerId = "asdfas",
                    npcFlow = 12312,
                    state = 1,
                    constructCompleteTs = 1,
                    salary = 123,
                    happy = 12312,
                },
                rent = 11,
                renter = 1,
                chart = { num = 1}
            },
            materialFactory = {

            },
            produceDepartment ={

            },
            publicFacility={

            },
        },
        bag = {
            inHand = {
                id = "123",
                num = 123,
            },
            reserved={
                id = "123",
                num = 123,
            },
            locked = {
                id = "123",
                num = 123,
            },
        },
        bagCapacity = 12312,
        itemIdCanProduce = {12312,33212},
        exchangeCollectedItem = {12312,123},
        ground = {
            {
                ownerId = "asdf",
                 x = 123,
                 y = 2332,
                 rent = {
                     rentPreDay = 1,
                     paymentCycleDays = 1,
                     deposit = 3,
                     rentDays = 4,
                     renterId = "asdfs",
                     rentBeginTs = 123123,
                 },
                 sell = {
                     price = 1
                 },
            },
        },
    }
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.Role", lMsg))

    ----反序列化，取出数据
    local msg = assert(pbl.decode("gs.Role",pMsg), "pbl.decode gs.Role failed")

    ct.log("abel_w4_proto_Role","[test_w4_proto_Role] msg: "..msg)
end)

UnitTest.Exec("cycle_w13_laboratory", "test_cycle_w13_laboratory",  function ()
    --local HouseModel = CtrlManager.GetModel(ModelNames.House);
    --if HouseModel ~= nil then
    --    HouseModel:Awake()
    --end
    --ct.OpenCtrl("LaboratoryCtrl", {})
    --ct.OpenCtrl("LabResearchCtrl", {})
end)

UnitTest.Exec("cycle_w15_laboratory03", "test_cycle_w15_laboratory03",  function ()
    --ct.OpenCtrl("LaboratoryCtrl", {})
end)

UnitTest.Exec("wk16_abel_ceil", "test_wk16_abel_ceil",  function ()
    local v1 = math.ceil(2)
    local v2 = math.ceil(1.7)
    local v3 = math.ceil(1.5)
    local v4 = math.ceil(1)
    local v5 = math.ceil(0.7)
    local v6 = math.ceil(0.5)
    local v7 = math.ceil(0)
    local v8 = math.ceil(-0.3)
    local v9 = math.ceil(-0.7)
    local v10 = math.ceil(-1)
    local v11 = math.ceil(-1.3)
    local v12 = math.ceil(-1.7)

    local t1 = ct.getIntPart(2)
    local t2 = ct.getIntPart(1.7)
    local t3 = ct.getIntPart(0.7)
    local t4 = ct.getIntPart(0)
    local t5 = ct.getIntPart(-0.7)
    local t6 = ct.getIntPart(-1.7)
    local t7 = ct.getIntPart(-2)

    local t8 = 8
end)

UnitTest.Exec("cycle_w19_groundTrans", "test_cycle_w19_groundTrans",  function ()
    local groundTransModel = CtrlManager.GetModel(ModelNames.GroundTrans)
    if groundTransModel ~= nil then
        --groundTransModel:Awake()
    end
end)

UnitTest.Exec("cycle_w22_pieTest", "test_cycle_w22_pieTest",  function ()
    --local pie = PieChart.New()
    --pie.CreatePie()
end)

--UnitTest.Exec_now("wk24_abel_mutiConnect", "c_wk24_abel_mutiConnect",self)
--UnitTest.Exec_now("wk24_abel_mutiConnect_revMsg", "c_wk24_abel_mutiConnect_revMsg",self)
UnitTest.Exec("wk24_abel_mutiConnect", "wk24_abel_mutiConnect",  function ()
    ct.log("wk24_abel_mutiConnect","[c_wk24_abel_mutiConnect]  测试开始")
    Event.AddListener("c_wk24_abel_mutiConnect", function (obj) --在测试用例中注册消息 c_AddClick_self
        --192.168.0.149:20001
        CityEngineLua.tradeappIP = "192.168.0.149";
        CityEngineLua.tradeappPort = "20001"
        CityEngineLua.login_tradeapp(true)
    end)
end)

UnitTest.Exec("wk24_abel_mutiConnect_revMsg", "wk24_abel_mutiConnect_revMsg",  function ()
    ct.log("wk24_abel_mutiConnect_revMsg","[c_wk24_abel_mutiConnect_revMsg]  测试开始")
    Event.AddListener("c_wk24_abel_mutiConnect_revMsg", function (obj) --在测试用例中注册消息 c_AddClick_self
        CityEngineLua.Message:registerNetMsg(pbl.enum("sscode.OpCode","queryPlayerEconomy"), function ()
            local test = 0
        end)
        CityEngineLua._tradeNetworkInterface1.testId = 2
        local pid ='8a20a7b8c1644a59b79e030c81603ed9'
        ----1、 获取协议id
        local msgId = pbl.enum("sscode.OpCode","queryPlayerEconomy")
        ----2、 填充 protobuf 内部协议数据
        local lMsg = { id = pid}
        local pMsg = assert(pbl.encode("ss.Id", lMsg))
        ----3、 创建包，填入数据并发包
        CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, CityEngineLua._tradeNetworkInterface1);
    end)
end)


UnitTest.TestBlockEnd()-----------------------------------------------------------
