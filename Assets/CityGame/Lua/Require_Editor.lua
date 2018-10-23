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
AutoRequire.getInstance():require("test/testFrameWork")
AutoRequire.getInstance():require("test/testFrameWork/memory")
AutoRequire.getInstance():require("Logic/ExchangeAbout")
AutoRequire.getInstance():require("Logic/GameBubble")
AutoRequire.getInstance():require("Logic/PieChart")
AutoRequire.getInstance():require("Logic")
AutoRequire.getInstance():require("View")
AutoRequire.getInstance():require("View/BuildingInfo")
AutoRequire.getInstance():require("View/Logic")
AutoRequire.getInstance():require("Controller")
AutoRequire.getInstance():require("Model")
AutoRequire.getInstance():requireLast("__require_last__")
--在磁盘上上述目录中如果新添了文件夹，需要把新文件夹添加到上述 “自动包含目录”中

function PostRequire()
    --单元测试
    AutoRequire.getInstance():require("test/testMain")
    AutoRequire.getInstance():require("test")
    --性能测试
    require('test/performance/luaPerformance')
    require('__require_last__') --后置包含
    AutoRequire.getInstance():FinishedRequire()
end

--最后把 AutoRequire.requirePaths 写到 Require_RunTime.lua
function Genfun()
    AutoRequire.getInstance():WriteRuntimeRequire()
    PostRequire()
end
coroutine.start(Genfun)

