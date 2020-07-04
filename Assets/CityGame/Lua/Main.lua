require('Common.define')
require('LuaUtil')
local CityLuaUtil = CityLuaUtil
require("Dbg")
require('ImpTestGroup')
local protoc = require ("Framework/pbl/protoc")

function OnInitProto()
	ct.log("abel_w7_pkg","[OnInitProto] protoc:addpath")
	ct.log("abel_w7_pkg","[OnInitProto] persistentDataPath: ",UnityEngine.Application.persistentDataPath)
--protoc:addpath("./Assets/CityGame/Lua/pb") --Note that this relative path starting from Assets is the only relative path on the PC currently found that can support loadfile
--protoc:addpath(UnityEngine.Application.persistentDataPath.."/CityGame/lua/pb") --This path is the path that can be accessed on Android
protoc:addpath(CityLuaUtil.getAssetsPath().."/Lua/pb") --Note that this relative path starting from Assets is the only relative path found on the PC that currently supports loadfile
protoc:addpath(CityLuaUtil.getAssetsPath().."/lua/pb") -- this path is the path that can be accessed on Android

	ct.log("abel_w7_pkg","[OnInitProto] protoc:loadfile")
	--加载并编译所有的 .proto 文件
	assert(protoc:loadfile( "common.proto"))
	assert(protoc:loadfile ("as.proto"))
	assert(protoc:loadfile ("asCode.proto"))
	--assert(protoc:loadfile ("ga.proto"))
	--assert(protoc:loadfile ("gaCode.proto"))
	assert(protoc:loadfile ("gs.proto"))
	assert(protoc:loadfile ("gsCode.proto"))
	assert(protoc:loadfile ("metadata.proto"))
	assert(protoc:loadfile ("client.proto"))
	assert(protoc:loadfile ("ss.proto"))
	assert(protoc:loadfile ("sscode.proto"))
	assert(protoc:loadfile ("global_def.proto"))
	assert(protoc:loadfile ("cc.proto"))
	assert(protoc:loadfile ("city.proto"))
	assert(protoc:loadfile ("dddbind.proto"))
end

-- The main entry function. Start lua logic from here
function Main()
	OnInitProto()	--load .proto
	--testMain()		--Test entrance
end

--Scene switching notification
function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end