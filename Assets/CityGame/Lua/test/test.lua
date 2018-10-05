---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/21 11:05
---

if not CityGlobal.G_UNITTEST then return {} end
TestGroup.active_TestGroup("abel_w7_LineChart")
--TestGroup.active_TestGroup("abel_w6_UIFrame")
--TestGroup.active_TestGroup("abel_w6_UIFrame_performance")

package.path = package.path .. ';./Assets/CityGame/Lua/test/?.lua'
package.path = package.path .. ';./Assets/CityGame/Lua/test/pbl/?.lua'
test = {}
require "LuaUtil"

UnitTest = require ('test/testFrameWork/UnitTest')

--require('test/performance/run')
require ("pbl_test")
require ("test/test_BaseOO")
require ("test/test_Mixins")
require("test/performance/luaPerformance")
require('test/performance/classPerformance')
require("examination")
require("metatable")
require('test/test_UIFrameWrok')
require('test/LineChart/testLineChart')

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
