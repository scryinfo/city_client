---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/21 11:05
---

if not CityGlobal.G_UNITTEST then return {} end
TestGroup.active_TestGroup("abel_w9_autoRequire")

--TestGroup.active_TestGroup("abel_w10_OpenCtrl")
--TestGroup.active_TestGroup("abel_w9_memory_usage")
--TestGroup.active_TestGroup("abel_w9_memory_usage")
--TestGroup.active_TestGroup("abel_w9_tableOrder")
--TestGroup.active_TestGroup("fisher_w8_RemoveClick") --激活测试组
--TestGroup.active_TestGroup("abel_w7_LineChart")
--TestGroup.active_TestGroup("abel_w6_UIFrame_1")
--TestGroup.active_TestGroup("cycle_w6_houseAndGround")  --住宅
--TestGroup.active_TestGroup("cycle_w8_exchange01_loopScroll")  --交易所滑动复用
--TestGroup.active_TestGroup("cycle_w9_exchange01")  --交易所界面
TestGroup.active_TestGroup("cycle_w10_exchange02")  --交易所界面
--TestGroup.active_TestGroup("test_cycle_w11_exchangeModel")  --交易所model

--TestGroup.active_TestGroup("cycle_w6_GroundAuc")  --拍卖
--TestGroup.active_TestGroup("abel_w7_LineChart")
--TestGroup.active_TestGroup("abel_w6_UIFrame")
--TestGroup.active_TestGroup("abel_w4_class_performance")
--TestGroup.active_TestGroup("abel_w7_LineChart")
--TestGroup.active_TestGroup("abel_w9_AddLuaComponent")
--TestGroup.active_TestGroup("abel_w9_AddComponent_MonoBehaviour")
--TestGroup.active_TestGroup("abel_w6_performance")
--TestGroup.active_TestGroup("abel_w6_UIFrame_performance")
--TestGroup.active_TestGroup("rodger_w8_GameMainInterface")
--TestGroup.active_TestGroup("fisher_w8_RemoveClick") --激活测试组

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
local serpent = require("Framework/pbl/serpent")
local protoc = require "Framework/pbl/protoc"
protoc:addpath("./Assets/CityGame/Lua/pb")

UnitTest.Exec("abel_w4", "test_pb11111",  function ()
    log("abel_w4","[test_pb11111]  balabalabalabala...............")
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

    log("abel_w3","[test_pb] login.account: "..msg.account)
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
    log("abl_w5", "[test] [test_log]  abl_w5 ")
    log("abl_w4", "[test] [test_log]  abl_w4 ")
    TestGroup.active_TestGroup("abel_w6_common")
    log("abel_w6_common", "[test] [test_log]  开始打印分组测试")
    log("abel_w6_common", "[test] [test_log]  在没有激活 abel_w6 分组的情况下，使用 abel_w6 打印.......")
    log("abel_w6", "[test] [test_log]  abel_w6 ")
    log("abel_w6_common", "[test] [test_log]  在激活 abel_w6 allen_w6 分组的情况下，使用 abel_w6 allen_w6 打印.......")
    TestGroup.active_TestGroup("abel_w6") --激活log分组
    TestGroup.active_TestGroup("allen_w6") --激活log分组
    log("abel_w6", "[test] [test_log]  abel_w6 ")
    log("allen_w6", "[test] [test_log]  allen_w6 ")
    log("abel_w6_common", "[test] [test_log]  在移除 abel_w6 分组的情况下，使用 abel_w6 打印.......")
    TestGroup.remove_TestGroupId("abel_w6") --移除log分组
    log("abel_w6", "[test] [test_log]  abel_w6 ")
    log("allen_w6", "[test] [test_log]  allen_w6 ")
    log("abel_w6_common", "[test] [test_log]  在移除 allen_w6 分组的情况下，使用 allen_w6 打印.......")
    TestGroup.remove_TestGroupId("allen_w6") --移除log分组
    log("abel_w6", "[test] [test_log]  abel_w6 ")
    log("allen_w6", "[test] [test_log]  allen_w6 ")
    TestGroup.remove_TestGroupId("abel_w6_common") --移除log分组
end)

UnitTest.Exec("cycle_w6_houseAndGround", "test_w6_house",  function ()
    local info = {}
    UIPage:ShowPage(HouseCtrl, info)

    log("cycle_w6_houseAndGround","[cycle_w6_houseAndGround]  balabalabalabala...............")
end)

UnitTest.Exec("cycle_w6_GroundAuc", "test_w6_groundAuc",  function ()
    --local info = {}
    --info.titleInfo = "CONGRATULATION";
    --info.contentInfo = "Success!!!!";
    --info.tipInfo = "lalalalalalalalla";
    --info.btnCallBack = function ()
    --    log("cycle_w6_GroundAuc","[cycle_w6_GroundAuc] 回调啊回调")
    --end;
    --UIPage:ShowPage(BtnDialogPageCtrl, info)

    log("cycle_w6_GroundAuc","[cycle_w6_GroundAuc]  balabalabalabala...............")

    ---测试拍卖
    local groundAucModel = CtrlManager.GetModel(ModelNames.GroundAuction);
    if groundAucModel ~= nil then
        groundAucModel:Awake();
    end
end)

UnitTest.Exec("cycle_w8_exchange01_loopScroll", "test_cycle_w8_exchange01_loopScroll",  function ()
    UIPage:ShowPage(TestExchangeCtrl)
    log("cycle_w8_exchange01_loopScroll","[cycle_w8_exchange01_loopScroll] ...............")
end)

UnitTest.Exec("cycle_w9_exchange01", "test_cycle_w9_exchange01",  function ()
    UIPage:ShowPage(ExchangeCtrl)

    log("cycle_w9_exchange01","[cycle_w9_exchange01] ...............")
end)

--遍历是顺序的，只不过调试时显示是乱序的
UnitTest.Exec("abel_w9_tableOrder", "test_table_order",  function ()
    local tb = {}
    for i = 1, 100 do
        tb[#tb+1] = 'tb_'..tostring(i)
        log("abel_w9_tableOrder", "[test_table_order]  添加table的顺序: ",tb[i])
    end
    for i = 1, 100 do
        log("abel_w9_tableOrder", "[test_table_order]  访问table的顺序: ",tb[i])
    end
end)

UnitTest.Exec("abel_w9_AddComponent_MonoBehaviour", "test_abel_w9_AddComponent_MonoBehaviour",  function ()
    log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour] ...............")

    require('Framework/UI/UIRoot')
    local UIRoot = UIRoot
    if UIRoot.Instance() == nil then
        log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  UIRoot.Instance() == nil ")
        return
    end
    local path = 'View/TopbarPanel'
    --加载 prefab 资源
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
    end
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local transform = go.transform
    local rect = go.transform:GetComponent("RectTransform");

    if transform == nil then
        log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
        return
    end

    if prefab == nil then
        log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
        return
    end

    --绑定脚本,使用 LuaHelper.GetType
    UnityEngine.GameObject.AddComponent(go, LuaHelper.GetType("LuaFramework.LuaBehaviour"))
    local topBarBehaviour = go:GetComponent('LuaBehaviour')
    if topBarBehaviour == nil then
        log("abel_w9_AddComponent_MonoBehaviour","[abel_w9_AddComponent_MonoBehaviour]  not find resource: "..path)
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
    log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent] ...............")

    require('Framework/UI/UIRoot')
    local UIRoot = UIRoot
    if UIRoot.Instance() == nil then
        log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  UIRoot.Instance() == nil ")
        return
    end
    local path = 'View/TopbarPanel'
    --加载 prefab 资源
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  not find resource: "..path)
    end
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local transform = go.transform
    local rect = go.transform:GetComponent("RectTransform");

    if transform == nil then
        log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  not find resource: "..path)
        return
    end

    if prefab == nil then
        log("abel_w9_AddLuaComponent","[test_abel_w9_AddLuaComponent]  not find resource: "..path)
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

UnitTest.Exec("cycle_w10_exchange02", "test_cycle_w10_exchange02",  function ()
    CityGlobal.OpenCtrl("ExchangeCtrl")
end)
UnitTest.Exec("cycle_w11_exchangeModel", "test_cycle_w11_exchangeModel",  function ()
    local exchangeModel = CtrlManager.GetModel(ModelNames.Exchange);
    if exchangeModel ~= nil then
        exchangeModel:Awake();
    end
end)