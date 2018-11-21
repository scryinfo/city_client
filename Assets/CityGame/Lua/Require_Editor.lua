---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/10/20 16:28
---
local coroutine = require("coroutine")
require('__require_first__') --前置包含
local AutoRequire = require "AutoRequire"

--自动包含目录
AutoRequire.getInstance():require("Common")
AutoRequire.getInstance():require("Framework/Interface")
AutoRequire.getInstance():require("Framework/pbl")
AutoRequire.getInstance():require("Framework/UI")
AutoRequire.getInstance():require("test/testFrameWork/memory")
AutoRequire.getInstance():require("test/testFrameWork")


if CityLuaUtil.isluaLogEnable() == false then --如果 lua log 禁用， 那么禁用整个测试分组策略

    function UnitTest.Exec_now(unitGroupId, event,...) return end
    function UnitTest.Exec(unitGroupId, funcName, func) return end
    ct.log = function(logid,s,...) return end

    AutoRequire.getInstance():addCode("function UnitTest.Exec_now(unitGroupId, event,...) return end")
    AutoRequire.getInstance():addCode("function UnitTest.Exec(unitGroupId, funcName, func) return end")
    AutoRequire.getInstance():addCode("ct.log = function(logid,s,...) return end")
else
    --单元测试
    AutoRequire.getInstance():require("test/testFrameWork")
    AutoRequire.getInstance():require("test/testFrameWork/memory")
    AutoRequire.getInstance():require("test/group")
    AutoRequire.getInstance():require("test/pbl")
    AutoRequire.getInstance():require("test/performance")
    AutoRequire.getInstance():require("test/performanceOpt1")
    --AutoRequire.getInstance():require("test/testCoroutine")
    AutoRequire.getInstance():require("test")
    AutoRequire.getInstance():require("test/testMain")
end
AutoRequire.getInstance():require("Logic/ExchangeAbout")
AutoRequire.getInstance():require("Logic/GameBubble")
AutoRequire.getInstance():require("Logic/PieChart")
AutoRequire.getInstance():require("Logic/ToggleSort")
AutoRequire.getInstance():require("Logic")
AutoRequire.getInstance():require("View")
AutoRequire.getInstance():require("View/BuildingInfo")
AutoRequire.getInstance():require("View/Logic")
AutoRequire.getInstance():require("Controller")
AutoRequire.getInstance():require("Model")
AutoRequire.getInstance():require("Config")
AutoRequire.getInstance():require("Items")
AutoRequire.getInstance():require("Items/LaboratoryItems")
AutoRequire.getInstance():require("Terrain")
AutoRequire.getInstance():requireLast("__require_last__")
--在磁盘上上述目录中如果新添了文件夹，需要把新文件夹添加到上述 “自动包含目录”中

function PostRequire()
    require('__require_last__') --后置包含
    AutoRequire.getInstance():FinishedRequire()
end

--打包时，把 AutoRequire.requirePaths 写到 Require_RunTime.lua
function Genfun()
    print("generate_RequireRT---------------------------------")
    AutoRequire.getInstance():WriteRuntimeRequire()
    PostRequire()
end
--if UnityEngine.Application.isEditor then
--    coroutine.start(Genfun)
--end

